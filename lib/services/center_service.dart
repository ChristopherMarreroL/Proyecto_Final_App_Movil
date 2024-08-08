// lib/services/center_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/school.dart';

class CenterService {
  final String _baseUrl = 'https://adamix.net/minerd/minerd';

  Future<List<School>> fetchCenters(String codigo) async {
    final url = '$_baseUrl/centros.php?regional=$codigo';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['exito']) {
        return (data['datos'] as List)
            .map((schoolData) => School.fromJson(schoolData))
            .toList();
      } else {
        throw Exception(data['mensaje'] ?? 'Error fetching centers');
      }
    } else {
      throw Exception('Error al comunicarse con el servidor');
    }
  }
}
