import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class LocalNotifications {
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static Future init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsDarwin =
    DarwinInitializationSettings();

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        debugPrint('Notification clicked with payload: ${response.payload}');
      },
    );
    tz.initializeTimeZones();
  }

  static Future showSimpleNotification({
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      'groupChannelId',
      'groupChannelName',
      channelDescription: 'groupChannelDescription',
      importance: Importance.max,
      priority: Priority.high,
      groupKey: 'groupKey',
    );

    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);

    await _flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      notificationDetails,
    );
  }

  static scheduleNotification({
    required String title,
    required String body,
    required int delay,
    required int notificationId,
  }) async {
    var androidDetails = const AndroidNotificationDetails(
      "important_notification",
      "My Channel",
      importance: Importance.max,
      priority: Priority.high,
    );
    var notificationDetails = NotificationDetails(android: androidDetails);
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      notificationId,
      title,
      body,
      tz.TZDateTime.now(tz.local).add(Duration(seconds: delay)),
      notificationDetails,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }


  void scheduleOrderNotifications() {
    print("scheduleOrderNotifications() called");

    LocalNotifications.scheduleNotification(
      title: 'Done',
      body: 'Checking your order',
      delay: 1,
      notificationId: 1,
    );

    LocalNotifications.scheduleNotification(
      title: 'Order Accepted',
      body: 'Your order has been accepted.',
      delay: 10,
      notificationId: 2,
    );

    LocalNotifications.scheduleNotification(
      title: 'Out for Delivery',
      body: 'Your order is out for delivery!',
      delay: 20,
      notificationId: 3,
    );

    LocalNotifications.scheduleNotification(
      title: 'Order Delivered',
      body: 'Your order has been delivered!',
      delay: 30,
      notificationId: 4,
    );
  }
}