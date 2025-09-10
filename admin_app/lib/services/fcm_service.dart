import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// 백그라운드 메시지 핸들러(최상위 함수)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // 필요한 경우 firebase_core 초기화 필요 (플러터 3.22+은 자동)
  // await Firebase.initializeApp();

  debugPrint('🔔 BG message: ${message.messageId}');
}

// 로컬 알림 초기화
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initLocalNotifications() async {
  const AndroidInitializationSettings androidInit =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initSettings = InitializationSettings(
    android: androidInit,
  );

  await flutterLocalNotificationsPlugin.initialize(initSettings);
}

Future<void> showLocalNotification(RemoteMessage msg) async {
  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'fcm_default_channel',
    'FCM',
    channelDescription: 'Firebase Cloud Messaging',
    importance: Importance.max,
    priority: Priority.high,
    playSound: true,
  );
  const NotificationDetails details = NotificationDetails(
    android: androidDetails,
  );

  final title = msg.notification?.title ?? '알림';
  final body = msg.notification?.body ?? '내용 없음';

  await flutterLocalNotificationsPlugin.show(
    DateTime.now().millisecondsSinceEpoch ~/ 1000,
    title,
    body,
    details,
  );
}

class FcmService {
  static final _messaging = FirebaseMessaging.instance;

  static Future<void> init() async {
    // 권한 요청 (Android13+)
    if (Platform.isAndroid) {
      final settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      debugPrint('🔐 Notification permission: ${settings.authorizationStatus}');
    }

    // 토큰 확인
    final token = await _messaging.getToken();
    debugPrint('✅ FCM token: $token');

    // 포그라운드 메시지
    FirebaseMessaging.onMessage.listen((RemoteMessage msg) async {
      debugPrint('📩 FG message: ${msg.data}');
      await showLocalNotification(msg);
    });

    // 앱이 백그라/종료 상태에서 알림 클릭 진입
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage msg) {
      debugPrint('👉 onMessageOpenedApp: ${msg.data}');
      // 특정 화면 이동 등 처리
    });

    // 백그라운드 핸들러 등록
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }
}
