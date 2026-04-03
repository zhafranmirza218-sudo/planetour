import 'package:flutter/material.dart';
import 'seat_selection_screen.dart';

class FlightSelectionScreen extends StatelessWidget {
  final String from;
  final String to;
  final int passengerCount;

  const FlightSelectionScreen({
    super.key,
    required this.from,
    required this.to,
    required this.passengerCount
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pilih Penerbangan"),
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.flight_takeoff, color: Color(0xFF1A237E)),
              title: const Text("Garuda Indonesia", style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("$from Ke $to \nJam: 08:00 WIB"),
              trailing: const Text("Rp 1.500.000", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
              onTap: () {
                // INI YANG AKAN MEMBUKA PILIH KURSI
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SeatSelectionScreen(
                          airline: "Garuda Indonesia",
                          from: from,
                          to: to,
                          price: "1.500.000",
                          passengerCount: passengerCount,
                        )
                    )
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}