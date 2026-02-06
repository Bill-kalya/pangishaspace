import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

/// ===========================
/// PUBLIC REPORTER SCREEN
/// ===========================
class PublicReporter extends StatefulWidget {
  const PublicReporter({super.key});

  @override
  State<PublicReporter> createState() => _PublicReporterState();
}

class _PublicReporterState extends State<PublicReporter> {
  // Theme colors
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

  bool loading = false;
  Map<String, dynamic>? _rawLocationData;

  @override
  void initState() {
    super.initState();
    _loadLocationData();
  }

  /// ===========================
  /// LOAD LOCATION DATA
  /// ===========================
  Future<void> _loadLocationData() async {
    final data = await rootBundle.loadString('assets/counties.json');
    final jsonData = json.decode(data);

    _rawLocationData = jsonData;

    setState(() {
      counties = (jsonData['counties'] as List)
          .map((c) => c['name'] as String)
          .toList();

      streets = (jsonData['streets'] as List).cast<String>();

      if (counties.isNotEmpty) {
        selectedCounty = counties.first;
        _updateSubCounties();
      }
    });
  }

  void _updateSubCounties() {
    if (selectedCounty == null || _rawLocationData == null) return;

    final countyData =
        (_rawLocationData!['counties'] as List).firstWhere(
      (c) => c['name'] == selectedCounty,
      orElse: () => null,
    );

    if (countyData != null) {
      setState(() {
        subCounties =
            (countyData['sub_counties'] as List).cast<String>();
        selectedSubCounty =
            subCounties.isNotEmpty ? subCounties.first : null;
      });
    }
  }

  /// ===========================
  /// SUBMIT REPORT
  /// ===========================
  Future<void> _submitReport() async {
    if (selectedCounty == null ||
        selectedSubCounty == null ||
        selectedStreet == null) {
      _toast('Please complete all fields');
      return;
    }

    setState(() => loading = true);

    final payload = {
      "county": selectedCounty,
      "subCounty": selectedSubCounty,
      "street": selectedStreet,
      // placeholder GPS (replace with real GPS later)
      "latitude": -1.286389,
      "longitude": 36.817223,
      "description": "Reported via PangishaSpace mobile app"
    };

    try {
      final res = await http.post(
        Uri.parse('http://localhost:8080/api/public/reports'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        _toast('Report submitted successfully');
      } else {
        _toast('Failed to submit report');
      }
    } catch (e) {
      _toast('Network error');
    }

    setState(() => loading = false);
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  /// ===========================
  /// UI
  /// ===========================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Text(
                "Report Location",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '"Help us identify illegal structures"',
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 30),

              _dropdown(
                label: "County",
                value: selectedCounty,
                items: counties,
                onChanged: (v) {
                  setState(() {
                    selectedCounty = v;
                    _updateSubCounties();
                  });
                },
              ),
              const SizedBox(height: 16),

              _dropdown(
                label: "Sub-County",
                value: selectedSubCounty,
                items: subCounties,
                onChanged: (v) =>
                    setState(() => selectedSubCounty = v),
              ),
              const SizedBox(height: 16),

              _dropdown(
                label: "Street",
                value: selectedStreet,
                items: streets,
                onChanged: (v) =>
                    setState(() => selectedStreet = v),
              ),
              const SizedBox(height: 40),

              SizedBox(
                width: 160,
                height: 50,
                child: ElevatedButton(
                  onPressed: loading ? null : _submitReport,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _deepGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: loading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          "SUBMIT",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
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

  Widget _dropdown({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.w500)),
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
            underline: const SizedBox(),
            icon:
                const Icon(Icons.arrow_drop_down, color: _accentGreen),
            items: items
                .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    ))
                .toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
