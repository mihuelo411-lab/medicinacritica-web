import 'package:equatable/equatable.dart';

class NutritionalAssessment extends Equatable {
  const NutritionalAssessment({
    required this.id,
    required this.patientId,
    required this.createdAt,
    this.nutricScore,
    this.nrsScore,
    this.apacheScore,
    this.sofaScore,
    this.pendingItems = const [],
    this.notes,
    this.trace,
  });

  final String id;
  final String patientId;
  final DateTime createdAt;
  final double? nutricScore;
  final double? nrsScore;
  final double? apacheScore;
  final double? sofaScore;
  final List<String> pendingItems;
  final String? notes;
  final Map<String, dynamic>? trace;

  NutritionalAssessment copyWith({
    String? id,
    String? patientId,
    DateTime? createdAt,
    double? nutricScore,
    double? nrsScore,
    double? apacheScore,
    double? sofaScore,
    List<String>? pendingItems,
    String? notes,
    Map<String, dynamic>? trace,
  }) {
    return NutritionalAssessment(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      createdAt: createdAt ?? this.createdAt,
      nutricScore: nutricScore ?? this.nutricScore,
      nrsScore: nrsScore ?? this.nrsScore,
      apacheScore: apacheScore ?? this.apacheScore,
      sofaScore: sofaScore ?? this.sofaScore,
      pendingItems: pendingItems ?? this.pendingItems,
      notes: notes ?? this.notes,
      trace: trace ?? this.trace,
    );
  }

  @override
  List<Object?> get props => [
        id,
        patientId,
        createdAt,
        nutricScore,
        nrsScore,
        apacheScore,
        sofaScore,
        pendingItems,
        notes,
        trace,
      ];
}
