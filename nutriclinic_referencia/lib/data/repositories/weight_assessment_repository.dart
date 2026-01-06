import 'package:nutrivigil/domain/patient/weight_assessment.dart';

abstract class WeightAssessmentRepository {
  Future<WeightAssessment?> latestForPatient(String patientId);
  Future<List<WeightAssessment>> historyForPatient(String patientId);
  Future<void> save(WeightAssessment assessment);
}
