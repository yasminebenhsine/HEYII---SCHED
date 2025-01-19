

import 'package:heyiisched/Prof/model/DatModel.dart';

class ReclamationModel {
  String text;
  List<DatModel>? selectedDays;

  ReclamationModel({required this.text, this.selectedDays});

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'selectedDays': selectedDays?.map((day) => day.toJson()).toList(),
    };
  }
}