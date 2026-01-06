import 'package:drift/drift.dart';

import '../../domain/patient/patient_entity.dart';
import 'package:nutrivigil/data/local/app_database.dart';

extension PatientRowMapper on Patient {
  PatientProfile toDomain() {
    return PatientProfile(
      id: id,
      fullName: fullName,
      age: age,
      sex: sex,
      diagnosis: diagnosis,
      weightKg: weightKg,
      heightCm: heightCm,
      bedNumber: bedNumber,
      supportType: supportType,
      notes: notes,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

extension PatientProfileMapper on PatientProfile {
  PatientsCompanion toCompanion({bool isUpdate = false}) {
    return PatientsCompanion(
      id: Value(id),
      fullName: Value(fullName),
      age: Value(age),
      sex: Value(sex),
      diagnosis: Value(diagnosis),
      weightKg: Value(weightKg),
      heightCm: Value(heightCm),
      bedNumber: Value(bedNumber),
      supportType: Value(supportType),
      notes: Value(notes),
      createdAt: createdAt != null
          ? Value(createdAt!)
          : (isUpdate ? const Value.absent() : const Value.absent()),
      updatedAt: Value(DateTime.now()),
    );
  }
}
