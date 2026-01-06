
import 'package:nutrivigil/domain/nutrition/products/enteral_product.dart';
import 'package:nutrivigil/domain/nutrition/products/formula_selection.dart';

class FormulaService {
  List<EnteralProduct> getRecommendations({
    bool isDiabetic = false,
    bool isRenal = false,
    bool isPulmonary = false,
    bool fluidRestriction = false,
    bool highProteinAndCalorie = false, // Critical/Sepsis
  }) {
    // If no specific condition, return Standards first
    if (!isDiabetic && !isRenal && !isPulmonary && !fluidRestriction && !highProteinAndCalorie) {
      return ProductDatabase.formulas.where((f) => 
        f.category == ProductCategory.standard || f.category == ProductCategory.standardHighProtein
      ).toList();
    }

    final recommendations = <EnteralProduct>[];

    // Priority 1: Renal (Safety critical)
    if (isRenal) {
      recommendations.addAll(ProductDatabase.formulas.where(
        (f) => f.category == ProductCategory.renal
      ));
    }

    // Priority 2: Diabetes
    if (isDiabetic) {
      recommendations.addAll(ProductDatabase.formulas.where(
        (f) => f.category == ProductCategory.diabetes
      ));
    }

    // Priority 3: Pulmonary
    if (isPulmonary) {
      recommendations.addAll(ProductDatabase.formulas.where(
        (f) => f.category == ProductCategory.pulmonary
      ));
    }

    // Priority 4: Fluid Restriction (High Density)
    if (fluidRestriction) {
      recommendations.addAll(ProductDatabase.formulas.where(
        (f) => f.kcalPerMl >= 1.5 && !recommendations.contains(f)
      ));
    }
    
    // Priority 5: High Value (Critical)
    if (highProteinAndCalorie) {
        recommendations.addAll(ProductDatabase.formulas.where(
        (f) => (f.category == ProductCategory.critical || f.proteinGramsPerLiter > 60) && !recommendations.contains(f)
      ));
    }

    // Always append Standards at the end as fallback
    recommendations.addAll(ProductDatabase.formulas.where(
      (f) => !recommendations.contains(f) && 
             (f.category == ProductCategory.standard || f.category == ProductCategory.standardHighProtein)
    ));

    return recommendations;
  }

  FormulaSelection calculatePrescription({
    required EnteralProduct product,
    required double targetCalories,
    required double targetProtein,
    required InfusionMode mode,
    required int hoursDuration, // 24 for continuous, 12-20 for cyclic
    ProteinModule? selectedModule,
  }) {
    // 1. Calculate Required Volume based on Calories
    // If powder (reconstituted), we use the kcal/ml density just like liquid
    final volumeNeeded = targetCalories / product.kcalPerMl;
    
    // 2. Bottles calculation (Standard 237ml for cans/bottles)
    // Need to handle 500ml or 1000ml bags? For MVP assuming standard 237ml or 500ml RTH
    // Let's assume standard unit is 237ml (8 fl oz) for most cans, or we could add 'unitSize' to product
    // For MVP, we'll display bottles of 237 ml
    const standardUnitMl = 237.0;
    final bottles = volumeNeeded / standardUnitMl;

    // 3. Protein check
    final proteinProvidedByFormula = (volumeNeeded / 1000) * product.proteinGramsPerLiter;
    final proteinDeficit = targetProtein - proteinProvidedByFormula;
    
    double moduleDoses = 0;
    if (selectedModule != null && proteinDeficit > 0) {
      moduleDoses = proteinDeficit / selectedModule.proteinPerDose;
    }
    
    final proteinFromModule = (selectedModule?.proteinPerDose ?? 0) * moduleDoses;
    final totalProtein = proteinProvidedByFormula + proteinFromModule;

    // 4. Rate calculation
    double rate = 0;
    double bolusVol = 0;
    int bolusCount = 0;

    if (mode == InfusionMode.bolus) {
      // Logic: Bolus every 4 hours approx? Or user defines count?
      // MVP: Fixed 5 boluses per day (every 4h with night rest?) or 6 (every 4h)
      // Let's standardize on 5 boluses for calculation
      bolusCount = 5;
      bolusVol = volumeNeeded / bolusCount;
    } else {
      // Continuous or Cyclic
      rate = volumeNeeded / hoursDuration;
    }

    return FormulaSelection(
      product: product,
      infusionMode: mode,
      totalVolumeMl: volumeNeeded,
      bottlesPerDay: bottles,
      mlPerHour: rate,
      bolusVolume: bolusVol,
      bolusCount: bolusCount,
      hoursPerDay: hoursDuration,
      proteinModule: selectedModule,
      moduleDoses: moduleDoses,
      providedCalories: targetCalories, // We match cals exactly by volume
      providedProtein: totalProtein,
      targetPercent: 100, // This logic is for 100%, UI handles the scaling
    );
  }
}
