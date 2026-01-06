part of 'nutritional_status_bloc.dart';

enum NutritionalStatusViewStatus { initial, loading, ready, error }

enum NutritionalStatusSaveStatus { idle, saving, success, failure }

enum IntakeCategory { lt50, gte50 }

enum WeightLossCategory { none, lt5, from5to10, gt10 }

enum WeightLossPeriod { less1Month, oneToThree, threeToSix, moreSix }

class NutritionalStatusState extends Equatable {
  const NutritionalStatusState({
    this.status = NutritionalStatusViewStatus.initial,
    this.saveStatus = NutritionalStatusSaveStatus.idle,
    this.patient,
    this.latest,
    this.errorMessage,
    this.intakeCategory,
    this.weightLossCategory,
    this.weightLossPeriod,
    this.hasInflammation,
    this.nutritionalStatusScore,
    this.diseaseSeverityScore,
    this.icuDays = 0,
    this.hasComorbidities = false,
    this.requiresVentilation = false,
    this.mustCategory,
    this.sgaCategory,
    this.aspenCategory,
    this.apacheScore,
    this.sofaScore,
    this.apacheDetails,
    this.sofaDetails,
    this.nutricScore,
    this.nrsScore,
    this.pendingItems = const [],
    this.displayWeight,
    this.displayHeight,
    this.displayBmi,
    this.weightReferenceLabel,
  });

  final NutritionalStatusViewStatus status;
  final NutritionalStatusSaveStatus saveStatus;
  final PatientProfile? patient;
  final NutritionalAssessment? latest;
  final String? errorMessage;

  final IntakeCategory? intakeCategory;
  final WeightLossCategory? weightLossCategory;
  final WeightLossPeriod? weightLossPeriod;
  final bool? hasInflammation;
  final int? nutritionalStatusScore;
  final int? diseaseSeverityScore;
  final int icuDays;
  final bool hasComorbidities;
  final bool requiresVentilation;
  final String? mustCategory;
  final String? sgaCategory;
  final String? aspenCategory;
  final double? apacheScore;
  final double? sofaScore;
  final Map<String, dynamic>? apacheDetails;
  final Map<String, dynamic>? sofaDetails;
  final double? nutricScore;
  final double? nrsScore;
  final List<String> pendingItems;
  final double? displayWeight;
  final double? displayHeight;
  final double? displayBmi;
  final String? weightReferenceLabel;

  bool get isReady =>
      status == NutritionalStatusViewStatus.ready && patient != null;

  String get primaryScale {
    if (aspenCategory != null) return 'ASPEN/GLIM';
    if (sgaCategory != null) return 'SGA';
    if (mustCategory != null) return 'MUST';
    if (nutricScore != null) return 'NUTRIC';
    if (nrsScore != null) return 'NRS-2002';
    return 'Pendiente';
  }

  String get primaryStatusLabel {
    if (aspenCategory != null) {
      return 'ASPEN: $aspenCategory';
    }
    if (sgaCategory != null) {
      return 'SGA: $sgaCategory';
    }
    if (mustCategory != null) {
      return 'MUST: $mustCategory';
    }
    if (nutricScore != null) {
      final risk = nutricScore! >= 5 ? 'Alto riesgo' : 'Riesgo moderado';
      return '$risk (NUTRIC ${nutricScore!.toStringAsFixed(1)})';
    }
    if (nrsScore != null) {
      final risk =
          nrsScore! >= 3 ? 'Riesgo nutricional' : 'Sin riesgo significativo';
      return '$risk (NRS ${nrsScore!.toStringAsFixed(1)})';
    }
    return 'Evaluación incompleta';
  }

  String? get nutricNarrative {
    if (nutricScore == null) return null;
    final risk =
        nutricScore! >= 5 ? 'Riesgo nutricional alto' : 'Riesgo moderado';
    return '$risk según cálculo energético (NUTRIC ${nutricScore!.toStringAsFixed(1)})';
  }

  String? get nrsNarrative {
    if (nrsScore == null) return null;
    final risk = nrsScore! >= 3
        ? 'Riesgo nutricional clínico'
        : 'Sin riesgo significativo';
    return '$risk (NRS ${nrsScore!.toStringAsFixed(1)})';
  }

  String? get mustNarrative =>
      mustCategory == null ? null : 'Riesgo global percibido: $mustCategory';

  String? get sgaNarrative =>
      sgaCategory == null ? null : 'Valoración subjetiva: Clase $sgaCategory';

  String? get aspenNarrative =>
      aspenCategory == null ? null : 'Fenotipo ASPEN/GLIM: $aspenCategory';

  String? get energyRiskLabel {
    if (aspenCategory != null && aspenCategory!.isNotEmpty) {
      if (aspenCategory == 'Sin criterios') {
        return 'Sin criterios fenotípicos (ASPEN/GLIM)';
      }
      return 'Riesgo ${aspenCategory!.toLowerCase()} (ASPEN/GLIM)';
    }
    if (mustCategory != null && mustCategory!.isNotEmpty) {
      return 'Riesgo ${mustCategory!.toLowerCase()} (MUST)';
    }
    if (sgaCategory != null && sgaCategory!.isNotEmpty) {
      return 'SGA $sgaCategory';
    }
    if (nutricScore != null) {
      return nutricScore! >= 5
          ? 'Riesgo nutricional alto'
          : 'Riesgo nutricional moderado';
    }
    if (nrsScore != null) {
      return nrsScore! >= 3 ? 'Riesgo nutricional clínico' : 'Riesgo leve';
    }
    return null;
  }

  NutritionalStatusState copyWith({
    NutritionalStatusViewStatus? status,
    NutritionalStatusSaveStatus? saveStatus,
    PatientProfile? patient,
    NutritionalAssessment? latest,
    Object? errorMessage = _sentinel,
    Object? intakeCategory = _sentinel,
    Object? weightLossCategory = _sentinel,
    Object? weightLossPeriod = _sentinel,
    Object? hasInflammation = _sentinel,
    Object? nutritionalStatusScore = _sentinel,
    Object? diseaseSeverityScore = _sentinel,
    int? icuDays,
    bool? hasComorbidities,
    bool? requiresVentilation,
    Object? mustCategory = _sentinel,
    Object? sgaCategory = _sentinel,
    Object? aspenCategory = _sentinel,
    Object? apacheScore = _sentinel,
    Object? sofaScore = _sentinel,
    Map<String, dynamic>? apacheDetails,
    Map<String, dynamic>? sofaDetails,
    double? nutricScore,
    double? nrsScore,
    List<String>? pendingItems,
    Object? displayWeight = _sentinel,
    Object? displayHeight = _sentinel,
    Object? displayBmi = _sentinel,
    Object? weightReferenceLabel = _sentinel,
  }) {
    return NutritionalStatusState(
      status: status ?? this.status,
      saveStatus: saveStatus ?? this.saveStatus,
      patient: patient ?? this.patient,
      latest: latest ?? this.latest,
      errorMessage: identical(errorMessage, _sentinel)
          ? this.errorMessage
          : errorMessage as String?,
      intakeCategory: identical(intakeCategory, _sentinel)
          ? this.intakeCategory
          : intakeCategory as IntakeCategory?,
      weightLossCategory: identical(weightLossCategory, _sentinel)
          ? this.weightLossCategory
          : weightLossCategory as WeightLossCategory?,
      weightLossPeriod: identical(weightLossPeriod, _sentinel)
          ? this.weightLossPeriod
          : weightLossPeriod as WeightLossPeriod?,
      hasInflammation: identical(hasInflammation, _sentinel)
          ? this.hasInflammation
          : hasInflammation as bool?,
      nutritionalStatusScore: identical(nutritionalStatusScore, _sentinel)
          ? this.nutritionalStatusScore
          : nutritionalStatusScore as int?,
      diseaseSeverityScore: identical(diseaseSeverityScore, _sentinel)
          ? this.diseaseSeverityScore
          : diseaseSeverityScore as int?,
      icuDays: icuDays ?? this.icuDays,
      hasComorbidities: hasComorbidities ?? this.hasComorbidities,
      requiresVentilation: requiresVentilation ?? this.requiresVentilation,
      mustCategory: identical(mustCategory, _sentinel)
          ? this.mustCategory
          : mustCategory as String?,
      sgaCategory: identical(sgaCategory, _sentinel)
          ? this.sgaCategory
          : sgaCategory as String?,
      aspenCategory: identical(aspenCategory, _sentinel)
          ? this.aspenCategory
          : aspenCategory as String?,
      apacheScore: identical(apacheScore, _sentinel)
          ? this.apacheScore
          : apacheScore as double?,
      sofaScore: identical(sofaScore, _sentinel)
          ? this.sofaScore
          : sofaScore as double?,
      apacheDetails: apacheDetails ?? this.apacheDetails,
      sofaDetails: sofaDetails ?? this.sofaDetails,
      nutricScore: nutricScore ?? this.nutricScore,
      nrsScore: nrsScore ?? this.nrsScore,
      pendingItems: pendingItems ?? this.pendingItems,
      displayWeight: identical(displayWeight, _sentinel)
          ? this.displayWeight
          : displayWeight as double?,
      displayHeight: identical(displayHeight, _sentinel)
          ? this.displayHeight
          : displayHeight as double?,
      displayBmi: identical(displayBmi, _sentinel)
          ? this.displayBmi
          : displayBmi as double?,
      weightReferenceLabel: identical(weightReferenceLabel, _sentinel)
          ? this.weightReferenceLabel
          : weightReferenceLabel as String?,
    );
  }

  @override
  List<Object?> get props => [
        status,
        saveStatus,
        patient,
        latest,
        errorMessage,
        intakeCategory,
        weightLossCategory,
        weightLossPeriod,
        hasInflammation,
        nutritionalStatusScore,
        diseaseSeverityScore,
        icuDays,
        hasComorbidities,
        requiresVentilation,
        mustCategory,
        sgaCategory,
        aspenCategory,
        apacheScore,
        sofaScore,
        apacheDetails,
        sofaDetails,
        nutricScore,
        nrsScore,
        pendingItems,
        displayWeight,
        displayHeight,
        displayBmi,
        weightReferenceLabel,
      ];
}

const Object _sentinel = Object();
