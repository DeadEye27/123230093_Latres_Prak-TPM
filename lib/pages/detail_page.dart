// lib/pages/detail_page.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/space_item.dart';
import '../services/api_service.dart';

class DetailPage extends StatefulWidget {
  final int id;
  final String endpoint;

  const DetailPage({super.key, required this.id, required this.endpoint});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Future<SpaceItem> futureDetail;

  @override
  void initState() {
    super.initState();
    futureDetail = ApiService.fetchDetail(widget.endpoint, widget.id);
  }

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      throw 'Could not launch $urlString';
    }
  }

  String _formatDate(String? isoDate) {
    if (isoDate == null) return '';
    return isoDate.split('T')[0]; 
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SpaceItem>(
      future: futureDetail,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: const Text("News Detail")),
            body: const Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: const Text("News Detail")),
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        }

        final detailData = snapshot.data!;
        
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(title: const Text("News Detail")),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Gambar membentang penuh tanpa padding
                if (detailData.imageUrl != null)
                  Image.network(
                    detailData.imageUrl!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 220,
                    // Tambahkan errorBuilder di sini
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: double.infinity,
                        height: 220,
                        color: Colors.grey[300],
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                            SizedBox(height: 8),
                            Text("Gambar gagal dimuat", style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      );
                    },
                  ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        detailData.title,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        detailData.newsSite,
                        style: const TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatDate(detailData.publishedAt),
                        style: const TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        detailData.summary ?? 'No summary available.',
                        style: const TextStyle(fontSize: 16, height: 1.5, color: Colors.black87),
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(height: 80), // Ruang ekstra agar teks tidak tertutup FAB
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Floating button gelap bergaya desain PDF
          floatingActionButton: detailData.url != null
              ? FloatingActionButton.extended(
                  backgroundColor: const Color(0xFF1E1E1E), // Warna hitam gelap
                  foregroundColor: Colors.white,
                  onPressed: () => _launchUrl(detailData.url!),
                  icon: const Icon(Icons.web, size: 20),
                  label: const Text("See more...", style: TextStyle(fontWeight: FontWeight.bold)),
                )
              : null,
        );
      },
    );
  }
}