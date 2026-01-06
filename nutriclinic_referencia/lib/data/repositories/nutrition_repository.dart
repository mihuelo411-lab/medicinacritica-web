import '../../domain/nutrition/nutrition_requirements.dart';

abstract class NutritionRepository {
  Future<List<NutritionRequirements>> historyForPatient(String patientId);
  Future<void> save(NutritionRequirements requirements, String patientId);
}
