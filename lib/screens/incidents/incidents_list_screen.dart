// lib/screens/incidents/incidents_list_screen.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/incident.dart';
import '../../services/incident_service.dart';
import 'incident_detail_screen.dart';

class IncidentsListScreen extends StatefulWidget {
  const IncidentsListScreen({super.key});

  @override
  _IncidentsListScreenState createState() => _IncidentsListScreenState();
}

class _IncidentsListScreenState extends State<IncidentsListScreen> {
  final IncidentService _incidentService = IncidentService();
  late Future<List<Incident>> _incidents = Future.value([]);

  @override
  void initState() {
    super.initState();
    _loadTokenAndFetchIncidents();
  }

  Future<void> _loadTokenAndFetchIncidents() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token != null) {
      setState(() {
        _incidents = _incidentService.fetchIncidents(token);
      });
    } else {
      // Maneja el caso donde el token no está disponible
      setState(() {
        _incidents = Future.error('Token no encontrado');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Incidencias Registradas'),
      ),
      body: FutureBuilder<List<Incident>>(
        future: _incidents,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final incidents = snapshot.data ?? [];
            return ListView.builder(
              itemCount: incidents.length,
              itemBuilder: (context, index) {
                final incident = incidents[index];
                return ListTile(
                  title: Text(incident.titulo),
                  subtitle: Text('${incident.centro} - ${incident.fecha}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => IncidentDetailScreen(incident: incident),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
