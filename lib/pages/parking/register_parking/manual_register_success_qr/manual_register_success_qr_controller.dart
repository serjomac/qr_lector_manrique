import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/register_manual_parking_response.dart';
import 'package:qr_scaner_manrique/BRACore/models/user_data.dart';
import 'package:share_plus/share_plus.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ManualRegisterSuccessQrController extends GetxController {
  final RegisterManualParkingResponse registerResponse;

  ManualRegisterSuccessQrController({required this.registerResponse});

  late final WebViewController webViewController;
  RxBool isLoading = true.obs;

  // GlobalKey para capturar el WebView
  final GlobalKey webViewKey = GlobalKey();

  @override
  void onInit() {
    super.onInit();
    _initializeWebView();
  }

  void _initializeWebView() {
    // Inicializar el WebViewController
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted);
    webViewController.loadRequest(Uri.parse(registerResponse.url));
  }

  void goBack() {
    Get.back(); // Cerrar bottomSheet
    Get.back(); // Volver a la pantalla anterior
  }

  void shareTicket() async {
    try {
      await Future.delayed(Duration(milliseconds: 1000)); 
      // loadingShare.value = true;
      RenderRepaintBoundary boundary =
          webViewKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      var image = await boundary.toImage(pixelRatio: 3);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();
      final tempDir = await getTemporaryDirectory();
      final file = await new File('${tempDir.path}/image.png').create();
      await file.writeAsBytes(pngBytes);
      final fileTmp = XFile(tempDir.path, name: '');
      // final res = await Share.shareXFiles([fileTmp],
      //     subject: UserData.sharedInstance.placeSelected!.nombre!);
      final res = await Share.shareXFiles(
          [XFile('${tempDir.path}/image.png', name: 'image.png')],);
      // loadingShare.value = false;
      if (res.status == ShareResultStatus.success) {
        log('La imagen ha sido compartida');
      } else {
        log('La acción de compartir ha sido cancelada');
      }
      // Limpiar archivo temporal
      await file.delete();
    } catch (e) {
      print('Error en shareTicket: $e');
    }
  }
}
