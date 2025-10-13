import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_scaner_manrique/BRACore/enums/main_parking_entry.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/parking_response.dart';
import 'package:qr_scaner_manrique/BRAUXComponents/Texts/BRAText.dart';
import 'package:qr_scaner_manrique/BRAUXComponents/buttons/BRAButton.dart';
import 'package:qr_scaner_manrique/BRAUXComponents/textField/custom_text_form_field.dart';
import 'package:qr_scaner_manrique/pages/parking/validate_parking/validate_parking_controller.dart';

class ValidateParkingPage extends StatelessWidget {
  final ParrkingResponse vehicleData;
  final MainParkingEntry mainParkingEntry;

  const ValidateParkingPage({
    Key? key,
    required this.vehicleData,
    required this.mainParkingEntry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<ValidateParkingController>(
        init: ValidateParkingController(
          vehicleData: vehicleData,
          mainParkingEntry: mainParkingEntry,
        ),
        builder: (controller) {
          return SafeArea(
            child: Column(
              children: [
                // Header fijo en la parte superior
                _buildHeader(context, controller),
                
                // Tab Bar fijo debajo del header
                _buildTabBar(context, controller),
                
                // Content scrollable
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Content específico según el tab
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: Column(
                            children: [
                              const SizedBox(height: 20),

                              // Placa del vehículo (común para todos los tabs)
                              _buildPlacaWidget(controller),

                              // Mensaje de alerta con observación (solo si existe)
                              _buildObservationAlert(controller),

                              const SizedBox(height: 20),

                              // Contenido específico del tab
                              _buildTabContent(controller, context),

                              const SizedBox(height: 40), // Espacio extra al final
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Botón fijo en la parte inferior (solo para ciertos tabs)
                _buildBottomButton(controller),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(
      BuildContext context, ValidateParkingController controller) {

    return Container(
      height: 47,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
                size: 18,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: BRAText(
                text: controller.getCurrentTabTitle(),
                size: 16,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF231918),
              ),
            ),
          ),
          const SizedBox(width: 45), // Para balancear el header
        ],
      ),
    );
  }

  Widget _buildTabBar(
      BuildContext context, ValidateParkingController controller) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        width: 342,
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFFF4F4F4),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Stack(
          children: [
            // Indicador animado
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              left: 3 + (controller.selectedTabIndex * 112),
              top: 3,
              child: Container(
                width: 110,
                height: 34,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
            // Tabs
            Row(
              children: [
                _buildTab("Ingreso", 0, controller),
                _buildTab("Validación", 1, controller),
                _buildTab("Salida", 2, controller),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(
      String title, int index, ValidateParkingController controller) {
    final isSelected = controller.selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.selectTab(index),
        child: Container(
          height: 40,
          alignment: Alignment.center,
          child: BRAText(
            text: title,
            size: 12,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : const Color(0xFF231918),
          ),
        ),
      ),
    );
  }

  Widget _buildPlacaWidget(ValidateParkingController controller) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icono del carro
          Container(
            width: 32,
            height: 31,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Icon(
              Icons.directions_car,
              color: Color(0xFF666666),
              size: 28,
            ),
          ),
          const SizedBox(width: 8),
          // Placa
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
            ),
            child: BRAText(
              text: controller.placaController.text,
              size: 25,
              fontWeight: FontWeight.w500,
              color: const Color(0xFFEB472A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildObservationAlert(ValidateParkingController controller) {
    // Solo mostrar la alerta si hay observación de ingreso
    if (controller.vehicleData.observacion == null ||
        controller.vehicleData.observacion!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF3CD),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFFFD60A), width: 1),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: Color(0xFFB45309),
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const BRAText(
                      text: "Observación de ingreso:",
                      size: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFB45309),
                    ),
                    const SizedBox(height: 4),
                    BRAText(
                      text: controller.vehicleData.observacion!,
                      size: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFFB45309),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildInfoSection(ValidateParkingController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nombre
          controller.nameController.text.isNotEmpty ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BRAText(
                text: 'Nombre:',
                size: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF333333),
              ),
              Expanded(
                child: BRAText(
                  text: controller.nameController.text,
                  size: 14,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF333333),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ) : Container(),
          const SizedBox(height: 12),
          // Cédula
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BRAText(
                text: 'Cédula:',
                size: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF333333),
              ),
              BRAText(
                text: controller.cedulaController.text,
                size: 14,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF333333),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Celular
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BRAText(
                text: 'Celular:',
                size: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF333333),
              ),
              BRAText(
                text: controller.celularController.text,
                size: 14,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF333333),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: Color(0xFFE0E0E0)),
          const SizedBox(height: 12),
          // Fecha
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BRAText(
                text: 'Fecha:',
                size: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF333333),
              ),
              BRAText(
                text: controller.fechaController.text,
                size: 14,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF5B5856),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Puerta
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BRAText(
                text: 'Puerta:',
                size: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF333333),
              ),
              BRAText(
                text: controller.puertaController.text,
                size: 14,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF5B5856),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value,
      {bool isSecondary = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BRAText(
          text: label,
          size: 16,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF202023),
        ),
        const SizedBox(height: 6),
        BRAText(
          text: value,
          size: 16,
          fontWeight: FontWeight.w400,
          color:
              isSecondary ? const Color(0xFF5B5856) : const Color(0xFF202023),
        ),
      ],
    );
  }

  Widget _buildImageGrid(ValidateParkingController controller) {
    return Column(
      children: [
        SizedBox(
          height: controller.imageUrls.isNotEmpty ? 402 : 0,
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.0,
            ),
            itemCount: controller.imageUrls.length,
            itemBuilder: (context, index) {
              return _buildImageCard(index, controller);
            },
          ),
        ),

        // Texto informativo para modo validación
        if (controller.isImageGridReadOnly && controller.imageUrls.isNotEmpty) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFCFF9E6),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF036546), width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.info_outline,
                  color: Color(0xFF036546),
                  size: 16,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: BRAText(
                    text: controller.imageUrls.isNotEmpty ? "Imágenes de ingreso (solo visualización)" : '',
                    size: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF036546),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildImageCard(int index, ValidateParkingController controller) {
    final hasImage = controller.imageUrls[index].isNotEmpty;
    final isReadOnly = controller.isImageGridReadOnly;

    return GestureDetector(
      onTap: isReadOnly
          ? null
          : () {
              // Aquí puedes agregar lógica para agregar/cambiar imagen
              // Solo si no está en modo de solo lectura
            },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFD9D9D9),
          borderRadius: BorderRadius.circular(10),
          // Agregar borde visual para indicar modo de solo lectura
          border: isReadOnly && hasImage
              ? Border.all(color: const Color(0xFF036546), width: 2)
              : null,
        ),
        child: Stack(
          children: [
            if (hasImage)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  controller.imageUrls[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildImagePlaceholder();
                  },
                ),
              )
            else
              _buildImagePlaceholder(),

            // Indicador de solo lectura
            if (isReadOnly && hasImage)
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF036546),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(
                    Icons.visibility,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent(ValidateParkingController controller, BuildContext context) {
    switch (controller.selectedTabIndex) {
      case 0: // Ingreso
        return _buildIngresoContent(controller);
      case 1: // Validación
        return controller.mainParkingEntry == MainParkingEntry.exit
            ? _buildExitContent(controller)
            : _buildValidacionContent(context);
      case 2: // Salida
        return _buildSalidaContent(controller);
      default:
        return _buildIngresoContent(controller);
    }
  }

  Widget _buildIngresoContent(ValidateParkingController controller) {
    return Column(
      children: [
        
        // Información del registro
        _buildInfoSection(controller),

        const SizedBox(height: 20),

        // Grid de imágenes
        _buildImageGrid(controller),
      ],
    );
  }

  Widget _buildExitContent(ValidateParkingController controller) {
    // Diseño original para modo validación normal
    return Column(
      children: [
        // Información de validación en dos columnas
        _buildValidacionInfoSection(controller),

        const SizedBox(height: 20),

        // Grid de imágenes (solo lectura)
        _buildImageGrid(controller),
      ],
    );
  }

  Widget _buildSalidaContent(ValidateParkingController controller) {
    // Si venimos de exit, mostrar diseño específico para salida
    if (controller.mainParkingEntry == MainParkingEntry.exit) {
      return _buildExitSalidaContent();
    }

    // Diseño original para sin registro de salida
    return Column(
      children: [
        const SizedBox(height: 20),

        // Mensaje de sin registro de salida
        _buildNoExitMessage(),
      ],
    );
  }

  Widget _buildValidacionInfoSection(ValidateParkingController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fecha
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BRAText(
                text: 'Fecha:',
                size: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF333333),
              ),
              BRAText(
                text: controller.fechaValidacionController.text,
                size: 14,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF5B5856),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Puerta
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BRAText(
                text: 'Puerta:',
                size: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF333333),
              ),
              BRAText(
                text: controller.puertaController.text,
                size: 14,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF5B5856),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Tiempo total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BRAText(
                text: 'Tiempo total:',
                size: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF333333),
              ),
              BRAText(
                text: controller.tiempoTotalController.text,
                size: 14,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF333333),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Tiempo pago
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BRAText(
                text: 'Tiempo pago:',
                size: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF333333),
              ),
              BRAText(
                text: controller.tiempoPagoController.text,
                size: 14,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF333333),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: Color(0xFFE0E0E0)),
          const SizedBox(height: 12),
          // Tarifa
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BRAText(
                text: 'Tarifa:',
                size: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF333333),
              ),
              Row(
                children: [
                  BRAText(
                    text: '\$${controller.tarifaController.text}',
                    size: 14,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF5B5856),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BRAText(
                text: 'Total:',
                size: 16,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF333333),
              ),
              BRAText(
                text: '\$${controller.totalController.text}',
                size: 16,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTarifaItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BRAText(
          text: label,
          size: 16,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF202023),
        ),
        const SizedBox(height: 6),
        BRAText(
          text: '\$${value}',
          size: 16,
          fontWeight: FontWeight.w400,
          color: const Color(0xFF5B5856),
        ),
      ],
    );
  }

  Widget _buildValidacionImageSection(ValidateParkingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Botón para agregar imagen
        GestureDetector(
          onTap: () {
            controller.takeValidacionPhoto();
          },
          child: Container(
            width: 177,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFC3C3C3)),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_photo_alternate_outlined,
                  size: 40,
                  color: Color(0xFFC3C3C3),
                ),
                SizedBox(height: 8),
                BRAText(
                  text: "Añadir imágenes",
                  size: 12,
                  color: Color(0xFFC3C3C3),
                ),
              ],
            ),
          ),
        ),

        // Lista horizontal de imágenes si hay alguna
        if (controller.validacionImages.isNotEmpty) ...[
          const SizedBox(height: 16),
          const BRAText(
            text: "Imágenes agregadas:",
            size: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF231918),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.validacionImages.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(right: 12),
                  child: _buildImageItem(controller, index),
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildImageItem(ValidateParkingController controller, int index) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFC3C3C3)),
      ),
      child: Stack(
        children: [
          // Preview de la imagen
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.file(
              controller.validacionImages[index],
              width: 120,
              height: 120,
              fit: BoxFit.cover,
            ),
          ),
          // Botón X para eliminar
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: () {
                controller.removeValidacionImage(index);
              },
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildObservacionField(ValidateParkingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 8.5),
          child: BRAText(
            text: "Observación ",
            size: 14,
            color: Color(0xFF231918),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: 62,
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFF85736F)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextFormField(
            controller: controller.observacionValidacionController,
            maxLines: null,
            expands: true,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 16,
              ),
            ),
            style: const TextStyle(
              color: Color(0xFF534340),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGuardarButton(ValidateParkingController controller) {
    return Obx(() {
      // Determinar el texto del botón según el modo
      String buttonText;
      if (controller.mainParkingEntry == MainParkingEntry.exit) {
        buttonText = controller.isValidating.value ? 'Guardando...' : 'Guardar';
      } else {
        buttonText = controller.isValidating.value ? 'Validando...' : 'Validar';
      }

      return BRAButton(
        label: buttonText,
        onPressed: () {
          if (!controller.isValidating.value) {
            controller.onValidarPressed();
          }
        },
      );
    });
  }

  Widget _buildBottomButton(ValidateParkingController controller) {
    // Determinar si mostrar botón según el tab y modo
    bool shouldShowButton = false;
    
    // Mostrar botón en el tab de Validación (index 1) o Salida (index 2) según el modo
    if (controller.selectedTabIndex == 1) {
      // Tab Validación: mostrar botón solo si NO venimos de exit mode
      shouldShowButton = controller.mainParkingEntry != MainParkingEntry.exit;
    } else if (controller.selectedTabIndex == 2) {
      // Tab Salida: mostrar botón solo si venimos de exit mode
      shouldShowButton = controller.mainParkingEntry == MainParkingEntry.exit;
    }

    if (!shouldShowButton) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: _buildGuardarButton(controller),
    );
  }

  Widget _buildTicketStatus(ValidateParkingController controller) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: controller.isTicketExpired
            ? const Color(0xFFE5E8EC)
            : const Color(0xFFCFF9E6),
        border: Border.all(
          color: controller.isTicketExpired
              ? const Color(0xFF565656)
              : const Color(0xFF036546),
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          BRAText(
            text: controller.isTicketExpired ? "CADUCADO" : "VALIDADO",
            size: 20,
            fontWeight: FontWeight.w400,
            color: controller.isTicketExpired
                ? const Color(0xFF565656)
                : const Color(0xFF036546),
          ),
          const SizedBox(width: 10),
          Icon(
            controller.isTicketExpired ? Icons.error : Icons.check_circle,
            size: 30,
            color: controller.isTicketExpired
                ? const Color(0xFF565656)
                : const Color(0xFF036546),
          ),
        ],
      ),
    );
  }

  Widget _buildNoExitMessage() {
    return Container(
      width: 297,
      height: 165,
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            size: 50,
            color: Color(0xFFEB472A),
          ),
          SizedBox(height: 6),
          BRAText(
            text: "Sin registro de salida",
            size: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF202023),
          ),
          SizedBox(height: 6),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: BRAText(
              text:
                  "Parece que no hay un registro de salida para este vehículo",
              size: 16,
              fontWeight: FontWeight.w400,
              color: Color(0xFF5B5856),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Center(
        child: Icon(
          Icons.image_outlined,
          color: Colors.grey,
          size: 40,
        ),
      ),
    );
  }

  // Método para el contenido de validación cuando venimos de exit
  Widget _buildValidacionContent(BuildContext context) {
    final controller = Get.find<ValidateParkingController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Info section
        _buildValidationInfoSection(controller),
    
        const SizedBox(height: 24),
    
        // Time and rate section
        _buildTimeAndRateSection(controller),
    
        const SizedBox(height: 32),
        _buildValidationImageSection(controller),
    
        const SizedBox(height: 32),
        // Observation field
        _buildExitObservationField(controller, context),
      ],
    );
  }

  Widget _buildTimeAndRateSection(ValidateParkingController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BRAText(
                text: 'Tiempo total:',
                size: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF333333),
              ),
              BRAText(
                text: controller.vehicleData.ingreso?.tiempoTotal ?? '',
                size: 14,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF333333),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BRAText(
                text: 'Tiempo de pago:',
                size: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF333333),
              ),
              BRAText(
                text: controller.vehicleData.ingreso?.tiempoHorasPago ?? '',
                size: 14,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF333333),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BRAText(
                text: 'Tarifa:',
                size: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF333333),
              ),
              BRAText(
                text: '\$${controller.vehicleData.ingreso?.tarifaAplicada}',
                size: 14,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF333333),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: Color(0xFFE0E0E0)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BRAText(
                text: 'Total a pagar:',
                size: 16,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF333333),
              ),
              BRAText(
                text: '\$${controller.vehicleData.ingreso?.valorTotal ?? ''}', // This would come from the controller
                size: 16,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Método para el contenido de salida cuando venimos de exit
  Widget _buildExitSalidaContent() {
    final controller = Get.find<ValidateParkingController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 20),

        // Info section (Fecha y Puerta)
        _buildExitRegistroInfoSection(controller),

        const SizedBox(height: 20),

        // Image upload section
        _buildExitImageUploadSection(controller),
      ],
    );
  }

  // Información básica para salida (fecha y puerta)
  Widget _buildValidationInfoSection(ValidateParkingController controller) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Columna izquierda - Fecha
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoItem("Fecha:", controller.fechaController.text,
                  isSecondary: true),
            ],
          ),
        ),
        const SizedBox(width: 45),
        // Columna derecha - Puerta
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoItem("Puerta", controller.puertaController.text,
                  isSecondary: true),
            ],
          ),
        ),
      ],
    );
  }

  // Sección de imagen para salida (una sola imagen)
  Widget _buildValidationImageSection(ValidateParkingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Lista horizontal que incluye el botón de agregar como primer elemento
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: controller.validacionImages.length +
                1, // +1 para el botón de agregar
            itemBuilder: (context, index) {
              if (index == 0) {
                // Primer elemento: botón para agregar imagen
                return Container(
                  margin: const EdgeInsets.only(right: 12),
                  child: GestureDetector(
                    onTap: () {
                      controller.takeValidacionPhoto();
                    },
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFC3C3C3)),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_photo_alternate_outlined,
                            size: 22,
                            color: Color(0xFFC3C3C3),
                          ),
                          SizedBox(height: 8),
                          BRAText(
                            text: "Añadir imágenes",
                            size: 10,
                            color: Color(0xFFC3C3C3),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                // Elementos siguientes: imágenes agregadas
                final imageIndex = index - 1;
                return Container(
                  margin: const EdgeInsets.only(right: 12),
                  child: _buildImageItem(controller, imageIndex),
                );
              }
            },
          ),
        ),
      ],
    );
  }

  // Información para registro de salida (Fecha y Puerta)
  Widget _buildExitRegistroInfoSection(ValidateParkingController controller) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Columna izquierda - Fecha
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BRAText(
                text: "Fecha:",
                size: 16,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF202023),
              ),
              const SizedBox(height: 6),
              BRAText(
                text: controller.fechaController.text.isNotEmpty
                    ? controller.fechaController.text
                    : "20 jul. 2025 10:40",
                size: 16,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF5B5856),
              ),
            ],
          ),
        ),
        const SizedBox(width: 45),
        // Columna derecha - Puerta
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BRAText(
                text: "Puerta",
                size: 16,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF202023),
              ),
              const SizedBox(height: 6),
              BRAText(
                text: controller.puertaController.text.isNotEmpty
                    ? controller.puertaController.text
                    : "Puerta Z",
                size: 16,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF5B5856),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Sección de imagen para registro de salida
  Widget _buildExitImageUploadSection(ValidateParkingController controller) {
    return Column(
      children: [
        // Imagen de carga única (177x164px como en Figma)
        GestureDetector(
          onTap: () {
            controller.takeValidacionPhoto();
          },
          child: Container(
            width: 177,
            height: 164,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFC3C3C3)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  child: const Icon(
                    Icons.add_photo_alternate_outlined,
                    size: 22,
                    color: Color(0xFFC3C3C3),
                  ),
                ),
                const SizedBox(height: 8),
                const BRAText(
                  text: "Añadir imagenes",
                  size: 10,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFFC3C3C3),
                ),
              ],
            ),
          ),
        ),

        // Lista horizontal de imágenes si hay alguna
        if (controller.validacionImages.isNotEmpty) ...[
          const SizedBox(height: 16),
          const BRAText(
            text: "Imágenes agregadas:",
            size: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF231918),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.validacionImages.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(right: 12),
                  child: _buildImageItem(controller, index),
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  // Campo de observación para registro de salida
  Widget _buildExitObservationField(
      ValidateParkingController controller, BuildContext context) {
    return SizedBox(
      height: 50,
      child: TextFormField(
        controller: controller.observacionValidacionController,
        maxLines: null,
        expands: true,
        decoration: CustomTextFormField.decorationFormCard(
            labelText: 'Observación',
            isFLoatingLabelVisible: true,
            theme: Theme.of(context),
            focusNode: FocusNode()),
      ),
    );
  }

  // Botón guardar para registro de salida
  Widget _buildExitSaveButton(ValidateParkingController controller) {
    return Obx(() {
      return Container(
        width: 206,
        height: 46,
        decoration: BoxDecoration(
          color: const Color(0xFFEB472A),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: controller.isValidating.value
                ? null
                : () {
                    controller.onValidarPressed();
                  },
            child: Center(
              child: BRAText(
                text:
                    controller.isValidating.value ? 'Guardando...' : 'Guardar',
                size: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
    });
  }
}
