import 'dart:convert';
import 'api_service.dart';
import '../models/school.dart';

class CenterService {
  final ApiService _apiService = ApiService();

  Future<List<School>> fetchCenters(String regional) async {
    final response = await _apiService.getRequest('minerd/centros.php?regional=$regional');

    final data = json.decode(response.body);
    if (data['exito']) {
      return (data['datos'] as List).map((json) => School.fromJson(json)).toList();
    } else {
      throw Exception(data['mensaje']);
    }
  }
}
