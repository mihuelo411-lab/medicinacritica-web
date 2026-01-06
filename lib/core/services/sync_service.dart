import 'dart:convert';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/foundation.dart';
import '../database/database.dart';
import 'supabase_service.dart';

class SyncService {
  final AppDatabase db;
  final SupabaseService supabase;

  SyncService(this.db, this.supabase);

  Future<void> syncAll() async {
    await _pushLocalChanges();
    await _pullRemoteState();
  }

  Future<void> _pushLocalChanges() async {
    // Empuja solo registros pendientes para optimizar tráfico y evitar conflictos
    final patients = await (db.select(db.patients)..where((tbl) => tbl.isSynced.equals(false))).get();
    if (patients.isNotEmpty) {
      await supabase.upsertPatients(patients);
      await _markPatientsSynced(patients.map((e) => e.id).toList());
    }

    final admissions = await (db.select(db.admissions)..where((tbl) => tbl.isSynced.equals(false))).get();
    if (admissions.isNotEmpty) {
      await supabase.upsertAdmissions(admissions);
      await _markAdmissionsSynced(admissions.map((e) => e.id).toList());
    }

    final evolutions = await (db.select(db.evolutions)..where((tbl) => tbl.isSynced.equals(false))).get();
    if (evolutions.isNotEmpty) {
      await supabase.upsertEvolutions(evolutions);
      await _markEvolutionsSynced(evolutions.map((e) => e.id).toList());
    }

    final indicationSheets = await (db.select(db.indicationSheets)..where((tbl) => tbl.isSynced.equals(false))).get();
    if (indicationSheets.isNotEmpty) {
      await supabase.upsertIndicationSheets(indicationSheets);
      await _markIndicationSheetsSynced(indicationSheets.map((e) => e.id).toList());
    }

    final epicrisisNotes = await (db.select(db.epicrisisNotes)..where((tbl) => tbl.isSynced.equals(false))).get();
    if (epicrisisNotes.isNotEmpty) {
      await supabase.upsertEpicrisisNotes(epicrisisNotes);
      await _markEpicrisisNotesSynced(epicrisisNotes.map((e) => e.id).toList());
    }

    final performedProcedures = await (db.select(db.performedProcedures)
          ..where((tbl) => tbl.isSynced.equals(false)))
        .get();
    if (performedProcedures.isNotEmpty) {
      await supabase.upsertPerformedProcedures(performedProcedures);
      await _markPerformedProceduresSynced(
        performedProcedures.map((e) => e.id).toList(),
      );
    }

    final examTemplates = await (db.select(db.examTemplates)..where((tbl) => tbl.isSynced.equals(false))).get();
    if (examTemplates.isNotEmpty) {
      await supabase.upsertExamTemplates(examTemplates);
      await _markExamTemplatesSynced(examTemplates.map((e) => e.id).toList());
    }

    final examResults = await (db.select(db.examResults)..where((tbl) => tbl.isSynced.equals(false))).get();
    if (examResults.isNotEmpty) {
      await supabase.upsertExamResults(examResults);
      await _markExamResultsSynced(examResults.map((e) => e.id).toList());
    }
  }

  Future<void> _pullRemoteState() async {
    final remotePatients = await supabase.fetchPatients();
    final remoteAdmissions = await supabase.fetchAdmissions();
    final remoteEvolutions = await supabase.fetchEvolutions();
    final remoteIndicationSheets = await supabase.fetchIndicationSheets();
    final remoteEpicrisisNotes = await supabase.fetchEpicrisisNotes();
    final remotePerformedProcedures =
        await supabase.fetchPerformedProcedures();
    final remoteExamTemplates = await supabase.fetchExamTemplates();
    final remoteExamResults = await supabase.fetchExamResults();

    await db.transaction(() async {
      for (final p in remotePatients) {
        final remoteId = p['id'] as int?;
        if (remoteId == null) continue;
        final remoteDni = (p['dni'] as String?)?.trim();
        final remoteHc = (p['hc'] as String?)?.trim();

        var conflictingLocalId = await _preparePatientForRemoteInsert(
          remoteId: remoteId,
          dni: remoteDni,
          hc: remoteHc,
        );

        final companion = PatientsCompanion(
          id: drift.Value(remoteId),
          dni: drift.Value(remoteDni ?? ''),
          name: drift.Value(p['name'] ?? ''),
          hc: drift.Value(remoteHc ?? ''),
          age: drift.Value(p['age'] ?? 0),
          sex: drift.Value(p['sex'] ?? 'Desconocido'),
          address: drift.Value(p['address']),
          occupation: drift.Value(p['occupation']),
          phone: drift.Value(p['phone']),
          familyContact: drift.Value(p['family_contact']),
          placeOfBirth: drift.Value(p['place_of_birth']),
          insuranceType: drift.Value(p['insurance_type']),
          createdAt: drift.Value(DateTime.tryParse(p['created_at'] ?? '') ?? DateTime.now()),
          updatedAt: drift.Value(DateTime.tryParse(p['updated_at'] ?? '') ?? DateTime.now()),
          isSynced: const drift.Value(true),
        );

        Future<void> performInsert() async {
          await db.into(db.patients).insertOnConflictUpdate(companion);
        }

        try {
          await performInsert();
        } catch (error) {
          final retryConflictId = await _tryResolvePatientUniqueConflict(
            error: error,
            remoteId: remoteId,
            dni: remoteDni,
            hc: remoteHc,
          );
          if (retryConflictId == null) rethrow;
          conflictingLocalId ??= retryConflictId;
          await performInsert();
        }

        if (conflictingLocalId != null) {
          final oldId = conflictingLocalId!;
          await _relinkAdmissionsForPatient(
            oldPatientId: oldId,
            newPatientId: remoteId,
          );
          await (db.delete(db.patients)..where((tbl) => tbl.id.equals(oldId))).go();
        }
      }

      for (final a in remoteAdmissions) {
        await db.into(db.admissions).insertOnConflictUpdate(
          AdmissionsCompanion(
            id: drift.Value(a['id']),
            patientId: drift.Value(a['patient_id']),
            admissionDate: drift.Value(DateTime.tryParse(a['admission_date'] ?? '') ?? DateTime.now()),
            sofaScore: drift.Value((a['sofa_score'] as num?)?.toDouble()),
            apacheScore: drift.Value((a['apache_score'] as num?)?.toDouble()),
            nutricScore: drift.Value((a['nutric_score'] as num?)?.toDouble()),
            sofaMortality: drift.Value(a['sofa_mortality']),
            apacheMortality: drift.Value(a['apache_mortality']),
            diagnosis: drift.Value(a['diagnosis']),
            signsSymptoms: drift.Value(a['signs_symptoms']),
            timeOfDisease: drift.Value(a['time_of_disease']),
            illnessStart: drift.Value(a['illness_start']),
            illnessCourse: drift.Value(a['illness_course']),
            story: drift.Value(a['story']),
            physicalExam: drift.Value(a['physical_exam']),
            plan: drift.Value(a['plan']),
            bp: drift.Value(a['bp']),
            hr: drift.Value(a['hr']),
            rr: drift.Value(a['rr']),
            o2Sat: drift.Value(a['o2_sat']),
            temp: drift.Value(a['temp']),
            vitalsJson: drift.Value(_jsonToString(a['vitals_json'])),
            procedures: drift.Value(a['procedures']),
            bedNumber: drift.Value(a['bed_number']),
            dischargedAt: drift.Value(DateTime.tryParse(a['discharged_at'] ?? '')),
            uciPriority: drift.Value(a['uci_priority']),
            status: drift.Value(a['status']?.toString() ?? 'activo'),
            isReadmission: drift.Value(a['is_readmission'] == true),
            createdAt: drift.Value(DateTime.tryParse(a['created_at'] ?? '') ?? DateTime.now()),
            isSynced: const drift.Value(true),
          ),
        );
      }

      for (final ev in remoteEvolutions) {
        await db.into(db.evolutions).insertOnConflictUpdate(
          EvolutionsCompanion(
            id: drift.Value(ev['id']),
            admissionId: drift.Value(ev['admission_id']),
            date: drift.Value(DateTime.tryParse(ev['date'] ?? '') ?? DateTime.now()),
            dayOfStay: drift.Value(ev['day_of_stay']),
            vitalsJson: drift.Value(_jsonToString(ev['vitals_json'])),
            vmSettingsJson: drift.Value(_jsonToString(ev['vm_settings_json'])),
            vmMechanicsJson: drift.Value(_jsonToString(ev['vm_mechanics_json'])),
            subjective: drift.Value(ev['subjective']),
            objectiveJson: drift.Value(_jsonToString(ev['objective_json'])),
            analysis: drift.Value(ev['analysis']),
          plan: drift.Value(ev['plan']),
          diagnosis: drift.Value(ev['diagnosis']),
          authorName: drift.Value(ev['author_name']),
          authorRole: drift.Value(ev['author_role']),
          proceduresNote: drift.Value(ev['procedures_note']),
          createdAt: drift.Value(DateTime.tryParse(ev['created_at'] ?? '') ?? DateTime.now()),
          isSynced: const drift.Value(true),
        ),
      );
      }

      for (final sheet in remoteIndicationSheets) {
        await db.into(db.indicationSheets).insertOnConflictUpdate(
          IndicationSheetsCompanion(
            id: drift.Value(sheet['id']),
            admissionId: drift.Value(sheet['admission_id']),
            payload: drift.Value(sheet['payload'] ?? '{}'),
            createdAt: drift.Value(DateTime.tryParse(sheet['created_at'] ?? '') ?? DateTime.now()),
            isSynced: const drift.Value(true),
          ),
        );
      }

      for (final note in remoteEpicrisisNotes) {
        await db.into(db.epicrisisNotes).insertOnConflictUpdate(
          EpicrisisNotesCompanion(
            id: drift.Value(note['id']),
            admissionId: drift.Value(note['admission_id']),
            payload: drift.Value(note['payload'] ?? '{}'),
            createdAt: drift.Value(DateTime.tryParse(note['created_at'] ?? '') ?? DateTime.now()),
            updatedAt: drift.Value(DateTime.tryParse(note['updated_at'] ?? '') ?? DateTime.now()),
            isSynced: const drift.Value(true),
          ),
        );
      }

      for (final proc in remotePerformedProcedures) {
        await db.into(db.performedProcedures).insertOnConflictUpdate(
              PerformedProceduresCompanion(
                id: drift.Value(proc['id']),
                admissionId: drift.Value(proc['admission_id']),
                procedureId: drift.Value(proc['procedure_id']),
                procedureName: drift.Value(proc['procedure_name'] ?? ''),
                performedAt: drift.Value(
                  DateTime.tryParse(proc['performed_at'] ?? '') ??
                      DateTime.now(),
                ),
                assistant: drift.Value(proc['assistant']),
                resident: drift.Value(proc['resident']),
                origin: drift.Value(proc['origin']),
                guardia: drift.Value(proc['guardia']),
                note: drift.Value(proc['note']),
                createdAt: drift.Value(
                  DateTime.tryParse(proc['created_at'] ?? '') ??
                      DateTime.now(),
                ),
                isSynced: const drift.Value(true),
              ),
            );
      }

      for (final template in remoteExamTemplates) {
        final fieldsJsonRaw = template['fields_json'];
        await db.into(db.examTemplates).insertOnConflictUpdate(
          ExamTemplatesCompanion(
            id: drift.Value(template['id']),
            name: drift.Value(template['name'] ?? ''),
            category: drift.Value(template['category']),
            description: drift.Value(template['description']),
            fieldsJson: drift.Value(
              fieldsJsonRaw is String
                  ? fieldsJsonRaw
                  : jsonEncode(fieldsJsonRaw ?? []),
            ),
            version: drift.Value(template['version'] ?? 1),
            isArchived: drift.Value(template['is_archived'] == true),
            createdBy: drift.Value(template['created_by']),
            createdAt: drift.Value(DateTime.tryParse(template['created_at'] ?? '') ?? DateTime.now()),
            updatedAt: drift.Value(DateTime.tryParse(template['updated_at'] ?? '') ?? DateTime.now()),
            isSynced: const drift.Value(true),
          ),
        );
      }

      for (final result in remoteExamResults) {
        await db.into(db.examResults).insertOnConflictUpdate(
          ExamResultsCompanion(
            id: drift.Value(result['id']),
            admissionId: drift.Value(result['admission_id']),
            templateId: drift.Value(result['template_id']),
            templateVersion: drift.Value(result['template_version'] ?? 1),
            recordedAt: drift.Value(DateTime.tryParse(result['recorded_at'] ?? '') ?? DateTime.now()),
            valuesJson: drift.Value(result['values_json'] ?? '{}'),
            note: drift.Value(result['note']),
            attachments: drift.Value(result['attachments']),
            recordedBy: drift.Value(result['recorded_by']),
            createdAt: drift.Value(DateTime.tryParse(result['created_at'] ?? '') ?? DateTime.now()),
            isSynced: const drift.Value(true),
          ),
        );
      }
    });
  }

  Future<int?> _preparePatientForRemoteInsert({
    required int remoteId,
    String? dni,
    String? hc,
  }) async {
    final existingById = await (db.select(db.patients)
          ..where((tbl) => tbl.id.equals(remoteId)))
        .getSingleOrNull();
    if (existingById != null) return null;

    Patient? conflict;
    if (dni != null && dni.isNotEmpty) {
      conflict = await (db.select(db.patients)
            ..where((tbl) => tbl.dni.equals(dni)))
          .getSingleOrNull();
    }
    if (conflict == null && hc != null && hc.isNotEmpty) {
      conflict = await (db.select(db.patients)
            ..where((tbl) => tbl.hc.equals(hc)))
          .getSingleOrNull();
    }
    final resolvedConflict = conflict;
    if (resolvedConflict == null) return null;

    final suffix = '${DateTime.now().microsecondsSinceEpoch}_${resolvedConflict.id}';
    debugPrint(
      'Conflicto de paciente local ${resolvedConflict.id} (dni: ${resolvedConflict.dni}, hc: ${resolvedConflict.hc}) '
      'al sincronizar remoto $remoteId. Rebautizando temporalmente para conservar datos locales.',
    );
    await (db.update(db.patients)..where((tbl) => tbl.id.equals(resolvedConflict.id))).write(
      PatientsCompanion(
        dni: drift.Value('__local_conflict_dni_$suffix'),
        hc: drift.Value('__local_conflict_hc_$suffix'),
      ),
    );
    return resolvedConflict.id;
  }

  Future<void> _relinkAdmissionsForPatient({
    required int oldPatientId,
    required int newPatientId,
  }) async {
    await (db.update(db.admissions)
          ..where((tbl) => tbl.patientId.equals(oldPatientId)))
        .write(
      AdmissionsCompanion(patientId: drift.Value(newPatientId)),
    );
  }

  Future<int?> _tryResolvePatientUniqueConflict({
    required Object error,
    required int remoteId,
    String? dni,
    String? hc,
  }) async {
    final text = error.toString().toLowerCase();
    final isPatientConstraint = text.contains('patients.dni') || text.contains('patients.hc');
    if (!isPatientConstraint) return null;
    return _preparePatientForRemoteInsert(
      remoteId: remoteId,
      dni: dni,
      hc: hc,
    );
  }

  String? _jsonToString(dynamic val) {
    if (val == null) return null;
    if (val is String) return val;
    try {
      return jsonEncode(val);
    } catch (_) {
      return val.toString();
    }
  }

  Future<void> _markPatientsSynced(List<int> ids) async {
    if (ids.isEmpty) return;
    await (db.update(db.patients)..where((t) => t.id.isIn(ids))).write(const PatientsCompanion(isSynced: drift.Value(true)));
  }

  Future<void> _markAdmissionsSynced(List<int> ids) async {
    if (ids.isEmpty) return;
    await (db.update(db.admissions)..where((t) => t.id.isIn(ids))).write(const AdmissionsCompanion(isSynced: drift.Value(true)));
  }

  Future<void> _markEvolutionsSynced(List<int> ids) async {
    if (ids.isEmpty) return;
    await (db.update(db.evolutions)..where((t) => t.id.isIn(ids))).write(const EvolutionsCompanion(isSynced: drift.Value(true)));
  }

  Future<void> _markIndicationSheetsSynced(List<int> ids) async {
    if (ids.isEmpty) return;
    await (db.update(db.indicationSheets)..where((t) => t.id.isIn(ids))).write(const IndicationSheetsCompanion(isSynced: drift.Value(true)));
  }

  Future<void> _markEpicrisisNotesSynced(List<int> ids) async {
    if (ids.isEmpty) return;
    await (db.update(db.epicrisisNotes)..where((t) => t.id.isIn(ids))).write(const EpicrisisNotesCompanion(isSynced: drift.Value(true)));
  }

  Future<void> _markPerformedProceduresSynced(List<int> ids) async {
    if (ids.isEmpty) return;
    await (db.update(db.performedProcedures)..where((t) => t.id.isIn(ids)))
        .write(const PerformedProceduresCompanion(
      isSynced: drift.Value(true),
    ));
  }

  Future<void> _markExamTemplatesSynced(List<int> ids) async {
    if (ids.isEmpty) return;
    await (db.update(db.examTemplates)..where((t) => t.id.isIn(ids))).write(
      const ExamTemplatesCompanion(isSynced: drift.Value(true)),
    );
  }

  Future<void> _markExamResultsSynced(List<int> ids) async {
    if (ids.isEmpty) return;
    await (db.update(db.examResults)..where((t) => t.id.isIn(ids))).write(
      const ExamResultsCompanion(isSynced: drift.Value(true)),
    );
  }
}
