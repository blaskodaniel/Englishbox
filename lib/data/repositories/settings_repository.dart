import '../db.dart';

class SettingsRepository {
  SettingsRepository(this._db);

  final AppDatabase _db;

  Stream<Settings> watch() => _db.select(_db.appSettings).watchSingle();

  Future<Settings> get() => _db.select(_db.appSettings).getSingle();

  /// Csak a megadott mezőket írja felül, pl.
  /// `update(AppSettingsCompanion(dailyGoal: Value(10)))`.
  Future<void> update(AppSettingsCompanion changes) async {
    await (_db.update(_db.appSettings)..where((s) => s.id.equals(1))).write(changes);
  }
}
