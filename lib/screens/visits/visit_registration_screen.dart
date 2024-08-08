// lib/screens/visits/visit_registration_screen.dart
//hola
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/visit_service.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

class VisitRegistrationScreen extends StatefulWidget {
  const VisitRegistrationScreen({super.key});

  @override
  _VisitRegistrationScreenState createState() => _VisitRegistrationScreenState();
}

class _VisitRegistrationScreenState extends State<VisitRegistrationScreen> {
  final TextEditingController _cedulaController = TextEditingController();
  final TextEditingController _codigoCentroController = TextEditingController();
  final TextEditingController _motivoController = TextEditingController();
  final TextEditingController _comentarioController = TextEditingController();
  final TextEditingController _fechaController = TextEditingController();
  final TextEditingController _horaController = TextEditingController();
  final TextEditingController _latitudController = TextEditingController();
  final TextEditingController _longitudController = TextEditingController();

  File? _imageFile;
  String? _audioPath;
  FlutterSoundRecorder? _audioRecorder; // Ensure this is nullable for initialization checks

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _audioRecorder = FlutterSoundRecorder();
    _initRecorder();
  }

  Future<void> _initRecorder() async {
    // Check and request microphone permission
    if (await Permission.microphone.request().isGranted) {
      await _audioRecorder?.openRecorder(); // Correct method for opening the recorder
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permiso de micrófono denegado')),
      );
    }
  }

  @override
  void dispose() {
    _audioRecorder?.closeRecorder(); // Correct method for closing the recorder
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      }
    });
  }

  Future<void> _recordAudio() async {
    if (_audioRecorder?.isRecording ?? false) {
      _audioPath = await _audioRecorder?.stopRecorder();
    } else {
      await _audioRecorder?.startRecorder(toFile: 'audio.aac');
    }

    setState(() {});
  }

  Future<void> _registerVisit() async {
    if (_formKey.currentState!.validate() && _imageFile != null) {
      try {
        bool success = await VisitService().registerVisit(
          cedulaDirector: _cedulaController.text,
          codigoCentro: _codigoCentroController.text,
          motivo: _motivoController.text,
          fotoEvidencia: _imageFile!,
          comentario: _comentarioController.text,
          notaVoz: _audioPath ?? '',
          latitud: _latitudController.text,
          longitud: _longitudController.text,
          fecha: _fechaController.text,
          hora: _horaController.text,
        );

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Visita registrada exitosamente')),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error al registrar la visita')),
          );
        }
      } catch (e) {
        print('Error en _registerVisit: $e'); // Debugging line
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } else if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor capture una foto')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Visita'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _cedulaController,
                decoration: const InputDecoration(labelText: 'Cédula del Director'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la cédula del director';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _codigoCentroController,
                decoration: const InputDecoration(labelText: 'Código del Centro'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el código del centro';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _motivoController,
                decoration: const InputDecoration(labelText: 'Motivo de la Visita'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el motivo de la visita';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _comentarioController,
                decoration: const InputDecoration(labelText: 'Comentario'),
                maxLines: 3,
              ),
              TextFormField(
                controller: _fechaController,
                decoration: const InputDecoration(labelText: 'Fecha (yyyy-mm-dd)'),
                keyboardType: TextInputType.datetime,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la fecha';
                  }
                  // Add date validation here
                  final dateRegExp = RegExp(r'^\d{4}-\d{2}-\d{2}$'); // YYYY-MM-DD format
                  if (!dateRegExp.hasMatch(value)) {
                    return 'Formato de fecha incorrecto';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _horaController,
                decoration: const InputDecoration(labelText: 'Hora (HH:mm:ss)'),
                keyboardType: TextInputType.datetime,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la hora';
                  }
                  // Add time validation here
                  final timeRegExp = RegExp(r'^\d{2}:\d{2}:\d{2}$'); // HH:mm:ss format
                  if (!timeRegExp.hasMatch(value)) {
                    return 'Formato de hora incorrecto';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _latitudController,
                decoration: const InputDecoration(labelText: 'Latitud'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la latitud';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _longitudController,
                decoration: const InputDecoration(labelText: 'Longitud'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la longitud';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: const Text('Capturar Foto'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _recordAudio,
                    child: Text(_audioRecorder?.isRecording ?? false
                        ? 'Detener Grabación'
                        : 'Grabar Nota'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _registerVisit,
                child: const Text('Registrar Visita'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
