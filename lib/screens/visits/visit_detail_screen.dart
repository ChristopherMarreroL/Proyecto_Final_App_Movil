import 'package:flutter/material.dart';
import '../../models/visit.dart';

class VisitDetailScreen extends StatelessWidget {
  final Visit visit;

  const VisitDetailScreen({super.key, required this.visit});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detalle de Visita',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
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
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            elevation: 8,
            shadowColor: Colors.black38,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Información General'),
                  const SizedBox(height: 10),
                  _buildDetailRow(
                    'Código del Centro:',
                    visit.codigoCentro,
                  ),
                  _buildDetailRow(
                    'Cédula del Director:',
                    visit.cedulaDirector ?? 'N/A',
                  ),
                  _buildDetailRow('Motivo:', visit.motivo),
                  _buildDetailRow('Comentario:', visit.comentario ?? 'No hay comentarios'),
                  const SizedBox(height: 20),
                  _buildSectionTitle('Fecha y Hora'),
                  const SizedBox(height: 10),
                  _buildDetailRow('Fecha:', visit.fecha),
                  _buildDetailRow('Hora:', visit.hora ?? 'N/A'),
                  const SizedBox(height: 20),
                  _buildLocationInfo(visit),
                  const SizedBox(height: 20),
                  _buildPhotoEvidence(visit),
                  const SizedBox(height: 20),
                  _buildVoiceNote(visit),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1A237E),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label ',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationInfo(Visit visit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Ubicación'),
        const SizedBox(height: 10),
        _buildDetailRow('Latitud:', visit.latitud),
        _buildDetailRow('Longitud:', visit.longitud),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: () {
            // Implementar la función para mostrar la ubicación en un mapa
          },
          icon: const Icon(Icons.map),
          label: const Text('Ver en el Mapa'),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: const Color(0xFFF57C00),
            elevation: 4,
            shadowColor: Colors.black54,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoEvidence(Visit visit) {
    if (visit.fotoEvidencia != null && visit.fotoEvidencia!.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Foto de Evidencia'),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Image.network(
              visit.fotoEvidencia!,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 200,
            ),
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
          _buildSectionTitle('Nota de Voz'),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: () {
              // Implementar la función para reproducir la nota de voz
            },
            icon: const Icon(Icons.play_arrow),
            label: const Text('Reproducir Nota de Voz'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white, backgroundColor: const Color(0xFFF57C00),
              elevation: 4,
              shadowColor: Colors.black54,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
          ),
        ],
      );
    }
    return Container();
  }
}
