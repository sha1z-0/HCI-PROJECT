import 'package:intl/intl.dart';

String formatShortTime(DateTime dateTime) {
  return DateFormat('h:mm a').format(dateTime);
}

String formatShortDate(DateTime dateTime) {
  return DateFormat('MMM d').format(dateTime);
}
