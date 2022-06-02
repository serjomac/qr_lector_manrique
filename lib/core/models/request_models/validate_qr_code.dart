class ValidateQrCodeRequest {
  ValidateQrCodeRequest({
        this.codigo,
        this.idArea,
    });

    String? codigo;
    String? idArea;

    factory ValidateQrCodeRequest.fromJson(Map<String, dynamic> json) => ValidateQrCodeRequest(
        codigo: json["codigo"],
        idArea: json["id_area"]
    );

    Map<String, dynamic> toJson() => {
        "codigo": codigo,
        "id_area": idArea
    };
}