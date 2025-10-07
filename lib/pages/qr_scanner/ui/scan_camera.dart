import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_scaner_manrique/BRACore/extensions/own-color-scheme.dart';
import 'package:qr_scaner_manrique/utils/AppLocations.dart';

class ScanCamera extends StatefulWidget {
  const ScanCamera({Key? key}) : super(key: key);
  static const routeName = 'scanPage';

  @override
  _ScanCameraState createState() => _ScanCameraState();
}

class _ScanCameraState extends State<ScanCamera> {
  QRViewController? controller;
  bool scanCode = false;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.pauseCamera();
      controller!.resumeCamera();
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stringsLoctaion = AppLocalizationsGenerator.appLocalizations(context: context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          stringsLoctaion.scanPinletLabel,
          style: TextStyle(color: Theme.of(context).own().primareyTextColor),
        ),
        foregroundColor: Theme.of(context).own().primareyTextColor,
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: _buildQrView(context),
          ),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 300.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      cameraFacing: CameraFacing.back,
      onQRViewCreated: _onQRViewCreated,
      formatsAllowed: [BarcodeFormat.qrcode],
      overlay: QrScannerOverlayShape(
        borderColor: Theme.of(context).primaryColor,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 5,
        cutOutSize: scanArea,
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (!scanCode) {
        scanCode = true;
        Get.back(result: scanData.code);
      }
    });
    // controller.pauseCamera();
    // controller.resumeCamera();
  }
}
