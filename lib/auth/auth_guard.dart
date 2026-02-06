import 'package:flutter/material.dart';
import 'auth_service.dart';
import '../screens/login_screen.dart';

class AuthGuard extends StatelessWidget {
  final Widget child;

  const AuthGuard({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: AuthService().isLoggedIn(),
      builder: (context, snapshot) {
        // Loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Not logged in → redirect
        if (!snapshot.hasData || snapshot.data == false) {
          return const LoginScreen();
        }

        // Logged in → allow access
        return child;
      },
    );
  }
}
