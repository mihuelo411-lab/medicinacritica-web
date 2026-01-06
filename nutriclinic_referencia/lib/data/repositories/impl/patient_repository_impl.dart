import 'package:nutrivigil/data/local/daos/patient_dao.dart';
import 'package:nutrivigil/data/mappers/patient_mapper.dart';
import 'package:nutrivigil/data/repositories/patient_repository.dart';
import 'package:nutrivigil/domain/patient/patient_entity.dart';

class PatientRepositoryImpl implements PatientRepository {
  PatientRepositoryImpl(this._dao);

  final PatientDao _dao;

  @override
  Future<List<PatientProfile>> fetchAll() async {
    final rows = await _dao.getAll();
    return rows.map((row) => row.toDomain()).toList();
  }

  @override
  Future<PatientProfile?> fetchById(String id) async {
    final row = await _dao.getById(id);
    return row?.toDomain();
  }

  @override
  Future<void> save(PatientProfile patient) async {
    final normalizedName = patient.fullName.trim();
    if (normalizedName.isEmpty) {
      throw Exception('El nombre del paciente es obligatorio');
    }
    final hasExistingId = patient.id.isNotEmpty;
    final current = patient.copyWith(
      id: hasExistingId ? patient.id : normalizedName,
      fullName: normalizedName,
    );

    await _dao.insertOrUpdate(current.toCompanion(isUpdate: hasExistingId));
  }

  @override
  Future<void> delete(String id) {
    return _dao.deleteById(id);
  }
}
