// lib/services/incident_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/incident.dart';

class IncidentService {
  final String apiUrl = 'https://adamix.net/minerd/def/situaciones.php';

  Future<List<Incident>> fetchIncidents(String token) async {
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      // Asegúrate de que cada elemento del JSON sea un Map<String, dynamic>
      return data.map((item) => Incident.fromJson(item as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Error al cargar las incidencias');
    }
  }
}
