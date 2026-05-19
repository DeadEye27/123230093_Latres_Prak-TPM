import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/space_item.dart';

class ApiService {
  static const String baseUrl = 'https://api.spaceflightnewsapi.net/v4';

  static Future<List<SpaceItem>> fetchList(String endpoint) async {
    final response = await http.get(Uri.parse('$baseUrl/$endpoint/'));
    
    if (response.statusCode == 200) {
      final List data = json.decode(response.body)['results'];
      return data.map((json) => SpaceItem.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<SpaceItem> fetchDetail(String endpoint, int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$endpoint/$id/'));
    
    if (response.statusCode == 200) {
      return SpaceItem.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load detail');
    }
  }
}