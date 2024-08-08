// lib/services/api_service.dart

import 'package:http/http.dart' as http;

class ApiService {
  final String _baseUrl = 'https://adamix.net/minerd/';

  Future<http.Response> getRequest(String endpoint) {
    final url = '$_baseUrl$endpoint';
    return http.get(Uri.parse(url));
  }
}
