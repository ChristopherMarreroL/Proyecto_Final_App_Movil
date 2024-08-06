import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'https://adamix.net/minerd/';

  Future<http.Response> getRequest(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await http.get(url);
    _handleResponse(response);
    return response;
  }

  Future<http.Response> postRequest(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await http.post(url, body: data);
    _handleResponse(response);
    return response;
  }

  void _handleResponse(http.Response response) {
    if (response.statusCode != 200) {
      throw Exception('Failed to load data: ${response.reasonPhrase}');
    }
  }
}
