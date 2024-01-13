import 'package:chatapp/pages/home_page.dart';
import 'package:chatapp/services/auth/login_or_register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

//tocheck if the user is logged in or not
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          // ignore: non_constant_identifier_names
          builder: (context, Snapshot) {
            //user is logged in
            if (Snapshot.hasData) {
              return const HomePage();
            }

            //user is NOT logged in
            else {
              return const LoginOrRegister();
            }
          }),
    );
  }
}
