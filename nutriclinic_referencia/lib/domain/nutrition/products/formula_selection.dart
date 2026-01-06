
import 'enteral_product.dart';

enum InfusionMode {
  continuous,
  cyclic,
  bolus,
}

class FormulaSelection {
  const FormulaSelection({
    required this.product,
    required this.infusionMode,
    required this.totalVolumeMl,
    required this.bottlesPerDay,
    required this.mlPerHour, // For continuous/cyclic
    required this.bolusVolume, // For bolus
    required this.bolusCount, // For bolus
    required this.hoursPerDay, // Duration (e.g. 24h or 16h)
    required this.proteinModule,
    required this.moduleDoses,
    required this.providedCalories,
    required this.providedProtein,
    required this.targetPercent, // 100% vs 50%
  });

  final EnteralProduct product;
  final InfusionMode infusionMode;
  
  // Volume & Packaging
  final double totalVolumeMl;
  final double bottlesPerDay;
  
  // Rate
  final double mlPerHour;
  final double bolusVolume;
  final int bolusCount;
  final int hoursPerDay;

  // Supplements
  final ProteinModule? proteinModule;
  final double moduleDoses;

  // Actual Nutrition
  final double providedCalories;
  final double providedProtein;
  
  // Goal
  final double targetPercent;

  String get infusionLabel {
    switch (infusionMode) {
      case InfusionMode.continuous:
        return '${mlPerHour.toStringAsFixed(0)} ml/h por ${hoursPerDay}h';
      case InfusionMode.cyclic:
        return 'Cíclica: ${mlPerHour.toStringAsFixed(0)} ml/h por ${hoursPerDay}h';
      case InfusionMode.bolus:
        return 'Bolos: ${bolusVolume.toStringAsFixed(0)} ml cada 4h ($bolusCount tomas)';
    }
  }

  double get proteinGramsPerDay => providedProtein; // Helper alias
}
