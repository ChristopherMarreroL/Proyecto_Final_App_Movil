class School {
  final String codigo;
  final String nombre;
  final String direccion;
  final String telefono;

  School({
    required this.codigo,
    required this.nombre,
    required this.direccion,
    required this.telefono,
  });

  factory School.fromJson(Map<String, dynamic> json) {
    return School(
      codigo: json['codigo'],
      nombre: json['nombre'],
      direccion: json['direccion'],
      telefono: json['telefono'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'codigo': codigo,
      'nombre': nombre,
      'direccion': direccion,
      'telefono': telefono,
    };
  }
}
