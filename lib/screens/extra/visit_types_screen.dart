// lib/screens/extra/visit_types_screen.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VisitTypesScreen extends StatelessWidget {
  const VisitTypesScreen({super.key});

  Future<List<dynamic>> _fetchVisitTypes() async {
    final response = await http.get(Uri.parse('https://adamix.net/minerd/api/visitas'));
    if (response.statusCode == 200) {
      return json.decode(response.body)['visitas'];
    } else {
      throw Exception('Error al cargar tipos de visitas');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tipos de Visitas'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _fetchVisitTypes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final visits = snapshot.data ?? [];
            return ListView.builder(
              itemCount: visits.length,
              itemBuilder: (context, index) {
                final visit = visits[index];
                return ListTile(
                  title: Text(visit['nombre']),
                  subtitle: Text(visit['descripcion']),
                );
              },
            );
          }
        },
      ),
    );
  }
}
