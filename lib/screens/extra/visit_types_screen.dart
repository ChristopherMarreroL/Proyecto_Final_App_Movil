// lib/screens/extra/visit_types_screen.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../services/auth_service.dart'; // Import AuthService

class VisitTypesScreen extends StatefulWidget {
  const VisitTypesScreen({super.key});

  @override
  _VisitTypesScreenState createState() => _VisitTypesScreenState();
}

class _VisitTypesScreenState extends State<VisitTypesScreen> {
  final TextEditingController _idController = TextEditingController(); // Controller for input
  bool _isLoading = false;
  String? _errorMessage;
  Map<String, dynamic>? _visitData;

  // Fetch visit types by situacionId
  Future<void> _fetchVisitTypes(String situacionId) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Obtain the token using AuthService
      final token = await AuthService().getToken();
      if (token != null) {
        final url =
            'https://adamix.net/minerd/def/situacion.php?token=$token&situacion_id=$situacionId';
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data['exito']) {
            setState(() {
              _visitData = data['datos'];
              _errorMessage = null;
            });
          } else {
            setState(() {
              _errorMessage = 'Error: ${data['mensaje']}';
            });
          }
        } else {
          setState(() {
            _errorMessage = 'Error al cargar tipos de visitas';
          });
        }
      } else {
        setState(() {
          _errorMessage = 'Token no encontrado';
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

  void _searchVisitType() {
    final situacionId = _idController.text.trim();
    if (situacionId.isNotEmpty) {
      _fetchVisitTypes(situacionId);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor ingrese un ID de situación válido')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tipos de Visitas'),
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
        child: Column(
          children: [
            _buildSearchField(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _searchVisitType,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: const Color(0xFFF57C00),
                padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 20.0),
                elevation: 5,
                shadowColor: Colors.black54,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Buscar', style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 20),
            if (_isLoading)
              const CircularProgressIndicator(),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            if (_visitData != null) _buildVisitDetails(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _idController,
      decoration: const InputDecoration(
        filled: true,
        fillColor: Colors.white,
        labelText: 'Ingrese el ID de la situación',
        labelStyle: TextStyle(color: Color(0xFF1A237E)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFF57C00)),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
      ),
      style: const TextStyle(color: Colors.black),
      keyboardType: TextInputType.number,
    );
  }

  Widget _buildVisitDetails() {
    return Expanded(
      child: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          _buildDetailCard('Cédula del Director', _visitData!['cedula_director'] ?? 'N/A'),
          _buildDetailCard('Código del Centro', _visitData!['codigo_centro'] ?? 'N/A'),
          _buildDetailCard('Motivo', _visitData!['motivo'] ?? 'N/A'),
          _buildDetailCard('Comentario', _visitData!['comentario'] ?? 'N/A'),
          _buildDetailCard('Fecha', _visitData!['fecha'] ?? 'N/A'),
          _buildDetailCard('Hora', _visitData!['hora'] ?? 'N/A'),
          _buildDetailCard('Latitud', _visitData!['latitud'] ?? 'N/A'),
          _buildDetailCard('Longitud', _visitData!['longitud'] ?? 'N/A'),
        ],
      ),
    );
  }

  Widget _buildDetailCard(String title, String value) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A237E),
          ),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(color: Colors.black87),
        ),
      ),
    );
  }
}
