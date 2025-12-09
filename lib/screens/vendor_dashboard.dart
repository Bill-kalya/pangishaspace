import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  runApp(const PangishaSpaceVendorApp());
}

class PangishaSpaceVendorApp extends StatelessWidget {
  const PangishaSpaceVendorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PangishaSpace Vendor',
      theme: ThemeData(
        primaryColor: const Color(0xFF27AE60),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: const Color(0xFF2980B9),
        ),
        fontFamily: 'Roboto',
      ),
      home: const VendorDashboardScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class VendorDashboardScreen extends StatefulWidget {
  const VendorDashboardScreen({super.key});

  @override
  State<VendorDashboardScreen> createState() => _VendorDashboardScreenState();
}

class _VendorDashboardScreenState extends State<VendorDashboardScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Row(
        children: [
          // Sidebar Navigation
          Container(
            width: 250,
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    'PangishaSpace',
                    style: TextStyle(
                      color: Color(0xFF27AE60),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Divider(color: Color(0xFFDFE6E9)),
                // Vendor Profile
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          color: Color(0xFF2980B9),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text(
                            'JS',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Juma Stores',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Vendor ID: PS-2386',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF7F8C8D),
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Approved',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF27AE60),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(color: Color(0xFFDFE6E9)),
                Expanded(
                  child: ListView(
                    children: [
                      _buildNavItem(Icons.home, 'Dashboard', 0),
                      _buildNavItem(Icons.description, 'Application Status', 1),
                      _buildNavItem(
                        Icons.file_upload,
                        'Document Management',
                        2,
                      ),
                      _buildNavItem(Icons.location_on, 'Location Details', 3),
                      _buildNavItem(Icons.history, 'Payment History', 4),
                      _buildNavItem(Icons.notifications, 'Notifications', 5),
                      _buildNavItem(Icons.help, 'Help & Support', 6),
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

                  // Application Status
                  _buildApplicationStatus(),
                  const SizedBox(height: 30),

                  // Action Cards
                  _buildActionCards(),
                  const SizedBox(height: 30),

                  // Documents & Notifications
                  _buildDocumentsAndNotifications(),
                  const SizedBox(height: 30),

                  // Map Preview
                  _buildMapPreview(),
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
      leading: Icon(icon, color: const Color(0xFF27AE60)),
      title: Text(title),
      selected: _selectedIndex == index,
      selectedTileColor: const Color(0xFF27AE60).withOpacity(0.1),
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
            'Vendor Dashboard',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
          ),
          Stack(
            children: [
              const Icon(
                Icons.notifications,
                color: Color(0xFF7F8C8D),
                size: 28,
              ),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE74C3C),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      '3',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildApplicationStatus() {
    return Container(
      padding: const EdgeInsets.all(25),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Application Status',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              Text(
                'Permit #: LC-7892-2023',
                style: TextStyle(fontSize: 14, color: Color(0xFF2980B9)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Timeline
          _buildTimeline(),
          const SizedBox(height: 20),
          // Info Box
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: const Color(0xFF27AE60).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.info, color: Color(0xFF27AE60), size: 20),
                    const SizedBox(width: 10),
                    const Text(
                      'Your application is currently undergoing location verification.',
                      style: TextStyle(color: Color(0xFF27AE60)),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  'An officer will visit your kiosk within 3 business days.',
                  style: TextStyle(color: Color(0xFF27AE60)),
                ),
                const SizedBox(height: 10),
                Text(
                  'Next step: Permit issuance and payment of licensing fees.',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildTimelineStep(Icons.person, 'Profile Created', completed: true),
        _buildTimelineStep(
          Icons.file_upload,
          'Documents Uploaded',
          completed: true,
        ),
        _buildTimelineStep(Icons.search, 'Under Review', completed: true),
        _buildTimelineStep(
          Icons.location_on,
          'Location Verification',
          active: true,
        ),
        _buildTimelineStep(Icons.check_circle, 'Approval'),
      ],
    );
  }

  Widget _buildTimelineStep(
    IconData icon,
    String label, {
    bool completed = false,
    bool active = false,
  }) {
    Color stepColor;
    if (active) {
      stepColor = const Color(0xFF2980B9);
    } else if (completed) {
      stepColor = const Color(0xFF27AE60);
    } else {
      stepColor = const Color(0xFFDFE6E9);
    }

    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(color: stepColor, shape: BoxShape.circle),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: 100,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: completed || active ? Colors.black : Colors.grey,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionCards() {
    return Row(
      children: [
        Expanded(
          child: _buildActionCard(
            Icons.file_upload,
            'Upload Documents',
            'Submit required documents for your permit application. You need to upload your ID, business permit, and location authorization.',
            const Color(0xFF27AE60),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: _buildActionCard(
            Icons.location_on,
            'Update Location',
            'Update your kiosk location details or request a change of location through the proper channels.',
            const Color(0xFF27AE60),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: _buildActionCard(
            Icons.sync,
            'Renew Permit',
            'Your current permit expires in 45 days. Start the renewal process early to avoid interruptions.',
            const Color(0xFF27AE60),
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard(
    IconData icon,
    String title,
    String description,
    Color color,
  ) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
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
          const SizedBox(height: 15),
          Text(
            description,
            style: const TextStyle(color: Color(0xFF7F8C8D), fontSize: 14),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: const Text(
                'Take Action',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentsAndNotifications() {
    return Row(
      children: [
        Expanded(child: _buildDocumentsCard()),
        const SizedBox(width: 20),
        Expanded(child: _buildNotificationsCard()),
      ],
    );
  }

  Widget _buildDocumentsCard() {
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
                'Document Status',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              Text(
                'View All',
                style: TextStyle(fontSize: 14, color: Color(0xFF2980B9)),
              ),
            ],
          ),
          const SizedBox(height: 15),
          _buildDocumentItem(
            Icons.credit_card,
            'National ID',
            'Approved',
            const Color(0xFF27AE60),
          ),
          _buildDocumentItem(
            Icons.description,
            'Business Permit',
            'Under Review',
            const Color(0xFFF39C12),
          ),
          _buildDocumentItem(
            Icons.map,
            'Location Authorization',
            'Needs Reupload',
            const Color(0xFFE74C3C),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentItem(
    IconData icon,
    String title,
    String status,
    Color statusColor,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF2980B9),
              borderRadius: BorderRadius.circular(8),
            ),
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
                  status,
                  style: TextStyle(fontSize: 12, color: statusColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsCard() {
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
                'Recent Notifications',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              Text(
                'View All',
                style: TextStyle(fontSize: 14, color: Color(0xFF2980B9)),
              ),
            ],
          ),
          const SizedBox(height: 15),
          _buildNotificationItem(
            Icons.info,
            'Your document submission has been received and is under review.',
            '2 hours ago',
          ),
          _buildNotificationItem(
            Icons.warning,
            'Your location authorization document was rejected. Please upload a clearer copy.',
            '1 day ago',
          ),
          _buildNotificationItem(
            Icons.calendar_today,
            'Remember to renew your permit 30 days before expiration to avoid penalties.',
            '3 days ago',
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(IconData icon, String message, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF27AE60),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(message, style: const TextStyle(height: 1.4)),
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
      ),
    );
  }

  Widget _buildMapPreview() {
    return Container(
      height: 250,
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
      child: Center(child: Icon(Icons.map, size: 50, color: Colors.grey[400])),
    );
  }
}
