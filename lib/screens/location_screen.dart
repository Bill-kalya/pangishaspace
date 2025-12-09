import 'package:flutter/material.dart';

void main() {
  runApp(const PangishaApp());
}

class PangishaApp extends StatelessWidget {
  const PangishaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LocationScreen(),
    );
  }
}

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  String? selectedCounty;
  String? selectedSubCounty;
  String? selectedStreet;

  final List<String> counties = ["County 1", "County 2", "County 3"];
  final List<String> subCounties = ["Sub-County 1", "Sub-County 2"];
  final List<String> streets = ["Street 1", "Street 2"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Background white
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          width: 350,
          decoration: BoxDecoration(
            color: const Color(0xFFE0E0DE), // Light grey
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Location",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2F5D36), // Green text
                ),
              ),
              const SizedBox(height: 30),

              // County & Sub-County Row
              Row(
                children: [
                  Expanded(
                    child: buildDropdown(
                      label: "County",
                      value: selectedCounty,
                      items: counties,
                      onChanged: (val) {
                        setState(() {
                          selectedCounty = val;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: buildDropdown(
                      label: "Sub-County",
                      value: selectedSubCounty,
                      items: subCounties,
                      onChanged: (val) {
                        setState(() {
                          selectedSubCounty = val;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Street
              buildDropdown(
                label: "Street",
                value: selectedStreet,
                items: streets,
                onChanged: (val) {
                  setState(() {
                    selectedStreet = val;
                  });
                },
              ),
              const SizedBox(height: 30),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [buildButton("Previous"), buildButton("SUBMIT")],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.black)),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
          ),
          child: DropdownButton<String>(
            value: value,
            hint: const Text(""),
            isExpanded: true,
            underline: const SizedBox(),
            icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF2F5D36)),
            items: items
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget buildButton(String text) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF2F5D36), // Green
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      ),
      onPressed: () {
        // Add your navigation or submit logic here
        debugPrint("$text pressed");
      },
      child: Text(text, style: const TextStyle(color: Colors.white)),
    );
  }
}
