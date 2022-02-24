import 'package:get/get.dart';
import 'package:qr_scaner_manrique/pages/login/controller/login_controller.dart';

class LoginBinding implements Bindings {

  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController());
  }
  
}