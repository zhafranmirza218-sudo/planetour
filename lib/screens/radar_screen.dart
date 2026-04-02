import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:planetour/services/api_service.dart';

class RadarScreen extends StatefulWidget {
  const RadarScreen({super.key});

  @override
  State<RadarScreen> createState() => _RadarScreenState();
}

class _RadarScreenState extends State<RadarScreen> {
  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Live Flight Radar"),
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: apiService.getLiveAircrafts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Terjadi kesalahan: ${snapshot.error}"));
          }

          // Filter data agar tidak ada yang null
          final aircrafts = snapshot.data?.where((plane) =>
          plane != null && plane.length > 6 && plane[5] != null && plane[6] != null
          ).take(50).toList() ?? [];

          return FlutterMap(
            options: const MapOptions(
              initialCenter: LatLng(-6.2000, 106.8166), // Fokus ke Jakarta
              initialZoom: 5.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.planetour.app',
              ),
              MarkerLayer(
                markers: aircrafts.map((plane) {
                  return Marker(
                    point: LatLng(
                        (plane[6] as num).toDouble(), // Latitude
                        (plane[5] as num).toDouble()  // Longitude
                    ),
                    width: 40,
                    height: 40,
                    child: const Icon(
                      Icons.flight,
                      color: Colors.red,
                      size: 25,
                    ),
                  );
                }).toList(),
              ),
            ],
          );
        },
      ),
    );
  }
}