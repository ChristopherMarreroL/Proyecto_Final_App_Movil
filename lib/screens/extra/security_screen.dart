// lib/screens/extra/security_screen.dart

import 'package:flutter/material.dart';
import 'dart:convert'; // Import for JSON encoding
import 'package:http/http.dart' as http;
import '../../services/auth_service.dart'; // Import your auth service to get the token

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  _SecurityScreenState createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  // Function to handle password change
  Future<void> _changePassword() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Fetch the token automatically
    final token = await AuthService().getToken();

    final url = 'https://adamix.net/minerd/def/cambiar_clave.php';
    final response = await http.post(
      Uri.parse(url),
      body: {
        'token': token, // Use the fetched token
        'clave_anterior': _currentPasswordController.text,
        'clave_nueva': _newPasswordController.text,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['exito']) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Contraseña cambiada con éxito')),
        );
      } else {
        setState(() {
          _errorMessage = data['mensaje'] ?? 'Error al cambiar la contraseña';
        });
      }
    } else {
      setState(() {
        _errorMessage = 'Error al comunicarse con el servidor';
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  // Function to delete all records
  void _deleteAllRecords() {
    // Aquí eliminarías todos los registros de la base de datos
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seguridad'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Form for changing password
            TextField(
              controller: _currentPasswordController,
              decoration: const InputDecoration(
                labelText: 'Contraseña Actual',
                prefixIcon: Icon(Icons.lock_outline),
              ),
              obscureText: true, // To hide current password
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _newPasswordController,
              decoration: const InputDecoration(
                labelText: 'Nueva Contraseña',
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true, // To hide new password
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _changePassword,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              )
                  : const Text('Cambiar Contraseña'),
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 20),
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            ],
            const Spacer(),
            ElevatedButton(
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
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
              ),
              child: const Text('Eliminar Todos los Registros'),
            ),
          ],
        ),
      ),
    );
  }
}
