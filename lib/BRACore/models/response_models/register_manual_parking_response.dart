class RegisterManualParkingResponse {
  final String status;
  final String idIngreso;
  final String url;

  RegisterManualParkingResponse({
    required this.status,
    required this.idIngreso,
    required this.url,
  });

  factory RegisterManualParkingResponse.fromJson(Map<String, dynamic> json) {
    return RegisterManualParkingResponse(
      status: json['status'] as String,
      idIngreso: json['id_ingreso'] as String,
      url: json['url'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'id_ingreso': idIngreso,
      'url': url,
    };
  }

  @override
  String toString() {
    return 'RegisterManualParkingResponse(status: $status, idIngreso: $idIngreso, url: $url)';
  }
}