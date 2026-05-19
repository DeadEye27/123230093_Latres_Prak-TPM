// lib/widgets/menu_card.dart
import 'package:flutter/material.dart';
import '../pages/list_page.dart';

class MenuCard extends StatelessWidget {
  final String title;
  final String endpoint;
  final IconData icon;
  final String description;

  const MenuCard({
    super.key,
    required this.title,
    required this.endpoint,
    required this.icon,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: const Color(0xFFF0EBF8), // Warna ungu super muda dari gambar
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ListPage(
                title: title == "News" ? "Berita Terkini" : title, 
                endpoint: endpoint
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Simulasi gambar kotak di sebelah kiri
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 50, color: Colors.deepPurple),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 22, 
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333)
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: const TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}