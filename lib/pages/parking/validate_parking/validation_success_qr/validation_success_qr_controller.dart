import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ValidationSuccessQrController extends GetxController {
  final String url;
  late WebViewController webViewController;
  final GlobalKey webViewKey = GlobalKey();

  ValidationSuccessQrController({required this.url});

  @override
  void onInit() {
    super.onInit();
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(url));
  }

  void goBack() {
    Get.back();
  }

  Future<void> shareTicket() async {
    try {
      // Capturar screenshot del WebView
      RenderRepaintBoundary boundary = webViewKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      // Compartir la imagen
      await Share.shareXFiles(
        [XFile.fromData(pngBytes, name: 'ticket_validacion.png', mimeType: 'image/png')],
        text: 'Ticket de validación de estacionamiento',
      );
    } catch (e) {
      print('Error al compartir el ticket: $e');
      // Mostrar mensaje de error al usuario si es necesario
      Get.snackbar(
        'Error',
        'No se pudo compartir el ticket',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}