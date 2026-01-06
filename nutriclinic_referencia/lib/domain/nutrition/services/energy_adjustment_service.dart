import 'package:equatable/equatable.dart';

enum AdjustmentLevel { trophic, hypocaloric, full }

class EnergyAdjustmentInput extends Equatable {
  const EnergyAdjustmentInput({
    required this.targetCalories,
    required this.targetProtein,
    required this.intakeCalories,
    required this.intakeProtein,
    required this.route,
    required this.hasVomiting,
    required this.hasDistension,
    required this.hasDiarrhea,
    required this.hasAbdominalPain,
    required this.residualVolume,
    required this.vasopressorLevel,
    required this.hasEcmo,
    required this.ventilationMode,
    required this.balanceMl,
    required this.diuresisMlKgH,
    required this.lactate,
    required this.triglycerides,
    required this.hyperglycemia,
    required this.propofolMlH,
    required this.currentBmi,
    required this.isRenalFailure,
    this.comment,
  });

  final double targetCalories;
  final double targetProtein;
  final double intakeCalories;
  final double intakeProtein;
  final NutritionRoute route;
  final bool hasVomiting;
  final bool hasDistension;
  final bool hasDiarrhea;
  final bool hasAbdominalPain;
  final double? residualVolume;
  final VasopressorLevel vasopressorLevel;
  final bool hasEcmo;
  final VentilationMode ventilationMode;
  final double? balanceMl;
  final double? diuresisMlKgH;
  final double? lactate;
  final double? triglycerides;
  final bool hyperglycemia;
  final String? comment;
  final double propofolMlH; // New
  final double? currentBmi; // New
  final bool isRenalFailure; // New

  @override
  List<Object?> get props => [
        targetCalories,
        targetProtein,
        intakeCalories,
        intakeProtein,
        route,
        hasVomiting,
        hasDistension,
        hasDiarrhea,
        hasAbdominalPain,
        residualVolume,
        vasopressorLevel,
        hasEcmo,
        ventilationMode,
        balanceMl,
        diuresisMlKgH,
        lactate,
        triglycerides,
        hyperglycemia,
        comment,
        propofolMlH,
        currentBmi,
        isRenalFailure,
      ];
}

class EnergyAdjustmentResult extends Equatable {
  const EnergyAdjustmentResult({
    required this.level,
    required this.recommendedPercent,
    required this.adjustedCalories,
    required this.adjustedProtein,
    required this.notes,
    this.trophicRateLabel,
    this.suggestedRoute,
  });

  final AdjustmentLevel level;
  final int recommendedPercent;
  final double adjustedCalories;
  final double adjustedProtein;
  final List<String> notes;
  final String? trophicRateLabel;
  final NutritionRoute? suggestedRoute;

  @override
  List<Object?> get props => [
        level,
        recommendedPercent,
        adjustedCalories,
        adjustedProtein,
        notes,
        trophicRateLabel,
        suggestedRoute,
      ];
}

enum NutritionRoute { enteral, parenteral, mixed, fasting }

enum VasopressorLevel { none, low, high }

enum VentilationMode { none, nonInvasive, invasive, ecmo }

class EnergyAdjustmentService {
  EnergyAdjustmentResult evaluate(EnergyAdjustmentInput input) {
    final notes = <String>[];
    final bool highResidual = (input.residualVolume ?? 0) >= 500;
    final bool moderateResidual =
        (input.residualVolume ?? 0) >= 250 && (input.residualVolume ?? 0) < 500;
    final bool giIntolerance =
        input.hasVomiting || input.hasDistension || input.hasDiarrhea;
    final bool hemoUnstable = input.vasopressorLevel == VasopressorLevel.high ||
        input.hasEcmo ||
        (input.lactate ?? 0) >= 4.0 ||
        (input.balanceMl ?? 0) > 2000 ||
        (input.diuresisMlKgH ?? 1) < 0.5;

    final bool metabolicFlags =
        (input.triglycerides ?? 0) >= 400 || input.hyperglycemia;

    // Check for NPT indication
    NutritionRoute? suggestedRoute;
    if (hemoUnstable || (highResidual && giIntolerance)) {
      notes.add('ALERTA: Condición crítica sugiere fallo intestinal o inestabilidad severa.');
      notes.add('Considere Nutrición Parenteral Total (NPT) si no hay acceso enteral viable.');
      suggestedRoute = NutritionRoute.parenteral;
    }

    // 1. Calculate Propofol Credits
    double effectiveTargetCalories = input.targetCalories;
    if (input.propofolMlH > 0) {
      final propofolKcal = input.propofolMlH * 24 * 1.1; // 1.1 kcal/ml (lipid)
      effectiveTargetCalories -= propofolKcal;
      if (effectiveTargetCalories < 0) effectiveTargetCalories = 0;
      notes.add(
        'Ajuste por Propofol (${input.propofolMlH} ml/h): -${propofolKcal.toStringAsFixed(0)} kcal (lípidos) deducidas.',
      );
    }
    
    // 2. Refeeding Risk Check (BMI < 16)
    final bool refeedingRisk = (input.currentBmi ?? 20) < 16;
    if (refeedingRisk) {
       notes.add('ALERTA: Alto Riesgo de Realimentación (IMC < 16).');
    }

    if (refeedingRisk && !hemoUnstable && !highResidual) {
       // Force safe start if not already restricted by instability
       final percent = 25;
       final calories = input.targetCalories * percent / 100; // Base on original target to start slowly
       // effectiveTarget might be lower, but for refeeding we restrict total input.
       // Let's use the smaller normative restriction.
       
       final protein = input.targetProtein * percent / 100;
       
       notes.add('Protocolo "Start Low, Go Slow": Inicio al 25% para prevenir colapso metabólico.');
       
       return EnergyAdjustmentResult(
        level: AdjustmentLevel.hypocaloric,
        recommendedPercent: percent,
        adjustedCalories: calories,
        adjustedProtein: protein,
        notes: notes,
        trophicRateLabel: 'Inicio cuidadoso: 10-15 ml/h',
        suggestedRoute: suggestedRoute,
      );
    }

    if (hemoUnstable || highResidual || input.ventilationMode == VentilationMode.ecmo) {
      notes.add('Inestabilidad hemodinámica o digestiva detectada.');
      final percent = 20;
      // Trophic is usually fixed volume, not strictly % of propofol-adjusted target
      final calories = input.targetCalories * percent / 100; 
      final protein = input.targetProtein * percent / 100;
      final trophicLabel = '10-20 ml/h (~${(calories).toStringAsFixed(0)} kcal/día)';
      return EnergyAdjustmentResult(
        level: AdjustmentLevel.trophic,
        recommendedPercent: percent,
        adjustedCalories: calories,
        adjustedProtein: protein,
        notes: notes,
        trophicRateLabel: trophicLabel,
        suggestedRoute: suggestedRoute,
      );
    }

    if (moderateResidual || giIntolerance || metabolicFlags || input.vasopressorLevel == VasopressorLevel.low) {
      final percent = 50;
      // Apply propofol deduction to the active target? 
      // Usually we want to meet 50% of needs. If propofol covers part, we feed less.
      // But for simplicity in hypocaloric phase, we often just target % of total needs via nutrition.
      // Let's use effectiveTarget if possible, but don't drop below 0.
      
      var calories = effectiveTargetCalories * percent / 100;
      // Correction: Hypocaloric usually means 50% of TOTAL needs. 
      // If Propofol covers 20%, we feed 30%? Or 50% of remaining?
      // Safer: Target 50% of Total, subtract Propofol.
      
      final totalTarget50 = input.targetCalories * 0.5;
      final propofolKcal = input.propofolMlH * 24 * 1.1;
      
      // If Propofol is massive, it might cover the whole 50%.
      double feedCalories = totalTarget50 - propofolKcal;
      if (feedCalories < 0) feedCalories = 0; // Propofol covers it all
      
      final protein = input.targetProtein * percent / 100; // Protein not affected by Propofol usually
      
      notes.add('Se sugiere aporte hipocalórico progresivo (25-50 %) hasta tolerancia completa.');
      
      return EnergyAdjustmentResult(
        level: AdjustmentLevel.hypocaloric,
        recommendedPercent: percent,
        adjustedCalories: feedCalories,
        adjustedProtein: protein,
        notes: notes,
        suggestedRoute: suggestedRoute, 
      );
    }

    notes.add('Paciente apto para cubrir 100 % del objetivo.');
    // Full target: Effective (Total - Propofol)
    return EnergyAdjustmentResult(
      level: AdjustmentLevel.full,
      recommendedPercent: 100,
      adjustedCalories: effectiveTargetCalories,
      adjustedProtein: input.targetProtein,
      notes: notes,
    );
  }
}
