// lib/services/visit_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/visit.dart'; // Import the Visit model

class VisitService {
  final String _baseUrl = 'https://adamix.net/minerd/def';

  Future<List<Visit>> fetchVisits(String token) async {
    final url = '$_baseUrl/situaciones.php?token=$token';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['exito']) {
        return (data['datos'] as List)
            .map((visitData) => Visit.fromJson(visitData))
            .toList();
      } else {
        throw Exception(data['mensaje'] ?? 'Error fetching visits');
      }
    } else {
      throw Exception('Error al comunicarse con el servidor');
    }
  }
}
