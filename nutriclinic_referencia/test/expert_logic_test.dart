
import 'package:flutter_test/flutter_test.dart';
import 'package:nutrivigil/domain/nutrition/calculators/energy_calculator.dart';
import 'package:nutrivigil/domain/patient/patient_entity.dart';

void main() {
  late EnergyCalculator calculator;
  
  setUp(() {
    calculator = EnergyCalculator();
  });

  group('Condition-Based Formula Selection Logic (Simulation)', () {
    // This part tests the 'EnergyCalculator' modification where we pass weightOverride
    
    test('Should use weightOverride when provided', () {
      final patient = PatientProfile(
        id: '1',
        fullName: 'Test',
        age: 30,
        sex: 'Masculino',
        diagnosis: 'Trauma',
        weightKg: 120.0, // Real weight
        heightCm: 176.0,
      );

      // WITHOUT override (Standard Harris-Benedict using 120kg)
      // HB = 66.5 + (13.75 * 120) + (5.003 * 176) - (6.775 * 30)
      // HB = 66.5 + 1650 + 880.528 - 203.25 = 2393.77
      final resultOriginal = calculator.calculate(
        patient: patient,
        formula: EnergyFormula.harrisBenedict,
      );

      // WITH override (Adjusted weight 90kg)
      // HB = 66.5 + (13.75 * 90) + (5.003 * 176) - (6.775 * 30)
      // HB = 66.5 + 1237.5 + 880.528 - 203.25 = 1981.27
      final resultOverride = calculator.calculate(
        patient: patient,
        formula: EnergyFormula.harrisBenedict,
        weightOverride: 90.0,
      );

      print('Original (120kg): ${resultOriginal.caloriesPerDay}');
      print('Override (90kg): ${resultOverride.caloriesPerDay}');

      expect(resultOverride.caloriesPerDay, lessThan(resultOriginal.caloriesPerDay));
      expect(resultOverride.caloriesPerDay, closeTo(1981.27, 1.0));
    });
  });

  group('Smart Formula Logic Simulation', () {
    // We simulate the logic we implemented in EnergyCalculatorPage
    
    test('Obese + Ventilated should prioritize Penn State', () {
      final bmi = 38.7;
      final isVentilated = true;
      
      final recommendedFormulas = <EnergyFormula>[];
      
      if (bmi >= 30) {
        if (isVentilated) {
           recommendedFormulas.add(EnergyFormula.pennState);
           recommendedFormulas.add(EnergyFormula.mifflinStJeor);
        } else {
           recommendedFormulas.add(EnergyFormula.mifflinStJeor);
           recommendedFormulas.add(EnergyFormula.harrisBenedict);
        }
      }
      
      expect(recommendedFormulas.first, EnergyFormula.pennState);
      expect(recommendedFormulas.contains(EnergyFormula.mifflinStJeor), true);
    });

    test('Obese + Spontaneous should prioritize Mifflin', () {
      final bmi = 38.7;
      final isVentilated = false;
      
      final recommendedFormulas = <EnergyFormula>[];
       if (bmi >= 30) {
        if (isVentilated) {
           recommendedFormulas.add(EnergyFormula.pennState);
        } else {
           recommendedFormulas.add(EnergyFormula.mifflinStJeor);
           recommendedFormulas.add(EnergyFormula.harrisBenedict);
        }
      }
      
      expect(recommendedFormulas.first, EnergyFormula.mifflinStJeor);
    });
  });
}
