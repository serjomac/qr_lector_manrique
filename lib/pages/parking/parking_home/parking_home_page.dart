import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:qr_scaner_manrique/BRACore/constants/constants-icons.dart';
import 'package:qr_scaner_manrique/BRACore/enums/entrances_type.dart';
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
            bottom: false,
            child: Stack(
              children: [
                // Imagen de fondo de la ciudad en la parte inferior
                Positioned(
                  bottom: 0,
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
                SingleChildScrollView(
                  child: Column(
                    children: [
                      // Top bar personalizada
                      _buildTopBar(controller, context),
                      const SizedBox(height: 24),
                  
                      // Logo de la aplicación
                      Image(
                        image: AssetImage('assets/images/logo-dark.png'),
                        width: 150,
                      ),
                  
                      // Dropdown de selección de puerta
                      _buildParkingGateSelector(controller, Theme.of(context)),
                      const SizedBox(height: 24),
                  
                      // Opciones principales del parqueo
                      _buildParkingOptions(controller, Theme.of(context)),
                      const SizedBox(height: 24),
                  
                      // Botón de historial flotante
                      _buildHistoryButton(controller),
                      const SizedBox(height: 32),
                    ],
                  ),
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
                    text: AppLocalizationsGenerator.appLocalizations(
                            context: context)
                        .logoutLabel,
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

  Widget _buildParkingGateSelector(
      ParkingHomeController controller, ThemeData theme) {
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 1),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    border: Border.all(color: const Color(0xFFC3C3C3)),
                    borderRadius: BorderRadius.circular(12),
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
                      selectedItemBuilder: (context) {
                        return controller.parkingEntrances.map((gate) {
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 14,
                                height: 14,
                                decoration: BoxDecoration(
                                  color: gate.tipoIngreso == TypeDoor.entrance 
                                    ? Colors.green.shade600 
                                    : Colors.red.shade600,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: gate.tipoIngreso == TypeDoor.entrance 
                                      ? Colors.green.shade800 
                                      : Colors.red.shade800,
                                    width: 1,
                                  ),
                                ),
                                child: Icon(
                                  gate.tipoIngreso == TypeDoor.entrance 
                                    ? Icons.arrow_downward 
                                    : Icons.arrow_upward,
                                  color: Colors.white,
                                  size: 8,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                gate.nombre ?? '',
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF202023),
                                ),
                              ),
                            ],
                          );
                        }).toList();
                      },
                      onChanged: (GateDoor? newValue) {
                        if (newValue != null) {
                          controller.changeParkingGate(newValue);
                        }
                      },
                      items: controller.parkingEntrances
                          .map<DropdownMenuItem<GateDoor>>((GateDoor gate) {
                        return DropdownMenuItem<GateDoor>(
                          value: gate,
                          child: Row(
                            children: [
                              Tooltip(
                                message: gate.tipoIngreso == TypeDoor.entrance 
                                  ? 'Puerta de Entrada' 
                                  : 'Puerta de Salida',
                                child: Container(
                                  width: 14,
                                  height: 14,
                                  decoration: BoxDecoration(
                                    color: gate.tipoIngreso == TypeDoor.entrance 
                                      ? Colors.green.shade600 
                                      : Colors.red.shade600,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: gate.tipoIngreso == TypeDoor.entrance 
                                        ? Colors.green.shade800 
                                        : Colors.red.shade800,
                                      width: 1,
                                    ),
                                  ),
                                  child: Icon(
                                    gate.tipoIngreso == TypeDoor.entrance 
                                      ? Icons.arrow_downward 
                                      : Icons.arrow_upward,
                                    color: Colors.white,
                                    size: 8,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(gate.nombre ?? ''),
                              ),
                            ],
                          ),
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
                    placeId: UserData.sharedInstance.placeSelected!.idLugar
                        .toString(),
                  );
                },
                child: Icon(
                  Icons.refresh,
                  color: theme.primaryColor,
                  size: 35,
                ),
              ),
            ],
          );
        }
      }),
    );
  }

  Widget _buildParkingOptions(
      ParkingHomeController controller, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Validación de parqueo
          _buildOptionCard(
            title: 'Validación de parqueo',
            iconColor: const Color(0xFF231918),
            iconData: Icons.qr_code_scanner,
            iconBackgroundColor: const Color(0xFFF5F5F5),
            onTap: controller.goToValidation,
            theme: theme,
          ),

          const SizedBox(height: 24),

          // Ingreso de parqueo
          _buildOptionCard(
            title: 'Ingreso de parqueo',
            iconColor: const Color(0xFF2EAB03),
            iconBackgroundColor: const Color(0xFFF5F5F5),
            iconData: Icons.login,
            onTap: controller.goToEntry,
            theme: theme,
          ),

          const SizedBox(height: 24),

          // Salida de parqueo
          _buildOptionCard(
            title: 'Salida de parqueo',
            iconColor: const Color(0xFFBA1A1A),
            iconBackgroundColor: const Color(0xFFF5F5F5),
            iconData: Icons.logout,
            onTap: controller.goToExit,
            theme: theme,
          ),

          const SizedBox(height: 24),

          // Buscar por placa
          _buildOptionCard(
            title: 'Buscar por placa',
            subtitle: 'Con filtros de fecha',
            iconColor: const Color(0xFF1976D2),
            iconBackgroundColor: const Color(0xFFF5F5F5),
            iconData: Icons.search,
            onTap: controller.goToPlateSearch,
            theme: theme,
          ),
        ],
      ),
    );
  }

  Widget _buildOptionCard({
    required String title,
    String? subtitle,
    required Color iconBackgroundColor,
    required Color iconColor,
    required IconData iconData,
    required VoidCallback onTap,
    required ThemeData theme,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 342,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: theme.primaryColor),
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
                  color: iconBackgroundColor,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Icon(
                  iconData,
                  size: 24,
                  color: iconColor,
                ),
              ),

              const SizedBox(width: 12),

              // Título y subtítulo de la opción
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BRAText(
                      text: title,
                      size: 16,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF231918),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      BRAText(
                        text: subtitle,
                        size: 12,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF8B8B8B),
                      ),
                    ],
                  ],
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
