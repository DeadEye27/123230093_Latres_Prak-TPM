// lib/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/menu_card.dart';
import 'login_page.dart'; // Impor login_page untuk navigasi balik setelah logout

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String username = "";

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  // Memuat username yang sedang login
  void _loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? "Guest";
    });
  }

  // Fungsi untuk Logout
  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    // Hapus hanya session username yang aktif login
    // Jangan hapus 'registered_username' atau 'registered_password' agar akun tetap terdaftar
    await prefs.remove('username'); 

    if (mounted) {
      // Tampilkan notifikasi singkat
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Berhasil Logout')),
      );
      
      // Arahkan kembali ke halaman Login dan hapus tumpukan navigasi sebelumnya
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hai, $username!"),
        centerTitle: false, // Menjaga teks salam berada di kiri jika diinginkan
        actions: [
          // Menambahkan Tombol Logout di pojok kanan AppBar
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              // Menampilkan dialog konfirmasi sebelum logout (opsional tapi disarankan agar lebih rapi)
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Konfirmasi Keluar"),
                    content: const Text("Apakah Anda yakin ingin logout?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Batal"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // Tutup dialog
                          _logout(); // Jalankan fungsi logout
                        },
                        child: const Text("Ya, Keluar", style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          MenuCard(
            title: "News",
            endpoint: "articles",
            icon: Icons.article,
            description: "Get an overview of the latest spaceflight news.",
          ),
          MenuCard(
            title: "Blog",
            endpoint: "blogs",
            icon: Icons.book,
            description: "Blogs often provide a more detailed overview.",
          ),
          MenuCard(
            title: "Report",
            endpoint: "reports",
            icon: Icons.bar_chart,
            description: "Space stations and missions often publish their data.",
          ),
        ],
      ),
    );
  }
}