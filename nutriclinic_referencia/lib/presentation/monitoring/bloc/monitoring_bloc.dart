import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:nutrivigil/data/repositories/monitoring_repository.dart';
import 'package:nutrivigil/domain/monitoring/daily_monitoring_entry.dart';

part 'monitoring_event.dart';
part 'monitoring_state.dart';

class MonitoringBloc extends Bloc<MonitoringEvent, MonitoringState> {
  MonitoringBloc(this._repository) : super(const MonitoringState()) {
    on<MonitoringRequested>(_onRequested);
    on<MonitoringEntrySaved>(_onSaved);
    on<MonitoringEntryDeleted>(_onDeleted);
  }

  final MonitoringRepository _repository;

  Future<void> _onRequested(MonitoringRequested event, Emitter<MonitoringState> emit) async {
    emit(state.copyWith(status: MonitoringStatus.loading));
    try {
      final entries = await _repository.fetchByPatient(event.patientId);
      emit(state.copyWith(status: MonitoringStatus.success, entries: entries));
    } catch (error) {
      emit(state.copyWith(status: MonitoringStatus.failure, errorMessage: error.toString()));
    }
  }

  Future<void> _onSaved(MonitoringEntrySaved event, Emitter<MonitoringState> emit) async {
    try {
      await _repository.save(event.entry);
      add(MonitoringRequested(event.entry.patientId));
    } catch (error) {
      emit(state.copyWith(status: MonitoringStatus.failure, errorMessage: error.toString()));
    }
  }

  Future<void> _onDeleted(MonitoringEntryDeleted event, Emitter<MonitoringState> emit) async {
    try {
      await _repository.delete(event.entryId);
      add(MonitoringRequested(event.patientId));
    } catch (error) {
      emit(state.copyWith(status: MonitoringStatus.failure, errorMessage: error.toString()));
    }
  }
}
