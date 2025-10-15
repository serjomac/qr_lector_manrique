import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:qr_scaner_manrique/BRACore/constants/constants-icons.dart';
import 'package:qr_scaner_manrique/BRAUXComponents/Texts/BRAText.dart';
import 'historic_parkin_controller.dart';

class HistoricParkinPage extends StatelessWidget {
  const HistoricParkinPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<HistoricParkinController>(
        init: HistoricParkinController(),
        builder: (controller) {
          return SafeArea(
            child: Column(
              children: [
                // Header with back button and title
                _buildHeader(controller),
                // Date range filter
                _buildDateRangeFilter(controller),
                // Search and type filters
                _buildFilters(controller),
                // Status chips filter
                _buildStatusChipsFilter(controller),
                // Vehicle records list
                Expanded(
                  child: _buildVehicleRecordsList(controller),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(HistoricParkinController controller) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        children: [
          // Back button
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
            ),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
                size: 20,
              ),
              onPressed: controller.onBackPressed,
            ),
          ),
          const SizedBox(width: 8),
          // Title
          Expanded(
            child: BRAText(
              text: 'Registro de ingreso de vehiculos',
              size: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateRangeFilter(HistoricParkinController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      height: 40,
      child: Obx(() => GestureDetector(
        onTap: controller.isLoading.value ? null : controller.onDateRangePressed,
        child: Container(
          decoration: BoxDecoration(
            color: controller.lasDaysSelected != null
                ? Color(0xFFFFF8F6)
                : Colors.white,
            border: Border.all(color: Color(0xFFD8C2BD)),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            children: [
              // Calendar icon
              SvgPicture.asset(ConstantsIcons.calendarIcon),
              const SizedBox(width: 5),
              // Date range text
              Expanded(
                child: BRAText(
                  text: controller.isLoading.value 
                      ? 'Cargando...'
                      : (controller.lasDaysSelected != null
                          ? controller.lasDaysSelected!.title
                          : controller.rangeDateDescription),
                  size: 12,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF5B5856),
                ),
              ),
              // Dropdown arrow or loading indicator
              controller.isLoading.value
                  ? SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF5B5856)),
                      ),
                    )
                  : Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 20,
                      color: const Color(0xFF5B5856),
                    ),
            ],
          ),
        ),
      )),
    );
  }

  Widget _buildFilters(HistoricParkinController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          // Placa search field
          Expanded(
            child: _buildSearchField(controller),
          ),
          const SizedBox(width: 10),
          // Type dropdown
          // Expanded(
          //   child: _buildTypeDropdown(controller),
          // ),
        ],
      ),
    );
  }

  Widget _buildSearchField(HistoricParkinController controller) {
    return Container(
      height: 60,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            color: Colors.white,
            child: BRAText(
              text: 'Buscar',
              size: 12,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF5B5856),
            ),
          ),
          const SizedBox(height: 3),
          // Text field
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFFC3C3C3)),
                borderRadius: BorderRadius.circular(4),
              ),
              child: TextFormField(
                controller: controller.placaController,
                onChanged: controller.onSearchPlaca,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  hintStyle: TextStyle(
                    color: Color(0xFF5B5856),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                style: const TextStyle(
                  color: Color(0xFF5B5856),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeDropdown(HistoricParkinController controller) {
    return Container(
      height: 61,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            color: Colors.white,
            child: BRAText(
              text: 'Tipo',
              size: 12,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF5B5856),
            ),
          ),
          const SizedBox(height: 3),
          // Dropdown
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFFC3C3C3)),
                borderRadius: BorderRadius.circular(4),
              ),
              child: DropdownButtonFormField<String>(
                value: controller.selectedTipo,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                ),
                style: const TextStyle(
                  color: Color(0xFF5B5856),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
                dropdownColor: Colors.white,
                icon: Transform.rotate(
                  angle: -1.5708, // 270 degrees
                  child: const Icon(
                    Icons.arrow_back_ios,
                    size: 12,
                    color: Color(0xFF5B5856),
                  ),
                ),
                items: controller.tiposVehiculo.map((String tipo) {
                  return DropdownMenuItem<String>(
                    value: tipo,
                    child: BRAText(
                      text: tipo,
                      size: 15,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF5B5856),
                    ),
                  );
                }).toList(),
                onChanged: controller.onTipoChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChipsFilter(HistoricParkinController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          BRAText(
            text: 'Filtrar por estado',
            size: 12,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF5B5856),
          ),
          const SizedBox(height: 8),
          // Chips list
          SizedBox(
            height: 40,
            child: GetBuilder<HistoricParkinController>(
              builder: (controller) {
                final statusCounts = controller.getStatusCounts();
                return ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    // "Todos" chip
                    _buildStatusChip(
                      label: 'Todos',
                      count: controller.allVehicleRecords.length,
                      isSelected: controller.selectedStatusFilter == null,
                      onTap: () => controller.onStatusFilterTap(null),
                      backgroundColor: Colors.grey[100]!,
                      textColor: const Color(0xFF5B5856),
                      borderColor: Colors.grey[300]!,
                    ),
                    const SizedBox(width: 8),
                    // Status chips
                    ...VehicleStatus.values.map((status) {
                      final count = statusCounts[status] ?? 0;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: _buildStatusChip(
                          label: status.label,
                          count: count,
                          isSelected: controller.selectedStatusFilter == status,
                          onTap: () => controller.onStatusFilterTap(status),
                          backgroundColor: status.backgroundColor,
                          textColor: status.textColor,
                          borderColor: status.borderColor,
                        ),
                      );
                    }).toList(),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip({
    required String label,
    required int count,
    required bool isSelected,
    required VoidCallback onTap,
    required Color backgroundColor,
    required Color textColor,
    required Color borderColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? backgroundColor : backgroundColor.withOpacity(0.3),
          border: Border.all(
            color: isSelected ? borderColor : borderColor.withOpacity(0.5),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            BRAText(
              text: label,
              size: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? textColor : textColor.withOpacity(0.8),
            ),
            const SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected ? textColor.withOpacity(0.2) : textColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: BRAText(
                text: count.toString(),
                size: 10,
                fontWeight: FontWeight.w600,
                color: isSelected ? textColor : textColor.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleRecordsList(HistoricParkinController controller) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFEB472A)),
              ),
              SizedBox(height: 16),
              BRAText(
                text: 'Cargando registros...',
                size: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF5B5856),
              ),
            ],
          ),
        );
      }

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: RefreshIndicator(
          color: Theme.of(Get.context!).primaryColor,
          backgroundColor: Colors.white,
          onRefresh: () async {
            await controller.fetchVehicleRecords(clearFilters: true);
          },
          child: controller.vehicleRecords.isEmpty
              ? ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    Container(
                      height: MediaQuery.of(Get.context!).size.height * 0.5,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.directions_car_outlined,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            BRAText(
                              text: 'No hay registros',
                              size: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600]!,
                            ),
                            const SizedBox(height: 8),
                            BRAText(
                              text: 'Desliza hacia abajo para actualizar',
                              size: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey[500]!,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: controller.vehicleRecords.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final record = controller.vehicleRecords[index];
                    return GestureDetector(
                      onTap: () => controller.onVehicleRecordTap(record),
                      child: _buildVehicleCard(record),
                    );
                  },
                ),
        ),
      );
    });
  }

  Widget _buildVehicleCard(VehicleRecord record) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF453F3D).withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: const Color(0xFF453F3D).withOpacity(0.03),
            blurRadius: 50,
            offset: const Offset(0, 8),
            spreadRadius: 7,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: Puerta label, accumulated time, and status badge
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Puerta label
                BRAText(
                  text: record.puerta,
                  size: 10,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF5B5856),
                ),
                const Spacer(),
                // Accumulated time section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    BRAText(
                      text: 'Tiempo acumulado',
                      size: 10,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFFC3C3C3),
                    ),
                    const SizedBox(height: 2),
                    BRAText(
                      text: record.tiempoAcumulado,
                      size: 10,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF5B5856),
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                // Status badge
                _buildStatusBadge(record.estado),
              ],
            ),
            // Bottom row: Vehicle info and time info
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Vehicle info section
                SizedBox(
                  width: 140,
                  child: _buildVehicleInfoSection(record),
                ),
                const SizedBox(width: 10),
                // Time info section
                Flexible(
                  child: _buildTimeInfoSection(record),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(VehicleStatus status) {
    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: status.backgroundColor,
        border: Border.all(color: status.borderColor),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: BRAText(
          text: status.label.toUpperCase(),
          size: 10,
          fontWeight: FontWeight.w600,
          color: status.textColor,
        ),
      ),
    );
  }

  Widget _buildVehicleInfoSection(VehicleRecord record) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Vehicle icon
          Container(
            width: 30,
            height: 30,
            child: Icon(
              Icons.directions_car,
              size: 22,
              color: const Color(0xFF5B5856),
            ),
          ),
          const SizedBox(width: 6),
          // Placa info
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              BRAText(
                text: 'Placa',
                size: 8,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF5B5856),
              ),
              const SizedBox(height: 1),
              BRAText(
                text: record.placa,
                size: 16,
                fontWeight: FontWeight.w500,
                color: const Color(0xFFEB472A),
              ),
              // Validation type badge
              Container(
                margin: const EdgeInsets.only(top: 1),
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFF565656)),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: BRAText(
                  text: record.tipoValidacion.toUpperCase(),
                  size: 7,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF565656),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeInfoSection(VehicleRecord record) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ingreso time
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: BRAText(
                  text: 'Fecha ingreso',
                  size: 12,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF5B5856),
                ),
              ),
              Center(
                child: BRAText(
                  text: record.horaIngreso,
                  size: 12,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF5B5856),
                ),
              ),
            ],
          ),
          SizedBox(height: 6),
          // Validación time
          Column(
            children: [
              Center(
                child: BRAText(
                  text: 'Fecha validación',
                  size: 12,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF5B5856),
                ),
              ),
              Center(
                child: BRAText(
                  text: record.horaValidacion,
                  size: 12,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF5B5856),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}