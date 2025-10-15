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

                              const SizedBox(
                                  height: 40), // Espacio extra al final
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

  Widget _buildInfoSection({
    required ValidateParkingController controller,
    required String name,
    required String id,
    required String cellphone,
    DateTime? date,
    required String door,
    String? observation,
    required String entryType,
    required String activity,
  }) {
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
          // Nombre (solo mostrar si tiene datos)
          controller.nameController.text.isNotEmpty
              ? Column(
                  children: [
                    Row(
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
                            text: name, //controller.nameController.text,
                            size: 14,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF333333),
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],
                )
              : Container(),
          // Cédula (solo mostrar si tiene datos)
          controller.cedulaController.text.isNotEmpty
              ? Column(
                  children: [
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
                          text: id, //controller.cedulaController.text,
                          size: 14,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF333333),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],
                )
              : Container(),
          // Celular (solo mostrar si tiene datos)
          controller.celularController.text.isNotEmpty
              ? Column(
                  children: [
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
                          text: cellphone, //controller.celularController.text,
                          size: 14,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF333333),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],
                )
              : Container(),
          // Solo mostrar divider si hay al menos un campo de información personal
          (controller.nameController.text.isNotEmpty ||
                  controller.cedulaController.text.isNotEmpty ||
                  controller.celularController.text.isNotEmpty)
              ? Column(
                  children: [
                    const Divider(color: Color(0xFFE0E0E0)),
                    const SizedBox(height: 12),
                  ],
                )
              : Container(),
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
                text: controller.formatDateTime(
                    date), //controller.formatDateTime(vehicleData.ingreso?.fechaIngreso),
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
                text: door, // vehicleData.ingreso?.nombrePuertaIngreso,
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
                text: 'Tipo ingreso:',
                size: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF333333),
              ),
              BRAText(
                text: entryType,
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
                text: 'Actividad:',
                size: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF333333),
              ),
              BRAText(
                text: activity,
                size: 14,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF5B5856),
              ),
            ],
          ),
          // Observación (solo mostrar si tiene datos)
          observation?.isNotEmpty == true
              ? Column(
                  children: [
                    const SizedBox(height: 12),
                    const Divider(color: Color(0xFFE0E0E0)),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BRAText(
                          text: 'Observación:',
                          size: 14,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF333333),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: BRAText(
                            text: observation ??
                                '', //vehicleData.ingreso?.observacionIngreso ?? '',
                            size: 14,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF5B5856),
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : Container(),
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

  Widget _buildImageGrid(
      ValidateParkingController controller, List<String> urls) {
    return Column(
      children: [
        SizedBox(
          height: urls.isNotEmpty ? 402 : 0,
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.0,
            ),
            itemCount: urls.length,
            itemBuilder: (context, index) {
              return _buildImageCard(index, controller, urls);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildImageCard(
      int index, ValidateParkingController controller, List<String> urls) {
    final hasImage = urls[index].isNotEmpty;
    final isReadOnly = controller.isImageGridReadOnly;

    return GestureDetector(
      onTap: () {
        if (hasImage) {
          // Mostrar modal con imagen ampliada
          _showImageModal(Get.context!, NetworkImage(urls[index]));
        } else if (!isReadOnly) {
          // Aquí puedes agregar lógica para agregar/cambiar imagen
          // Solo si no está en modo de solo lectura
        }
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
                  urls[index],
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

  Widget _buildTabContent(
      ValidateParkingController controller, BuildContext context) {
    switch (controller.selectedTabIndex) {
      case 0: // Ingreso
        return _buildIngresoContent(controller);
      case 1: // Validación
        return (controller.mainParkingEntry == MainParkingEntry.exit ||
                controller.mainParkingEntry == MainParkingEntry.history)
            ? _buildExitContent(controller)
            : _buildValidacionContent(context);
      case 2: // Salida
        return _buildSalidaContent(controller, Theme.of(context));
      default:
        return _buildIngresoContent(controller);
    }
  }

  Widget _buildIngresoContent(ValidateParkingController controller) {
    return Column(
      children: [
        // Información del registro
        _buildInfoSection(
          controller: controller,
          name: controller.nameController.text,
          id: controller.cedulaController.text,
          cellphone: controller.celularController.text,
          date: vehicleData.ingreso?.fechaIngreso ?? DateTime.now(),
          door: vehicleData.ingreso?.nombrePuertaIngreso ?? '',
          observation: vehicleData.ingreso?.observacionIngreso,
          entryType: vehicleData.ingreso?.tipoIngreso ?? '',
          activity: vehicleData.ingreso?.actividad ?? '',
        ),

        const SizedBox(height: 20),

        // Grid de imágenes
        _buildImageGrid(controller, controller.loadEntryImages()),
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
        _buildImageGrid(controller, controller.loadValidationImages()),
      ],
    );
  }

  Widget _buildSalidaContent(
    ValidateParkingController controller,
    ThemeData theme,
  ) {
    // Si venimos de exit, mostrar diseño específico para salida
    if (controller.mainParkingEntry == MainParkingEntry.exit) {
      return _buildExitSalidaContent(theme);
    }

    // Si venimos de history, mostrar información de historial
    if (controller.mainParkingEntry == MainParkingEntry.history) {
      return _buildHistoryContent(controller);
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
          vehicleData.ingreso?.fechaValidacion == null
              ? const BRAText(
                  text: 'No validado',
                  size: 14,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF333333),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BRAText(
                      text: 'Fecha:',
                      size: 14,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF333333),
                    ),
                    BRAText(
                      text: controller
                          .formatDateTime(vehicleData.ingreso?.fechaValidacion),
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
                text: vehicleData.ingreso?.nombrePuertaIngreso ?? '',
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
    // Si estamos en modo history, solo mostrar las imágenes existentes
    if (controller.mainParkingEntry == MainParkingEntry.history) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Solo mostrar las imágenes si hay alguna, sin botón de agregar
          if (controller.validacionImages.isNotEmpty) ...[
            const BRAText(
              text: "Imágenes del registro:",
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
                    child: _buildHistoryImageItem(controller, index),
                  );
                },
              ),
            ),
          ],
        ],
      );
    }

    // Comportamiento normal para otros modos
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
          // Preview de la imagen con tap para zoom
          GestureDetector(
            onTap: () {
              _showImageModal(
                  Get.context!, FileImage(controller.validacionImages[index]));
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.file(
                controller.validacionImages[index],
                width: 120,
                height: 120,
                fit: BoxFit.cover,
              ),
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

  // Método para mostrar imágenes en modo historial (solo lectura)
  Widget _buildHistoryImageItem(
      ValidateParkingController controller, int index) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF036546), width: 2),
      ),
      child: Stack(
        children: [
          // Preview de la imagen con tap para zoom
          GestureDetector(
            onTap: () {
              _showImageModal(
                  Get.context!, FileImage(controller.validacionImages[index]));
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.file(
                controller.validacionImages[index],
                width: 120,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Indicador de solo lectura
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
    // No mostrar botón en modo historial
    if (controller.mainParkingEntry == MainParkingEntry.history) {
      return const SizedBox.shrink();
    }

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
        // Time and rate section (ahora incluye fecha y puerta)
        _buildTimeAndRateSection(controller),

        const SizedBox(height: 32),
        _buildValidationImageSection(controller),

        const SizedBox(height: 32),
        // Observation field
        if (!controller.shouldHideObservacionValidacion)
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
          // Fecha y Puerta (en dos columnas)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Columna izquierda - Fecha
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BRAText(
                      text: "Fecha:",
                      size: 14,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF333333),
                    ),
                    const SizedBox(height: 6),
                    BRAText(
                      text: 'No validado',
                      size: 14,
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
                      text: "Puerta:",
                      size: 14,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF333333),
                    ),
                    const SizedBox(height: 6),
                    BRAText(
                      text: vehicleData.ingreso?.nombrePuertaIngreso ?? '',
                      size: 14,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF5B5856),
                    ),
                  ],
                ),
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
                text: 'Fracción/Hora:',
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
                text: '\$${controller.vehicleData.ingreso?.valorTotal ?? ''}',
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
  Widget _buildExitSalidaContent(ThemeData theme) {
    final controller = Get.find<ValidateParkingController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 20),

        // Campo de placa si está vacía o es null
        if (controller.shouldShowPlacaField) ...[
          Form(
            key: controller.placaFormKey,
            child: _buildPlacaInputField(controller, theme),
          ),
          const SizedBox(height: 20),
        ],

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
    // Si estamos en modo history, solo mostrar las imágenes existentes
    if (controller.mainParkingEntry == MainParkingEntry.history) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Solo mostrar las imágenes si hay alguna, sin botón de agregar
          if (controller.validacionImages.isNotEmpty) ...[
            const BRAText(
              text: "Imágenes del registro:",
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
                    child: _buildHistoryImageItem(controller, index),
                  );
                },
              ),
            ),
          ],
        ],
      );
    }

    // Comportamiento normal para otros modos
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Lista horizontal que incluye el botón de agregar como primer elemento
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: controller.validacionImages.length + 1, // +1 para el botón de agregar
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

  // Campo de observación para registro de salida
  Widget _buildExitObservationField(
      ValidateParkingController controller, BuildContext context) {
    return SizedBox(
      height: 50,
      child: TextFormField(
        controller: controller.observacionValidacionController,
        readOnly: controller.mainParkingEntry == MainParkingEntry.exit ||
            controller.mainParkingEntry == MainParkingEntry.history,
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

  // Campo de entrada para placa en registro de salida
  Widget _buildPlacaInputField(
    ValidateParkingController controller,
    ThemeData theme,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BRAText(
            text: 'Placa del vehículo *',
            size: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF231918),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller.placaController,
            textCapitalization: TextCapitalization.characters,
            validator: (value) {
              // Solo validar cuando el campo es visible
              if (controller.shouldShowPlacaField) {
                if (value == null || value.trim().isEmpty) {
                  return 'La placa del vehículo es obligatoria';
                }
                if (value.trim().length < 3) {
                  return 'La placa debe tener al menos 3 caracteres';
                }
              }
              return null;
            },
            decoration: CustomTextFormField.decorationFormCard(
              labelText: '',
              theme: theme,
              focusNode: FocusNode(),
            ),
            // const InputDecoration(
            //   border: InputBorder.none,
            //   contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
            //   hintText: 'Ej: ABC123',
            //   hintStyle: TextStyle(
            //     color: Color(0xFF9E9E9E),
            //     fontSize: 16,
            //     fontWeight: FontWeight.w400,
            //   ),
            // ),
            style: const TextStyle(
              color: Color(0xFF231918),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            onChanged: (value) {
              // Convertir a mayúsculas automáticamente
              controller.placaController.value =
                  controller.placaController.value.copyWith(
                text: value.toUpperCase(),
                selection:
                    TextSelection.collapsed(offset: value.toUpperCase().length),
              );
            },
          ),
        ],
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

  // Método para mostrar imagen con zoom
  void _showImageModal(BuildContext context, ImageProvider imageProvider) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Center(
            child: Stack(
              children: [
                // Imagen con zoom sin fondo
                InteractiveViewer(
                  minScale: 0.5,
                  maxScale: 10.0,
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.9,
                      maxHeight: MediaQuery.of(context).size.height * 0.8,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image(
                        image: imageProvider,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                // Botón de cerrar posicionado sobre la imagen
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.black54,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHistoryContent(ValidateParkingController controller) {
    return Column(
      children: [
        // Información del registro (usando la información de salida si existe)
        _buildInfoSection(
          controller: controller,
          name: controller.nameController.text,
          cellphone: controller.celularController.text,
          id: controller.cedulaController.text,
          door: controller.vehicleData.ingreso?.nombrePuertaSalida ?? '',
          date: controller.vehicleData.ingreso?.fechaSalida,
          observation: controller.vehicleData.ingreso?.observacionSalida ?? '',
          entryType: controller.vehicleData.ingreso?.tipoIngreso ?? '',
          activity: controller.vehicleData.ingreso?.actividad ?? '',
        ),

        const SizedBox(height: 20),

        // Grid de imágenes (solo lectura)
        _buildImageGrid(controller, controller.loadExitImages()),

        const SizedBox(height: 20),
      ],
    );
  }
}
