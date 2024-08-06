// lib/services/news_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news.dart';

class NewsService {
  final String _baseUrl = 'https://adamix.net/minerd/def/noticias.php';

  Future<List<News>> fetchNews() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => News.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar las noticias');
    }
  }
}
