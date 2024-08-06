import 'dart:convert';
import 'api_service.dart';
import '../models/video.dart';

class VideoService {
  final ApiService _apiService = ApiService();

  Future<List<Video>> fetchVideos() async {
    final response = await _apiService.getRequest('def/videos.php');

    final data = json.decode(response.body);
    if (data['exito']) {
      return (data['datos'] as List).map((json) => Video.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar los videos');
    }
  }
}
