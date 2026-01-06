import 'package:equatable/equatable.dart';

class AlertItem extends Equatable {
  const AlertItem({
    required this.id,
    required this.patientId,
    required this.type,
    required this.message,
    required this.createdAt,
    this.dueDate,
    this.resolved = false,
  });

  final String id;
  final String patientId;
  final String type;
  final String message;
  final DateTime createdAt;
  final DateTime? dueDate;
  final bool resolved;

  AlertItem copyWith({
    String? id,
    String? patientId,
    String? type,
    String? message,
    DateTime? createdAt,
    DateTime? dueDate,
    bool? resolved,
  }) {
    return AlertItem(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      type: type ?? this.type,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
      dueDate: dueDate ?? this.dueDate,
      resolved: resolved ?? this.resolved,
    );
  }

  @override
  List<Object?> get props => [id, patientId, type, message, createdAt, dueDate, resolved];
}
