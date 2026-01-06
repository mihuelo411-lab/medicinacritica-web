part of 'patient_timeline_cubit.dart';

enum TimelineStatus { initial, loading, success, failure }

class PatientTimelineState extends Equatable {
  const PatientTimelineState({
    this.status = TimelineStatus.initial,
    this.patient,
    this.history = const [],
    this.errorMessage,
  });

  final TimelineStatus status;
  final PatientProfile? patient;
  final List<EnergyPlanSnapshot> history;
  final String? errorMessage;

  PatientTimelineState copyWith({
    TimelineStatus? status,
    PatientProfile? patient,
    List<EnergyPlanSnapshot>? history,
    String? errorMessage,
  }) {
    return PatientTimelineState(
      status: status ?? this.status,
      patient: patient ?? this.patient,
      history: history ?? this.history,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, patient, history, errorMessage];
}
