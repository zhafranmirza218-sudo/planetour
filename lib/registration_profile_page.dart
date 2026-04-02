import 'package:flutter/material.dart';

class RegistrationProfilePage extends StatelessWidget {
  // Data profil user hasil registrasi di aplikasi maskapai
  final String namaLengkap;
  final String email;
  final String nomorPaspor;
  final String kewarganegaraan;
  final String memberStatus; // misal: Silver, Gold, Platinum

  const RegistrationProfilePage({
    super.key,
    required this.namaLengkap,
    required this.email,
    required this.nomorPaspor,
    required this.kewarganegaraan,
    required this.memberStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Profil Akun Maskapai'),
        centerTitle: true,
        backgroundColor: Colors.blue[900],
        foregroundColor: Colors.white,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.edit)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Bagian Header Profil
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 30),
              decoration: BoxDecoration(
                color: Colors.blue[900],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 60, color: Colors.blue),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    namaLengkap,
                    style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    email,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Bagian Status Loyalitas/Member
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Card(
                color: Colors.amber[50],
                child: ListTile(
                  leading: const Icon(Icons.card_membership, color: Colors.amber),
                  title: const Text("Tipe Keanggotaan"),
                  subtitle: Text("$memberStatus Member"),
                  trailing: const Text("5.200 Miles", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Informasi Dokumen Perjalanan
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Informasi Dokumen",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  _buildDataField("Nomor Paspor / NIK", nomorPaspor),
                  _buildDataField("Kewarganegaraan", kewarganegaraan),
                  _buildDataField("Tanggal Lahir", "12 Januari 2000"), // Contoh data tambahan

                  const SizedBox(height: 30),

                  // Tombol Logout atau Pengaturan
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                        foregroundColor: Colors.red,
                      ),
                      child: const Text("Keluar dari Akun"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk menampilkan baris data profil yang bersih
  Widget _buildDataField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 5),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          const Divider(),
        ],
      ),
    );
  }
}