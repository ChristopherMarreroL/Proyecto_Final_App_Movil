// lib/screens/visits/visits_map_screen.dart

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class VisitsMapScreen extends StatelessWidget {
  const VisitsMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Simulando datos de visitas
    final visits = [
      {
        'lat': 18.4834,
        'lng': -69.9290,
        'school': 'Escuela A',
      },
      {
        'lat': 18.4861,
        'lng': -69.9366,
        'school': 'Escuela B',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa de Visitas'),
      ),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(18.4834, -69.9290),
          zoom: 12,
        ),
        markers: visits.map((visit) {
          final lat = visit['lat'] as double;
          final lng = visit['lng'] as double;
          final school = visit['school'] as String;

          return Marker(
            markerId: MarkerId(school),
            position: LatLng(lat, lng),
            infoWindow: InfoWindow(
              title: school,
              onTap: () {
                // Mostrar detalles de la visita
              },
            ),
          );
        }).toSet(),
      ),
    );
  }
}
