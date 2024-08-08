// main.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/login_screen.dart';
import 'screens/main_menu_screen.dart';
import 'screens/incidents/incidents_list_screen.dart';
import 'screens/incidents/incident_registration_screen.dart';
import 'screens/visits/visit_registration_screen.dart';
import 'screens/visits/visits_list_screen.dart';
import 'screens/visits/visits_map_screen.dart';
import 'screens/consultation/school_by_code_screen.dart';
import 'screens/consultation/director_by_cedula_screen.dart';
import 'screens/extra/about_screen.dart';
import 'screens/extra/security_screen.dart';
import 'screens/extra/visit_types_screen.dart';
import 'screens/extra/news_screen.dart';
import 'screens/extra/weather_screen.dart';
import 'screens/extra/horoscope_screen.dart';
import 'screens/registration_screen.dart';  // Make sure this import is present

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MINERD App',
      theme: ThemeData(
        primaryColor: const Color(0xFF1A237E), // Deep Purple for a modern look
        hintColor: const Color(0xFFF57C00), // Orange accent for highlights
        scaffoldBackgroundColor: const Color(0xFFF5F5F5), // Light gray for the background
        appBarTheme: const AppBarTheme(
          elevation: 4, // Adds shadow to AppBar
          shadowColor: Colors.black54,
          backgroundColor: Color(0xFF1A237E),
          foregroundColor: Colors.white,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          bodyMedium: TextStyle(
            fontSize: 16.0,
            height: 1.5, // Line height for better readability
            color: Colors.black54,
          ),
        ),
        buttonTheme: const ButtonThemeData(
          buttonColor: Color(0xFFF57C00),
          textTheme: ButtonTextTheme.primary,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 3,
            shadowColor: Colors.black45,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Colors.black12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Color(0xFF1A237E)),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/main_menu': (context) => const MainMenuScreen(),
        '/incidents_list': (context) => const IncidentsListScreen(),
        '/incident_registration': (context) => const IncidentRegistrationScreen(),
        '/visits_list': (context) => const VisitsListScreen(),
        '/visit_registration': (context) => const VisitRegistrationScreen(),
        '/school_by_code': (context) => const SchoolByCodeScreen(),
        '/director_by_cedula': (context) => const DirectorByCedulaScreen(),
        '/about': (context) => const AboutScreen(),
        '/security': (context) => const SecurityScreen(),
        '/visit_types': (context) => const VisitTypesScreen(),
        '/news': (context) => const NewsScreen(),
        '/weather': (context) => const WeatherScreen(),
        '/horoscope': (context) => const HoroscopeScreen(),
        '/register': (context) => const RegisterScreen(), // Add this line
      },
    );
  }
}
