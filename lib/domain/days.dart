/// Naptári napok kezelése helyi idő szerint.
///
/// A napokat egész számként („hányadik nap 1970 óta”) hasonlítjuk össze, így a
/// nyári/téli időszámítás váltása nem okoz 23 vagy 25 órás „napot”.
int dayNumber(DateTime time) {
  final local = time.toLocal();
  return DateTime.utc(local.year, local.month, local.day).millisecondsSinceEpoch ~/
      Duration.millisecondsPerDay;
}

/// A nap kezdete (helyi éjfél).
DateTime startOfDay(DateTime time) {
  final local = time.toLocal();
  return DateTime(local.year, local.month, local.day);
}

/// „2026-11-04” – adatbázis-kulcsnak (pl. melyik nap vette fel a küldetést).
String dayKey(DateTime time) {
  final local = time.toLocal();
  String two(int n) => n.toString().padLeft(2, '0');
  return '${local.year}-${two(local.month)}-${two(local.day)}';
}
