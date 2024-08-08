import 'package:flutter/material.dart';
import '../../models/visit.dart';
import '../../services/auth_service.dart';
import '../../services/visit_service.dart';
import 'visit_detail_screen.dart';

class VisitsListScreen extends StatefulWidget {
  const VisitsListScreen({super.key});

  @override
  _VisitsListScreenState createState() => _VisitsListScreenState();
}

class _VisitsListScreenState extends State<VisitsListScreen> {
  final VisitService _visitService = VisitService();
  late Future<List<Visit>> _visits;

  @override
  void initState() {
    super.initState();
    _visits = _fetchVisits();
  }

  Future<List<Visit>> _fetchVisits() async {
    try {
      final token = await AuthService().getToken();
      if (token != null) {
        return await _visitService.fetchVisits(token);
      } else {
        throw Exception('Token no encontrado');
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visitas Registradas'),
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
        child: FutureBuilder<List<Visit>>(
          future: _visits,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              );
            } else {
              final visits = snapshot.data ?? [];

              if (visits.isEmpty) {
                return const Center(
                  child: Text(
                    'No hay visitas registradas.',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: visits.length,
                itemBuilder: (context, index) {
                  final visit = visits[index];
                  return _buildVisitCard(visit, context);
                },
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildVisitCard(Visit visit, BuildContext context) {
    return Card(
      color: Colors.white,
      shadowColor: Colors.black26,
      elevation: 6,
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        leading: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1A237E),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.location_on, color: Colors.white, size: 40),
        ),
        title: Text(
          visit.codigoCentro,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF283593),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.info_outline, color: Color(0xFF55409E), size: 18),
                const SizedBox(width: 5),
                Text(
                  visit.motivo,
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.calendar_today, color: Color(0xFF55409E), size: 18),
                const SizedBox(width: 5),
                Text(
                  visit.fecha,
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: Color(0xFF283593)),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VisitDetailScreen(visit: visit),
            ),
          );
        },
      ),
    );
  }
}
