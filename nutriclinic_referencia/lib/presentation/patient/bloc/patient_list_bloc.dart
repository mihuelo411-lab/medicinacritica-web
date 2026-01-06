import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:nutrivigil/data/repositories/patient_repository.dart';
import 'package:nutrivigil/domain/patient/patient_entity.dart';

part 'patient_list_event.dart';
part 'patient_list_state.dart';

class PatientListBloc extends Bloc<PatientListEvent, PatientListState> {
  PatientListBloc(this._repository) : super(const PatientListState()) {
    on<PatientsRequested>(_onRequested);
    on<PatientDeleted>(_onDeleted);
  }

  final PatientRepository _repository;

  Future<void> _onRequested(PatientsRequested event, Emitter<PatientListState> emit) async {
    emit(state.copyWith(status: PatientListStatus.loading));
    try {
      final patients = await _repository.fetchAll();
      emit(state.copyWith(status: PatientListStatus.success, patients: patients));
    } catch (error) {
      emit(state.copyWith(status: PatientListStatus.failure, errorMessage: error.toString()));
    }
  }

  Future<void> _onDeleted(PatientDeleted event, Emitter<PatientListState> emit) async {
    try {
      await _repository.delete(event.id);
      add(const PatientsRequested());
    } catch (error) {
      emit(state.copyWith(status: PatientListStatus.failure, errorMessage: error.toString()));
    }
  }
}
