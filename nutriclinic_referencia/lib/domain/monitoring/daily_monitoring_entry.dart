import 'package:equatable/equatable.dart';

class DailyMonitoringEntry extends Equatable {
  const DailyMonitoringEntry({
    required this.id,
    required this.patientId,
    required this.date,
    this.weightKg,
    this.fluidBalanceMl,
    this.caloricIntakeKcal,
    this.proteinIntakeGrams,
    this.glucoseMin,
    this.glucoseMax,
    this.triglyceridesMgDl,
    this.creatinineMgDl,
    this.ast,
    this.alt,
    this.cReactiveProtein,
    this.procalcitonin,
    this.notes,
  });

  final String id;
  final String patientId;
  final DateTime date;
  final double? weightKg;
  final double? fluidBalanceMl;
  final double? caloricIntakeKcal;
  final double? proteinIntakeGrams;
  final double? glucoseMin;
  final double? glucoseMax;
  final double? triglyceridesMgDl;
  final double? creatinineMgDl;
  final double? ast;
  final double? alt;
  final double? cReactiveProtein;
  final double? procalcitonin;
  final String? notes;

  @override
  List<Object?> get props => [
        id,
        patientId,
        date,
        weightKg,
        fluidBalanceMl,
        caloricIntakeKcal,
        proteinIntakeGrams,
        glucoseMin,
        glucoseMax,
        triglyceridesMgDl,
        creatinineMgDl,
        ast,
        alt,
        cReactiveProtein,
        procalcitonin,
        notes,
      ];

  DailyMonitoringEntry copyWith({
    String? id,
    String? patientId,
    DateTime? date,
    double? weightKg,
    double? fluidBalanceMl,
    double? caloricIntakeKcal,
    double? proteinIntakeGrams,
    double? glucoseMin,
    double? glucoseMax,
    double? triglyceridesMgDl,
    double? creatinineMgDl,
    double? ast,
    double? alt,
    double? cReactiveProtein,
    double? procalcitonin,
    String? notes,
  }) {
    return DailyMonitoringEntry(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      date: date ?? this.date,
      weightKg: weightKg ?? this.weightKg,
      fluidBalanceMl: fluidBalanceMl ?? this.fluidBalanceMl,
      caloricIntakeKcal: caloricIntakeKcal ?? this.caloricIntakeKcal,
      proteinIntakeGrams: proteinIntakeGrams ?? this.proteinIntakeGrams,
      glucoseMin: glucoseMin ?? this.glucoseMin,
      glucoseMax: glucoseMax ?? this.glucoseMax,
      triglyceridesMgDl: triglyceridesMgDl ?? this.triglyceridesMgDl,
      creatinineMgDl: creatinineMgDl ?? this.creatinineMgDl,
      ast: ast ?? this.ast,
      alt: alt ?? this.alt,
      cReactiveProtein: cReactiveProtein ?? this.cReactiveProtein,
      procalcitonin: procalcitonin ?? this.procalcitonin,
      notes: notes ?? this.notes,
    );
  }
}
