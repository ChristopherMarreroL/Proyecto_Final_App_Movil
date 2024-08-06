class Video {
  final String id;
  final String fecha;
  final String titulo;
  final String descripcion;
  final String link;

  Video({
    required this.id,
    required this.fecha,
    required this.titulo,
    required this.descripcion,
    required this.link,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      id: json['id'],
      fecha: json['fecha'],
      titulo: json['titulo'],
      descripcion: json['descripcion'],
      link: json['link'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fecha': fecha,
      'titulo': titulo,
      'descripcion': descripcion,
      'link': link,
    };
  }
}
