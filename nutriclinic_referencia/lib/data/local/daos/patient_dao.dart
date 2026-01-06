import 'package:drift/drift.dart';

import '../app_database.dart';

part 'patient_dao.g.dart';

@DriftAccessor(tables: [Patients])
class PatientDao extends DatabaseAccessor<AppDatabase> with _$PatientDaoMixin {
  PatientDao(AppDatabase db) : super(db);

  Future<List<Patient>> getAll() => select(patients).get();

  Future<Patient?> getById(String id) {
    return (select(patients)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  Future<void> insertOrUpdate(PatientsCompanion entity) {
    return into(patients).insertOnConflictUpdate(entity);
  }

  Future<void> deleteById(String id) {
    return (delete(patients)..where((tbl) => tbl.id.equals(id))).go();
  }
}
