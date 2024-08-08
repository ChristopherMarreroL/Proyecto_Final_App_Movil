// lib/screens/consultation/school_by_code_screen.dart

import 'package:flutter/material.dart';
import '../../services/center_service.dart';
import '../../models/school.dart';

class SchoolByCodeScreen extends StatefulWidget {
  const SchoolByCodeScreen({super.key});

  @override
  _SchoolByCodeScreenState createState() => _SchoolByCodeScreenState();
}

class _SchoolByCodeScreenState extends State<SchoolByCodeScreen> {
  final TextEditingController _codeController = TextEditingController();
  final CenterService _centerService = CenterService();
  List<School> _schools = [];
  String? _errorMessage;

  Future<void> _searchSchool() async {
    final code = _codeController.text;
    if (code.isNotEmpty) {
      try {
        final schools = await _centerService.fetchCenters(code);
        setState(() {
          _schools = schools;
          _errorMessage = schools.isEmpty ? 'No se encontraron escuelas con ese código' : null;
        });
      } catch (e) {
        setState(() {
          _schools = [];
          _errorMessage = 'Error: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Consultar Centro Educativos',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
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
            _buildSearchBar(),
            const SizedBox(height: 20),
            if (_errorMessage != null) ...[
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
              const SizedBox(height: 20),
            ],
            Expanded(
              child: _schools.isEmpty
                  ? const Center(
                child: Text(
                  'Ingrese un código para buscar escuelas.',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              )
                  : ListView.builder(
                itemCount: _schools.length,
                itemBuilder: (context, index) {
                  final school = _schools[index];
                  return _buildSchoolCard(school);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _codeController,
            decoration: const InputDecoration(
              filled: true,
              fillColor: Colors.white,
              labelText: 'Código de la Escuela',
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
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: _searchSchool,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFF57C00),
            padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 20.0),
            elevation: 5,
            shadowColor: Colors.black54,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Icon(Icons.search, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildSchoolCard(School school) {
    return Card(
      color: Colors.white,
      shadowColor: Colors.black26,
      elevation: 6,
      margin: const EdgeInsets.symmetric(vertical: 8),
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
          child: const Icon(Icons.school, color: Colors.white, size: 40),
        ),
        title: Text(
          school.nombre,
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
            _buildInfoRow(Icons.code, 'Código:', school.codigo),
            _buildInfoRow(Icons.location_on, 'Coordenadas:', school.coordenadas),
            _buildInfoRow(Icons.location_city, 'Distrito:', school.distrito),
            _buildInfoRow(Icons.map, 'Regional:', school.regional),
            _buildInfoRow(Icons.place, 'Distrito Municipal:', school.dDmunicipal),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFF57C00), size: 18),
          const SizedBox(width: 5),
          Text(
            '$label ',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
