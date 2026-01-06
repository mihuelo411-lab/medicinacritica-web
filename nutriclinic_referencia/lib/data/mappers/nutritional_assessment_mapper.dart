import 'dart:convert';

import 'package:drift/drift.dart';

import 'package:nutrivigil/data/local/app_database.dart' as db;
import 'package:nutrivigil/domain/nutrition/nutritional_assessment.dart';

extension NutritionalAssessmentMapper on NutritionalAssessment {
  db.NutritionalAssessmentsCompanion toCompanion() {
    return db.NutritionalAssessmentsCompanion(
      id: Value(id),
      patientId: Value(patientId),
      createdAt: Value(createdAt),
      nutricScore: Value(nutricScore),
      nrsScore: Value(nrsScore),
      apacheScore: Value(apacheScore),
      sofaScore: Value(sofaScore),
      pendingItemsJson:
          Value(pendingItems.isEmpty ? null : jsonEncode(pendingItems)),
      notes: Value(notes),
      traceJson: Value(trace == null ? null : jsonEncode(trace)),
    );
  }
}

extension NutritionalAssessmentRowX on db.NutritionalAssessment {
  NutritionalAssessment toDomain() {
    return NutritionalAssessment(
      id: id,
      patientId: patientId,
      createdAt: createdAt,
      nutricScore: nutricScore,
      nrsScore: nrsScore,
      apacheScore: apacheScore,
      sofaScore: sofaScore,
      pendingItems: _decodeList(pendingItemsJson),
      notes: notes,
      trace: _decodeMap(traceJson),
    );
  }
}

List<String> _decodeList(String? raw) {
  if (raw == null || raw.isEmpty) {
    return const [];
  }
  final decoded = jsonDecode(raw);
  if (decoded is List) {
    return decoded.map((e) => '$e').toList();
  }
  return const [];
}

Map<String, dynamic>? _decodeMap(String? raw) {
  if (raw == null || raw.isEmpty) {
    return null;
  }
  final decoded = jsonDecode(raw);
  if (decoded is Map<String, dynamic>) {
    return decoded;
  }
  if (decoded is Map) {
    return decoded.map((key, value) => MapEntry('$key', value));
  }
  return null;
}
