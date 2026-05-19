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
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: Icon(icon, size: 40, color: Colors.deepPurple),
        title: Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        subtitle: Text(description),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ListPage(title: title, endpoint: endpoint),
            ),
          );
        },
      ),
    );
  }
}