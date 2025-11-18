import 'package:get/get.dart';

class ExitWithQrRequestFormController extends GetxController {
  // Observable variables
  final RxString selectedType = ''.obs;
  final RxString resident = ''.obs;
  final RxString primary = ''.obs;
  final RxString secondary = ''.obs;
  final RxString guestName = ''.obs;
  final RxString guestId = ''.obs;
  final RxString guestPhone = ''.obs;
  final RxString licensePlate = ''.obs;
  final RxString reason = ''.obs;

  // Current step
  final RxInt currentStep = 0.obs;

  void goBack() {
    Get.back();
  }

  void nextStep() {
    if (currentStep.value < 2) {
      currentStep.value++;
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    }
  }

  void onTypeChanged(String type) {
    selectedType.value = type;
  }

  void onResidentChanged(String value) {
    resident.value = value;
  }

  void onPrimaryChanged(String value) {
    primary.value = value;
  }

  void onSecondaryChanged(String value) {
    secondary.value = value;
  }

  void onGuestNameChanged(String value) {
    guestName.value = value;
  }

  void onGuestIdChanged(String value) {
    guestId.value = value;
  }

  void onGuestPhoneChanged(String value) {
    guestPhone.value = value;
  }

  void onLicensePlateChanged(String value) {
    licensePlate.value = value;
  }

  void onReasonChanged(String value) {
    reason.value = value;
  }
}
