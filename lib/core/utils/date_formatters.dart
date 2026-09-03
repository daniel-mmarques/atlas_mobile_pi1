import 'package:intl/intl.dart';

abstract class DateFormatters {
  static String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  static DateTime? parseDate(String value) {
    try {
      return DateFormat('dd/MM/yyyy').parseStrict(value);
    } catch (_) {
      return null;
    }
  }
}
