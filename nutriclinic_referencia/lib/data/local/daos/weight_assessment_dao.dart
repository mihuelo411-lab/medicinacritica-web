import 'package:drift/drift.dart';

import '../app_database.dart';

part 'weight_assessment_dao.g.dart';

@DriftAccessor(tables: [WeightAssessments])
class WeightAssessmentDao extends DatabaseAccessor<AppDatabase>
    with _$WeightAssessmentDaoMixin {
  WeightAssessmentDao(AppDatabase db) : super(db);

  Future<WeightAssessment?> latestForPatient(String patientId) {
    return (select(weightAssessments)
          ..where((tbl) => tbl.patientId.equals(patientId))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)])
          ..limit(1))
        .getSingleOrNull();
  }

  Future<List<WeightAssessment>> historyForPatient(String patientId) {
    return (select(weightAssessments)
          ..where((tbl) => tbl.patientId.equals(patientId))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)]))
        .get();
  }

  Future<void> upsert(WeightAssessmentsCompanion entity) {
    return into(weightAssessments).insertOnConflictUpdate(entity);
  }
}
