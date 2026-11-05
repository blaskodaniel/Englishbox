import 'dart:convert';

import 'package:drift/drift.dart';

import '../domain/formula.dart';

/// A képletet JSON szövegként tárolja az adatbázisban.
class FormulaConverter extends TypeConverter<List<FormulaBlock>, String> {
  const FormulaConverter();

  @override
  List<FormulaBlock> fromSql(String fromDb) => (jsonDecode(fromDb) as List)
      .map((e) => FormulaBlock.fromJson(e as Map<String, dynamic>))
      .toList();

  @override
  String toSql(List<FormulaBlock> value) => jsonEncode(value.map((b) => b.toJson()).toList());
}
