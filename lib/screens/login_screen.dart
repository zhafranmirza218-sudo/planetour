import 'package:flutter/material.dart';
import '../main.dart';
import '../models/ticket_model.dart' hide UserAccount;

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (c) => MainNavigation(
                userData: UserAccount(name: "Mirza", email: "mirza@ui.ac.id"),
              ),
            ),
          ),
          child: const Text("MASUK KE PLANETOUR"),
        ),
      ),
    );
  }
}