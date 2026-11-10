import 'dart:convert';

import 'package:drift/drift.dart';

import 'db.dart';

/// Hibás vagy nem Englishbox mentésfájl.
class BackupFormatException implements Exception {
  const BackupFormatException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Mentés és visszaállítás JSON-ba / JSON-ból.
///
/// A táblákat „nyersen” mentjük (`SELECT *`), pontosan úgy, ahogy az SQLite-ban
/// vannak – így a fájl a séma minden részletét megőrzi, és visszatöltéskor
/// nem kell semmit átalakítani.
class BackupService {
  BackupService(this._db);

  final AppDatabase _db;

  static const format = 'englishbox-backup';

  /// A teljes adatbázis JSON szövegként.
  Future<String> exportJson() async {
    final tables = <String, List<Map<String, Object?>>>{};
    for (final table in _db.allTables) {
      final rows = await _db.customSelect('SELECT * FROM "${table.actualTableName}"').get();
      tables[table.actualTableName] = [for (final row in rows) row.data];
    }
    return const JsonEncoder.withIndent(' ').convert({
      'format': format,
      'schemaVersion': _db.schemaVersion,
      'exportedAt': DateTime.now().toUtc().toIso8601String(),
      'tables': tables,
    });
  }

  /// Hány elem van a mentésben – a megerősítő párbeszédablakhoz.
  /// Ha a fájl nem Englishbox mentés, [BackupFormatException]-t dob.
  int countItems(String json) => (_parse(json)['items'] ?? const []).length;

  /// Lecseréli a teljes adatbázist a mentés tartalmára, egy tranzakcióban:
  /// ha bármi hibás, semmi sem változik.
  Future<void> importJson(String json) async {
    final tables = _parse(json);
    await _db.transaction(() async {
      // Törlés fordított sorrendben (előbb a hivatkozók, aztán a hivatkozottak).
      for (final table in _db.allTables.toList().reversed) {
        await _db.delete(table).go();
      }
      // Beszúrás a deklarált sorrendben (előbb az elemek, aztán a kapcsolataik).
      for (final table in _db.allTables) {
        final rows = tables[table.actualTableName];
        if (rows == null) continue; // régebbi mentésben még nem létező tábla
        final known = {for (final c in table.$columns) c.name};
        for (final row in rows) {
          final columns = row.keys.where(known.contains).toList();
          if (columns.isEmpty) continue;
          await _db.customInsert(
            'INSERT INTO "${table.actualTableName}" '
            '(${columns.map((c) => '"$c"').join(', ')}) '
            'VALUES (${List.filled(columns.length, '?').join(', ')})',
            variables: [for (final c in columns) Variable(row[c])],
            updates: {table},
          );
        }
      }
      // Kézzel bővített mentésben hiányozhat az elemek ismétlési állapota.
      await _db.ensureReviewStates();
      // A beállítások sora mindig legyen meg.
      final settings = await _db.select(_db.appSettings).get();
      if (settings.isEmpty) {
        await _db.into(_db.appSettings).insert(AppSettingsCompanion.insert());
      }
    });
  }

  /// Ellenőrzi a fájlt, és visszaadja a táblák sorait.
  Map<String, List<Map<String, Object?>>> _parse(String json) {
    final Object? decoded;
    try {
      decoded = jsonDecode(json);
    } on FormatException {
      throw const BackupFormatException('This file is not a valid backup.');
    }
    if (decoded is! Map || decoded['format'] != format || decoded['tables'] is! Map) {
      throw const BackupFormatException('This is not an Englishbox backup file.');
    }
    final version = decoded['schemaVersion'];
    if (version is int && version > _db.schemaVersion) {
      throw const BackupFormatException(
        'This backup was made with a newer version of Englishbox. Update the app first.',
      );
    }
    return {
      for (final MapEntry(:key, :value) in (decoded['tables'] as Map).entries)
        if (value is List)
          key as String: [
            for (final row in value)
              if (row is Map) row.cast<String, Object?>(),
          ],
    };
  }
}
