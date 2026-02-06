import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;

/// ===========================
/// ENTRY POINT
/// ===========================
void main() {
  runApp(const PangishaSpaceApp());
}

/// ===========================
/// ROOT APP
/// ===========================
class PangishaSpaceApp extends StatefulWidget {
  const PangishaSpaceApp({super.key});

  @override
  State<PangishaSpaceApp> createState() => _PangishaSpaceAppState();
}

class _PangishaSpaceAppState extends State<PangishaSpaceApp> {
  bool dark = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: dark ? ThemeData.dark() : ThemeData.light(),
      home: DashboardScreen(
        isDarkMode: dark,
        onToggleTheme: () => setState(() => dark = !dark),
        jwtToken: 'PUT_REAL_JWT_HERE',
        userRole: 'ADMIN',
      ),
    );
  }
}

/// ===========================
/// DATA MODELS
/// ===========================
class DashboardStats {
  final int totalVendors;
  final int pending;
  final int approved;
  final int reported;
  final double growthRate;
  final int riskZones;

  DashboardStats({
    required this.totalVendors,
    required this.pending,
    required this.approved,
    required this.reported,
    required this.growthRate,
    required this.riskZones,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      totalVendors: json['totalVendors'],
      pending: json['pending'],
      approved: json['approved'],
      reported: json['reported'],
      growthRate: (json['growthRate'] ?? 0).toDouble(),
      riskZones: json['riskZones'] ?? 0,
    );
  }
}

/// ===========================
/// API CLIENT
/// ===========================
class AdminApi {
  static const baseUrl = 'http://localhost:8080/api/admin';

  static Future<DashboardStats> getStats(String token) async {
    final res = await http.get(
      Uri.parse('$baseUrl/dashboard/stats'),
      headers: {'Authorization': 'Bearer $token'},
    );
    return DashboardStats.fromJson(jsonDecode(res.body));
  }

  static Future<List<FlSpot>> getTrend(
      String token, String endpoint) async {
    final res = await http.get(
      Uri.parse('$baseUrl/analytics/$endpoint'),
      headers: {'Authorization': 'Bearer $token'},
    );

    final List data = jsonDecode(res.body);
    return data
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble(), e.value.toDouble()))
        .toList();
  }
}

/// ===========================
/// DASHBOARD
/// ===========================
class DashboardScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;
  final String jwtToken;
  final String userRole;

  const DashboardScreen({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
    required this.jwtToken,
    required this.userRole,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  DashboardStats? stats;
  List<FlSpot> registrations = [];
  List<FlSpot> approvals = [];
  bool loading = true;

  bool get isAdmin => widget.userRole == 'ADMIN';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    stats = await AdminApi.getStats(widget.jwtToken);
    registrations =
        await AdminApi.getTrend(widget.jwtToken, 'registrations');
    approvals =
        await AdminApi.getTrend(widget.jwtToken, 'approvals');
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (!isAdmin) {
      return const Scaffold(
        body: Center(child: Text('ADMIN ONLY')),
      );
    }

    return Scaffold(
      body: Row(
        children: [
          _sidebar(),
          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        _header(),
                        const SizedBox(height: 25),
                        _stats(),
                        const SizedBox(height: 25),
                        _kpis(),
                        const SizedBox(height: 25),
                        _charts(),
                        const SizedBox(height: 25),
                        _bottom(),
                      ],
                    ),
                  ),
          )
        ],
      ),
    );
  }

  /// ===========================
  /// UI SECTIONS
  /// ===========================
  Widget _sidebar() {
    return Container(
      width: 240,
      color: Colors.blueGrey.shade900,
      child: const Column(
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: Text('PangishaSpace',
                style: TextStyle(color: Colors.white, fontSize: 22)),
          ),
          Divider(color: Colors.white24),
        ],
      ),
    );
  }

  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Admin Dashboard',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
        Row(
          children: [
            IconButton(
              icon: Icon(widget.isDarkMode
                  ? Icons.light_mode
                  : Icons.dark_mode),
              onPressed: widget.onToggleTheme,
            ),
            const CircleAvatar(child: Text('AD')),
          ],
        )
      ],
    );
  }

  Widget _stats() {
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      childAspectRatio: 1.4,
      children: [
        _Stat('Vendors', stats!.totalVendors, Icons.store),
        _Stat('Pending', stats!.pending, Icons.pending),
        _Stat('Approved', stats!.approved, Icons.check),
        _Stat('Reported', stats!.reported, Icons.warning),
      ],
    );
  }

  Widget _kpis() {
    return Row(
      children: [
        Expanded(
            child: _card(Text(
                'Growth Rate\n${stats!.growthRate.toStringAsFixed(1)}%',
                style: const TextStyle(fontSize: 22)))),
        const SizedBox(width: 20),
        Expanded(
            child: _card(Text('Risk Zones\n${stats!.riskZones}',
                style: const TextStyle(fontSize: 22)))),
      ],
    );
  }

  Widget _charts() {
    return Row(
      children: [
        Expanded(child: _lineChart()),
        const SizedBox(width: 20),
        Expanded(child: _pieChart()),
      ],
    );
  }

  Widget _lineChart() {
    return _card(LineChart(LineChartData(
      lineBarsData: [
        LineChartBarData(spots: registrations, color: Colors.blue),
        LineChartBarData(spots: approvals, color: Colors.green),
      ],
      titlesData: const FlTitlesData(show: false),
      borderData: FlBorderData(show: false),
    )));
  }

  Widget _pieChart() {
    return _card(PieChart(PieChartData(sections: [
      PieChartSectionData(
          value: stats!.approved.toDouble(),
          title: 'Approved',
          color: Colors.green),
      PieChartSectionData(
          value: stats!.pending.toDouble(),
          title: 'Pending',
          color: Colors.orange),
      PieChartSectionData(
          value: stats!.reported.toDouble(),
          title: 'Reported',
          color: Colors.red),
    ])));
  }

  Widget _bottom() {
    return Row(
      children: [
        Expanded(
            child: _card(const Text(
                'Recent Activity\n• Vendor approved\n• Kiosk flagged'))),
        const SizedBox(width: 20),
        Expanded(
            child: _card(const Text(
                'Heatmap powered by PostGIS\n(Loaded dynamically)'))),
      ],
    );
  }

  Widget _card(Widget child) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: child,
    );
  }
}

/// ===========================
/// STAT CARD
/// ===========================
class _Stat extends StatelessWidget {
  final String title;
  final int value;
  final IconData icon;

  const _Stat(this.title, this.value, this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).cardColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon),
          const Spacer(),
          Text('$value',
              style:
                  const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
          Text(title),
        ],
      ),
    );
  }
}
