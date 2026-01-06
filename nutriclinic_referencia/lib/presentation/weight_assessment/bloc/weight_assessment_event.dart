part of 'weight_assessment_bloc.dart';

abstract class WeightAssessmentEvent extends Equatable {
  const WeightAssessmentEvent();

  @override
  List<Object?> get props => [];
}

class WeightAssessmentStarted extends WeightAssessmentEvent {
  const WeightAssessmentStarted(this.patientId);

  final String patientId;

  @override
  List<Object?> get props => [patientId];
}

class WeightAssessmentVitalsChanged extends WeightAssessmentEvent {
  const WeightAssessmentVitalsChanged({
    this.weightKg,
    this.heightCm,
    this.heightReliable,
    this.weightSource,
    this.measurementRecent,
    this.measurementDate,
    this.weightTrusted,
  });

  final double? weightKg;
  final double? heightCm;
  final bool? heightReliable;
  final WeightSource? weightSource;
  final bool? measurementRecent;
  final DateTime? measurementDate;
  final bool? weightTrusted;
}

class WeightAssessmentAvailabilityChanged extends WeightAssessmentEvent {
  const WeightAssessmentAvailabilityChanged(this.hasRealWeight);

  final bool hasRealWeight;

  @override
  List<Object?> get props => [hasRealWeight];
}

class WeightAssessmentAnthropometryChanged extends WeightAssessmentEvent {
  const WeightAssessmentAnthropometryChanged({
    this.kneeHeightCm,
    this.ulnaLengthCm,
  });

  final double? kneeHeightCm;
  final double? ulnaLengthCm;

  @override
  List<Object?> get props => [kneeHeightCm, ulnaLengthCm];
}

class WeightAssessmentFlagsChanged extends WeightAssessmentEvent {
  const WeightAssessmentFlagsChanged(this.flags);

  final WeightFlags flags;

  @override
  List<Object?> get props => [flags];
}

class WeightAssessmentSaved extends WeightAssessmentEvent {
  const WeightAssessmentSaved();
}
