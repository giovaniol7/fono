import 'package:intl/intl.dart';

String converterData(String dateTimeString) {
  List<String> dateParts = dateTimeString.split('/');
  int day = int.parse(dateParts[0]);
  int month = int.parse(dateParts[1]);
  int year = int.parse(dateParts[2]);

  DateTime dateTime = DateTime(year, month, day);
  DateTime now = DateTime.now();
  DateTime yesterday = now.subtract(const Duration(days: 1));

  var textToShow = (dateTime.year == now.year && dateTime.month == now.month && dateTime.day == now.day)
      ? 'Hoje'
      : (dateTime.year == yesterday.year && dateTime.month == yesterday.month && dateTime.day == yesterday.day)
      ? 'Ontem'
      : DateFormat('dd/MM/yyyy').format(dateTime);

  return textToShow;
}