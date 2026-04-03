import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/flight_model.dart';

class ApiService {
  static const String baseUrl = "http://192.168.18.237/planetour_api";

  // 1. [READ] Ambil data pesawat live
  Future<List<dynamic>> getLiveAircrafts() async {
    const String url = 'https://api.allorigins.win/raw?url=https://opensky-network.org/api/states/all';
    try {
      final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['states'] ?? _getDummyRadar();
      }
      return _getDummyRadar();
    } catch (e) {
      return _getDummyRadar();
    }
  }

  // 2. [READ] Ambil data tiket dari DATABASE
  Future<List<FlightModel>> getMyBookings() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/get_bookings.php"));
      print("Log Data API: ${response.body}");

      if (response.statusCode == 200) {
        List data = json.decode(response.body);
        return data.map((json) => FlightModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print("Error koneksi API getMyBookings: $e");
      return [];
    }
  }

  // 3. [DELETE] Menghapus pesanan
  Future<bool> deleteBooking(String id) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/delete_booking.php"),
        body: {'id': id},
      );
      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        return result['status'] == 'success';
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // ---------------------------------------------------------
  // 4. [CREATE] SIMPAN BOOKING BARU (TAMBAHKAN DI SINI)
  // ---------------------------------------------------------
  Future<bool> saveBooking({
    required String airline,
    required String from,
    required String to,
    required String price,
    required String seat,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/save_booking.php"),
        body: {
          'airline': airline,
          'from_airport': from,
          'to_airport': to,
          'price': price,
          'seat_number': seat,
        },
      );

      print("Log Save Booking: ${response.body}");

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        return result['status'] == 'success';
      }
      return false;
    } catch (e) {
      print("Error Save Booking: $e");
      return false;
    }
  }

  // --- DATA DUMMY ---
  List<dynamic> _getDummyRadar() {
    return [
      ["GIA123", "Garuda Indonesia", "Indonesia", 164000, 164000, 106.65, -6.12, 10000],
      ["AWQ456", "AirAsia", "Malaysia", 164000, 164000, 115.16, -8.74, 5000],
    ];
  }
}