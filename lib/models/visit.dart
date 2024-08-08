// lib/models/visit.dart

class Visit {
  final String id;
  final String cedulaDirector;
  final String codigoCentro;
  final String motivo;
  final String? comentario; // Make nullable if not always present
  final String? notaVoz; // Nullable
  final String? fotoEvidencia; // Nullable
  final String latitud;
  final String longitud;
  final String fecha;
  final String hora;

  Visit({
    required this.id,
    required this.cedulaDirector,
    required this.codigoCentro,
    required this.motivo,
    this.comentario,
    this.notaVoz,
    this.fotoEvidencia,
    required this.latitud,
    required this.longitud,
    required this.fecha,
    required this.hora,
  });

  factory Visit.fromJson(Map<String, dynamic> json) {
    return Visit(
      id: json['id'] ?? '', // Use a default value if null
      cedulaDirector: json['cedula_director'] ?? 'N/A', // Default if null
      codigoCentro: json['codigo_centro'] ?? 'N/A', // Default if null
      motivo: json['motivo'] ?? 'N/A', // Default if null
      comentario: json['comentario'], // Nullable
      notaVoz: json['nota_voz'], // Nullable
      fotoEvidencia: json['foto_evidencia'], // Nullable
      latitud: json['latitud'] ?? '0.0', // Default if null
      longitud: json['longitud'] ?? '0.0', // Default if null
      fecha: json['fecha'] ?? 'N/A', // Default if null
      hora: json['hora'] ?? 'N/A', // Default if null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cedula_director': cedulaDirector,
      'codigo_centro': codigoCentro,
      'motivo': motivo,
      'comentario': comentario,
      'nota_voz': notaVoz,
      'foto_evidencia': fotoEvidencia,
      'latitud': latitud,
      'longitud': longitud,
      'fecha': fecha,
      'hora': hora,
    };
  }
}
