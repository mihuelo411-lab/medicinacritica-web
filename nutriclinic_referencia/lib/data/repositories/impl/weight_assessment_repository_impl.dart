import 'package:uuid/uuid.dart';

import 'package:nutrivigil/data/local/daos/weight_assessment_dao.dart';
import 'package:nutrivigil/data/mappers/weight_assessment_mapper.dart';
import 'package:nutrivigil/data/repositories/weight_assessment_repository.dart';
import 'package:nutrivigil/domain/patient/weight_assessment.dart';

class WeightAssessmentRepositoryImpl implements WeightAssessmentRepository {
  WeightAssessmentRepositoryImpl(this._dao, {Uuid? uuid})
      : _uuid = uuid ?? const Uuid();

  final WeightAssessmentDao _dao;
  final Uuid _uuid;

  @override
  Future<List<WeightAssessment>> historyForPatient(String patientId) async {
    final rows = await _dao.historyForPatient(patientId);
    return rows.map((row) => row.toDomain()).toList();
  }

  @override
  Future<WeightAssessment?> latestForPatient(String patientId) async {
    final row = await _dao.latestForPatient(patientId);
    return row?.toDomain();
  }

  @override
  Future<void> save(WeightAssessment assessment) {
    final id = assessment.id.isEmpty ? _uuid.v4() : assessment.id;
    return _dao.upsert(assessment.copyWith(id: id).toCompanion());
  }
}
