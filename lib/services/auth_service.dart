import '../storage/secure_storage.dart';
import 'api_service.dart';

// Service d'authentification (auth_service.dart)

class AuthService {
  static final AuthService _instance = AuthService._internal();

  factory AuthService() => _instance;

  AuthService._internal();
  final ApiService api = ApiService();
  final SecureStorage storage = SecureStorage();

  String? _token;
  Map<String, dynamic>? _user;

  // 🔐 récupérer token (source unique)
  Future<String?> getToken() async {
    _token ??= await storage.getToken();
    return _token;
  }

  // 🔐 LOGIN
  Future<bool> login(String email, String password) async {
    try {
      final response = await api.postLogin(email, password);

      final token = response.data['token'];
      if (token == null || token.isEmpty) return false;

      _token = token;
      await storage.saveToken(token);

      // 🔥 charger user direct
      await fetchMe();

      return true;
    } catch (e) {
      print("Login error: $e");
      return false;
    }
  }

  Future<bool> fetchMe({bool forceRefresh = false}) async {
    // 🔥 CACHE : si user déjà chargé, on évite appel API
    if (_user != null && !forceRefresh) {
      return true;
    }

    final token = await getToken();
    if (token == null) return false;

    try {
      final response = await api.getMe(token);
      _user = response.data;
      return true;
    } catch (e) {
      print("FetchMe error: $e");
      _user = null;
      return false;
    }
  } 

  // 👤 getter user
  Map<String, dynamic>? getUser() => _user;

  // 🚪 logout
  Future<void> logout() async {
    _token = null;
    _user = null;
    await storage.deleteToken();
  }

  // ❓ est connecté
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }


  Future<List<dynamic>> getPatients() async {
    final token = await getToken();
    if (token == null) return [];

    try {
      final response = await api.getPatients(token);

      final data = response.data;

      // 🔥 CAS 1 : API renvoie directement une liste
      if (data is List) {
        return data;
      }

      // 🔥 CAS 2 : API Platform (fallback)
      if (data is Map && data['hydra:member'] != null) {
        return List.from(data['hydra:member']);
      }

      return [];
    } catch (e) {
      print("GetPatients error: $e");
      return [];
    }
  }
  Future<int> getPatientsCount() async {
    final patients = await getPatients();
    return patients.length;
  }
}
