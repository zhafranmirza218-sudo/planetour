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

  Future<void> _register() async {
    if (_nameController.text.isEmpty || _emailController.text.isEmpty || _passController.text.isEmpty) {
      _notif("Semua kolom harus diisi!");
      return;
    }

    setState(() => _isLoading = true);

    try {
      var url = Uri.parse("http://localhost/planetour_api/register_api.php");
      var response = await http.post(url, body: {
        "nama": _nameController.text,
        "email": _emailController.text,
        "password": _passController.text,
      });

      var data = jsonDecode(response.body);

      if (data['status'] == 'success') {
        _notif("Berhasil daftar! Silakan login.", isError: false);
        if (!mounted) return;
        Navigator.pop(context); // Kembali ke halaman Login
      } else {
        _notif(data['message']);
      }
    } catch (e) {
      _notif("Koneksi gagal.");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _notif(String pesan, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(pesan), backgroundColor: isError ? Colors.red : Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Account")),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
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
                child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text("REGISTER", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}