// lib/pages/list_page.dart
import 'package:flutter/material.dart';
import '../models/space_item.dart';
import '../services/api_service.dart';
import 'detail_page.dart';

class ListPage extends StatefulWidget {
  final String title;
  final String endpoint;

  const ListPage({super.key, required this.title, required this.endpoint});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  late Future<List<SpaceItem>> futureList;

  @override
  void initState() {
    super.initState();
    futureList = ApiService.fetchList(widget.endpoint);
  }

  String _formatDate(String? isoDate) {
    if (isoDate == null) return '';
    // Format sederhana YYYY-MM-DD
    return isoDate.split('T')[0]; 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: FutureBuilder<List<SpaceItem>>(
        future: futureList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data found'));
          }

          final listData = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: listData.length,
            itemBuilder: (context, index) {
              final item = listData[index];
              return Card(
                elevation: 3,
                color: const Color(0xFFF8F5FB),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                margin: const EdgeInsets.only(bottom: 16),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPage(
                          id: item.id,
                          endpoint: widget.endpoint,
                        ),
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Gambar Full Width di atas Card
                      if (item.imageUrl != null)
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                          child: Image.network(
                            item.imageUrl!,
                            width: double.infinity,
                            height: 180,
                            fit: BoxFit.cover,
                            // Tambahkan errorBuilder di sini
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: double.infinity,
                                height: 180,
                                color: Colors.grey[300],
                                child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                              );
                            },
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              item.newsSite,
                              style: const TextStyle(color: Colors.grey, fontSize: 13),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _formatDate(item.publishedAt),
                                  style: const TextStyle(color: Colors.black54, fontSize: 13),
                                ),
                                const Icon(Icons.arrow_forward, size: 20, color: Colors.black54),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}