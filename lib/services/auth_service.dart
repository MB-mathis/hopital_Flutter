import '../storage/secure_storage.dart';
import 'api_service.dart';

// Service d'authentification (auth_service.dart)

class AuthService {
  final ApiService api = ApiService();
  final SecureStorage storage = SecureStorage();

  Future<bool> login(String email, String password) async {
    try {
      final response = await api.postLogin(email, password);

      final token = response.data['token'] ?? '';
      if (token.isEmpty) return false;

      await storage.saveToken(token);

      return true;
    } catch (e) {
      print("Login error: $e");
      return false;
    }
  }

  Future<void> logout() async {
    await storage.deleteToken();
  }

  Future<bool> isLoggedIn() async {
    final token = await storage.getToken();
    return token != null;
  }
}
