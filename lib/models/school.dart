// lib/models/school.dart

class School {
  final String idx;
  final String codigo;
  final String nombre;
  final String coordenadas;
  final String distrito;
  final String regional;
  final String dDmunicipal;

  School({
    required this.idx,
    required this.codigo,
    required this.nombre,
    required this.coordenadas,
    required this.distrito,
    required this.regional,
    required this.dDmunicipal,
  });

  factory School.fromJson(Map<String, dynamic> json) {
    return School(
      idx: json['idx'] ?? '',
      codigo: json['codigo'] ?? '',
      nombre: json['nombre'] ?? '',
      coordenadas: json['coordenadas'] ?? '',
      distrito: json['distrito'] ?? '',
      regional: json['regional'] ?? '',
      dDmunicipal: json['d_dmunicipal'] ?? '',
    );
  }
}
