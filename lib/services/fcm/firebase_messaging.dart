// firebase_messaging.dart
import 'package:chatapp/services/fcm/fcm_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class FirebaseMessagingService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final GlobalKey<NavigatorState> navigatorKey;
  final FcmService fcmService = FcmService();

  FirebaseMessagingService({required this.navigatorKey});

  Future<void> init() async {
    // Request permission for receiving messages
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

      // Check if the chat page is open for the sender
      bool isChatPageOpen = _isChatPageOpen(message.data['senderId']);

      // If the chat page is open, fetch and display the new message
      if (isChatPageOpen) {
        navigatorKey.currentState
            ?.pushReplacementNamed('/chat_page', arguments: {
          'receiverUserId': message.data['senderId'],
          'receiverUserEmail': message.data['senderEmail'],
          'openedFromNotification': true,
        });
      } else {
        // If the chat page is not open, you might want to show a notification or handle it as needed
        // For now, we'll print a message
        print(
            'New message from ${message.data['senderEmail']}: ${message.notification?.body}');
      }
    });

    // Handle notification tap when the app is in the background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print(
          'Notification opened by tapping on it: ${message.notification?.title}');

      // Navigate to the appropriate screen if needed
      navigatorKey.currentState?.pushReplacementNamed('/chat_page', arguments: {
        'receiverUserId': message.data['senderId'],
        'receiverUserEmail': message.data['senderEmail'],
        'openedFromNotification': true,
      });
    });

    // Get the token
    String? token = await _firebaseMessaging.getToken();
    print('FCM Token: $token');
    fcmService.refreshToken(token);
  }

  // Helper method to check if the chat page is currently open for a specific user
  bool _isChatPageOpen(String userId) {
    // Implement your logic to check if the chat page is open for the specified user
    // You might need to keep track of open chat pages in your app
    // For simplicity, we'll assume the chat page is always open
    return true;
  }
}
