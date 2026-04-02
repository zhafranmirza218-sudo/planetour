class FlightModel {
  final String airline;
  final String from;
  final String to;
  final String price;
  final String status;

  FlightModel({
    required this.airline,
    required this.from,
    required this.to,
    required this.price,
    required this.status,
  });

  // Fungsi untuk mengubah data JSON dari internet menjadi objek Dart
  factory FlightModel.fromJson(Map<String, dynamic> json) {
    return FlightModel(
      airline: json['airline_name'] ?? 'Unknown Airline',
      from: json['departure_city'] ?? '',
      to: json['arrival_city'] ?? '',
      price: json['price']?.toString() ?? '0',
      status: json['status'] ?? 'Scheduled',
    );
  }
}