// lib/screens/main_menu_screen.dart

import 'package:flutter/material.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menú Principal'),
      ),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/incidents_list');
              },
              child: const Text('Ver Incidencias'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/visit_registration');
              },
              child: const Text('Registrar Visita'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/visits_list');
              },
              child: const Text('Ver Visitas'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/visits_map');
              },
              child: const Text('Mapa de Visitas'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/school_by_code');
              },
              child: const Text('Consultar Escuela'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/director_by_cedula');
              },
              child: const Text('Consultar Director'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/about');
              },
              child: const Text('Acerca de'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/security');
              },
              child: const Text('Seguridad'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/visit_types');
              },
              child: const Text('Tipos de Visitas'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/news');
              },
              child: const Text('Noticias'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/weather');
              },
              child: const Text('Estado del Clima'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/horoscope');
              },
              child: const Text('Horóscopo'),
            ),
          ],
        ),
      ),
    );
  }
}
