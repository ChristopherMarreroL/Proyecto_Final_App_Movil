// login_screen.dart

import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _cedulaController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        String cedula = _cedulaController.text;
        String password = _passwordController.text;

        // Use named parameters when calling login
        Map<String, dynamic>? userData = await AuthService().login(
          cedula: cedula,
          password: password,
        );

        if (userData != null && userData['exito']) {
          // Save the token for later use
          String token = userData['datos']['token'];
          // Store the token securely, for example using shared_preferences
          await AuthService().saveToken(token);

          Navigator.pushReplacementNamed(context, '/main_menu');
        } else {
          String message = userData?['mensaje'] ?? 'Credenciales incorrectas';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
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

  void _navigateToRegister() {
    Navigator.pushNamed(context, '/register');  // Ensure this route is correct
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio de Sesión'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese su contraseña';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              if (_isLoading)
                const CircularProgressIndicator()
              else
                ElevatedButton(
                  onPressed: _login,
                  child: const Text('Iniciar Sesión'),
                ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: _navigateToRegister,  // Make sure this calls the right function
                child: const Text('Registrarse'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
