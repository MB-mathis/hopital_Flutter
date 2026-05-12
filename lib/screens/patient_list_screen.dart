import 'package:flutter/material.dart';
import '../services/patient_service.dart';
import 'patient_detail_screen.dart'; // IMPORTANT

class PatientListScreen extends StatefulWidget {
  const PatientListScreen({super.key});

  @override
  State<PatientListScreen> createState() => _PatientListScreenState();
}

class _PatientListScreenState extends State<PatientListScreen> {
  final PatientService patientService = PatientService();

  List<dynamic> patients = [];
  bool loading = true;
  String? error;

  bool _isFetching = false;

  @override
  void initState() {
    super.initState();
    fetchPatients();
  }

  Future<void> fetchPatients() async {
    if (_isFetching) return;

    _isFetching = true;

    try {
      setState(() {
        loading = true;
        error = null;
      });

      final data = await patientService.getPatients();

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
    } finally {
      _isFetching = false;
    }
  }

  Future<void> _onRefresh() async {
    await fetchPatients();
  }

  @override
  Widget build(BuildContext context) {
    if (loading && patients.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null && patients.isEmpty) {
      return Center(child: Text(error!));
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: patients.length,
        itemBuilder: (context, index) {
          final patient = patients[index];

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              leading: const Icon(Icons.person),
              title: Text("${patient['prenom']} ${patient['nom']}"),
              subtitle: Text("Ville: ${patient['ville'] ?? 'N/A'}"),
              trailing: const Icon(Icons.arrow_forward_ios),

              // ✅ ICI = bon endroit
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PatientDetailScreen(
                      patientId: patient['id'],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}