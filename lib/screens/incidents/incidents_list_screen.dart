// lib/screens/incidents/incidents_list_screen.dart

import 'package:flutter/material.dart';
import '../../models/incident.dart';
import '../../services/incident_service.dart';
import '../../services/auth_service.dart'; // Import AuthService
import 'incident_detail_screen.dart';

class IncidentsListScreen extends StatefulWidget {
  const IncidentsListScreen({super.key});

  @override
  _IncidentsListScreenState createState() => _IncidentsListScreenState();
}

class _IncidentsListScreenState extends State<IncidentsListScreen> {
  final IncidentService _incidentService = IncidentService();
  late Future<List<Incident>> _incidents;

  @override
  void initState() {
    super.initState();
    _incidents = _fetchIncidents(); // Initialize the incidents fetching process
  }

  Future<List<Incident>> _fetchIncidents() async {
    try {
      // Get the token from AuthService
      final token = await AuthService().getToken();
      if (token != null) {
        // Fetch incidents using the retrieved token
        return await _incidentService.fetchIncidents(token);
      } else {
        throw Exception('Token no encontrado');
      }
    } catch (e) {
      return Future.error(e); // Handle errors by returning a Future error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Incidencias Registradas'),
        backgroundColor: const Color(0xFF3949AB),
        centerTitle: true,
        elevation: 4,
        shadowColor: Colors.black45,
      ),
      body: FutureBuilder<List<Incident>>(
        future: _incidents,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                ),
              ),
            );
          } else {
            final incidents = snapshot.data ?? [];
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: incidents.length,
              itemBuilder: (context, index) {
                final incident = incidents[index];
                return _buildIncidentCard(context, incident);
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildIncidentCard(BuildContext context, Incident incident) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 5,
      shadowColor: Colors.black54,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.0),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => IncidentDetailScreen(incident: incident),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                incident.titulo,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A237E),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${incident.centro} - ${incident.fecha}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    color: Color(0xFFF57C00),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      incident.descripcion ?? 'No hay descripción disponible',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
