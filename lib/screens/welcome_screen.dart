// lib/screens/welcome_screen.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:pangishaspace/screens/vendor_registration.dart';
import 'package:pangishaspace/screens/login_screen.dart';
import 'package:pangishaspace/screens/public_reporter.dart';
import 'package:pangishaspace/screens/admin_registration.dart';
import 'package:pangishaspace/screens/vendor_dashboard.dart';

const Color _mint = Color(0xFFCFF7D5); // light green container
const Color _deep = Color(0xFF234D2F); // darkest green (text/btns)
const Color _deep2 = Color(0xFF2E5E3A); // button body
const double _radius = 28;

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  String? _selectedRole;

  final List<String> _roles = ['Vendor', 'Public Reporter', 'Admin'];

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final containerWidth = math.min(w * 0.92, 820.0);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Container(
            width: containerWidth,
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 30),
            decoration: BoxDecoration(
              color: _mint,
              borderRadius: BorderRadius.circular(32),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 16,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'welcome to',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w700,
                    color: _deep,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Pangisha space',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w800,
                    color: _deep,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '"Organize, Legalize, Thrive."',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                    color: _deep.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 18),

                // Illustration
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 220),
                  child: AspectRatio(
                    aspectRatio: 1.1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          'assets/icons/vendor_icon.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Role selection dropdown
                Center(
                  child: Container(
                    width: 220,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: _deep2,
                      borderRadius: BorderRadius.circular(_radius),
                    ),
                    child: DropdownButton<String>(
                      value: _selectedRole,
                      hint: const Text(
                        'Select Role',
                        style: TextStyle(color: Colors.white),
                      ),
                      isExpanded: true,
                      underline: const SizedBox(),
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.white,
                      ),
                      dropdownColor: _deep2,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      items: _roles.map((role) {
                        return DropdownMenuItem<String>(
                          value: role,
                          child: Text(role),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedRole = value;
                        });
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Bottom Login / Register buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 140,
                      child: _WidePill(
                        label: 'Login',
                        onTap: () {
                          if (_selectedRole == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please select a role first'),
                              ),
                            );
                            return;
                          }
                          if (_selectedRole == 'Vendor') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const VendorDashboardScreen(),
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    SizedBox(
                      width: 140,
                      child: _WidePill(
                        label: 'Register',
                        onTap: () {
                          if (_selectedRole == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please select a role first'),
                              ),
                            );
                            return;
                          }
                          Widget targetScreen;
                          switch (_selectedRole) {
                            case 'Vendor':
                              targetScreen = const VendorRegistration();
                              break;
                            case 'Public Reporter':
                              targetScreen = const PublicReporter();
                              break;
                            case 'Admin':
                              targetScreen = const AdminRegistrationScreen();
                              break;
                            default:
                              targetScreen = const LoginScreen();
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => targetScreen,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Reusable wide pill widget
class _WidePill extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _WidePill({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _deep2,
      borderRadius: BorderRadius.circular(28),
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: onTap,
        child: SizedBox(
          height: 44,
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
