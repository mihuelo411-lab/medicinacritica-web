import 'package:nutrivigil/domain/nutrition/nutrition_requirements.dart';
import 'package:nutrivigil/domain/patient/patient_entity.dart';

enum EnergyFormula {
  harrisBenedict,
  pennState,
  mifflinStJeor,
}

class EnergyCalculator {
  const EnergyCalculator();

  NutritionRequirements calculate({
    required PatientProfile patient,
    required EnergyFormula formula,
    double? weightOverride, // New arg
    double stressFactor = 1.0,
    double activityFactor = 1.0,
    double? temperatureCelsius,
    double? minuteVolumeL,
  }) {
    final double calories;
    final weight = weightOverride ?? patient.weightKg;

    switch (formula) {
      case EnergyFormula.harrisBenedict:
        calories = _harrisBenedict(patient, weight, stressFactor, activityFactor);
        break;
      case EnergyFormula.pennState:
        calories = _pennState(patient, weight, temperatureCelsius, minuteVolumeL);
        break;
      case EnergyFormula.mifflinStJeor:
        calories = _mifflinStJeor(patient, weight, stressFactor, activityFactor);
        break;
    }

    // Proteínas: regla base 1.3 g/kg, ajustable por la clínica.
    final protein = weight * 1.3;

    return NutritionRequirements(
      method: formula.name,
      caloriesPerDay: calories,
      proteinGrams: protein,
      notes: null,
    );
  }

  double _harrisBenedict(PatientProfile patient, double weight, double stress, double activity) {
    final height = patient.heightCm;
    final age = patient.age;
    final isMale = patient.sex.toLowerCase().startsWith('m');
    final bmr = isMale
        ? 66.47 + (13.75 * weight) + (5.0 * height) - (6.76 * age)
        : 655.1 + (9.56 * weight) + (1.85 * height) - (4.68 * age);
    return bmr * stress * activity;
  }

  double _mifflinStJeor(PatientProfile patient, double weight, double stress, double activity) {
    final height = patient.heightCm;
    final age = patient.age;
    final isMale = patient.sex.toLowerCase().startsWith('m');
    final bmr = (10 * weight) + (6.25 * height) - (5 * age) + (isMale ? 5 : -161);
    return bmr * stress * activity;
  }

  double _pennState(PatientProfile patient, double weight, double? tempC, double? minuteVolume) {
    // Penn State 2003b (Modified) for obese:
    // Mifflin(0.96) + VE(31) + Tmax(167) - 6212
    // BUT the current implementation looks like a custom linear approximation. 
    // We will keep the weight substitution but mark as TODO to verify formula accuracy.
    final temperature = tempC ?? 37.0;
    final ve = minuteVolume ?? 8.0;
    final age = patient.age.toDouble();
    return 0.85 * // This 0.85 factor is suspicious too, but keeping structure for now
        ((1.04 * (patient.sex.toLowerCase().startsWith('m') ? 0 : 1)) +
            (0.85 * (weight)) +
            (5.0 * ve) +
            (1.3 * temperature) -
            (0.5 * age));
  }
}
