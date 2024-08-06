import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class VisitService {
  final String _baseUrl = 'https://adamix.net/minerd';

  Future<bool> registerVisit({
    required String cedulaDirector,
    required String codigoCentro,
    required String motivo,
    required File fotoEvidencia,
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

    final url = '$_baseUrl/def/registrar_visita.php'; // Ajustar la URL
    final request = http.MultipartRequest('POST', Uri.parse(url))
      ..fields['cedulaDirector'] = cedulaDirector
      ..fields['codigoCentro'] = codigoCentro
      ..fields['motivo'] = motivo
      ..fields['comentario'] = comentario
      ..fields['notaVoz'] = notaVoz
      ..fields['latitud'] = latitud
      ..fields['longitud'] = longitud
      ..fields['fecha'] = fecha
      ..fields['hora'] = hora
      ..fields['token'] = token
      ..files.add(await http.MultipartFile.fromPath('fotoEvidencia', fotoEvidencia.path));

    final response = await request.send();
    final responseData = await http.Response.fromStream(response);

    if (responseData.statusCode == 200) {
      final data = json.decode(responseData.body);
      return data['exito'];
    } else {
      print('Error al comunicarse con el servidor: ${responseData.statusCode}');
      print('Response: ${responseData.body}');
      throw Exception('Error al comunicarse con el servidor');
    }
  }
}
