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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SpaceItem>(
      future: futureDetail,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: const Text("Detail")),
            body: const Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: const Text("Detail")),
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        }

        final detailData = snapshot.data!;
        
        return Scaffold(
          appBar: AppBar(title: const Text("Detail")),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (detailData.imageUrl != null)
                  Image.network(detailData.imageUrl!, fit: BoxFit.cover, width: double.infinity, height: 250),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        detailData.title,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Source: ${detailData.newsSite} | ${detailData.publishedAt?.split('T')[0] ?? ''}",
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        detailData.summary ?? 'No summary available.',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: detailData.url != null
              ? FloatingActionButton.extended(
                  onPressed: () => _launchUrl(detailData.url!),
                  icon: const Icon(Icons.open_in_browser),
                  label: const Text("See more..."),
                )
              : null,
        );
      },
    );
  }
}