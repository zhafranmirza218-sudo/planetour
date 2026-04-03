import 'package:flutter/material.dart';
import '../models/flight_model.dart';
import '../services/api_service.dart';

class TicketListScreen extends StatefulWidget {
  const TicketListScreen({super.key});

  @override
  State<TicketListScreen> createState() => _TicketListScreenState();
}

class _TicketListScreenState extends State<TicketListScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<FlightModel>> _flightFuture;

  @override
  void initState() {
    super.initState();
    _refreshFlights();
  }

  void _refreshFlights() {
    setState(() {
      _flightFuture = _apiService.getMyBookings();
    });
  }

  // --- POIN 4: FUNGSI BATALKAN TIKET ---
  void _deleteTicket(String id) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator(color: Color(0xFF1A237E))),
    );

    bool success = await _apiService.deleteBooking(id);

    if (!mounted) return;
    Navigator.pop(context); // Tutup loading

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tiket berhasil dibatalkan"), backgroundColor: Colors.green),
      );
      _refreshFlights(); // Segarkan list agar tiket hilang
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal membatalkan tiket"), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text("My Tickets", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: FutureBuilder<List<FlightModel>>(
        future: _flightFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || (snapshot.data?.isEmpty ?? true)) {
            return const Center(child: Text("Belum ada tiket aktif."));
          }

          final flights = snapshot.data!;
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
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(flight.airline, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text("Rp ${flight.price}", style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
              ],
            ),
            const Divider(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(flight.from, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const Icon(Icons.trending_flat, color: Colors.grey),
                Text(flight.to, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Seat: ${flight.seatNumber}", style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => _showDeleteConfirmation(flight.id),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Batalkan Tiket?"),
        content: const Text("Tindakan ini tidak dapat dibatalkan."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("TIDAK")),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteTicket(id);
            },
            child: const Text("YA, BATALKAN", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}