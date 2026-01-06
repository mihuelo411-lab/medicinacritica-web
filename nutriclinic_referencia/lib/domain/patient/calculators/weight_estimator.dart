import 'package:nutrivigil/domain/patient/patient_entity.dart';

class WeightEstimator {
  const WeightEstimator();

  double idealBodyWeightKg({required double heightCm, required bool isMale}) {
    final inches = heightCm / 2.54;
    final base = 50.0;
    final adjustment = 2.3 * (inches - 60);
    return (isMale ? base : 45.5) + adjustment.clamp(0, double.infinity);
  }

  double adjustedBodyWeightKg({required double actualWeightKg, required double idealWeightKg}) {
    if (actualWeightKg <= idealWeightKg) {
      return actualWeightKg;
    }
    return idealWeightKg + 0.25 * (actualWeightKg - idealWeightKg);
  }

  double bmiKgM2({required double weightKg, required double heightCm}) {
    final heightM = heightCm / 100;
    if (heightM == 0) {
      return 0;
    }
    return weightKg / (heightM * heightM);
  }

  PatientProfile withUpdatedAnthropometrics({
    required PatientProfile patient,
    double? weightKg,
    double? heightCm,
  }) {
    return patient.copyWith(
      weightKg: weightKg ?? patient.weightKg,
      heightCm: heightCm ?? patient.heightCm,
    );
  }
}
