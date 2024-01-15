import 'package:chatapp/model/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class ChatService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> sendMessage(String receiverId, String message) async {
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    Message newMessage = Message(
      senderID: currentUserId,
      senderEmail: currentUserEmail,
      receiverId: receiverId,
      timestamp: timestamp,
      message: message,
    );

    List<String> ids = [currentUserId, receiverId];
    ids.sort();
    String chatRoomId = ids.join("_");

    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.toMAp());

    _sendPushNotification(receiverId, message);
  }

  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");

    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  Future<void> handlePushNotifications(Map<String, dynamic> message) async {
    String senderId = message['data']['senderId'];
    String senderEmail = message['data']['senderEmail'];

    bool isChatPageOpen = _isChatPageOpen(senderId);

    if (isChatPageOpen) {
      getMessages(senderId, _firebaseAuth.currentUser!.uid);
    } else {
      print(
          'New message from $senderEmail: ${message['notification']['body']}');
    }
  }

  bool _isChatPageOpen(String userId) {
    return true;
  }

  Future<void> _sendPushNotification(String receiverId, String message) async {
    String currentUserId = _firebaseAuth.currentUser!.uid;
    String currentUserEmail = _firebaseAuth.currentUser!.email.toString();

    String? receiverToken = await _getFCMToken(receiverId);

    if (receiverToken != null) {
      Map<String, dynamic> notificationMessage = {
        'to': receiverToken,
        'notification': {
          'title': 'New Message from $currentUserEmail',
          'body': message,
        },
        'data': {
          'senderId': currentUserId,
          'senderEmail': currentUserEmail,
        },
      };

      // // Use the send method from the FirebaseMessaging instance
      // await _firebaseMessaging.send(
      //   RemoteMessage.fromMap(notificationMessage),
      // );
    }
  }

  Future<String?> _getFCMToken(String userId) async {
    try {
      return await _firebaseMessaging.getToken();
    } catch (e) {
      print('Error getting FCM token: $e');
      return null;
    }
  }
}
