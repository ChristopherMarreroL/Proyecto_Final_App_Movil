// lib/models/visit.dart

class Visit {
  final String id;
  final String cedulaDirector;
  final String codigoCentro;
  final String motivo;
  final String comentario;
  final String? notaVoz;
  final String? fotoEvidencia;
  final String latitud;
  final String longitud;
  final String fecha;
  final String hora;

  Visit({
    required this.id,
    required this.cedulaDirector,
    required this.codigoCentro,
    required this.motivo,
    required this.comentario,
    this.notaVoz,
    this.fotoEvidencia,
    required this.latitud,
    required this.longitud,
    required this.fecha,
    required this.hora,
  });

  factory Visit.fromJson(Map<String, dynamic> json) {
    return Visit(
      id: json['id'],
      cedulaDirector: json['cedula_director'],
      codigoCentro: json['codigo_centro'],
      motivo: json['motivo'],
      comentario: json['comentario'],
      notaVoz: json['nota_voz'],
      fotoEvidencia: json['foto_evidencia'],
      latitud: json['latitud'],
      longitud: json['longitud'],
      fecha: json['fecha'],
      hora: json['hora'],
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
