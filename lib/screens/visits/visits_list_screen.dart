// lib/screens/visits/visits_list_screen.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/visit.dart';
import '../../models/incident.dart';
import '../../services/incident_service.dart';
import 'visit_detail_screen.dart';

class VisitsListScreen extends StatefulWidget {
  const VisitsListScreen({super.key});

  @override
  _VisitsListScreenState createState() => _VisitsListScreenState();
}

class _VisitsListScreenState extends State<VisitsListScreen> {
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
        title: const Text('Visitas Registradas'),
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
            final visits = incidents.map((incident) => _convertIncidentToVisit(incident)).toList();

            return ListView.builder(
              itemCount: visits.length,
              itemBuilder: (context, index) {
                final visit = visits[index];
                return ListTile(
                  title: Text(visit.codigoCentro),
                  subtitle: Text('${visit.motivo} - ${visit.fecha}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VisitDetailScreen(visit: visit),
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

  Visit _convertIncidentToVisit(Incident incident) {
    return Visit(
      id: incident.id,
      cedulaDirector: 'N/A', // Si no hay campo cedulaDirector, usa un valor por defecto
      codigoCentro: incident.centro,
      motivo: incident.titulo,
      comentario: incident.descripcion,
      notaVoz: incident.audioPath,
      fotoEvidencia: incident.fotoPath,
      latitud: '0.0', // Usa valores por defecto o calcula si es necesario
      longitud: '0.0',
      fecha: incident.fecha,
      hora: 'N/A', // Usa un valor por defecto si no existe en Incident
    );
  }
}
