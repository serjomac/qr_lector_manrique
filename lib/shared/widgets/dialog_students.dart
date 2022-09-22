// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:qr_scaner_manrique/core/models/response_models/validation_qr_response.dart';
import 'package:qr_scaner_manrique/utils/constants/constants.dart';
import 'package:checkbox_grouped/checkbox_grouped.dart';
import 'package:get/get.dart';

class DialogStudents extends StatelessWidget {
  final String titulo;
  final double titleSize;
  final String mensaje;
  final String tipo;
  final List<Estudiante> studentsList;
  final GroupController controller;
  final List<Estudiante> valueCheck;
  final List<String> itemsTitle;
  final VoidCallback onTapAcept;
  final RxBool seleccionarTodo;

  const DialogStudents({
    required this.titulo,
    this.titleSize = 25.0,
    required this.mensaje,
    required this.tipo,
    required this.studentsList,
    required this.controller,
    required this.valueCheck,
    required this.itemsTitle,
    required this.onTapAcept,
    required this.seleccionarTodo,
  });

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    final TextStyle _tituloEstilo = TextStyle(
        fontWeight: FontWeight.bold,
        color: this.tipo == Constants.EXITO ? Colors.green : Colors.red,
        fontSize: this.titleSize);
    final TextStyle _textoEstilo = TextStyle(
        fontWeight: FontWeight.w300, color: Colors.black, fontSize: 15.0);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: SingleChildScrollView(
        // physics: NeverScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: double.infinity,
                height: _size.height * 0.10,
                child: tipo == Constants.EXITO
                    ? const Image(
                        image: AssetImage("assets/images/sucess.png"),
                        alignment: Alignment.center,
                        fit: BoxFit.contain)
                    : const Image(
                        image: AssetImage("assets/images/error.png"),
                        alignment: Alignment.center,
                        fit: BoxFit.contain),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                this.titulo,
                textAlign: TextAlign.center,
                style: _tituloEstilo,
              ),
              SizedBox(height: _size.height * 0.02),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 0.3, color: Colors.grey)),
              ),
              SizedBox(height: 10),
              Text(
                'Hijos por retirar',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 10),
              Obx(() {
                return CheckboxListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(60)),
                  controlAffinity: ListTileControlAffinity.leading,
                  selected: false,
                  title: Text('Seleccionar todo'),
                  value: seleccionarTodo.value,
                  onChanged: (value) => {
                    seleccionarTodo.value = value!,
                    if (value)
                      {controller.selectAll()}
                    else
                      {controller.deselectAll()}
                  },
                );
              }),
              SimpleGroupedCheckbox(
                values: this.valueCheck,
                groupStyle: GroupStyle(itemTitleStyle: TextStyle(fontSize: 15)),
                controller: this.controller,
                itemsTitle: this.itemsTitle,
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 0.3, color: Colors.grey)),
              ),
              SizedBox(height: 20),
              InkWell(
                onTap: onTapAcept,
                child: Container(
                  height: 50,
                  width: 150,
                  decoration: BoxDecoration(
                    color: tipo == Constants.EXITO
                        ? Colors.green
                        : Color(0xFFED1B30),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      'Aceptar',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              InkWell(
                onTap: () {
                  Get.back();
                },
                child: Center(
                  child: Text(
                    'Cancelar',
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
