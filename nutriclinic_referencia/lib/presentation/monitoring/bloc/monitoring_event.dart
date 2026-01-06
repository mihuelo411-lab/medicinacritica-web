part of 'monitoring_bloc.dart';

abstract class MonitoringEvent extends Equatable {
  const MonitoringEvent();

  @override
  List<Object?> get props => [];
}

class MonitoringRequested extends MonitoringEvent {
  const MonitoringRequested(this.patientId);

  final String patientId;

  @override
  List<Object?> get props => [patientId];
}

class MonitoringEntrySaved extends MonitoringEvent {
  const MonitoringEntrySaved(this.entry);

  final DailyMonitoringEntry entry;

  @override
  List<Object?> get props => [entry];
}

class MonitoringEntryDeleted extends MonitoringEvent {
  const MonitoringEntryDeleted({required this.entryId, required this.patientId});

  final String entryId;
  final String patientId;

  @override
  List<Object?> get props => [entryId, patientId];
}
