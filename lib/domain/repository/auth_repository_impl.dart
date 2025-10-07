// import 'package:dio/dio.dart';
// import 'package:qr_scaner_manrique/BRACore/data/user_entite.dart';
// import 'package:qr_scaner_manrique/data/dto_entities/user_dto.dart';
// import 'package:qr_scaner_manrique/data/source/network/auth_api.dart';
// import 'package:qr_scaner_manrique/data/source/network/auth_repository_data_source.dart';
// import 'package:qr_scaner_manrique/domain/entites/user_entite.dart';

// class AuthRepositoryImpl extends AuthApi {
//   late AuthApi _authApi;

//   AuthRepositoryImpl({
//     required AuthApi authApi,
//   }) {
//     _authApi = authApi;
//   }

//   @override
//   Future<UserEntite> auth(String user, String password) async {
//     try {
//       final userDTO = await _authApi.auth(user, password);
      
//     } on DioError catch (e) {
//       return Future.error(e);
//     }
//   }

// }
