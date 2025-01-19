import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  /*Future<String> getEnseignantId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String enseignantId = prefs.getString('enseignantId') ?? '';
    print("Fetched enseignantId from SharedPreferencesService: $enseignantId");
    return enseignantId;
  }*/

  Future<void> storeEnseignantId(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('enseignantId', id);
    print("Enseignant ID stored in SharedPreferencesService: $id");
  }
  Future<String> getEnseignantId() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String enseignantId = prefs.getString('enseignantId') ?? '';  // Si non trouvé, retourne une chaîne vide
    print("Fetched enseignantId: $enseignantId");
    return enseignantId;
  } catch (e) {
    print("Erreur lors de la récupération de l'ID enseignant: $e");
    return '';  // Si erreur, retourne une chaîne vide
  }
}
}
