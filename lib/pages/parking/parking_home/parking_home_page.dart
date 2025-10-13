import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:qr_scaner_manrique/BRACore/constants/constants-icons.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/entrance.dart';
import 'package:qr_scaner_manrique/BRACore/models/user_data.dart';
import 'package:qr_scaner_manrique/BRAUXComponents/Texts/BRAText.dart';
import 'package:qr_scaner_manrique/pages/login/ui/login_page.dart';
import 'package:qr_scaner_manrique/utils/AppLocations.dart';
import 'parking_home_controller.dart';

class ParkingHomePage extends StatelessWidget {
  const ParkingHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<ParkingHomeController>(
        init: ParkingHomeController(),
        builder: (controller) {
          return SafeArea(
            child: Stack(
              children: [
                // Imagen de fondo de la ciudad en la parte inferior
                Positioned(
                  bottom: -20,
                  left: -100,
                  right: -100,
                  child: Opacity(
                    opacity: 0.3,
                    child: Image.asset(
                      'assets/images/ciudad.png',
                      fit: BoxFit.cover,
                      height: 300,
                    ),
                  ),
                ),
                
                // Contenido principal
                Column(
                  children: [
                    // Top bar personalizada
                    _buildTopBar(controller, context),
                    
                    // Dropdown de selección de puerta
                    _buildParkingGateSelector(controller),
                    
                    // Opciones principales del parqueo
                    Expanded(
                      child: _buildParkingOptions(controller),
                    ),
                    
                    // Botón de historial flotante
                    _buildHistoryButton(controller),
                    
                    const SizedBox(height: 32),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTopBar(ParkingHomeController controller, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(195, 195, 195, 0.12),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Lado izquierdo - Nombre del lugar con flecha
          Row(
            children: [
              GestureDetector(
                onTap: controller.goBack,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  child: const Icon(
                    Icons.arrow_back_ios,
                    size: 20,
                    color: Color(0xFF231918),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              BRAText(
                text: controller.placeName,
                size: 16,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF231918),
              ),
            ],
          ),
          
          // Lado derecho - Icono de logout (igual que HomePage)
          InkWell(
            onTap: () {
              UserData.sharedInstance.removeSession();
              Get.offAll(() => const LoginPage());
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 28),
              child: Row(
                children: [
                  const Icon(
                    Icons.logout_rounded,
                    size: 30,
                    color: Color(0xFF231918),
                  ),
                  BRAText(
                    text: AppLocalizationsGenerator.appLocalizations(context: context).logoutLabel,
                    size: 15,
                    color: const Color(0xFF231918),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParkingGateSelector(ParkingHomeController controller) {
    return Container(
      margin: const EdgeInsets.only(top: 32, left: 25, right: 25),
      child: Obx(() {
        if (controller.entrancesLoading.value) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const SizedBox(
                width: 35,
                height: 35,
                child: CircularProgressIndicator(
                  color: Color(0xFF202023),
                ),
              ),
            ],
          );
        } else {
          return Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    border: Border.all(color: const Color(0xFFC3C3C3)),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<GateDoor>(
                      value: controller.entranceIdSelected,
                      hint: const Text(
                        'Seleccionar puerta de parqueo',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF202023),
                        ),
                      ),
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Color(0xFF202023),
                        size: 20,
                      ),
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF202023),
                      ),
                      onChanged: (GateDoor? newValue) {
                        if (newValue != null) {
                          controller.changeParkingGate(newValue);
                        }
                      },
                      items: controller.parkingEntrances.map<DropdownMenuItem<GateDoor>>((GateDoor gate) {
                        return DropdownMenuItem<GateDoor>(
                          value: gate,
                          child: Text(gate.nombre ?? ''),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () {
                  controller.fetchParkingEntrances(
                    placeId: UserData.sharedInstance.placeSelected!.idLugar.toString(),
                  );
                },
                child: const Icon(
                  Icons.refresh,
                  color: Color(0xFF202023),
                  size: 35,
                ),
              ),
            ],
          );
        }
      }),
    );
  }

  Widget _buildParkingOptions(ParkingHomeController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Validación de parqueo
          _buildOptionCard(
            title: 'Validación de parqueo',
            iconColor: const Color(0xFFE8D6D3),
            iconData: Icons.qr_code_scanner,
            onTap: controller.goToValidation,
          ),
          
          const SizedBox(height: 24),
          
          // Ingreso de parqueo
          _buildOptionCard(
            title: 'Ingreso de parqueo',
            iconColor: const Color(0xFFF5F5F5),
            iconData: Icons.login,
            onTap: controller.goToEntry,
          ),
          
          const SizedBox(height: 24),
          
          // Salida de parqueo
          _buildOptionCard(
            title: 'Salida de parqueo',
            iconColor: const Color(0xFFF5F5F5),
            iconData: Icons.logout,
            onTap: controller.goToExit,
          ),
        ],
      ),
    );
  }

  Widget _buildOptionCard({
    required String title,
    required Color iconColor,
    required IconData iconData,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 342,
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
                child: Icon(
                  iconData,
                  size: 24,
                  color: const Color(0xFF231918),
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

  Widget _buildHistoryButton(ParkingHomeController controller) {
    return Container(
      margin: const EdgeInsets.only(right: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: controller.goToHistory,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(100),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(195, 195, 195, 0.27),
                    blurRadius: 2,
                    offset: Offset(0, 2),
                  ),
                  BoxShadow(
                    color: Color.fromRGBO(195, 195, 195, 0.12),
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    ConstantsIcons.hisotric,
                    width: 18,
                    height: 18,
                    color: const Color(0xFF534340),
                  ),
                  const SizedBox(width: 8),
                  const BRAText(
                    text: 'Historial',
                    size: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF231918),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}