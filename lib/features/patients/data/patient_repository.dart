import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../../../../core/database/database.dart';
import 'package:drift/drift.dart';
import '../../../../core/services/supabase_service.dart';

abstract class PatientRepository {
  Future<List<Patient>> searchPatients(String query);
  Future<Patient?> getPatientByDni(String dni);
  Future<int> createOrUpdatePatient(PatientsCompanion patient);
  Future<int> saveAdmission(AdmissionsCompanion admission);
  Future<bool> updateAdmission(AdmissionsCompanion admission);
  Future<List<ActiveAdmission>> getActiveAdmissions();
  Future<void> syncFromSupabase();
}

class ActiveAdmission {
  final Patient patient;
  final Admission admission;
  ActiveAdmission(this.patient, this.admission);
}

class LocalPatientRepository implements PatientRepository {
  final AppDatabase db;

  LocalPatientRepository(this.db);

  @override
  Future<List<Patient>> searchPatients(String query) {
    return (db.select(db.patients)
      ..where((tbl) => tbl.name.contains(query) | tbl.dni.contains(query) | tbl.hc.contains(query))
      ..limit(10))
      .get();
  }

  @override
  Future<Patient?> getPatientByDni(String dni) {
    return (db.select(db.patients)..where((tbl) => tbl.dni.equals(dni))).getSingleOrNull();
  }

  @override
  Future<int> createOrUpdatePatient(PatientsCompanion patient) async {
    // Upsert logic: Check if DNI exists
    final existing = await getPatientByDni(patient.dni.value);
    if (existing != null) {
      // Update and return ID
      await (db.update(db.patients)..where((tbl) => tbl.id.equals(existing.id))).write(patient);
      return existing.id;
    } else {
      // Create and return new ID
      return db.into(db.patients).insert(patient);
    }
  }

  @override
  Future<int> saveAdmission(AdmissionsCompanion admission) {
    return db
        .into(db.admissions)
        .insert(admission, mode: InsertMode.insertOrReplace);
  }

  @override
  Future<bool> updateAdmission(AdmissionsCompanion admission) async {
    // Ensure ID is present for update
    if (!admission.id.present) return false;
    return await (db.update(db.admissions)..where((tbl) => tbl.id.equals(admission.id.value))).write(admission) > 0;
  }

  @override
  Future<List<ActiveAdmission>> getActiveAdmissions() async {
    final query = db.select(db.admissions).join([
      innerJoin(db.patients, db.patients.id.equalsExp(db.admissions.patientId))
    ]);
    // Filter for active (not discharged) and assigned beds
    query.where(db.admissions.dischargedAt.isNull() & db.admissions.bedNumber.isNotNull());
    
    final rows = await query.get();
    return rows.map((row) {
      return ActiveAdmission(
        row.readTable(db.patients),
        row.readTable(db.admissions),
      );
    }).toList();
  }

  // Sync Logic
  @override
  Future<void> syncFromSupabase() async {
    try {
      final activeList = await SupabaseService().fetchActiveAdmissions();

      debugPrint('Syncing ${activeList.length} admissions from Cloud...');

      final Set<int> remoteActiveIds = {};

      for (var data in activeList) {
        final Map<String, dynamic> pData = Map<String, dynamic>.from(data['patients'] ?? {});

        // 1. Upsert Patient
        final patientCompanion = PatientsCompanion(
          dni: Value(pData['dni']),
          name: Value(pData['name']),
          hc: Value(pData['hc']),
          age: Value(pData['age'] ?? 0),
          sex: Value(pData['sex'] ?? 'Masculino'),
          address: Value(pData['address']),
          occupation: Value(pData['occupation']),
          phone: Value(pData['phone']),
          familyContact: Value(pData['family_contact']),
          placeOfBirth: Value(pData['place_of_birth']),
          insuranceType: Value(pData['insurance_type']),
          isSynced: const Value(true),
        );

        final localPatientId = await createOrUpdatePatient(patientCompanion);
        final remoteAdmissionId = data['id'] as int?;
        if (remoteAdmissionId == null) continue;
        remoteActiveIds.add(remoteAdmissionId);

        // 2. Upsert Admission ensuring local id == remote id
        final admissionCompanion = AdmissionsCompanion(
          id: Value(remoteAdmissionId),
          patientId: Value(localPatientId),
          bedNumber: Value(data['bed_number']),
          admissionDate: Value(DateTime.tryParse('${data['admission_date']}') ?? DateTime.now()),
          diagnosis: Value(data['diagnosis']),
          sofaScore: Value((data['sofa_score'] as num?)?.toDouble()),
          apacheScore: Value((data['apache_score'] as num?)?.toDouble()),
          nutricScore: Value((data['nutric_score'] as num?)?.toDouble()),
          sofaMortality: Value(data['sofa_mortality']),
          apacheMortality: Value(data['apache_mortality']),
          signsSymptoms: Value(data['signs_symptoms']),
          timeOfDisease: Value(data['time_of_disease']),
          illnessStart: Value(data['illness_start']),
          illnessCourse: Value(data['illness_course']),
          story: Value(data['story']),
          physicalExam: Value(data['physical_exam']),
          plan: Value(data['plan']),
          procedures: Value(data['procedures']),
          uciPriority: Value(data['uci_priority']),
          vitalsJson: Value(_stringifyJsonField(data['vitals_json'])),
          bp: Value(data['bp']),
          hr: Value(data['hr']),
          rr: Value(data['rr']),
          o2Sat: Value(data['o2_sat']),
          temp: Value(data['temp']),
          isSynced: const Value(true),
        );

        final localAdmissionId = await _upsertAdmissionWithRemoteId(
          admissionCompanion: admissionCompanion,
          bedNumber: data['bed_number'] as int?,
          expectedPatientId: localPatientId,
        );

        if (localAdmissionId != null) {
          await _syncEvolutionsForAdmission(
            localAdmissionId: localAdmissionId,
            remoteAdmissionId: remoteAdmissionId,
          );
        }
      }

      await _markLocallyOccupiedBedsNotIn(remoteActiveIds);
      debugPrint('Sync Complete.');
    } catch (e) {
      debugPrint('Sync Error: $e');
    }
  }

  Future<void> _markLocallyOccupiedBedsNotIn(Set<int> remoteActiveIds) async {
    final stillOccupied = await (db.select(db.admissions)
          ..where((tbl) => tbl.dischargedAt.isNull())
          ..where((tbl) => tbl.bedNumber.isNotNull())
          ..where((tbl) => tbl.isSynced.equals(true)))
        .get();

    final missingIds = stillOccupied
        .where((admission) => !remoteActiveIds.contains(admission.id))
        .map((admission) => admission.id)
        .toList();
    if (missingIds.isEmpty) return;

    final remoteStatuses = await SupabaseService().fetchAdmissionsByIds(missingIds);
    final statusById = <int, Map<String, dynamic>>{};
    for (final status in remoteStatuses) {
      final id = status['id'] as int?;
      if (id != null) statusById[id] = status;
    }

    final now = DateTime.now();
    for (final id in missingIds) {
      final remote = statusById[id];
      final dischargedAt = remote != null
          ? DateTime.tryParse(remote['discharged_at']?.toString() ?? '') ?? now
          : now;
      await (db.update(db.admissions)..where((tbl) => tbl.id.equals(id))).write(
        AdmissionsCompanion(
          bedNumber: const Value<int?>(null),
          dischargedAt: Value(dischargedAt),
          isSynced: const Value(true),
        ),
      );
    }
  }

  Future<int?> _upsertAdmissionWithRemoteId({
    required AdmissionsCompanion admissionCompanion,
    required int? bedNumber,
    required int expectedPatientId,
  }) async {
    final remoteId = admissionCompanion.id.present ? admissionCompanion.id.value : null;
    if (remoteId == null) {
      return db.into(db.admissions).insert(admissionCompanion);
    }

    final existingById = await (db.select(db.admissions)..where((tbl) => tbl.id.equals(remoteId))).getSingleOrNull();
    if (existingById != null) {
      await (db.update(db.admissions)..where((tbl) => tbl.id.equals(remoteId))).write(admissionCompanion);
      return remoteId;
    }

    Admission? existingByBed;
    if (bedNumber != null) {
      existingByBed = await (db.select(db.admissions)
            ..where((tbl) => tbl.bedNumber.equals(bedNumber))
            ..where((tbl) => tbl.dischargedAt.isNull()))
          .getSingleOrNull();
    }

    if (existingByBed != null) {
      if (existingByBed.id == remoteId) {
        await (db.update(db.admissions)..where((tbl) => tbl.id.equals(remoteId))).write(admissionCompanion);
        return remoteId;
      }
      if (existingByBed.patientId == expectedPatientId) {
        final previousId = existingByBed.id;
        await db.transaction(() async {
          await db.into(db.admissions).insert(admissionCompanion);
          await (db.update(db.evolutions)..where((tbl) => tbl.admissionId.equals(previousId)))
              .write(EvolutionsCompanion(admissionId: Value(remoteId)));
          await (db.delete(db.admissions)..where((tbl) => tbl.id.equals(previousId))).go();
        });
        return remoteId;
      }
    }

    await db.into(db.admissions).insert(admissionCompanion);
    return remoteId;
  }

  Future<void> _syncEvolutionsForAdmission({
    required int localAdmissionId,
    required int remoteAdmissionId,
  }) async {
    final remoteEvolutions = await SupabaseService().fetchEvolutionsForAdmission(remoteAdmissionId);
    if (remoteEvolutions.isEmpty) return;

    await db.transaction(() async {
      await (db.delete(db.evolutions)..where((tbl) => tbl.admissionId.equals(localAdmissionId))).go();
      for (final evo in remoteEvolutions) {
        await db.into(db.evolutions).insert(
          EvolutionsCompanion(
            admissionId: Value(localAdmissionId),
            date: Value(DateTime.tryParse('${evo['date']}') ?? DateTime.now()),
            dayOfStay: Value(evo['day_of_stay'] as int?),
            vitalsJson: Value(_stringifyJsonField(evo['vitals_json'])),
            vmSettingsJson: Value(_stringifyJsonField(evo['vm_settings_json'])),
            vmMechanicsJson: Value(_stringifyJsonField(evo['vm_mechanics_json'])),
            subjective: Value(evo['subjective'] as String?),
            objectiveJson: Value(_stringifyJsonField(evo['objective_json'])),
            analysis: Value(evo['analysis'] as String?),
            plan: Value(evo['plan'] as String?),
            diagnosis: Value(evo['diagnosis'] as String?),
            authorName: Value(evo['author_name'] as String?),
            authorRole: Value(evo['author_role'] as String?),
            isSynced: const Value(true),
          ),
        );
      }
    });
  }

  String? _stringifyJsonField(dynamic value) {
    if (value == null) return null;
    if (value is String) {
      return value.isEmpty ? null : value;
    }
    try {
      return jsonEncode(value);
    } catch (_) {
      return value.toString();
    }
  }
}
