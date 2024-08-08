import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HoroscopeScreen extends StatefulWidget {
  const HoroscopeScreen({super.key});

  @override
  _HoroscopeScreenState createState() => _HoroscopeScreenState();
}

class _HoroscopeScreenState extends State<HoroscopeScreen> {
  final List<String> _zodiacSigns = [
    'Aries',
    'Taurus',
    'Gemini',
    'Cancer',
    'Leo',
    'Virgo',
    'Libra',
    'Scorpio',
    'Sagittarius',
    'Capricorn',
    'Aquarius',
    'Pisces'
  ];

  final List<String> _days = ['TODAY', 'TOMORROW', 'YESTERDAY'];

  // Languages supported by LibreTranslate
  final List<Map<String, String>> _languages = [
    {'code': 'es', 'name': 'Spanish'},
    {'code': 'fr', 'name': 'French'},
    {'code': 'de', 'name': 'German'},
    {'code': 'it', 'name': 'Italian'},
    {'code': 'pt', 'name': 'Portuguese'},
    {'code': 'zh', 'name': 'Chinese'},
  ];

  String? _selectedSign;
  String? _selectedDay;
  String? _selectedLanguage;
  DateTime? _selectedDate;
  String? _horoscopeMessage;
  String? _translatedMessage;
  bool _isLoading = false;
  String? _errorMessage;

  // Fetch horoscope based on selected sign and day
  Future<void> _fetchHoroscope(String sign, String day) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _horoscopeMessage = null;
      _translatedMessage = null; // Reset translated message
    });

    final url =
        'https://horoscope-app-api.vercel.app/api/v1/get-horoscope/daily?sign=$sign&day=$day';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _horoscopeMessage = data['data']['horoscope_data'];
        });
      } else {
        setState(() {
          _errorMessage = 'Error fetching horoscope: ${response.reasonPhrase}';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error connecting to the server: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Translate the horoscope message using LibreTranslate
  Future<void> _translateHoroscope(String message, String targetLang) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _translatedMessage = null;
    });

    final url = 'https://libretranslate.de/translate';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'q': message,
          'source': 'en',
          'target': targetLang,
          'format': 'text'
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _translatedMessage = data['translatedText'];
        });
      } else {
        setState(() {
          _errorMessage = 'Error translating message: ${response.reasonPhrase}';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error connecting to the translation server: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Function to build date picker dialog
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _selectedDay =
            _selectedDate!.toIso8601String().split('T').first; // Format as YYYY-MM-DD
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Horóscopo Diario'),
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
            _buildDropdown(
              hint: 'Seleccione su signo zodiacal',
              value: _selectedSign,
              items: _zodiacSigns,
              onChanged: (newValue) {
                setState(() {
                  _selectedSign = newValue;
                });
              },
            ),
            const SizedBox(height: 20),
            _buildDropdown(
              hint: 'Seleccione el día',
              value: _selectedDay,
              items: _days,
              onChanged: (newValue) {
                setState(() {
                  _selectedDay = newValue;
                  _selectedDate = null; // Reset date when selecting a day
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_selectedSign != null && _selectedDay != null) {
                  _fetchHoroscope(_selectedSign!, _selectedDay!);
                } else if (_selectedSign != null && _selectedDate != null) {
                  _fetchHoroscope(
                      _selectedSign!, _selectedDate!.toIso8601String().split('T').first);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Seleccione un signo y un día o una fecha')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xFFF57C00),
                padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 24.0),
                elevation: 5,
                shadowColor: Colors.black54,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Obtener Horóscopo', style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 20),
            if (_isLoading)
              const CircularProgressIndicator(),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            if (_horoscopeMessage != null) _buildHoroscopeSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.black12),
      ),
      child: DropdownButton<String>(
        hint: Text(hint),
        value: value,
        icon: const Icon(Icons.arrow_drop_down, color: Colors.black54),
        iconSize: 24,
        elevation: 16,
        isExpanded: true,
        underline: Container(),
        style: const TextStyle(color: Colors.black87, fontSize: 16),
        onChanged: onChanged,
        items: items.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildHoroscopeSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          children: [
            Text(
              _horoscopeMessage!,
              style: const TextStyle(fontSize: 18, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            _buildDropdown(
              hint: 'Seleccione un idioma para traducir',
              value: _selectedLanguage,
              items: _languages.map((lang) => lang['name']!).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedLanguage = _languages
                      .firstWhere((lang) => lang['name'] == newValue)['code'];
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _selectedLanguage != null
                  ? () => _translateHoroscope(_horoscopeMessage!, _selectedLanguage!)
                  : null,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xFFF57C00),
                padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 24.0),
                elevation: 5,
                shadowColor: Colors.black54,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Traducir Horóscopo', style: TextStyle(fontSize: 18)),
            ),
            if (_translatedMessage != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  _translatedMessage!,
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
