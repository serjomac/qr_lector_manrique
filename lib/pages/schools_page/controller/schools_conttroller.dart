import 'package:get/get.dart';
import 'package:qr_scaner_manrique/core/api/api_managr.dart';
import 'package:qr_scaner_manrique/core/api/local_api.dart';
import 'package:qr_scaner_manrique/core/models/request_models/request_areas.dart';
import 'package:qr_scaner_manrique/core/models/response_models/area_model.dart';

class SchoolsController extends GetxController {

  Map<String, dynamic> arguments = {};
  List<Area> _arealist = [];
  Area? _selectedArea;
  LocalApi localApi = LocalApi();
  ApiManager apiManager = ApiManager();
  RxBool loadingAreaList = false.obs;

  @override
  void onInit() {
    arguments = Get.arguments;
    if (arguments['idUser'] != null) {
      getAreas(arguments['idUser'] as String);
    }
    super.onInit();
  }

  // GETTERS AND SETTERS
  List<Area> get areaList {
    return _arealist;
  }
  set areaList (List<Area> areaList) {
    _arealist = areaList;
  }

  Area? get selectedArea {
    return _selectedArea;
  }

  set selectedArea(Area? selectedArea) {
    localApi.saveAreaSelected(selectedArea!);
    _selectedArea = selectedArea;
  }

  getAreas(String idUser) async {
    loadingAreaList.value = true;
    AreaRequest areaRequest = AreaRequest(idUsuario: idUser);
    _arealist = await apiManager.getAreasByUser(areaRequest);
    loadingAreaList.value = false;
  }

}