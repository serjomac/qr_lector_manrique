import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qr_scaner_manrique/BRACore/constants/constants-icons.dart';
import 'package:qr_scaner_manrique/BRACore/extensions/own-color-scheme.dart';
import 'package:qr_scaner_manrique/BRAUXComponents/Texts/BRAText.dart';
import 'package:qr_scaner_manrique/BRAUXComponents/buttons/BRAButton.dart';
import 'package:qr_scaner_manrique/BRAUXComponents/textField/custom_text_form_field.dart';
import 'package:qr_scaner_manrique/utils/AppLocations.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class FilterLastDay {
  final String title;
  final int value;
  FilterLastDay({required this.title, required this.value});
}

class PlateSearchModal extends StatefulWidget {
  final Function(String, DateTime, DateTime) onSearch; // Agregar parámetros de fecha

  const PlateSearchModal({
    Key? key,
    required this.onSearch,
  }) : super(key: key);

  @override
  State<PlateSearchModal> createState() => _PlateSearchModalState();
}

class _PlateSearchModalState extends State<PlateSearchModal> {
  final TextEditingController plateController = TextEditingController();
  final FocusNode plateFocusNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final RxBool isLoading = false.obs;

  // Propiedades para filtros de fecha
  DateTime startDate = DateTime.now().subtract(Duration(days: 1));
  DateTime endDate = DateTime.now();
  List<FilterLastDay> filterLastDay = [];
  FilterLastDay? _lasDaysSelected;

  // Language support
  bool get isEnglishLanguage {
    return AppLocalizationsGenerator.languageCode == 'en';
  }

  // Getters and setters for date range
  set lasDaysSelected(FilterLastDay? filterLastDay) {
    _lasDaysSelected = filterLastDay;
    endDate = DateTime.now();
    startDate = endDate.subtract(Duration(days: filterLastDay?.value ?? 1));
    setState(() {});
  }

  FilterLastDay? get lasDaysSelected {
    return _lasDaysSelected;
  }

  String get rangeDateDescription {
    if (_lasDaysSelected != null) {
      return _lasDaysSelected!.title;
    }
    return '${DateFormat.yMMMd('ES').format(startDate)} - ${DateFormat.yMMMd('ES').format(endDate)}';
  }

  @override
  void initState() {
    super.initState();
    _initializeFilterLastDay();
    // Inicializar con "Último día" por defecto
    lasDaysSelected = filterLastDay.first;
  }

  void _initializeFilterLastDay() {
    filterLastDay = [
      FilterLastDay(
          title: isEnglishLanguage ? 'Last day' : 'Último día', value: 1),
      FilterLastDay(
          title: isEnglishLanguage ? 'Last 3 days' : 'Últimos 3 días',
          value: 3),
      FilterLastDay(
          title: isEnglishLanguage ? 'Last 5 days' : 'Últimos 5 días',
          value: 5),
      FilterLastDay(
          title: isEnglishLanguage ? 'Last 7 days' : 'Últimos 7 días',
          value: 7),
    ];
  }

  // Método para mostrar el bottom sheet de filtros de fecha
  void onDateRangePressed() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.background,
      isScrollControlled: true,
      builder: (context) {
        return _buildDateRangeBottomSheet();
      },
    );
  }

  // Widget para construir el bottom sheet de rango de fechas
  Widget _buildDateRangeBottomSheet() {
    return Container(
      padding: EdgeInsets.only(left: 24, right: 24, bottom: 30),
      height: MediaQuery.of(context).size.height * 0.75,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10))),
      child: Column(
        children: [
          SizedBox(height: 24),
          // Línea del bottom sheet
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 16),
          // Lista horizontal de filtros predefinidos
          SizedBox(
            height: 45,
            child: ListView.builder(
              itemCount: filterLastDay.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final filter = filterLastDay[index];
                return GestureDetector(
                  onTap: () {
                    lasDaysSelected = filter;
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    margin: EdgeInsets.only(right: 16, top: 5, bottom: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Color(0xFFFFF8F6),
                        border: Border.all(color: Theme.of(context).primaryColor)),
                    child: Center(
                        child: Text(
                      filter.title,
                      style: TextStyle(
                        color: Theme.of(context).own().secundaryTextColor,
                        fontSize: 12,
                      ),
                    )),
                  ),
                );
              },
            ),
          ),
          // Expandir para incluir el calendario
          Expanded(
            child: SfDateRangePicker(
              view: DateRangePickerView.month,
              backgroundColor: Theme.of(context).colorScheme.background,
              headerStyle: DateRangePickerHeaderStyle(
                backgroundColor: Theme.of(context).colorScheme.background,
                textStyle: TextStyle(
                  color: Theme.of(context).own().secundaryTextColor,
                ),
              ),
              headerHeight: 80,
              confirmText: AppLocalizationsGenerator.appLocalizations(context: context).acceptLabel.toUpperCase(),
              onSubmit: (p0) {
                // Limpiar selección de filtros predefinidos cuando se selecciona fecha personalizada
                _lasDaysSelected = null;
                final pickerDateRange = p0 as PickerDateRange;
                startDate = pickerDateRange.startDate ?? startDate;
                endDate = pickerDateRange.endDate ?? endDate;
                setState(() {});
                Navigator.pop(context);
              },
              monthFormat: 'MMMM',
              cancelText: AppLocalizationsGenerator.appLocalizations(context: context).cancelLabel.toUpperCase(),
              monthViewSettings: DateRangePickerMonthViewSettings(
                showTrailingAndLeadingDates: true,
                viewHeaderStyle: DateRangePickerViewHeaderStyle(
                    textStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                )),
              ),
              monthCellStyle: DateRangePickerMonthCellStyle(
                  trailingDatesTextStyle: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 16,
                  ),
                  leadingDatesTextStyle: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 16,
                  ),
                  textStyle: TextStyle(
                    color: Theme.of(context).own().secundaryTextColor,
                    fontSize: 16,
                  )),
              yearCellStyle: DateRangePickerYearCellStyle(
                  textStyle: TextStyle(color: Theme.of(context).own().secundaryTextColor)),
              showActionButtons: true,
              rangeSelectionColor: Theme.of(context).primaryColor.withOpacity(0.2),
              onCancel: () {
                Navigator.pop(context);
              },
              rangeTextStyle: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface, fontSize: 16),
              startRangeSelectionColor: Theme.of(context).primaryColor,
              endRangeSelectionColor: Theme.of(context).primaryColor,
              selectionTextStyle: TextStyle(color: Colors.white, fontSize: 16),
              todayHighlightColor: Theme.of(context).primaryColor,
              initialSelectedRange: PickerDateRange(
                startDate,
                endDate,
              ),
              maxDate: DateTime.now(),
              onSelectionChanged: (dateRangePickerSelectionChangedArgs) {
                // Actualizar preview del rango seleccionado
                final rangeDate = dateRangePickerSelectionChangedArgs.value as PickerDateRange;
                if (rangeDate.startDate != null) {
                  startDate = rangeDate.startDate!;
                  endDate = rangeDate.endDate ?? rangeDate.startDate!;
                }
              },
              selectionMode: DateRangePickerSelectionMode.range,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    plateController.dispose();
    plateFocusNode.dispose();
    super.dispose();
  }

  void _onSearchPressed() async {
    if (_formKey.currentState!.validate()) {
      isLoading.value = true;

      try {
        await widget.onSearch(
          plateController.text.toUpperCase().trim(),
          startDate,
          endDate,
        );
      } catch (e) {
        // El error será manejado por el controller
      } finally {
        isLoading.value = false;
      }
    }
  }

  Widget _buildDateRangeFilter() {
    return Container(
      height: 40,
      child: GestureDetector(
        onTap: onDateRangePressed,
        child: Container(
          decoration: BoxDecoration(
            color: lasDaysSelected != null
                ? Color(0xFFFFF8F6)
                : Colors.white,
            border: Border.all(color: Color(0xFFD8C2BD)),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            children: [
              // Calendar icon
              SvgPicture.asset(
                ConstantsIcons.calendarIcon,
                width: 18,
                height: 18,
              ),
              const SizedBox(width: 5),
              // Date range text
              Expanded(
                child: BRAText(
                  text: rangeDateDescription,
                  size: 12,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF5B5856),
                ),
              ),
              // Dropdown arrow
              Icon(
                Icons.keyboard_arrow_down,
                color: const Color(0xFF5B5856),
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Título
              const BRAText(
                text: 'Buscar por placa',
                size: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF231918),
              ),
              const SizedBox(height: 8),
              const BRAText(
                text: 'Ingresa la placa del vehículo para buscar su registro',
                size: 14,
                color: Color(0xFF666666),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Filtro de rango de fechas
              _buildDateRangeFilter(),
              const SizedBox(height: 16),

              // Campo de entrada para placa
              CustomTextFormField(
                focusNode: plateFocusNode,
                controller: plateController,
                hintText: 'Ej: ABC123',
                label: 'Placa del vehículo',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor ingresa la placa del vehículo';
                  }
                  if (value.trim().length < 3) {
                    return 'La placa debe tener al menos 3 caracteres';
                  }
                  return null;
                },
                onChanged: (value) {
                  // Convert to uppercase as user types
                  final upperCaseText = value.toUpperCase();
                  if (plateController.text != upperCaseText) {
                    plateController.value = plateController.value.copyWith(
                      text: upperCaseText,
                      selection: TextSelection.collapsed(offset: upperCaseText.length),
                    );
                  }
                },
                onTap: () {},
              ),

              const SizedBox(height: 24),

              // Botones
              Row(
                children: [
                  // Botón cancelar
                  Expanded(
                    child: Obx(() => TextButton(
                      onPressed: isLoading.value ? null : () => Get.back(),
                      child: const BRAText(
                        text: 'Cancelar',
                        size: 16,
                        color: Color(0xFF666666),
                      ),
                    )),
                  ),
                  const SizedBox(width: 16),

                  // Botón buscar
                  Expanded(
                    child: BRAButton(
                      label: isLoading.value ? 'Buscando...' : 'Buscar',
                      onPressed: _onSearchPressed,
                      loadingButton: isLoading,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}