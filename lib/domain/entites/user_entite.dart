import 'package:equatable/equatable.dart';

class UserEntite extends Equatable {
  final int? idUsuarioAdmin;
  final String? nombres;
  final String? apellidos;
  final String? celular;
  final String? correo;
  final String? usuario;
  final String? tipo;
  final String? tokenFcm;
  final String? estado;
  final String? tokenG;

  const UserEntite({
    required this.idUsuarioAdmin,
    required this.nombres,
    required this.apellidos,
    required this.celular,
    required this.correo,
    required this.usuario,
    required this.tipo,
    required this.tokenFcm,
    required this.estado,
    required this.tokenG,
  });

  @override
  List<Object?> get props => [
        idUsuarioAdmin,
        nombres,
        apellidos,
        celular,
        correo,
        usuario,
        tipo,
        tokenFcm,
        estado,
        tokenG,
      ];
}
