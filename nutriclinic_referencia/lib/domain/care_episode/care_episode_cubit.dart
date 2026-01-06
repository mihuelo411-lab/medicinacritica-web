import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:nutrivigil/domain/care_episode/care_episode.dart';
import 'package:nutrivigil/domain/patient/patient_entity.dart';
import 'package:nutrivigil/domain/patient/services/weight_assessment_service.dart';
import 'package:nutrivigil/domain/nutrition/nutrition_requirements.dart';
import 'package:nutrivigil/domain/nutrition/services/energy_adjustment_service.dart';
import 'package:nutrivigil/domain/nutrition/products/formula_selection.dart';

class CareEpisodeCubit extends Cubit<CareEpisode> {
  CareEpisodeCubit() : super(const CareEpisode());

  void setPatient(PatientProfile patient) {
    emit(state.copyWith(patient: patient));
  }

  void setWeightAssessment(WeightAssessmentComputation computation) {
    emit(state.copyWith(weightAssessment: computation));
  }

  void setRiskSnapshot(RiskSnapshot snapshot) {
    emit(state.copyWith(riskSnapshot: snapshot));
  }

  void setEnergyPlan({
    required NutritionRequirements requirements,
    double? lipidPercent,
    double? proteinPerKg,
    String? referenceWeightLabel,
    MacroTargetsSnapshot? macros,
    String? stressLabel,
    double? triglycerides,
    List<FormulaBreakdown>? formulas,
    double? meanCalories,
  }) {
    emit(
      state.copyWith(
        energyPlan: EnergyPlanSnapshot(
          requirements: requirements,
          lipidPercent: lipidPercent,
          proteinPerKg: proteinPerKg,
          referenceWeightLabel: referenceWeightLabel,
          macroTargets: macros,
          factorStressLabel: stressLabel,
          triglycerides: triglycerides,
          formulas: formulas,
          meanCalories: meanCalories,
          createdAt: DateTime.now(), // Auto-set when saving/setting
        ),
      ),
    );
  }

  void setAdjustment({
    required EnergyAdjustmentResult result,
    double? appliedPercent,
    String? notes,
    String? route,
  }) {
    emit(
      state.copyWith(
        adjustment: AdjustmentSnapshot(
          result: result,
          appliedPercent: appliedPercent,
          notes: notes,
          route: route,
        ),
      ),
    );
  }

  void setPrescription(FormulaSelection selection) {
    emit(state.copyWith(prescription: selection));
  }

  void reset() {
    emit(const CareEpisode());
  }
}
