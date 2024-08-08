// lib/screens/consultation/director_by_cedula_screen.dart

import 'package:flutter/material.dart';
import 'dart:convert'; // Import to work with JSON
import '../../services/api_service.dart';

class DirectorByCedulaScreen extends StatefulWidget {
  const DirectorByCedulaScreen({super.key});

  @override
  _DirectorByCedulaScreenState createState() => _DirectorByCedulaScreenState();
}

class _DirectorByCedulaScreenState extends State<DirectorByCedulaScreen> {
  final TextEditingController _cedulaController = TextEditingController();
  Map<String, dynamic>? _director; // Store the director's data
  bool _isLoading = false; // Track loading state
  String? _errorMessage; // Store error messages

  // Fetch director by cedula
  Future<void> _fetchDirectorByCedula(String cedula) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await ApiService().getRequest('def/director/$cedula');
      // Decode the JSON response
      final data = json.decode(response.body);
      if (data['exito']) {
        setState(() {
          _director = data['director'];
        });
      } else {
        setState(() {
          _errorMessage = 'Error al cargar el director: ${data['mensaje']}';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al conectar con el servidor: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Search and show director information
  void _searchDirector() async {
    final cedula = _cedulaController.text;
    if (cedula.isNotEmpty) {
      await _fetchDirectorByCedula(cedula);
      // Show dialog if the director information is available
      if (_director != null) {
        _showDirectorDialog(context);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor ingrese una cédula válida')),
      );
    }
  }

  // Display director information in a dialog
  void _showDirectorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('${_director!['nombre']} ${_director!['apellido']}'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_director!['foto'] != null && _director!['foto'].isNotEmpty)
                  Image.network(
                    _director!['foto'],
                    height: 150,
                    width: 150,
                    fit: BoxFit.cover,
                  ),
                const SizedBox(height: 10),
                Text('Fecha de Nacimiento: ${_director!['fechaNacimiento']}'),
                Text('Dirección: ${_director!['direccion']}'),
                Text('Teléfono: ${_director!['telefono']}'),
              ],
            ),
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
  }

  @override
  Widget build(BuildContext context) {
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
              keyboardType: TextInputType.number, // Use numeric keyboard
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _searchDirector,
              child: const Text('Buscar'),
            ),
            const SizedBox(height: 20),
            if (_isLoading)
              const CircularProgressIndicator(), // Show loading indicator
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ), // Show error message
          ],
        ),
      ),
    );
  }
}
