import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../database/database.dart';

class SupabaseService {
  // Singleton
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  String _stripBucketPrefix(String path, String bucket) {
    final prefix = '$bucket/';
    if (path.startsWith(prefix)) {
      return path.substring(prefix.length);
    }
    return path;
  }

  /// Clients can access the Supabase client instance via this getter
  SupabaseClient get client => Supabase.instance.client;

  /// Initialize Supabase with project URL and Anon Key
  Future<void> initialize({required String url, required String anonKey}) async {
    await Supabase.initialize(
      url: url,
      anonKey: anonKey,
    );
  }

  Future<List<Map<String, dynamic>>> fetchProcedureCatalog() async {
    try {
      final response = await client
          .from('procedure_catalog')
          .select()
          .order('name')
          .limit(200);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('Error fetching procedure catalog: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> upsertProcedureCatalogEntry({
    int? id,
    required String name,
    String? code,
    String? description,
    String category = 'uci',
  }) async {
    final payload = <String, dynamic>{
      'name': name,
      'category': category,
      if (code != null && code.isNotEmpty) 'code': code,
      if (description != null && description.isNotEmpty)
        'description_template': description,
    };
    if (id != null) payload['id'] = id;
    final response = await client
        .from('procedure_catalog')
        .upsert(payload, onConflict: 'id')
        .select()
        .single();
    return Map<String, dynamic>.from(response);
  }

  Future<void> deleteProcedureCatalogEntry(int id) async {
    await client.from('procedure_catalog').delete().eq('id', id);
  }

  Future<List<Map<String, dynamic>>> fetchPerformedProcedures() async {
    try {
      final response = await client
          .from('performed_procedures')
          .select()
          .order('performed_at');
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('Error fetching performed procedures: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchPerformedProceduresForAdmission({
    required int admissionId,
    required String origin,
    String? guardia,
  }) async {
    try {
      final response = await client
          .from('performed_procedures')
          .select()
          .eq('admission_id', admissionId)
          .eq('origin', origin)
          .order('performed_at');
      final rows = List<Map<String, dynamic>>.from(response);
      return rows
          .where((row) => guardia != null
              ? row['guardia'] == guardia
              : row['guardia'] == null)
          .map((row) => Map<String, dynamic>.from(row))
          .toList();
    } catch (e) {
      debugPrint('Error fetching admission procedures: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> savePerformedProcedure({
    int? id,
    required int admissionId,
    required int procedureId,
    required String procedureName,
    required DateTime performedAt,
    String? assistant,
    String? resident,
    required String origin,
    String? guardia,
    String? note,
  }) async {
    final payload = <String, dynamic>{
      'admission_id': admissionId,
      'procedure_id': procedureId,
      'procedure_name': procedureName,
      'performed_at': performedAt.toIso8601String(),
      'origin': origin,
      if (assistant != null) 'assistant': assistant,
      if (resident != null) 'resident': resident,
      if (guardia != null) 'guardia': guardia,
      if (note != null) 'note': note,
    };
    if (id != null) payload['id'] = id;
    final response = await client
        .from('performed_procedures')
        .upsert(payload, onConflict: 'id')
        .select()
        .single();
    return Map<String, dynamic>.from(response);
  }

  Future<void> deletePerformedProcedure(int id) async {
    await client.from('performed_procedures').delete().eq('id', id);
  }

  Future<void> updateReportStoragePath(
    int reportId,
    String path, {
    String bucket = 'reports',
  }) async {
    final normalized = _stripBucketPrefix(path, bucket);
    await client
        .from('procedure_reports')
        .update({'storage_path': normalized}).eq('id', reportId);
  }

  Future<String> uploadReportFile({
    required List<int> bytes,
    required String storagePath,
    String bucket = 'reports',
    String contentType =
        'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
  }) async {
    final storage = client.storage.from(bucket);
    final data = bytes is Uint8List ? bytes : Uint8List.fromList(bytes);
    final relativePath = _stripBucketPrefix(storagePath, bucket);
    await storage.uploadBinary(
      relativePath,
      data,
      fileOptions: FileOptions(contentType: contentType, upsert: true),
    );
    return relativePath;
  }

  Future<void> cleanupManualExports({
    String? keepRelativePath,
    String bucket = 'reports',
    String folder = 'manual_exports',
  }) async {
    final storage = client.storage.from(bucket);
    final normalizedKeep = keepRelativePath != null
        ? _stripBucketPrefix(keepRelativePath, bucket)
        : null;
    List<FileObject> files = const <FileObject>[];
    try {
      files = await storage.list(path: folder);
    } catch (error) {
      debugPrint('cleanupManualExports: $error');
      return;
    }
    if (files.isEmpty) return;
    final toDelete = <String>[];
    for (final file in files) {
      final candidate = '$folder/${file.name}';
      if (normalizedKeep != null && candidate == normalizedKeep) continue;
      toDelete.add(candidate);
    }
    if (toDelete.isEmpty) return;
    await storage.remove(toDelete);
  }

  Future<void> deleteReportFile({
    required String storagePath,
    String bucket = 'reports',
  }) async {
    final storage = client.storage.from(bucket);
    final relativePath = _stripBucketPrefix(storagePath, bucket);
    await storage.remove([relativePath]);
  }

  String getReportPublicUrl({
    required String storagePath,
    String bucket = 'reports',
  }) {
    final relativePath = _stripBucketPrefix(storagePath, bucket);
    return client.storage.from(bucket).getPublicUrl(relativePath);
  }

  Future<Map<String, dynamic>> generateProcedureReport({
    required int year,
    required int month,
  }) async {
    final response = await client
        .rpc('generate_procedure_report', params: {
          'p_year': year,
          'p_month': month,
        });
    return Map<String, dynamic>.from(response);
  }

  Future<List<Map<String, dynamic>>> fetchProcedureReports({
    int limit = 12,
  }) async {
    final response = await client
        .from('procedure_reports')
        .select()
        .order('created_at', ascending: false)
        .limit(limit);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<List<int>> fetchAvailableReportYears() async {
    final response = await client
        .from('procedure_reports')
        .select('period_year')
        .order('period_year', ascending: false);
    final years = <int>{};
    for (final row in response) {
      final value = row['period_year'];
      if (value is int) {
        years.add(value);
      }
    }
    final list = years.toList()..sort((a, b) => b.compareTo(a));
    return list;
  }

  Future<void> upsertProcedures(List<Procedure> procedures) async {
    if (procedures.isEmpty) return;
    final payload = procedures.map((p) {
      return {
        'id': p.id,
        'name': p.name,
        'code': p.code,
        'description_template': p.description,
        'category': 'uci',
        'created_at': p.createdAt.toIso8601String(),
      };
    }).toList();
    await client
        .from('procedure_catalog')
        .upsert(payload, onConflict: 'id');
  }

  Future<void> upsertPerformedProcedures(
    List<PerformedProcedure> procedures,
  ) async {
    if (procedures.isEmpty) return;
    final payload = procedures.map((p) {
      return {
        'id': p.id,
        'admission_id': p.admissionId,
        'procedure_id': p.procedureId,
        'procedure_name': p.procedureName,
        'performed_at': p.performedAt.toIso8601String(),
        'assistant': p.assistant,
        'resident': p.resident,
        'origin': p.origin,
        'guardia': p.guardia,
        'note': p.note,
        'created_at': p.createdAt.toIso8601String(),
      };
    }).toList();
    await client
        .from('performed_procedures')
        .upsert(payload, onConflict: 'id');
  }

  Future<List<Map<String, dynamic>>> fetchExamTemplates() async {
    final response = await client.from('exam_templates').select();
    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> upsertExamTemplates(List<ExamTemplate> templates) async {
    if (templates.isEmpty) return;
    final payload = templates.map((t) {
      return {
        'id': t.id,
        'name': t.name,
        'category': t.category,
        'description': t.description,
        'fields_json': t.fieldsJson,
        'version': t.version,
        'is_archived': t.isArchived,
        'created_by': t.createdBy,
        'created_at': t.createdAt.toIso8601String(),
        'updated_at': t.updatedAt.toIso8601String(),
      };
    }).toList();
    await client.from('exam_templates').upsert(payload, onConflict: 'id');
  }

  Future<List<Map<String, dynamic>>> fetchExamResults() async {
    final response = await client.from('exam_results').select();
    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> upsertExamResults(List<ExamResult> results) async {
    if (results.isEmpty) return;
    final payload = results.map((r) {
      return {
        'id': r.id,
        'admission_id': r.admissionId,
        'template_id': r.templateId,
        'template_version': r.templateVersion,
        'recorded_at': r.recordedAt.toIso8601String(),
        'values_json': r.valuesJson,
        'note': r.note,
        'attachments': r.attachments,
        'recorded_by': r.recordedBy,
        'created_at': r.createdAt.toIso8601String(),
      };
    }).toList();
    await client.from('exam_results').upsert(payload, onConflict: 'id');
  }

  Future<Map<String, dynamic>> createExternalProcedure({
    required int patientId,
    int? procedureCatalogId,
    required String procedureName,
    DateTime? performedAt,
    String? serviceRoom,
    String? diagnosis,
    String? assistantName,
    String? residentName,
    String? note,
  }) async {
    final payload = <String, dynamic>{
      'patient_id': patientId,
      'procedure_name': procedureName,
      if (procedureCatalogId != null) 'procedure_catalog_id': procedureCatalogId,
      'performed_at':
          (performedAt ?? DateTime.now()).toIso8601String(),
      if (serviceRoom != null && serviceRoom.isNotEmpty)
        'service_room': serviceRoom,
      if (diagnosis != null && diagnosis.isNotEmpty)
        'diagnosis': diagnosis,
      if (assistantName != null && assistantName.isNotEmpty)
        'assistant_name': assistantName,
      if (residentName != null && residentName.isNotEmpty)
        'resident_name': residentName,
      if (note != null && note.isNotEmpty) 'note': note,
    };
    final response = await client
        .from('external_procedures')
        .insert(payload)
        .select()
        .single();
    return Map<String, dynamic>.from(response);
  }

  Future<int> ensureExternalPatient({
    required String name,
    required String dni,
    String? hc,
  }) async {
    final normalizedDni = dni.trim();
    final normalizedHc =
        hc != null && hc.trim().isNotEmpty ? hc.trim() : null;

    Map<String, dynamic>? record;
    if (normalizedDni.isNotEmpty) {
      record = await client
          .from('patients')
          .select()
          .eq('dni', normalizedDni)
          .limit(1)
          .maybeSingle();
    }
    if (record == null && normalizedHc != null) {
      record = await client
          .from('patients')
          .select()
          .eq('hc', normalizedHc)
          .limit(1)
          .maybeSingle();
    }
    if (record != null) {
      return record['id'] as int;
    }

    final fallbackHc =
        normalizedHc ?? _buildExternalHistoryCode(normalizedDni);

    final inserted = await client
        .from('patients')
        .insert({
          'name': name,
          'dni': normalizedDni,
          'hc': fallbackHc,
          'age': 0,
          'sex': 'Desconocido',
          'is_synced': true,
        })
        .select()
        .single();
    return inserted['id'] as int;
  }

  String _buildExternalHistoryCode(String dni) {
    final suffix =
        dni.isNotEmpty ? dni : DateTime.now().microsecondsSinceEpoch.toString();
    return 'EXT-$suffix';
  }

  // --- Core Patient & Admission Flow ---

  /// Registers a patient and their admission in one transaction (RPC).
  /// Automatically detects if it's a new patient or a readmission.
  Future<Map<String, dynamic>> registerPatientAdmission({
    required String dni,
    required String name,
    required String hc,
    required int age,
    required String sex,
    String? address,
    String? occupation,
    String? phone,
    String? familyContact,
    String? placeOfBirth,
    String? insuranceType,
    int? bedNumber,
    String? diagnosis,
    double? sofaScore,
    double? apacheScore,
  }) async {
    try {
      final response = await client.rpc('register_patient_admission', params: {
        'p_dni': dni,
        'p_name': name,
        'p_hc': hc,
        'p_age': age, // Passing Age directly as per schema
        'p_sex': sex,
        'p_address': address,
        'p_occupation': occupation,
        'p_phone': phone,
        'p_family_contact': familyContact,
        'p_place_of_birth': placeOfBirth,
        'p_insurance_type': insuranceType,
        'p_bed_number': bedNumber,
        'p_diagnosis': diagnosis,
        'p_sofa_score': sofaScore,
        'p_apache_score': apacheScore,
      });
      
      final admissionId = response['admission_id'] as int?;
      final rawStatus = response['status']?.toString().toUpperCase();
      final bool isReadmission = rawStatus == 'REINGRESO';
      if (admissionId != null) {
        try {
          await client.from('admissions').update({
            'status': 'activo',
            'is_readmission': isReadmission,
          }).eq('id', admissionId);
        } catch (statusError) {
          debugPrint('Error tagging admission status fields: $statusError');
        }
      }
      
      return Map<String, dynamic>.from(response);
    } catch (e) {
      debugPrint('Error in registerPatientAdmission: $e');
      rethrow;
    }
  }

  /// Updates the admission with full clinical details (Vitals, Plan, Physical Exam, etc.)
  /// This should be called after registerPatientAdmission returns the admission_id.
  Future<void> updateAdmissionClinicalData({
    required int admissionId,
    Map<String, dynamic>? vitals,
    String? signsSymptoms,
    String? diseaseTime,
    String? diseaseStart,
    String? diseaseCourse,
    String? story,
    String? physicalExam,
    String? plan,
    String? procedures,
    String? sofaMortality,
    String? apacheMortality,
    double? nutricScore,
  }) async {
    await client.from('admissions').update({
      'vitals_json': vitals, // Store key-value pairs as JSON
      'signs_symptoms': signsSymptoms,
      'time_of_disease': diseaseTime,
      'illness_start': diseaseStart,
      'illness_course': diseaseCourse,
      'story': story,
      'physical_exam': physicalExam,
      'plan': plan,
      'procedures': procedures,
      'sofa_mortality': sofaMortality,
      'apache_mortality': apacheMortality,
      'nutric_score': nutricScore,
      // Map flat vital columns if needed for optimized querying, but JSON is fine for full display
      'bp': vitals?['PA'],
      'hr': vitals?['FC'],
      'rr': vitals?['FR'],
      'o2_sat': vitals?['SatO2'],
      'temp': vitals?['T'],
    }).eq('id', admissionId);
  }

  /// Find Patient by DNI
  /// Returns null if not found
  Future<Map<String, dynamic>?> findPatientByDni(String dni) async {
    try {
      final response = await client
          .from('patients')
          .select()
          .eq('dni', dni)
          .maybeSingle();
      return response;
    } catch (e) {
      debugPrint('Error searching patient: $e');
      return null;
    }
  }

  /// Search patients by name or DNI (Partial match)
  Future<List<Map<String, dynamic>>> searchPatients(String query) async {
    try {
      final response = await client
          .from('patients')
          .select()
          .or('name.ilike.%$query%,dni.ilike.%$query%') // Multi-column search
          .limit(20);
      
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('Error searching patients list: $e');
      return [];
    }
  }

  /// Fetch ALL Active Admissions (Bed assigned, not discharged)
  /// Joins with Patients table
  Future<List<Map<String, dynamic>>> fetchActiveAdmissions() async {
    try {
      final response = await client
          .from('admissions')
          .select('*, patients(*)') // Join with patients
          .not('bed_number', 'is', null) // Has bed
          .filter('discharged_at', 'is', null) // Not discharged
          .eq('status', 'activo'); // Only active patients
      
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('Error fetching active admissions: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchAdmissionsByIds(List<int> ids) async {
    if (ids.isEmpty) return const [];
    try {
      final formattedIds = '(${ids.join(',')})';
      final response = await client
          .from('admissions')
          .select('id, bed_number, discharged_at, status, is_readmission')
          .filter('id', 'in', formattedIds);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('Error fetching admissions by id: $e');
      return [];
    }
  }

  Future<void> dischargeAdmission({
    required int admissionId,
    DateTime? dischargedAt,
    bool releaseBed = true,
  }) async {
    final payload = <String, dynamic>{
      'discharged_at': (dischargedAt ?? DateTime.now()).toIso8601String(),
      'is_synced': true,
      'status': 'alta',
    };
    if (releaseBed) payload['bed_number'] = null;
    try {
      await client.from('admissions').update(payload).eq('id', admissionId);
    } catch (e) {
      debugPrint('Error marking discharge: $e');
      rethrow;
    }
  }

  /// Create a new evolution (best effort; admission_id must exist remotely)
  Future<void> createEvolution({
    required int admissionId,
    required DateTime date,
    required Map<String, String> vitals,
    required Map<String, String> vmSettings,
    required Map<String, String> vmMechanics,
    required Map<String, String> objective,
    required String subjective,
    required String analysis,
    required String plan,
    required String diagnosis,
    String? authorName,
    String? authorRole,
    int? vmDays,
    bool? vmActive,
    String? proceduresNote,
  }) async {
    try {
      await client.from('evolutions').insert({
        'admission_id': admissionId,
        'date': date.toIso8601String(),
        'vitals_json': vitals,
        'vm_settings_json': vmSettings,
        'vm_mechanics_json': vmMechanics,
        'objective_json': objective,
        'subjective': subjective,
        'analysis': analysis,
        'plan': plan,
        'diagnosis': diagnosis,
        if (authorName != null) 'author_name': authorName,
        if (authorRole != null) 'author_role': authorRole,
        'vm_days': vmDays,
        'vm_active': vmActive,
        if (proceduresNote != null) 'procedures_note': proceduresNote,
      });
    } catch (e) {
      debugPrint('Error creating evolution: $e');
      rethrow;
    }
  }

  /// Fetch evolutions for a specific admission (ordered by date ascending)
  Future<List<Map<String, dynamic>>> fetchEvolutionsForAdmission(int admissionId) async {
    try {
      final response = await client
          .from('evolutions')
          .select()
          .eq('admission_id', admissionId)
          .order('date', ascending: true);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('Error fetching evolutions: $e');
      return [];
    }
  }

  Future<void> updateAdmissionDiagnosis({
    required int admissionId,
    required String diagnosis,
  }) async {
    try {
      await client.from('admissions').update({'diagnosis': diagnosis}).eq('id', admissionId);
    } catch (e) {
      debugPrint('Error updating diagnosis: $e');
    }
  }

  // ---- Bulk fetch / upsert for sync ----
  Future<List<Map<String, dynamic>>> fetchPatients() async {
    try {
      final response = await client.from('patients').select();
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('Error fetching patients: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchAdmissions() async {
    try {
      final response = await client.from('admissions').select();
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('Error fetching admissions: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchEvolutions() async {
    try {
      final response = await client.from('evolutions').select();
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('Error fetching evolutions: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchIndicationSheets() async {
    try {
      final response = await client.from('indication_sheets').select();
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('Error fetching indication sheets: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchEpicrisisNotes() async {
    try {
      final response = await client.from('epicrisis_notes').select();
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('Error fetching epicrisis notes: $e');
      return [];
    }
  }

  Future<void> upsertPatients(List patients) async {
    if (patients.isEmpty) return;
    await client.from('patients').upsert(patients.map((p) => {
      'id': p.id,
      'dni': p.dni,
      'name': p.name,
      'hc': p.hc,
      'age': p.age,
      'sex': p.sex,
      'address': p.address,
      'occupation': p.occupation,
      'phone': p.phone,
      'family_contact': p.familyContact,
      'place_of_birth': p.placeOfBirth,
      'insurance_type': p.insuranceType,
      'created_at': p.createdAt.toIso8601String(),
      'updated_at': p.updatedAt.toIso8601String(),
      'is_synced': true,
    }).toList());
  }

  Future<void> upsertAdmissions(List admissions) async {
    if (admissions.isEmpty) return;
    await client.from('admissions').upsert(admissions.map((a) => {
      'id': a.id,
      'patient_id': a.patientId,
      'admission_date': a.admissionDate.toIso8601String(),
      'sofa_score': a.sofaScore,
      'apache_score': a.apacheScore,
      'nutric_score': a.nutricScore,
      'sofa_mortality': a.sofaMortality,
      'apache_mortality': a.apacheMortality,
      'diagnosis': a.diagnosis,
      'signs_symptoms': a.signsSymptoms,
      'time_of_disease': a.timeOfDisease,
      'illness_start': a.illnessStart,
      'illness_course': a.illnessCourse,
      'story': a.story,
      'physical_exam': a.physicalExam,
      'plan': a.plan,
      'bp': a.bp,
      'hr': a.hr,
      'rr': a.rr,
      'o2_sat': a.o2Sat,
      'temp': a.temp,
      'vitals_json': _safeJson(a.vitalsJson),
      'procedures': a.procedures,
      'bed_number': a.bedNumber,
      'discharged_at': a.dischargedAt?.toIso8601String(),
      'uci_priority': a.uciPriority,
      'status': a.status ?? 'activo',
      'is_readmission': a.isReadmission ?? false,
      'created_at': a.createdAt.toIso8601String(),
      'is_synced': true,
    }).toList());
  }

  Future<void> upsertEvolutions(List evolutions) async {
    if (evolutions.isEmpty) return;
    await client.from('evolutions').upsert(evolutions.map((ev) => {
      'id': ev.id,
      'admission_id': ev.admissionId,
      'date': ev.date.toIso8601String(),
      'day_of_stay': ev.dayOfStay,
      'vitals_json': _safeJson(ev.vitalsJson),
      'vm_settings_json': _safeJson(ev.vmSettingsJson),
      'vm_mechanics_json': _safeJson(ev.vmMechanicsJson),
      'subjective': ev.subjective,
      'objective_json': _safeJson(ev.objectiveJson),
      'analysis': ev.analysis,
      'plan': ev.plan,
      'diagnosis': ev.diagnosis,
      'author_name': ev.authorName,
      'author_role': ev.authorRole,
      'procedures_note': ev.proceduresNote,
      'created_at': ev.createdAt.toIso8601String(),
      'is_synced': true,
    }).toList());
  }

  Future<void> upsertIndicationSheets(List sheets) async {
    if (sheets.isEmpty) return;
    await client.from('indication_sheets').upsert(sheets.map((sheet) => {
      'id': sheet.id,
      'admission_id': sheet.admissionId,
      'payload': sheet.payload,
      'created_at': sheet.createdAt.toIso8601String(),
      'is_synced': true,
    }).toList());
  }

  Future<void> upsertEpicrisisNotes(List notes) async {
    if (notes.isEmpty) return;
    await client.from('epicrisis_notes').upsert(notes.map((note) => {
      'id': note.id,
      'admission_id': note.admissionId,
      'payload': note.payload,
      'created_at': note.createdAt.toIso8601String(),
      'updated_at': note.updatedAt.toIso8601String(),
      'is_synced': true,
    }).toList());
  }

  dynamic _safeJson(String? jsonStr) {
    if (jsonStr == null) return null;
    try {
      return jsonStr.isEmpty ? null : json.decode(jsonStr);
    } catch (_) {
      return jsonStr;
    }
  }
}
