class AuthLoginModel {
  String? id;
  String? nombres;
  String? usuario;
  String? correo;

  AuthLoginModel({this.id, this.nombres, this.usuario, this.correo});

  AuthLoginModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nombres = json['nombres'];
    usuario = json['usuario'];
    correo = json['correo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nombres'] = nombres;
    data['usuario'] = usuario;
    data['correo'] = correo;
    return data;
  }
}
