import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_scaner_manrique/pages/salida/controller/salida_controller.dart';
import 'package:qr_scaner_manrique/utils/constants/constants.dart';

class SalidaPage extends StatelessWidget {
  const SalidaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetBuilder<SalidaController>(builder: (_) {
        return Scaffold(
          body: Stack(
            children: [
              IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(Icons.arrow_back_ios_new)),
              Container(
                margin: EdgeInsets.only(top: 15),
                child: Column(
                  children: [
                    const Text(
                      'Lista de padres',
                      style: TextStyle(fontSize: 17),
                    ),
                    Obx(() {
                      if (!_.loagindSalida.value) {
                        return Expanded(
                          child: RefreshIndicator(
                            onRefresh: () => _.getSalida(
                                idArea: _.areaSelected!.id!, tipo: 'P'),
                            child: ListView.separated(
                                separatorBuilder: (context, index) {
                                  return Container(
                                      height: 1,
                                      decoration:
                                          BoxDecoration(color: Colors.grey));
                                },
                                padding:
                                    const EdgeInsets.only(top: 15, bottom: 20),
                                itemCount: _.parentList.length,
                                itemBuilder: (c, i) {
                                  return ListTile(
                                    onTap: () {
                                      _.showModalStudentsList(
                                          'Lista de hijos por retirar',
                                          Constants.EXITO,
                                          '',
                                          _.parentList[i].hijos!,
                                          _.getNombreHijos(_.parentList[i]),
                                          _.parentList[i].hijos!,
                                          _.controller, () {
                                        _.marcarSalida(_.parentList[i]);
                                      });
                                    },
                                    title: Container(
                                      margin: EdgeInsets.only(top: 5),
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      height: 60,
                                      width: 60,
                                      decoration: BoxDecoration(
                                          color: Colors.blueGrey,
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            _.parentList[i].padre ?? '',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                _.parentList[i].hijos != null
                                                    ? _.parentList[i].hijos!
                                                        .length
                                                        .toString()
                                                    : '0',
                                                style: TextStyle(
                                                    fontSize: 23,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const Image(
                                                image: AssetImage(
                                                    'assets/images/student.png'),
                                                width: 35,
                                                height: 35,
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        );
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    })
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
