// lib/main.dart
import 'package:flutter/material.dart';
import 'pages/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spaceflight App',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF212124), // Warna gelap ala desain soal
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        scaffoldBackgroundColor: const Color(0xFFF3F4F6),
        primarySwatch: Colors.deepPurple,
      ),
      home: const LoginPage(),
    );
  }
}