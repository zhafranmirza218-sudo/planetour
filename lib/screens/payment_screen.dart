import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  final String airline;
  final String price;
  final String from;
  final String to;
  final String seat;
  // 1. Tambahkan variabel untuk menampung list penumpang
  final List<String> passengers;

  const PaymentScreen({
    super.key,
    required this.airline,
    required this.price,
    required this.from,
    required this.to,
    required this.seat,
    required this.passengers, // Pastikan ini required
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String? selectedMethod;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Pembayaran"),
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Ringkasan Tiket",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 15),
            _buildSummaryCard(),
            const SizedBox(height: 30),
            const Text(
              "Pilih Metode Pembayaran",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            _paymentOption("Transfer Bank", Icons.account_balance, "Bank"),
            _paymentOption("E-Wallet (Gopay/OVO)", Icons.account_balance_wallet, "Wallet"),
            _paymentOption("Kartu Kredit", Icons.credit_card, "Card"),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A237E),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onPressed: selectedMethod == null
                  ? null
                  : () {
                _showSuccessDialog();
              },
              child: const Text(
                "BAYAR SEKARANG",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _rowDetail("Maskapai", widget.airline),
          const Divider(height: 25),
          _rowDetail("Rute", "${widget.from} - ${widget.to}"),
          const Divider(height: 25),

          // 2. Tampilkan Daftar Penumpang di sini
          const Text("Daftar Penumpang:", style: TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 5),
          Column(
            children: widget.passengers.map((name) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  const Icon(Icons.person_outline, size: 14, color: Colors.blue),
                  const SizedBox(width: 8),
                  Text(name, style: const TextStyle(fontWeight: FontWeight.w500)),
                ],
              ),
            )).toList(),
          ),

          const Divider(height: 25),
          _rowDetail("Nomor Kursi Utama", widget.seat, isBold: true),
          const Divider(height: 25),
          _rowDetail("Total Harga", widget.price, isPrice: true),
        ],
      ),
    );
  }

  Widget _rowDetail(String label, String value, {bool isBold = false, bool isPrice = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        Text(
          value,
          style: TextStyle(
            fontWeight: isBold || isPrice ? FontWeight.bold : FontWeight.normal,
            color: isPrice ? Colors.orange : Colors.black,
            fontSize: isPrice ? 18 : 14,
          ),
        ),
      ],
    );
  }

  Widget _paymentOption(String title, IconData icon, String value) {
    bool isSelected = selectedMethod == value;
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? Colors.orange : Colors.grey.shade200,
          width: 1.5,
        ),
      ),
      child: RadioListTile<String>(
        title: Text(title, style: const TextStyle(fontSize: 14)),
        secondary: Icon(icon, color: const Color(0xFF1A237E)),
        value: value,
        groupValue: selectedMethod,
        activeColor: Colors.orange,
        onChanged: (v) {
          setState(() {
            selectedMethod = v;
          });
        },
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 10),
            Text("Berhasil"),
          ],
        ),
        content: Text("Pembayaran untuk ${widget.passengers.length} tiket berhasil diproses. Tiket elektronik sudah dikirim."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Tutup Dialog
              Navigator.popUntil(context, (route) => route.isFirst); // Kembali ke Home
            },
            child: const Text("KEMBALI KE HOME"),
          )
        ],
      ),
    );
  }
}