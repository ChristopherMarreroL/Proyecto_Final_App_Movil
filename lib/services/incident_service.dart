// lib/services/incident_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/incident.dart';
import 'auth_service.dart'; // Import AuthService to get the token

class IncidentService {
  final String _baseUrl = 'https://adamix.net/minerd/def';

  Future<List<Incident>> fetchIncidents(String token) async {
    final url = Uri.parse('$_baseUrl/situaciones.php?token=$token');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['datos'];
      return data.map((incident) => Incident.fromJson(incident)).toList();
    } else {
      throw Exception('Error al cargar las visitas');
    }
  }
}
