import 'package:equatable/equatable.dart';

import 'package:nutrivigil/domain/patient/patient_entity.dart';
import 'package:nutrivigil/domain/patient/services/weight_assessment_service.dart';
import 'package:nutrivigil/domain/nutrition/nutrition_requirements.dart';
import 'package:nutrivigil/domain/nutrition/services/energy_adjustment_service.dart';
import 'package:nutrivigil/domain/nutrition/products/formula_selection.dart';

class CareEpisode extends Equatable {
  const CareEpisode({
    this.patient,
    this.weightAssessment,
    this.riskSnapshot,
    this.energyPlan,
    this.adjustment,
    this.prescription,
  });

  final PatientProfile? patient;
  final WeightAssessmentComputation? weightAssessment;
  final RiskSnapshot? riskSnapshot;
  final EnergyPlanSnapshot? energyPlan;
  final AdjustmentSnapshot? adjustment;
  final FormulaSelection? prescription;

  CareEpisode copyWith({
    PatientProfile? patient,
    WeightAssessmentComputation? weightAssessment,
    RiskSnapshot? riskSnapshot,
    EnergyPlanSnapshot? energyPlan,
    AdjustmentSnapshot? adjustment,
    FormulaSelection? prescription,
  }) {
    return CareEpisode(
      patient: patient ?? this.patient,
      weightAssessment: weightAssessment ?? this.weightAssessment,
      riskSnapshot: riskSnapshot ?? this.riskSnapshot,
      energyPlan: energyPlan ?? this.energyPlan,
      adjustment: adjustment ?? this.adjustment,
      prescription: prescription ?? this.prescription,
    );
  }

  @override
  List<Object?> get props => [
        patient,
        weightAssessment,
        riskSnapshot,
        energyPlan,
        adjustment,
        prescription,
      ];
}

class RiskSnapshot extends Equatable {
  const RiskSnapshot({
    this.mustCategory,
    this.sgaCategory,
    this.aspenCategory,
    this.nutricScore,
    this.nrsScore,
    this.primaryLabel,
  });

  final String? mustCategory;
  final String? sgaCategory;
  final String? aspenCategory;
  final double? nutricScore;
  final double? nrsScore;
  final String? primaryLabel;

  @override
  List<Object?> get props => [
        mustCategory,
        sgaCategory,
        aspenCategory,
        nutricScore,
        nrsScore,
        primaryLabel,
      ];
}

class EnergyPlanSnapshot extends Equatable {
  const EnergyPlanSnapshot({
    required this.requirements,
    this.lipidPercent,
    this.proteinPerKg,
    this.referenceWeightLabel,
    this.macroTargets,
    this.factorStressLabel,
    this.triglycerides,
    this.formulas,
    this.meanCalories,
    this.createdAt,
  });

  final NutritionRequirements requirements;
  final double? lipidPercent;
  final double? proteinPerKg;
  final String? referenceWeightLabel;
  final MacroTargetsSnapshot? macroTargets;
  final String? factorStressLabel;
  final double? triglycerides;
  final List<FormulaBreakdown>? formulas;
  final double? meanCalories;
  final DateTime? createdAt;

  @override
  List<Object?> get props => [
        requirements,
        lipidPercent,
        proteinPerKg,
        referenceWeightLabel,
        macroTargets,
        factorStressLabel,
        triglycerides,
        formulas,
        meanCalories,
        createdAt,
      ];
}

class MacroTargetsSnapshot extends Equatable {
  const MacroTargetsSnapshot({
    required this.proteinGrams,
    required this.lipidGrams,
    required this.carbohydrateGrams,
    this.proteinPercent,
    this.lipidPercent,
    this.carbohydratePercent,
  });

  final double proteinGrams;
  final double lipidGrams;
  final double carbohydrateGrams;
  final double? proteinPercent;
  final double? lipidPercent;
  final double? carbohydratePercent;

  @override
  List<Object?> get props => [
        proteinGrams,
        lipidGrams,
        carbohydrateGrams,
        proteinPercent,
        lipidPercent,
        carbohydratePercent,
      ];
}

class AdjustmentSnapshot extends Equatable {
  const AdjustmentSnapshot({
    required this.result,
    this.appliedPercent,
    this.notes,
    this.route,
  });

  final EnergyAdjustmentResult result;
  final double? appliedPercent;
  final String? notes;
  final String? route; // 'enteral', 'parenteral', 'mixed'

  @override
  List<Object?> get props => [result, appliedPercent, notes, route];
}

class FormulaBreakdown extends Equatable {
  const FormulaBreakdown({
    required this.name,
    required this.calories,
    required this.proteinGrams,
    this.notes,
  });

  final String name;
  final double calories;
  final double proteinGrams;
  final String? notes;

  @override
  List<Object?> get props => [name, calories, proteinGrams, notes];
}
