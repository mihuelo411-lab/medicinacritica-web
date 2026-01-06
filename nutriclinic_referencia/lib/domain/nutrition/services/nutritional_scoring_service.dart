import 'package:nutrivigil/domain/nutrition/nutritional_assessment.dart';

class NutricInput {
  const NutricInput({
    required this.age,
    this.apacheScore,
    this.sofaScore,
    this.icuDays = 0,
    this.hasComorbidities = false,
    this.requiresVentilation = false,
  });

  final int age;
  final double? apacheScore;
  final double? sofaScore;
  final int icuDays;
  final bool hasComorbidities;
  final bool requiresVentilation;
}

class NrsInput {
  const NrsInput({
    required this.nutritionalStatus,
    required this.diseaseSeverity,
    required this.age,
  });

  final int nutritionalStatus;
  final int diseaseSeverity;
  final int age;
}

class NutritionalScoreResult {
  const NutritionalScoreResult({
    required this.nutricScore,
    required this.nrsScore,
    required this.pendingItems,
  });

  final double? nutricScore;
  final double? nrsScore;
  final List<String> pendingItems;
}

class NutritionalScoringService {
  NutritionalScoreResult evaluate({
    required NutricInput nutric,
    required NrsInput nrs,
  }) {
    final pending = <String>[];
    final nutricScore = _nutricScore(nutric, pending);
    final nrsScore = _nrsScore(nrs, pending);
    return NutritionalScoreResult(
      nutricScore: nutricScore,
      nrsScore: nrsScore,
      pendingItems: pending,
    );
  }

  double? _nutricScore(NutricInput input, List<String> pending) {
    if (input.apacheScore == null) {
      pending.add('Calcular APACHE II');
    }
    if (input.sofaScore == null) {
      pending.add('Calcular SOFA');
    }
    if (input.apacheScore == null || input.sofaScore == null) {
      return null;
    }
    final agePoints = input.age >= 75
        ? 2
        : (input.age >= 50 ? 1 : 0);
    
    // Modified NUTRIC Score Cutoffs
    // APACHE II: <15 (0), 15-19 (1), 20-27 (2), >=28 (3)
    final apachePoints = input.apacheScore! >= 28
        ? 3
        : (input.apacheScore! >= 20
            ? 2
            : (input.apacheScore! >= 15 ? 1 : 0));
            
    // SOFA: <5 (0), 5-6 (1), 7-9 (2), >=10 (3)
    final sofaPoints = input.sofaScore! >= 10
        ? 3
        : (input.sofaScore! >= 7
            ? 2
            : (input.sofaScore! >= 5 ? 1 : 0));
            
    // Days from hospital to ICU: 0-<1 (0), >=1 (1)
    // Using icuDays field as proxy for "Hospital Days" based on user context
    final daysPoints = input.icuDays >= 1 ? 1 : 0;
    
    final comorbPoints = input.hasComorbidities ? 1 : 0;
    
    // Ventilation is NOT part of Modified NUTRIC (it was linked to IL-6 proxy in some studies but generally excluded)
    // We remove it to strictly follow the standard Modified NUTRIC Score (0-9 range)
    
    return (agePoints + apachePoints + sofaPoints + daysPoints + comorbPoints).toDouble();
  }

  double _nrsScore(NrsInput input, List<String> pending) {
    if (input.nutritionalStatus < 0 || input.diseaseSeverity < 0) {
      pending.add('Completar componentes NRS-2002');
      return 0;
    }
    final agePoints = input.age >= 70 ? 1 : 0;
    return (input.nutritionalStatus + input.diseaseSeverity + agePoints).toDouble();
  }
}
