import 'package:flutter_test/flutter_test.dart';
import 'package:nutrivigil/domain/nutrition/calculators/energy_calculator.dart';
import 'package:nutrivigil/domain/patient/patient_entity.dart';

void main() {
  group('EnergyCalculator', () {
    const patient = PatientProfile(
      id: '1',
      fullName: 'Paciente Demo',
      age: 45,
      sex: 'Masculino',
      diagnosis: 'Sepsis',
      weightKg: 70,
      heightCm: 175,
    );

    test('calcula Harris-Benedict', () {
      final calculator = EnergyCalculator();
      final result = calculator.calculate(patient: patient, formula: EnergyFormula.harrisBenedict);
      expect(result.caloriesPerDay, greaterThan(0));
    });
  });
}
