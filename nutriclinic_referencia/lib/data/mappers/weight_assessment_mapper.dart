import 'dart:convert';

import 'package:drift/drift.dart';

import 'package:nutrivigil/data/local/app_database.dart' as db;
import 'package:nutrivigil/domain/patient/weight_assessment.dart'
    as domain;

extension WeightAssessmentDomainMapper on domain.WeightAssessment {
  db.WeightAssessmentsCompanion toCompanion() {
    return db.WeightAssessmentsCompanion(
      id: Value(id),
      patientId: Value(patientId),
      createdAt: Value(createdAt),
      weightRealKg: Value(weightRealKg),
      heightCm: Value(heightCm),
      heightMethod: Value(heightMethod),
      weightSource: Value(weightSource?.name),
      confidence: Value(confidence?.name),
      bmi: Value(bmi),
      idealWeightKg: Value(idealWeightKg),
      adjustedWeightKg: Value(adjustedWeightKg),
      workWeightKg: Value(workWeightKg),
      workWeightLabel: Value(workWeightMethod?.name),
      proteinBaseKg: Value(proteinBaseKg),
      kcalBaseKg: Value(kcalBaseKg),
      overrideJustification: Value(overrideJustification),
      kneeHeightCm: Value(kneeHeightCm),
      ulnaLengthCm: Value(ulnaLengthCm),
      estimatedHeightCm: Value(estimatedHeightCm),
      obesitySuspected: Value(flags.obesidad),
      edemaPresent: Value(flags.edema),
      ascitesPresent: Value(flags.ascitis),
      dryWeightConfirmed: Value(flags.pesoSecoConfirmado),
      amputationsPresent: Value(flags.amputaciones.isNotEmpty),
      pregnancyPresent: Value(flags.embarazo),
      spinalIssues: Value(flags.columnaAlterada),
      ascitesSeverity: Value(flags.ascitisSeveridad),
      amputationsJson: Value(_encodeList(flags.amputaciones)),
      pendingActionsJson: Value(_encodeList(pendingActions)),
      traceJson: Value(jsonEncode(trace)),
    );
  }
}

extension WeightAssessmentRowMapper on db.WeightAssessment {
  domain.WeightAssessment toDomain() {
    return domain.WeightAssessment(
      id: id,
      patientId: patientId,
      createdAt: createdAt,
      weightRealKg: weightRealKg,
      heightCm: heightCm,
      heightMethod: heightMethod,
      weightSource: _enumFromName(domain.WeightSource.values, weightSource),
      confidence: _enumFromName(domain.WeightConfidence.values, confidence),
      bmi: bmi,
      idealWeightKg: idealWeightKg,
      adjustedWeightKg: adjustedWeightKg,
      workWeightKg: workWeightKg,
      workWeightMethod: _enumFromName(domain.WorkWeightMethod.values, workWeightLabel),
      proteinBaseKg: proteinBaseKg,
      kcalBaseKg: kcalBaseKg,
      overrideJustification: overrideJustification,
      kneeHeightCm: kneeHeightCm,
      ulnaLengthCm: ulnaLengthCm,
      estimatedHeightCm: estimatedHeightCm,
      pendingActions: _decodeList(pendingActionsJson),
      trace: _decodeMap(traceJson),
      flags: domain.WeightFlags(
        obesidad: obesitySuspected ?? false,
        edema: edemaPresent ?? false,
        ascitis: ascitesPresent ?? false,
        ascitisSeveridad: ascitesSeverity,
        pesoSecoConfirmado: dryWeightConfirmed ?? false,
        amputaciones: _decodeList(amputationsJson),
        embarazo: pregnancyPresent ?? false,
        columnaAlterada: spinalIssues ?? false,
      ),
    );
  }
}

T? _enumFromName<T>(List<T> values, String? name) {
  if (name == null) {
    return null;
  }
  for (final value in values) {
    final enumName = value.toString().split('.').last;
    if (enumName == name) {
      return value;
    }
  }
  return null;
}

String? _encodeList(List<String> items) {
  if (items.isEmpty) {
    return null;
  }
  return jsonEncode(items);
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

Map<String, dynamic> _decodeMap(String? raw) {
  if (raw == null || raw.isEmpty) {
    return const {};
  }
  final decoded = jsonDecode(raw);
  if (decoded is Map<String, dynamic>) {
    return decoded;
  }
  return Map<String, dynamic>.from(decoded as Map);
}
