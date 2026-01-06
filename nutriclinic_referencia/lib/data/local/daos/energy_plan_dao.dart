import 'package:drift/drift.dart';

import '../app_database.dart';

part 'energy_plan_dao.g.dart';

@DriftAccessor(tables: [EnergyPlans])
class EnergyPlanDao extends DatabaseAccessor<AppDatabase> with _$EnergyPlanDaoMixin {
  EnergyPlanDao(AppDatabase db) : super(db);

  Future<void> insertSnapshot(String id, String patientId, String json) {
    return into(energyPlans).insertOnConflictUpdate(
      EnergyPlansCompanion.insert(
        id: id,
        patientId: patientId,
        snapshotJson: json,
      ),
    );
  }

  Future<EnergyPlan?> latestForPatient(String patientId) {
    return (select(energyPlans)
          ..where((tbl) => tbl.patientId.equals(patientId))
          ..orderBy([(tbl) => OrderingTerm(expression: tbl.createdAt, mode: OrderingMode.desc)])
          ..limit(1))
        .getSingleOrNull();
  }

  Future<List<EnergyPlan>> historyForPatient(String patientId) {
    return (select(energyPlans)
          ..where((tbl) => tbl.patientId.equals(patientId))
          ..orderBy([(tbl) => OrderingTerm(expression: tbl.createdAt, mode: OrderingMode.desc)]))
        .get();
  }
}
