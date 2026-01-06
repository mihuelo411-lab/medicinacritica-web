import 'package:uuid/uuid.dart';

import 'package:nutrivigil/data/local/daos/nutritional_assessment_dao.dart';
import 'package:nutrivigil/data/mappers/nutritional_assessment_mapper.dart';
import 'package:nutrivigil/data/repositories/nutritional_assessment_repository.dart';
import 'package:nutrivigil/domain/nutrition/nutritional_assessment.dart';

class NutritionalAssessmentRepositoryImpl
    implements NutritionalAssessmentRepository {
  NutritionalAssessmentRepositoryImpl(this._dao, {Uuid? uuid})
      : _uuid = uuid ?? const Uuid();

  final NutritionalAssessmentDao _dao;
  final Uuid _uuid;

  @override
  Future<NutritionalAssessment?> latestForPatient(String patientId) async {
    final row = await _dao.latestForPatient(patientId);
    return row?.toDomain();
  }

  @override
  Future<void> saveAssessment(NutritionalAssessment assessment) {
    final entity = assessment.id.isEmpty
        ? assessment.copyWith(id: _uuid.v4())
        : assessment;
    return _dao.upsert(entity.toCompanion());
  }
}
