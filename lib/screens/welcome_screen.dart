import 'dart:math' as math;
import 'package:flutter/material.dart';

import 'vendor_registration.dart';
import 'login_screen.dart';
import 'public_reporter.dart';
import 'admin_registration.dart';
import 'vendor_dashboard.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  String? _selectedRole;

  late AnimationController _animController;
  late Animation<double> _scaleAnim;

  final List<_RoleItem> _roles = const [
    _RoleItem('Vendor', Icons.store),
    _RoleItem('Public Reporter', Icons.report),
    _RoleItem('Admin', Icons.admin_panel_settings),
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );
    _scaleAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutBack,
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _goLogin() {
    if (_selectedRole == null) {
      _toast('Please select a role first');
      return;
    }

    if (_selectedRole == 'Vendor') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const VendorDashboardScreen()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  void _goRegister() {
    if (_selectedRole == null) {
      _toast('Please select a role first');
      return;
    }

    late Widget screen;
    switch (_selectedRole) {
      case 'Vendor':
        screen = const VendorRegistration();
        break;
      case 'Public Reporter':
        screen = const PublicReporter();
        break;
      case 'Admin':
        screen = const AdminRegistrationScreen();
        break;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bg = isDark ? const Color(0xFF0F1F16) : const Color(0xFFCFF7D5);
    final deep = isDark ? Colors.white : const Color(0xFF234D2F);
    final pill = isDark ? const Color(0xFF1E3A2A) : const Color(0xFF2E5E3A);

    final w = MediaQuery.of(context).size.width;
    final boxWidth = math.min(w * 0.92, 820.0);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Container(
            width: boxWidth,
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 30),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(32),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 18,
                  color: Colors.black26,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'welcome to',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w700,
                    color: deep,
                  ),
                ),
                Text(
                  'Pangisha space',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w800,
                    color: deep,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '"Organize, Legalize, Thrive."',
                  style: TextStyle(
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                    color: deep.withValues(alpha: 0.85),
                  ),
                ),
                const SizedBox(height: 20),

                // illustration
                SizedBox(
                  height: 200,
                  child: Image.asset(
                    'assets/icons/vendor_icon.png',
                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(height: 14),

                // animated role dropdown
                ScaleTransition(
                  scale: _scaleAnim,
                  child: _RoleDropdown(
                    roles: _roles,
                    value: _selectedRole,
                    pillColor: pill,
                    textColor: Colors.white,
                    onTap: () => _animController.forward(from: 0),
                    onChanged: (val) {
                      setState(() => _selectedRole = val);
                    },
                  ),
                ),

                const SizedBox(height: 26),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _PillButton(label: 'Login', color: pill, onTap: _goLogin),
                    const SizedBox(width: 18),
                    _PillButton(
                        label: 'Register', color: pill, onTap: _goRegister),
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

/* -------------------- UI WIDGETS -------------------- */

class _RoleDropdown extends StatelessWidget {
  final List<_RoleItem> roles;
  final String? value;
  final Color pillColor;
  final Color textColor;
  final VoidCallback onTap;
  final ValueChanged<String?> onChanged;

  const _RoleDropdown({
    required this.roles,
    required this.value,
    required this.pillColor,
    required this.textColor,
    required this.onTap,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240,
      child: DropdownButtonFormField<String>(
        value: value,
        onTap: onTap,
        dropdownColor: pillColor,
        icon: Icon(Icons.expand_more, color: textColor),
        decoration: InputDecoration(
          filled: true,
          fillColor: pillColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: BorderSide.none,
          ),
        ),
        hint: Text('Select Role', style: TextStyle(color: textColor)),
        style: TextStyle(color: textColor, fontSize: 16),
        items: roles.map((r) {
          return DropdownMenuItem(
            value: r.label,
            child: Row(
              children: [
                Icon(r.icon, color: textColor),
                const SizedBox(width: 10),
                Text(r.label),
              ],
            ),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}

class _PillButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _PillButton({
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      height: 44,
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(28),
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: onTap,
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/* -------------------- MODEL -------------------- */

class _RoleItem {
  final String label;
  final IconData icon;
  const _RoleItem(this.label, this.icon);
}
