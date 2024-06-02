import 'package:firebase_example_project/data/remote/firebase_repository.dart';
import 'package:firebase_example_project/presentations/screens/auth/auth_screen.dart';
import 'package:firebase_example_project/presentations/screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    checkLoggerUser();
    super.initState();
  }

  checkLoggerUser() async {
    await Future.delayed(const Duration(seconds: 2), () {
      if (FireBaseRepo().checkCurrentUser()) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const ProfileScreen(),
          ),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const AuthScreen(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: Text('Firebase Example'),
        ),
      ),
    );
  }
}
