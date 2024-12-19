import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final String topic;

  NotificationService({required topic}) : this.topic = topic {
    initializePermissition();
    _firebaseMessaging.subscribeToTopic(this.topic);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(
          'Mensagem recebida em primeiro plano: ${message.notification?.title}');
      if (message.notification != null) {
        print('Corpo da notificação: ${message.notification?.body}');
      }
    });
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
    print('Mensagem recebida em background: ${message.messageId}');
  }

  Future<void> requestPermission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
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
