import 'package:get/get.dart';
import 'package:qr_scaner_manrique/pages/schools_page/controller/schools_conttroller.dart';

class SchoolBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SchoolsController>(() => SchoolsController());
  }
  
}