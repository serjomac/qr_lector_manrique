import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:qr_scaner_manrique/BRACore/constants/constants-icons.dart';
import 'package:qr_scaner_manrique/BRACore/enums/main_parking_entry.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/parking_response.dart';
import 'package:qr_scaner_manrique/BRAUXComponents/Texts/BRAText.dart';
import 'package:qr_scaner_manrique/shared/loadings_pages/loading_invitations_page.dart';
import 'parking_date_range_bottom_sheet.dart';
import 'vehicles_list_controller.dart';

class VehiclesListPage extends StatelessWidget {
  final String? doorId;
  final MainParkingEntry mainParkingEntry;
  
  const VehiclesListPage({Key? key, this.doorId, this.mainParkingEntry = MainParkingEntry.validation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VehiclesValidationListController>(
      init: VehiclesValidationListController(doorId: doorId, mainParkingEntry: mainParkingEntry),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                // Header with back button and title
                _buildHeader(controller),
                // Date selection section
                GetBuilder<VehiclesValidationListController>(
                  builder: (controller) => _buildDateSelectionSection(controller),
                ),
                // Search field
                _buildSearchField(controller),
                // Vehicle list or loading
                Expanded(
                  child: controller.isLoading.value 
                      ? LoadingInvitationsPage()
                      : _buildVehicleList(controller),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(VehiclesValidationListController controller) {
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
            child: InkWell(
              onTap: () => Get.back(),
              child: const Icon(
                Icons.arrow_back_ios,
                color: Color(0xFF231918),
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Title
          Expanded(
            child: BRAText(
              text: controller.mainParkingEntry == MainParkingEntry.validation ? 'Vehículos para validar' : 'Vehículos pasa salir',
              size: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF231918),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelectionSection(VehiclesValidationListController controller) {
    print('Building date selection section. Controller: ${controller.lasDaysSelected?.title ?? "null"}');
    
    return Container(
      margin: const EdgeInsets.only(top: 16, left: 24, right: 24),
      height: 48, // Altura fija para asegurar que sea visible
      child: GestureDetector(
        onTap: () {
          print('Date selection tapped');
          showModalBottomSheet(
            context: Get.context!,
            backgroundColor: Colors.white,
            isScrollControlled: true,
            builder: (context) {
              return const ParkingDateRangeBottomSheet();
            },
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: controller.lasDaysSelected != null
                ? const Color(0xFFFFF8F6)
                : const Color(0xFFF0F0F0), // Color más visible cuando no hay selección
            border: Border.all(color: const Color(0xFFD8C2BD), width: 1.5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                ConstantsIcons.calendarIcon,
                width: 16,
                height: 16,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: BRAText(
                  text: controller.lasDaysSelected?.title ?? 'Seleccionar fechas',
                  color: const Color(0xFF231918),
                  fontWeight: FontWeight.w500,
                  size: 12,
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Color(0xFF231918),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField(VehiclesValidationListController controller) {
    return Container(
      margin: const EdgeInsets.only(top: 16, left: 24, right: 24),
      child: TextField(
        controller: controller.placaController,
        onChanged: controller.searchByPlaca,
        decoration: InputDecoration(
          hintText: 'Buscar',
          hintStyle: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFF999999),
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: Color(0xFF999999),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFEB472A)),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildVehicleList(VehiclesValidationListController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: ListView.builder(
        itemCount: controller.filteredVehicleEntries.length,
        itemBuilder: (context, index) {
          final entry = controller.filteredVehicleEntries[index];
          
          return Container(
            margin: const EdgeInsets.only(bottom: 15),
            child: _buildVehicleCard(entry, index, () {
              controller.onVehicleCardTap(entry);
            }, controller),
          );
        },
      ),
    );
  }

  Widget _buildVehicleCard(ParrkingResponse entry, int index, VoidCallback onTap, VehiclesValidationListController controller) {
    return GestureDetector(
      onTap: onTap,
      child: GetBuilder<VehiclesValidationListController>(
        init: controller,
        builder: (_) {
          final bool isLoading = controller.selectedEntryIndex == index && controller.isCardLoading.value;
          
          return Container(
          height: 123,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(69, 63, 61, 0.1),
                offset: Offset(0, 4),
                blurRadius: 15,
              ),
              BoxShadow(
                color: Color.fromRGBO(69, 63, 61, 0.03),
                offset: Offset(0, 8),
                blurRadius: 50,
                spreadRadius: 7,
              ),
            ],
          ),
          child: Stack(
            children: [
              // Door label (top left)
              Positioned(
                left: 19,
                top: 17,
                child: BRAText(
                  text: (entry.ingreso?.nombrePuertaIngreso ?? '').toUpperCase(),
                  size: 10,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF5B5856),
                ),
              ),
              
              // Status badge (top right)
              Positioned(
                right: 15,
                top: 14,
                child: _buildStatusBadge(entry),
              ),
              
              // Vehicle info section (left)
              Positioned(
                left: 14,
                top: 40,
                child: _buildVehicleInfo(entry),
              ),
              
              // Time section (right)
              Positioned(
                right: 15,
                top: 41,
                child: _buildTimeSection(entry),
              ),
              
              // Accumulated time (top right, below status)
              Positioned(
                right: 90,
                top: 8,
                child: _buildAccumulatedTime(entry),
              ),
              
              // Loading overlay
              if (isLoading)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFEB472A),
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
        },
      ),
    );
  }

  Widget _buildStatusBadge(ParrkingResponse entry) {
    final String estado = _getEstadoFromApi(entry);
    final Color backgroundColor = Color(_getEstadoBgColor(entry));
    final Color textColor = Color(_getEstadoColor(entry));
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: textColor),
        borderRadius: BorderRadius.circular(4),
      ),
      child: BRAText(
        text: estado,
        size: 10,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
    );
  }

  Widget _buildVehicleInfo(ParrkingResponse entry) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          // Vehicle icon
          Container(
            width: 32,
            height: 31,
            decoration: BoxDecoration(
              color: const Color(0xFFD9D9D9),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Icon(
              Icons.directions_car,
              color: Color(0xFF5B5856),
              size: 20,
            ),
          ),
          const SizedBox(width: 8),
          
          // Plate info
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BRAText(
                text: 'Placa',
                size: 8,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF5B5856),
              ),
              const SizedBox(height: 2),
              BRAText(
                text: entry.placa?.toUpperCase() ?? '',
                size: 20,
                fontWeight: FontWeight.w500,
                color: const Color(0xFFEB472A),
              ),
              const SizedBox(height: 2),
              // Garita badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFF565656)),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: BRAText(
                  text: entry.ingreso?.tipoIngreso ?? '',
                  size: 8,
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

  Widget _buildTimeSection(ParrkingResponse entry) {
    return Container(
      width: 156,
      height: 70,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          // Ingreso time
          Expanded(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF2F2F2),
                  ),
                  child: BRAText(
                    text: 'Ingreso',
                    size: 10,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF5B5856),
                  ),
                ),
                const SizedBox(height: 2),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F2F2),
                    border: Border.all(color: const Color(0xFFC3C3C3)),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: BRAText(
                    text: _formatDateTime(entry.fechaIngreso),
                    size: 10,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF5B5856),
                  ),
                ),
              ],
            ),
          ),
          
          // Separator
          Container(
            width: 5,
            height: 2,
            color: const Color(0xFFC3C3C3),
          ),
          
          // Validación time
          Expanded(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF2F2F2),
                  ),
                  child: BRAText(
                    text: 'Validación',
                    size: 10,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF5B5856),
                  ),
                ),
                const SizedBox(height: 2),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F2F2),
                    border: Border.all(color: const Color(0xFFC3C3C3)),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: BRAText(
                      text: _formatDateTime(entry.fechaValidacion),
                      size: 10,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF5B5856),
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

  Widget _buildAccumulatedTime(ParrkingResponse entry) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        BRAText(
          text: 'Tiempo acumulado',
          size: 10,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF5B5856),
        ),
        BRAText(
          text: _calculateAccumulatedTime(entry),
          size: 15,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF5B5856),
        ),
      ],
    );
  }

  // Helper methods
  String _getEstadoFromApi(ParrkingResponse entry) {
    return entry.estado ?? 'Sin estado';
  }

  int _getEstadoColor(ParrkingResponse entry) {
    final estado = entry.estado?.toLowerCase() ?? '';
    switch (estado) {
      case 'validado':
        return 0xFF036546; // Green
      case 'ingresado':
        return 0xFFB86E00; // Orange
      case 'retirado':
        return 0xFFA10101; // Red
      case 'caducado':
        return 0xFF565656; // Gray
      default:
        return 0xFFB86E00; // Default orange
    }
  }

  int _getEstadoBgColor(ParrkingResponse entry) {
    final estado = entry.estado?.toLowerCase() ?? '';
    switch (estado) {
      case 'validado':
        return 0xFFCFF9E6; // Light green
      case 'ingresado':
        return 0xFFFEEFC8; // Light orange
      case 'retirado':
        return 0xFFFEC8C8; // Light red
      case 'caducado':
        return 0xFFE5E8EC; // Light gray
      default:
        return 0xFFFEEFC8; // Default light orange
    }
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return '---';
    
    // Format as HH:MM AM/PM
    final hour = dateTime.hour;
    final minute = dateTime.minute;
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    
    return '${displayHour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
  }

  String _calculateAccumulatedTime(ParrkingResponse entry) {
    if (entry.fechaIngreso == null) return '0h 0min';
    
    final DateTime ingreso = entry.fechaIngreso!;
    final DateTime now = DateTime.now();
    final Duration difference = now.difference(ingreso);
    
    final int hours = difference.inHours;
    final int minutes = difference.inMinutes.remainder(60);
    
    return '${hours}h ${minutes}min';
  }
}