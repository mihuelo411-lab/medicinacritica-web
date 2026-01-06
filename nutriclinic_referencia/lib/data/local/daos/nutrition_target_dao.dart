import 'package:drift/drift.dart';

import '../app_database.dart';

part 'nutrition_target_dao.g.dart';

@DriftAccessor(tables: [NutritionTargets])
class NutritionTargetDao extends DatabaseAccessor<AppDatabase> with _$NutritionTargetDaoMixin {
  NutritionTargetDao(AppDatabase db) : super(db);

  Future<List<NutritionTarget>> allForPatient(String patientId) {
    return (select(nutritionTargets)..where((tbl) => tbl.patientId.equals(patientId))..orderBy([
            (tbl) => OrderingTerm(expression: tbl.createdAt, mode: OrderingMode.desc),
          ])).get();
  }

  Future<void> saveTarget(NutritionTargetsCompanion target) {
    return into(nutritionTargets).insertOnConflictUpdate(target);
  }
}
