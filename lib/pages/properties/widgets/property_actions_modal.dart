import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:qr_scaner_manrique/BRACore/constants/constants-icons.dart';
import 'package:qr_scaner_manrique/BRACore/extensions/own-color-scheme.dart';
import 'package:qr_scaner_manrique/BRAUXComponents/Texts/BRAText.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/place.dart';
import 'package:qr_scaner_manrique/pages/home/home_page.dart';
import 'package:qr_scaner_manrique/pages/parking/parking_home/parking_home_page.dart';
import 'package:qr_scaner_manrique/pages/school/exit_without_qr_request_form/enums/registration_type.dart';

class PropertyActionsModal extends StatelessWidget {
  final Place place;
  final bool showNewVersionButton;

  const PropertyActionsModal({
    Key? key,
    required this.place,
    required this.showNewVersionButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.own().primareyTextColor!.withOpacity(0.2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                _buildActionButton(
                  context,
                  icon: ConstantsIcons.qrIcon,
                  label: 'PINLET GARITA',
                  onTap: () {
                    Get.back();
                    Get.to(() => HomePage(
                          showNewVersionButton: showNewVersionButton,
                          initialTab: 0,
                          propertyEntryType: PropertyEntryType.residentGate,
                        ));
                  },
                ),
                const SizedBox(height: 16),
                _buildActionButton(
                  context,
                  icon: ConstantsIcons.qrIcon,
                  label: 'PINLET COLEGIO',
                  onTap: () {
                    Get.back();
                    Get.to(() => HomePage(
                          showNewVersionButton: showNewVersionButton,
                          initialTab: 0,
                          propertyEntryType: PropertyEntryType.schoolGate,
                        ));
                  },
                ),
                const SizedBox(height: 16),
                _buildActionButton(
                  context,
                  icon: ConstantsIcons.qrIcon,
                  label: 'PINLET PARQUEO',
                  onTap: () {
                    Get.back();
                       Get.to(() => const ParkingHomePage());
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.own().primareyTextColor!.withOpacity(0.1),
          ),
          boxShadow: [
            BoxShadow(
              color: theme.own().primareyTextColor!.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: SvgPicture.asset(icon),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: BRAText(
                text: label,
                textStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: theme.own().primareyTextColor,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: theme.primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
