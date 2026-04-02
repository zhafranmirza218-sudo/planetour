import 'package:flutter/material.dart';
import 'payment_screen.dart';

class SeatSelectionScreen extends StatefulWidget {
  final String airline;
  final String from;
  final String to;
  final String price;
  final int passengerCount; // Terima jumlah penumpang dari screen sebelumnya

  const SeatSelectionScreen({
    super.key,
    required this.airline,
    required this.from,
    required this.to,
    required this.price,
    required this.passengerCount,
  });

  @override
  State<SeatSelectionScreen> createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  // Gunakan Set untuk menyimpan banyak kursi yang dipilih
  final Set<int> selectedIndices = {};

  // Simulasi kursi yang sudah terisi
  List<int> reservedSeats = [5, 10, 15, 22, 30, 45, 52];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pilih Kursi"),
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Info jumlah kursi yang harus dipilih
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Color(0xFF1A237E)),
                  const SizedBox(width: 10),
                  Text(
                    "Silahkan pilih ${widget.passengerCount} kursi\n(Terpilih: ${selectedIndices.length})",
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A237E)),
                  ),
                ],
              ),
            ),
          ),

          const Text("DEPAN / COCKPIT", style: TextStyle(color: Colors.grey, fontSize: 12, letterSpacing: 2)),
          const Icon(Icons.arrow_drop_up, color: Colors.grey),

          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              itemCount: 60,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                // Lorong pesawat (nomor baris di tengah)
                if (index % 5 == 2) {
                  return Center(child: Text("${(index ~/ 5) + 1}", style: const TextStyle(color: Colors.grey)));
                }

                bool isReserved = reservedSeats.contains(index);
                bool isSelected = selectedIndices.contains(index);

                return GestureDetector(
                  onTap: isReserved ? null : () {
                    setState(() {
                      if (isSelected) {
                        selectedIndices.remove(index);
                      } else {
                        // Batasi pemilihan sesuai jumlah penumpang dari HomeScreen
                        if (selectedIndices.length < widget.passengerCount) {
                          selectedIndices.add(index);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Maksimal pilih ${widget.passengerCount} kursi"))
                          );
                        }
                      }
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isReserved ? Colors.grey.shade300 : (isSelected ? Colors.orange : Colors.blue.shade50),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: isSelected ? Colors.orange : Colors.blue.shade100),
                    ),
                    child: Icon(
                      Icons.event_seat,
                      size: 20,
                      color: isReserved ? Colors.grey : (isSelected ? Colors.white : const Color(0xFF1A237E)),
                    ),
                  ),
                );
              },
            ),
          ),
          _buildConfirmButton(),
        ],
      ),
    );
  }

  Widget _buildConfirmButton() {
    // Tombol hanya aktif jika jumlah kursi yang dipilih pas dengan jumlah penumpang
    bool isReady = selectedIndices.length == widget.passengerCount;

    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 10, 25, 30),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1A237E),
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey[300],
          minimumSize: const Size(double.infinity, 55),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: !isReady ? null : () {
          // Generate list label kursi (misal: 1A, 1B)
          List<String> seatLabels = selectedIndices.map((idx) {
            String col = String.fromCharCode(65 + (idx % 5));
            int row = (idx ~/ 5) + 1;
            return "$row$col";
          }).toList();

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PaymentScreen(
                airline: widget.airline,
                from: widget.from,
                to: widget.to,
                price: widget.price,
                seat: seatLabels.join(", "), // Gabungkan label kursi jadi satu string
                passengers: List.generate(widget.passengerCount, (i) => "Penumpang ${i + 1}"),
              ),
            ),
          );
        },
        child: Text(isReady ? "KONFIRMASI PESANAN" : "PILIH ${widget.passengerCount} KURSI"),
      ),
    );
  }
}