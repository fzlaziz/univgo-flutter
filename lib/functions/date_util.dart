import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class DateUtil {
  static bool _isInitialized = false;

  static void ensureInitialized() {
    if (!_isInitialized) {
      tz.initializeTimeZones();
      _isInitialized = true;
    }
  }

  static DateTime? toJakartaTime(String? dateString) {
    if (dateString == null) return null;

    ensureInitialized();
    final jakarta = tz.getLocation('Asia/Jakarta');
    final utcTime = DateTime.parse(dateString);
    final jakartaDateTime = tz.TZDateTime.from(utcTime, jakarta);

    return DateTime(
      jakartaDateTime.year,
      jakartaDateTime.month,
      jakartaDateTime.day,
      jakartaDateTime.hour,
      jakartaDateTime.minute,
      jakartaDateTime.second,
      jakartaDateTime.millisecond,
      jakartaDateTime.microsecond,
    );
  }

  static DateTime toJakartaTimeWithDefault(String? dateString,
      {DateTime? defaultValue}) {
    return toJakartaTime(dateString) ?? (defaultValue ?? DateTime.now());
  }
}
