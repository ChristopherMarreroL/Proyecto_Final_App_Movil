// lib/screens/extra/security_screen.dart

import 'package:flutter/material.dart';

class SecurityScreen extends StatelessWidget {
  const SecurityScreen({super.key});

  void _deleteAllRecords() {
    // Aquí eliminarías todos los registros de la base de datos
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seguridad'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Eliminar todos los registros'),
                  content: const Text(
                      '¿Estás seguro de que deseas eliminar todos los registros? Esta acción no se puede deshacer.'),
                  actions: [
                    TextButton(
                      child: const Text('Cancelar'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    ElevatedButton(
                      child: const Text('Eliminar'),
                      onPressed: () {
                        _deleteAllRecords();
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          },
          child: const Text('Eliminar Todos los Registros'),
        ),
      ),
    );
  }
}
