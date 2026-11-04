import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../domain/enums.dart';
import '../domain/formula.dart';
import 'converters.dart';
import 'tables.dart';

export 'tables.dart';

part 'db.g.dart';

@DriftDatabase(
  tables: [
    Items,
    ItemLinks,
    RuleMistakes,
    Tags,
    ItemTags,
    Collections,
    CollectionItems,
    ReviewStates,
    ReviewLogs,
    XpEvents,
    AppSettings,
  ],
)
class AppDatabase extends _$AppDatabase {
  /// Alapból a telefonon lévő `englishbox.sqlite` fájlt nyitja meg;
  /// tesztekben memóriabeli adatbázist adunk át.
  AppDatabase([QueryExecutor? executor])
      : super(executor ?? driftDatabase(name: 'englishbox'));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          // A beállítások egyetlen sora, alapértékekkel.
          await into(appSettings).insert(AppSettingsCompanion.insert());
        },
        beforeOpen: (details) async {
          // SQLite-ban a külső kulcsokat külön be kell kapcsolni.
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );
}
