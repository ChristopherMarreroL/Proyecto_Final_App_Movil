// lib/screens/visits/visit_detail_screen.dart

import 'package:flutter/material.dart';
import '../../models/visit.dart';

class VisitDetailScreen extends StatelessWidget {
  final Visit visit;

  const VisitDetailScreen({super.key, required this.visit});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle de Visita: ${visit.codigoCentro}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Código del Centro: ${visit.codigoCentro}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('Cédula del Director: ${visit.cedulaDirector}'),
            Text('Motivo: ${visit.motivo}'),
            Text('Comentario: ${visit.comentario}'),
            const SizedBox(height: 10),
            Text('Fecha: ${visit.fecha}'),
            Text('Hora: ${visit.hora}'),
            const SizedBox(height: 20),
            _buildLocationInfo(visit),
            const SizedBox(height: 20),
            _buildPhotoEvidence(visit),
            const SizedBox(height: 20),
            _buildVoiceNote(visit),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationInfo(Visit visit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ubicación:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text('Latitud: ${visit.latitud}'),
        Text('Longitud: ${visit.longitud}'),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            // Implementar la función para mostrar la ubicación en un mapa
          },
          child: const Text('Ver en el Mapa'),
        ),
      ],
    );
  }

  Widget _buildPhotoEvidence(Visit visit) {
    if (visit.fotoEvidencia != null && visit.fotoEvidencia!.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Foto de Evidencia:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Image.network(
            visit.fotoEvidencia!,
            fit: BoxFit.cover,
            width: double.infinity,
            height: 200,
          ),
        ],
      );
    }
    return Container();
  }

  Widget _buildVoiceNote(Visit visit) {
    if (visit.notaVoz != null && visit.notaVoz!.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Nota de Voz:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              // Implementar la función para reproducir la nota de voz
            },
            child: const Text('Reproducir Nota de Voz'),
          ),
        ],
      );
    }
    return Container();
  }
}
