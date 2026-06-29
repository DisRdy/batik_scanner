import 'package:intl/intl.dart';

class AppDates {
  const AppDates._();

  static final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  static DateTime today() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  static DateTime yesterday() => today().subtract(const Duration(days: 1));

  static String todayKey() => _dateFormat.format(today());

  static String yesterdayKey() => _dateFormat.format(yesterday());

  static bool isToday(String? value) => value == todayKey();

  static bool isYesterday(String? value) => value == yesterdayKey();

  static bool isBeforeYesterday(String? value) {
    if (value == null || value.isEmpty) {
      return false;
    }
    final parsed = DateTime.tryParse(value);
    if (parsed == null) {
      return false;
    }
    return parsed.isBefore(yesterday());
  }
}
