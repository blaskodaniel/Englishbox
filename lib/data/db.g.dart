// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db.dart';

// ignore_for_file: type=lint
class $ItemsTable extends Items with TableInfo<$ItemsTable, Item> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<ItemType, String> type =
      GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<ItemType>($ItemsTable.$convertertype);
  static const VerificationMeta _englishMeta = const VerificationMeta(
    'english',
  );
  @override
  late final GeneratedColumn<String> english = GeneratedColumn<String>(
    'english',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(minTextLength: 1),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hungarianMeta = const VerificationMeta(
    'hungarian',
  );
  @override
  late final GeneratedColumn<String> hungarian = GeneratedColumn<String>(
    'hungarian',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<PartOfSpeech?, String>
  partOfSpeech = GeneratedColumn<String>(
    'part_of_speech',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  ).withConverter<PartOfSpeech?>($ItemsTable.$converterpartOfSpeechn);
  @override
  late final GeneratedColumnWithTypeConverter<PhraseKind?, String> phraseKind =
      GeneratedColumn<String>(
        'phrase_kind',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<PhraseKind?>($ItemsTable.$converterphraseKindn);
  static const VerificationMeta _ipaMeta = const VerificationMeta('ipa');
  @override
  late final GeneratedColumn<String> ipa = GeneratedColumn<String>(
    'ipa',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<CefrLevel?, String> level =
      GeneratedColumn<String>(
        'level',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<CefrLevel?>($ItemsTable.$converterleveln);
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ruleCategoryMeta = const VerificationMeta(
    'ruleCategory',
  );
  @override
  late final GeneratedColumn<String> ruleCategory = GeneratedColumn<String>(
    'rule_category',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<FormulaBlock>, String>
  formula = GeneratedColumn<String>(
    'formula',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  ).withConverter<List<FormulaBlock>>($ItemsTable.$converterformula);
  static const VerificationMeta _trapNoteMeta = const VerificationMeta(
    'trapNote',
  );
  @override
  late final GeneratedColumn<String> trapNote = GeneratedColumn<String>(
    'trap_note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isFavoriteMeta = const VerificationMeta(
    'isFavorite',
  );
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
    'is_favorite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_favorite" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    type,
    english,
    hungarian,
    notes,
    partOfSpeech,
    phraseKind,
    ipa,
    level,
    source,
    ruleCategory,
    formula,
    trapNote,
    isFavorite,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'items';
  @override
  VerificationContext validateIntegrity(
    Insertable<Item> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('english')) {
      context.handle(
        _englishMeta,
        english.isAcceptableOrUnknown(data['english']!, _englishMeta),
      );
    } else if (isInserting) {
      context.missing(_englishMeta);
    }
    if (data.containsKey('hungarian')) {
      context.handle(
        _hungarianMeta,
        hungarian.isAcceptableOrUnknown(data['hungarian']!, _hungarianMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('ipa')) {
      context.handle(
        _ipaMeta,
        ipa.isAcceptableOrUnknown(data['ipa']!, _ipaMeta),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    if (data.containsKey('rule_category')) {
      context.handle(
        _ruleCategoryMeta,
        ruleCategory.isAcceptableOrUnknown(
          data['rule_category']!,
          _ruleCategoryMeta,
        ),
      );
    }
    if (data.containsKey('trap_note')) {
      context.handle(
        _trapNoteMeta,
        trapNote.isAcceptableOrUnknown(data['trap_note']!, _trapNoteMeta),
      );
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
        _isFavoriteMeta,
        isFavorite.isAcceptableOrUnknown(data['is_favorite']!, _isFavoriteMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Item map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Item(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      type: $ItemsTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      english: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}english'],
      )!,
      hungarian: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hungarian'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      partOfSpeech: $ItemsTable.$converterpartOfSpeechn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}part_of_speech'],
        ),
      ),
      phraseKind: $ItemsTable.$converterphraseKindn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}phrase_kind'],
        ),
      ),
      ipa: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ipa'],
      ),
      level: $ItemsTable.$converterleveln.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}level'],
        ),
      ),
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      ),
      ruleCategory: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rule_category'],
      ),
      formula: $ItemsTable.$converterformula.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}formula'],
        )!,
      ),
      trapNote: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}trap_note'],
      ),
      isFavorite: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_favorite'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ItemsTable createAlias(String alias) {
    return $ItemsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ItemType, String, String> $convertertype =
      const EnumNameConverter<ItemType>(ItemType.values);
  static JsonTypeConverter2<PartOfSpeech, String, String>
  $converterpartOfSpeech = const EnumNameConverter<PartOfSpeech>(
    PartOfSpeech.values,
  );
  static JsonTypeConverter2<PartOfSpeech?, String?, String?>
  $converterpartOfSpeechn = JsonTypeConverter2.asNullable(
    $converterpartOfSpeech,
  );
  static JsonTypeConverter2<PhraseKind, String, String> $converterphraseKind =
      const EnumNameConverter<PhraseKind>(PhraseKind.values);
  static JsonTypeConverter2<PhraseKind?, String?, String?>
  $converterphraseKindn = JsonTypeConverter2.asNullable($converterphraseKind);
  static JsonTypeConverter2<CefrLevel, String, String> $converterlevel =
      const EnumNameConverter<CefrLevel>(CefrLevel.values);
  static JsonTypeConverter2<CefrLevel?, String?, String?> $converterleveln =
      JsonTypeConverter2.asNullable($converterlevel);
  static TypeConverter<List<FormulaBlock>, String> $converterformula =
      const FormulaConverter();
}

class Item extends DataClass implements Insertable<Item> {
  final int id;
  final ItemType type;

  /// Szó, kifejezés, szabály neve vagy maga a mondat.
  final String english;

  /// Magyar jelentés / fordítás.
  final String hungarian;

  /// Hosszabb magyarázat (kifejezés jelentése, szabály leírása).
  final String? notes;
  final PartOfSpeech? partOfSpeech;
  final PhraseKind? phraseKind;
  final String? ipa;
  final CefrLevel? level;

  /// Honnan származik, pl. „lesson”, „work call”.
  final String? source;

  /// Szabálycsoport, pl. „Conditionals”.
  final String? ruleCategory;
  final List<FormulaBlock> formula;

  /// „Magyar csapda” megjegyzés szabályokhoz.
  final String? trapNote;
  final bool isFavorite;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Item({
    required this.id,
    required this.type,
    required this.english,
    required this.hungarian,
    this.notes,
    this.partOfSpeech,
    this.phraseKind,
    this.ipa,
    this.level,
    this.source,
    this.ruleCategory,
    required this.formula,
    this.trapNote,
    required this.isFavorite,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['type'] = Variable<String>($ItemsTable.$convertertype.toSql(type));
    }
    map['english'] = Variable<String>(english);
    map['hungarian'] = Variable<String>(hungarian);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || partOfSpeech != null) {
      map['part_of_speech'] = Variable<String>(
        $ItemsTable.$converterpartOfSpeechn.toSql(partOfSpeech),
      );
    }
    if (!nullToAbsent || phraseKind != null) {
      map['phrase_kind'] = Variable<String>(
        $ItemsTable.$converterphraseKindn.toSql(phraseKind),
      );
    }
    if (!nullToAbsent || ipa != null) {
      map['ipa'] = Variable<String>(ipa);
    }
    if (!nullToAbsent || level != null) {
      map['level'] = Variable<String>(
        $ItemsTable.$converterleveln.toSql(level),
      );
    }
    if (!nullToAbsent || source != null) {
      map['source'] = Variable<String>(source);
    }
    if (!nullToAbsent || ruleCategory != null) {
      map['rule_category'] = Variable<String>(ruleCategory);
    }
    {
      map['formula'] = Variable<String>(
        $ItemsTable.$converterformula.toSql(formula),
      );
    }
    if (!nullToAbsent || trapNote != null) {
      map['trap_note'] = Variable<String>(trapNote);
    }
    map['is_favorite'] = Variable<bool>(isFavorite);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ItemsCompanion toCompanion(bool nullToAbsent) {
    return ItemsCompanion(
      id: Value(id),
      type: Value(type),
      english: Value(english),
      hungarian: Value(hungarian),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      partOfSpeech: partOfSpeech == null && nullToAbsent
          ? const Value.absent()
          : Value(partOfSpeech),
      phraseKind: phraseKind == null && nullToAbsent
          ? const Value.absent()
          : Value(phraseKind),
      ipa: ipa == null && nullToAbsent ? const Value.absent() : Value(ipa),
      level: level == null && nullToAbsent
          ? const Value.absent()
          : Value(level),
      source: source == null && nullToAbsent
          ? const Value.absent()
          : Value(source),
      ruleCategory: ruleCategory == null && nullToAbsent
          ? const Value.absent()
          : Value(ruleCategory),
      formula: Value(formula),
      trapNote: trapNote == null && nullToAbsent
          ? const Value.absent()
          : Value(trapNote),
      isFavorite: Value(isFavorite),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Item.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Item(
      id: serializer.fromJson<int>(json['id']),
      type: $ItemsTable.$convertertype.fromJson(
        serializer.fromJson<String>(json['type']),
      ),
      english: serializer.fromJson<String>(json['english']),
      hungarian: serializer.fromJson<String>(json['hungarian']),
      notes: serializer.fromJson<String?>(json['notes']),
      partOfSpeech: $ItemsTable.$converterpartOfSpeechn.fromJson(
        serializer.fromJson<String?>(json['partOfSpeech']),
      ),
      phraseKind: $ItemsTable.$converterphraseKindn.fromJson(
        serializer.fromJson<String?>(json['phraseKind']),
      ),
      ipa: serializer.fromJson<String?>(json['ipa']),
      level: $ItemsTable.$converterleveln.fromJson(
        serializer.fromJson<String?>(json['level']),
      ),
      source: serializer.fromJson<String?>(json['source']),
      ruleCategory: serializer.fromJson<String?>(json['ruleCategory']),
      formula: serializer.fromJson<List<FormulaBlock>>(json['formula']),
      trapNote: serializer.fromJson<String?>(json['trapNote']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'type': serializer.toJson<String>(
        $ItemsTable.$convertertype.toJson(type),
      ),
      'english': serializer.toJson<String>(english),
      'hungarian': serializer.toJson<String>(hungarian),
      'notes': serializer.toJson<String?>(notes),
      'partOfSpeech': serializer.toJson<String?>(
        $ItemsTable.$converterpartOfSpeechn.toJson(partOfSpeech),
      ),
      'phraseKind': serializer.toJson<String?>(
        $ItemsTable.$converterphraseKindn.toJson(phraseKind),
      ),
      'ipa': serializer.toJson<String?>(ipa),
      'level': serializer.toJson<String?>(
        $ItemsTable.$converterleveln.toJson(level),
      ),
      'source': serializer.toJson<String?>(source),
      'ruleCategory': serializer.toJson<String?>(ruleCategory),
      'formula': serializer.toJson<List<FormulaBlock>>(formula),
      'trapNote': serializer.toJson<String?>(trapNote),
      'isFavorite': serializer.toJson<bool>(isFavorite),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Item copyWith({
    int? id,
    ItemType? type,
    String? english,
    String? hungarian,
    Value<String?> notes = const Value.absent(),
    Value<PartOfSpeech?> partOfSpeech = const Value.absent(),
    Value<PhraseKind?> phraseKind = const Value.absent(),
    Value<String?> ipa = const Value.absent(),
    Value<CefrLevel?> level = const Value.absent(),
    Value<String?> source = const Value.absent(),
    Value<String?> ruleCategory = const Value.absent(),
    List<FormulaBlock>? formula,
    Value<String?> trapNote = const Value.absent(),
    bool? isFavorite,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Item(
    id: id ?? this.id,
    type: type ?? this.type,
    english: english ?? this.english,
    hungarian: hungarian ?? this.hungarian,
    notes: notes.present ? notes.value : this.notes,
    partOfSpeech: partOfSpeech.present ? partOfSpeech.value : this.partOfSpeech,
    phraseKind: phraseKind.present ? phraseKind.value : this.phraseKind,
    ipa: ipa.present ? ipa.value : this.ipa,
    level: level.present ? level.value : this.level,
    source: source.present ? source.value : this.source,
    ruleCategory: ruleCategory.present ? ruleCategory.value : this.ruleCategory,
    formula: formula ?? this.formula,
    trapNote: trapNote.present ? trapNote.value : this.trapNote,
    isFavorite: isFavorite ?? this.isFavorite,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Item copyWithCompanion(ItemsCompanion data) {
    return Item(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      english: data.english.present ? data.english.value : this.english,
      hungarian: data.hungarian.present ? data.hungarian.value : this.hungarian,
      notes: data.notes.present ? data.notes.value : this.notes,
      partOfSpeech: data.partOfSpeech.present
          ? data.partOfSpeech.value
          : this.partOfSpeech,
      phraseKind: data.phraseKind.present
          ? data.phraseKind.value
          : this.phraseKind,
      ipa: data.ipa.present ? data.ipa.value : this.ipa,
      level: data.level.present ? data.level.value : this.level,
      source: data.source.present ? data.source.value : this.source,
      ruleCategory: data.ruleCategory.present
          ? data.ruleCategory.value
          : this.ruleCategory,
      formula: data.formula.present ? data.formula.value : this.formula,
      trapNote: data.trapNote.present ? data.trapNote.value : this.trapNote,
      isFavorite: data.isFavorite.present
          ? data.isFavorite.value
          : this.isFavorite,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Item(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('english: $english, ')
          ..write('hungarian: $hungarian, ')
          ..write('notes: $notes, ')
          ..write('partOfSpeech: $partOfSpeech, ')
          ..write('phraseKind: $phraseKind, ')
          ..write('ipa: $ipa, ')
          ..write('level: $level, ')
          ..write('source: $source, ')
          ..write('ruleCategory: $ruleCategory, ')
          ..write('formula: $formula, ')
          ..write('trapNote: $trapNote, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    type,
    english,
    hungarian,
    notes,
    partOfSpeech,
    phraseKind,
    ipa,
    level,
    source,
    ruleCategory,
    formula,
    trapNote,
    isFavorite,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Item &&
          other.id == this.id &&
          other.type == this.type &&
          other.english == this.english &&
          other.hungarian == this.hungarian &&
          other.notes == this.notes &&
          other.partOfSpeech == this.partOfSpeech &&
          other.phraseKind == this.phraseKind &&
          other.ipa == this.ipa &&
          other.level == this.level &&
          other.source == this.source &&
          other.ruleCategory == this.ruleCategory &&
          other.formula == this.formula &&
          other.trapNote == this.trapNote &&
          other.isFavorite == this.isFavorite &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ItemsCompanion extends UpdateCompanion<Item> {
  final Value<int> id;
  final Value<ItemType> type;
  final Value<String> english;
  final Value<String> hungarian;
  final Value<String?> notes;
  final Value<PartOfSpeech?> partOfSpeech;
  final Value<PhraseKind?> phraseKind;
  final Value<String?> ipa;
  final Value<CefrLevel?> level;
  final Value<String?> source;
  final Value<String?> ruleCategory;
  final Value<List<FormulaBlock>> formula;
  final Value<String?> trapNote;
  final Value<bool> isFavorite;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const ItemsCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.english = const Value.absent(),
    this.hungarian = const Value.absent(),
    this.notes = const Value.absent(),
    this.partOfSpeech = const Value.absent(),
    this.phraseKind = const Value.absent(),
    this.ipa = const Value.absent(),
    this.level = const Value.absent(),
    this.source = const Value.absent(),
    this.ruleCategory = const Value.absent(),
    this.formula = const Value.absent(),
    this.trapNote = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ItemsCompanion.insert({
    this.id = const Value.absent(),
    required ItemType type,
    required String english,
    this.hungarian = const Value.absent(),
    this.notes = const Value.absent(),
    this.partOfSpeech = const Value.absent(),
    this.phraseKind = const Value.absent(),
    this.ipa = const Value.absent(),
    this.level = const Value.absent(),
    this.source = const Value.absent(),
    this.ruleCategory = const Value.absent(),
    this.formula = const Value.absent(),
    this.trapNote = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : type = Value(type),
       english = Value(english);
  static Insertable<Item> custom({
    Expression<int>? id,
    Expression<String>? type,
    Expression<String>? english,
    Expression<String>? hungarian,
    Expression<String>? notes,
    Expression<String>? partOfSpeech,
    Expression<String>? phraseKind,
    Expression<String>? ipa,
    Expression<String>? level,
    Expression<String>? source,
    Expression<String>? ruleCategory,
    Expression<String>? formula,
    Expression<String>? trapNote,
    Expression<bool>? isFavorite,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (english != null) 'english': english,
      if (hungarian != null) 'hungarian': hungarian,
      if (notes != null) 'notes': notes,
      if (partOfSpeech != null) 'part_of_speech': partOfSpeech,
      if (phraseKind != null) 'phrase_kind': phraseKind,
      if (ipa != null) 'ipa': ipa,
      if (level != null) 'level': level,
      if (source != null) 'source': source,
      if (ruleCategory != null) 'rule_category': ruleCategory,
      if (formula != null) 'formula': formula,
      if (trapNote != null) 'trap_note': trapNote,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ItemsCompanion copyWith({
    Value<int>? id,
    Value<ItemType>? type,
    Value<String>? english,
    Value<String>? hungarian,
    Value<String?>? notes,
    Value<PartOfSpeech?>? partOfSpeech,
    Value<PhraseKind?>? phraseKind,
    Value<String?>? ipa,
    Value<CefrLevel?>? level,
    Value<String?>? source,
    Value<String?>? ruleCategory,
    Value<List<FormulaBlock>>? formula,
    Value<String?>? trapNote,
    Value<bool>? isFavorite,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return ItemsCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      english: english ?? this.english,
      hungarian: hungarian ?? this.hungarian,
      notes: notes ?? this.notes,
      partOfSpeech: partOfSpeech ?? this.partOfSpeech,
      phraseKind: phraseKind ?? this.phraseKind,
      ipa: ipa ?? this.ipa,
      level: level ?? this.level,
      source: source ?? this.source,
      ruleCategory: ruleCategory ?? this.ruleCategory,
      formula: formula ?? this.formula,
      trapNote: trapNote ?? this.trapNote,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
        $ItemsTable.$convertertype.toSql(type.value),
      );
    }
    if (english.present) {
      map['english'] = Variable<String>(english.value);
    }
    if (hungarian.present) {
      map['hungarian'] = Variable<String>(hungarian.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (partOfSpeech.present) {
      map['part_of_speech'] = Variable<String>(
        $ItemsTable.$converterpartOfSpeechn.toSql(partOfSpeech.value),
      );
    }
    if (phraseKind.present) {
      map['phrase_kind'] = Variable<String>(
        $ItemsTable.$converterphraseKindn.toSql(phraseKind.value),
      );
    }
    if (ipa.present) {
      map['ipa'] = Variable<String>(ipa.value);
    }
    if (level.present) {
      map['level'] = Variable<String>(
        $ItemsTable.$converterleveln.toSql(level.value),
      );
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (ruleCategory.present) {
      map['rule_category'] = Variable<String>(ruleCategory.value);
    }
    if (formula.present) {
      map['formula'] = Variable<String>(
        $ItemsTable.$converterformula.toSql(formula.value),
      );
    }
    if (trapNote.present) {
      map['trap_note'] = Variable<String>(trapNote.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ItemsCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('english: $english, ')
          ..write('hungarian: $hungarian, ')
          ..write('notes: $notes, ')
          ..write('partOfSpeech: $partOfSpeech, ')
          ..write('phraseKind: $phraseKind, ')
          ..write('ipa: $ipa, ')
          ..write('level: $level, ')
          ..write('source: $source, ')
          ..write('ruleCategory: $ruleCategory, ')
          ..write('formula: $formula, ')
          ..write('trapNote: $trapNote, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ItemLinksTable extends ItemLinks
    with TableInfo<$ItemLinksTable, ItemLink> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ItemLinksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _parentIdMeta = const VerificationMeta(
    'parentId',
  );
  @override
  late final GeneratedColumn<int> parentId = GeneratedColumn<int>(
    'parent_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES items (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _childIdMeta = const VerificationMeta(
    'childId',
  );
  @override
  late final GeneratedColumn<int> childId = GeneratedColumn<int>(
    'child_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES items (id) ON DELETE CASCADE',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<LinkRole, String> role =
      GeneratedColumn<String>(
        'role',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<LinkRole>($ItemLinksTable.$converterrole);
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [parentId, childId, role, position];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'item_links';
  @override
  VerificationContext validateIntegrity(
    Insertable<ItemLink> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('parent_id')) {
      context.handle(
        _parentIdMeta,
        parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_parentIdMeta);
    }
    if (data.containsKey('child_id')) {
      context.handle(
        _childIdMeta,
        childId.isAcceptableOrUnknown(data['child_id']!, _childIdMeta),
      );
    } else if (isInserting) {
      context.missing(_childIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {parentId, childId, role};
  @override
  ItemLink map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ItemLink(
      parentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}parent_id'],
      )!,
      childId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}child_id'],
      )!,
      role: $ItemLinksTable.$converterrole.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}role'],
        )!,
      ),
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
    );
  }

  @override
  $ItemLinksTable createAlias(String alias) {
    return $ItemLinksTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<LinkRole, String, String> $converterrole =
      const EnumNameConverter<LinkRole>(LinkRole.values);
}

class ItemLink extends DataClass implements Insertable<ItemLink> {
  final int parentId;
  final int childId;
  final LinkRole role;
  final int position;
  const ItemLink({
    required this.parentId,
    required this.childId,
    required this.role,
    required this.position,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['parent_id'] = Variable<int>(parentId);
    map['child_id'] = Variable<int>(childId);
    {
      map['role'] = Variable<String>(
        $ItemLinksTable.$converterrole.toSql(role),
      );
    }
    map['position'] = Variable<int>(position);
    return map;
  }

  ItemLinksCompanion toCompanion(bool nullToAbsent) {
    return ItemLinksCompanion(
      parentId: Value(parentId),
      childId: Value(childId),
      role: Value(role),
      position: Value(position),
    );
  }

  factory ItemLink.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ItemLink(
      parentId: serializer.fromJson<int>(json['parentId']),
      childId: serializer.fromJson<int>(json['childId']),
      role: $ItemLinksTable.$converterrole.fromJson(
        serializer.fromJson<String>(json['role']),
      ),
      position: serializer.fromJson<int>(json['position']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'parentId': serializer.toJson<int>(parentId),
      'childId': serializer.toJson<int>(childId),
      'role': serializer.toJson<String>(
        $ItemLinksTable.$converterrole.toJson(role),
      ),
      'position': serializer.toJson<int>(position),
    };
  }

  ItemLink copyWith({
    int? parentId,
    int? childId,
    LinkRole? role,
    int? position,
  }) => ItemLink(
    parentId: parentId ?? this.parentId,
    childId: childId ?? this.childId,
    role: role ?? this.role,
    position: position ?? this.position,
  );
  ItemLink copyWithCompanion(ItemLinksCompanion data) {
    return ItemLink(
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      childId: data.childId.present ? data.childId.value : this.childId,
      role: data.role.present ? data.role.value : this.role,
      position: data.position.present ? data.position.value : this.position,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ItemLink(')
          ..write('parentId: $parentId, ')
          ..write('childId: $childId, ')
          ..write('role: $role, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(parentId, childId, role, position);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ItemLink &&
          other.parentId == this.parentId &&
          other.childId == this.childId &&
          other.role == this.role &&
          other.position == this.position);
}

class ItemLinksCompanion extends UpdateCompanion<ItemLink> {
  final Value<int> parentId;
  final Value<int> childId;
  final Value<LinkRole> role;
  final Value<int> position;
  final Value<int> rowid;
  const ItemLinksCompanion({
    this.parentId = const Value.absent(),
    this.childId = const Value.absent(),
    this.role = const Value.absent(),
    this.position = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ItemLinksCompanion.insert({
    required int parentId,
    required int childId,
    required LinkRole role,
    this.position = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : parentId = Value(parentId),
       childId = Value(childId),
       role = Value(role);
  static Insertable<ItemLink> custom({
    Expression<int>? parentId,
    Expression<int>? childId,
    Expression<String>? role,
    Expression<int>? position,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (parentId != null) 'parent_id': parentId,
      if (childId != null) 'child_id': childId,
      if (role != null) 'role': role,
      if (position != null) 'position': position,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ItemLinksCompanion copyWith({
    Value<int>? parentId,
    Value<int>? childId,
    Value<LinkRole>? role,
    Value<int>? position,
    Value<int>? rowid,
  }) {
    return ItemLinksCompanion(
      parentId: parentId ?? this.parentId,
      childId: childId ?? this.childId,
      role: role ?? this.role,
      position: position ?? this.position,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (parentId.present) {
      map['parent_id'] = Variable<int>(parentId.value);
    }
    if (childId.present) {
      map['child_id'] = Variable<int>(childId.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(
        $ItemLinksTable.$converterrole.toSql(role.value),
      );
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ItemLinksCompanion(')
          ..write('parentId: $parentId, ')
          ..write('childId: $childId, ')
          ..write('role: $role, ')
          ..write('position: $position, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RuleMistakesTable extends RuleMistakes
    with TableInfo<$RuleMistakesTable, RuleMistake> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RuleMistakesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _ruleIdMeta = const VerificationMeta('ruleId');
  @override
  late final GeneratedColumn<int> ruleId = GeneratedColumn<int>(
    'rule_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES items (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _wrongMeta = const VerificationMeta('wrong');
  @override
  late final GeneratedColumn<String> wrong = GeneratedColumn<String>(
    'wrong',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _explanationMeta = const VerificationMeta(
    'explanation',
  );
  @override
  late final GeneratedColumn<String> explanation = GeneratedColumn<String>(
    'explanation',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ruleId,
    wrong,
    explanation,
    position,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'rule_mistakes';
  @override
  VerificationContext validateIntegrity(
    Insertable<RuleMistake> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('rule_id')) {
      context.handle(
        _ruleIdMeta,
        ruleId.isAcceptableOrUnknown(data['rule_id']!, _ruleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_ruleIdMeta);
    }
    if (data.containsKey('wrong')) {
      context.handle(
        _wrongMeta,
        wrong.isAcceptableOrUnknown(data['wrong']!, _wrongMeta),
      );
    } else if (isInserting) {
      context.missing(_wrongMeta);
    }
    if (data.containsKey('explanation')) {
      context.handle(
        _explanationMeta,
        explanation.isAcceptableOrUnknown(
          data['explanation']!,
          _explanationMeta,
        ),
      );
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RuleMistake map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RuleMistake(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      ruleId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rule_id'],
      )!,
      wrong: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}wrong'],
      )!,
      explanation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}explanation'],
      ),
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
    );
  }

  @override
  $RuleMistakesTable createAlias(String alias) {
    return $RuleMistakesTable(attachedDatabase, alias);
  }
}

class RuleMistake extends DataClass implements Insertable<RuleMistake> {
  final int id;
  final int ruleId;
  final String wrong;
  final String? explanation;
  final int position;
  const RuleMistake({
    required this.id,
    required this.ruleId,
    required this.wrong,
    this.explanation,
    required this.position,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['rule_id'] = Variable<int>(ruleId);
    map['wrong'] = Variable<String>(wrong);
    if (!nullToAbsent || explanation != null) {
      map['explanation'] = Variable<String>(explanation);
    }
    map['position'] = Variable<int>(position);
    return map;
  }

  RuleMistakesCompanion toCompanion(bool nullToAbsent) {
    return RuleMistakesCompanion(
      id: Value(id),
      ruleId: Value(ruleId),
      wrong: Value(wrong),
      explanation: explanation == null && nullToAbsent
          ? const Value.absent()
          : Value(explanation),
      position: Value(position),
    );
  }

  factory RuleMistake.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RuleMistake(
      id: serializer.fromJson<int>(json['id']),
      ruleId: serializer.fromJson<int>(json['ruleId']),
      wrong: serializer.fromJson<String>(json['wrong']),
      explanation: serializer.fromJson<String?>(json['explanation']),
      position: serializer.fromJson<int>(json['position']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'ruleId': serializer.toJson<int>(ruleId),
      'wrong': serializer.toJson<String>(wrong),
      'explanation': serializer.toJson<String?>(explanation),
      'position': serializer.toJson<int>(position),
    };
  }

  RuleMistake copyWith({
    int? id,
    int? ruleId,
    String? wrong,
    Value<String?> explanation = const Value.absent(),
    int? position,
  }) => RuleMistake(
    id: id ?? this.id,
    ruleId: ruleId ?? this.ruleId,
    wrong: wrong ?? this.wrong,
    explanation: explanation.present ? explanation.value : this.explanation,
    position: position ?? this.position,
  );
  RuleMistake copyWithCompanion(RuleMistakesCompanion data) {
    return RuleMistake(
      id: data.id.present ? data.id.value : this.id,
      ruleId: data.ruleId.present ? data.ruleId.value : this.ruleId,
      wrong: data.wrong.present ? data.wrong.value : this.wrong,
      explanation: data.explanation.present
          ? data.explanation.value
          : this.explanation,
      position: data.position.present ? data.position.value : this.position,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RuleMistake(')
          ..write('id: $id, ')
          ..write('ruleId: $ruleId, ')
          ..write('wrong: $wrong, ')
          ..write('explanation: $explanation, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, ruleId, wrong, explanation, position);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RuleMistake &&
          other.id == this.id &&
          other.ruleId == this.ruleId &&
          other.wrong == this.wrong &&
          other.explanation == this.explanation &&
          other.position == this.position);
}

class RuleMistakesCompanion extends UpdateCompanion<RuleMistake> {
  final Value<int> id;
  final Value<int> ruleId;
  final Value<String> wrong;
  final Value<String?> explanation;
  final Value<int> position;
  const RuleMistakesCompanion({
    this.id = const Value.absent(),
    this.ruleId = const Value.absent(),
    this.wrong = const Value.absent(),
    this.explanation = const Value.absent(),
    this.position = const Value.absent(),
  });
  RuleMistakesCompanion.insert({
    this.id = const Value.absent(),
    required int ruleId,
    required String wrong,
    this.explanation = const Value.absent(),
    this.position = const Value.absent(),
  }) : ruleId = Value(ruleId),
       wrong = Value(wrong);
  static Insertable<RuleMistake> custom({
    Expression<int>? id,
    Expression<int>? ruleId,
    Expression<String>? wrong,
    Expression<String>? explanation,
    Expression<int>? position,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ruleId != null) 'rule_id': ruleId,
      if (wrong != null) 'wrong': wrong,
      if (explanation != null) 'explanation': explanation,
      if (position != null) 'position': position,
    });
  }

  RuleMistakesCompanion copyWith({
    Value<int>? id,
    Value<int>? ruleId,
    Value<String>? wrong,
    Value<String?>? explanation,
    Value<int>? position,
  }) {
    return RuleMistakesCompanion(
      id: id ?? this.id,
      ruleId: ruleId ?? this.ruleId,
      wrong: wrong ?? this.wrong,
      explanation: explanation ?? this.explanation,
      position: position ?? this.position,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (ruleId.present) {
      map['rule_id'] = Variable<int>(ruleId.value);
    }
    if (wrong.present) {
      map['wrong'] = Variable<String>(wrong.value);
    }
    if (explanation.present) {
      map['explanation'] = Variable<String>(explanation.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RuleMistakesCompanion(')
          ..write('id: $id, ')
          ..write('ruleId: $ruleId, ')
          ..write('wrong: $wrong, ')
          ..write('explanation: $explanation, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }
}

class $TagsTable extends Tags with TableInfo<$TagsTable, Tag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tags';
  @override
  VerificationContext validateIntegrity(
    Insertable<Tag> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Tag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Tag(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
    );
  }

  @override
  $TagsTable createAlias(String alias) {
    return $TagsTable(attachedDatabase, alias);
  }
}

class Tag extends DataClass implements Insertable<Tag> {
  final int id;

  /// Kisbetűs, `#` nélkül: „work”, „feelings”.
  final String name;
  const Tag({required this.id, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  TagsCompanion toCompanion(bool nullToAbsent) {
    return TagsCompanion(id: Value(id), name: Value(name));
  }

  factory Tag.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Tag(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  Tag copyWith({int? id, String? name}) =>
      Tag(id: id ?? this.id, name: name ?? this.name);
  Tag copyWithCompanion(TagsCompanion data) {
    return Tag(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Tag(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tag && other.id == this.id && other.name == this.name);
}

class TagsCompanion extends UpdateCompanion<Tag> {
  final Value<int> id;
  final Value<String> name;
  const TagsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  TagsCompanion.insert({this.id = const Value.absent(), required String name})
    : name = Value(name);
  static Insertable<Tag> custom({
    Expression<int>? id,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
    });
  }

  TagsCompanion copyWith({Value<int>? id, Value<String>? name}) {
    return TagsCompanion(id: id ?? this.id, name: name ?? this.name);
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TagsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $ItemTagsTable extends ItemTags with TableInfo<$ItemTagsTable, ItemTag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ItemTagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<int> itemId = GeneratedColumn<int>(
    'item_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES items (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _tagIdMeta = const VerificationMeta('tagId');
  @override
  late final GeneratedColumn<int> tagId = GeneratedColumn<int>(
    'tag_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tags (id) ON DELETE CASCADE',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [itemId, tagId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'item_tags';
  @override
  VerificationContext validateIntegrity(
    Insertable<ItemTag> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('item_id')) {
      context.handle(
        _itemIdMeta,
        itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta),
      );
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('tag_id')) {
      context.handle(
        _tagIdMeta,
        tagId.isAcceptableOrUnknown(data['tag_id']!, _tagIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tagIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {itemId, tagId};
  @override
  ItemTag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ItemTag(
      itemId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}item_id'],
      )!,
      tagId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tag_id'],
      )!,
    );
  }

  @override
  $ItemTagsTable createAlias(String alias) {
    return $ItemTagsTable(attachedDatabase, alias);
  }
}

class ItemTag extends DataClass implements Insertable<ItemTag> {
  final int itemId;
  final int tagId;
  const ItemTag({required this.itemId, required this.tagId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['item_id'] = Variable<int>(itemId);
    map['tag_id'] = Variable<int>(tagId);
    return map;
  }

  ItemTagsCompanion toCompanion(bool nullToAbsent) {
    return ItemTagsCompanion(itemId: Value(itemId), tagId: Value(tagId));
  }

  factory ItemTag.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ItemTag(
      itemId: serializer.fromJson<int>(json['itemId']),
      tagId: serializer.fromJson<int>(json['tagId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'itemId': serializer.toJson<int>(itemId),
      'tagId': serializer.toJson<int>(tagId),
    };
  }

  ItemTag copyWith({int? itemId, int? tagId}) =>
      ItemTag(itemId: itemId ?? this.itemId, tagId: tagId ?? this.tagId);
  ItemTag copyWithCompanion(ItemTagsCompanion data) {
    return ItemTag(
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      tagId: data.tagId.present ? data.tagId.value : this.tagId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ItemTag(')
          ..write('itemId: $itemId, ')
          ..write('tagId: $tagId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(itemId, tagId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ItemTag &&
          other.itemId == this.itemId &&
          other.tagId == this.tagId);
}

class ItemTagsCompanion extends UpdateCompanion<ItemTag> {
  final Value<int> itemId;
  final Value<int> tagId;
  final Value<int> rowid;
  const ItemTagsCompanion({
    this.itemId = const Value.absent(),
    this.tagId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ItemTagsCompanion.insert({
    required int itemId,
    required int tagId,
    this.rowid = const Value.absent(),
  }) : itemId = Value(itemId),
       tagId = Value(tagId);
  static Insertable<ItemTag> custom({
    Expression<int>? itemId,
    Expression<int>? tagId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (itemId != null) 'item_id': itemId,
      if (tagId != null) 'tag_id': tagId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ItemTagsCompanion copyWith({
    Value<int>? itemId,
    Value<int>? tagId,
    Value<int>? rowid,
  }) {
    return ItemTagsCompanion(
      itemId: itemId ?? this.itemId,
      tagId: tagId ?? this.tagId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (itemId.present) {
      map['item_id'] = Variable<int>(itemId.value);
    }
    if (tagId.present) {
      map['tag_id'] = Variable<int>(tagId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ItemTagsCompanion(')
          ..write('itemId: $itemId, ')
          ..write('tagId: $tagId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CollectionsTable extends Collections
    with TableInfo<$CollectionsTable, Collection> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CollectionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('book'),
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0xFFB49CFF),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, icon, color, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'collections';
  @override
  VerificationContext validateIntegrity(
    Insertable<Collection> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Collection map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Collection(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $CollectionsTable createAlias(String alias) {
    return $CollectionsTable(attachedDatabase, alias);
  }
}

class Collection extends DataClass implements Insertable<Collection> {
  final int id;
  final String name;

  /// Ikon kulcsa, pl. „book”, „briefcase”, „film”.
  final String icon;

  /// ARGB szín, pl. 0xFFB49CFF.
  final int color;
  final DateTime createdAt;
  const Collection({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['icon'] = Variable<String>(icon);
    map['color'] = Variable<int>(color);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CollectionsCompanion toCompanion(bool nullToAbsent) {
    return CollectionsCompanion(
      id: Value(id),
      name: Value(name),
      icon: Value(icon),
      color: Value(color),
      createdAt: Value(createdAt),
    );
  }

  factory Collection.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Collection(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      icon: serializer.fromJson<String>(json['icon']),
      color: serializer.fromJson<int>(json['color']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'icon': serializer.toJson<String>(icon),
      'color': serializer.toJson<int>(color),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Collection copyWith({
    int? id,
    String? name,
    String? icon,
    int? color,
    DateTime? createdAt,
  }) => Collection(
    id: id ?? this.id,
    name: name ?? this.name,
    icon: icon ?? this.icon,
    color: color ?? this.color,
    createdAt: createdAt ?? this.createdAt,
  );
  Collection copyWithCompanion(CollectionsCompanion data) {
    return Collection(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      icon: data.icon.present ? data.icon.value : this.icon,
      color: data.color.present ? data.color.value : this.color,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Collection(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('color: $color, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, icon, color, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Collection &&
          other.id == this.id &&
          other.name == this.name &&
          other.icon == this.icon &&
          other.color == this.color &&
          other.createdAt == this.createdAt);
}

class CollectionsCompanion extends UpdateCompanion<Collection> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> icon;
  final Value<int> color;
  final Value<DateTime> createdAt;
  const CollectionsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.icon = const Value.absent(),
    this.color = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  CollectionsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.icon = const Value.absent(),
    this.color = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Collection> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? icon,
    Expression<int>? color,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (icon != null) 'icon': icon,
      if (color != null) 'color': color,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  CollectionsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? icon,
    Value<int>? color,
    Value<DateTime>? createdAt,
  }) {
    return CollectionsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CollectionsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('color: $color, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $CollectionItemsTable extends CollectionItems
    with TableInfo<$CollectionItemsTable, CollectionItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CollectionItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _collectionIdMeta = const VerificationMeta(
    'collectionId',
  );
  @override
  late final GeneratedColumn<int> collectionId = GeneratedColumn<int>(
    'collection_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES collections (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<int> itemId = GeneratedColumn<int>(
    'item_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES items (id) ON DELETE CASCADE',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [collectionId, itemId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'collection_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<CollectionItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('collection_id')) {
      context.handle(
        _collectionIdMeta,
        collectionId.isAcceptableOrUnknown(
          data['collection_id']!,
          _collectionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_collectionIdMeta);
    }
    if (data.containsKey('item_id')) {
      context.handle(
        _itemIdMeta,
        itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta),
      );
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {collectionId, itemId};
  @override
  CollectionItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CollectionItem(
      collectionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}collection_id'],
      )!,
      itemId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}item_id'],
      )!,
    );
  }

  @override
  $CollectionItemsTable createAlias(String alias) {
    return $CollectionItemsTable(attachedDatabase, alias);
  }
}

class CollectionItem extends DataClass implements Insertable<CollectionItem> {
  final int collectionId;
  final int itemId;
  const CollectionItem({required this.collectionId, required this.itemId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['collection_id'] = Variable<int>(collectionId);
    map['item_id'] = Variable<int>(itemId);
    return map;
  }

  CollectionItemsCompanion toCompanion(bool nullToAbsent) {
    return CollectionItemsCompanion(
      collectionId: Value(collectionId),
      itemId: Value(itemId),
    );
  }

  factory CollectionItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CollectionItem(
      collectionId: serializer.fromJson<int>(json['collectionId']),
      itemId: serializer.fromJson<int>(json['itemId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'collectionId': serializer.toJson<int>(collectionId),
      'itemId': serializer.toJson<int>(itemId),
    };
  }

  CollectionItem copyWith({int? collectionId, int? itemId}) => CollectionItem(
    collectionId: collectionId ?? this.collectionId,
    itemId: itemId ?? this.itemId,
  );
  CollectionItem copyWithCompanion(CollectionItemsCompanion data) {
    return CollectionItem(
      collectionId: data.collectionId.present
          ? data.collectionId.value
          : this.collectionId,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CollectionItem(')
          ..write('collectionId: $collectionId, ')
          ..write('itemId: $itemId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(collectionId, itemId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CollectionItem &&
          other.collectionId == this.collectionId &&
          other.itemId == this.itemId);
}

class CollectionItemsCompanion extends UpdateCompanion<CollectionItem> {
  final Value<int> collectionId;
  final Value<int> itemId;
  final Value<int> rowid;
  const CollectionItemsCompanion({
    this.collectionId = const Value.absent(),
    this.itemId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CollectionItemsCompanion.insert({
    required int collectionId,
    required int itemId,
    this.rowid = const Value.absent(),
  }) : collectionId = Value(collectionId),
       itemId = Value(itemId);
  static Insertable<CollectionItem> custom({
    Expression<int>? collectionId,
    Expression<int>? itemId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (collectionId != null) 'collection_id': collectionId,
      if (itemId != null) 'item_id': itemId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CollectionItemsCompanion copyWith({
    Value<int>? collectionId,
    Value<int>? itemId,
    Value<int>? rowid,
  }) {
    return CollectionItemsCompanion(
      collectionId: collectionId ?? this.collectionId,
      itemId: itemId ?? this.itemId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (collectionId.present) {
      map['collection_id'] = Variable<int>(collectionId.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<int>(itemId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CollectionItemsCompanion(')
          ..write('collectionId: $collectionId, ')
          ..write('itemId: $itemId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReviewStatesTable extends ReviewStates
    with TableInfo<$ReviewStatesTable, ReviewState> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReviewStatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<int> itemId = GeneratedColumn<int>(
    'item_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES items (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _dueAtMeta = const VerificationMeta('dueAt');
  @override
  late final GeneratedColumn<DateTime> dueAt = GeneratedColumn<DateTime>(
    'due_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _easeMeta = const VerificationMeta('ease');
  @override
  late final GeneratedColumn<double> ease = GeneratedColumn<double>(
    'ease',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(2.5),
  );
  static const VerificationMeta _intervalDaysMeta = const VerificationMeta(
    'intervalDays',
  );
  @override
  late final GeneratedColumn<int> intervalDays = GeneratedColumn<int>(
    'interval_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _repetitionsMeta = const VerificationMeta(
    'repetitions',
  );
  @override
  late final GeneratedColumn<int> repetitions = GeneratedColumn<int>(
    'repetitions',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lapsesMeta = const VerificationMeta('lapses');
  @override
  late final GeneratedColumn<int> lapses = GeneratedColumn<int>(
    'lapses',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastReviewedAtMeta = const VerificationMeta(
    'lastReviewedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastReviewedAt =
      GeneratedColumn<DateTime>(
        'last_reviewed_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    itemId,
    dueAt,
    ease,
    intervalDays,
    repetitions,
    lapses,
    lastReviewedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'review_states';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReviewState> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('item_id')) {
      context.handle(
        _itemIdMeta,
        itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta),
      );
    }
    if (data.containsKey('due_at')) {
      context.handle(
        _dueAtMeta,
        dueAt.isAcceptableOrUnknown(data['due_at']!, _dueAtMeta),
      );
    } else if (isInserting) {
      context.missing(_dueAtMeta);
    }
    if (data.containsKey('ease')) {
      context.handle(
        _easeMeta,
        ease.isAcceptableOrUnknown(data['ease']!, _easeMeta),
      );
    }
    if (data.containsKey('interval_days')) {
      context.handle(
        _intervalDaysMeta,
        intervalDays.isAcceptableOrUnknown(
          data['interval_days']!,
          _intervalDaysMeta,
        ),
      );
    }
    if (data.containsKey('repetitions')) {
      context.handle(
        _repetitionsMeta,
        repetitions.isAcceptableOrUnknown(
          data['repetitions']!,
          _repetitionsMeta,
        ),
      );
    }
    if (data.containsKey('lapses')) {
      context.handle(
        _lapsesMeta,
        lapses.isAcceptableOrUnknown(data['lapses']!, _lapsesMeta),
      );
    }
    if (data.containsKey('last_reviewed_at')) {
      context.handle(
        _lastReviewedAtMeta,
        lastReviewedAt.isAcceptableOrUnknown(
          data['last_reviewed_at']!,
          _lastReviewedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {itemId};
  @override
  ReviewState map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReviewState(
      itemId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}item_id'],
      )!,
      dueAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_at'],
      )!,
      ease: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}ease'],
      )!,
      intervalDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}interval_days'],
      )!,
      repetitions: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}repetitions'],
      )!,
      lapses: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}lapses'],
      )!,
      lastReviewedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_reviewed_at'],
      ),
    );
  }

  @override
  $ReviewStatesTable createAlias(String alias) {
    return $ReviewStatesTable(attachedDatabase, alias);
  }
}

class ReviewState extends DataClass implements Insertable<ReviewState> {
  final int itemId;
  final DateTime dueAt;
  final double ease;
  final int intervalDays;

  /// Egymás utáni sikeres ismétlések száma.
  final int repetitions;

  /// Hányszor felejtette el.
  final int lapses;
  final DateTime? lastReviewedAt;
  const ReviewState({
    required this.itemId,
    required this.dueAt,
    required this.ease,
    required this.intervalDays,
    required this.repetitions,
    required this.lapses,
    this.lastReviewedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['item_id'] = Variable<int>(itemId);
    map['due_at'] = Variable<DateTime>(dueAt);
    map['ease'] = Variable<double>(ease);
    map['interval_days'] = Variable<int>(intervalDays);
    map['repetitions'] = Variable<int>(repetitions);
    map['lapses'] = Variable<int>(lapses);
    if (!nullToAbsent || lastReviewedAt != null) {
      map['last_reviewed_at'] = Variable<DateTime>(lastReviewedAt);
    }
    return map;
  }

  ReviewStatesCompanion toCompanion(bool nullToAbsent) {
    return ReviewStatesCompanion(
      itemId: Value(itemId),
      dueAt: Value(dueAt),
      ease: Value(ease),
      intervalDays: Value(intervalDays),
      repetitions: Value(repetitions),
      lapses: Value(lapses),
      lastReviewedAt: lastReviewedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastReviewedAt),
    );
  }

  factory ReviewState.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReviewState(
      itemId: serializer.fromJson<int>(json['itemId']),
      dueAt: serializer.fromJson<DateTime>(json['dueAt']),
      ease: serializer.fromJson<double>(json['ease']),
      intervalDays: serializer.fromJson<int>(json['intervalDays']),
      repetitions: serializer.fromJson<int>(json['repetitions']),
      lapses: serializer.fromJson<int>(json['lapses']),
      lastReviewedAt: serializer.fromJson<DateTime?>(json['lastReviewedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'itemId': serializer.toJson<int>(itemId),
      'dueAt': serializer.toJson<DateTime>(dueAt),
      'ease': serializer.toJson<double>(ease),
      'intervalDays': serializer.toJson<int>(intervalDays),
      'repetitions': serializer.toJson<int>(repetitions),
      'lapses': serializer.toJson<int>(lapses),
      'lastReviewedAt': serializer.toJson<DateTime?>(lastReviewedAt),
    };
  }

  ReviewState copyWith({
    int? itemId,
    DateTime? dueAt,
    double? ease,
    int? intervalDays,
    int? repetitions,
    int? lapses,
    Value<DateTime?> lastReviewedAt = const Value.absent(),
  }) => ReviewState(
    itemId: itemId ?? this.itemId,
    dueAt: dueAt ?? this.dueAt,
    ease: ease ?? this.ease,
    intervalDays: intervalDays ?? this.intervalDays,
    repetitions: repetitions ?? this.repetitions,
    lapses: lapses ?? this.lapses,
    lastReviewedAt: lastReviewedAt.present
        ? lastReviewedAt.value
        : this.lastReviewedAt,
  );
  ReviewState copyWithCompanion(ReviewStatesCompanion data) {
    return ReviewState(
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      dueAt: data.dueAt.present ? data.dueAt.value : this.dueAt,
      ease: data.ease.present ? data.ease.value : this.ease,
      intervalDays: data.intervalDays.present
          ? data.intervalDays.value
          : this.intervalDays,
      repetitions: data.repetitions.present
          ? data.repetitions.value
          : this.repetitions,
      lapses: data.lapses.present ? data.lapses.value : this.lapses,
      lastReviewedAt: data.lastReviewedAt.present
          ? data.lastReviewedAt.value
          : this.lastReviewedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReviewState(')
          ..write('itemId: $itemId, ')
          ..write('dueAt: $dueAt, ')
          ..write('ease: $ease, ')
          ..write('intervalDays: $intervalDays, ')
          ..write('repetitions: $repetitions, ')
          ..write('lapses: $lapses, ')
          ..write('lastReviewedAt: $lastReviewedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    itemId,
    dueAt,
    ease,
    intervalDays,
    repetitions,
    lapses,
    lastReviewedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReviewState &&
          other.itemId == this.itemId &&
          other.dueAt == this.dueAt &&
          other.ease == this.ease &&
          other.intervalDays == this.intervalDays &&
          other.repetitions == this.repetitions &&
          other.lapses == this.lapses &&
          other.lastReviewedAt == this.lastReviewedAt);
}

class ReviewStatesCompanion extends UpdateCompanion<ReviewState> {
  final Value<int> itemId;
  final Value<DateTime> dueAt;
  final Value<double> ease;
  final Value<int> intervalDays;
  final Value<int> repetitions;
  final Value<int> lapses;
  final Value<DateTime?> lastReviewedAt;
  const ReviewStatesCompanion({
    this.itemId = const Value.absent(),
    this.dueAt = const Value.absent(),
    this.ease = const Value.absent(),
    this.intervalDays = const Value.absent(),
    this.repetitions = const Value.absent(),
    this.lapses = const Value.absent(),
    this.lastReviewedAt = const Value.absent(),
  });
  ReviewStatesCompanion.insert({
    this.itemId = const Value.absent(),
    required DateTime dueAt,
    this.ease = const Value.absent(),
    this.intervalDays = const Value.absent(),
    this.repetitions = const Value.absent(),
    this.lapses = const Value.absent(),
    this.lastReviewedAt = const Value.absent(),
  }) : dueAt = Value(dueAt);
  static Insertable<ReviewState> custom({
    Expression<int>? itemId,
    Expression<DateTime>? dueAt,
    Expression<double>? ease,
    Expression<int>? intervalDays,
    Expression<int>? repetitions,
    Expression<int>? lapses,
    Expression<DateTime>? lastReviewedAt,
  }) {
    return RawValuesInsertable({
      if (itemId != null) 'item_id': itemId,
      if (dueAt != null) 'due_at': dueAt,
      if (ease != null) 'ease': ease,
      if (intervalDays != null) 'interval_days': intervalDays,
      if (repetitions != null) 'repetitions': repetitions,
      if (lapses != null) 'lapses': lapses,
      if (lastReviewedAt != null) 'last_reviewed_at': lastReviewedAt,
    });
  }

  ReviewStatesCompanion copyWith({
    Value<int>? itemId,
    Value<DateTime>? dueAt,
    Value<double>? ease,
    Value<int>? intervalDays,
    Value<int>? repetitions,
    Value<int>? lapses,
    Value<DateTime?>? lastReviewedAt,
  }) {
    return ReviewStatesCompanion(
      itemId: itemId ?? this.itemId,
      dueAt: dueAt ?? this.dueAt,
      ease: ease ?? this.ease,
      intervalDays: intervalDays ?? this.intervalDays,
      repetitions: repetitions ?? this.repetitions,
      lapses: lapses ?? this.lapses,
      lastReviewedAt: lastReviewedAt ?? this.lastReviewedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (itemId.present) {
      map['item_id'] = Variable<int>(itemId.value);
    }
    if (dueAt.present) {
      map['due_at'] = Variable<DateTime>(dueAt.value);
    }
    if (ease.present) {
      map['ease'] = Variable<double>(ease.value);
    }
    if (intervalDays.present) {
      map['interval_days'] = Variable<int>(intervalDays.value);
    }
    if (repetitions.present) {
      map['repetitions'] = Variable<int>(repetitions.value);
    }
    if (lapses.present) {
      map['lapses'] = Variable<int>(lapses.value);
    }
    if (lastReviewedAt.present) {
      map['last_reviewed_at'] = Variable<DateTime>(lastReviewedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReviewStatesCompanion(')
          ..write('itemId: $itemId, ')
          ..write('dueAt: $dueAt, ')
          ..write('ease: $ease, ')
          ..write('intervalDays: $intervalDays, ')
          ..write('repetitions: $repetitions, ')
          ..write('lapses: $lapses, ')
          ..write('lastReviewedAt: $lastReviewedAt')
          ..write(')'))
        .toString();
  }
}

class $ReviewLogsTable extends ReviewLogs
    with TableInfo<$ReviewLogsTable, ReviewLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReviewLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<int> itemId = GeneratedColumn<int>(
    'item_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES items (id) ON DELETE CASCADE',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<ReviewTask, String> task =
      GeneratedColumn<String>(
        'task',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<ReviewTask>($ReviewLogsTable.$convertertask);
  static const VerificationMeta _correctMeta = const VerificationMeta(
    'correct',
  );
  @override
  late final GeneratedColumn<bool> correct = GeneratedColumn<bool>(
    'correct',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("correct" IN (0, 1))',
    ),
  );
  static const VerificationMeta _reviewedAtMeta = const VerificationMeta(
    'reviewedAt',
  );
  @override
  late final GeneratedColumn<DateTime> reviewedAt = GeneratedColumn<DateTime>(
    'reviewed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, itemId, task, correct, reviewedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'review_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReviewLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('item_id')) {
      context.handle(
        _itemIdMeta,
        itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta),
      );
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('correct')) {
      context.handle(
        _correctMeta,
        correct.isAcceptableOrUnknown(data['correct']!, _correctMeta),
      );
    } else if (isInserting) {
      context.missing(_correctMeta);
    }
    if (data.containsKey('reviewed_at')) {
      context.handle(
        _reviewedAtMeta,
        reviewedAt.isAcceptableOrUnknown(data['reviewed_at']!, _reviewedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReviewLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReviewLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      itemId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}item_id'],
      )!,
      task: $ReviewLogsTable.$convertertask.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}task'],
        )!,
      ),
      correct: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}correct'],
      )!,
      reviewedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}reviewed_at'],
      )!,
    );
  }

  @override
  $ReviewLogsTable createAlias(String alias) {
    return $ReviewLogsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ReviewTask, String, String> $convertertask =
      const EnumNameConverter<ReviewTask>(ReviewTask.values);
}

class ReviewLog extends DataClass implements Insertable<ReviewLog> {
  final int id;
  final int itemId;
  final ReviewTask task;
  final bool correct;
  final DateTime reviewedAt;
  const ReviewLog({
    required this.id,
    required this.itemId,
    required this.task,
    required this.correct,
    required this.reviewedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['item_id'] = Variable<int>(itemId);
    {
      map['task'] = Variable<String>(
        $ReviewLogsTable.$convertertask.toSql(task),
      );
    }
    map['correct'] = Variable<bool>(correct);
    map['reviewed_at'] = Variable<DateTime>(reviewedAt);
    return map;
  }

  ReviewLogsCompanion toCompanion(bool nullToAbsent) {
    return ReviewLogsCompanion(
      id: Value(id),
      itemId: Value(itemId),
      task: Value(task),
      correct: Value(correct),
      reviewedAt: Value(reviewedAt),
    );
  }

  factory ReviewLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReviewLog(
      id: serializer.fromJson<int>(json['id']),
      itemId: serializer.fromJson<int>(json['itemId']),
      task: $ReviewLogsTable.$convertertask.fromJson(
        serializer.fromJson<String>(json['task']),
      ),
      correct: serializer.fromJson<bool>(json['correct']),
      reviewedAt: serializer.fromJson<DateTime>(json['reviewedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'itemId': serializer.toJson<int>(itemId),
      'task': serializer.toJson<String>(
        $ReviewLogsTable.$convertertask.toJson(task),
      ),
      'correct': serializer.toJson<bool>(correct),
      'reviewedAt': serializer.toJson<DateTime>(reviewedAt),
    };
  }

  ReviewLog copyWith({
    int? id,
    int? itemId,
    ReviewTask? task,
    bool? correct,
    DateTime? reviewedAt,
  }) => ReviewLog(
    id: id ?? this.id,
    itemId: itemId ?? this.itemId,
    task: task ?? this.task,
    correct: correct ?? this.correct,
    reviewedAt: reviewedAt ?? this.reviewedAt,
  );
  ReviewLog copyWithCompanion(ReviewLogsCompanion data) {
    return ReviewLog(
      id: data.id.present ? data.id.value : this.id,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      task: data.task.present ? data.task.value : this.task,
      correct: data.correct.present ? data.correct.value : this.correct,
      reviewedAt: data.reviewedAt.present
          ? data.reviewedAt.value
          : this.reviewedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReviewLog(')
          ..write('id: $id, ')
          ..write('itemId: $itemId, ')
          ..write('task: $task, ')
          ..write('correct: $correct, ')
          ..write('reviewedAt: $reviewedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, itemId, task, correct, reviewedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReviewLog &&
          other.id == this.id &&
          other.itemId == this.itemId &&
          other.task == this.task &&
          other.correct == this.correct &&
          other.reviewedAt == this.reviewedAt);
}

class ReviewLogsCompanion extends UpdateCompanion<ReviewLog> {
  final Value<int> id;
  final Value<int> itemId;
  final Value<ReviewTask> task;
  final Value<bool> correct;
  final Value<DateTime> reviewedAt;
  const ReviewLogsCompanion({
    this.id = const Value.absent(),
    this.itemId = const Value.absent(),
    this.task = const Value.absent(),
    this.correct = const Value.absent(),
    this.reviewedAt = const Value.absent(),
  });
  ReviewLogsCompanion.insert({
    this.id = const Value.absent(),
    required int itemId,
    required ReviewTask task,
    required bool correct,
    this.reviewedAt = const Value.absent(),
  }) : itemId = Value(itemId),
       task = Value(task),
       correct = Value(correct);
  static Insertable<ReviewLog> custom({
    Expression<int>? id,
    Expression<int>? itemId,
    Expression<String>? task,
    Expression<bool>? correct,
    Expression<DateTime>? reviewedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (itemId != null) 'item_id': itemId,
      if (task != null) 'task': task,
      if (correct != null) 'correct': correct,
      if (reviewedAt != null) 'reviewed_at': reviewedAt,
    });
  }

  ReviewLogsCompanion copyWith({
    Value<int>? id,
    Value<int>? itemId,
    Value<ReviewTask>? task,
    Value<bool>? correct,
    Value<DateTime>? reviewedAt,
  }) {
    return ReviewLogsCompanion(
      id: id ?? this.id,
      itemId: itemId ?? this.itemId,
      task: task ?? this.task,
      correct: correct ?? this.correct,
      reviewedAt: reviewedAt ?? this.reviewedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<int>(itemId.value);
    }
    if (task.present) {
      map['task'] = Variable<String>(
        $ReviewLogsTable.$convertertask.toSql(task.value),
      );
    }
    if (correct.present) {
      map['correct'] = Variable<bool>(correct.value);
    }
    if (reviewedAt.present) {
      map['reviewed_at'] = Variable<DateTime>(reviewedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReviewLogsCompanion(')
          ..write('id: $id, ')
          ..write('itemId: $itemId, ')
          ..write('task: $task, ')
          ..write('correct: $correct, ')
          ..write('reviewedAt: $reviewedAt')
          ..write(')'))
        .toString();
  }
}

class $XpEventsTable extends XpEvents with TableInfo<$XpEventsTable, XpEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $XpEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<XpReason, String> reason =
      GeneratedColumn<String>(
        'reason',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<XpReason>($XpEventsTable.$converterreason);
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<int> itemId = GeneratedColumn<int>(
    'item_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES items (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, amount, reason, itemId, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'xp_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<XpEvent> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('item_id')) {
      context.handle(
        _itemIdMeta,
        itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  XpEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return XpEvent(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
      reason: $XpEventsTable.$converterreason.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}reason'],
        )!,
      ),
      itemId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}item_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $XpEventsTable createAlias(String alias) {
    return $XpEventsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<XpReason, String, String> $converterreason =
      const EnumNameConverter<XpReason>(XpReason.values);
}

class XpEvent extends DataClass implements Insertable<XpEvent> {
  final int id;
  final int amount;
  final XpReason reason;
  final int? itemId;
  final DateTime createdAt;
  const XpEvent({
    required this.id,
    required this.amount,
    required this.reason,
    this.itemId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['amount'] = Variable<int>(amount);
    {
      map['reason'] = Variable<String>(
        $XpEventsTable.$converterreason.toSql(reason),
      );
    }
    if (!nullToAbsent || itemId != null) {
      map['item_id'] = Variable<int>(itemId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  XpEventsCompanion toCompanion(bool nullToAbsent) {
    return XpEventsCompanion(
      id: Value(id),
      amount: Value(amount),
      reason: Value(reason),
      itemId: itemId == null && nullToAbsent
          ? const Value.absent()
          : Value(itemId),
      createdAt: Value(createdAt),
    );
  }

  factory XpEvent.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return XpEvent(
      id: serializer.fromJson<int>(json['id']),
      amount: serializer.fromJson<int>(json['amount']),
      reason: $XpEventsTable.$converterreason.fromJson(
        serializer.fromJson<String>(json['reason']),
      ),
      itemId: serializer.fromJson<int?>(json['itemId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'amount': serializer.toJson<int>(amount),
      'reason': serializer.toJson<String>(
        $XpEventsTable.$converterreason.toJson(reason),
      ),
      'itemId': serializer.toJson<int?>(itemId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  XpEvent copyWith({
    int? id,
    int? amount,
    XpReason? reason,
    Value<int?> itemId = const Value.absent(),
    DateTime? createdAt,
  }) => XpEvent(
    id: id ?? this.id,
    amount: amount ?? this.amount,
    reason: reason ?? this.reason,
    itemId: itemId.present ? itemId.value : this.itemId,
    createdAt: createdAt ?? this.createdAt,
  );
  XpEvent copyWithCompanion(XpEventsCompanion data) {
    return XpEvent(
      id: data.id.present ? data.id.value : this.id,
      amount: data.amount.present ? data.amount.value : this.amount,
      reason: data.reason.present ? data.reason.value : this.reason,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('XpEvent(')
          ..write('id: $id, ')
          ..write('amount: $amount, ')
          ..write('reason: $reason, ')
          ..write('itemId: $itemId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, amount, reason, itemId, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is XpEvent &&
          other.id == this.id &&
          other.amount == this.amount &&
          other.reason == this.reason &&
          other.itemId == this.itemId &&
          other.createdAt == this.createdAt);
}

class XpEventsCompanion extends UpdateCompanion<XpEvent> {
  final Value<int> id;
  final Value<int> amount;
  final Value<XpReason> reason;
  final Value<int?> itemId;
  final Value<DateTime> createdAt;
  const XpEventsCompanion({
    this.id = const Value.absent(),
    this.amount = const Value.absent(),
    this.reason = const Value.absent(),
    this.itemId = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  XpEventsCompanion.insert({
    this.id = const Value.absent(),
    required int amount,
    required XpReason reason,
    this.itemId = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : amount = Value(amount),
       reason = Value(reason);
  static Insertable<XpEvent> custom({
    Expression<int>? id,
    Expression<int>? amount,
    Expression<String>? reason,
    Expression<int>? itemId,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (amount != null) 'amount': amount,
      if (reason != null) 'reason': reason,
      if (itemId != null) 'item_id': itemId,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  XpEventsCompanion copyWith({
    Value<int>? id,
    Value<int>? amount,
    Value<XpReason>? reason,
    Value<int?>? itemId,
    Value<DateTime>? createdAt,
  }) {
    return XpEventsCompanion(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      reason: reason ?? this.reason,
      itemId: itemId ?? this.itemId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(
        $XpEventsTable.$converterreason.toSql(reason.value),
      );
    }
    if (itemId.present) {
      map['item_id'] = Variable<int>(itemId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('XpEventsCompanion(')
          ..write('id: $id, ')
          ..write('amount: $amount, ')
          ..write('reason: $reason, ')
          ..write('itemId: $itemId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, Settings> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _usernameMeta = const VerificationMeta(
    'username',
  );
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
    'username',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  late final GeneratedColumnWithTypeConverter<CefrLevel, String> levelNow =
      GeneratedColumn<String>(
        'level_now',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('b1'),
      ).withConverter<CefrLevel>($AppSettingsTable.$converterlevelNow);
  @override
  late final GeneratedColumnWithTypeConverter<CefrLevel, String> levelGoal =
      GeneratedColumn<String>(
        'level_goal',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('c1'),
      ).withConverter<CefrLevel>($AppSettingsTable.$converterlevelGoal);
  static const VerificationMeta _dailyGoalMeta = const VerificationMeta(
    'dailyGoal',
  );
  @override
  late final GeneratedColumn<int> dailyGoal = GeneratedColumn<int>(
    'daily_goal',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(5),
  );
  static const VerificationMeta _sessionLengthMeta = const VerificationMeta(
    'sessionLength',
  );
  @override
  late final GeneratedColumn<int> sessionLength = GeneratedColumn<int>(
    'session_length',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(10),
  );
  @override
  late final GeneratedColumnWithTypeConverter<AnswerMode, String> answerMode =
      GeneratedColumn<String>(
        'answer_mode',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('mix'),
      ).withConverter<AnswerMode>($AppSettingsTable.$converteranswerMode);
  static const VerificationMeta _gameModeMeta = const VerificationMeta(
    'gameMode',
  );
  @override
  late final GeneratedColumn<bool> gameMode = GeneratedColumn<bool>(
    'game_mode',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("game_mode" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _streakFreezeMeta = const VerificationMeta(
    'streakFreeze',
  );
  @override
  late final GeneratedColumn<bool> streakFreeze = GeneratedColumn<bool>(
    'streak_freeze',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("streak_freeze" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _reminderEnabledMeta = const VerificationMeta(
    'reminderEnabled',
  );
  @override
  late final GeneratedColumn<bool> reminderEnabled = GeneratedColumn<bool>(
    'reminder_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("reminder_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _reminderMinutesMeta = const VerificationMeta(
    'reminderMinutes',
  );
  @override
  late final GeneratedColumn<int> reminderMinutes = GeneratedColumn<int>(
    'reminder_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(19 * 60 + 30),
  );
  @override
  late final GeneratedColumnWithTypeConverter<Accent, String> accent =
      GeneratedColumn<String>(
        'accent',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('british'),
      ).withConverter<Accent>($AppSettingsTable.$converteraccent);
  @override
  late final GeneratedColumnWithTypeConverter<SpeechSpeed, String> speechSpeed =
      GeneratedColumn<String>(
        'speech_speed',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('normal'),
      ).withConverter<SpeechSpeed>($AppSettingsTable.$converterspeechSpeed);
  static const VerificationMeta _lastBackupAtMeta = const VerificationMeta(
    'lastBackupAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastBackupAt = GeneratedColumn<DateTime>(
    'last_backup_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    username,
    levelNow,
    levelGoal,
    dailyGoal,
    sessionLength,
    answerMode,
    gameMode,
    streakFreeze,
    reminderEnabled,
    reminderMinutes,
    accent,
    speechSpeed,
    lastBackupAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<Settings> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('username')) {
      context.handle(
        _usernameMeta,
        username.isAcceptableOrUnknown(data['username']!, _usernameMeta),
      );
    }
    if (data.containsKey('daily_goal')) {
      context.handle(
        _dailyGoalMeta,
        dailyGoal.isAcceptableOrUnknown(data['daily_goal']!, _dailyGoalMeta),
      );
    }
    if (data.containsKey('session_length')) {
      context.handle(
        _sessionLengthMeta,
        sessionLength.isAcceptableOrUnknown(
          data['session_length']!,
          _sessionLengthMeta,
        ),
      );
    }
    if (data.containsKey('game_mode')) {
      context.handle(
        _gameModeMeta,
        gameMode.isAcceptableOrUnknown(data['game_mode']!, _gameModeMeta),
      );
    }
    if (data.containsKey('streak_freeze')) {
      context.handle(
        _streakFreezeMeta,
        streakFreeze.isAcceptableOrUnknown(
          data['streak_freeze']!,
          _streakFreezeMeta,
        ),
      );
    }
    if (data.containsKey('reminder_enabled')) {
      context.handle(
        _reminderEnabledMeta,
        reminderEnabled.isAcceptableOrUnknown(
          data['reminder_enabled']!,
          _reminderEnabledMeta,
        ),
      );
    }
    if (data.containsKey('reminder_minutes')) {
      context.handle(
        _reminderMinutesMeta,
        reminderMinutes.isAcceptableOrUnknown(
          data['reminder_minutes']!,
          _reminderMinutesMeta,
        ),
      );
    }
    if (data.containsKey('last_backup_at')) {
      context.handle(
        _lastBackupAtMeta,
        lastBackupAt.isAcceptableOrUnknown(
          data['last_backup_at']!,
          _lastBackupAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Settings map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Settings(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      username: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}username'],
      )!,
      levelNow: $AppSettingsTable.$converterlevelNow.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}level_now'],
        )!,
      ),
      levelGoal: $AppSettingsTable.$converterlevelGoal.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}level_goal'],
        )!,
      ),
      dailyGoal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}daily_goal'],
      )!,
      sessionLength: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}session_length'],
      )!,
      answerMode: $AppSettingsTable.$converteranswerMode.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}answer_mode'],
        )!,
      ),
      gameMode: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}game_mode'],
      )!,
      streakFreeze: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}streak_freeze'],
      )!,
      reminderEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}reminder_enabled'],
      )!,
      reminderMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reminder_minutes'],
      )!,
      accent: $AppSettingsTable.$converteraccent.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}accent'],
        )!,
      ),
      speechSpeed: $AppSettingsTable.$converterspeechSpeed.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}speech_speed'],
        )!,
      ),
      lastBackupAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_backup_at'],
      ),
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<CefrLevel, String, String> $converterlevelNow =
      const EnumNameConverter<CefrLevel>(CefrLevel.values);
  static JsonTypeConverter2<CefrLevel, String, String> $converterlevelGoal =
      const EnumNameConverter<CefrLevel>(CefrLevel.values);
  static JsonTypeConverter2<AnswerMode, String, String> $converteranswerMode =
      const EnumNameConverter<AnswerMode>(AnswerMode.values);
  static JsonTypeConverter2<Accent, String, String> $converteraccent =
      const EnumNameConverter<Accent>(Accent.values);
  static JsonTypeConverter2<SpeechSpeed, String, String> $converterspeechSpeed =
      const EnumNameConverter<SpeechSpeed>(SpeechSpeed.values);
}

class Settings extends DataClass implements Insertable<Settings> {
  final int id;
  final String username;
  final CefrLevel levelNow;
  final CefrLevel levelGoal;

  /// Napi cél: új elemek száma.
  final int dailyGoal;

  /// Egy ismétlési kör hossza (elem).
  final int sessionLength;
  final AnswerMode answerMode;
  final bool gameMode;
  final bool streakFreeze;
  final bool reminderEnabled;

  /// Emlékeztető ideje percben éjféltől (19:30 = 1170).
  final int reminderMinutes;
  final Accent accent;
  final SpeechSpeed speechSpeed;
  final DateTime? lastBackupAt;
  const Settings({
    required this.id,
    required this.username,
    required this.levelNow,
    required this.levelGoal,
    required this.dailyGoal,
    required this.sessionLength,
    required this.answerMode,
    required this.gameMode,
    required this.streakFreeze,
    required this.reminderEnabled,
    required this.reminderMinutes,
    required this.accent,
    required this.speechSpeed,
    this.lastBackupAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['username'] = Variable<String>(username);
    {
      map['level_now'] = Variable<String>(
        $AppSettingsTable.$converterlevelNow.toSql(levelNow),
      );
    }
    {
      map['level_goal'] = Variable<String>(
        $AppSettingsTable.$converterlevelGoal.toSql(levelGoal),
      );
    }
    map['daily_goal'] = Variable<int>(dailyGoal);
    map['session_length'] = Variable<int>(sessionLength);
    {
      map['answer_mode'] = Variable<String>(
        $AppSettingsTable.$converteranswerMode.toSql(answerMode),
      );
    }
    map['game_mode'] = Variable<bool>(gameMode);
    map['streak_freeze'] = Variable<bool>(streakFreeze);
    map['reminder_enabled'] = Variable<bool>(reminderEnabled);
    map['reminder_minutes'] = Variable<int>(reminderMinutes);
    {
      map['accent'] = Variable<String>(
        $AppSettingsTable.$converteraccent.toSql(accent),
      );
    }
    {
      map['speech_speed'] = Variable<String>(
        $AppSettingsTable.$converterspeechSpeed.toSql(speechSpeed),
      );
    }
    if (!nullToAbsent || lastBackupAt != null) {
      map['last_backup_at'] = Variable<DateTime>(lastBackupAt);
    }
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(
      id: Value(id),
      username: Value(username),
      levelNow: Value(levelNow),
      levelGoal: Value(levelGoal),
      dailyGoal: Value(dailyGoal),
      sessionLength: Value(sessionLength),
      answerMode: Value(answerMode),
      gameMode: Value(gameMode),
      streakFreeze: Value(streakFreeze),
      reminderEnabled: Value(reminderEnabled),
      reminderMinutes: Value(reminderMinutes),
      accent: Value(accent),
      speechSpeed: Value(speechSpeed),
      lastBackupAt: lastBackupAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastBackupAt),
    );
  }

  factory Settings.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Settings(
      id: serializer.fromJson<int>(json['id']),
      username: serializer.fromJson<String>(json['username']),
      levelNow: $AppSettingsTable.$converterlevelNow.fromJson(
        serializer.fromJson<String>(json['levelNow']),
      ),
      levelGoal: $AppSettingsTable.$converterlevelGoal.fromJson(
        serializer.fromJson<String>(json['levelGoal']),
      ),
      dailyGoal: serializer.fromJson<int>(json['dailyGoal']),
      sessionLength: serializer.fromJson<int>(json['sessionLength']),
      answerMode: $AppSettingsTable.$converteranswerMode.fromJson(
        serializer.fromJson<String>(json['answerMode']),
      ),
      gameMode: serializer.fromJson<bool>(json['gameMode']),
      streakFreeze: serializer.fromJson<bool>(json['streakFreeze']),
      reminderEnabled: serializer.fromJson<bool>(json['reminderEnabled']),
      reminderMinutes: serializer.fromJson<int>(json['reminderMinutes']),
      accent: $AppSettingsTable.$converteraccent.fromJson(
        serializer.fromJson<String>(json['accent']),
      ),
      speechSpeed: $AppSettingsTable.$converterspeechSpeed.fromJson(
        serializer.fromJson<String>(json['speechSpeed']),
      ),
      lastBackupAt: serializer.fromJson<DateTime?>(json['lastBackupAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'username': serializer.toJson<String>(username),
      'levelNow': serializer.toJson<String>(
        $AppSettingsTable.$converterlevelNow.toJson(levelNow),
      ),
      'levelGoal': serializer.toJson<String>(
        $AppSettingsTable.$converterlevelGoal.toJson(levelGoal),
      ),
      'dailyGoal': serializer.toJson<int>(dailyGoal),
      'sessionLength': serializer.toJson<int>(sessionLength),
      'answerMode': serializer.toJson<String>(
        $AppSettingsTable.$converteranswerMode.toJson(answerMode),
      ),
      'gameMode': serializer.toJson<bool>(gameMode),
      'streakFreeze': serializer.toJson<bool>(streakFreeze),
      'reminderEnabled': serializer.toJson<bool>(reminderEnabled),
      'reminderMinutes': serializer.toJson<int>(reminderMinutes),
      'accent': serializer.toJson<String>(
        $AppSettingsTable.$converteraccent.toJson(accent),
      ),
      'speechSpeed': serializer.toJson<String>(
        $AppSettingsTable.$converterspeechSpeed.toJson(speechSpeed),
      ),
      'lastBackupAt': serializer.toJson<DateTime?>(lastBackupAt),
    };
  }

  Settings copyWith({
    int? id,
    String? username,
    CefrLevel? levelNow,
    CefrLevel? levelGoal,
    int? dailyGoal,
    int? sessionLength,
    AnswerMode? answerMode,
    bool? gameMode,
    bool? streakFreeze,
    bool? reminderEnabled,
    int? reminderMinutes,
    Accent? accent,
    SpeechSpeed? speechSpeed,
    Value<DateTime?> lastBackupAt = const Value.absent(),
  }) => Settings(
    id: id ?? this.id,
    username: username ?? this.username,
    levelNow: levelNow ?? this.levelNow,
    levelGoal: levelGoal ?? this.levelGoal,
    dailyGoal: dailyGoal ?? this.dailyGoal,
    sessionLength: sessionLength ?? this.sessionLength,
    answerMode: answerMode ?? this.answerMode,
    gameMode: gameMode ?? this.gameMode,
    streakFreeze: streakFreeze ?? this.streakFreeze,
    reminderEnabled: reminderEnabled ?? this.reminderEnabled,
    reminderMinutes: reminderMinutes ?? this.reminderMinutes,
    accent: accent ?? this.accent,
    speechSpeed: speechSpeed ?? this.speechSpeed,
    lastBackupAt: lastBackupAt.present ? lastBackupAt.value : this.lastBackupAt,
  );
  Settings copyWithCompanion(AppSettingsCompanion data) {
    return Settings(
      id: data.id.present ? data.id.value : this.id,
      username: data.username.present ? data.username.value : this.username,
      levelNow: data.levelNow.present ? data.levelNow.value : this.levelNow,
      levelGoal: data.levelGoal.present ? data.levelGoal.value : this.levelGoal,
      dailyGoal: data.dailyGoal.present ? data.dailyGoal.value : this.dailyGoal,
      sessionLength: data.sessionLength.present
          ? data.sessionLength.value
          : this.sessionLength,
      answerMode: data.answerMode.present
          ? data.answerMode.value
          : this.answerMode,
      gameMode: data.gameMode.present ? data.gameMode.value : this.gameMode,
      streakFreeze: data.streakFreeze.present
          ? data.streakFreeze.value
          : this.streakFreeze,
      reminderEnabled: data.reminderEnabled.present
          ? data.reminderEnabled.value
          : this.reminderEnabled,
      reminderMinutes: data.reminderMinutes.present
          ? data.reminderMinutes.value
          : this.reminderMinutes,
      accent: data.accent.present ? data.accent.value : this.accent,
      speechSpeed: data.speechSpeed.present
          ? data.speechSpeed.value
          : this.speechSpeed,
      lastBackupAt: data.lastBackupAt.present
          ? data.lastBackupAt.value
          : this.lastBackupAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Settings(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('levelNow: $levelNow, ')
          ..write('levelGoal: $levelGoal, ')
          ..write('dailyGoal: $dailyGoal, ')
          ..write('sessionLength: $sessionLength, ')
          ..write('answerMode: $answerMode, ')
          ..write('gameMode: $gameMode, ')
          ..write('streakFreeze: $streakFreeze, ')
          ..write('reminderEnabled: $reminderEnabled, ')
          ..write('reminderMinutes: $reminderMinutes, ')
          ..write('accent: $accent, ')
          ..write('speechSpeed: $speechSpeed, ')
          ..write('lastBackupAt: $lastBackupAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    username,
    levelNow,
    levelGoal,
    dailyGoal,
    sessionLength,
    answerMode,
    gameMode,
    streakFreeze,
    reminderEnabled,
    reminderMinutes,
    accent,
    speechSpeed,
    lastBackupAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Settings &&
          other.id == this.id &&
          other.username == this.username &&
          other.levelNow == this.levelNow &&
          other.levelGoal == this.levelGoal &&
          other.dailyGoal == this.dailyGoal &&
          other.sessionLength == this.sessionLength &&
          other.answerMode == this.answerMode &&
          other.gameMode == this.gameMode &&
          other.streakFreeze == this.streakFreeze &&
          other.reminderEnabled == this.reminderEnabled &&
          other.reminderMinutes == this.reminderMinutes &&
          other.accent == this.accent &&
          other.speechSpeed == this.speechSpeed &&
          other.lastBackupAt == this.lastBackupAt);
}

class AppSettingsCompanion extends UpdateCompanion<Settings> {
  final Value<int> id;
  final Value<String> username;
  final Value<CefrLevel> levelNow;
  final Value<CefrLevel> levelGoal;
  final Value<int> dailyGoal;
  final Value<int> sessionLength;
  final Value<AnswerMode> answerMode;
  final Value<bool> gameMode;
  final Value<bool> streakFreeze;
  final Value<bool> reminderEnabled;
  final Value<int> reminderMinutes;
  final Value<Accent> accent;
  final Value<SpeechSpeed> speechSpeed;
  final Value<DateTime?> lastBackupAt;
  const AppSettingsCompanion({
    this.id = const Value.absent(),
    this.username = const Value.absent(),
    this.levelNow = const Value.absent(),
    this.levelGoal = const Value.absent(),
    this.dailyGoal = const Value.absent(),
    this.sessionLength = const Value.absent(),
    this.answerMode = const Value.absent(),
    this.gameMode = const Value.absent(),
    this.streakFreeze = const Value.absent(),
    this.reminderEnabled = const Value.absent(),
    this.reminderMinutes = const Value.absent(),
    this.accent = const Value.absent(),
    this.speechSpeed = const Value.absent(),
    this.lastBackupAt = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    this.id = const Value.absent(),
    this.username = const Value.absent(),
    this.levelNow = const Value.absent(),
    this.levelGoal = const Value.absent(),
    this.dailyGoal = const Value.absent(),
    this.sessionLength = const Value.absent(),
    this.answerMode = const Value.absent(),
    this.gameMode = const Value.absent(),
    this.streakFreeze = const Value.absent(),
    this.reminderEnabled = const Value.absent(),
    this.reminderMinutes = const Value.absent(),
    this.accent = const Value.absent(),
    this.speechSpeed = const Value.absent(),
    this.lastBackupAt = const Value.absent(),
  });
  static Insertable<Settings> custom({
    Expression<int>? id,
    Expression<String>? username,
    Expression<String>? levelNow,
    Expression<String>? levelGoal,
    Expression<int>? dailyGoal,
    Expression<int>? sessionLength,
    Expression<String>? answerMode,
    Expression<bool>? gameMode,
    Expression<bool>? streakFreeze,
    Expression<bool>? reminderEnabled,
    Expression<int>? reminderMinutes,
    Expression<String>? accent,
    Expression<String>? speechSpeed,
    Expression<DateTime>? lastBackupAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (username != null) 'username': username,
      if (levelNow != null) 'level_now': levelNow,
      if (levelGoal != null) 'level_goal': levelGoal,
      if (dailyGoal != null) 'daily_goal': dailyGoal,
      if (sessionLength != null) 'session_length': sessionLength,
      if (answerMode != null) 'answer_mode': answerMode,
      if (gameMode != null) 'game_mode': gameMode,
      if (streakFreeze != null) 'streak_freeze': streakFreeze,
      if (reminderEnabled != null) 'reminder_enabled': reminderEnabled,
      if (reminderMinutes != null) 'reminder_minutes': reminderMinutes,
      if (accent != null) 'accent': accent,
      if (speechSpeed != null) 'speech_speed': speechSpeed,
      if (lastBackupAt != null) 'last_backup_at': lastBackupAt,
    });
  }

  AppSettingsCompanion copyWith({
    Value<int>? id,
    Value<String>? username,
    Value<CefrLevel>? levelNow,
    Value<CefrLevel>? levelGoal,
    Value<int>? dailyGoal,
    Value<int>? sessionLength,
    Value<AnswerMode>? answerMode,
    Value<bool>? gameMode,
    Value<bool>? streakFreeze,
    Value<bool>? reminderEnabled,
    Value<int>? reminderMinutes,
    Value<Accent>? accent,
    Value<SpeechSpeed>? speechSpeed,
    Value<DateTime?>? lastBackupAt,
  }) {
    return AppSettingsCompanion(
      id: id ?? this.id,
      username: username ?? this.username,
      levelNow: levelNow ?? this.levelNow,
      levelGoal: levelGoal ?? this.levelGoal,
      dailyGoal: dailyGoal ?? this.dailyGoal,
      sessionLength: sessionLength ?? this.sessionLength,
      answerMode: answerMode ?? this.answerMode,
      gameMode: gameMode ?? this.gameMode,
      streakFreeze: streakFreeze ?? this.streakFreeze,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      reminderMinutes: reminderMinutes ?? this.reminderMinutes,
      accent: accent ?? this.accent,
      speechSpeed: speechSpeed ?? this.speechSpeed,
      lastBackupAt: lastBackupAt ?? this.lastBackupAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (levelNow.present) {
      map['level_now'] = Variable<String>(
        $AppSettingsTable.$converterlevelNow.toSql(levelNow.value),
      );
    }
    if (levelGoal.present) {
      map['level_goal'] = Variable<String>(
        $AppSettingsTable.$converterlevelGoal.toSql(levelGoal.value),
      );
    }
    if (dailyGoal.present) {
      map['daily_goal'] = Variable<int>(dailyGoal.value);
    }
    if (sessionLength.present) {
      map['session_length'] = Variable<int>(sessionLength.value);
    }
    if (answerMode.present) {
      map['answer_mode'] = Variable<String>(
        $AppSettingsTable.$converteranswerMode.toSql(answerMode.value),
      );
    }
    if (gameMode.present) {
      map['game_mode'] = Variable<bool>(gameMode.value);
    }
    if (streakFreeze.present) {
      map['streak_freeze'] = Variable<bool>(streakFreeze.value);
    }
    if (reminderEnabled.present) {
      map['reminder_enabled'] = Variable<bool>(reminderEnabled.value);
    }
    if (reminderMinutes.present) {
      map['reminder_minutes'] = Variable<int>(reminderMinutes.value);
    }
    if (accent.present) {
      map['accent'] = Variable<String>(
        $AppSettingsTable.$converteraccent.toSql(accent.value),
      );
    }
    if (speechSpeed.present) {
      map['speech_speed'] = Variable<String>(
        $AppSettingsTable.$converterspeechSpeed.toSql(speechSpeed.value),
      );
    }
    if (lastBackupAt.present) {
      map['last_backup_at'] = Variable<DateTime>(lastBackupAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('levelNow: $levelNow, ')
          ..write('levelGoal: $levelGoal, ')
          ..write('dailyGoal: $dailyGoal, ')
          ..write('sessionLength: $sessionLength, ')
          ..write('answerMode: $answerMode, ')
          ..write('gameMode: $gameMode, ')
          ..write('streakFreeze: $streakFreeze, ')
          ..write('reminderEnabled: $reminderEnabled, ')
          ..write('reminderMinutes: $reminderMinutes, ')
          ..write('accent: $accent, ')
          ..write('speechSpeed: $speechSpeed, ')
          ..write('lastBackupAt: $lastBackupAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ItemsTable items = $ItemsTable(this);
  late final $ItemLinksTable itemLinks = $ItemLinksTable(this);
  late final $RuleMistakesTable ruleMistakes = $RuleMistakesTable(this);
  late final $TagsTable tags = $TagsTable(this);
  late final $ItemTagsTable itemTags = $ItemTagsTable(this);
  late final $CollectionsTable collections = $CollectionsTable(this);
  late final $CollectionItemsTable collectionItems = $CollectionItemsTable(
    this,
  );
  late final $ReviewStatesTable reviewStates = $ReviewStatesTable(this);
  late final $ReviewLogsTable reviewLogs = $ReviewLogsTable(this);
  late final $XpEventsTable xpEvents = $XpEventsTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    items,
    itemLinks,
    ruleMistakes,
    tags,
    itemTags,
    collections,
    collectionItems,
    reviewStates,
    reviewLogs,
    xpEvents,
    appSettings,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'items',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('item_links', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'items',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('item_links', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'items',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('rule_mistakes', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'items',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('item_tags', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'tags',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('item_tags', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'collections',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('collection_items', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'items',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('collection_items', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'items',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('review_states', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'items',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('review_logs', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'items',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('xp_events', kind: UpdateKind.update)],
    ),
  ]);
}

typedef $$ItemsTableCreateCompanionBuilder = ItemsCompanion Function({
  Value<int> id,
  required ItemType type,
  required String english,
  Value<String> hungarian,
  Value<String?> notes,
  Value<PartOfSpeech?> partOfSpeech,
  Value<PhraseKind?> phraseKind,
  Value<String?> ipa,
  Value<CefrLevel?> level,
  Value<String?> source,
  Value<String?> ruleCategory,
  Value<List<FormulaBlock>> formula,
  Value<String?> trapNote,
  Value<bool> isFavorite,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$ItemsTableUpdateCompanionBuilder = ItemsCompanion Function({
  Value<int> id,
  Value<ItemType> type,
  Value<String> english,
  Value<String> hungarian,
  Value<String?> notes,
  Value<PartOfSpeech?> partOfSpeech,
  Value<PhraseKind?> phraseKind,
  Value<String?> ipa,
  Value<CefrLevel?> level,
  Value<String?> source,
  Value<String?> ruleCategory,
  Value<List<FormulaBlock>> formula,
  Value<String?> trapNote,
  Value<bool> isFavorite,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$ItemsTableReferences
    extends BaseReferences<_$AppDatabase, $ItemsTable, Item> {
  $$ItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ItemLinksTable, List<ItemLink>>
  _outgoingLinksTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.itemLinks,
    aliasName: 'items__id__item_links__parent_id',
  );

  $$ItemLinksTableProcessedTableManager get outgoingLinks {
    final manager = $$ItemLinksTableTableManager(
      $_db,
      $_db.itemLinks,
    ).filter((f) => f.parentId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_outgoingLinksTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ItemLinksTable, List<ItemLink>>
  _incomingLinksTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.itemLinks,
    aliasName: 'items__id__item_links__child_id',
  );

  $$ItemLinksTableProcessedTableManager get incomingLinks {
    final manager = $$ItemLinksTableTableManager(
      $_db,
      $_db.itemLinks,
    ).filter((f) => f.childId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_incomingLinksTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RuleMistakesTable, List<RuleMistake>>
  _ruleMistakesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.ruleMistakes,
    aliasName: 'items__id__rule_mistakes__rule_id',
  );

  $$RuleMistakesTableProcessedTableManager get ruleMistakesRefs {
    final manager = $$RuleMistakesTableTableManager(
      $_db,
      $_db.ruleMistakes,
    ).filter((f) => f.ruleId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_ruleMistakesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ItemTagsTable, List<ItemTag>> _itemTagsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.itemTags,
    aliasName: 'items__id__item_tags__item_id',
  );

  $$ItemTagsTableProcessedTableManager get itemTagsRefs {
    final manager = $$ItemTagsTableTableManager(
      $_db,
      $_db.itemTags,
    ).filter((f) => f.itemId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_itemTagsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CollectionItemsTable, List<CollectionItem>>
  _collectionItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.collectionItems,
    aliasName: 'items__id__collection_items__item_id',
  );

  $$CollectionItemsTableProcessedTableManager get collectionItemsRefs {
    final manager = $$CollectionItemsTableTableManager(
      $_db,
      $_db.collectionItems,
    ).filter((f) => f.itemId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _collectionItemsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ReviewStatesTable, List<ReviewState>>
  _reviewStatesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.reviewStates,
    aliasName: 'items__id__review_states__item_id',
  );

  $$ReviewStatesTableProcessedTableManager get reviewStatesRefs {
    final manager = $$ReviewStatesTableTableManager(
      $_db,
      $_db.reviewStates,
    ).filter((f) => f.itemId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_reviewStatesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ReviewLogsTable, List<ReviewLog>>
  _reviewLogsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.reviewLogs,
    aliasName: 'items__id__review_logs__item_id',
  );

  $$ReviewLogsTableProcessedTableManager get reviewLogsRefs {
    final manager = $$ReviewLogsTableTableManager(
      $_db,
      $_db.reviewLogs,
    ).filter((f) => f.itemId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_reviewLogsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$XpEventsTable, List<XpEvent>> _xpEventsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.xpEvents,
    aliasName: 'items__id__xp_events__item_id',
  );

  $$XpEventsTableProcessedTableManager get xpEventsRefs {
    final manager = $$XpEventsTableTableManager(
      $_db,
      $_db.xpEvents,
    ).filter((f) => f.itemId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_xpEventsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ItemsTableFilterComposer extends Composer<_$AppDatabase, $ItemsTable> {
  $$ItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ItemType, ItemType, String> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get english => $composableBuilder(
    column: $table.english,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hungarian => $composableBuilder(
    column: $table.hungarian,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<PartOfSpeech?, PartOfSpeech, String>
  get partOfSpeech => $composableBuilder(
    column: $table.partOfSpeech,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<PhraseKind?, PhraseKind, String>
  get phraseKind => $composableBuilder(
    column: $table.phraseKind,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get ipa => $composableBuilder(
    column: $table.ipa,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<CefrLevel?, CefrLevel, String> get level =>
      $composableBuilder(
        column: $table.level,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ruleCategory => $composableBuilder(
    column: $table.ruleCategory,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<FormulaBlock>, List<FormulaBlock>, String>
  get formula => $composableBuilder(
    column: $table.formula,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get trapNote => $composableBuilder(
    column: $table.trapNote,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> outgoingLinks(
    Expression<bool> Function($$ItemLinksTableFilterComposer f) f,
  ) {
    final $$ItemLinksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.itemLinks,
      getReferencedColumn: (t) => t.parentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemLinksTableFilterComposer(
            $db: $db,
            $table: $db.itemLinks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> incomingLinks(
    Expression<bool> Function($$ItemLinksTableFilterComposer f) f,
  ) {
    final $$ItemLinksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.itemLinks,
      getReferencedColumn: (t) => t.childId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemLinksTableFilterComposer(
            $db: $db,
            $table: $db.itemLinks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> ruleMistakesRefs(
    Expression<bool> Function($$RuleMistakesTableFilterComposer f) f,
  ) {
    final $$RuleMistakesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ruleMistakes,
      getReferencedColumn: (t) => t.ruleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RuleMistakesTableFilterComposer(
            $db: $db,
            $table: $db.ruleMistakes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> itemTagsRefs(
    Expression<bool> Function($$ItemTagsTableFilterComposer f) f,
  ) {
    final $$ItemTagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.itemTags,
      getReferencedColumn: (t) => t.itemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemTagsTableFilterComposer(
            $db: $db,
            $table: $db.itemTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> collectionItemsRefs(
    Expression<bool> Function($$CollectionItemsTableFilterComposer f) f,
  ) {
    final $$CollectionItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.collectionItems,
      getReferencedColumn: (t) => t.itemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CollectionItemsTableFilterComposer(
            $db: $db,
            $table: $db.collectionItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> reviewStatesRefs(
    Expression<bool> Function($$ReviewStatesTableFilterComposer f) f,
  ) {
    final $$ReviewStatesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reviewStates,
      getReferencedColumn: (t) => t.itemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReviewStatesTableFilterComposer(
            $db: $db,
            $table: $db.reviewStates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> reviewLogsRefs(
    Expression<bool> Function($$ReviewLogsTableFilterComposer f) f,
  ) {
    final $$ReviewLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reviewLogs,
      getReferencedColumn: (t) => t.itemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReviewLogsTableFilterComposer(
            $db: $db,
            $table: $db.reviewLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> xpEventsRefs(
    Expression<bool> Function($$XpEventsTableFilterComposer f) f,
  ) {
    final $$XpEventsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.xpEvents,
      getReferencedColumn: (t) => t.itemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$XpEventsTableFilterComposer(
            $db: $db,
            $table: $db.xpEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $ItemsTable> {
  $$ItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get english => $composableBuilder(
    column: $table.english,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hungarian => $composableBuilder(
    column: $table.hungarian,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get partOfSpeech => $composableBuilder(
    column: $table.partOfSpeech,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phraseKind => $composableBuilder(
    column: $table.phraseKind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ipa => $composableBuilder(
    column: $table.ipa,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ruleCategory => $composableBuilder(
    column: $table.ruleCategory,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get formula => $composableBuilder(
    column: $table.formula,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get trapNote => $composableBuilder(
    column: $table.trapNote,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ItemsTable> {
  $$ItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ItemType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get english =>
      $composableBuilder(column: $table.english, builder: (column) => column);

  GeneratedColumn<String> get hungarian =>
      $composableBuilder(column: $table.hungarian, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumnWithTypeConverter<PartOfSpeech?, String> get partOfSpeech =>
      $composableBuilder(
        column: $table.partOfSpeech,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<PhraseKind?, String> get phraseKind =>
      $composableBuilder(
        column: $table.phraseKind,
        builder: (column) => column,
      );

  GeneratedColumn<String> get ipa =>
      $composableBuilder(column: $table.ipa, builder: (column) => column);

  GeneratedColumnWithTypeConverter<CefrLevel?, String> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get ruleCategory => $composableBuilder(
    column: $table.ruleCategory,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<List<FormulaBlock>, String> get formula =>
      $composableBuilder(column: $table.formula, builder: (column) => column);

  GeneratedColumn<String> get trapNote =>
      $composableBuilder(column: $table.trapNote, builder: (column) => column);

  GeneratedColumn<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> outgoingLinks<T extends Object>(
    Expression<T> Function($$ItemLinksTableAnnotationComposer a) f,
  ) {
    final $$ItemLinksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.itemLinks,
      getReferencedColumn: (t) => t.parentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemLinksTableAnnotationComposer(
            $db: $db,
            $table: $db.itemLinks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> incomingLinks<T extends Object>(
    Expression<T> Function($$ItemLinksTableAnnotationComposer a) f,
  ) {
    final $$ItemLinksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.itemLinks,
      getReferencedColumn: (t) => t.childId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemLinksTableAnnotationComposer(
            $db: $db,
            $table: $db.itemLinks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> ruleMistakesRefs<T extends Object>(
    Expression<T> Function($$RuleMistakesTableAnnotationComposer a) f,
  ) {
    final $$RuleMistakesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ruleMistakes,
      getReferencedColumn: (t) => t.ruleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RuleMistakesTableAnnotationComposer(
            $db: $db,
            $table: $db.ruleMistakes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> itemTagsRefs<T extends Object>(
    Expression<T> Function($$ItemTagsTableAnnotationComposer a) f,
  ) {
    final $$ItemTagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.itemTags,
      getReferencedColumn: (t) => t.itemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemTagsTableAnnotationComposer(
            $db: $db,
            $table: $db.itemTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> collectionItemsRefs<T extends Object>(
    Expression<T> Function($$CollectionItemsTableAnnotationComposer a) f,
  ) {
    final $$CollectionItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.collectionItems,
      getReferencedColumn: (t) => t.itemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CollectionItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.collectionItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> reviewStatesRefs<T extends Object>(
    Expression<T> Function($$ReviewStatesTableAnnotationComposer a) f,
  ) {
    final $$ReviewStatesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reviewStates,
      getReferencedColumn: (t) => t.itemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReviewStatesTableAnnotationComposer(
            $db: $db,
            $table: $db.reviewStates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> reviewLogsRefs<T extends Object>(
    Expression<T> Function($$ReviewLogsTableAnnotationComposer a) f,
  ) {
    final $$ReviewLogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reviewLogs,
      getReferencedColumn: (t) => t.itemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReviewLogsTableAnnotationComposer(
            $db: $db,
            $table: $db.reviewLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> xpEventsRefs<T extends Object>(
    Expression<T> Function($$XpEventsTableAnnotationComposer a) f,
  ) {
    final $$XpEventsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.xpEvents,
      getReferencedColumn: (t) => t.itemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$XpEventsTableAnnotationComposer(
            $db: $db,
            $table: $db.xpEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ItemsTable,
          Item,
          $$ItemsTableFilterComposer,
          $$ItemsTableOrderingComposer,
          $$ItemsTableAnnotationComposer,
          $$ItemsTableCreateCompanionBuilder,
          $$ItemsTableUpdateCompanionBuilder,
          (Item, $$ItemsTableReferences),
          Item,
          PrefetchHooks Function({
            bool outgoingLinks,
            bool incomingLinks,
            bool ruleMistakesRefs,
            bool itemTagsRefs,
            bool collectionItemsRefs,
            bool reviewStatesRefs,
            bool reviewLogsRefs,
            bool xpEventsRefs,
          })
        > {
  $$ItemsTableTableManager(_$AppDatabase db, $ItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<ItemType> type = const Value.absent(),
                Value<String> english = const Value.absent(),
                Value<String> hungarian = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<PartOfSpeech?> partOfSpeech = const Value.absent(),
                Value<PhraseKind?> phraseKind = const Value.absent(),
                Value<String?> ipa = const Value.absent(),
                Value<CefrLevel?> level = const Value.absent(),
                Value<String?> source = const Value.absent(),
                Value<String?> ruleCategory = const Value.absent(),
                Value<List<FormulaBlock>> formula = const Value.absent(),
                Value<String?> trapNote = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ItemsCompanion(
                id: id,
                type: type,
                english: english,
                hungarian: hungarian,
                notes: notes,
                partOfSpeech: partOfSpeech,
                phraseKind: phraseKind,
                ipa: ipa,
                level: level,
                source: source,
                ruleCategory: ruleCategory,
                formula: formula,
                trapNote: trapNote,
                isFavorite: isFavorite,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required ItemType type,
                required String english,
                Value<String> hungarian = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<PartOfSpeech?> partOfSpeech = const Value.absent(),
                Value<PhraseKind?> phraseKind = const Value.absent(),
                Value<String?> ipa = const Value.absent(),
                Value<CefrLevel?> level = const Value.absent(),
                Value<String?> source = const Value.absent(),
                Value<String?> ruleCategory = const Value.absent(),
                Value<List<FormulaBlock>> formula = const Value.absent(),
                Value<String?> trapNote = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ItemsCompanion.insert(
                id: id,
                type: type,
                english: english,
                hungarian: hungarian,
                notes: notes,
                partOfSpeech: partOfSpeech,
                phraseKind: phraseKind,
                ipa: ipa,
                level: level,
                source: source,
                ruleCategory: ruleCategory,
                formula: formula,
                trapNote: trapNote,
                isFavorite: isFavorite,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ItemsTable, Item>(table),
                  $$ItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                outgoingLinks = false,
                incomingLinks = false,
                ruleMistakesRefs = false,
                itemTagsRefs = false,
                collectionItemsRefs = false,
                reviewStatesRefs = false,
                reviewLogsRefs = false,
                xpEventsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (outgoingLinks) db.itemLinks,
                    if (incomingLinks) db.itemLinks,
                    if (ruleMistakesRefs) db.ruleMistakes,
                    if (itemTagsRefs) db.itemTags,
                    if (collectionItemsRefs) db.collectionItems,
                    if (reviewStatesRefs) db.reviewStates,
                    if (reviewLogsRefs) db.reviewLogs,
                    if (xpEventsRefs) db.xpEvents,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (outgoingLinks)
                        await $_getPrefetchedDataByColumns<
                          Item,
                          $ItemsTable,
                          ItemLink,
                          $ItemLinksTable
                        >(
                          currentTable: table,
                          referencedTable: $$ItemsTableReferences
                              ._outgoingLinksTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ItemsTableReferences(
                                db,
                                table,
                                p0,
                              ).outgoingLinks,
                          currentColumn: 'id',
                          referencedColumn: 'parent_id',
                          typedResults: items,
                        ),
                      if (incomingLinks)
                        await $_getPrefetchedDataByColumns<
                          Item,
                          $ItemsTable,
                          ItemLink,
                          $ItemLinksTable
                        >(
                          currentTable: table,
                          referencedTable: $$ItemsTableReferences
                              ._incomingLinksTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ItemsTableReferences(
                                db,
                                table,
                                p0,
                              ).incomingLinks,
                          currentColumn: 'id',
                          referencedColumn: 'child_id',
                          typedResults: items,
                        ),
                      if (ruleMistakesRefs)
                        await $_getPrefetchedDataByColumns<
                          Item,
                          $ItemsTable,
                          RuleMistake,
                          $RuleMistakesTable
                        >(
                          currentTable: table,
                          referencedTable: $$ItemsTableReferences
                              ._ruleMistakesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ItemsTableReferences(
                                db,
                                table,
                                p0,
                              ).ruleMistakesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'rule_id',
                          typedResults: items,
                        ),
                      if (itemTagsRefs)
                        await $_getPrefetchedDataByColumns<
                          Item,
                          $ItemsTable,
                          ItemTag,
                          $ItemTagsTable
                        >(
                          currentTable: table,
                          referencedTable: $$ItemsTableReferences
                              ._itemTagsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ItemsTableReferences(
                                db,
                                table,
                                p0,
                              ).itemTagsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'item_id',
                          typedResults: items,
                        ),
                      if (collectionItemsRefs)
                        await $_getPrefetchedDataByColumns<
                          Item,
                          $ItemsTable,
                          CollectionItem,
                          $CollectionItemsTable
                        >(
                          currentTable: table,
                          referencedTable: $$ItemsTableReferences
                              ._collectionItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ItemsTableReferences(
                                db,
                                table,
                                p0,
                              ).collectionItemsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'item_id',
                          typedResults: items,
                        ),
                      if (reviewStatesRefs)
                        await $_getPrefetchedDataByColumns<
                          Item,
                          $ItemsTable,
                          ReviewState,
                          $ReviewStatesTable
                        >(
                          currentTable: table,
                          referencedTable: $$ItemsTableReferences
                              ._reviewStatesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ItemsTableReferences(
                                db,
                                table,
                                p0,
                              ).reviewStatesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'item_id',
                          typedResults: items,
                        ),
                      if (reviewLogsRefs)
                        await $_getPrefetchedDataByColumns<
                          Item,
                          $ItemsTable,
                          ReviewLog,
                          $ReviewLogsTable
                        >(
                          currentTable: table,
                          referencedTable: $$ItemsTableReferences
                              ._reviewLogsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ItemsTableReferences(
                                db,
                                table,
                                p0,
                              ).reviewLogsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'item_id',
                          typedResults: items,
                        ),
                      if (xpEventsRefs)
                        await $_getPrefetchedDataByColumns<
                          Item,
                          $ItemsTable,
                          XpEvent,
                          $XpEventsTable
                        >(
                          currentTable: table,
                          referencedTable: $$ItemsTableReferences
                              ._xpEventsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ItemsTableReferences(
                                db,
                                table,
                                p0,
                              ).xpEventsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'item_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ItemsTable,
      Item,
      $$ItemsTableFilterComposer,
      $$ItemsTableOrderingComposer,
      $$ItemsTableAnnotationComposer,
      $$ItemsTableCreateCompanionBuilder,
      $$ItemsTableUpdateCompanionBuilder,
      (Item, $$ItemsTableReferences),
      Item,
      PrefetchHooks Function({
        bool outgoingLinks,
        bool incomingLinks,
        bool ruleMistakesRefs,
        bool itemTagsRefs,
        bool collectionItemsRefs,
        bool reviewStatesRefs,
        bool reviewLogsRefs,
        bool xpEventsRefs,
      })
    >;
typedef $$ItemLinksTableCreateCompanionBuilder = ItemLinksCompanion Function({
  required int parentId,
  required int childId,
  required LinkRole role,
  Value<int> position,
  Value<int> rowid,
});
typedef $$ItemLinksTableUpdateCompanionBuilder = ItemLinksCompanion Function({
  Value<int> parentId,
  Value<int> childId,
  Value<LinkRole> role,
  Value<int> position,
  Value<int> rowid,
});

final class $$ItemLinksTableReferences
    extends BaseReferences<_$AppDatabase, $ItemLinksTable, ItemLink> {
  $$ItemLinksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ItemsTable _parentIdTable(_$AppDatabase db) =>
      db.items.createAlias('item_links__parent_id__items__id');

  $$ItemsTableProcessedTableManager get parentId {
    final $_column = $_itemColumn<int>('parent_id')!;

    final manager = $$ItemsTableTableManager(
      $_db,
      $_db.items,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_parentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ItemsTable _childIdTable(_$AppDatabase db) =>
      db.items.createAlias('item_links__child_id__items__id');

  $$ItemsTableProcessedTableManager get childId {
    final $_column = $_itemColumn<int>('child_id')!;

    final manager = $$ItemsTableTableManager(
      $_db,
      $_db.items,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_childIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ItemLinksTableFilterComposer
    extends Composer<_$AppDatabase, $ItemLinksTable> {
  $$ItemLinksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnWithTypeConverterFilters<LinkRole, LinkRole, String> get role =>
      $composableBuilder(
        column: $table.role,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  $$ItemsTableFilterComposer get parentId {
    final $$ItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableFilterComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ItemsTableFilterComposer get childId {
    final $$ItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.childId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableFilterComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ItemLinksTableOrderingComposer
    extends Composer<_$AppDatabase, $ItemLinksTable> {
  $$ItemLinksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  $$ItemsTableOrderingComposer get parentId {
    final $$ItemsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableOrderingComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ItemsTableOrderingComposer get childId {
    final $$ItemsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.childId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableOrderingComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ItemLinksTableAnnotationComposer
    extends Composer<_$AppDatabase, $ItemLinksTable> {
  $$ItemLinksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumnWithTypeConverter<LinkRole, String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  $$ItemsTableAnnotationComposer get parentId {
    final $$ItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ItemsTableAnnotationComposer get childId {
    final $$ItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.childId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ItemLinksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ItemLinksTable,
          ItemLink,
          $$ItemLinksTableFilterComposer,
          $$ItemLinksTableOrderingComposer,
          $$ItemLinksTableAnnotationComposer,
          $$ItemLinksTableCreateCompanionBuilder,
          $$ItemLinksTableUpdateCompanionBuilder,
          (ItemLink, $$ItemLinksTableReferences),
          ItemLink,
          PrefetchHooks Function({bool parentId, bool childId})
        > {
  $$ItemLinksTableTableManager(_$AppDatabase db, $ItemLinksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ItemLinksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ItemLinksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ItemLinksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> parentId = const Value.absent(),
                Value<int> childId = const Value.absent(),
                Value<LinkRole> role = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ItemLinksCompanion(
                parentId: parentId,
                childId: childId,
                role: role,
                position: position,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int parentId,
                required int childId,
                required LinkRole role,
                Value<int> position = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ItemLinksCompanion.insert(
                parentId: parentId,
                childId: childId,
                role: role,
                position: position,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ItemLinksTable, ItemLink>(table),
                  $$ItemLinksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({parentId = false, childId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (parentId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.parentId,
                        referencedTable: $$ItemLinksTableReferences
                            ._parentIdTable(db),
                        referencedColumn: $$ItemLinksTableReferences
                            ._parentIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (childId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.childId,
                        referencedTable: $$ItemLinksTableReferences
                            ._childIdTable(db),
                        referencedColumn: $$ItemLinksTableReferences
                            ._childIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ItemLinksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ItemLinksTable,
      ItemLink,
      $$ItemLinksTableFilterComposer,
      $$ItemLinksTableOrderingComposer,
      $$ItemLinksTableAnnotationComposer,
      $$ItemLinksTableCreateCompanionBuilder,
      $$ItemLinksTableUpdateCompanionBuilder,
      (ItemLink, $$ItemLinksTableReferences),
      ItemLink,
      PrefetchHooks Function({bool parentId, bool childId})
    >;
typedef $$RuleMistakesTableCreateCompanionBuilder =
    RuleMistakesCompanion Function({
      Value<int> id,
      required int ruleId,
      required String wrong,
      Value<String?> explanation,
      Value<int> position,
    });
typedef $$RuleMistakesTableUpdateCompanionBuilder =
    RuleMistakesCompanion Function({
      Value<int> id,
      Value<int> ruleId,
      Value<String> wrong,
      Value<String?> explanation,
      Value<int> position,
    });

final class $$RuleMistakesTableReferences
    extends BaseReferences<_$AppDatabase, $RuleMistakesTable, RuleMistake> {
  $$RuleMistakesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ItemsTable _ruleIdTable(_$AppDatabase db) =>
      db.items.createAlias('rule_mistakes__rule_id__items__id');

  $$ItemsTableProcessedTableManager get ruleId {
    final $_column = $_itemColumn<int>('rule_id')!;

    final manager = $$ItemsTableTableManager(
      $_db,
      $_db.items,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ruleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RuleMistakesTableFilterComposer
    extends Composer<_$AppDatabase, $RuleMistakesTable> {
  $$RuleMistakesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get wrong => $composableBuilder(
    column: $table.wrong,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get explanation => $composableBuilder(
    column: $table.explanation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  $$ItemsTableFilterComposer get ruleId {
    final $$ItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ruleId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableFilterComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RuleMistakesTableOrderingComposer
    extends Composer<_$AppDatabase, $RuleMistakesTable> {
  $$RuleMistakesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get wrong => $composableBuilder(
    column: $table.wrong,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get explanation => $composableBuilder(
    column: $table.explanation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  $$ItemsTableOrderingComposer get ruleId {
    final $$ItemsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ruleId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableOrderingComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RuleMistakesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RuleMistakesTable> {
  $$RuleMistakesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get wrong =>
      $composableBuilder(column: $table.wrong, builder: (column) => column);

  GeneratedColumn<String> get explanation => $composableBuilder(
    column: $table.explanation,
    builder: (column) => column,
  );

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  $$ItemsTableAnnotationComposer get ruleId {
    final $$ItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ruleId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RuleMistakesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RuleMistakesTable,
          RuleMistake,
          $$RuleMistakesTableFilterComposer,
          $$RuleMistakesTableOrderingComposer,
          $$RuleMistakesTableAnnotationComposer,
          $$RuleMistakesTableCreateCompanionBuilder,
          $$RuleMistakesTableUpdateCompanionBuilder,
          (RuleMistake, $$RuleMistakesTableReferences),
          RuleMistake,
          PrefetchHooks Function({bool ruleId})
        > {
  $$RuleMistakesTableTableManager(_$AppDatabase db, $RuleMistakesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RuleMistakesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RuleMistakesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RuleMistakesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> ruleId = const Value.absent(),
                Value<String> wrong = const Value.absent(),
                Value<String?> explanation = const Value.absent(),
                Value<int> position = const Value.absent(),
              }) => RuleMistakesCompanion(
                id: id,
                ruleId: ruleId,
                wrong: wrong,
                explanation: explanation,
                position: position,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int ruleId,
                required String wrong,
                Value<String?> explanation = const Value.absent(),
                Value<int> position = const Value.absent(),
              }) => RuleMistakesCompanion.insert(
                id: id,
                ruleId: ruleId,
                wrong: wrong,
                explanation: explanation,
                position: position,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RuleMistakesTable, RuleMistake>(table),
                  $$RuleMistakesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({ruleId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (ruleId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.ruleId,
                        referencedTable: $$RuleMistakesTableReferences
                            ._ruleIdTable(db),
                        referencedColumn: $$RuleMistakesTableReferences
                            ._ruleIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RuleMistakesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RuleMistakesTable,
      RuleMistake,
      $$RuleMistakesTableFilterComposer,
      $$RuleMistakesTableOrderingComposer,
      $$RuleMistakesTableAnnotationComposer,
      $$RuleMistakesTableCreateCompanionBuilder,
      $$RuleMistakesTableUpdateCompanionBuilder,
      (RuleMistake, $$RuleMistakesTableReferences),
      RuleMistake,
      PrefetchHooks Function({bool ruleId})
    >;
typedef $$TagsTableCreateCompanionBuilder = TagsCompanion Function({
  Value<int> id,
  required String name,
});
typedef $$TagsTableUpdateCompanionBuilder = TagsCompanion Function({
  Value<int> id,
  Value<String> name,
});

final class $$TagsTableReferences
    extends BaseReferences<_$AppDatabase, $TagsTable, Tag> {
  $$TagsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ItemTagsTable, List<ItemTag>> _itemTagsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.itemTags,
    aliasName: 'tags__id__item_tags__tag_id',
  );

  $$ItemTagsTableProcessedTableManager get itemTagsRefs {
    final manager = $$ItemTagsTableTableManager(
      $_db,
      $_db.itemTags,
    ).filter((f) => f.tagId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_itemTagsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TagsTableFilterComposer extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> itemTagsRefs(
    Expression<bool> Function($$ItemTagsTableFilterComposer f) f,
  ) {
    final $$ItemTagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.itemTags,
      getReferencedColumn: (t) => t.tagId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemTagsTableFilterComposer(
            $db: $db,
            $table: $db.itemTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TagsTableOrderingComposer extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  Expression<T> itemTagsRefs<T extends Object>(
    Expression<T> Function($$ItemTagsTableAnnotationComposer a) f,
  ) {
    final $$ItemTagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.itemTags,
      getReferencedColumn: (t) => t.tagId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemTagsTableAnnotationComposer(
            $db: $db,
            $table: $db.itemTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TagsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TagsTable,
          Tag,
          $$TagsTableFilterComposer,
          $$TagsTableOrderingComposer,
          $$TagsTableAnnotationComposer,
          $$TagsTableCreateCompanionBuilder,
          $$TagsTableUpdateCompanionBuilder,
          (Tag, $$TagsTableReferences),
          Tag,
          PrefetchHooks Function({bool itemTagsRefs})
        > {
  $$TagsTableTableManager(_$AppDatabase db, $TagsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
          }) => TagsCompanion(id: id, name: name),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
          }) => TagsCompanion.insert(id: id, name: name),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TagsTable, Tag>(table),
                  $$TagsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({itemTagsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (itemTagsRefs) db.itemTags],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (itemTagsRefs)
                    await $_getPrefetchedDataByColumns<
                      Tag,
                      $TagsTable,
                      ItemTag,
                      $ItemTagsTable
                    >(
                      currentTable: table,
                      referencedTable: $$TagsTableReferences._itemTagsRefsTable(
                        db,
                      ),
                      managerFromTypedResult: (p0) =>
                          $$TagsTableReferences(db, table, p0).itemTagsRefs,
                      currentColumn: 'id',
                      referencedColumn: 'tag_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$TagsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TagsTable,
      Tag,
      $$TagsTableFilterComposer,
      $$TagsTableOrderingComposer,
      $$TagsTableAnnotationComposer,
      $$TagsTableCreateCompanionBuilder,
      $$TagsTableUpdateCompanionBuilder,
      (Tag, $$TagsTableReferences),
      Tag,
      PrefetchHooks Function({bool itemTagsRefs})
    >;
typedef $$ItemTagsTableCreateCompanionBuilder = ItemTagsCompanion Function({
  required int itemId,
  required int tagId,
  Value<int> rowid,
});
typedef $$ItemTagsTableUpdateCompanionBuilder = ItemTagsCompanion Function({
  Value<int> itemId,
  Value<int> tagId,
  Value<int> rowid,
});

final class $$ItemTagsTableReferences
    extends BaseReferences<_$AppDatabase, $ItemTagsTable, ItemTag> {
  $$ItemTagsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ItemsTable _itemIdTable(_$AppDatabase db) =>
      db.items.createAlias('item_tags__item_id__items__id');

  $$ItemsTableProcessedTableManager get itemId {
    final $_column = $_itemColumn<int>('item_id')!;

    final manager = $$ItemsTableTableManager(
      $_db,
      $_db.items,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_itemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TagsTable _tagIdTable(_$AppDatabase db) =>
      db.tags.createAlias('item_tags__tag_id__tags__id');

  $$TagsTableProcessedTableManager get tagId {
    final $_column = $_itemColumn<int>('tag_id')!;

    final manager = $$TagsTableTableManager(
      $_db,
      $_db.tags,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tagIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ItemTagsTableFilterComposer
    extends Composer<_$AppDatabase, $ItemTagsTable> {
  $$ItemTagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$ItemsTableFilterComposer get itemId {
    final $$ItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableFilterComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TagsTableFilterComposer get tagId {
    final $$TagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableFilterComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ItemTagsTableOrderingComposer
    extends Composer<_$AppDatabase, $ItemTagsTable> {
  $$ItemTagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$ItemsTableOrderingComposer get itemId {
    final $$ItemsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableOrderingComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TagsTableOrderingComposer get tagId {
    final $$TagsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableOrderingComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ItemTagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ItemTagsTable> {
  $$ItemTagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$ItemsTableAnnotationComposer get itemId {
    final $$ItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TagsTableAnnotationComposer get tagId {
    final $$TagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableAnnotationComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ItemTagsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ItemTagsTable,
          ItemTag,
          $$ItemTagsTableFilterComposer,
          $$ItemTagsTableOrderingComposer,
          $$ItemTagsTableAnnotationComposer,
          $$ItemTagsTableCreateCompanionBuilder,
          $$ItemTagsTableUpdateCompanionBuilder,
          (ItemTag, $$ItemTagsTableReferences),
          ItemTag,
          PrefetchHooks Function({bool itemId, bool tagId})
        > {
  $$ItemTagsTableTableManager(_$AppDatabase db, $ItemTagsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ItemTagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ItemTagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ItemTagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> itemId = const Value.absent(),
            Value<int> tagId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => ItemTagsCompanion(itemId: itemId, tagId: tagId, rowid: rowid),
          createCompanionCallback:
              ({
                required int itemId,
                required int tagId,
                Value<int> rowid = const Value.absent(),
              }) => ItemTagsCompanion.insert(
                itemId: itemId,
                tagId: tagId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ItemTagsTable, ItemTag>(table),
                  $$ItemTagsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({itemId = false, tagId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (itemId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.itemId,
                        referencedTable: $$ItemTagsTableReferences._itemIdTable(
                          db,
                        ),
                        referencedColumn: $$ItemTagsTableReferences
                            ._itemIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (tagId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.tagId,
                        referencedTable: $$ItemTagsTableReferences._tagIdTable(
                          db,
                        ),
                        referencedColumn: $$ItemTagsTableReferences
                            ._tagIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ItemTagsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ItemTagsTable,
      ItemTag,
      $$ItemTagsTableFilterComposer,
      $$ItemTagsTableOrderingComposer,
      $$ItemTagsTableAnnotationComposer,
      $$ItemTagsTableCreateCompanionBuilder,
      $$ItemTagsTableUpdateCompanionBuilder,
      (ItemTag, $$ItemTagsTableReferences),
      ItemTag,
      PrefetchHooks Function({bool itemId, bool tagId})
    >;
typedef $$CollectionsTableCreateCompanionBuilder =
    CollectionsCompanion Function({
      Value<int> id,
      required String name,
      Value<String> icon,
      Value<int> color,
      Value<DateTime> createdAt,
    });
typedef $$CollectionsTableUpdateCompanionBuilder =
    CollectionsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> icon,
      Value<int> color,
      Value<DateTime> createdAt,
    });

final class $$CollectionsTableReferences
    extends BaseReferences<_$AppDatabase, $CollectionsTable, Collection> {
  $$CollectionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$CollectionItemsTable, List<CollectionItem>>
  _collectionItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.collectionItems,
    aliasName: 'collections__id__collection_items__collection_id',
  );

  $$CollectionItemsTableProcessedTableManager get collectionItemsRefs {
    final manager = $$CollectionItemsTableTableManager(
      $_db,
      $_db.collectionItems,
    ).filter((f) => f.collectionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _collectionItemsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CollectionsTableFilterComposer
    extends Composer<_$AppDatabase, $CollectionsTable> {
  $$CollectionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> collectionItemsRefs(
    Expression<bool> Function($$CollectionItemsTableFilterComposer f) f,
  ) {
    final $$CollectionItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.collectionItems,
      getReferencedColumn: (t) => t.collectionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CollectionItemsTableFilterComposer(
            $db: $db,
            $table: $db.collectionItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CollectionsTableOrderingComposer
    extends Composer<_$AppDatabase, $CollectionsTable> {
  $$CollectionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CollectionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CollectionsTable> {
  $$CollectionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<int> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> collectionItemsRefs<T extends Object>(
    Expression<T> Function($$CollectionItemsTableAnnotationComposer a) f,
  ) {
    final $$CollectionItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.collectionItems,
      getReferencedColumn: (t) => t.collectionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CollectionItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.collectionItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CollectionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CollectionsTable,
          Collection,
          $$CollectionsTableFilterComposer,
          $$CollectionsTableOrderingComposer,
          $$CollectionsTableAnnotationComposer,
          $$CollectionsTableCreateCompanionBuilder,
          $$CollectionsTableUpdateCompanionBuilder,
          (Collection, $$CollectionsTableReferences),
          Collection,
          PrefetchHooks Function({bool collectionItemsRefs})
        > {
  $$CollectionsTableTableManager(_$AppDatabase db, $CollectionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CollectionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CollectionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CollectionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> icon = const Value.absent(),
                Value<int> color = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => CollectionsCompanion(
                id: id,
                name: name,
                icon: icon,
                color: color,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String> icon = const Value.absent(),
                Value<int> color = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => CollectionsCompanion.insert(
                id: id,
                name: name,
                icon: icon,
                color: color,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CollectionsTable, Collection>(table),
                  $$CollectionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({collectionItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (collectionItemsRefs) db.collectionItems,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (collectionItemsRefs)
                    await $_getPrefetchedDataByColumns<
                      Collection,
                      $CollectionsTable,
                      CollectionItem,
                      $CollectionItemsTable
                    >(
                      currentTable: table,
                      referencedTable: $$CollectionsTableReferences
                          ._collectionItemsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$CollectionsTableReferences(
                            db,
                            table,
                            p0,
                          ).collectionItemsRefs,
                      currentColumn: 'id',
                      referencedColumn: 'collection_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CollectionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CollectionsTable,
      Collection,
      $$CollectionsTableFilterComposer,
      $$CollectionsTableOrderingComposer,
      $$CollectionsTableAnnotationComposer,
      $$CollectionsTableCreateCompanionBuilder,
      $$CollectionsTableUpdateCompanionBuilder,
      (Collection, $$CollectionsTableReferences),
      Collection,
      PrefetchHooks Function({bool collectionItemsRefs})
    >;
typedef $$CollectionItemsTableCreateCompanionBuilder =
    CollectionItemsCompanion Function({
      required int collectionId,
      required int itemId,
      Value<int> rowid,
    });
typedef $$CollectionItemsTableUpdateCompanionBuilder =
    CollectionItemsCompanion Function({
      Value<int> collectionId,
      Value<int> itemId,
      Value<int> rowid,
    });

final class $$CollectionItemsTableReferences
    extends
        BaseReferences<_$AppDatabase, $CollectionItemsTable, CollectionItem> {
  $$CollectionItemsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CollectionsTable _collectionIdTable(_$AppDatabase db) => db
      .collections
      .createAlias('collection_items__collection_id__collections__id');

  $$CollectionsTableProcessedTableManager get collectionId {
    final $_column = $_itemColumn<int>('collection_id')!;

    final manager = $$CollectionsTableTableManager(
      $_db,
      $_db.collections,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_collectionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ItemsTable _itemIdTable(_$AppDatabase db) =>
      db.items.createAlias('collection_items__item_id__items__id');

  $$ItemsTableProcessedTableManager get itemId {
    final $_column = $_itemColumn<int>('item_id')!;

    final manager = $$ItemsTableTableManager(
      $_db,
      $_db.items,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_itemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CollectionItemsTableFilterComposer
    extends Composer<_$AppDatabase, $CollectionItemsTable> {
  $$CollectionItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$CollectionsTableFilterComposer get collectionId {
    final $$CollectionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.collectionId,
      referencedTable: $db.collections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CollectionsTableFilterComposer(
            $db: $db,
            $table: $db.collections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ItemsTableFilterComposer get itemId {
    final $$ItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableFilterComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CollectionItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $CollectionItemsTable> {
  $$CollectionItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$CollectionsTableOrderingComposer get collectionId {
    final $$CollectionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.collectionId,
      referencedTable: $db.collections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CollectionsTableOrderingComposer(
            $db: $db,
            $table: $db.collections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ItemsTableOrderingComposer get itemId {
    final $$ItemsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableOrderingComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CollectionItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CollectionItemsTable> {
  $$CollectionItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$CollectionsTableAnnotationComposer get collectionId {
    final $$CollectionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.collectionId,
      referencedTable: $db.collections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CollectionsTableAnnotationComposer(
            $db: $db,
            $table: $db.collections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ItemsTableAnnotationComposer get itemId {
    final $$ItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CollectionItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CollectionItemsTable,
          CollectionItem,
          $$CollectionItemsTableFilterComposer,
          $$CollectionItemsTableOrderingComposer,
          $$CollectionItemsTableAnnotationComposer,
          $$CollectionItemsTableCreateCompanionBuilder,
          $$CollectionItemsTableUpdateCompanionBuilder,
          (CollectionItem, $$CollectionItemsTableReferences),
          CollectionItem,
          PrefetchHooks Function({bool collectionId, bool itemId})
        > {
  $$CollectionItemsTableTableManager(
    _$AppDatabase db,
    $CollectionItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CollectionItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CollectionItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CollectionItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> collectionId = const Value.absent(),
                Value<int> itemId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CollectionItemsCompanion(
                collectionId: collectionId,
                itemId: itemId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int collectionId,
                required int itemId,
                Value<int> rowid = const Value.absent(),
              }) => CollectionItemsCompanion.insert(
                collectionId: collectionId,
                itemId: itemId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CollectionItemsTable, CollectionItem>(table),
                  $$CollectionItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({collectionId = false, itemId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (collectionId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.collectionId,
                        referencedTable: $$CollectionItemsTableReferences
                            ._collectionIdTable(db),
                        referencedColumn: $$CollectionItemsTableReferences
                            ._collectionIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (itemId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.itemId,
                        referencedTable: $$CollectionItemsTableReferences
                            ._itemIdTable(db),
                        referencedColumn: $$CollectionItemsTableReferences
                            ._itemIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CollectionItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CollectionItemsTable,
      CollectionItem,
      $$CollectionItemsTableFilterComposer,
      $$CollectionItemsTableOrderingComposer,
      $$CollectionItemsTableAnnotationComposer,
      $$CollectionItemsTableCreateCompanionBuilder,
      $$CollectionItemsTableUpdateCompanionBuilder,
      (CollectionItem, $$CollectionItemsTableReferences),
      CollectionItem,
      PrefetchHooks Function({bool collectionId, bool itemId})
    >;
typedef $$ReviewStatesTableCreateCompanionBuilder =
    ReviewStatesCompanion Function({
      Value<int> itemId,
      required DateTime dueAt,
      Value<double> ease,
      Value<int> intervalDays,
      Value<int> repetitions,
      Value<int> lapses,
      Value<DateTime?> lastReviewedAt,
    });
typedef $$ReviewStatesTableUpdateCompanionBuilder =
    ReviewStatesCompanion Function({
      Value<int> itemId,
      Value<DateTime> dueAt,
      Value<double> ease,
      Value<int> intervalDays,
      Value<int> repetitions,
      Value<int> lapses,
      Value<DateTime?> lastReviewedAt,
    });

final class $$ReviewStatesTableReferences
    extends BaseReferences<_$AppDatabase, $ReviewStatesTable, ReviewState> {
  $$ReviewStatesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ItemsTable _itemIdTable(_$AppDatabase db) =>
      db.items.createAlias('review_states__item_id__items__id');

  $$ItemsTableProcessedTableManager get itemId {
    final $_column = $_itemColumn<int>('item_id')!;

    final manager = $$ItemsTableTableManager(
      $_db,
      $_db.items,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_itemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ReviewStatesTableFilterComposer
    extends Composer<_$AppDatabase, $ReviewStatesTable> {
  $$ReviewStatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get dueAt => $composableBuilder(
    column: $table.dueAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get ease => $composableBuilder(
    column: $table.ease,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get intervalDays => $composableBuilder(
    column: $table.intervalDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get repetitions => $composableBuilder(
    column: $table.repetitions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lapses => $composableBuilder(
    column: $table.lapses,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastReviewedAt => $composableBuilder(
    column: $table.lastReviewedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ItemsTableFilterComposer get itemId {
    final $$ItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableFilterComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReviewStatesTableOrderingComposer
    extends Composer<_$AppDatabase, $ReviewStatesTable> {
  $$ReviewStatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get dueAt => $composableBuilder(
    column: $table.dueAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get ease => $composableBuilder(
    column: $table.ease,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get intervalDays => $composableBuilder(
    column: $table.intervalDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get repetitions => $composableBuilder(
    column: $table.repetitions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lapses => $composableBuilder(
    column: $table.lapses,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastReviewedAt => $composableBuilder(
    column: $table.lastReviewedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ItemsTableOrderingComposer get itemId {
    final $$ItemsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableOrderingComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReviewStatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReviewStatesTable> {
  $$ReviewStatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get dueAt =>
      $composableBuilder(column: $table.dueAt, builder: (column) => column);

  GeneratedColumn<double> get ease =>
      $composableBuilder(column: $table.ease, builder: (column) => column);

  GeneratedColumn<int> get intervalDays => $composableBuilder(
    column: $table.intervalDays,
    builder: (column) => column,
  );

  GeneratedColumn<int> get repetitions => $composableBuilder(
    column: $table.repetitions,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lapses =>
      $composableBuilder(column: $table.lapses, builder: (column) => column);

  GeneratedColumn<DateTime> get lastReviewedAt => $composableBuilder(
    column: $table.lastReviewedAt,
    builder: (column) => column,
  );

  $$ItemsTableAnnotationComposer get itemId {
    final $$ItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReviewStatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReviewStatesTable,
          ReviewState,
          $$ReviewStatesTableFilterComposer,
          $$ReviewStatesTableOrderingComposer,
          $$ReviewStatesTableAnnotationComposer,
          $$ReviewStatesTableCreateCompanionBuilder,
          $$ReviewStatesTableUpdateCompanionBuilder,
          (ReviewState, $$ReviewStatesTableReferences),
          ReviewState,
          PrefetchHooks Function({bool itemId})
        > {
  $$ReviewStatesTableTableManager(_$AppDatabase db, $ReviewStatesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReviewStatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReviewStatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReviewStatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> itemId = const Value.absent(),
                Value<DateTime> dueAt = const Value.absent(),
                Value<double> ease = const Value.absent(),
                Value<int> intervalDays = const Value.absent(),
                Value<int> repetitions = const Value.absent(),
                Value<int> lapses = const Value.absent(),
                Value<DateTime?> lastReviewedAt = const Value.absent(),
              }) => ReviewStatesCompanion(
                itemId: itemId,
                dueAt: dueAt,
                ease: ease,
                intervalDays: intervalDays,
                repetitions: repetitions,
                lapses: lapses,
                lastReviewedAt: lastReviewedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> itemId = const Value.absent(),
                required DateTime dueAt,
                Value<double> ease = const Value.absent(),
                Value<int> intervalDays = const Value.absent(),
                Value<int> repetitions = const Value.absent(),
                Value<int> lapses = const Value.absent(),
                Value<DateTime?> lastReviewedAt = const Value.absent(),
              }) => ReviewStatesCompanion.insert(
                itemId: itemId,
                dueAt: dueAt,
                ease: ease,
                intervalDays: intervalDays,
                repetitions: repetitions,
                lapses: lapses,
                lastReviewedAt: lastReviewedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ReviewStatesTable, ReviewState>(table),
                  $$ReviewStatesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({itemId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (itemId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.itemId,
                        referencedTable: $$ReviewStatesTableReferences
                            ._itemIdTable(db),
                        referencedColumn: $$ReviewStatesTableReferences
                            ._itemIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ReviewStatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReviewStatesTable,
      ReviewState,
      $$ReviewStatesTableFilterComposer,
      $$ReviewStatesTableOrderingComposer,
      $$ReviewStatesTableAnnotationComposer,
      $$ReviewStatesTableCreateCompanionBuilder,
      $$ReviewStatesTableUpdateCompanionBuilder,
      (ReviewState, $$ReviewStatesTableReferences),
      ReviewState,
      PrefetchHooks Function({bool itemId})
    >;
typedef $$ReviewLogsTableCreateCompanionBuilder = ReviewLogsCompanion Function({
  Value<int> id,
  required int itemId,
  required ReviewTask task,
  required bool correct,
  Value<DateTime> reviewedAt,
});
typedef $$ReviewLogsTableUpdateCompanionBuilder = ReviewLogsCompanion Function({
  Value<int> id,
  Value<int> itemId,
  Value<ReviewTask> task,
  Value<bool> correct,
  Value<DateTime> reviewedAt,
});

final class $$ReviewLogsTableReferences
    extends BaseReferences<_$AppDatabase, $ReviewLogsTable, ReviewLog> {
  $$ReviewLogsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ItemsTable _itemIdTable(_$AppDatabase db) =>
      db.items.createAlias('review_logs__item_id__items__id');

  $$ItemsTableProcessedTableManager get itemId {
    final $_column = $_itemColumn<int>('item_id')!;

    final manager = $$ItemsTableTableManager(
      $_db,
      $_db.items,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_itemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ReviewLogsTableFilterComposer
    extends Composer<_$AppDatabase, $ReviewLogsTable> {
  $$ReviewLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ReviewTask, ReviewTask, String> get task =>
      $composableBuilder(
        column: $table.task,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<bool> get correct => $composableBuilder(
    column: $table.correct,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get reviewedAt => $composableBuilder(
    column: $table.reviewedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ItemsTableFilterComposer get itemId {
    final $$ItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableFilterComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReviewLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $ReviewLogsTable> {
  $$ReviewLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get task => $composableBuilder(
    column: $table.task,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get correct => $composableBuilder(
    column: $table.correct,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get reviewedAt => $composableBuilder(
    column: $table.reviewedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ItemsTableOrderingComposer get itemId {
    final $$ItemsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableOrderingComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReviewLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReviewLogsTable> {
  $$ReviewLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ReviewTask, String> get task =>
      $composableBuilder(column: $table.task, builder: (column) => column);

  GeneratedColumn<bool> get correct =>
      $composableBuilder(column: $table.correct, builder: (column) => column);

  GeneratedColumn<DateTime> get reviewedAt => $composableBuilder(
    column: $table.reviewedAt,
    builder: (column) => column,
  );

  $$ItemsTableAnnotationComposer get itemId {
    final $$ItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReviewLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReviewLogsTable,
          ReviewLog,
          $$ReviewLogsTableFilterComposer,
          $$ReviewLogsTableOrderingComposer,
          $$ReviewLogsTableAnnotationComposer,
          $$ReviewLogsTableCreateCompanionBuilder,
          $$ReviewLogsTableUpdateCompanionBuilder,
          (ReviewLog, $$ReviewLogsTableReferences),
          ReviewLog,
          PrefetchHooks Function({bool itemId})
        > {
  $$ReviewLogsTableTableManager(_$AppDatabase db, $ReviewLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReviewLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReviewLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReviewLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> itemId = const Value.absent(),
                Value<ReviewTask> task = const Value.absent(),
                Value<bool> correct = const Value.absent(),
                Value<DateTime> reviewedAt = const Value.absent(),
              }) => ReviewLogsCompanion(
                id: id,
                itemId: itemId,
                task: task,
                correct: correct,
                reviewedAt: reviewedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int itemId,
                required ReviewTask task,
                required bool correct,
                Value<DateTime> reviewedAt = const Value.absent(),
              }) => ReviewLogsCompanion.insert(
                id: id,
                itemId: itemId,
                task: task,
                correct: correct,
                reviewedAt: reviewedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ReviewLogsTable, ReviewLog>(table),
                  $$ReviewLogsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({itemId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (itemId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.itemId,
                        referencedTable: $$ReviewLogsTableReferences
                            ._itemIdTable(db),
                        referencedColumn: $$ReviewLogsTableReferences
                            ._itemIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ReviewLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReviewLogsTable,
      ReviewLog,
      $$ReviewLogsTableFilterComposer,
      $$ReviewLogsTableOrderingComposer,
      $$ReviewLogsTableAnnotationComposer,
      $$ReviewLogsTableCreateCompanionBuilder,
      $$ReviewLogsTableUpdateCompanionBuilder,
      (ReviewLog, $$ReviewLogsTableReferences),
      ReviewLog,
      PrefetchHooks Function({bool itemId})
    >;
typedef $$XpEventsTableCreateCompanionBuilder = XpEventsCompanion Function({
  Value<int> id,
  required int amount,
  required XpReason reason,
  Value<int?> itemId,
  Value<DateTime> createdAt,
});
typedef $$XpEventsTableUpdateCompanionBuilder = XpEventsCompanion Function({
  Value<int> id,
  Value<int> amount,
  Value<XpReason> reason,
  Value<int?> itemId,
  Value<DateTime> createdAt,
});

final class $$XpEventsTableReferences
    extends BaseReferences<_$AppDatabase, $XpEventsTable, XpEvent> {
  $$XpEventsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ItemsTable _itemIdTable(_$AppDatabase db) =>
      db.items.createAlias('xp_events__item_id__items__id');

  $$ItemsTableProcessedTableManager? get itemId {
    final $_column = $_itemColumn<int>('item_id');
    if ($_column == null) return null;
    final manager = $$ItemsTableTableManager(
      $_db,
      $_db.items,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_itemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$XpEventsTableFilterComposer
    extends Composer<_$AppDatabase, $XpEventsTable> {
  $$XpEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<XpReason, XpReason, String> get reason =>
      $composableBuilder(
        column: $table.reason,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ItemsTableFilterComposer get itemId {
    final $$ItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableFilterComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$XpEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $XpEventsTable> {
  $$XpEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ItemsTableOrderingComposer get itemId {
    final $$ItemsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableOrderingComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$XpEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $XpEventsTable> {
  $$XpEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumnWithTypeConverter<XpReason, String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$ItemsTableAnnotationComposer get itemId {
    final $$ItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$XpEventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $XpEventsTable,
          XpEvent,
          $$XpEventsTableFilterComposer,
          $$XpEventsTableOrderingComposer,
          $$XpEventsTableAnnotationComposer,
          $$XpEventsTableCreateCompanionBuilder,
          $$XpEventsTableUpdateCompanionBuilder,
          (XpEvent, $$XpEventsTableReferences),
          XpEvent,
          PrefetchHooks Function({bool itemId})
        > {
  $$XpEventsTableTableManager(_$AppDatabase db, $XpEventsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$XpEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$XpEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$XpEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<XpReason> reason = const Value.absent(),
                Value<int?> itemId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => XpEventsCompanion(
                id: id,
                amount: amount,
                reason: reason,
                itemId: itemId,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int amount,
                required XpReason reason,
                Value<int?> itemId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => XpEventsCompanion.insert(
                id: id,
                amount: amount,
                reason: reason,
                itemId: itemId,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$XpEventsTable, XpEvent>(table),
                  $$XpEventsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({itemId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (itemId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.itemId,
                        referencedTable: $$XpEventsTableReferences._itemIdTable(
                          db,
                        ),
                        referencedColumn: $$XpEventsTableReferences
                            ._itemIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$XpEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $XpEventsTable,
      XpEvent,
      $$XpEventsTableFilterComposer,
      $$XpEventsTableOrderingComposer,
      $$XpEventsTableAnnotationComposer,
      $$XpEventsTableCreateCompanionBuilder,
      $$XpEventsTableUpdateCompanionBuilder,
      (XpEvent, $$XpEventsTableReferences),
      XpEvent,
      PrefetchHooks Function({bool itemId})
    >;
typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<int> id,
      Value<String> username,
      Value<CefrLevel> levelNow,
      Value<CefrLevel> levelGoal,
      Value<int> dailyGoal,
      Value<int> sessionLength,
      Value<AnswerMode> answerMode,
      Value<bool> gameMode,
      Value<bool> streakFreeze,
      Value<bool> reminderEnabled,
      Value<int> reminderMinutes,
      Value<Accent> accent,
      Value<SpeechSpeed> speechSpeed,
      Value<DateTime?> lastBackupAt,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<int> id,
      Value<String> username,
      Value<CefrLevel> levelNow,
      Value<CefrLevel> levelGoal,
      Value<int> dailyGoal,
      Value<int> sessionLength,
      Value<AnswerMode> answerMode,
      Value<bool> gameMode,
      Value<bool> streakFreeze,
      Value<bool> reminderEnabled,
      Value<int> reminderMinutes,
      Value<Accent> accent,
      Value<SpeechSpeed> speechSpeed,
      Value<DateTime?> lastBackupAt,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<CefrLevel, CefrLevel, String> get levelNow =>
      $composableBuilder(
        column: $table.levelNow,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<CefrLevel, CefrLevel, String> get levelGoal =>
      $composableBuilder(
        column: $table.levelGoal,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get dailyGoal => $composableBuilder(
    column: $table.dailyGoal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sessionLength => $composableBuilder(
    column: $table.sessionLength,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<AnswerMode, AnswerMode, String>
  get answerMode => $composableBuilder(
    column: $table.answerMode,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<bool> get gameMode => $composableBuilder(
    column: $table.gameMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get streakFreeze => $composableBuilder(
    column: $table.streakFreeze,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get reminderEnabled => $composableBuilder(
    column: $table.reminderEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reminderMinutes => $composableBuilder(
    column: $table.reminderMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Accent, Accent, String> get accent =>
      $composableBuilder(
        column: $table.accent,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<SpeechSpeed, SpeechSpeed, String>
  get speechSpeed => $composableBuilder(
    column: $table.speechSpeed,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get lastBackupAt => $composableBuilder(
    column: $table.lastBackupAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get levelNow => $composableBuilder(
    column: $table.levelNow,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get levelGoal => $composableBuilder(
    column: $table.levelGoal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dailyGoal => $composableBuilder(
    column: $table.dailyGoal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sessionLength => $composableBuilder(
    column: $table.sessionLength,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get answerMode => $composableBuilder(
    column: $table.answerMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get gameMode => $composableBuilder(
    column: $table.gameMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get streakFreeze => $composableBuilder(
    column: $table.streakFreeze,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get reminderEnabled => $composableBuilder(
    column: $table.reminderEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reminderMinutes => $composableBuilder(
    column: $table.reminderMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accent => $composableBuilder(
    column: $table.accent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get speechSpeed => $composableBuilder(
    column: $table.speechSpeed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastBackupAt => $composableBuilder(
    column: $table.lastBackupAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumnWithTypeConverter<CefrLevel, String> get levelNow =>
      $composableBuilder(column: $table.levelNow, builder: (column) => column);

  GeneratedColumnWithTypeConverter<CefrLevel, String> get levelGoal =>
      $composableBuilder(column: $table.levelGoal, builder: (column) => column);

  GeneratedColumn<int> get dailyGoal =>
      $composableBuilder(column: $table.dailyGoal, builder: (column) => column);

  GeneratedColumn<int> get sessionLength => $composableBuilder(
    column: $table.sessionLength,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<AnswerMode, String> get answerMode =>
      $composableBuilder(
        column: $table.answerMode,
        builder: (column) => column,
      );

  GeneratedColumn<bool> get gameMode =>
      $composableBuilder(column: $table.gameMode, builder: (column) => column);

  GeneratedColumn<bool> get streakFreeze => $composableBuilder(
    column: $table.streakFreeze,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get reminderEnabled => $composableBuilder(
    column: $table.reminderEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<int> get reminderMinutes => $composableBuilder(
    column: $table.reminderMinutes,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<Accent, String> get accent =>
      $composableBuilder(column: $table.accent, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SpeechSpeed, String> get speechSpeed =>
      $composableBuilder(
        column: $table.speechSpeed,
        builder: (column) => column,
      );

  GeneratedColumn<DateTime> get lastBackupAt => $composableBuilder(
    column: $table.lastBackupAt,
    builder: (column) => column,
  );
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTable,
          Settings,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            Settings,
            BaseReferences<_$AppDatabase, $AppSettingsTable, Settings>,
          ),
          Settings,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> username = const Value.absent(),
                Value<CefrLevel> levelNow = const Value.absent(),
                Value<CefrLevel> levelGoal = const Value.absent(),
                Value<int> dailyGoal = const Value.absent(),
                Value<int> sessionLength = const Value.absent(),
                Value<AnswerMode> answerMode = const Value.absent(),
                Value<bool> gameMode = const Value.absent(),
                Value<bool> streakFreeze = const Value.absent(),
                Value<bool> reminderEnabled = const Value.absent(),
                Value<int> reminderMinutes = const Value.absent(),
                Value<Accent> accent = const Value.absent(),
                Value<SpeechSpeed> speechSpeed = const Value.absent(),
                Value<DateTime?> lastBackupAt = const Value.absent(),
              }) => AppSettingsCompanion(
                id: id,
                username: username,
                levelNow: levelNow,
                levelGoal: levelGoal,
                dailyGoal: dailyGoal,
                sessionLength: sessionLength,
                answerMode: answerMode,
                gameMode: gameMode,
                streakFreeze: streakFreeze,
                reminderEnabled: reminderEnabled,
                reminderMinutes: reminderMinutes,
                accent: accent,
                speechSpeed: speechSpeed,
                lastBackupAt: lastBackupAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> username = const Value.absent(),
                Value<CefrLevel> levelNow = const Value.absent(),
                Value<CefrLevel> levelGoal = const Value.absent(),
                Value<int> dailyGoal = const Value.absent(),
                Value<int> sessionLength = const Value.absent(),
                Value<AnswerMode> answerMode = const Value.absent(),
                Value<bool> gameMode = const Value.absent(),
                Value<bool> streakFreeze = const Value.absent(),
                Value<bool> reminderEnabled = const Value.absent(),
                Value<int> reminderMinutes = const Value.absent(),
                Value<Accent> accent = const Value.absent(),
                Value<SpeechSpeed> speechSpeed = const Value.absent(),
                Value<DateTime?> lastBackupAt = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                id: id,
                username: username,
                levelNow: levelNow,
                levelGoal: levelGoal,
                dailyGoal: dailyGoal,
                sessionLength: sessionLength,
                answerMode: answerMode,
                gameMode: gameMode,
                streakFreeze: streakFreeze,
                reminderEnabled: reminderEnabled,
                reminderMinutes: reminderMinutes,
                accent: accent,
                speechSpeed: speechSpeed,
                lastBackupAt: lastBackupAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AppSettingsTable, Settings>(table),
                  BaseReferences<_$AppDatabase, $AppSettingsTable, Settings>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTable,
      Settings,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (Settings, BaseReferences<_$AppDatabase, $AppSettingsTable, Settings>),
      Settings,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ItemsTableTableManager get items =>
      $$ItemsTableTableManager(_db, _db.items);
  $$ItemLinksTableTableManager get itemLinks =>
      $$ItemLinksTableTableManager(_db, _db.itemLinks);
  $$RuleMistakesTableTableManager get ruleMistakes =>
      $$RuleMistakesTableTableManager(_db, _db.ruleMistakes);
  $$TagsTableTableManager get tags => $$TagsTableTableManager(_db, _db.tags);
  $$ItemTagsTableTableManager get itemTags =>
      $$ItemTagsTableTableManager(_db, _db.itemTags);
  $$CollectionsTableTableManager get collections =>
      $$CollectionsTableTableManager(_db, _db.collections);
  $$CollectionItemsTableTableManager get collectionItems =>
      $$CollectionItemsTableTableManager(_db, _db.collectionItems);
  $$ReviewStatesTableTableManager get reviewStates =>
      $$ReviewStatesTableTableManager(_db, _db.reviewStates);
  $$ReviewLogsTableTableManager get reviewLogs =>
      $$ReviewLogsTableTableManager(_db, _db.reviewLogs);
  $$XpEventsTableTableManager get xpEvents =>
      $$XpEventsTableTableManager(_db, _db.xpEvents);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
}
