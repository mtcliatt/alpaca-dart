/// Returns an ISO 8601 (subset RFC 3339) compliant String representation of the
/// given [time].
///
/// The America/New York timezone is assumed for simplicity.
String toRfc3339String(DateTime time) {
  String twoDigits(int n) => n < 10 ? '0$n' : '$n';

  final month = twoDigits(time.month);
  final day = twoDigits(time.day);
  final hour = twoDigits(time.hour);
  final minute = twoDigits(time.minute);
  final second = twoDigits(time.second);

  return '${time.year}-$month-${day}T$hour:$minute:$second-05:00';
}