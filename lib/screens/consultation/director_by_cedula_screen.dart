// lib/screens/consultation/director_by_cedula_screen.dart

import 'package:flutter/material.dart';
import 'dart:convert'; // Importa este paquete para trabajar con JSON
import '../../services/api_service.dart';

class DirectorByCedulaScreen extends StatelessWidget {
  const DirectorByCedulaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _cedulaController = TextEditingController();

    Future<Map<String, dynamic>> _fetchDirectorByCedula(String cedula) async {
      final response = await ApiService().getRequest('def/director/$cedula');
      if (response.statusCode == 200) {
        return json.decode(response.body)['director'];
      } else {
        throw Exception('Error al cargar el director');
      }
    }

    void _searchDirector(BuildContext context) async {
      final cedula = _cedulaController.text;
      if (cedula.isNotEmpty) {
        try {
          final director = await _fetchDirectorByCedula(cedula);
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('${director['nombre']} ${director['apellido']}'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.network(director['foto']),
                    Text('Fecha de Nacimiento: ${director['fechaNacimiento']}'),
                    Text('Dirección: ${director['direccion']}'),
                    Text('Teléfono: ${director['telefono']}'),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cerrar'),
                  ),
                ],
              );
            },
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor ingrese una cédula válida')),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Consultar Director por Cédula'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _cedulaController,
              decoration: const InputDecoration(
                labelText: 'Cédula del Director',
              ),
              keyboardType: TextInputType.number, // Asegúrate de usar el teclado numérico
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _searchDirector(context),
              child: const Text('Buscar'),
            ),
          ],
        ),
      ),
    );
  }
}
