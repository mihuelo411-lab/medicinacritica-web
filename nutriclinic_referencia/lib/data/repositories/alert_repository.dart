import '../../domain/alerts/alert_entity.dart';

abstract class AlertRepository {
  Future<List<AlertItem>> fetchPending();
  Future<List<AlertItem>> fetchByPatient(String patientId);
  Future<void> save(AlertItem alert);
  Future<void> markResolved(String id);
}
