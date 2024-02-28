import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class ReminderPageState extends StatefulWidget {
  const ReminderPageState({super.key});

  @override
  State<ReminderPageState> createState() => _ReminderPageStateState();
}

class _ReminderPageStateState extends State<ReminderPageState> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  late TimeOfDay selectedTime = const TimeOfDay(hour: 8, minute: 0);
  late String selectedActivity = activities[0];
  late String selectedDay = days[0];

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    _configureLocalTimeZone();
  }

  void _configureLocalTimeZone() {
    tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));
  }

  void _scheduleNotification() async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Reminder',
      'Time for $selectedActivity!',
      _nextInstanceOfSelectedDayTime(),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'channel id',
          'channel name',
          // 'channel description',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  tz.TZDateTime _nextInstanceOfSelectedDayTime() {
    final now = tz.TZDateTime.now(tz.local);
    final selectedWeekday =
        days.indexOf(selectedDay) + 1; // Monday is 1, Sunday is 7
    var scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day,
        selectedTime.hour, selectedTime.minute);
    while (scheduledDate.weekday != selectedWeekday) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      appBar: AppBar(
        backgroundColor: Colors.amber,
        centerTitle: true,
        title: const Text(
          'Reminder App',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
            color: Colors.black,
            image: DecorationImage(
                image: AssetImage("assets/images/Reminders1.jpg"))),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                DropdownButton<String>(
                  style: TextStyle(color: Colors.white),
                  dropdownColor: Colors.amber,
                  value: selectedDay,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedDay = newValue!;
                    });
                  },
                  items: days.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                DropdownButton<TimeOfDay>(
                  style: TextStyle(color: Colors.white),
                  dropdownColor: Colors.amber,
                  value: selectedTime,
                  onChanged: (TimeOfDay? newValue) {
                    setState(() {
                      selectedTime = newValue!;
                    });
                  },
                  items: _buildTimeOfDayMenuItems(),
                ),
                DropdownButton<String>(
                  style: TextStyle(color: Colors.white),
                  dropdownColor: Colors.amber,
                  value: selectedActivity,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedActivity = newValue!;
                    });
                  },
                  items:
                      activities.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.amber, // Set the background color here
                  ),
                  onPressed: _scheduleNotification,
                  child: Text(
                    'Set Reminder',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem<TimeOfDay>> _buildTimeOfDayMenuItems() {
    var items = <DropdownMenuItem<TimeOfDay>>[];
    for (var hour = 0; hour < 24; hour++) {
      for (var minute = 0; minute < 60; minute += 15) {
        items.add(
          DropdownMenuItem<TimeOfDay>(
            value: TimeOfDay(hour: hour, minute: minute),
            child: Text('$hour:${minute.toString().padLeft(2, '0')}'),
          ),
        );
      }
    }
    return items;
  }
}

final List<String> days = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];

final List<String> activities = [
  'Wake up',
  'Go to gym',
  'Breakfast',
  'Meetings',
  'Lunch',
  'Quick nap',
  'Go to library',
  'Dinner',
  'Go to sleep',
];
