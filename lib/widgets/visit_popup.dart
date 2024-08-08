// lib/widgets/visit_popup.dart

import 'package:flutter/material.dart';

class VisitPopup extends StatelessWidget {
  final Map<String, dynamic> visit;

  const VisitPopup({Key? key, required this.visit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final school = visit['codigo_centro'] ?? 'Centro sin nombre';
    final motivo = visit['motivo'];
    final fecha = visit['fecha'];
    final hora = visit['hora'];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              school,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text('Motivo: $motivo'),
            Text('Fecha: $fecha'),
            Text('Hora: $hora'),
          ],
        ),
      ),
    );
  }
}
