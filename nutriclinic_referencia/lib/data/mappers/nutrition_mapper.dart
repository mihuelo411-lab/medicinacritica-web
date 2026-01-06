import 'package:drift/drift.dart';

import '../../domain/nutrition/nutrition_requirements.dart';
import 'package:nutrivigil/data/local/app_database.dart';

extension NutritionRowMapper on NutritionTarget {
  NutritionRequirements toDomain() {
    return NutritionRequirements(
      method: method,
      caloriesPerDay: caloriesPerDay,
      proteinGrams: proteinGrams,
      notes: notes,
    );
  }
}

extension NutritionRequirementsMapper on NutritionRequirements {
  NutritionTargetsCompanion toCompanion({required String id, required String patientId}) {
    return NutritionTargetsCompanion(
      id: Value(id),
      patientId: Value(patientId),
      method: Value(method),
      caloriesPerDay: Value(caloriesPerDay),
      proteinGrams: Value(proteinGrams),
      notes: Value(notes),
      createdAt: Value(DateTime.now()),
    );
  }
}
