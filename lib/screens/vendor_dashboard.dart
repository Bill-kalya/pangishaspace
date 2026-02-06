import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// ===========================
/// ENTRY POINT
/// ===========================
void main() {
  runApp(const PangishaSpaceVendorApp());
}

/// ===========================
/// ROOT APP
/// ===========================
class PangishaSpaceVendorApp extends StatelessWidget {
  const PangishaSpaceVendorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PangishaSpace Vendor',
      theme: ThemeData(primaryColor: const Color(0xFF27AE60)),
      home: const VendorDashboardScreen(
        jwtToken: 'PUT_VENDOR_JWT_HERE',
      ),
    );
  }
}

/// ===========================
/// DATA MODELS
/// ===========================
class VendorDashboardData {
  final String businessName;
  final String vendorId;
  final String status;
  final String permitNumber;
  final String nextStep;
  final String locationStatus;

  VendorDashboardData({
    required this.businessName,
    required this.vendorId,
    required this.status,
    required this.permitNumber,
    required this.nextStep,
    required this.locationStatus,
  });

  factory VendorDashboardData.fromJson(Map<String, dynamic> json) {
    return VendorDashboardData(
      businessName: json['businessName'],
      vendorId: json['vendorId'],
      status: json['status'],
      permitNumber: json['permitNumber'],
      nextStep: json['nextStep'],
      locationStatus: json['locationStatus'],
    );
  }
}

class VendorDocument {
  final String name;
  final String status;

  VendorDocument(this.name, this.status);

  factory VendorDocument.fromJson(Map<String, dynamic> json) =>
      VendorDocument(json['name'], json['status']);
}

class VendorNotification {
  final String message;
  final String time;

  VendorNotification(this.message, this.time);

  factory VendorNotification.fromJson(Map<String, dynamic> json) =>
      VendorNotification(json['message'], json['time']);
}

/// ===========================
/// API CLIENT
/// ===========================
class VendorApi {
  static const baseUrl = 'http://localhost:8080/api/vendor';

  static Future<VendorDashboardData> dashboard(String token) async {
    final res = await http.get(
      Uri.parse('$baseUrl/dashboard'),
      headers: {'Authorization': 'Bearer $token'},
    );
    return VendorDashboardData.fromJson(jsonDecode(res.body));
  }

  static Future<List<VendorDocument>> documents(String token) async {
    final res = await http.get(
      Uri.parse('$baseUrl/documents'),
      headers: {'Authorization': 'Bearer $token'},
    );
    return (jsonDecode(res.body) as List)
        .map((e) => VendorDocument.fromJson(e))
        .toList();
  }

  static Future<List<VendorNotification>> notifications(String token) async {
    final res = await http.get(
      Uri.parse('$baseUrl/notifications'),
      headers: {'Authorization': 'Bearer $token'},
    );
    return (jsonDecode(res.body) as List)
        .map((e) => VendorNotification.fromJson(e))
        .toList();
  }
}

/// ===========================
/// DASHBOARD SCREEN
/// ===========================
class VendorDashboardScreen extends StatefulWidget {
  final String jwtToken;

  const VendorDashboardScreen({super.key, required this.jwtToken});

  @override
  State<VendorDashboardScreen> createState() => _VendorDashboardScreenState();
}

class _VendorDashboardScreenState extends State<VendorDashboardScreen> {
  VendorDashboardData? dashboard;
  List<VendorDocument> documents = [];
  List<VendorNotification> notifications = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    dashboard = await VendorApi.dashboard(widget.jwtToken);
    documents = await VendorApi.documents(widget.jwtToken);
    notifications = await VendorApi.notifications(widget.jwtToken);
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Row(
        children: [
          _sidebar(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _header(),
                  const SizedBox(height: 30),
                  _applicationStatus(),
                  const SizedBox(height: 30),
                  _documentsAndNotifications(),
                  const SizedBox(height: 30),
                  _mapPreview(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ===========================
  /// UI
  /// ===========================
  Widget _sidebar() {
    return Container(
      width: 250,
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('PangishaSpace',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF27AE60))),
          const SizedBox(height: 30),
          Text(dashboard!.businessName,
              style: const TextStyle(fontSize: 16)),
          Text('Vendor ID: ${dashboard!.vendorId}',
              style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const Divider(),
        ],
      ),
    );
  }

  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Vendor Dashboard',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
        Chip(
          label: Text(dashboard!.status),
          backgroundColor: dashboard!.status == 'APPROVED'
              ? Colors.green.shade100
              : Colors.orange.shade100,
        )
      ],
    );
  }

  Widget _applicationStatus() {
    return _card(Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Permit #: ${dashboard!.permitNumber}',
            style: const TextStyle(color: Color(0xFF2980B9))),
        const SizedBox(height: 10),
        Text(dashboard!.nextStep),
        const SizedBox(height: 10),
        Text('Location status: ${dashboard!.locationStatus}'),
      ],
    ));
  }

  Widget _documentsAndNotifications() {
    return Row(
      children: [
        Expanded(
            child: _card(Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Documents',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ...documents.map((d) => Text('${d.name}: ${d.status}')),
          ],
        ))),
        const SizedBox(width: 20),
        Expanded(
            child: _card(Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Notifications',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ...notifications.map(
                (n) => Text('• ${n.message} (${n.time})')),
          ],
        ))),
      ],
    );
  }

  Widget _mapPreview() {
    return _card(const Center(
      child: Text('Kiosk location loaded from PostGIS'),
    ));
  }

  Widget _card(Widget child) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: child,
    );
  }
}
