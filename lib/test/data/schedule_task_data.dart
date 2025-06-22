

import '../model/schedule_model.dart';

class ScheduleTasksData {
  final scheduled = const [
    ScheduledModel(title: "Hatha Yoga", date: "Today, 9AM - 10AM"),
    ScheduledModel(title: "Body Combat", date: "Tomorrow, 5PM - 6PM"),
    ScheduledModel(title: "Hatha Yoga", date: "Wednesday, 9AM - 10AM"),
  ];
}

String formatDate(dynamic date) {

  // Parse the ISO date string
  DateTime dateTime;

  if (date is String) {
    dateTime = DateTime.parse(date);
  } else if (date is DateTime) {
    dateTime = date;
  } else {
    return 'Invalid date';
  }

  // Get the day of week
  List<String> weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
  String dayOfWeek = weekdays[dateTime.weekday - 1];

  // Get the month
  List<String> months = ['January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'];
  String month = months[dateTime.month - 1];

  // Get the day with suffix (1st, 2nd, 3rd, etc.)
  String day = dateTime.day.toString();
  String suffix;
  if (day.endsWith('1') && day != '11') {
    suffix = 'st';
  } else if (day.endsWith('2') && day != '12') {
    suffix = 'nd';
  } else if (day.endsWith('3') && day != '13') {
    suffix = 'rd';
  } else {
    suffix = 'th';
  }

  // Format the time
  int hour = dateTime.hour;
  String period = hour >= 12 ? 'PM' : 'AM';
  int hour12 = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);

  // For the time range (assuming 1 hour slot)
  int endHour = (hour + 1) % 24;
  int endHour12 = endHour > 12 ? endHour - 12 : (endHour == 0 ? 12 : endHour);
  String endPeriod = endHour >= 12 ? 'PM' : 'AM';

  // Formatted string
  return '$dayOfWeek, $hour12$period - $endHour12$endPeriod, $month $day$suffix, ${dateTime.year}';
}
