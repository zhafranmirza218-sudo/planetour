import 'package:flutter/material.dart';
// Gunakan dua titik (../) untuk keluar dari folder widgets,
// lalu masuk ke folder services
import 'services/api_service.dart'; // Hapus titik duanya

class RadarScreen extends StatefulWidget {
  const RadarScreen({super.key});

  @override
  State<RadarScreen> createState() => _RadarScreenState();
}

class _RadarScreenState extends State<RadarScreen> {
  final ApiService _apiService = ApiService();

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
        future: _apiService.getLiveAircrafts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Gagal memuat data pesawat"));
          }

          final planes = snapshot.data!;

          return ListView.builder(
            itemCount: planes.length,
            itemBuilder: (context, index) {
              final plane = planes[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                child: ListTile(
                  leading: const Icon(Icons.airplanemode_active, color: Color(0xFF1A237E)),
                  title: Text(plane[1].toString().trim().isEmpty ? "Unknown" : plane[1].toString()),
                  subtitle: Text("Origin: ${plane[2]}"),
                  trailing: Text("${plane[7]}m", style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              );
            },
          );
        },
      ),
    );
  }
}