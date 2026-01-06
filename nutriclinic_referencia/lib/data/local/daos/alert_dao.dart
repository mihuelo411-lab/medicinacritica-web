import 'package:drift/drift.dart';

import '../app_database.dart';

part 'alert_dao.g.dart';

@DriftAccessor(tables: [Alerts])
class AlertDao extends DatabaseAccessor<AppDatabase> with _$AlertDaoMixin {
  AlertDao(AppDatabase db) : super(db);

  Future<List<Alert>> pendingAlerts() {
    return (select(alerts)..where((tbl) => tbl.resolved.equals(false))).get();
  }

  Future<List<Alert>> alertsForPatient(String patientId) {
    return (select(alerts)
          ..where((tbl) => tbl.patientId.equals(patientId))
          ..orderBy([(tbl) => OrderingTerm(expression: tbl.createdAt, mode: OrderingMode.desc)]))
        .get();
  }

  Future<void> upsertAlert(AlertsCompanion alert) {
    return into(alerts).insertOnConflictUpdate(alert);
  }

  Future<void> markResolved(String id) {
    return (update(alerts)..where((tbl) => tbl.id.equals(id))).write(const AlertsCompanion(resolved: Value(true)));
  }
}
