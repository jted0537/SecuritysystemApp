import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotification {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  tz.TZDateTime schduledDate;

  // Initial Settings for using local_notification
  void initialSettings() {
    final initSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final initSettingiOS = IOSInitializationSettings();
    final initSettings = InitializationSettings(
        android: initSettingsAndroid, iOS: initSettingiOS);
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initSettings);
  }

  // Set notification time
  tz.TZDateTime _setNotiTime(
      int year, int month, int day, int hour, int minute) {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Dhaka'));
    var scheduledDate = tz.TZDateTime(tz.local, year, month, day, hour, minute);
    return scheduledDate;
  }

  // Show local notification
  Future<void> showNotification(
      int year, int month, int day, int hour, int minute) async {
    var androidDetails = AndroidNotificationDetails("channelId",
        "Local Notification", "This is the description of the notification",
        importance: Importance.high);
    var iOSDetails = IOSNotificationDetails();
    var generalNotificationDetails =
        NotificationDetails(android: androidDetails, iOS: iOSDetails);
    // Parsing date
    var realTime = '';
    var realHour = hour;
    if (hour >= 12) {
      if (realHour > 12) realHour -= 12;
      realTime += realHour > 9 ? '$realHour:' : '0$realHour:';
      realTime += minute > 9 ? '$minute pm' : '0$minute pm';
    } else {
      realTime += realHour > 9 ? '$realHour:' : '0$realHour:';
      realTime += minute > 9 ? '$minute am' : '0$minute am';
    }

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.deleteNotificationChannelGroup("channelId");

    // Schedule local notification
    await flutterLocalNotificationsPlugin.zonedSchedule(
      year + month + day + hour * 60 + minute,
      'Time to attend',
      realTime,
      _setNotiTime(year, month, day, hour, minute),
      generalNotificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  // Cancel all local notificatiohn
  Future<void> cancelAllNotification() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
