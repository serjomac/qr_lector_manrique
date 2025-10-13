class Representative {
  final String? id;
  final String nombre;
  final String ci;
  final int? studentCount;

  Representative({
    this.id,
    required this.nombre,
    required this.ci,
    this.studentCount,
  });

  factory Representative.fromJson(Map<String, dynamic> json) {
    return Representative(
      id: json['id']?.toString(),
      nombre: json['nombre'] ?? '',
      ci: json['ci'] ?? '',
      studentCount: json['cantidad_estudiantes']?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'ci': ci,
      'cantidad_estudiantes': studentCount,
    };
  }

  String get name => nombre;
  int get count => studentCount ?? 0;
}