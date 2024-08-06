// lib/screens/incidents/incident_registration_screen.dart

import 'package:flutter/material.dart';

class IncidentRegistrationScreen extends StatefulWidget {
  const IncidentRegistrationScreen({super.key});

  @override
  _IncidentRegistrationScreenState createState() =>
      _IncidentRegistrationScreenState();
}

class _IncidentRegistrationScreenState
    extends State<IncidentRegistrationScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _schoolController = TextEditingController();
  final TextEditingController _regionController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String? _photoPath;
  String? _audioPath;

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _selectPhoto() async {
    // Implementar función para seleccionar una foto
  }

  void _recordAudio() async {
    // Implementar función para grabar audio
  }

  void _saveIncident() {
    // Guardar la incidencia en la base de datos o localmente
    // Validar que todos los campos estén llenos
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Incidencia'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Título'),
            ),
            TextField(
              controller: _schoolController,
              decoration: const InputDecoration(labelText: 'Centro Educativo'),
            ),
            TextField(
              controller: _regionController,
              decoration: const InputDecoration(labelText: 'Regional'),
            ),
            TextField(
              controller: _districtController,
              decoration: const InputDecoration(labelText: 'Distrito'),
            ),
            ListTile(
              title: const Text('Fecha'),
              subtitle: Text('${_selectedDate.toLocal()}'.split(' ')[0]),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectDate(context),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Descripción'),
              maxLines: 3,
            ),
            ElevatedButton(
              onPressed: _selectPhoto,
              child: const Text('Seleccionar Foto'),
            ),
            ElevatedButton(
              onPressed: _recordAudio,
              child: const Text('Grabar Audio'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveIncident,
              child: const Text('Guardar Incidencia'),
            ),
          ],
        ),
      ),
    );
  }
}
