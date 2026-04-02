import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/flight_model.dart';

class ApiService {
  // Method untuk Radar Screen (tetap dipertahankan)
  Future<List<dynamic>> getLiveAircrafts() async {
    const String url = 'https://api.allorigins.win/raw?url=https://opensky-network.org/api/states/all';
    try {
      final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['states'] ?? _getDummyData();
      }
      return _getDummyData();
    } catch (e) {
      return _getDummyData();
    }
  }

  // Method BARU untuk TicketListScreen agar tidak error
  Future<List<FlightModel>> getFlights(String from, String to) async {
    // Simulasi delay jaringan
    await Future.delayed(const Duration(milliseconds: 800));

    // Data dummy untuk list tiket
    return [
      FlightModel(airline: "Garuda Indonesia", status: "On Time", price: "1.500.000", from: '', to: ''),
      FlightModel(airline: "AirAsia", status: "Scheduled", price: "850.000", from: '', to: ''),
      FlightModel(airline: "Lion Air", status: "Delayed", price: "920.000", from: '', to: ''),
    ];
  }

  List<dynamic> _getDummyData() {
    return [
      ["GIA123", "Garuda Indonesia", "Indonesia", 164000, 164000, 106.65, -6.12, 10000],
      ["AWQ456", "AirAsia", "Malaysia", 164000, 164000, 115.16, -8.74, 5000],
    ];
  }
}