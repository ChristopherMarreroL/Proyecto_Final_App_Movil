import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/visit_service.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

class VisitRegistrationScreen extends StatefulWidget {
  const VisitRegistrationScreen({super.key});

  @override
  _VisitRegistrationScreenState createState() =>
      _VisitRegistrationScreenState();
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
  FlutterSoundRecorder? _audioRecorder;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _audioRecorder = FlutterSoundRecorder();
    _initRecorder();
  }

  Future<void> _initRecorder() async {
    if (await Permission.microphone.request().isGranted) {
      await _audioRecorder?.openRecorder();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permiso de micrófono denegado')),
      );
    }
  }

  @override
  void dispose() {
    _audioRecorder?.closeRecorder();
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

  Future<String?> _fileToBase64(File? file) async {
    if (file == null) return null;
    final bytes = await file.readAsBytes();
    return base64Encode(bytes);
  }

  Future<void> _registerVisit() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Convert image to Base64 if it exists
        final imageBase64 = _imageFile != null ? await _fileToBase64(_imageFile!) : '';

        // Convert audio to Base64 if it exists
        String? audioBase64;
        if (_audioPath != null) {
          final audioFile = File(_audioPath!);
          if (audioFile.existsSync()) {
            audioBase64 = await _fileToBase64(audioFile);
          }
        }

        // Adjust hour format if needed
        String formattedHour = _horaController.text;
        if (!formattedHour.contains(':')) {
          // Convert to standard format if needed (e.g., "6PM" to "18:00:00")
          final hour = int.parse(formattedHour.replaceAll(RegExp(r'\D'), ''));
          final isPm = formattedHour.toLowerCase().contains('pm');
          formattedHour = isPm ? '${hour + 12}:00:00' : '$hour:00:00';
        }

        bool success = await VisitService().registerVisit(
          cedulaDirector: _cedulaController.text,
          codigoCentro: _codigoCentroController.text,
          motivo: _motivoController.text,
          fotoEvidencia: imageBase64 ?? '', // Use Base64 string for the image
          comentario: _comentarioController.text,
          notaVoz: audioBase64 ?? '', // Use Base64 string for the audio
          latitud: _latitudController.text,
          longitud: _longitudController.text,
          fecha: _fechaController.text,
          hora: formattedHour,
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Visita'),
        backgroundColor: const Color(0xFF3949AB),
        centerTitle: true,
        elevation: 4,
        shadowColor: Colors.black45,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1A237E), Color(0xFF283593), Color(0xFF3949AB)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTextField(
                  controller: _cedulaController,
                  label: 'Cédula del Director',
                  icon: Icons.person,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese la cédula del director';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _codigoCentroController,
                  label: 'Código del Centro',
                  icon: Icons.business,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese el código del centro';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _motivoController,
                  label: 'Motivo de la Visita',
                  icon: Icons.assignment,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese el motivo de la visita';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _comentarioController,
                  label: 'Comentario',
                  icon: Icons.comment,
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _fechaController,
                  label: 'Fecha (yyyy-mm-dd)',
                  icon: Icons.calendar_today,
                  keyboardType: TextInputType.datetime,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese la fecha';
                    }
                    final dateRegExp =
                    RegExp(r'^\d{4}-\d{2}-\d{2}$'); // YYYY-MM-DD format
                    if (!dateRegExp.hasMatch(value)) {
                      return 'Formato de fecha incorrecto';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _horaController,
                  label: 'Hora (HH:mm:ss)',
                  icon: Icons.access_time,
                  keyboardType: TextInputType.datetime,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese la hora';
                    }
                    final timeRegExp =
                    RegExp(r'^\d{2}:\d{2}:\d{2}$'); // HH:mm:ss format
                    if (!timeRegExp.hasMatch(value)) {
                      return 'Formato de hora incorrecto';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _latitudController,
                  label: 'Latitud',
                  icon: Icons.gps_fixed,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese la latitud';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _longitudController,
                  label: 'Longitud',
                  icon: Icons.gps_fixed,
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildActionButton(
                      context,
                      label: 'Capturar Foto',
                      icon: Icons.camera_alt,
                      onPressed: _pickImage,
                    ),
                    _buildActionButton(
                      context,
                      label: _audioRecorder?.isRecording ?? false
                          ? 'Detener Grabación'
                          : 'Grabar Nota',
                      icon: Icons.mic,
                      onPressed: _recordAudio,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _registerVisit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF57C00),
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Registrar Visita',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF3949AB)),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Colors.black12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Color(0xFF3949AB)),
        ),
      ),
    );
  }

  Widget _buildActionButton(
      BuildContext context, {
        required String label,
        required IconData icon,
        required VoidCallback onPressed,
      }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white),
      label: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF3949AB),
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        elevation: 5,
        shadowColor: Colors.black54,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
