import 'package:flutter_hopital/services/api_service.dart';
import 'package:flutter_hopital/services/auth_service.dart';

class PatientService {
  final ApiService api = ApiService();
  final AuthService auth = AuthService();

  // 📋 récupérer liste patients
  Future<List<dynamic>> getPatients() async {
    final token = await auth.getToken();

    // 🔒 sécurité
    if (token == null) {
      return [];
    }

    try {
      final response = await api.getPatients(token);

      final data = response.data;

      // ✅ CAS API classique
      if (data is List) {
        return data;
      }

      // ✅ CAS API Platform Hydra
      if (data is Map<String, dynamic> && data['hydra:member'] != null) {
        return List<dynamic>.from(data['hydra:member']);
      }

      return [];
    } catch (e) {
      print("GetPatients error: $e");
      return [];
    }
  }

  // 📊 compteur patients
  Future<int> getPatientsCount() async {
    final patients = await getPatients();
    return patients.length;
  }

  // 📋 récupérer un patient
  Future<Map<String, dynamic>?> getPatient(int id) async {
    final token = await auth.getToken();

    if (token == null) {
      return null;
    }

    try {
      final response = await api.getPatient(id, token);

      return response.data;
    } catch (e) {
      print("GetPatient error: $e");
      return null;
    }
  }
}
