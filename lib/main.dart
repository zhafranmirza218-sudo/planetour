import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'screens/radar_screen.dart';

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
  final List<String> passengers;
  TicketModel({required this.from, required this.to, required this.airline, required this.time, required this.gate, required this.seat, required this.passengers});
}

class NotificationModel {
  final String title, desc, time;
  final IconData icon;
  final Color color;
  NotificationModel({required this.title, required this.desc, required this.time, required this.icon, required this.color});
}

// --- 2. APP ENTRY ---
class PlanetourApp extends StatelessWidget {
  const PlanetourApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Planetour',
      theme: ThemeData(
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1A237E)),
      ),
      home: const LoginScreen(),
    );
  }
}

// --- 3. LOGIN SCREEN ---
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Welcome Back!", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
              const Text("Login to start your journey", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 40),
              TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: "Email", prefixIcon: Icon(Icons.email_outlined), border: OutlineInputBorder())
              ),
              const SizedBox(height: 20),
              const TextField(obscureText: true, decoration: InputDecoration(labelText: "Password", prefixIcon: Icon(Icons.lock_outline), border: OutlineInputBorder())),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1A237E), foregroundColor: Colors.white),
                  onPressed: () {
                    final user = UserAccount(
                      name: _emailController.text.contains('@') ? _emailController.text.split('@')[0] : "Mirza",
                      email: _emailController.text.isEmpty ? "mirza@ui.ac.id" : _emailController.text,
                    );
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => MainNavigation(userData: user)));
                  },
                  child: const Text("Login"),
                ),
              ),
            ],
          ),
        ),
      ),
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

  static List<TicketModel> myTickets = [
    TicketModel(from: "Jakarta (CGK)", to: "Bali (DPS)", airline: "Garuda Indonesia", time: "08:00", gate: "G12", seat: "14A", passengers: ["Mirza"]),
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
    final List<Widget> _pages = [
      const HomeScreen(),
      BookingsPage(tickets: myTickets),
      NotificationsPage(notifications: myNotifications),
      ProfilePage(user: currentUser, onUpdate: (updatedUser) => setState(() => currentUser = updatedUser)),
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

// --- 5. HOME SCREEN (INPUT PENUMPANG DI SINI) ---
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> _countries = ["Jakarta (CGK)", "Bali (DPS)", "Singapore (SIN)", "Tokyo (HND)"];
  String? _fromCountry;
  String? _toCountry;

  // List controller penumpang dipindah ke sini
  final List<TextEditingController> _passengerControllers = [TextEditingController()];

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
              decoration: const BoxDecoration(color: Color(0xFF1A237E), borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30))),
              child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text("Find Your Flight", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                Text("Enjoy your trip with Planetour", style: TextStyle(color: Colors.white70)),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Card(
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(labelText: "From", prefixIcon: Icon(Icons.flight_takeoff)),
                        items: _countries.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                        onChanged: (v) => _fromCountry = v,
                      ),
                      const SizedBox(height: 15),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(labelText: "To", prefixIcon: Icon(Icons.flight_land)),
                        items: _countries.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                        onChanged: (v) => _toCountry = v,
                      ),

                      const SizedBox(height: 25),
                      // BAGIAN INPUT PENUMPANG
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Daftar Penumpang", style: TextStyle(fontWeight: FontWeight.bold)),
                          IconButton(
                            onPressed: () => setState(() => _passengerControllers.add(TextEditingController())),
                            icon: const Icon(Icons.add_circle, color: Color(0xFF1A237E)),
                          ),
                        ],
                      ),
                      ...List.generate(_passengerControllers.length, (index) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: TextField(
                          controller: _passengerControllers[index],
                          decoration: InputDecoration(
                              labelText: "Nama Penumpang ${index + 1}",
                              border: const OutlineInputBorder(),
                              isDense: true,
                              suffixIcon: index == 0 ? null : IconButton(
                                icon: const Icon(Icons.remove_circle, color: Colors.red),
                                onPressed: () => setState(() => _passengerControllers.removeAt(index)),
                              )
                          ),
                        ),
                      )),

                      const SizedBox(height: 25),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.orange[800], foregroundColor: Colors.white),
                          onPressed: () {
                            if (_fromCountry != null && _toCountry != null) {
                              List<String> passengers = _passengerControllers.map((e) => e.text).toList();
                              Navigator.push(context, MaterialPageRoute(builder: (c) => TicketListScreen(
                                from: _fromCountry!,
                                to: _toCountry!,
                                passengers: passengers, // Kirim list penumpang
                              )));
                            }
                          },
                          child: const Text("SEARCH FLIGHTS"),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: OutlinedButton.icon(
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const RadarScreen())),
                          icon: const Icon(Icons.map_outlined),
                          label: const Text("LIVE FLIGHT RADAR"),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF1A237E)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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

// --- 6. TICKET LIST SCREEN ---
class TicketListScreen extends StatelessWidget {
  final String from, to;
  final List<String> passengers; // Terima list penumpang
  const TicketListScreen({super.key, required this.from, required this.to, required this.passengers});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("$from ✈ $to")),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [
          _ticketItem(context, "Garuda Indonesia", "08:00", "Rp 1.500.000"),
          _ticketItem(context, "AirAsia", "13:45", "Rp 850.000"),
          _ticketItem(context, "Lion Air", "19:00", "Rp 920.000"),
        ],
      ),
    );
  }

  Widget _ticketItem(BuildContext context, String airline, String time, String price) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      child: ListTile(
        leading: const Icon(Icons.airplanemode_active, color: Color(0xFF1A237E)),
        title: Text(airline, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("Departs: $time\n${passengers.length} Penumpang"),
        trailing: Text(price, style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (c) => SeatSelectionScreen(
              airline: airline, from: from, to: to, price: price, passengers: passengers
          )));
        },
      ),
    );
  }
}

// --- 7. SEAT SELECTION SCREEN ---
class SeatSelectionScreen extends StatefulWidget {
  final String airline, from, to, price;
  final List<String> passengers;
  const SeatSelectionScreen({super.key, required this.airline, required this.from, required this.to, required this.price, required this.passengers});
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
            child: Text("Penumpang: ${widget.passengers.join(', ')}", style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
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
                  passengers: widget.passengers,
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
  final List<String> passengers;
  const PaymentScreen({super.key, required this.airline, required this.price, required this.from, required this.to, required this.seat, required this.passengers});
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
            ListTile(title: Text(widget.airline), subtitle: Text("${widget.passengers.length} Tiket • Seat ${widget.seat}"), trailing: Text(widget.price)),
            const Divider(),
            ...widget.passengers.map((p) => ListTile(leading: const Icon(Icons.person), title: Text(p), dense: true)),
            const Divider(),
            RadioListTile<String>(title: const Text("Transfer Bank"), value: "Bank", groupValue: _method, onChanged: (v) => setState(() => _method = v)),
            RadioListTile<String>(title: const Text("E-Wallet"), value: "Wallet", groupValue: _method, onChanged: (v) => setState(() => _method = v)),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1A237E), foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 50)),
              onPressed: _method == null ? null : () => Navigator.push(context, MaterialPageRoute(builder: (c) => CountdownPayScreen(airline: widget.airline, price: widget.price, from: widget.from, to: widget.to, seat: widget.seat, passengers: widget.passengers))),
              child: const Text("BAYAR SEKARANG"),
            )
          ],
        ),
      ),
    );
  }
}

// --- 9. SIMULASI PEMBAYARAN ---
class CountdownPayScreen extends StatelessWidget {
  final String airline, price, from, to, seat;
  final List<String> passengers;
  const CountdownPayScreen({super.key, required this.airline, required this.price, required this.from, required this.to, required this.seat, required this.passengers});

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
              const Text("Menunggu Pembayaran...", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 50)),
                onPressed: () {
                  _MainNavigationState.myTickets.insert(0, TicketModel(from: from, to: to, airline: airline, time: "10:00", gate: "B3", seat: seat, passengers: passengers));
                  _MainNavigationState.myNotifications.insert(0, NotificationModel(title: "Payment Successful", desc: "Tiket $airline ($from - $to) dikonfirmasi.", time: "Just now", icon: Icons.check_circle, color: Colors.blue));

                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (c) => MainNavigation(userData: UserAccount(name: "Mirza", email: "mirza@ui.ac.id"))), (r) => false);
                },
                child: const Text("SAYA SUDAH BAYAR"),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// --- 10. BOOKINGS PAGE ---
class BookingsPage extends StatelessWidget {
  final List<TicketModel> tickets;
  const BookingsPage({super.key, required this.tickets});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Tickets")),
      body: tickets.isEmpty ? const Center(child: Text("No Tickets")) : ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: tickets.length,
        itemBuilder: (context, i) => Card(
          margin: const EdgeInsets.only(bottom: 20),
          child: Column(
            children: [
              ListTile(title: Text("${tickets[i].from} ✈ ${tickets[i].to}"), subtitle: Text("${tickets[i].airline} • Seat ${tickets[i].seat}")),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Align(alignment: Alignment.centerLeft, child: Text("Penumpang: ${tickets[i].passengers.join(", ")}", style: const TextStyle(fontSize: 12, color: Colors.grey))),
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Icon(Icons.qr_code_2, size: 80)),
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
