// lib/screens/extra/horoscope_screen.dart

import 'package:flutter/material.dart';

class HoroscopeScreen extends StatelessWidget {
  const HoroscopeScreen({super.key});

  Future<String> _fetchHoroscope() async {
    // Ejemplo simple de horóscopo, puede ser reemplazado por una llamada a una API real
    return Future.delayed(const Duration(seconds: 2),
            () => 'Hoy es un buen día para aprender algo nuevo.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Horóscopo'),
      ),
      body: FutureBuilder<String>(
        future: _fetchHoroscope(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final horoscope = snapshot.data ?? '';
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(horoscope),
              ),
            );
          }
        },
      ),
    );
  }
}
