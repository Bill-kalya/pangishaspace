import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../api/api_client.dart';
import '../maps/location_service.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final ApiClient _api = ApiClient();
  final Set<Marker> _markers = {};

  GoogleMapController? _controller;
  LatLng? _current;

  @override
  void initState() {
    super.initState();
    _loadLocation();
  }

  Future<void> _loadLocation() async {
    final pos = await LocationService.getCurrentLocation();
    _current = LatLng(pos.latitude, pos.longitude);
    await _loadNearbyKiosks();
    setState(() {});
  }

  Future<void> _loadNearbyKiosks() async {
    final response = await _api.get(
      'http://localhost:8080/api/kiosks/nearby'
      '?lat=${_current!.latitude}&lng=${_current!.longitude}&radius=2000',
    );

    final List data = jsonDecode(response.body);

    for (var k in data) {
      _markers.add(
        Marker(
          markerId: MarkerId(k['id']),
          position: LatLng(k['latitude'], k['longitude']),
          infoWindow: InfoWindow(title: k['name']),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_current == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Nearby Kiosks')),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _current!,
          zoom: 15,
        ),
        markers: _markers,
        myLocationEnabled: true,
        onMapCreated: (c) => _controller = c,
      ),
    );
  }
}
