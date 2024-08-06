class Incident {
  final String id;
  final String titulo;
  final String descripcion;
  final String fecha;
  final String audioPath;
  final String fotoPath;
  final String centro;
  final String regional;
  final String distrito;

  Incident({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.fecha,
    required this.audioPath,
    required this.fotoPath,
    required this.centro,
    required this.regional,
    required this.distrito,
  });

  factory Incident.fromJson(Map<String, dynamic> json) {
    return Incident(
      id: json['id'],
      titulo: json['titulo'],
      descripcion: json['descripcion'],
      fecha: json['fecha'],
      audioPath: json['audio'],
      fotoPath: json['foto'],
      centro: json['centro'],
      regional: json['regional'],
      distrito: json['distrito'],
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
