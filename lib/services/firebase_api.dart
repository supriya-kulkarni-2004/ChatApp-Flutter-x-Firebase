import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApi {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // Initialize FCM and request permission for receiving messages
  Future<void> initNotifications() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');

    // Handle incoming messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received foreground message: ${message.notification?.title}');
      // Handle the received message as needed
    });

    // Handle notification tap
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print(
          'Notification opened by tapping on it: ${message.notification?.title}');
      // Navigate to the appropriate screen if needed
      // Example: navigate to the chat page with the sender's information
      // Navigator.pushNamed(context, '/chat', arguments: {'senderId': message.data['senderId']});
    });

    // Get the FCM token
    String? token = await _firebaseMessaging.getToken();
    print('FCM Token: $token');
  }

  // Handle background and terminated state messages
  Future<void> onBackgroundMessageHandler(RemoteMessage message) async {
    print('Handling background message: ${message.notification?.title}');
    // Handle the message as needed, e.g., show a notification
  }
}
