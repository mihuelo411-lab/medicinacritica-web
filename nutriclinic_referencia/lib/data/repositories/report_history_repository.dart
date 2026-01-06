import 'package:nutrivigil/domain/reporting/report_history_entry.dart';

abstract class ReportHistoryRepository {
  Future<List<ReportHistoryEntry>> fetchAll();
  Future<void> save(ReportHistoryEntry entry);
  Future<void> delete(String id);
}
