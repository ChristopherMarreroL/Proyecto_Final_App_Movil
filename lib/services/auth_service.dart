import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String _baseUrl = 'https://adamix.net/minerd/def';

  Future<Map<String, dynamic>?> login({
    required String cedula,
    required String password,
  }) async {
    final url = '$_baseUrl/iniciar_sesion.php';
    final response = await http.post(
      Uri.parse(url),
      body: {
        'cedula': cedula,
        'clave': password,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['exito']) {
        // Save the token for later use
        String token = data['datos']['token'];
        await saveToken(token); // Save token to SharedPreferences
        return data;
      } else {
        throw Exception(data['mensaje']);
      }
    } else {
      throw Exception('Error al comunicarse con el servidor');
    }
  }

  Future<bool> register({
    required String cedula,
    required String nombre,
    required String apellido,
    required String correo,
    required String telefono,
    required String fechaNacimiento,
    required String clave,
  }) async {
    final url = '$_baseUrl/registro.php';
    final response = await http.post(
      Uri.parse(url),
      body: {
        'cedula': cedula,
        'nombre': nombre,
        'apellido': apellido,
        'correo': correo,
        'telefono': telefono,
        'fecha_nacimiento': fechaNacimiento,
        'clave': clave,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['exito']) {
        return true;
      } else {
        throw Exception(data['mensaje']);
      }
    } else {
      throw Exception('Error al comunicarse con el servidor');
    }
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }
}
