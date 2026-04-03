import 'package:flutter/material.dart';
import 'flight_selection_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> _countries = ["Jakarta (CGK)", "Bali (DPS)", "Singapore (SIN)", "Tokyo (HND)"];
  String? _fromCountry;
  String? _toCountry;
  int _passengerCount = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // HEADER BIRU
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 60, left: 25, right: 25, bottom: 40),
              decoration: const BoxDecoration(
                  color: Color(0xFF1A237E),
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30))
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Find Your Flight", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                  Text("Enjoy your trip with Planetour", style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(labelText: "From", prefixIcon: Icon(Icons.flight_takeoff)),
                        items: _countries.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                        onChanged: (v) => setState(() => _fromCountry = v),
                      ),
                      const SizedBox(height: 15),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(labelText: "To", prefixIcon: Icon(Icons.flight_land)),
                        items: _countries.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                        onChanged: (v) => setState(() => _toCountry = v),
                      ),
                      const SizedBox(height: 25),
                      const Text("Jumlah Penumpang", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.people_outline, color: Colors.grey),
                              SizedBox(width: 10),
                              Text("Penumpang", style: TextStyle(fontSize: 16)),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () => setState(() => _passengerCount > 1 ? _passengerCount-- : null),
                                icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                              ),
                              Text("$_passengerCount", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              IconButton(
                                onPressed: () => setState(() => _passengerCount++),
                                icon: const Icon(Icons.add_circle_outline, color: Color(0xFF1A237E)),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange[800],
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                          ),
                          onPressed: () {
                            if (_fromCountry != null && _toCountry != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FlightSelectionScreen(
                                    from: _fromCountry!,
                                    to: _toCountry!,
                                    passengerCount: _passengerCount,
                                  ),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Pilih rute asal dan tujuan dulu!")),
                              );
                            }
                          },
                          child: const Text("SEARCH FLIGHTS", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}