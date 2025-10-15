import 'package:dio/dio.dart';
import 'package:qr_scaner_manrique/BRACore/api/app_interceptors.dart';

class DioClient {
  final Dio _dio = Dio();
  DioClient() {
    _dio.options
      ..baseUrl = 'http://34.27.124.191/apiRest6/corp/v1'
      ..connectTimeout = 8000
      ..receiveTimeout = 8000;
    _dio.interceptors.add(AppInterceptors());
  }
  Dio get dio {
    return _dio;
  }
}
