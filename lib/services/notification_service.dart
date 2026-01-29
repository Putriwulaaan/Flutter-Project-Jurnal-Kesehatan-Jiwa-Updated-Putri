import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  // =========================
  // INIT NOTIFICATION
  // =========================
  Future<void> initNotification() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: androidSettings);

    await _plugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
        if (notificationResponse.payload == 'emergency') {
          navigatorKey.currentState?.pushNamed('/emergency_contact');
        }
      },
    );

    final AndroidFlutterLocalNotificationsPlugin? androidPlugin =
        _plugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.requestNotificationsPermission();
  }

  // =========================
  // SHOW EMERGENCY NOTIFICATION
  // =========================
  Future<void> showEmergencyNotification(
    String title,
    String body,
  ) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'emergency_channel',
      'Emergency',
      channelDescription: 'Notifikasi darurat',
      importance: Importance.max,
      priority: Priority.high,
      fullScreenIntent: true,
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    await _plugin.show(
      1, // ID NOTIFICATION (positional)
      title,
      body,
      notificationDetails,
      payload: 'emergency',
    );
  }
}
