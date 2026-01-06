import 'package:uuid/uuid.dart';

import 'package:nutrivigil/data/local/daos/nutrition_target_dao.dart';
import 'package:nutrivigil/data/mappers/nutrition_mapper.dart';
import 'package:nutrivigil/data/repositories/nutrition_repository.dart';
import 'package:nutrivigil/domain/nutrition/nutrition_requirements.dart';

class NutritionRepositoryImpl implements NutritionRepository {
  NutritionRepositoryImpl(this._dao, {Uuid? uuid}) : _uuid = uuid ?? const Uuid();

  final NutritionTargetDao _dao;
  final Uuid _uuid;

  @override
  Future<List<NutritionRequirements>> historyForPatient(String patientId) async {
    final rows = await _dao.allForPatient(patientId);
    return rows.map((row) => row.toDomain()).toList();
  }

  @override
  Future<void> save(NutritionRequirements requirements, String patientId) {
    final id = _uuid.v4();
    return _dao.saveTarget(requirements.toCompanion(id: id, patientId: patientId));
  }
}
