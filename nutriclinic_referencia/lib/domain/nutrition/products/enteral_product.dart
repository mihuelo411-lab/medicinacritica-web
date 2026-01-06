
enum ProductCategory {
  standard,
  standardHighProtein,
  diabetes,
  renal,
  pulmonary,
  critical,
  highDensity,
}

class EnteralProduct {
  const EnteralProduct({
    required this.name,
    required this.kcalPerMl,
    required this.proteinGramsPerLiter,
    required this.category,
    required this.description,
    this.isPowder = false,
  });

  final String name;
  final double kcalPerMl;
  final double proteinGramsPerLiter;
  final ProductCategory category;
  final String description;
  final bool isPowder;

  String get densityLabel => '${kcalPerMl.toStringAsFixed(1)} kcal/ml';
  
  // Helper for powder display
  String get nameDisplay => isPowder ? '$name (Reconstituido)' : name;
}

class ProteinModule {
  const ProteinModule({
    required this.name,
    required this.proteinPerDose,
    required this.doseLabel,
    this.isLiquid = false,
  });

  final String name;
  final double proteinPerDose;
  final String doseLabel; // e.g. "medida", "sobre", "dosis 30ml"
  final bool isLiquid;
}

class ProductDatabase {
  static const List<EnteralProduct> formulas = [
    // Standard
    EnteralProduct(
      name: 'Ensure',
      kcalPerMl: 1.0,
      proteinGramsPerLiter: 40.0,
      category: ProductCategory.standard,
      description: 'Polimérica estándar',
    ),
    EnteralProduct(
      name: 'Jevity',
      kcalPerMl: 1.0, // Can be 1.0-1.2, using 1.0 as baseline for MVP
      proteinGramsPerLiter: 44.0,
      category: ProductCategory.standard,
      description: 'Con fibra',
    ),
     EnteralProduct(
      name: 'Osmolite',
      kcalPerMl: 1.0,
      proteinGramsPerLiter: 44.0,
      category: ProductCategory.standard,
      description: 'Isotónica, alta tolerancia',
    ),
    // Standard High Protein
    EnteralProduct(
      name: 'Ensure Clinical',
      kcalPerMl: 1.5,
      proteinGramsPerLiter: 62.0,
      category: ProductCategory.standardHighProtein,
      description: 'Alta densidad proteica y calórica',
    ),
    // Powder (as Reconstituted)
    EnteralProduct(
      name: 'Ensure Polvo',
      kcalPerMl: 1.0,
      proteinGramsPerLiter: 37.2,
      category: ProductCategory.standard,
      description: 'Dilución estándar (6 medidas/195ml)',
      isPowder: true,
    ),
    EnteralProduct(
      name: 'Glucerna Polvo',
      kcalPerMl: 0.93,
      proteinGramsPerLiter: 41.0,
      category: ProductCategory.diabetes,
      description: 'Dilución estándar (5 medidas/200ml)',
      isPowder: true,
    ),
    // Diabetes
    EnteralProduct(
      name: 'Glucerna (Líquida)',
      kcalPerMl: 1.0,
      proteinGramsPerLiter: 50.0, // Varies by version, taking conservative 1.0 RTH
      category: ProductCategory.diabetes,
      description: 'Control glucémico',
    ),
    EnteralProduct(
      name: 'Diben (Fresenius)',
      kcalPerMl: 1.5,
      proteinGramsPerLiter: 75.0,
      category: ProductCategory.diabetes,
      description: 'Control glucémico alta densidad',
    ),
    // Renal
    EnteralProduct(
      name: 'Nepro',
      kcalPerMl: 1.8,
      proteinGramsPerLiter: 81.0,
      category: ProductCategory.renal,
      description: 'Alta densidad, bajo K/P (Diálisis)',
    ),
    EnteralProduct(
      name: 'Suplena',
      kcalPerMl: 1.8,
      proteinGramsPerLiter: 30.0,
      category: ProductCategory.renal,
      description: 'Pre-diálisis (Baja proteína)',
    ),
    // Pulmonary
    EnteralProduct(
      name: 'Pulmocare',
      kcalPerMl: 1.5,
      proteinGramsPerLiter: 63.0,
      category: ProductCategory.pulmonary,
      description: 'Alta en grasas, bajo CO2',
    ),
    // Critical/Immune
    EnteralProduct(
      name: 'Perative',
      kcalPerMl: 1.3,
      proteinGramsPerLiter: 66.6,
      category: ProductCategory.critical,
      description: 'Péptidos + Arginina',
    ),
    EnteralProduct(
      name: 'AlitraQ',
      kcalPerMl: 1.0,
      proteinGramsPerLiter: 52.5,
      category: ProductCategory.critical,
      description: 'Glutamina elemental',
    ),
    // Fluid Restriction
     EnteralProduct(
      name: 'Ensure Plus',
      kcalPerMl: 1.5,
      proteinGramsPerLiter: 62.0,
      category: ProductCategory.highDensity,
      description: 'Restricción hídrica',
    ),
  ];

  static const List<ProteinModule> modules = [
    ProteinModule(
      name: 'Diutin Provide Gold',
      proteinPerDose: 16.0,
      doseLabel: 'dosis (30ml)',
      isLiquid: true,
    ),
     ProteinModule(
      name: 'Caseinato de Calcio',
      proteinPerDose: 4.5,
      doseLabel: 'medida (5g)',
      isLiquid: false,
    ),
     ProteinModule(
      name: 'Proteinex',
      proteinPerDose: 15.0,
      doseLabel: 'dosis (30ml)',
      isLiquid: true,
    ),
     ProteinModule(
      name: 'Beneprotein',
      proteinPerDose: 6.0,
      doseLabel: 'medida (7g)',
      isLiquid: false,
    ),
  ];
}
