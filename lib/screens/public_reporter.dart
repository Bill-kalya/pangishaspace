import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class PublicReporter extends StatefulWidget {
  const PublicReporter({super.key});

  @override
  State<PublicReporter> createState() => _PublicReporterState();
}

class _PublicReporterState extends State<PublicReporter> {
  // Colors
  static const Color _lightGreen = Color(0xFFCFF7D5);
  static const Color _deepGreen = Color(0xFF2E5E3A);
  static const Color _accentGreen = Color(0xFF234D2F);

  // Location data
  List<String> counties = [];
  List<String> subCounties = [];
  List<String> streets = [];
  
  String? selectedCounty;
  String? selectedSubCounty;
  String? selectedStreet;

  @override
  void initState() {
    super.initState();
    _loadLocationData();
  }

  Future<void> _loadLocationData() async {
    final data = await rootBundle.loadString('assets/counties.json');
    final jsonData = json.decode(data);
    
    setState(() {
      counties = (jsonData['counties'] as List)
          .map((county) => county['name'] as String)
          .toList();
      
      streets = (jsonData['streets'] as List).cast<String>();
      
      // Initialize subCounties if a county is pre-selected
      if (counties.isNotEmpty) {
        selectedCounty = counties.first;
        _updateSubCounties(jsonData);
      }
    });
  }

  void _updateSubCounties(dynamic jsonData) {
    if (selectedCounty == null) return;
    
    final countyData = (jsonData['counties'] as List).firstWhere(
      (county) => county['name'] == selectedCounty,
      orElse: () => null,
    );
    
    if (countyData != null) {
      setState(() {
        subCounties = (countyData['sub_counties'] as List).cast<String>();
        selectedSubCounty = subCounties.isNotEmpty ? subCounties.first : null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Report",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                "Location",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '"Help us identify the area."',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 30),

              // County Dropdown
              _buildLocationDropdown(
                label: "County",
                value: selectedCounty,
                items: counties,
                onChanged: (value) {
                  setState(() {
                    selectedCounty = value;
                    _loadLocationData();
                  });
                },
              ),
              const SizedBox(height: 16),

              // Sub-County Dropdown
              _buildLocationDropdown(
                label: "Sub-County",
                value: selectedSubCounty,
                items: subCounties,
                onChanged: (value) => setState(() => selectedSubCounty = value),
              ),
              const SizedBox(height: 16),

              // Street Dropdown
              _buildLocationDropdown(
                label: "Street",
                value: selectedStreet,
                items: streets,
                onChanged: (value) => setState(() => selectedStreet = value),
              ),
              
              const SizedBox(height: 40),

              // Submit Button (Rectangular)
              SizedBox(
                width: 160,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle submission
                    print('Selected: $selectedCounty, $selectedSubCounty, $selectedStreet');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _deepGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ), // Added missing closing parenthesis here
                  child: const Text(
                    "SUBMIT",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: _lightGreen,
            borderRadius: BorderRadius.circular(6),
          ),
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            underline: const SizedBox(), // Remove default underline
            icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF234D2F)),
            items: items.map((e) => DropdownMenuItem(
              value: e,
              child: Text(e, style: const TextStyle(color: Colors.black87)),
            )).toList(), // Fixed the parenthesis and toList() placement
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}