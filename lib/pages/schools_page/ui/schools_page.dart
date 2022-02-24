import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_scaner_manrique/core/routes/app_routes.dart';
import 'package:qr_scaner_manrique/pages/schools_page/controller/schools_conttroller.dart';

class SchoolsPage extends StatelessWidget {
  const SchoolsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<SchoolsController>(
        builder: (_) {
            return ListView.builder(
              itemCount: 5,
              itemBuilder: (c, i) {
              return ListTile(
                title: Text('Hola'),
                onTap: () {
                  Get.offAllNamed(AppRoutes.QR_SCANNER);
                },
              );
            });
        },),
    );
  }
}