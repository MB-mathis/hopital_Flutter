class ApiRoutes {
  // Routes de l'API (api_routes.dart)

  static const baseUrl = "https://declaratory-aleena-heatedly.ngrok-free.dev";

  // AUTH
  static const login = "/api/login_check";

  // USERS
  static const users = "/api/users";

  // CORE HOSPITAL (MVP important)
  static const patients = "/api/patients";
  static const consultations = "/api/consultations";
  static const dossierMedical = "/api/dossier_medicals";
  static const greffes = "/api/greffes";
  static const documents = "/api/documents";

  // MEDICAL STAFF
  static const chirurgiens = "/api/chirurgiens";
  static const donneurs = "/api/donneurs";

  // MEDICAL DATA
  static const serologies = "/api/serologies";
  static const prelevements = "/api/prelevements";
  static const groupeHLA = "/api/groupe_h_l_as";
  static const conditionnementImmunologiques =
      "/api/conditionnement_immunologiques";

  // SHARING
  static const patientUserShares = "/api/patient_user_shares";
}
