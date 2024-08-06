import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _cedulaController = TextEditingController();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _fechaNacimientoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  void _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        String cedula = _cedulaController.text;
        String nombre = _nombreController.text;
        String apellido = _apellidoController.text;
        String correo = _emailController.text;
        String telefono = _telefonoController.text;
        String fechaNacimiento = _fechaNacimientoController.text;
        String clave = _passwordController.text;

        // Convert the date to the expected format (yyyyMMdd)
        String formattedDate = fechaNacimiento.replaceAll('-', '');

        // Use named parameters for clarity
        bool isRegistered = await AuthService().register(
          cedula: cedula,
          nombre: nombre,
          apellido: apellido,
          correo: correo,
          telefono: telefono,
          fechaNacimiento: formattedDate,
          clave: clave,
        );

        if (isRegistered) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registro exitoso')),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error al registrarse')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _cedulaController,
                decoration: const InputDecoration(labelText: 'Cédula'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese su cédula';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese su nombre';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _apellidoController,
                decoration: const InputDecoration(labelText: 'Apellido'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese su apellido';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Correo'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese su correo';
                  }
                  // Add email validation
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    return 'Ingrese un correo válido';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _telefonoController,
                decoration: const InputDecoration(labelText: 'Teléfono'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese su teléfono';
                  }
                  // Add phone number validation
                  if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                    return 'Ingrese un número de teléfono válido';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _fechaNacimientoController,
                decoration: const InputDecoration(labelText: 'Fecha de Nacimiento (yyyy-mm-dd)'),
                keyboardType: TextInputType.datetime,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese su fecha de nacimiento';
                  }
                  // Validate the date format
                  final dateRegExp = RegExp(r'^\d{4}-\d{2}-\d{2}$'); // YYYY-MM-DD format
                  if (!dateRegExp.hasMatch(value)) {
                    return 'Formato de fecha incorrecto';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese su contraseña';
                  }
                  // Add password length validation
                  if (value.length < 6) {
                    return 'La contraseña debe tener al menos 6 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              if (_isLoading)
                const CircularProgressIndicator()
              else
                ElevatedButton(
                  onPressed: _register,
                  child: const Text('Registrarse'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
