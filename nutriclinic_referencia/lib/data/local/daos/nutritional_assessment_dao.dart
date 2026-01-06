import 'package:drift/drift.dart';

import '../app_database.dart';

part 'nutritional_assessment_dao.g.dart';

@DriftAccessor(tables: [NutritionalAssessments])
class NutritionalAssessmentDao extends DatabaseAccessor<AppDatabase>
    with _$NutritionalAssessmentDaoMixin {
  NutritionalAssessmentDao(AppDatabase db) : super(db);

  Future<NutritionalAssessment?> latestForPatient(String patientId) {
    return (select(nutritionalAssessments)
          ..where((tbl) => tbl.patientId.equals(patientId))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)])
          ..limit(1))
        .getSingleOrNull();
  }

  Future<void> upsert(NutritionalAssessmentsCompanion companion) {
    return into(nutritionalAssessments).insertOnConflictUpdate(companion);
  }
}
