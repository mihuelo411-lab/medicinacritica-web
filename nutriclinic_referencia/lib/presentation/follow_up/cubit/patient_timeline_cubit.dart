import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrivigil/data/repositories/energy_plan_repository.dart';
import 'package:nutrivigil/data/repositories/patient_repository.dart';
import 'package:nutrivigil/domain/care_episode/care_episode.dart';
import 'package:nutrivigil/domain/patient/patient_entity.dart';

part 'patient_timeline_state.dart';

class PatientTimelineCubit extends Cubit<PatientTimelineState> {
  PatientTimelineCubit(
    this._patientRepository,
    this._planRepository,
  ) : super(const PatientTimelineState());

  final PatientRepository _patientRepository;
  final EnergyPlanRepository _planRepository;

  Future<void> load(String patientId) async {
    emit(state.copyWith(status: TimelineStatus.loading));
    try {
      final patient = await _patientRepository.fetchById(patientId);
      if (patient == null) {
        emit(state.copyWith(status: TimelineStatus.failure, errorMessage: 'Paciente no encontrado'));
        return;
      }

      final history = await _planRepository.historyForPatient(patientId);

      emit(state.copyWith(
        status: TimelineStatus.success,
        patient: patient,
        history: history,
      ));
    } catch (e) {
      emit(state.copyWith(status: TimelineStatus.failure, errorMessage: e.toString()));
    }
  }
}
