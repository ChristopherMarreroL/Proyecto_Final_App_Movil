// lib/screens/extra/about_screen.dart

import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Acerca de'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/images/technician_photo.jpg'), // Asegúrate de tener esta imagen en tus assets
            ),
            const SizedBox(height: 10),
            const Text(
              'Nombre: Juan Pérez',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Matrícula: 12345678',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              '"La educación es el arma más poderosa que puedes usar para cambiar el mundo."',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}
