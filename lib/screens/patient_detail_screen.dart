import 'package:flutter/material.dart';
import 'package:flutter_hopital/services/patient_service.dart';
import 'package:flutter_hopital/widgets/info_widgets.dart';

class PatientDetailScreen extends StatefulWidget {
  final int patientId;

  const PatientDetailScreen({
    super.key,
    required this.patientId,
  });

  @override
  State<PatientDetailScreen> createState() => _PatientDetailScreenState();
}

class _PatientDetailScreenState extends State<PatientDetailScreen> {
  final PatientService service = PatientService();

  Map<String, dynamic>? patient;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPatient();
  }

  Future<void> _loadPatient() async {
    final data = await service.getPatient(widget.patientId);

    setState(() {
      patient = data;
      isLoading = false;
    });
  }

  String _formatDate(String? date) {
    if (date == null) return '';

    try {
      final parsed = DateTime.parse(date);
      return "${parsed.day.toString().padLeft(2, '0')}/"
          "${parsed.month.toString().padLeft(2, '0')}/"
          "${parsed.year}";
    } catch (_) {
      return date;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (patient == null) {
      return const Scaffold(
        body: Center(child: Text("Patient introuvable")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("${patient!['nom']} ${patient!['prenom']}"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Dossier patient",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const Divider(),

                const SectionTitle("Identité"),
                InfoRow(label: "Nom", value: patient!['nom'] ?? ''),
                InfoRow(label: "Prénom", value: patient!['prenom'] ?? ''),
                InfoRow(label: "Sexe", value: patient!['sexe'] ?? ''),
                InfoRow(
                  label: "Date naissance",
                  value: _formatDate(patient!['dateNaissance']),
                ),

                const SizedBox(height: 16),

                const SectionTitle("Contact"),
                InfoRow(label: "Téléphone", value: patient!['telephone'] ?? ''),
                InfoRow(label: "Email", value: patient!['email'] ?? ''),
                InfoRow(label: "Ville", value: patient!['ville'] ?? ''),
                InfoRow(label: "Code postal", value: patient!['codePostal'] ?? ''),

                const SizedBox(height: 16),

                const SectionTitle("Système"),
                InfoRow(
                  label: "Créé le",
                  value: _formatDate(patient!['createdAt']),
                ),
                InfoRow(label: "Créé par", value: patient!['createdBy'] ?? ''),
              ],
            ),
          ),
        ),
      ),
    );
  }
}