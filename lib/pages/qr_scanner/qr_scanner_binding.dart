import 'package:get/get.dart';
import 'package:qr_scaner_manrique/pages/qr_scanner/controller/qr_scanner_controller.dart';

class QrScannerBinding implements Bindings {

  @override
  void dependencies() {
    Get.lazyPut<QrScannerController>(() => QrScannerController());
  }
  
}