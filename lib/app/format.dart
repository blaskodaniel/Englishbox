const _months = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

/// „Oct 28”, vagy más évben „Oct 28, 2025”.
String shortDate(DateTime date, {DateTime? now}) {
  final local = date.toLocal();
  final text = '${_months[local.month - 1]} ${local.day}';
  final year = (now ?? DateTime.now()).year;
  return local.year == year ? text : '$text, ${local.year}';
}

/// 1240 → „1,240”
String thousands(int value) {
  final digits = value.abs().toString();
  final buffer = StringBuffer(value < 0 ? '-' : '');
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(',');
    buffer.write(digits[i]);
  }
  return buffer.toString();
}

/// Napszaknak megfelelő köszönés.
String greeting(DateTime now) => switch (now.hour) {
  >= 5 && < 12 => 'Good morning',
  >= 12 && < 18 => 'Good afternoon',
  _ => 'Good evening',
};

/// Mennyi van hátra éjfélig: „4h”, „35m”.
String untilMidnight(DateTime now) {
  final midnight = DateTime(now.year, now.month, now.day + 1);
  final left = midnight.difference(now);
  return left.inHours >= 1 ? '${left.inHours}h' : '${left.inMinutes.clamp(1, 59)}m';
}
