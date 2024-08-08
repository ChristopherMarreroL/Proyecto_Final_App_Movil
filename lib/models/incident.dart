// lib/models/incident.dart

class Incident {
  final String id;
  final String titulo;
  final String descripcion;
  final String fecha;
  final String? audioPath; // Make nullable
  final String? fotoPath; // Make nullable
  final String centro;
  final String regional;
  final String distrito;

  Incident({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.fecha,
    this.audioPath, // Nullable
    this.fotoPath, // Nullable
    required this.centro,
    required this.regional,
    required this.distrito,
  });

  factory Incident.fromJson(Map<String, dynamic> json) {
    return Incident(
      id: json['id'] ?? '', // Provide default value
      titulo: json['titulo'] ?? 'No Title', // Provide default value
      descripcion: json['descripcion'] ?? 'No Description', // Provide default value
      fecha: json['fecha'] ?? 'Unknown Date', // Provide default value
      audioPath: json['audio'], // Nullable
      fotoPath: json['foto'], // Nullable
      centro: json['centro'] ?? 'Unknown Center', // Provide default value
      regional: json['regional'] ?? 'Unknown Regional', // Provide default value
      distrito: json['distrito'] ?? 'Unknown District', // Provide default value
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'descripcion': descripcion,
      'fecha': fecha,
      'audio': audioPath,
      'foto': fotoPath,
      'centro': centro,
      'regional': regional,
      'distrito': distrito,
    };
  }
}
