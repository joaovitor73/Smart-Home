import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final String topic;
  bool _isFlutterLocalNotificationsInitialized = false;

  NotificationService({required topic}) : this.topic = topic {
    initializePermissition();
    _firebaseMessaging.subscribeToTopic(this.topic);

    setupFlutterNotifications();
    _setupMessageHandlers();
  }

  Future<void> _setupMessageHandlers() async {
    //foreground message
    FirebaseMessaging.onMessage.listen((message) {
      showNotifictionForeground(message);
    });

    // background message
    FirebaseMessaging.onMessageOpenedApp
        .listen(_firebaseMessagingBackgroundHandler);
  }

  void showNotifictionForeground(RemoteMessage message) {
    AndroidNotification? android = message.notification?.android;
    RemoteNotification? notification = message.notification;

    print('Mensagem recebida: ${message.notification?.title}');
    print(message.notification?.body);
    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'alerta',
            'Notificações de presença',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker',
            styleInformation: BigTextStyleInformation(
              notification.body!,
              contentTitle: notification.title,
              htmlFormatContentTitle: true,
              htmlFormatBigText: true,
            ),
          ),
        ),
      );
    }
  }

  Future<void> setupFlutterNotifications() async {
    if (_isFlutterLocalNotificationsInitialized) {
      return;
    }

    // android setup
    const channel = AndroidNotificationChannel(
      'alerta',
      'Notificações de presença',
      importance: Importance.high,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    // flutter notification setup
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {},
    );

    _isFlutterLocalNotificationsInitialized = true;
  }

  Future<void> initializePermissition() async {
    requestPermission();
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp();
  }

  Future<void> requestPermission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('Permissão concedida!');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('Permissão provisória concedida.');
    } else {
      print('Permissão negada.');
    }
  }
}
