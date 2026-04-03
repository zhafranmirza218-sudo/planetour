import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:planetour/screens/home_screen.dart';
import 'dart:async';
import 'screens/radar_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/ticket_list_screen.dart';
import 'screens/flight_selection_screen.dart';
import 'screens/seat_selection_screen.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const PlanetourApp());
}

// --- 1. MODELS ---
class UserAccount {
  String name;
  String email;
  UserAccount({required this.name, required this.email});
}

class TicketModel {
  final String from, to, airline, time, gate, seat;
  final int passengerCount;

  TicketModel({
    required this.from,
    required this.to,
    required this.airline,
    required this.time,
    required this.gate,
    required this.seat,
    required this.passengerCount
  });

  // MAPPING: Fungsi ini untuk mengubah data JSON dari PHP ke format Flutter
  factory TicketModel.fromJson(Map<String, dynamic> json) {
    return TicketModel(
      // Kiri: nama variabel Flutter | Kanan: nama kolom di Database/PHP
      from: json['from_location'] ?? '-',
      to: json['to_location'] ?? '-',
      airline: json['airline'] ?? '-',
      time: json['travel_time'] ?? '-', // Sesuaikan jika di DB namanya 'travel_time'
      gate: json['gate'] ?? '-',
      seat: json['seat_number'] ?? '-', // Di DB kamu namanya 'seat_number'
      passengerCount: int.tryParse(json['jumlah_orang'].toString()) ?? 1,
    );
  }
}

class NotificationModel {
  final String title, desc, time;
  final IconData icon;
  final Color color;
  NotificationModel({required this.title, required this.desc, required this.time, required this.icon, required this.color});
}

// --- 2. APP ENTRY ---
// Di main.dart
class PlanetourApp extends StatelessWidget {
  const PlanetourApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Planetour',
      theme: ThemeData(
        primaryColor: const Color(0xFF1A237E),
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),

      // 1. Kembalikan ke LoginScreen
      home: const LoginScreen(),

      routes: {
        '/home': (context) => const HomeScreen(),
        '/login': (context) => const LoginScreen(),
      },
    );
  }
}

// --- 4. MAIN NAVIGATION ---
class MainNavigation extends StatefulWidget {
  final UserAccount userData;
  const MainNavigation({super.key, required this.userData});
  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  late UserAccount currentUser;

  // UPDATE: Memperbaiki penamaan parameter dummy data
  static List<TicketModel> myTickets = [
    TicketModel(
        from: "Jakarta",
        to: "Bali",
        airline: "Garuda Indonesia",
        time: "08:00",
        gate: "G12",
        seat: "14A",
        passengerCount: 1
    ),
  ];

  static List<NotificationModel> myNotifications = [
    NotificationModel(title: "Login Successful", desc: "Welcome to Planetour!", time: "Just now", icon: Icons.check_circle, color: Colors.green),
  ];

  @override
  void initState() {
    super.initState();
    currentUser = widget.userData;
  }

  @override
  Widget build(BuildContext context) {
    // DI DALAM main.dart
    final List<Widget> _pages = [
      const HomeScreen(),
      const TicketListScreen(), // Memanggil TicketListScreen dari import
      NotificationsPage(notifications: myNotifications),
      ProfilePage(
          user: currentUser,
          onUpdate: (updatedUser) => setState(() => currentUser = updatedUser)
      ),
    ];

    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (i) => setState(() => _selectedIndex = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.confirmation_number_outlined), label: 'Tickets'),
          NavigationDestination(icon: Icon(Icons.notifications_outlined), label: 'Alerts'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}

// --- 5. HOME SCREEN ---
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
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 60, left: 25, right: 25, bottom: 40),
              decoration: const BoxDecoration(
                  color: Color(0xFF1A237E),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30))),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Find Your Flight",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold)),
                  Text("Enjoy your trip with Planetour",
                      style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                            labelText: "From",
                            prefixIcon: Icon(Icons.flight_takeoff)),
                        items: _countries
                            .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                            .toList(),
                        onChanged: (v) => _fromCountry = v,
                      ),
                      const SizedBox(height: 15),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                            labelText: "To",
                            prefixIcon: Icon(Icons.flight_land)),
                        items: _countries
                            .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                            .toList(),
                        onChanged: (v) => _toCountry = v,
                      ),
                      const SizedBox(height: 25),
                      const Text("Jumlah Penumpang",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.grey)),
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
                                onPressed: () => setState(() =>
                                _passengerCount > 1 ? _passengerCount-- : null),
                                icon: const Icon(Icons.remove_circle_outline,
                                    color: Colors.red),
                              ),
                              Text("$_passengerCount",
                                  style: const TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.bold)),
                              IconButton(
                                onPressed: () => setState(() => _passengerCount++),
                                icon: const Icon(Icons.add_circle_outline,
                                    color: Color(0xFF1A237E)),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),

                      // TOMBOL SEARCH FLIGHTS
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange[800],
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
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

                          child: const Text("SEARCH FLIGHTS",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // TOMBOL LIVE FLIGHT RADAR
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: OutlinedButton.icon(
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (c) => const RadarScreen())),
                          icon: const Icon(Icons.map_outlined),
                          label: const Text("LIVE FLIGHT RADAR"),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF1A237E)),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
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

// --- 7. SEAT SELECTION SCREEN ---
class SeatSelectionScreen extends StatefulWidget {
  final String airline, from, to, price;
  final int passengerCount;
  const SeatSelectionScreen({super.key, required this.airline, required this.from, required this.to, required this.price, required this.passengerCount});
  @override
  State<SeatSelectionScreen> createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  int? selectedIndex;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pilih Kursi")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Text("Jumlah Penumpang: ${widget.passengerCount}", style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
          ),
          const Padding(padding: EdgeInsets.all(10), child: Text("DEPAN / COCKPIT", style: TextStyle(color: Colors.grey))),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              itemCount: 40,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5, mainAxisSpacing: 10, crossAxisSpacing: 10),
              itemBuilder: (context, index) {
                if (index % 5 == 2) return Center(child: Text("${(index ~/ 5) + 1}", style: const TextStyle(color: Colors.grey)));
                bool isSelected = selectedIndex == index;
                return GestureDetector(
                  onTap: () => setState(() => selectedIndex = index),
                  child: Container(
                    decoration: BoxDecoration(color: isSelected ? Colors.orange : Colors.blue[50], borderRadius: BorderRadius.circular(8)),
                    child: Icon(Icons.event_seat, color: isSelected ? Colors.white : Colors.blue[900], size: 20),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1A237E), foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 50)),
              onPressed: selectedIndex == null ? null : () {
                Navigator.push(context, MaterialPageRoute(builder: (c) => PaymentScreen(
                  airline: widget.airline, price: widget.price, from: widget.from, to: widget.to,
                  seat: "${(selectedIndex! ~/ 5) + 1}${String.fromCharCode(65 + (selectedIndex! % 5))}",
                  passengerCount: widget.passengerCount,
                )));
              },
              child: const Text("KONFIRMASI"),
            ),
          )
        ],
      ),
    );
  }
}

// --- 8. PAYMENT SCREEN ---
class PaymentScreen extends StatefulWidget {
  final String airline, price, from, to, seat;
  final int passengerCount;
  const PaymentScreen({super.key, required this.airline, required this.price, required this.from, required this.to, required this.seat, required this.passengerCount});
  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String? _method;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Payment")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ListTile(
                title: Text(widget.airline),
                subtitle: Text("${widget.passengerCount} Tiket • Seat ${widget.seat}"),
                trailing: Text(widget.price)
            ),
            const Divider(),
            RadioListTile<String>(title: const Text("Transfer Bank"), value: "Bank", groupValue: _method, onChanged: (v) => setState(() => _method = v)),
            RadioListTile<String>(title: const Text("E-Wallet"), value: "Wallet", groupValue: _method, onChanged: (v) => setState(() => _method = v)),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1A237E), foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 50)),
              onPressed: _method == null ? null : () => Navigator.push(context, MaterialPageRoute(builder: (c) => CountdownPayScreen(
                  airline: widget.airline, price: widget.price, from: widget.from, to: widget.to, seat: widget.seat, passengerCount: widget.passengerCount
              ))),
              child: const Text("BAYAR SEKARANG"),
            )
          ],
        ),
      ),
    );
  }
}

// --- 9. SIMULASI PEMBAYARAN (VERSI FIX MENU BAWAH) ---
class CountdownPayScreen extends StatelessWidget {
  final String airline, price, from, to, seat;
  final int passengerCount;

  const CountdownPayScreen({
    super.key,
    required this.airline,
    required this.price,
    required this.from,
    required this.to,
    required this.seat,
    required this.passengerCount
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.timer, size: 80, color: Colors.orange),
              const SizedBox(height: 20),
              const Text("Menunggu Pembayaran...",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text("Total: $price", style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 40),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                onPressed: () async {
                  try {
                    final response = await http.post(
                      Uri.parse("http://192.168.18.237/planetour_api/add_booking.php"),
                      body: {
                        "airline": airline,
                        "from_location": from,
                        "to_location": to,
                        "travel_time": "10:00",
                        "gate": "B3",
                        "seat": seat,
                        "jumlah_orang": passengerCount.toString(),
                      },
                    );

                    if (response.statusCode == 200) {
                      if (context.mounted) {
                        // Balik ke MainNavigation agar Bar Navigasi Bawah muncul kembali
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (c) => MainNavigation( // JANGAN pakai const
                              userData: UserAccount(
                                name: "Mirza", // Gunakan nama langsung atau variabel yang tersedia
                                email: "mirza@ui.ac.id",
                              ),
                            ),
                          ),
                              (route) => false,
                        );
                      }
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Gagal menyimpan ke database")));
                    }
                  }
                },
                child: const Text("SAYA SUDAH BAYAR", style: TextStyle(fontWeight: FontWeight.bold)),
              ),

              const SizedBox(height: 15),
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Batalkan Pembayaran", style: TextStyle(color: Colors.red))),
            ],
          ),
        ),
      ),
    );
  }
}

// --- 11. PROFILE PAGE ---
class ProfilePage extends StatelessWidget {
  final UserAccount user;
  final Function(UserAccount) onUpdate;
  const ProfilePage({super.key, required this.user, required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: Column(
        children: [
          const SizedBox(height: 30),
          const Center(child: CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50))),
          const SizedBox(height: 20),
          Text(user.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          Text(user.email, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: ElevatedButton.icon(
              onPressed: () async {
                final result = await Navigator.push(context, MaterialPageRoute(builder: (c) => EditProfileScreen(user: user)));
                if (result != null) onUpdate(result as UserAccount);
              },
              icon: const Icon(Icons.edit),
              label: const Text("Edit Profile"),
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 45)),
            ),
          ),
          const Spacer(),
          TextButton(onPressed: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (c) => const LoginScreen()), (r) => false), child: const Text("Logout", style: TextStyle(color: Colors.red))),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

// --- 12. EDIT PROFILE SCREEN ---
class EditProfileScreen extends StatefulWidget {
  final UserAccount user;
  const EditProfileScreen({super.key, required this.user});
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController nameCtrl;
  late TextEditingController emailCtrl;
  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: widget.user.name);
    emailCtrl = TextEditingController(text: widget.user.email);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: "Full Name", border: OutlineInputBorder())),
            const SizedBox(height: 20),
            TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: "Email", border: OutlineInputBorder())),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50), backgroundColor: const Color(0xFF1A237E), foregroundColor: Colors.white),
              onPressed: () => Navigator.pop(context, UserAccount(name: nameCtrl.text, email: emailCtrl.text)),
              child: const Text("SAVE CHANGES"),
            )
          ],
        ),
      ),
    );
  }
}

// --- 13. NOTIFICATIONS PAGE ---
class NotificationsPage extends StatelessWidget {
  final List<NotificationModel> notifications;
  const NotificationsPage({super.key, required this.notifications});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Alerts")),
        body: notifications.isEmpty ? const Center(child: Text("No Notifications")) : ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: notifications.length,
            itemBuilder: (c, i) => Card(
              child: ListTile(
                leading: Icon(notifications[i].icon, color: notifications[i].color),
                title: Text(notifications[i].title, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(notifications[i].desc),
                trailing: Text(notifications[i].time, style: const TextStyle(fontSize: 10, color: Colors.grey)),
              ),
            )
        )
    );
  }
}

// Tambahkan variabel global appTheme jika belum ada
final appTheme = ThemeData(
  primaryColor: const Color(0xFF1A237E),
  textTheme: GoogleFonts.poppinsTextTheme(),
);