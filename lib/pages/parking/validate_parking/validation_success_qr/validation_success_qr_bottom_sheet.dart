import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'validation_success_qr_controller.dart';

class ValidationSuccessQrBottomSheet extends StatelessWidget {
  final String url;

  const ValidationSuccessQrBottomSheet({
    Key? key,
    required this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GetBuilder<ValidationSuccessQrController>(
      init: ValidationSuccessQrController(url: url),
      builder: (controller) {
        return Container(
          margin: EdgeInsets.only(
            top: size.height * 0.05,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              // Header with close button
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Iconos en la esquina superior derecha
                  Row(
                    children: [
                      // Icono Compartir
                      IconButton(
                        onPressed: controller.shareTicket,
                        icon: const Icon(
                          Icons.share,
                          color: Color(0xFFEB472A),
                          size: 24,
                        ),
                        tooltip: 'Compartir ticket',
                      ),
              
                      // Icono Cerrar
                      IconButton(
                        onPressed: controller.goBack,
                        icon: const Icon(
                          Icons.close,
                          color: Color(0xFF666666),
                          size: 24,
                        ),
                        tooltip: 'Cerrar',
                      ),
                    ],
                  ),
                ],
              ),
              // Web content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Center(
                    child: RepaintBoundary(
                      key: controller.webViewKey,
                      child: SizedBox(
                        width: size.width * 0.95,
                        child: WebViewWidget(controller: controller.webViewController),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
