const _months = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

/// „Oct 28”, vagy más évben „Oct 28, 2025”.
String shortDate(DateTime date, {DateTime? now}) {
  final local = date.toLocal();
  final text = '${_months[local.month - 1]} ${local.day}';
  final year = (now ?? DateTime.now()).year;
  return local.year == year ? text : '$text, ${local.year}';
}
