part of 'monitoring_bloc.dart';

enum MonitoringStatus { initial, loading, success, failure }

class MonitoringState extends Equatable {
  const MonitoringState({
    this.status = MonitoringStatus.initial,
    this.entries = const [],
    this.errorMessage,
  });

  final MonitoringStatus status;
  final List<DailyMonitoringEntry> entries;
  final String? errorMessage;

  MonitoringState copyWith({
    MonitoringStatus? status,
    List<DailyMonitoringEntry>? entries,
    String? errorMessage,
  }) {
    return MonitoringState(
      status: status ?? this.status,
      entries: entries ?? this.entries,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, entries, errorMessage];
}
