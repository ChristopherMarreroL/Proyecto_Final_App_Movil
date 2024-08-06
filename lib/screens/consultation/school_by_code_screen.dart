// lib/screens/consultation/school_by_code_screen.dart

import 'package:flutter/material.dart';
import '../../services/center_service.dart';
import '../../models/school.dart';

class SchoolByCodeScreen extends StatefulWidget {
  const SchoolByCodeScreen({super.key});

  @override
  _SchoolByCodeScreenState createState() => _SchoolByCodeScreenState();
}

class _SchoolByCodeScreenState extends State<SchoolByCodeScreen> {
  final TextEditingController _codeController = TextEditingController();
  final CenterService _centerService = CenterService();
  School? _school;

  void _searchSchool() async {
    final code = _codeController.text;
    if (code.isNotEmpty) {
      try {
        final school = await _centerService.fetchCenters(code);
        setState(() {
          _school = school.first;
        });
      } catch (e) {
        _showError('Error: $e');
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consultar Escuela por Código'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _codeController,
              decoration: const InputDecoration(labelText: 'Código de la Escuela'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _searchSchool,
              child: const Text('Buscar'),
            ),
            if (_school != null) ...[
              const SizedBox(height: 20),
              Text('Nombre: ${_school!.nombre}'),
              Text('Dirección: ${_school!.direccion}'),
              Text('Teléfono: ${_school!.telefono}'),
            ],
          ],
        ),
      ),
    );
  }
}
