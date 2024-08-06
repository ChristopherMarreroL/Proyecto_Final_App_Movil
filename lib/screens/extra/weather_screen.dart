// lib/screens/extra/weather_screen.dart

import 'package:flutter/material.dart';
import '../../services/weather_service.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final WeatherService _weatherService = WeatherService();
  Map<String, dynamic>? _weatherData;
  bool _isLoading = true;

  // Coordenadas predefinidas (pueden ser cambiadas según tu preferencia)
  double latitude = 18.4834;
  double longitude = -69.9290;

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    try {
      final weatherData = await _weatherService.getCurrentWeather(latitude, longitude);
      setState(() {
        _weatherData = weatherData;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _updateCoordinates() {
    // Abrir un cuadro de diálogo para solicitar la entrada de coordenadas del usuario
    showDialog(
      context: context,
      builder: (BuildContext context) {
        double? lat;
        double? lon;

        return AlertDialog(
          title: const Text('Ingrese las coordenadas'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Latitud'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  lat = double.tryParse(value);
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Longitud'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  lon = double.tryParse(value);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (lat != null && lon != null) {
                  setState(() {
                    latitude = lat!;
                    longitude = lon!;
                    _isLoading = true;
                    _fetchWeather();
                  });
                }
                Navigator.of(context).pop();
              },
              child: const Text('Actualizar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estado del Clima'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _weatherData != null
          ? Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.network(
                  'https:${_weatherData!['current']['condition']['icon']}',
                  width: 50,
                  height: 50,
                ),
                const SizedBox(width: 10),
                Text(
                  _weatherData!['current']['condition']['text'],
                  style: const TextStyle(fontSize: 24),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Temperatura: ${_weatherData!['current']['temp_c']} °C',
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              'Humedad: ${_weatherData!['current']['humidity']} %',
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              'Viento: ${_weatherData!['current']['wind_kph']} kph',
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              'Presión: ${_weatherData!['current']['pressure_mb']} mb',
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              'Sensación Térmica: ${_weatherData!['current']['feelslike_c']} °C',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      )
          : const Center(child: Text('No se pudo cargar el clima')),
      floatingActionButton: FloatingActionButton(
        onPressed: _updateCoordinates,
        tooltip: 'Actualizar Coordenadas',
        child: const Icon(Icons.edit_location),
      ),
    );
  }
}
