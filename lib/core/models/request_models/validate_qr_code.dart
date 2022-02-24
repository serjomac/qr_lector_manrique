class ValidateQrCodeRequest {
  ValidateQrCodeRequest({
        this.codigo,
    });

    String? codigo;

    factory ValidateQrCodeRequest.fromJson(Map<String, dynamic> json) => ValidateQrCodeRequest(
        codigo: json["codigo"]
    );

    Map<String, dynamic> toJson() => {
        "codigo": codigo
    };
}