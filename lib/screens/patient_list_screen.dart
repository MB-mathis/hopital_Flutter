import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class PatientListScreen extends StatefulWidget {
  const PatientListScreen({super.key});

  @override
  State<PatientListScreen> createState() => _PatientListScreenState();
}

class _PatientListScreenState extends State<PatientListScreen> {
  final AuthService auth = AuthService();

  List<dynamic> patients = [];
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchPatients();
  }

  Future<void> fetchPatients() async {
    try {
      final data = await auth.getPatients();

      if (!mounted) return;

      setState(() {
        patients = data;
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        error = "Erreur de chargement des patients";
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // 🔄 LOADING
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    // ❌ ERREUR
    if (error != null) {
      return Center(child: Text(error!));
    }

    // 📭 VIDE
    if (patients.isEmpty) {
      return const Center(child: Text("Aucun patient"));
    }

    // ✅ LISTE
    return ListView.builder(
      itemCount: patients.length,
      itemBuilder: (context, index) {
        final patient = patients[index];

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: ListTile(
            leading: const Icon(Icons.person),
            title: Text("${patient['prenom']} ${patient['nom']}"),
            subtitle: Text("Ville: ${patient['ville']}"),
            trailing: const Icon(Icons.arrow_forward_ios),

            onTap: () {
              // 👉 futur détail patient
            },
          ),
        );
      },
    );
  }
}