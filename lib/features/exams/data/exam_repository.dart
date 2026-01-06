import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../core/database/database.dart';

class ExamFieldConfig {
  final String id;
  final String label;
  final String type; // number | text
  final String? unit;
  final num? minValue;
  final num? maxValue;
  final bool isCritical;

  const ExamFieldConfig({
    required this.id,
    required this.label,
    required this.type,
    this.unit,
    this.minValue,
    this.maxValue,
    this.isCritical = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'label': label,
      'type': type,
      if (unit != null) 'unit': unit,
      if (minValue != null) 'minValue': minValue,
      if (maxValue != null) 'maxValue': maxValue,
      'isCritical': isCritical,
    };
  }

  factory ExamFieldConfig.fromMap(Map<String, dynamic> map) {
    return ExamFieldConfig(
      id: map['id']?.toString() ?? '',
      label: map['label']?.toString() ?? '',
      type: (map['type']?.toString() ?? 'text'),
      unit: map['unit']?.toString(),
      minValue: map['minValue'] is num ? map['minValue'] : num.tryParse('${map['minValue']}'),
      maxValue: map['maxValue'] is num ? map['maxValue'] : num.tryParse('${map['maxValue']}'),
      isCritical: map['isCritical'] == true,
    );
  }
}

class ExamResultEntry {
  final ExamResult result;
  final ExamTemplate template;
  ExamResultEntry(this.result, this.template);
}

abstract class ExamRepository {
  Future<List<ExamTemplate>> fetchTemplates({bool includeArchived = false});
  Future<int> saveTemplate({
    int? id,
    required String name,
    String? category,
    String? description,
    required List<ExamFieldConfig> fields,
    String? createdBy,
    bool archived,
  });

  Future<List<ExamResultEntry>> fetchResultsForAdmission(int admissionId);

  Future<int> saveExamResult({
    required int admissionId,
    required ExamTemplate template,
    required Map<String, dynamic> values,
    required DateTime recordedAt,
    String? note,
    String? attachments,
    String? recordedBy,
  });

  Future<List<ExamFieldConfig>> getTemplateFields(ExamTemplate template);
}

class LocalExamRepository implements ExamRepository {
  final AppDatabase db;
  LocalExamRepository(this.db);

  @override
  Future<List<ExamTemplate>> fetchTemplates({bool includeArchived = false}) async {
    final query = db.select(db.examTemplates)
      ..orderBy([(tbl) => OrderingTerm(expression: tbl.name)]);
    if (!includeArchived) {
      query.where((tbl) => tbl.isArchived.equals(false));
    }
    return query.get();
  }

  @override
  Future<int> saveTemplate({
    int? id,
    required String name,
    String? category,
    String? description,
    required List<ExamFieldConfig> fields,
    String? createdBy,
    bool archived = false,
  }) async {
    final fieldsJson = jsonEncode(fields.map((f) => f.toMap()).toList());
    final companion = ExamTemplatesCompanion(
      name: Value(name),
      category: Value(category),
      description: Value(description),
      fieldsJson: Value(fieldsJson),
      version: const Value(1),
      isArchived: Value(archived),
      createdBy: Value(createdBy),
      updatedAt: Value(DateTime.now()),
      isSynced: const Value(false),
    );
    if (id == null) {
      return db.into(db.examTemplates).insert(companion);
    } else {
      await (db.update(db.examTemplates)..where((tbl) => tbl.id.equals(id))).write(companion);
      return id;
    }
  }

  @override
  Future<List<ExamResultEntry>> fetchResultsForAdmission(int admissionId) async {
    final query = db.select(db.examResults).join([
      innerJoin(db.examTemplates, db.examTemplates.id.equalsExp(db.examResults.templateId)),
    ])
      ..where(db.examResults.admissionId.equals(admissionId))
      ..orderBy([OrderingTerm(expression: db.examResults.recordedAt, mode: OrderingMode.desc)]);
    final rows = await query.get();
    return rows.map((row) {
      return ExamResultEntry(
        row.readTable(db.examResults),
        row.readTable(db.examTemplates),
      );
    }).toList();
  }

  @override
  Future<int> saveExamResult({
    required int admissionId,
    required ExamTemplate template,
    required Map<String, dynamic> values,
    required DateTime recordedAt,
    String? note,
    String? attachments,
    String? recordedBy,
  }) async {
    final payload = ExamResultsCompanion(
      admissionId: Value(admissionId),
      templateId: Value(template.id),
      templateVersion: Value(template.version),
      recordedAt: Value(recordedAt),
      valuesJson: Value(jsonEncode(values)),
      note: Value(note),
      attachments: Value(attachments),
      recordedBy: Value(recordedBy),
      createdAt: Value(DateTime.now()),
      isSynced: const Value(false),
    );
    return db.into(db.examResults).insert(payload);
  }

  @override
  Future<List<ExamFieldConfig>> getTemplateFields(ExamTemplate template) async {
    try {
      final decoded = jsonDecode(template.fieldsJson);
      if (decoded is List) {
        return decoded
            .whereType<Map>()
            .map((item) => ExamFieldConfig.fromMap(Map<String, dynamic>.from(item as Map)))
            .toList();
      }
    } catch (_) {}
    return [];
  }
}
