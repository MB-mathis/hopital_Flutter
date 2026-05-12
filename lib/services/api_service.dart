import 'package:dio/dio.dart';
import '../config/api_routes.dart';

// Service de communication avec l'API (api_service.dart)

class ApiService {
  final Dio dio = Dio();

  ApiService() {
    dio.options.baseUrl = ApiRoutes.baseUrl;
  }

  // 🔐 LOGIN (pas besoin de token)
  Future<Response> postLogin(String email, String password) async {
    return await dio.post(
      ApiRoutes.login,
      data: {
        "email": email,
        "password": password,
      },
    );
  }

  // 👤 GET USER CONNECTÉ
  Future<Response> getMe(String token) async {
    return await dio.get(
      ApiRoutes.me,
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );
  }

  // 🏥 PATIENTS
  Future<Response> getPatients(String token) async {
    return await dio.get(
      ApiRoutes.patients,
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );
  }
  Future<Response> getPatient(int id, String token) async {
    return dio.get(
      ApiRoutes.patient(id),
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );
  }
}