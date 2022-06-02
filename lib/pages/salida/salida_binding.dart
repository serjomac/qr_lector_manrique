import 'package:get/get.dart';
import 'package:qr_scaner_manrique/pages/salida/controller/salida_controller.dart';

class SalidaBinding implements Bindings {

  @override
  void dependencies() {
    Get.lazyPut<SalidaController>(() => SalidaController());
  }
  
}