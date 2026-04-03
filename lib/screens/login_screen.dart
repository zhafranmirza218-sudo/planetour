import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../main.dart'; // Pastikan di main.dart ada class MainNavigation dan UserAccount

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  bool _isLoading = false;

  Future<void> _loginSekarang() async {
    if (_emailController.text.isEmpty || _passController.text.isEmpty) {
      _notif("Email dan Password harus diisi");
      return;
    }

    setState(() => _isLoading = true);

    try {
      // GUNAKAN IP LAPTOP KAMU (Sesuaikan jika IP berubah)
      var url = Uri.parse("http://192.168.18.237/planetour_api/login_api.php");

      var response = await http.post(url, body: {
        "email": _emailController.text,
        "password": _passController.text,
      }).timeout(const Duration(seconds: 10));

      var data = jsonDecode(response.body);

      if (data['status'] == 'success') {
        if (!mounted) return;

        // --- PERBAIKAN DI SINI ---
        // Kita ambil data user dari response API dan kirim ke MainNavigation
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (c) => MainNavigation(
              userData: UserAccount(
                name: data['user']['nama'] ?? "User", // Ambil nama dari field 'nama' di database
                email: data['user']['email'] ?? _emailController.text,
              ),
            ),
          ),
        );
      } else {
        _notif(data['message']);
      }
    } catch (e) {
      _notif("Gagal konek ke server. Cek XAMPP & IP kamu!");
      print("Error Login: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _notif(String pesan) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(pesan),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.flight_takeoff, size: 80, color: Color(0xFF1A237E)),
              const SizedBox(height: 20),
              const Text("Welcome Back!",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
              const Text("Login to start your journey", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 40),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                    labelText: "Email",
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder()
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _passController,
                obscureText: true,
                decoration: const InputDecoration(
                    labelText: "Password",
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder()
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A237E),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: _isLoading ? null : _loginSekarang,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("LOGIN", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  // Tambahkan navigasi ke Register jika perlu
                },
                child: const Text("Don't have an account? Register Now", style: TextStyle(color: Color(0xFF1A237E))),
              )
            ],
          ),
        ),
      ),
    );
  }
}