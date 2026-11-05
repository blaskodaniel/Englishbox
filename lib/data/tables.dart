import 'package:drift/drift.dart';

import '../domain/enums.dart';
import 'converters.dart';

/// Minden elem: szó, kifejezés, nyelvtani szabály, mondat.
class Items extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get type => textEnum<ItemType>()();

  /// Szó, kifejezés, szabály neve vagy maga a mondat.
  TextColumn get english => text().withLength(min: 1)();

  /// Magyar jelentés / fordítás.
  TextColumn get hungarian => text().withDefault(const Constant(''))();

  /// Hosszabb magyarázat (kifejezés jelentése, szabály leírása).
  TextColumn get notes => text().nullable()();

  TextColumn get partOfSpeech => textEnum<PartOfSpeech>().nullable()();
  TextColumn get phraseKind => textEnum<PhraseKind>().nullable()();
  TextColumn get ipa => text().nullable()();
  TextColumn get level => textEnum<CefrLevel>().nullable()();

  /// Honnan származik, pl. „lesson”, „work call”.
  TextColumn get source => text().nullable()();

  /// Szabálycsoport, pl. „Conditionals”.
  TextColumn get ruleCategory => text().nullable()();
  TextColumn get formula =>
      text().map(const FormulaConverter()).withDefault(const Constant('[]'))();

  /// „Magyar csapda” megjegyzés szabályokhoz.
  TextColumn get trapNote => text().nullable()();

  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();

  /// „To check” – megjelölve, mert utána kell nézni (pl. ismétlés közben).
  BoolColumn get needsCheck => boolean().withDefault(const Constant(false))();

  /// Mi a kérdés vele – opcionális megjegyzés a jelöléshez.
  TextColumn get checkNote => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

/// Kapcsolat két elem között: példamondat, kapcsolt nyelvtan, hasonló elem.
class ItemLinks extends Table {
  @ReferenceName('outgoingLinks')
  IntColumn get parentId => integer().references(Items, #id, onDelete: KeyAction.cascade)();
  @ReferenceName('incomingLinks')
  IntColumn get childId => integer().references(Items, #id, onDelete: KeyAction.cascade)();
  TextColumn get role => textEnum<LinkRole>()();
  IntColumn get position => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {parentId, childId, role};
}

/// Hibás példák nyelvtani szabályokhoz – ezek nem kerülnek ismétlésbe.
class RuleMistakes extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get ruleId => integer().references(Items, #id, onDelete: KeyAction.cascade)();
  TextColumn get wrong => text()();
  TextColumn get explanation => text().nullable()();
  IntColumn get position => integer().withDefault(const Constant(0))();
}

class Tags extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Kisbetűs, `#` nélkül: „work”, „feelings”.
  TextColumn get name => text().unique()();
}

class ItemTags extends Table {
  IntColumn get itemId => integer().references(Items, #id, onDelete: KeyAction.cascade)();
  IntColumn get tagId => integer().references(Tags, #id, onDelete: KeyAction.cascade)();

  @override
  Set<Column> get primaryKey => {itemId, tagId};
}

/// Gyűjtemények, pl. „Lesson notes”, „Work English”.
class Collections extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();

  /// Ikon kulcsa, pl. „book”, „briefcase”, „film”.
  TextColumn get icon => text().withDefault(const Constant('book'))();

  /// ARGB szín, pl. 0xFFB49CFF.
  IntColumn get color => integer().withDefault(const Constant(0xFFB49CFF))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class CollectionItems extends Table {
  IntColumn get collectionId =>
      integer().references(Collections, #id, onDelete: KeyAction.cascade)();
  IntColumn get itemId => integer().references(Items, #id, onDelete: KeyAction.cascade)();

  @override
  Set<Column> get primaryKey => {collectionId, itemId};
}

/// Elemenként az ismétlés ütemezése (SM-2 jellegű).
class ReviewStates extends Table {
  IntColumn get itemId => integer().references(Items, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get dueAt => dateTime()();
  RealColumn get ease => real().withDefault(const Constant(2.5))();
  IntColumn get intervalDays => integer().withDefault(const Constant(0))();

  /// Egymás utáni sikeres ismétlések száma.
  IntColumn get repetitions => integer().withDefault(const Constant(0))();

  /// Hányszor felejtette el.
  IntColumn get lapses => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastReviewedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {itemId};
}

/// Minden egyes ismétlési válasz – statisztikához, napi feladatokhoz.
class ReviewLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get itemId => integer().references(Items, #id, onDelete: KeyAction.cascade)();
  TextColumn get task => textEnum<ReviewTask>()();
  BoolColumn get correct => boolean()();
  DateTimeColumn get reviewedAt => dateTime().withDefault(currentDateAndTime)();
}

/// XP-napló: az összes XP, a szint és a streak ebből számolódik.
class XpEvents extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get amount => integer()();
  TextColumn get reason => textEnum<XpReason>()();
  IntColumn get itemId =>
      integer().nullable().references(Items, #id, onDelete: KeyAction.setNull)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// Felvett napi küldetésjutalmak – naponta küldetésenként legfeljebb egy.
class QuestClaims extends Table {
  /// „2026-11-04” (helyi idő szerint).
  TextColumn get day => text()();
  TextColumn get quest => textEnum<Quest>()();
  DateTimeColumn get claimedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {day, quest};
}

/// Beállítások – mindig pontosan egy sor (id = 1).
@DataClassName('Settings')
class AppSettings extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  TextColumn get username => text().withDefault(const Constant(''))();
  TextColumn get levelNow => textEnum<CefrLevel>().withDefault(const Constant('b1'))();
  TextColumn get levelGoal => textEnum<CefrLevel>().withDefault(const Constant('c1'))();

  /// Napi cél: új elemek száma.
  IntColumn get dailyGoal => integer().withDefault(const Constant(5))();

  /// Egy ismétlési kör hossza (elem).
  IntColumn get sessionLength => integer().withDefault(const Constant(10))();
  TextColumn get answerMode => textEnum<AnswerMode>().withDefault(const Constant('mix'))();

  /// Mely típusok jönnek szókártyaként, vesszővel elválasztva („word,phrase,rule”).
  TextColumn get cardTypes => text().withDefault(const Constant('word,phrase,rule'))();
  BoolColumn get gameMode => boolean().withDefault(const Constant(true))();
  BoolColumn get streakFreeze => boolean().withDefault(const Constant(true))();
  BoolColumn get reminderEnabled => boolean().withDefault(const Constant(true))();

  /// Emlékeztető ideje percben éjféltől (19:30 = 1170).
  IntColumn get reminderMinutes => integer().withDefault(const Constant(19 * 60 + 30))();
  TextColumn get accent => textEnum<Accent>().withDefault(const Constant('british'))();
  TextColumn get speechSpeed => textEnum<SpeechSpeed>().withDefault(const Constant('normal'))();
  DateTimeColumn get lastBackupAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
