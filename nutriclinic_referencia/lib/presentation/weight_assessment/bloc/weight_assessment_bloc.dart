import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:nutrivigil/data/repositories/patient_repository.dart';
import 'package:nutrivigil/data/repositories/weight_assessment_repository.dart';
import 'package:nutrivigil/domain/patient/patient_entity.dart';
import 'package:nutrivigil/domain/patient/services/weight_assessment_service.dart';
import 'package:nutrivigil/domain/patient/weight_assessment.dart';

part 'weight_assessment_event.dart';
part 'weight_assessment_state.dart';

class WeightAssessmentBloc
    extends Bloc<WeightAssessmentEvent, WeightAssessmentState> {
  WeightAssessmentBloc(
    this._patientRepository,
    this._assessmentRepository,
    this._service,
  ) : super(const WeightAssessmentState()) {
    on<WeightAssessmentStarted>(_onStarted);
    on<WeightAssessmentVitalsChanged>(_onVitalsChanged);
    on<WeightAssessmentAvailabilityChanged>(_onAvailabilityChanged);
    on<WeightAssessmentAnthropometryChanged>(_onAnthropometryChanged);
    on<WeightAssessmentFlagsChanged>(_onFlagsChanged);
    on<WeightAssessmentSaved>(_onSaved);
  }

  final PatientRepository _patientRepository;
  final WeightAssessmentRepository _assessmentRepository;
  final WeightAssessmentService _service;

  Future<void> _onStarted(
    WeightAssessmentStarted event,
    Emitter<WeightAssessmentState> emit,
  ) async {
    emit(state.copyWith(
      status: WeightAssessmentStatus.loading,
      errorMessage: null,
      setErrorMessage: true,
      saveSuccess: false,
    ));
    try {
      final patient = await _patientRepository.fetchById(event.patientId);
      if (patient == null) {
        throw Exception('Paciente no encontrado');
      }
      final latest = await _assessmentRepository.latestForPatient(event.patientId);
      final initHeightReliable = patient.heightCm >= 120 && patient.heightCm <= 210;
      final hasWeight = patient.weightKg > 0;
      final baseState = state.copyWith(
        status: WeightAssessmentStatus.ready,
        patient: patient,
        weightKg: hasWeight ? patient.weightKg : null,
        heightCm: patient.heightCm,
        heightReliable: initHeightReliable,
        measurementDate: DateTime.now(),
        weightSource: WeightSource.bascula,
        measurementRecent: true,
        latestAssessment: latest,
        hasRealWeight: hasWeight,
        weightTrusted: hasWeight,
      );
      emit(_recalculate(baseState));
    } catch (error) {
      emit(state.copyWith(
        status: WeightAssessmentStatus.error,
        errorMessage: error.toString(),
        setErrorMessage: true,
      ));
    }
  }

  void _onVitalsChanged(
    WeightAssessmentVitalsChanged event,
    Emitter<WeightAssessmentState> emit,
  ) {
    final newState = state.copyWith(
      weightKg: event.weightKg ?? state.weightKg,
      heightCm: event.heightCm ?? state.heightCm,
      heightReliable: event.heightReliable ?? state.heightReliable,
      weightSource: event.weightSource ?? state.weightSource,
      measurementRecent: event.measurementRecent ?? state.measurementRecent,
      measurementDate: event.measurementDate ?? state.measurementDate,
      weightTrusted: event.weightTrusted ?? state.weightTrusted,
    );
    emit(_recalculate(newState));
  }

  void _onAnthropometryChanged(
    WeightAssessmentAnthropometryChanged event,
    Emitter<WeightAssessmentState> emit,
  ) {
    emit(_recalculate(state.copyWith(
      kneeHeightCm: event.kneeHeightCm,
      ulnaLengthCm: event.ulnaLengthCm,
    )));
  }

  void _onAvailabilityChanged(
    WeightAssessmentAvailabilityChanged event,
    Emitter<WeightAssessmentState> emit,
  ) {
    final hasWeight = event.hasRealWeight;
    final newTrusted =
        hasWeight ? (state.hasRealWeight ? state.weightTrusted : true) : false;
    emit(_recalculate(state.copyWith(
      hasRealWeight: hasWeight,
      weightKg: hasWeight ? state.weightKg : null,
      measurementRecent: hasWeight ? state.measurementRecent : false,
      weightTrusted: newTrusted,
    )));
  }

  void _onFlagsChanged(
    WeightAssessmentFlagsChanged event,
    Emitter<WeightAssessmentState> emit,
  ) {
    emit(_recalculate(state.copyWith(flags: event.flags)));
  }

  Future<void> _onSaved(
    WeightAssessmentSaved event,
    Emitter<WeightAssessmentState> emit,
  ) async {
    if (!state.canContinue) {
      emit(state.copyWith(
        errorMessage: 'Complete los datos requeridos',
        setErrorMessage: true,
      ));
      return;
    }
    emit(state.copyWith(
      status: WeightAssessmentStatus.saving,
      errorMessage: null,
      setErrorMessage: true,
      saveSuccess: false,
    ));
    try {
      final computation = state.computation!;
      final patient = state.patient!;
      final workMethod = computation.recommendedMethod;
      final selectedWeight = _weightForMethod(workMethod, state, computation);
      if (selectedWeight == null) {
        throw Exception('No se pudo determinar el peso de trabajo');
      }

      final assessment = WeightAssessment(
        id: '',
        patientId: patient.id,
        createdAt: DateTime.now(),
        weightRealKg: state.weightKg,
        heightCm: state.heightCm,
        heightMethod: computation.heightMethod,
        weightSource: state.weightSource,
        confidence: computation.confidence,
        bmi: computation.bmi,
        idealWeightKg: computation.idealWeightKg,
        adjustedWeightKg: computation.adjustedWeightKg,
        workWeightKg: selectedWeight,
        workWeightMethod: workMethod,
        proteinBaseKg: computation.proteinBaseKg,
        kcalBaseKg: computation.energyBaseKg,
        kneeHeightCm: state.kneeHeightCm,
        ulnaLengthCm: state.ulnaLengthCm,
        estimatedHeightCm: computation.heightUsedCm,
        pendingActions: computation.pendingActions,
        trace: {
          ...computation.trace,
          'selection': workMethod.name,
        },
        flags: state.flags,
      );

      await _assessmentRepository.save(assessment);
      emit(state.copyWith(
        status: WeightAssessmentStatus.ready,
        latestAssessment: assessment,
        saveSuccess: true,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: WeightAssessmentStatus.error,
        errorMessage: error.toString(),
        setErrorMessage: true,
      ));
    }
  }

  WeightAssessmentState _recalculate(WeightAssessmentState current) {
    if (current.patient == null) {
      return current;
    }
    final input = WeightAssessmentInput(
      patient: current.patient!,
      weightKg: current.hasRealWeight ? current.weightKg : null,
      hasRealWeight: current.hasRealWeight,
      weightTrusted: current.weightTrusted,
      heightCm: current.heightCm,
      heightReliable: current.heightReliable,
      weightSource: current.weightSource,
      measurementRecent: current.measurementRecent,
      measurementDate: current.measurementDate ?? DateTime.now(),
      kneeHeightCm: current.kneeHeightCm,
      ulnaLengthCm: current.ulnaLengthCm,
      flags: current.flags,
    );
    final computation = _service.evaluate(input);
    return current.copyWith(
      computation: computation,
      saveSuccess: false,
    );
  }

  double? _weightForMethod(
    WorkWeightMethod method,
    WeightAssessmentState state,
    WeightAssessmentComputation computation,
  ) {
    switch (method) {
      case WorkWeightMethod.real:
        return computation.recalculatedRealKg ?? state.weightKg;
      case WorkWeightMethod.ideal:
        return computation.idealWeightKg;
      case WorkWeightMethod.ajustado:
        return computation.adjustedWeightKg;
      case WorkWeightMethod.realAjustado:
        return computation.energyBaseKg;
      case WorkWeightMethod.otro:
        return null;
    }
  }
}
