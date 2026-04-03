class FlightModel {
  final String id;
  final String airline;
  final String from;
  final String to;
  final String price;
  final String status;
  final String seatNumber; // 1. Tambahkan variabel ini

  FlightModel({
    required this.id,
    required this.airline,
    required this.from,
    required this.to,
    required this.price,
    required this.status,
    required this.seatNumber, // 2. Tambahkan di constructor
  });

  // Di dalam flight_model.dart
  factory FlightModel.fromJson(Map<String, dynamic> json) {
    return FlightModel(
      id: json['id'].toString(),
      airline: json['airline'] ?? '-',
      from: json['from_location'] ?? '-',
      to: json['to_location'] ?? '-',
      // PERHATIKAN BAGIAN INI:
      price: json['price']?.toString() ?? '0',       // Ambil dari kolom 'price'
      seatNumber: json['seat'] ?? '-',        // Ambil dari kolom 'seat_number'
      status: json['status'] ?? 'Active',
    );
  }
}