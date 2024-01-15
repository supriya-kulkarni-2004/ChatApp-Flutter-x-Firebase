import 'package:chatapp/util/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FcmService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void refreshToken(String? fcmToken) {
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    _firestore
        .collection(Constants.USERS_DB)
        .doc(currentUserId)
        .update({"fcm_token": fcmToken});
  }
}
