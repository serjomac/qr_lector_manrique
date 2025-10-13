import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/register_manual_parking_response.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'manual_register_success_qr_controller.dart';

class ManualRegisterSuccessQrBottomSheet extends StatelessWidget {
  final RegisterManualParkingResponse registerResponse;

  const ManualRegisterSuccessQrBottomSheet({
    Key? key,
    required this.registerResponse,
  }) : super(key: key);

    @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GetBuilder<ManualRegisterSuccessQrController>(
      init: ManualRegisterSuccessQrController(registerResponse: registerResponse),
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
              // Barra superior con iconos
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

              // Contenido principal
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Código QR / Ticket WebView
                      RepaintBoundary(
                        key: controller.webViewKey,
                        child: SizedBox(
                          width: size.width * 0.9,
                          height: 620,
                          child: WebViewWidget(controller: controller.webViewController),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
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
