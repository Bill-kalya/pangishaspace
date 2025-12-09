import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(const PangishaSpaceApp());
}

class PangishaSpaceApp extends StatelessWidget {
  const PangishaSpaceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PangishaSpace Admin',
      theme: ThemeData(
        primaryColor: const Color(0xFF2C3E50),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: const Color(0xFF3498DB),
        ),
        fontFamily: 'Roboto',
      ),
      home: const DashboardScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  // Sample data for charts
  final List<FlSpot> registrationData = [
    FlSpot(0, 12),
    FlSpot(1, 19),
    FlSpot(2, 8),
    FlSpot(3, 15),
    FlSpot(4, 24),
    FlSpot(5, 18),
    FlSpot(6, 22),
  ];

  final List<FlSpot> approvedData = [
    FlSpot(0, 8),
    FlSpot(1, 12),
    FlSpot(2, 6),
    FlSpot(3, 10),
    FlSpot(4, 18),
    FlSpot(5, 14),
    FlSpot(6, 16),
  ];

  final List<PieChartSectionData> statusData = [
    PieChartSectionData(
      value: 985,
      color: const Color(0xFF2ECC71),
      title: '78.9%',
      radius: 60,
      titleStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    PieChartSectionData(
      value: 48,
      color: const Color(0xFFF39C12),
      title: '3.8%',
      radius: 60,
      titleStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    PieChartSectionData(
      value: 197,
      color: const Color(0xFFE74C3C),
      title: '15.8%',
      radius: 60,
      titleStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    PieChartSectionData(
      value: 17,
      color: const Color(0xFF9B59B6),
      title: '1.4%',
      radius: 60,
      titleStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Row(
        children: [
          // Sidebar Navigation
          Container(
            width: 250,
            color: const Color(0xFF2C3E50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    'PangishaSpace',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Divider(color: Colors.white54),
                Expanded(
                  child: ListView(
                    children: [
                      _buildNavItem(Icons.home, 'Dashboard', 0),
                      _buildNavItem(Icons.store, 'Vendor Management', 1),
                      _buildNavItem(
                        Icons.description,
                        'Document Verification',
                        2,
                      ),
                      _buildNavItem(Icons.map, 'Map View', 3),
                      _buildNavItem(Icons.bar_chart, 'Reports & Analytics', 4),
                      _buildNavItem(Icons.settings, 'System Settings', 5),
                      _buildNavItem(Icons.people, 'User Management', 6),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Main Content Area
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  _buildHeader(),
                  const SizedBox(height: 30),

                  // Stats Cards
                  _buildStatsGrid(),
                  const SizedBox(height: 30),

                  // Charts
                  _buildChartsRow(),
                  const SizedBox(height: 30),

                  // Recent Activity & Map
                  _buildActivityAndMap(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String title, int index) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      selected: _selectedIndex == index,
      selectedTileColor: Colors.white.withOpacity(0.1),
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Admin Dashboard',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
          ),
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Color(0xFF3498DB),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    'AD',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Admin User'),
                  Text(
                    'County Government',
                    style: TextStyle(fontSize: 12, color: Color(0xFF7F8C8D)),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 4,
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      childAspectRatio: 1.2,
      children: [
        _buildStatCard(
          'TOTAL VENDORS',
          '1,247',
          Icons.store,
          const Color(0xFF3498DB),
          true,
          '12% from last month',
        ),
        _buildStatCard(
          'PENDING VERIFICATION',
          '48',
          Icons.description,
          const Color(0xFFF39C12),
          false,
          '3% from last week',
        ),
        _buildStatCard(
          'APPROVED VENDORS',
          '985',
          Icons.check_circle,
          const Color(0xFF2ECC71),
          true,
          '8% from last month',
        ),
        _buildStatCard(
          'ILLEGAL REPORTED',
          '17',
          Icons.warning,
          const Color(0xFFE74C3C),
          false,
          '2 from yesterday',
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
    bool isPositive,
    String changeText,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(color: Color(0xFF7F8C8D), fontSize: 14),
              ),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: Colors.white),
              ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Icon(
                isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                color: isPositive
                    ? const Color(0xFF2ECC71)
                    : const Color(0xFFE74C3C),
                size: 14,
              ),
              const SizedBox(width: 4),
              Text(
                changeText,
                style: TextStyle(
                  color: isPositive
                      ? const Color(0xFF2ECC71)
                      : const Color(0xFFE74C3C),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChartsRow() {
    return Row(
      children: [
        Expanded(flex: 2, child: _buildLineChart()),
        const SizedBox(width: 20),
        Expanded(flex: 1, child: _buildPieChart()),
      ],
    );
  }

  Widget _buildLineChart() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Registration Trends',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFDFE6E9)),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: DropdownButton<String>(
                  value: 'Last 7 Days',
                  items: const [
                    DropdownMenuItem(
                      value: 'Last 7 Days',
                      child: Text('Last 7 Days'),
                    ),
                    DropdownMenuItem(
                      value: 'Last 30 Days',
                      child: Text('Last 30 Days'),
                    ),
                    DropdownMenuItem(
                      value: 'Last 90 Days',
                      child: Text('Last 90 Days'),
                    ),
                  ],
                  onChanged: (value) {},
                  underline: const SizedBox(),
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 250,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: registrationData,
                    isCurved: true,
                    color: const Color(0xFF3498DB),
                    barWidth: 3,
                    belowBarData: BarAreaData(
                      show: true,
                      color: const Color(0xFF3498DB).withOpacity(0.1),
                    ),
                    dotData: const FlDotData(show: false),
                  ),
                  LineChartBarData(
                    spots: approvedData,
                    isCurved: true,
                    color: const Color(0xFF2ECC71),
                    barWidth: 3,
                    belowBarData: BarAreaData(
                      show: true,
                      color: const Color(0xFF2ECC71).withOpacity(0.1),
                    ),
                    dotData: const FlDotData(show: false),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPieChart() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Status Distribution',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 250,
            child: PieChart(
              PieChartData(sections: statusData, centerSpaceRadius: 40),
            ),
          ),
          const SizedBox(height: 10),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  Icon(Icons.circle, color: Color(0xFF2ECC71), size: 12),
                  SizedBox(width: 5),
                  Text('Approved', style: TextStyle(fontSize: 12)),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.circle, color: Color(0xFFF39C12), size: 12),
                  SizedBox(width: 5),
                  Text('Pending', style: TextStyle(fontSize: 12)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 5),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  Icon(Icons.circle, color: Color(0xFFE74C3C), size: 12),
                  SizedBox(width: 5),
                  Text('Rejected', style: TextStyle(fontSize: 12)),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.circle, color: Color(0xFF9B59B6), size: 12),
                  SizedBox(width: 5),
                  Text('Reported', style: TextStyle(fontSize: 12)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActivityAndMap() {
    return Row(
      children: [
        Expanded(flex: 2, child: _buildActivityCard()),
        const SizedBox(width: 20),
        Expanded(flex: 1, child: _buildMapCard()),
      ],
    );
  }

  Widget _buildActivityCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Activity',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              Text(
                'View All',
                style: TextStyle(fontSize: 14, color: Color(0xFF3498DB)),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Column(
            children: [
              _buildActivityItem(
                Icons.check_circle,
                'Vendor application approved - Juma Stores',
                '10 minutes ago',
                const Color(0xFF2ECC71),
              ),
              _buildActivityItem(
                Icons.cancel,
                'Vendor application rejected - Mama Ntilie',
                '45 minutes ago',
                const Color(0xFFE74C3C),
              ),
              _buildActivityItem(
                Icons.location_pin,
                'New kiosk reported in Westlands area',
                '2 hours ago',
                const Color(0xFF3498DB),
              ),
              _buildActivityItem(
                Icons.file_upload,
                'New documents uploaded by Kimathi Ventures',
                '5 hours ago',
                const Color(0xFFF39C12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(
    IconData icon,
    String title,
    String time,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 5),
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF7F8C8D),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    );
  }

  Widget _buildMapCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Kiosk Map Overview',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              Text(
                'View Full Map',
                style: TextStyle(fontSize: 14, color: Color(0xFF3498DB)),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Container(
            height: 300,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F2F6),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Icon(Icons.map, size: 50, color: Colors.grey[400]),
            ),
          ),
        ],
      ),
    );
  }
}