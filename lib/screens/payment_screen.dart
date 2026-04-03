import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'ticket_list_screen.dart'; // Pastikan file ini ada di folder yang sama

class PaymentScreen extends StatefulWidget {
  final String airline;
  final String price;
  final String from;
  final String to;
  final String seat;
  final List<String> passengers;

  const PaymentScreen({
    super.key,
    required this.airline,
    required this.price,
    required this.from,
    required this.to,
    required this.seat,
    required this.passengers,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String? selectedMethod;
  bool isLoading = false;

  // --- 1. FUNGSI SIMPAN KE DATABASE ---
  Future<void> _simpanBookingKeDatabase() async {
    setState(() => isLoading = true);

    try {
      // PASTIKAN IP INI SESUAI DENGAN IP LAPTOP KAMU (192.168.18.237)
      final url = Uri.parse("http://192.168.18.237/planetour_api/add_booking.php");

      final response = await http.post(
        url,
        body: {
          "airline": widget.airline,
          "from_location": widget.from,
          "to_location": widget.to,
          "seat": widget.seat,
          "price": widget.price.replaceAll(RegExp(r'[^0-9]'), ''),
          "jumlah_orang": widget.passengers.length.toString(),
          "status": "Active",
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        // Jika PHP kamu mengembalikan echo "success"
        if (response.body.contains("success")) {
          _showSuccessDialog();
        } else {
          _showErrorSnackBar("Gagal menyimpan: ${response.body}");
        }
      } else {
        _showErrorSnackBar("Server Error: ${response.statusCode}");
      }
    } catch (e) {
      _showErrorSnackBar("Koneksi gagal! Pastikan XAMPP Jalan & Firewall Mati.");
      print("Detail Error: $e");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  // --- 2. FUNGSI SNACKBAR UNTUK ERROR ---
  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // --- 3. FUNGSI DIALOG SUKSES ---
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
        content: const Text("Pembayaran berhasil! Tiket Anda sudah disimpan ke database."),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Tutup dialog
              // Pindah ke halaman tiket dan hapus semua history navigasi
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const TicketListScreen()),
                    (route) => false,
              );
            },
            child: const Text("LIHAT TIKET SAYA"),
          )
        ],
      ),
    );
  }

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
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF1A237E)))
          : SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            // Mengatur tinggi agar Spacer() tetap berfungsi
            height: MediaQuery.of(context).size.height - 140,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Ringkasan Tiket",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 15),
                _buildSummaryCard(),
                const SizedBox(height: 30),
                const Text("Pilih Metode Pembayaran",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 10),
                _paymentOption("Transfer Bank", Icons.account_balance, "Bank"),
                _paymentOption("E-Wallet", Icons.account_balance_wallet, "Wallet"),

                const Spacer(),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A237E),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  onPressed: selectedMethod == null ? null : _simpanBookingKeDatabase,
                  child: const Text("BAYAR SEKARANG",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
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
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))
        ],
      ),
      child: Column(
        children: [
          _rowDetail("Maskapai", widget.airline),
          const Divider(),
          _rowDetail("Rute", "${widget.from} - ${widget.to}"),
          const Divider(),
          _rowDetail("Kursi", widget.seat, isBold: true),
          const Divider(),
          _rowDetail("Total Harga", "Rp ${widget.price}", isPrice: true),
        ],
      ),
    );
  }

  Widget _rowDetail(String label, String value, {bool isBold = false, bool isPrice = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: TextStyle(
            fontWeight: isBold || isPrice ? FontWeight.bold : FontWeight.normal,
            color: isPrice ? Colors.orange : Colors.black,
            fontSize: isPrice ? 16 : 14,
          )),
        ],
      ),
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
            width: 1.5
        ),
      ),
      child: RadioListTile<String>(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        secondary: Icon(icon, color: const Color(0xFF1A237E)),
        value: value,
        groupValue: selectedMethod,
        activeColor: Colors.orange,
        onChanged: (v) => setState(() => selectedMethod = v),
      ),
    );
  }
}