import 'package:firebase_example_project/data/remote/firebase_repository.dart';
import 'package:firebase_example_project/main.dart';
import 'package:firebase_example_project/presentations/screens/auth/auth_screen.dart';
import 'package:firebase_example_project/presentations/screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  final _fireRepo = FireBaseRepo();
  final TextEditingController _emailController = TextEditingController();
  TextEditingController get emailController => _emailController;

  final TextEditingController _passwordController = TextEditingController();
  TextEditingController get passwordController => _passwordController;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey get formKey => _formKey;

  bool _hasAccount = false;

  bool get hasAccount => _hasAccount;

  set hasAccount(bool newValue) {
    _hasAccount = newValue;
    notifyListeners();
  }

  void reset() {
    _emailController.clear();
    _passwordController.clear();
  }

  checkLoggerUser() async {
    await Future.delayed(const Duration(seconds: 2), () {
      final flag = FireBaseRepo().checkCurrentUser();
      if (navigatorStateKey.currentContext != null) {
        Navigator.of(navigatorStateKey.currentContext!).pushReplacement(
          MaterialPageRoute(
            builder: (_) => flag ? const ProfileScreen() : const AuthScreen(),
          ),
        );
      }
    });
  }

  Future<void> logout() async {
    _fireRepo.logout().whenComplete(() {
      if (navigatorStateKey.currentContext != null) {
        Navigator.of(navigatorStateKey.currentContext!).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const AuthScreen()),
            (route) => false);
      }
    });
  }

  Future<void> authAction() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (isValid) {
      // String message = _hasAccount
      //     ? 'You are successfully logined'
      //     : 'You are successfully registered';
      Future<bool?> authFuture = _hasAccount
          ? _fireRepo.signInWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text)
          : _fireRepo.createUserWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text);

      await authFuture.then((value) {
        reset();
        if (value != null && value) {
          if (navigatorStateKey.currentContext != null) {
            Navigator.of(navigatorStateKey.currentContext!).pushReplacement(
              MaterialPageRoute(
                builder: (_) => const ProfileScreen(),
              ),
            );
            // ScaffoldMessenger.of(navigatorStateKey.currentContext!)
            //     .showSnackBar(
            //   SnackBar(
            //     content: Text(
            //       message,
            //       style: const TextStyle(color: Colors.white),
            //     ),
            //   ),
            // );
          }
        }
      }).catchError((err) {
        final errorMessage = (err as MyExeption).message;
        if (navigatorStateKey.currentContext != null) {
          ScaffoldMessenger.of(navigatorStateKey.currentContext!).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red[300],
              content: Text(
                errorMessage,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          );
        }
      });
    }
  }
}
