import 'package:flutter/material.dart';
import '../auth/auth_service.dart';
import 'admin_dashboard.dart';
import 'vendor_dashboard.dart';
import 'public_reporter.dart';

final authService = AuthService();

void handleLogin(BuildContext context, String email, String password) async {
  final success = await authService.login(email, password);

  if (!success) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Invalid credentials')),
    );
    return;
  }

  final role = await authService.getRole();

  if (role == 'ADMIN') {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => DashboardScreen(
        isDarkMode: false,
        onToggleTheme: () {},
        userRole: 'ADMIN',
      )),
    );
  } else if (role == 'VENDOR') {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const VendorDashboardScreen()),
    );
  } else {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const PublicReporter()),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController idController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Colors
  static const Color _containerColor = Color(0xFFCCFFD8); // Light green
  static const Color _deepGreen = Color(0xFF2F5D36); // Dark green
  static const Color _accentGreen = Color(0xFF234D2F); // Accent green

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          width: 350,
          decoration: BoxDecoration(
            color: _containerColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: _deepGreen,
                  ),
                ),
                const SizedBox(height: 30),

                // ID Number or Email
                _buildTextField(
                  controller: idController,
                  label: "ID Number or Email",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Password
                _buildTextField(
                  controller: passwordController,
                  label: "Password",
                  isObscure: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),

                // Submit Button
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        handleLogin(context, idController.text, passwordController.text);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _deepGreen,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 28, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ), // Added missing closing parenthesis here
                    ), // And here
                    child: const Text(
                      "SUBMIT",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool isObscure = false,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.black87),
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          obscureText: isObscure,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide.none,
            ),
            errorStyle: const TextStyle(color: Colors.red),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: const BorderSide(color: Colors.red),
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }
}