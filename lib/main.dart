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
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(fontSize: 16.0),
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
        '/visits_map': (context) => const VisitsMapScreen(),
        '/school_by_code': (context) => const SchoolByCodeScreen(),
        '/director_by_cedula': (context) => const DirectorByCedulaScreen(),
        '/about': (context) => const AboutScreen(),
        '/security': (context) => const SecurityScreen(),
        '/visit_types': (context) => const VisitTypesScreen(),
        '/news': (context) => const NewsScreen(),
        '/weather': (context) => const WeatherScreen(),
        '/horoscope': (context) => const HoroscopeScreen(),
        '/register': (context) => const RegisterScreen(),  // Add this line
      },
    );
  }
}
