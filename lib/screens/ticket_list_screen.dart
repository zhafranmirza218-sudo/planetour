import 'package:flutter/material.dart';
import '../models/flight_model.dart';
import '../services/api_service.dart';
import 'seat_selection_screen.dart';

class TicketListScreen extends StatelessWidget {
  final String from;
  final String to;
  final int passengerCount; // Menyimpan jumlah penumpang dari HomeScreen

  const TicketListScreen({
    super.key,
    required this.from,
    required this.to,
    required this.passengerCount,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$from ✈ $to"),
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: FutureBuilder<List<FlightModel>>(
        future: ApiService().getFlights(from, to),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF1A237E)));
          }

          if (snapshot.hasError) {
            return Center(child: Text("Gagal memuat: ${snapshot.error}"));
          }

          final flights = snapshot.data ?? [];
          return ListView.builder(
            padding: const EdgeInsets.all(15),
            itemCount: flights.length,
            itemBuilder: (context, index) => _ticketCard(context, flights[index]),
          );
        },
      ),
    );
  }

  Widget _ticketCard(BuildContext context, FlightModel flight) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: const Icon(Icons.flight_takeoff, color: Color(0xFF1A237E)),
        title: Text(flight.airline, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("Status: ${flight.status}\n$passengerCount Penumpang"),
        trailing: Text(
          "Rp ${flight.price}",
          style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SeatSelectionScreen(
                airline: flight.airline,
                from: from,
                to: to,
                price: "Rp ${flight.price}",
                passengerCount: passengerCount, // Teruskan ke SeatSelection
              ),
            ),
          );
        },
      ),
    );
  }
}