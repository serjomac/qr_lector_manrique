
// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:qr_scaner_manrique/utils/constants/constants.dart';

class DialogSuccessError extends StatelessWidget {
  final String titulo;
  final double titleSize;
  final String mensaje;
  final String tipo;

  const DialogSuccessError(
      {required this.titulo,
      this.titleSize = 25.0,
      required this.mensaje,
      required this.tipo});

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    final TextStyle _tituloEstilo = TextStyle(
        fontWeight: FontWeight.bold,
        color: this.tipo == Constants.EXITO
            ? Colors.green
            : Colors.red,
        fontSize: this.titleSize);
    final TextStyle _textoEstilo = TextStyle(
        fontWeight: FontWeight.w300,
        color: Colors.black,
        fontSize: 15.0);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
          //height: _size.height * 0.7,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 10,),
                SizedBox(
                  width: double.infinity,
                  height: _size.height * 0.23,
                  child: tipo == Constants.EXITO
                      ? const Image(image: AssetImage("assets/images/sucess.png"),
                          alignment: Alignment.center,
                          fit: BoxFit.contain)
                      : const Image(image: AssetImage("assets/images/error.png"),
                          alignment: Alignment.center,
                          fit: BoxFit.contain),
                ),
                SizedBox(height: 5,),
                Text(
                  this.titulo,
                  textAlign: TextAlign.center,
                  style: _tituloEstilo,
                ),
                SizedBox(height: _size.height * 0.02),
                Text(
                  this.mensaje,
                  textAlign: TextAlign.center,
                  style: _textoEstilo,
                ),
                SizedBox(height: 5),Container(),
                SizedBox(height: 15),
                InkWell(
                  onTap: () {
                     Navigator.pop(context);
                  },
                  child: Container(
                    height: 50,
                    width: 150,
                    decoration: BoxDecoration(
                      color: tipo == Constants.EXITO ? Colors.green : Color(0xFFED1B30),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(child: Text('Aceptar', style: TextStyle(color: Colors.white),),),
                  ),
                ),
                SizedBox(height: 10,),
                ],
            ),
          ),
        ),
      ),
    );
  }
}
