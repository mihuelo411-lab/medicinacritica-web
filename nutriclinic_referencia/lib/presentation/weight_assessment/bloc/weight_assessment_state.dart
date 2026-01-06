part of 'weight_assessment_bloc.dart';

enum WeightAssessmentStatus { loading, ready, saving, error }

class WeightAssessmentState extends Equatable {
  const WeightAssessmentState({
    this.status = WeightAssessmentStatus.loading,
    this.patient,
    this.weightKg,
    this.heightCm,
    this.heightReliable = true,
    this.hasRealWeight = true,
    this.weightTrusted = true,
    this.weightSource = WeightSource.bascula,
    this.measurementRecent = true,
    this.measurementDate,
    this.kneeHeightCm,
    this.ulnaLengthCm,
    this.flags = const WeightFlags(),
    this.computation,
    this.errorMessage,
    this.latestAssessment,
    this.saveSuccess = false,
  });

  final WeightAssessmentStatus status;
  final PatientProfile? patient;
  final double? weightKg;
  final double? heightCm;
  final bool heightReliable;
  final bool hasRealWeight;
  final bool weightTrusted;
  final WeightSource weightSource;
  final bool measurementRecent;
  final DateTime? measurementDate;
  final double? kneeHeightCm;
  final double? ulnaLengthCm;
  final WeightFlags flags;
  final WeightAssessmentComputation? computation;
  final String? errorMessage;
  final WeightAssessment? latestAssessment;
  final bool saveSuccess;

  bool get canContinue =>
      patient != null && computation != null && recommendedWeight != null;

  double? get recommendedWeight {
    final calc = computation;
    if (calc == null) return null;
    switch (calc.recommendedMethod) {
      case WorkWeightMethod.real:
        return calc.recalculatedRealKg ?? weightKg;
      case WorkWeightMethod.ideal:
        return calc.idealWeightKg;
      case WorkWeightMethod.ajustado:
        return calc.adjustedWeightKg;
      case WorkWeightMethod.realAjustado:
        return calc.energyBaseKg;
      case WorkWeightMethod.otro:
        return null;
    }
  }

  WeightAssessmentState copyWith({
    WeightAssessmentStatus? status,
    PatientProfile? patient,
    double? weightKg,
    double? heightCm,
    bool? heightReliable,
    bool? hasRealWeight,
    bool? weightTrusted,
    WeightSource? weightSource,
    bool? measurementRecent,
    DateTime? measurementDate,
    double? kneeHeightCm,
    double? ulnaLengthCm,
    WeightFlags? flags,
    WeightAssessmentComputation? computation,
    String? errorMessage,
    bool setErrorMessage = false,
    WeightAssessment? latestAssessment,
    bool? saveSuccess,
  }) {
    return WeightAssessmentState(
      status: status ?? this.status,
      patient: patient ?? this.patient,
      weightKg: weightKg ?? this.weightKg,
      heightCm: heightCm ?? this.heightCm,
      heightReliable: heightReliable ?? this.heightReliable,
      hasRealWeight: hasRealWeight ?? this.hasRealWeight,
      weightTrusted: weightTrusted ?? this.weightTrusted,
      weightSource: weightSource ?? this.weightSource,
      measurementRecent: measurementRecent ?? this.measurementRecent,
      measurementDate: measurementDate ?? this.measurementDate,
      kneeHeightCm: kneeHeightCm ?? this.kneeHeightCm,
      ulnaLengthCm: ulnaLengthCm ?? this.ulnaLengthCm,
      flags: flags ?? this.flags,
      computation: computation ?? this.computation,
      errorMessage:
          setErrorMessage ? errorMessage : (errorMessage ?? this.errorMessage),
      latestAssessment: latestAssessment ?? this.latestAssessment,
      saveSuccess: saveSuccess ?? this.saveSuccess,
    );
  }

  @override
  List<Object?> get props => [
        status,
        patient,
        weightKg,
        heightCm,
        heightReliable,
        hasRealWeight,
        weightTrusted,
        weightSource,
        measurementRecent,
        measurementDate,
        kneeHeightCm,
        ulnaLengthCm,
        flags,
        computation,
        errorMessage,
        latestAssessment,
        saveSuccess,
      ];
}
