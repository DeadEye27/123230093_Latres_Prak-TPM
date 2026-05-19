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
            itemCount: listData.length,
            itemBuilder: (context, index) {
              final item = listData[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  leading: item.imageUrl != null
                      ? Image.network(item.imageUrl!, width: 80, fit: BoxFit.cover)
                      : const Icon(Icons.image),
                  title: Text(item.title, maxLines: 2, overflow: TextOverflow.ellipsis),
                  subtitle: Text(item.newsSite),
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
                ),
              );
            },
          );
        },
      ),
    );
  }
}