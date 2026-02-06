import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_heatmap/google_maps_flutter_heatmap.dart';
import '../api/api_client.dart';

class AdminHeatmapScreen extends StatefulWidget {
  const AdminHeatmapScreen({super.key});

  @override
  State<AdminHeatmapScreen> createState() => _AdminHeatmapScreenState();
}

class _AdminHeatmapScreenState extends State<AdminHeatmapScreen> {
  final ApiClient _api = ApiClient();
  Set<Heatmap> _heatmaps = {};

  @override
  void initState() {
    super.initState();
    _loadHeatmap();
  }

  Future<void> _loadHeatmap() async {
    final res = await _api.get(
      'http://localhost:8080/api/admin/analytics/kiosk-heatmap',
    );

    final List data = jsonDecode(res.body);

    final points = data.map((p) {
      return WeightedLatLng(
        point: LatLng(p['latitude'], p['longitude']),
        intensity: p['intensity'].toDouble(),
      );
    }).toList();

    setState(() {
      _heatmaps = {
        Heatmap(
          heatmapId: const HeatmapId('kiosk_density'),
          points: points,
          radius: 40,
          opacity: 0.7,
        ),
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kiosk Density Heatmap')),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(-1.2866, 36.8172),
          zoom: 12,
        ),
        heatmaps: _heatmaps,
      ),
    );
  }
}
