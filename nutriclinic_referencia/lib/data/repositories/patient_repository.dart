import '../../domain/patient/patient_entity.dart';

abstract class PatientRepository {
  Future<List<PatientProfile>> fetchAll();
  Future<PatientProfile?> fetchById(String id);
  Future<void> save(PatientProfile patient);
  Future<void> delete(String id);
}
