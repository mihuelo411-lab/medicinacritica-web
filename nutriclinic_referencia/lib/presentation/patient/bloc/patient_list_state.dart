part of 'patient_list_bloc.dart';

enum PatientListStatus { initial, loading, success, failure }

class PatientListState extends Equatable {
  const PatientListState({
    this.status = PatientListStatus.initial,
    this.patients = const [],
    this.errorMessage,
  });

  final PatientListStatus status;
  final List<PatientProfile> patients;
  final String? errorMessage;

  PatientListState copyWith({
    PatientListStatus? status,
    List<PatientProfile>? patients,
    String? errorMessage,
  }) {
    return PatientListState(
      status: status ?? this.status,
      patients: patients ?? this.patients,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, patients, errorMessage];
}
