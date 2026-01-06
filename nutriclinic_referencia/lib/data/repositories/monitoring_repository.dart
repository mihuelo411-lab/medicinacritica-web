import '../../domain/monitoring/daily_monitoring_entry.dart';

abstract class MonitoringRepository {
  Future<List<DailyMonitoringEntry>> fetchByPatient(String patientId);
  Future<void> save(DailyMonitoringEntry entry);
  Future<void> delete(String entryId);
}
