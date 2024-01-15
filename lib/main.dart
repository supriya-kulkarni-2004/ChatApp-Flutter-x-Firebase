// main.dart
import 'package:chatapp/firebase_options.dart';
import 'package:chatapp/services/auth/auth_gate.dart';
import 'package:chatapp/services/auth/auth_service.dart';
import 'package:chatapp/services/chat/chat_service.dart';
import 'package:chatapp/services/fcm/firebase_messaging.dart';
import 'package:chatapp/pages/chat_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Create a GlobalKey for the Navigator
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
        ChangeNotifierProvider(create: (context) => ChatService()),
      ],
      child: MyApp(navigatorKey: navigatorKey),
    ),
  );

  // Initialize Firebase Messaging Service
  FirebaseMessagingService(navigatorKey: navigatorKey).init();
}

class MyApp extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const MyApp({Key? key, required this.navigatorKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      home: AuthGate(),
      routes: {
        // ignore: prefer_const_constructors
        '/chat_page': (context) => ChatPage(
              receiveruserEmail: 'example@email.com',
              receiverUSerID: 'someUserID',
            ),
      },
    );
  }
}
