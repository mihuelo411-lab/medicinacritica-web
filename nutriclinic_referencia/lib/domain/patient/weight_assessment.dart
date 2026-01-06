import 'package:equatable/equatable.dart';

enum WeightConfidence { alta, media, baja }

enum WeightSource { bascula, camaBalanza, estimado, desconocido }

enum WorkWeightMethod { real, ideal, ajustado, realAjustado, otro }

class WeightFlags extends Equatable {
  const WeightFlags({
    this.obesidad = false,
    this.edema = false,
    this.ascitis = false,
    this.ascitisSeveridad,
    this.pesoSecoConfirmado = false,
    this.amputaciones = const [],
    this.embarazo = false,
    this.columnaAlterada = false,
  });

  final bool obesidad;
  final bool edema;
  final bool ascitis;
  final String? ascitisSeveridad;
  final bool pesoSecoConfirmado;
  final List<String> amputaciones;
  final bool embarazo;
  final bool columnaAlterada;

  WeightFlags copyWith({
    bool? obesidad,
    bool? edema,
    bool? ascitis,
    String? ascitisSeveridad,
    bool? pesoSecoConfirmado,
    List<String>? amputaciones,
    bool? embarazo,
    bool? columnaAlterada,
  }) {
    return WeightFlags(
      obesidad: obesidad ?? this.obesidad,
      edema: edema ?? this.edema,
      ascitis: ascitis ?? this.ascitis,
      ascitisSeveridad: ascitisSeveridad ?? this.ascitisSeveridad,
      pesoSecoConfirmado: pesoSecoConfirmado ?? this.pesoSecoConfirmado,
      amputaciones: amputaciones ?? this.amputaciones,
      embarazo: embarazo ?? this.embarazo,
      columnaAlterada: columnaAlterada ?? this.columnaAlterada,
    );
  }

  @override
  List<Object?> get props => [
        obesidad,
        edema,
        ascitis,
        ascitisSeveridad,
        pesoSecoConfirmado,
        amputaciones,
        embarazo,
        columnaAlterada,
      ];
}

class WeightAssessment extends Equatable {
  const WeightAssessment({
    required this.id,
    required this.patientId,
    required this.createdAt,
    this.weightRealKg,
    this.heightCm,
    this.heightMethod,
    this.weightSource,
    this.confidence,
    this.bmi,
    this.idealWeightKg,
    this.adjustedWeightKg,
    this.workWeightKg,
    this.workWeightMethod,
    this.proteinBaseKg,
    this.kcalBaseKg,
    this.overrideJustification,
    this.kneeHeightCm,
    this.ulnaLengthCm,
    this.estimatedHeightCm,
    this.pendingActions = const [],
    this.trace = const {},
    this.flags = const WeightFlags(),
  });

  final String id;
  final String patientId;
  final DateTime createdAt;
  final double? weightRealKg;
  final double? heightCm;
  final String? heightMethod;
  final WeightSource? weightSource;
  final WeightConfidence? confidence;
  final double? bmi;
  final double? idealWeightKg;
  final double? adjustedWeightKg;
  final double? workWeightKg;
  final WorkWeightMethod? workWeightMethod;
  final double? proteinBaseKg;
  final double? kcalBaseKg;
  final String? overrideJustification;
  final double? kneeHeightCm;
  final double? ulnaLengthCm;
  final double? estimatedHeightCm;
  final List<String> pendingActions;
  final Map<String, dynamic> trace;
  final WeightFlags flags;

  WeightAssessment copyWith({
    String? id,
    String? patientId,
    DateTime? createdAt,
    double? weightRealKg,
    double? heightCm,
    String? heightMethod,
    WeightSource? weightSource,
    WeightConfidence? confidence,
    double? bmi,
    double? idealWeightKg,
    double? adjustedWeightKg,
    double? workWeightKg,
    WorkWeightMethod? workWeightMethod,
    double? proteinBaseKg,
    double? kcalBaseKg,
    String? overrideJustification,
    double? kneeHeightCm,
    double? ulnaLengthCm,
    double? estimatedHeightCm,
    List<String>? pendingActions,
    Map<String, dynamic>? trace,
    WeightFlags? flags,
  }) {
    return WeightAssessment(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      createdAt: createdAt ?? this.createdAt,
      weightRealKg: weightRealKg ?? this.weightRealKg,
      heightCm: heightCm ?? this.heightCm,
      heightMethod: heightMethod ?? this.heightMethod,
      weightSource: weightSource ?? this.weightSource,
      confidence: confidence ?? this.confidence,
      bmi: bmi ?? this.bmi,
      idealWeightKg: idealWeightKg ?? this.idealWeightKg,
      adjustedWeightKg: adjustedWeightKg ?? this.adjustedWeightKg,
      workWeightKg: workWeightKg ?? this.workWeightKg,
      workWeightMethod: workWeightMethod ?? this.workWeightMethod,
      proteinBaseKg: proteinBaseKg ?? this.proteinBaseKg,
      kcalBaseKg: kcalBaseKg ?? this.kcalBaseKg,
      overrideJustification: overrideJustification ?? this.overrideJustification,
      kneeHeightCm: kneeHeightCm ?? this.kneeHeightCm,
      ulnaLengthCm: ulnaLengthCm ?? this.ulnaLengthCm,
      estimatedHeightCm: estimatedHeightCm ?? this.estimatedHeightCm,
      pendingActions: pendingActions ?? this.pendingActions,
      trace: trace ?? this.trace,
      flags: flags ?? this.flags,
    );
  }

  @override
  List<Object?> get props => [
        id,
        patientId,
        createdAt,
        weightRealKg,
        heightCm,
        heightMethod,
        weightSource,
        confidence,
        bmi,
        idealWeightKg,
        adjustedWeightKg,
        workWeightKg,
        workWeightMethod,
        proteinBaseKg,
        kcalBaseKg,
        overrideJustification,
        kneeHeightCm,
        ulnaLengthCm,
        estimatedHeightCm,
        pendingActions,
        trace,
        flags,
      ];
}
