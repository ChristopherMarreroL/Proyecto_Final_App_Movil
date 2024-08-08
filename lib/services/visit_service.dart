import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';
import '../models/visit.dart'; // Make sure to import the Visit model

class VisitService {
  final String _baseUrl = 'adamix.net';

  // Register a new visit
  Future<bool> registerVisit({
    required String cedulaDirector,
    required String codigoCentro,
    required String motivo,
    required String fotoEvidencia,
    required String comentario,
    required String notaVoz,
    required String latitud,
    required String longitud,
    required String fecha,
    required String hora,
  }) async {
    final token = await AuthService().getToken();
    if (token == null) {
      throw Exception('Token de autenticación no encontrado');
    }

    // Construct the query parameters
    final queryParameters = {
      'cedula_director': cedulaDirector,
      'codigo_centro': codigoCentro,
      'motivo': motivo,
      'foto_evidencia': fotoEvidencia,
      'comentario': comentario,
      'nota_voz': notaVoz,
      'latitud': latitud,
      'longitud': longitud,
      'fecha': fecha,
      'hora': hora,
      'token': token,
    };

    // Use the correct path for the endpoint
    final uri = Uri.https(
        _baseUrl, 'minerd/minerd/registrar_visita.php', queryParameters);

    try {
      print('Request URI: $uri'); // Debugging line to check the final URI

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['exito']) {
          print('Visita registrada con éxito');
          return true;
        } else {
          throw Exception('Error en el registro: ${data['mensaje']}');
        }
      } else {
        throw Exception(
            'Error al comunicarse con el servidor: ${response.statusCode}');
      }
    } catch (e) {
      print('Error en _registerVisit: $e');
      throw Exception('Error al comunicarse con el servidor');
    }
  }

  // Fetch the list of visits
  Future<List<Visit>> fetchVisits(String token) async {
    // Construct the query parameters
    final queryParameters = {
      'token': token,
    };

    // Use the correct path for the endpoint
    final uri = Uri.https(_baseUrl, 'minerd/def/situaciones.php', queryParameters);

    try {
      print('Request URI: $uri'); // Debugging line to check the final URI

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['exito']) {
          print('Visitas fetched successfully');
          return (data['datos'] as List)
              .map((visitData) => Visit.fromJson(visitData))
              .toList();
        } else {
          throw Exception('Error al obtener visitas: ${data['mensaje']}');
        }
      } else {
        throw Exception('Error al comunicarse con el servidor: ${response.statusCode}');
      }
    } catch (e) {
      print('Error en fetchVisits: $e');
      throw Exception('Error al comunicarse con el servidor');
    }
  }
}
