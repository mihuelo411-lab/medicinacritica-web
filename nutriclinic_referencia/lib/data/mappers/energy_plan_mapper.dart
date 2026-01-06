import 'package:nutrivigil/domain/care_episode/care_episode.dart';
import 'package:nutrivigil/domain/nutrition/nutrition_requirements.dart';

extension EnergyPlanSnapshotJson on EnergyPlanSnapshot {
  Map<String, dynamic> toJson() => EnergyPlanSnapshotJsonMapper.toJson(this);
}

class EnergyPlanSnapshotJsonMapper {
  static Map<String, dynamic> toJson(EnergyPlanSnapshot snapshot) {
    return {
      'requirements': _requirementsToJson(snapshot.requirements),
      'lipidPercent': snapshot.lipidPercent,
      'proteinPerKg': snapshot.proteinPerKg,
      'referenceWeightLabel': snapshot.referenceWeightLabel,
      'macroTargets': _macroToJson(snapshot.macroTargets),
      'factorStressLabel': snapshot.factorStressLabel,
      'triglycerides': snapshot.triglycerides,
      'formulas': snapshot.formulas?.map(_formulaToJson).toList(),
      'meanCalories': snapshot.meanCalories,
    };
  }

  static EnergyPlanSnapshot fromJson(Map<String, dynamic> json, {DateTime? createdAt}) {
    return EnergyPlanSnapshot(
      requirements: _requirementsFromJson(json['requirements'] as Map<String, dynamic>),
      lipidPercent: (json['lipidPercent'] as num?)?.toDouble(),
      proteinPerKg: (json['proteinPerKg'] as num?)?.toDouble(),
      referenceWeightLabel: json['referenceWeightLabel'] as String?,
      macroTargets: _macroFromJson(json['macroTargets'] as Map<String, dynamic>?),
      factorStressLabel: json['factorStressLabel'] as String?,
      triglycerides: (json['triglycerides'] as num?)?.toDouble(),
      formulas: (json['formulas'] as List<dynamic>?)
          ?.map((item) => _formulaFromJson(item as Map<String, dynamic>))
          .toList(),
      meanCalories: (json['meanCalories'] as num?)?.toDouble(),
      createdAt: createdAt,
    );
  }

  static Map<String, dynamic> _requirementsToJson(NutritionRequirements requirements) {
    return {
      'method': requirements.method,
      'caloriesPerDay': requirements.caloriesPerDay,
      'proteinGrams': requirements.proteinGrams,
      'notes': requirements.notes,
    };
  }

  static NutritionRequirements _requirementsFromJson(Map<String, dynamic> json) {
    return NutritionRequirements(
      method: json['method'] as String? ?? 'Desconocido',
      caloriesPerDay: (json['caloriesPerDay'] as num).toDouble(),
      proteinGrams: (json['proteinGrams'] as num).toDouble(),
      notes: json['notes'] as String?,
    );
  }

  static Map<String, dynamic>? _macroToJson(MacroTargetsSnapshot? macros) {
    if (macros == null) {
      return null;
    }
    return {
      'proteinGrams': macros.proteinGrams,
      'lipidGrams': macros.lipidGrams,
      'carbohydrateGrams': macros.carbohydrateGrams,
      'proteinPercent': macros.proteinPercent,
      'lipidPercent': macros.lipidPercent,
      'carbohydratePercent': macros.carbohydratePercent,
    };
  }

  static MacroTargetsSnapshot? _macroFromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }
    return MacroTargetsSnapshot(
      proteinGrams: (json['proteinGrams'] as num).toDouble(),
      lipidGrams: (json['lipidGrams'] as num).toDouble(),
      carbohydrateGrams: (json['carbohydrateGrams'] as num).toDouble(),
      proteinPercent: (json['proteinPercent'] as num?)?.toDouble(),
      lipidPercent: (json['lipidPercent'] as num?)?.toDouble(),
      carbohydratePercent: (json['carbohydratePercent'] as num?)?.toDouble(),
    );
  }

  static Map<String, dynamic> _formulaToJson(FormulaBreakdown formula) {
    return {
      'name': formula.name,
      'calories': formula.calories,
      'proteinGrams': formula.proteinGrams,
      'notes': formula.notes,
    };
  }

  static FormulaBreakdown _formulaFromJson(Map<String, dynamic> json) {
    return FormulaBreakdown(
      name: json['name'] as String? ?? '',
      calories: (json['calories'] as num).toDouble(),
      proteinGrams: (json['proteinGrams'] as num).toDouble(),
      notes: json['notes'] as String?,
    );
  }
}
