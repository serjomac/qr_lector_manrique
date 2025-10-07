import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:qr_scaner_manrique/BRACore/constants/constants-icons.dart';
import 'package:qr_scaner_manrique/BRACore/enums/main_parking_entry.dart';
import 'package:qr_scaner_manrique/BRAUXComponents/Texts/BRAText.dart';
import 'package:qr_scaner_manrique/pages/parking/type_parking_register/type_parking_register_controller.dart';

class TypeParkingRegisterModal extends StatelessWidget {
  final String? doorId;
  final bool showSearchOption;
  final MainParkingEntry mainParkingEntry;
  
  const TypeParkingRegisterModal({
    Key? key, 
    this.doorId,
    this.showSearchOption = true,
    this.mainParkingEntry = MainParkingEntry.validation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Inicializar el controlador con doorId y mainParkingEntry
    final controller = Get.put(TypeParkingRegisterController(
      doorId: doorId,
      mainParkingEntry: mainParkingEntry,
    ));
    
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 290,
        padding: const EdgeInsets.all(42),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(195, 195, 195, 0.3),
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
            BoxShadow(
              color: Color.fromRGBO(195, 195, 195, 0.12),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Opción Por QR
            _buildOptionCard(
              title: 'Por QR',
              iconColor: const Color(0xFFE8D6D3),
              iconWidget: SvgPicture.asset(
                ConstantsIcons.qrIcon,
                width: 24,
                height: 24,
                color: const Color(0xFF231918),
              ),
              onTap: () {
                controller.selectType(ParkingValidationType.qr);
                controller.navigateToQrScanner();
              },
            ),
            
            const SizedBox(height: 10),
            
            // Opción Buscar (condicional)
            if (showSearchOption) ...[
              _buildOptionCard(
                title: 'Buscar',
                iconColor: const Color(0xFFF5F5F5),
                iconWidget: const Icon(
                  Icons.search,
                  size: 24,
                  color: Color(0xFF231918),
                ),
                onTap: () {
                  controller.selectType(ParkingValidationType.search);
                  controller.navigateToSearch();
                },
              ),
              const SizedBox(height: 10),
            ],
            
            // Opción Manual
            _buildOptionCard(
              title: 'Manual',
              iconColor: const Color(0xFFF5F5F5),
              iconWidget: const Icon(
                Icons.edit,
                size: 24,
                color: Color(0xFF231918),
              ),
              onTap: () {
                controller.selectType(ParkingValidationType.manual);
                controller.navigateToManual();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard({
    required String title,
    required Color iconColor,
    required Widget iconWidget,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 191,
        height: 65,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFF85736F)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              // Icono circular
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: iconColor,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Center(
                  child: iconWidget,
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Título de la opción
              Expanded(
                child: BRAText(
                  text: title,
                  size: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF231918),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}