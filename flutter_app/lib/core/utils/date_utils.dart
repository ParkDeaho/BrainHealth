import 'package:intl/intl.dart';

String toDateKey(DateTime date) {
  return DateFormat('yyyy-MM-dd').format(date);
}
