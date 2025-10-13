import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_scaner_manrique/BRACore/routes/app_routes.dart';
import 'package:qr_scaner_manrique/pages/schools_page/controller/schools_conttroller.dart';

class SchoolsPage extends StatelessWidget {
  const SchoolsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: GetBuilder<SchoolsController>(
          builder: (_) {
            return Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Seleccione un aula',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                Obx(() {
                  if (!_.loadingAreaList.value) {
                    return Expanded(
                      child: ListView.builder(
                          itemCount: _.areaList.length,
                          itemBuilder: (c, i) {
                            return Column(
                              children: [
                                ListTile(
                                    title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(_.areaList[i].area ?? ''),
                                        const Icon(Icons.school)
                                      ],
                                    ),
                                    onTap: () {
                                      _.selectedArea = _.areaList[i];
                                      Get.offAllNamed(AppRoutes.QR_SCANNER);
                                    }),
                                Container(
                                  margin: const EdgeInsets.only(left: 15),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          style: BorderStyle.solid,
                                          color: Colors.grey,
                                          width: 0.2)),
                                )
                              ],
                            );
                          }),
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                })
              ],
            );
          },
        ),
      ),
    );
  }
}
