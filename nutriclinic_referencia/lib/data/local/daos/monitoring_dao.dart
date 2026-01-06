import 'package:drift/drift.dart';

import '../app_database.dart';

part 'monitoring_dao.g.dart';

@DriftAccessor(tables: [MonitoringEntries])
class MonitoringDao extends DatabaseAccessor<AppDatabase> with _$MonitoringDaoMixin {
  MonitoringDao(AppDatabase db) : super(db);

  Future<List<MonitoringEntry>> forPatient(String patientId) {
    return (select(monitoringEntries)..where((tbl) => tbl.patientId.equals(patientId))..orderBy([
            (tbl) => OrderingTerm(expression: tbl.date, mode: OrderingMode.desc),
          ])).get();
  }

  Future<void> addEntry(MonitoringEntriesCompanion entry) {
    return into(monitoringEntries).insertOnConflictUpdate(entry);
  }

  Future<void> deleteEntry(String entryId) {
    return (delete(monitoringEntries)..where((tbl) => tbl.id.equals(entryId))).go();
  }
}
