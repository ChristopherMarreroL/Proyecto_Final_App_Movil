import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String _apiKey = 'f0c9068d96ec4119987230951240508';
  final String _baseUrl = 'http://api.weatherapi.com/v1';

  Future<Map<String, dynamic>> getCurrentWeather(double lat, double lon) async {
    final url = Uri.parse(
        '$_baseUrl/current.json?key=$_apiKey&q=$lat,$lon&aqi=no');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al cargar los datos del clima');
    }
  }
}
