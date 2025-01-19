

import 'package:heyiisched/Prof/model/DatModel.dart';
import 'package:heyiisched/Prof/model/TimeRange.dart';

class VoeuxModel {
  List<DatModel>? selectedDays; // List of DatModel for days and time ranges
  List<String>? selectedSubjects; // List of selected subjects (matieres)

  VoeuxModel({this.selectedDays, this.selectedSubjects});

  // Convert VoeuxModel to JSON-compatible map
  Map<String, dynamic> toJson() {
    return {
      'selectedDays': selectedDays?.map((dat) => dat.toJson()).toList(),
      'selectedSubjects': selectedSubjects,
    };
  }

  // Method to convert Map<String, TimeRange> to List<DatModel>
  void setSelectedDaysFromMap(Map<String, TimeRange> map) {
    selectedDays = map.entries.map((entry) {
      DateTime debutHeure = entry.value.debutHeure;
      DateTime finHeure = entry.value.finHeure;

      // Get the corresponding Jour enum from the day string
      Jour jour = _getJourFromString(entry.key);

      return DatModel(
        idDate: selectedDays?.length ?? 0, // Ensure idDate is correctly set
        jour: jour,
        debutHeure: debutHeure,
        finHeure: finHeure,
      );
    }).toList();
  }

  // Helper method to convert string to Jour enum
  Jour _getJourFromString(String jourStr) {
    switch (jourStr) {
      case 'Lundi':
        return Jour.Lundi;
      case 'Mardi':
        return Jour.Mardi;
      case 'Mercredi':
        return Jour.Mercredi;
      case 'Jeudi':
        return Jour.Jeudi;
      case 'Vendredi':
        return Jour.Vendredi;
      case 'Samedi':
        return Jour.Samedi;
      case 'Dimanche':
        return Jour.Dimanche;
      default:
        throw ArgumentError('Invalid day: $jourStr');
    }
  }
}