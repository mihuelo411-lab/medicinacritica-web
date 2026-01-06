import 'package:nutrivigil/domain/nutrition/nutritional_assessment.dart';

abstract class NutritionalAssessmentRepository {
  Future<NutritionalAssessment?> latestForPatient(String patientId);
  Future<void> saveAssessment(NutritionalAssessment assessment);
}
