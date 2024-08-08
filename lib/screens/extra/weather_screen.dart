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

  // Predefined coordinates (can be changed as per your preference)
  double latitude = 18.4834;
  double longitude = -69.9290;

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    try {
      final weatherData =
      await _weatherService.getCurrentWeather(latitude, longitude);
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
    // Open a dialog to request user input for coordinates
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
        centerTitle: true,
        backgroundColor: const Color(0xFF1A237E),
        elevation: 4,
        shadowColor: Colors.black54,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF283593), Color(0xFF3949AB), Color(0xFF1A237E)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _weatherData != null
            ? Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWeatherCard(),
              const SizedBox(height: 20),
              _buildWeatherDetails(),
            ],
          ),
        )
            : const Center(
          child: Text(
            'No se pudo cargar el clima',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _updateCoordinates,
        tooltip: 'Actualizar Coordenadas',
        backgroundColor: const Color(0xFFF57C00),
        child: const Icon(Icons.edit_location),
      ),
    );
  }

  Widget _buildWeatherCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 8,
      shadowColor: Colors.black26,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Image.network(
              'https:${_weatherData!['current']['condition']['icon']}',
              width: 80,
              height: 80,
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _weatherData!['current']['condition']['text'],
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF283593),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Temperatura: ${_weatherData!['current']['temp_c']} °C',
                  style: const TextStyle(fontSize: 18, color: Colors.black87),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherDetails() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 8,
      shadowColor: Colors.black26,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow(
              icon: Icons.opacity,
              label: 'Humedad',
              value: '${_weatherData!['current']['humidity']} %',
            ),
            const Divider(),
            _buildDetailRow(
              icon: Icons.air,
              label: 'Viento',
              value: '${_weatherData!['current']['wind_kph']} kph',
            ),
            const Divider(),
            _buildDetailRow(
              icon: Icons.compress,
              label: 'Presión',
              value: '${_weatherData!['current']['pressure_mb']} mb',
            ),
            const Divider(),
            _buildDetailRow(
              icon: Icons.thermostat,
              label: 'Sensación Térmica',
              value: '${_weatherData!['current']['feelslike_c']} °C',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({required IconData icon, required String label, required String value}) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFFF57C00), size: 30),
        const SizedBox(width: 10),
        Text(
          '$label:',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 10),
        Text(
          value,
          style: const TextStyle(fontSize: 18, color: Colors.black54),
        ),
      ],
    );
  }
}