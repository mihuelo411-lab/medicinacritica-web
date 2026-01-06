part of 'patient_list_bloc.dart';

abstract class PatientListEvent extends Equatable {
  const PatientListEvent();

  @override
  List<Object?> get props => [];
}

class PatientsRequested extends PatientListEvent {
  const PatientsRequested();
}

class PatientDeleted extends PatientListEvent {
  const PatientDeleted(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}
