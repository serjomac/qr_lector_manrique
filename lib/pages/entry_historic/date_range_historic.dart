import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:qr_scaner_manrique/BRACore/extensions/own-color-scheme.dart';
import 'package:qr_scaner_manrique/BRAUXComponents/Texts/BRAText.dart';
import 'package:qr_scaner_manrique/pages/entry_historic/entry_historic_controller.dart';
import 'package:qr_scaner_manrique/shared/widgets/bottom-sheet-line.dart';
import 'package:qr_scaner_manrique/utils/AppLocations.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DateRangeHistoric extends StatelessWidget {
  DateRangeHistoric();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final stringLocations = AppLocalizationsGenerator.appLocalizations(context: context);
    return GetBuilder<EntryHistoricController>(
        init: EntryHistoricController(),
        builder: (_) {
          return Container(
              padding: EdgeInsets.only(left : 24, right: 24, bottom: 30),
              height: MediaQuery.of(context).size.height * 0.75,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10))),
              child: Column(
                children: [
                  SizedBox(
                    height: 24,
                  ),
                  BottomSheetLine(),
                  SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    height: 45,
                    child: ListView.builder(
                      itemCount: _.filterLastDay.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final filter = _.filterLastDay[index];
                        return GestureDetector(
                          onTap: () {
                            _.lasDaysSelected = filter;
                            Get.back();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            margin:
                                EdgeInsets.only(right: 16, top: 5, bottom: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Color(0xFFFFF8F6),
                                border: Border.all(color: theme.primaryColor)),
                            child: Center(
                                child: BRAText(
                              text: filter.title,
                              color: theme.own().primareyTextColor,
                              size: 12,
                            )),
                          ),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: SfDateRangePicker(
                      view: DateRangePickerView.month,
                      backgroundColor: theme.colorScheme.background,
                      headerStyle: DateRangePickerHeaderStyle(
                        backgroundColor: theme.colorScheme.background,
                        textStyle: TextStyle(
                          color: theme.own().primareyTextColor,
                        ),
                      ),
                      headerHeight: 80,
                      confirmText: stringLocations.acceptLabel.toUpperCase(),
                      onSubmit: (p0) {
                        _.lasDaysSelected = null;
                        final pickerDateRange = p0 as PickerDateRange;
                        _.startDate = pickerDateRange.startDate ?? _.startDate;
                        _.endDate = pickerDateRange.endDate ?? _.endDate;
                        _.fetchEntries();
                        Get.back();
                      },
                      monthFormat: 'MMMM',
                      cancelText: stringLocations.cancelLabel.toUpperCase(),
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
                          )),
                      yearCellStyle: DateRangePickerYearCellStyle(
                          textStyle:
                              TextStyle(color: theme.own().primareyTextColor)),
                      showActionButtons: true,
                      rangeSelectionColor: theme.primaryColor.withOpacity(0.2),
                      onCancel: () {
                        _.endDateTemprary = DateTime.now();
                        Get.back();
                      },
                      rangeTextStyle: TextStyle(
                          color: theme.own().primareyTextColor, fontSize: 16),
                      startRangeSelectionColor: theme.primaryColor,
                      endRangeSelectionColor: theme.primaryColor,
                      selectionTextStyle:
                          TextStyle(color: Colors.white, fontSize: 16),
                      todayHighlightColor: theme.primaryColor,
                      initialSelectedRange: PickerDateRange(
                        _.startDate,
                        _.endDate,
                      ),
                      maxDate: _.endDateTemprary.add(Duration(days: 7)),
                      onSelectionChanged:
                          (dateRangePickerSelectionChangedArgs) {
                            final rangeDate = dateRangePickerSelectionChangedArgs.value as PickerDateRange;
                            _.endDateTemprary = rangeDate.startDate ?? DateTime.now();
                            _.update();
                          },
                      selectionMode: DateRangePickerSelectionMode.range,
                      // monthViewSettings: DateRangePickerMonthViewSettings(firstDayOfWeek: 1),
                    ),
                  ),
                ],
              ));
        });
  }
}
