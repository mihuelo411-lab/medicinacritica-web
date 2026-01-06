import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:nutrivigil/data/repositories/nutritional_assessment_repository.dart';
import 'package:nutrivigil/data/repositories/patient_repository.dart';
import 'package:nutrivigil/data/repositories/weight_assessment_repository.dart';
import 'package:nutrivigil/domain/nutrition/nutritional_assessment.dart';
import 'package:nutrivigil/domain/nutrition/services/nutritional_scoring_service.dart';
import 'package:nutrivigil/domain/patient/patient_entity.dart';
import 'package:nutrivigil/domain/patient/weight_assessment.dart';

part 'nutritional_status_event.dart';
part 'nutritional_status_state.dart';

class NutritionalStatusBloc
    extends Bloc<NutritionalStatusEvent, NutritionalStatusState> {
  NutritionalStatusBloc(
    this._patientRepository,
    this._assessmentRepository,
    this._weightAssessmentRepository,
    this._scoringService,
  ) : super(const NutritionalStatusState()) {
    on<NutritionalStatusStarted>(_onStarted);
    on<NutritionalStatusFieldChanged>(_onFieldChanged);
    on<NutritionalStatusApacheRecorded>(_onApacheRecorded);
    on<NutritionalStatusSofaRecorded>(_onSofaRecorded);
    on<NutritionalStatusSubmitted>(_onSubmitted);
    on<NutritionalStatusFeedbackCleared>(
      (event, emit) =>
          emit(state.copyWith(saveStatus: NutritionalStatusSaveStatus.idle)),
    );
  }

  final PatientRepository _patientRepository;
  final NutritionalAssessmentRepository _assessmentRepository;
  final WeightAssessmentRepository _weightAssessmentRepository;
  final NutritionalScoringService _scoringService;

  Future<void> _onStarted(
    NutritionalStatusStarted event,
    Emitter<NutritionalStatusState> emit,
  ) async {
    emit(state.copyWith(
      status: NutritionalStatusViewStatus.loading,
      errorMessage: null,
    ));
    try {
      final patient = await _patientRepository.fetchById(event.patientId);
      if (patient == null) {
        throw Exception('Paciente no encontrado');
      }
      final latest =
          await _assessmentRepository.latestForPatient(event.patientId);
      final latestWeightAssessment =
          await _weightAssessmentRepository.latestForPatient(event.patientId);
      final weightSummary =
          _deriveWeightSummary(patient, latestWeightAssessment);
      final previousTrace = latest?.trace ?? const <String, dynamic>{};
      var nextState = state.copyWith(
        status: NutritionalStatusViewStatus.ready,
        patient: patient,
        latest: latest,
        apacheScore: latest?.apacheScore,
        sofaScore: latest?.sofaScore,
        apacheDetails: _mapFrom(previousTrace['apacheDetails']),
        sofaDetails: _mapFrom(previousTrace['sofaDetails']),
        displayWeight: weightSummary.weight,
        displayHeight: weightSummary.height,
        displayBmi: weightSummary.bmi,
        weightReferenceLabel: weightSummary.label,
      );

      if (previousTrace.isNotEmpty) {
        final trace = previousTrace;
        nextState = nextState.copyWith(
          intakeCategory: _enumFromName(
              IntakeCategory.values, trace['intakeCategory'] as String?),
          weightLossCategory: _enumFromName(WeightLossCategory.values,
              trace['weightLossCategory'] as String?),
          weightLossPeriod: _enumFromName(
              WeightLossPeriod.values, trace['weightLossPeriod'] as String?),
          hasInflammation: trace['hasInflammation'] as bool?,
          nutritionalStatusScore: _intFrom(trace['nutritionalStatusScore']),
          diseaseSeverityScore: _intFrom(trace['diseaseSeverityScore']),
          icuDays: _intFrom(trace['icuDays']) ?? nextState.icuDays,
          hasComorbidities:
              trace['hasComorbidities'] as bool? ?? nextState.hasComorbidities,
          requiresVentilation: trace['requiresVentilation'] as bool? ??
              nextState.requiresVentilation,
          mustCategory: trace['mustCategory'] as String?,
          sgaCategory: trace['sgaCategory'] as String?,
          aspenCategory: trace['aspenCategory'] as String?,
        );
      }

      emit(_recalculate(nextState));
    } catch (error) {
      emit(state.copyWith(
        status: NutritionalStatusViewStatus.error,
        errorMessage: error.toString(),
      ));
    }
  }

  void _onFieldChanged(
    NutritionalStatusFieldChanged event,
    Emitter<NutritionalStatusState> emit,
  ) {
    NutritionalStatusState updated;
    switch (event.field) {
      case NutritionalStatusField.intakeCategory:
        updated =
            state.copyWith(intakeCategory: event.value as IntakeCategory?);
        break;
      case NutritionalStatusField.weightLossCategory:
        updated = state.copyWith(
            weightLossCategory: event.value as WeightLossCategory?);
        break;
      case NutritionalStatusField.weightLossPeriod:
        updated =
            state.copyWith(weightLossPeriod: event.value as WeightLossPeriod?);
        break;
      case NutritionalStatusField.hasInflammation:
        updated = state.copyWith(hasInflammation: event.value as bool?);
        break;
      case NutritionalStatusField.nutritionalStatusScore:
        updated = state.copyWith(nutritionalStatusScore: _intFrom(event.value));
        break;
      case NutritionalStatusField.diseaseSeverityScore:
        updated = state.copyWith(diseaseSeverityScore: _intFrom(event.value));
        break;
      case NutritionalStatusField.icuDays:
        updated = state.copyWith(icuDays: _intFrom(event.value) ?? 0);
        break;
      case NutritionalStatusField.hasComorbidities:
        updated =
            state.copyWith(hasComorbidities: event.value as bool? ?? false);
        break;
      case NutritionalStatusField.requiresVentilation:
        updated =
            state.copyWith(requiresVentilation: event.value as bool? ?? false);
        break;
      case NutritionalStatusField.mustCategory:
        updated = state.copyWith(mustCategory: event.value as String?);
        break;
      case NutritionalStatusField.sgaCategory:
        updated = state.copyWith(sgaCategory: event.value as String?);
        break;
      case NutritionalStatusField.aspenCategory:
        updated = state.copyWith(aspenCategory: event.value as String?);
        break;
    }

    emit(_recalculate(updated.copyWith(
      saveStatus: NutritionalStatusSaveStatus.idle,
    )));
  }

  void _onApacheRecorded(
    NutritionalStatusApacheRecorded event,
    Emitter<NutritionalStatusState> emit,
  ) {
    emit(_recalculate(state.copyWith(
      apacheScore: event.value,
      apacheDetails: event.details,
      saveStatus: NutritionalStatusSaveStatus.idle,
    )));
  }

  void _onSofaRecorded(
    NutritionalStatusSofaRecorded event,
    Emitter<NutritionalStatusState> emit,
  ) {
    emit(_recalculate(state.copyWith(
      sofaScore: event.value,
      sofaDetails: event.details,
      saveStatus: NutritionalStatusSaveStatus.idle,
    )));
  }

  Future<void> _onSubmitted(
    NutritionalStatusSubmitted event,
    Emitter<NutritionalStatusState> emit,
  ) async {
    if (state.patient == null) {
      return;
    }
    emit(state.copyWith(
      saveStatus: NutritionalStatusSaveStatus.saving,
      errorMessage: null,
    ));
    try {
      final assessment = NutritionalAssessment(
        id: state.latest?.id ?? '',
        patientId: state.patient!.id,
        createdAt: DateTime.now(),
        nutricScore: state.nutricScore,
        nrsScore: state.nrsScore,
        apacheScore: state.apacheScore,
        sofaScore: state.sofaScore,
        pendingItems: state.pendingItems,
        notes: null,
        trace: _buildTrace(state),
      );
      await _assessmentRepository.saveAssessment(assessment);
      final refreshed =
          await _assessmentRepository.latestForPatient(state.patient!.id);
      emit(state.copyWith(
        saveStatus: NutritionalStatusSaveStatus.success,
        latest: refreshed ?? assessment,
      ));
    } catch (error) {
      emit(state.copyWith(
        saveStatus: NutritionalStatusSaveStatus.failure,
        errorMessage: error.toString(),
      ));
    }
  }

  NutritionalStatusState _recalculate(NutritionalStatusState current) {
    if (current.patient == null) {
      return current;
    }
    final scoring = _scoringService.evaluate(
      nutric: NutricInput(
        age: current.patient!.age,
        apacheScore: current.apacheScore,
        sofaScore: current.sofaScore,
        icuDays: current.icuDays,
        hasComorbidities: current.hasComorbidities,
        requiresVentilation: current.requiresVentilation,
      ),
      nrs: NrsInput(
        nutritionalStatus: current.nutritionalStatusScore ?? -1,
        diseaseSeverity: current.diseaseSeverityScore ?? -1,
        age: current.patient!.age,
      ),
    );
    final manual = _manualPending(current);
    final combined = LinkedHashSet<String>()
      ..addAll(scoring.pendingItems)
      ..addAll(manual);
    return current.copyWith(
      nutricScore: scoring.nutricScore,
      nrsScore: scoring.nrsScore,
      pendingItems: combined.toList(growable: false),
    );
  }

  List<String> _manualPending(NutritionalStatusState current) {
    final pending = <String>[];
    if (current.intakeCategory == null) {
      pending.add('Cuantificar ingesta energética (≥ o <50%)');
    }
    if (current.weightLossCategory == null) {
      pending.add('Registrar pérdida de peso (%)');
    }
    if (current.weightLossPeriod == null) {
      pending.add('Documentar periodo de pérdida de peso');
    }
    if (current.hasInflammation == null) {
      pending.add('Confirmar inflamación/estrés metabólico');
    }
    if (current.mustCategory == null) {
      pending.add('Clasificar riesgo según MUST');
    }
    if (current.sgaCategory == null) {
      pending.add('Completar SGA');
    }
    if (current.aspenCategory == null) {
      pending.add('Clasificar con criterios ASPEN/GLIM');
    }
    if (current.sofaScore == null) {
      pending.add('Completar puntaje SOFA para seguimiento inflamatorio');
    }
    return pending;
  }

  Map<String, dynamic> _buildTrace(NutritionalStatusState current) {
    return {
      'intakeCategory': current.intakeCategory?.name,
      'weightLossCategory': current.weightLossCategory?.name,
      'weightLossPeriod': current.weightLossPeriod?.name,
      'hasInflammation': current.hasInflammation,
      'nutritionalStatusScore': current.nutritionalStatusScore,
      'diseaseSeverityScore': current.diseaseSeverityScore,
      'icuDays': current.icuDays,
      'hasComorbidities': current.hasComorbidities,
      'requiresVentilation': current.requiresVentilation,
      'mustCategory': current.mustCategory,
      'sgaCategory': current.sgaCategory,
      'aspenCategory': current.aspenCategory,
      'apacheScore': current.apacheScore,
      'sofaScore': current.sofaScore,
      'apacheDetails': current.apacheDetails,
      'sofaDetails': current.sofaDetails,
    }..removeWhere((key, value) => value == null);
  }
}

double? _doubleFrom(Object? value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString());
}

int? _intFrom(Object? value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString());
}

Map<String, dynamic>? _mapFrom(Object? value) {
  if (value is Map<String, dynamic>) {
    return value;
  }
  if (value is Map) {
    return value.map((key, dynamic v) => MapEntry('$key', v));
  }
  return null;
}

T? _enumFromName<T extends Enum>(Iterable<T> values, String? raw) {
  if (raw == null) return null;
  for (final value in values) {
    if (value.name == raw) {
      return value;
    }
  }
  return null;
}

_WeightSummary _deriveWeightSummary(
  PatientProfile patient,
  WeightAssessment? assessment,
) {
  final weight =
      assessment?.workWeightKg ?? assessment?.weightRealKg ?? patient.weightKg;
  final height =
      assessment?.heightCm ?? assessment?.estimatedHeightCm ?? patient.heightCm;
  final bmi = assessment?.bmi ?? _computeBmi(weight, height);
  final label = assessment?.workWeightKg != null
      ? 'Peso de trabajo'
      : assessment?.weightRealKg != null
          ? 'Peso reciente'
          : 'Peso registrado';
  return _WeightSummary(
    weight: weight,
    height: height,
    bmi: bmi,
    label: label,
  );
}

double? _computeBmi(double? weight, double? heightCm) {
  if (weight == null || heightCm == null || heightCm == 0) {
    return null;
  }
  final meters = heightCm / 100;
  return weight / (meters * meters);
}

class _WeightSummary {
  const _WeightSummary({
    required this.weight,
    required this.height,
    required this.bmi,
    required this.label,
  });

  final double? weight;
  final double? height;
  final double? bmi;
  final String label;
}
