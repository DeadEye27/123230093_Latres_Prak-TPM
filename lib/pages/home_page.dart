import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/menu_card.dart';

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

  void _loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? "Guest";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hai, $username!"),
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