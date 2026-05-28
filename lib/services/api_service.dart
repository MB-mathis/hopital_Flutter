import 'package:dio/dio.dart';
import '../config/api_routes.dart';

class ApiService {
  final Dio dio = Dio();

  ApiService() {
    dio.options.baseUrl = ApiRoutes.baseUrl;

    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.receiveTimeout = const Duration(seconds: 10);

    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestBody: true,
        responseBody: true,
        error: true,
      ),
    );
  }

  // 🔐 LOGIN
  Future<Response> postLogin(String email, String password) async {
    return await dio.post(
      ApiRoutes.login,
      data: {
        "email": email,
        "password": password,
      },
    );
  }

  // 👤 ME
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
    return await dio.get(
      ApiRoutes.patient(id),
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );
  }
}