import 'package:dio/dio.dart';
import '../storage/secure_storage.dart';
import '../config/api_routes.dart';

// Service de communication avec l'API (api_service.dart)

class ApiService {
  final Dio dio = Dio();
  final SecureStorage storage = SecureStorage();

  ApiService() {
    dio.options.baseUrl = ApiRoutes.baseUrl;
  }

  // LOGIN
  Future<Response> postLogin(String email, String password) async {
    return await dio.post(
      ApiRoutes.login,
      data: {"email": email, "password": password},
    );
  }

  // ROUTE PROTÉGÉE
  Future<Response> getPatients() async {
    final token = await storage.getToken();

    return await dio.get(
      ApiRoutes.patients,
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }
}
