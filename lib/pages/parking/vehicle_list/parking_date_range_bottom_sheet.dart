import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_scaner_manrique/BRACore/extensions/own-color-scheme.dart';
import 'package:qr_scaner_manrique/BRAUXComponents/Texts/BRAText.dart';
import 'package:qr_scaner_manrique/pages/parking/vehicle_list/vehicles_list_controller.dart';
import 'package:qr_scaner_manrique/shared/widgets/bottom-sheet-line.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class ParkingDateRangeBottomSheet extends StatelessWidget {
  const ParkingDateRangeBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return GetBuilder<VehiclesValidationListController>(
      builder: (controller) {
        return Container(
          padding: const EdgeInsets.only(left: 24, right: 24, bottom: 30),
          height: MediaQuery.of(context).size.height * 0.75,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 24),
              BottomSheetLine(),
              const SizedBox(height: 16),
              
              // Título
              const BRAText(
                text: 'Seleccionar rango de fechas',
                size: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF231918),
              ),
              const SizedBox(height: 16),
              
              // Filtros predefinidos
              SizedBox(
                height: 45,
                child: ListView.builder(
                  itemCount: controller.filterLastDay.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final filter = controller.filterLastDay[index];
                    final isSelected = controller.lasDaysSelected?.value == filter.value;
                    
                    return GestureDetector(
                      onTap: () {
                        controller.lasDaysSelected = filter;
                        Get.back();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        margin: const EdgeInsets.only(right: 12, top: 5, bottom: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: isSelected ? const Color(0xFFEB472A) : const Color(0xFFFFF8F6),
                          border: Border.all(
                            color: isSelected ? const Color(0xFFEB472A) : const Color(0xFFD8C2BD),
                          ),
                        ),
                        child: Center(
                          child: BRAText(
                            text: filter.title,
                            color: isSelected ? Colors.white : const Color(0xFF231918),
                            size: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              
              // Calendario
              Expanded(
                child: GetBuilder<VehiclesValidationListController>(
                  builder: (controller) {
                    // Calcular minDate y maxDate dinámicamente
                    DateTime calculatedMinDate = DateTime.now().subtract(const Duration(days: 365)); // 1 año atrás por defecto
                    DateTime calculatedMaxDate = DateTime.now();
                    
                    // Si hay una fecha de referencia (endDateTemprary), ajustar los límites
                    if (controller.endDateTemprary != DateTime.now()) {
                      calculatedMinDate = controller.endDateTemprary.subtract(const Duration(days: 7));
                      calculatedMaxDate = controller.endDateTemprary.add(const Duration(days: 7));
                      
                      // Asegurar que maxDate no sea mayor a hoy
                      if (calculatedMaxDate.isAfter(DateTime.now())) {
                        calculatedMaxDate = DateTime.now();
                      }
                    }
                    
                    return SfDateRangePicker(
                      view: DateRangePickerView.month,
                      backgroundColor: theme.colorScheme.background,
                      headerStyle: DateRangePickerHeaderStyle(
                        backgroundColor: theme.colorScheme.background,
                        textStyle: TextStyle(
                          color: theme.own().primareyTextColor,
                        ),
                      ),
                      headerHeight: 80,
                      confirmText: 'ACEPTAR',
                      cancelText: 'CANCELAR',
                      onSubmit: (selectedDates) {
                        controller.lasDaysSelected = null;
                        final pickerDateRange = selectedDates as PickerDateRange;
                        controller.startDate = pickerDateRange.startDate ?? controller.startDate;
                        controller.endDate = pickerDateRange.endDate ?? controller.endDate;
                        controller.loadVehicleEntries();
                        Get.back();
                      },
                      monthFormat: 'MMMM',
                      monthViewSettings: const DateRangePickerMonthViewSettings(
                        showTrailingAndLeadingDates: true,
                        viewHeaderStyle: DateRangePickerViewHeaderStyle(
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      monthCellStyle: DateRangePickerMonthCellStyle(
                        trailingDatesTextStyle: TextStyle(
                          color: theme.own().tertiaryTextColor,
                          fontSize: 16,
                        ),
                        leadingDatesTextStyle: TextStyle(
                          color: theme.own().tertiaryTextColor,
                          fontSize: 16,
                        ),
                        textStyle: TextStyle(
                          color: theme.own().primareyTextColor,
                          fontSize: 16,
                        ),
                      ),
                      yearCellStyle: DateRangePickerYearCellStyle(
                        textStyle: TextStyle(color: theme.own().primareyTextColor),
                      ),
                      showActionButtons: true,
                      rangeSelectionColor: const Color(0xFFFFE5E0),
                      onCancel: () {
                        controller.endDateTemprary = DateTime.now();
                        Get.back();
                      },
                      rangeTextStyle: TextStyle(
                        color: theme.own().primareyTextColor,
                        fontSize: 16,
                      ),
                      startRangeSelectionColor: const Color(0xFFEB472A),
                      endRangeSelectionColor: const Color(0xFFEB472A),
                      selectionTextStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      todayHighlightColor: const Color(0xFFEB472A),
                      initialSelectedRange: PickerDateRange(
                        controller.startDate,
                        controller.endDate,
                      ),
                      minDate: calculatedMinDate,
                      maxDate: calculatedMaxDate,
                      onSelectionChanged: (dateRangePickerSelectionChangedArgs) {
                        final rangeDate = dateRangePickerSelectionChangedArgs.value as PickerDateRange;
                        if (rangeDate.startDate != null) {
                          // Actualizar la fecha de referencia y forzar rebuild
                          controller.endDateTemprary = rangeDate.startDate!;
                          controller.update(); // Forzar actualización del GetBuilder
                        } else {
                          controller.endDateTemprary = DateTime.now();
                          controller.update();
                        }
                      },
                      selectionMode: DateRangePickerSelectionMode.range,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}