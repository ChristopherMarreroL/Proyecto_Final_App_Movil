// lib/screens/main_menu_screen.dart

import 'package:flutter/material.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menú Principal'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFF1A237E),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1A237E), Color(0xFF283593), Color(0xFF3949AB)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Bienvenido a la App MINERD',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                _buildMenuButton(
                  context,
                  icon: Icons.list,
                  label: 'Ver Incidencias',
                  route: '/incidents_list',
                ),
                _buildMenuButton(
                  context,
                  icon: Icons.add_circle_outline,
                  label: 'Registrar Visita',
                  route: '/visit_registration',
                ),
                _buildMenuButton(
                  context,
                  icon: Icons.visibility,
                  label: 'Ver Visitas',
                  route: '/visits_list',
                ),
                _buildMenuButton(
                  context,
                  icon: Icons.map,
                  label: 'Mapa de Visitas',
                  route: '/visits_map',
                ),
                _buildMenuButton(
                  context,
                  icon: Icons.school,
                  label: 'Consultar Escuela',
                  route: '/school_by_code',
                ),
                _buildMenuButton(
                  context,
                  icon: Icons.person_search,
                  label: 'Consultar Director',
                  route: '/director_by_cedula',
                ),
                _buildMenuButton(
                  context,
                  icon: Icons.info,
                  label: 'Acerca de',
                  route: '/about',
                ),
                _buildMenuButton(
                  context,
                  icon: Icons.security,
                  label: 'Seguridad',
                  route: '/security',
                ),
                _buildMenuButton(
                  context,
                  icon: Icons.format_list_bulleted,
                  label: 'Tipos de Visitas',
                  route: '/visit_types',
                ),
                _buildMenuButton(
                  context,
                  icon: Icons.newspaper,
                  label: 'Noticias',
                  route: '/news',
                ),
                _buildMenuButton(
                  context,
                  icon: Icons.cloud,
                  label: 'Estado del Clima',
                  route: '/weather',
                ),
                _buildMenuButton(
                  context,
                  icon: Icons.star,
                  label: 'Horóscopo',
                  route: '/horoscope',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(
      BuildContext context, {
        required IconData icon,
        required String label,
        required String route,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.pushNamed(context, route);
        },
        icon: Icon(icon, color: Colors.white),
        label: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF55409E),
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
          elevation: 5,
          shadowColor: Colors.black54,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
