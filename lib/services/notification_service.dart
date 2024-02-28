import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  FlutterLocalNotificationsPlugin get notificationsPlugin =>
      _notificationsPlugin;

  final AndroidInitializationSettings androidInitializationSettings =
      const AndroidInitializationSettings("@mipmap/ic_launcher");

  final LinuxInitializationSettings linuxInitializationSettings =
      const LinuxInitializationSettings(defaultActionName: 'pidum');

  final AndroidNotificationDetails defaultAndroidNotificationDetails =
      const AndroidNotificationDetails(
    'pidum',
    'pidum',
    importance: Importance.max,
    priority: Priority.max,
    category: AndroidNotificationCategory.reminder,
    actions: [AndroidNotificationAction('read', 'OK')],
  );

  final BehaviorSubject<String?> stream = BehaviorSubject();

  String? onDidReceivePayload;
  String? onDidReceiveActionId;

  final LinuxNotificationDetails deafultLinuxNotificationDetails =
      const LinuxNotificationDetails();

  Future<NotificationService> init() async {
    debugPrint("NotificationServices.init");
    var details = await _notificationsPlugin.getNotificationAppLaunchDetails();

    if (details?.didNotificationLaunchApp ?? false) {
      debugPrint("notif launch");
      if (details?.notificationResponse != null) {
        onDidReceivePayload = details!.notificationResponse!.payload;
        onDidReceiveActionId = details.notificationResponse!.actionId;
      }
    }

    _notificationsPlugin.initialize(
      InitializationSettings(
        android: androidInitializationSettings,
        linux: linuxInitializationSettings,
      ),
      onDidReceiveNotificationResponse: (details) {
        stream.add(details.payload);
      },
    );

    return this;
  }

  Future dateNotification({
    required int id,
    required String title,
    required String body,
    required DateTime date,
    String? payload,
  }) async {
    try {
      _notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(date, tz.local),
        NotificationDetails(
          android: defaultAndroidNotificationDetails,
          linux: deafultLinuxNotificationDetails,
        ),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: payload,
      );
    } catch (e) {
      debugPrint("$e");
    }
  }

  Future show({
    int id = 0,
    required String payload,
    required String title,
    required String body,
  }) async {
    await _notificationsPlugin.show(
      id,
      title,
      body,
      NotificationDetails(
        android: defaultAndroidNotificationDetails,
        linux: deafultLinuxNotificationDetails,
      ),
      payload: payload,
    );
  }
}
