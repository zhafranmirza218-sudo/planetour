import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  bool _isLoading = false;

  // GUNAKAN IP YANG SAMA DENGAN MAIN.DART
  final String apiUrl = "http://192.168.18.237/planetour_api/register_api.php";

  Future<void> _register() async {
    if (_nameController.text.isEmpty || _emailController.text.isEmpty || _passController.text.isEmpty) {
      _notif("Semua kolom harus diisi!");
      return;
    }

    setState(() => _isLoading = true);

    try {
      print("Mencoba kirim ke: $apiUrl");
      var response = await http.post(
        Uri.parse(apiUrl),
        body: {
          "nama": _nameController.text,
          "email": _emailController.text,
          "password": _passController.text,
        },
      ).timeout(const Duration(seconds: 10));

      print("DEBUG SERVER: ${response.body}");
      var data = jsonDecode(response.body);

      if (data['status'] == 'success') {
        _notif("Akun berhasil dibuat!", isError: false);
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        _notif(data['message']);
      }
    } catch (e) {
      print("ERROR REGISTER: $e");
      _notif("Koneksi gagal. Cek XAMPP & Firewall!");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _notif(String pesan, {bool isError = true}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(pesan), backgroundColor: isError ? Colors.red : Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Account"), backgroundColor: const Color(0xFF1A237E), foregroundColor: Colors.white),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            const Icon(Icons.person_add, size: 80, color: Color(0xFF1A237E)),
            const SizedBox(height: 30),
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: "Full Name", border: OutlineInputBorder())),
            const SizedBox(height: 15),
            TextField(controller: _emailController, decoration: const InputDecoration(labelText: "Email", border: OutlineInputBorder())),
            const SizedBox(height: 15),
            TextField(controller: _passController, obscureText: true, decoration: const InputDecoration(labelText: "Password", border: OutlineInputBorder())),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1A237E)),
                onPressed: _isLoading ? null : _register,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("REGISTER", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}