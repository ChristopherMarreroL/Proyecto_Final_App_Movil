// lib/screens/incidents/incident_detail_screen.dart

import 'package:flutter/material.dart';
import '../../models/incident.dart';

class IncidentDetailScreen extends StatelessWidget {
  final Incident incident;

  const IncidentDetailScreen({super.key, required this.incident});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle de Incidencia: ${incident.titulo}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildIncidentDetails(),
            const SizedBox(height: 20),
            _buildPhoto(),
            const SizedBox(height: 20),
            _buildAudio(),
          ],
        ),
      ),
    );
  }

  Widget _buildIncidentDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Centro: ${incident.centro}',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text('Regional: ${incident.regional}'),
        Text('Distrito: ${incident.distrito}'),
        Text('Fecha: ${incident.fecha}'),
        const SizedBox(height: 10),
        const Text(
          'Descripción:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text(incident.descripcion),
      ],
    );
  }

  Widget _buildPhoto() {
    if (incident.fotoPath != null && incident.fotoPath!.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Foto:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Image.network(
            incident.fotoPath!,
            fit: BoxFit.cover,
            width: double.infinity,
            height: 200,
          ),
        ],
      );
    }
    return Container();
  }

  Widget _buildAudio() {
    if (incident.audioPath != null && incident.audioPath!.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Audio:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              // Implementar la función para reproducir el audio
              _playAudio(incident.audioPath!);
            },
            child: const Text('Reproducir Audio'),
          ),
        ],
      );
    }
    return Container();
  }

  void _playAudio(String audioPath) {
    // Implementar la lógica para reproducir audio usando un paquete como audioplayers
    print('Reproduciendo audio: $audioPath');
  }
}
