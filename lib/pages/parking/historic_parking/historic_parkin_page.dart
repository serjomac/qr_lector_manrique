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
      child: GestureDetector(
        onTap: controller.isLoading ? null : controller.onDateRangePressed,
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
                  text: controller.isLoading 
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
              controller.isLoading
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
      ),
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
          Expanded(
            child: _buildTypeDropdown(controller),
          ),
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
                  hintText: 'GDF 4566',
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

  Widget _buildVehicleRecordsList(HistoricParkinController controller) {
    if (controller.isLoading) {
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
      child: ListView.separated(
        itemCount: controller.vehicleRecords.length,
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final record = controller.vehicleRecords[index];
          return _buildVehicleCard(record);
        },
      ),
    );
  }

  Widget _buildVehicleCard(VehicleRecord record) {
    return Container(
      height: 130,
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
              children: [
                // Vehicle info section
                Flexible(
                  flex: 3,
                  child: _buildVehicleInfoSection(record),
                ),
                const SizedBox(width: 10),
                // Time info section
                Flexible(
                  flex: 2,
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
      height: 38,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          // Ingreso time
          Expanded(
            child: Column(
              children: [
                Center(
                  child: BRAText(
                    text: 'Ingreso',
                    size: 10,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF5B5856),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F2F2),
                      border: Border.all(color: const Color(0xFFC3C3C3)),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Center(
                      child: BRAText(
                        text: record.horaIngreso,
                        size: 10,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF5B5856),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Separator
          Container(
            width: 3,
            height: 2,
            margin: const EdgeInsets.symmetric(horizontal: 1),
            color: const Color(0xFFC3C3C3),
          ),
          // Validación time
          Expanded(
            child: Column(
              children: [
                Center(
                  child: BRAText(
                    text: 'Validación',
                    size: 10,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF5B5856),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F2F2),
                      border: Border.all(color: const Color(0xFFC3C3C3)),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Center(
                      child: BRAText(
                        text: record.horaValidacion,
                        size: 10,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF5B5856),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}