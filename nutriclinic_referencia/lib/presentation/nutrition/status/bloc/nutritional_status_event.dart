part of 'nutritional_status_bloc.dart';

enum NutritionalStatusField {
  intakeCategory,
  weightLossCategory,
  weightLossPeriod,
  hasInflammation,
  nutritionalStatusScore,
  diseaseSeverityScore,
  icuDays,
  hasComorbidities,
  requiresVentilation,
  mustCategory,
  sgaCategory,
  aspenCategory,
}

abstract class NutritionalStatusEvent extends Equatable {
  const NutritionalStatusEvent();

  @override
  List<Object?> get props => [];
}

class NutritionalStatusStarted extends NutritionalStatusEvent {
  const NutritionalStatusStarted(this.patientId);

  final String patientId;

  @override
  List<Object?> get props => [patientId];
}

class NutritionalStatusFieldChanged extends NutritionalStatusEvent {
  const NutritionalStatusFieldChanged({
    required this.field,
    this.value,
  });

  final NutritionalStatusField field;
  final Object? value;

  @override
  List<Object?> get props => [field, value];
}

class NutritionalStatusApacheRecorded extends NutritionalStatusEvent {
  const NutritionalStatusApacheRecorded({
    required this.value,
    this.details = const {},
  });

  final double value;
  final Map<String, dynamic> details;

  @override
  List<Object?> get props => [value, details];
}

class NutritionalStatusSofaRecorded extends NutritionalStatusEvent {
  const NutritionalStatusSofaRecorded({
    required this.value,
    this.details = const {},
  });

  final double value;
  final Map<String, dynamic> details;

  @override
  List<Object?> get props => [value, details];
}

class NutritionalStatusSubmitted extends NutritionalStatusEvent {
  const NutritionalStatusSubmitted();
}

class NutritionalStatusFeedbackCleared extends NutritionalStatusEvent {
  const NutritionalStatusFeedbackCleared();
}
