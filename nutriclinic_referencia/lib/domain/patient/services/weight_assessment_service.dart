import 'dart:math';

import 'package:nutrivigil/domain/patient/patient_entity.dart';
import 'package:nutrivigil/domain/patient/weight_assessment.dart';

class WeightAssessmentInput {
  const WeightAssessmentInput({
    required this.patient,
    required this.weightKg,
    required this.hasRealWeight,
    required this.weightTrusted,
    required this.heightCm,
    required this.heightReliable,
    required this.weightSource,
    required this.measurementRecent,
    required this.flags,
    required this.measurementDate,
    this.kneeHeightCm,
    this.ulnaLengthCm,
    this.overrideFactor = 0.4,
  });

  final PatientProfile patient;
  final double? weightKg;
  final bool hasRealWeight;
  final bool weightTrusted;
  final double? heightCm;
  final bool heightReliable;
  final WeightSource weightSource;
  final bool measurementRecent;
  final WeightFlags flags;
  final DateTime measurementDate;
  final double? kneeHeightCm;
  final double? ulnaLengthCm;
  final double overrideFactor;
}

class WeightAssessmentComputation {
  WeightAssessmentComputation({
    required this.heightUsedCm,
    required this.heightMethod,
    required this.idealWeightKg,
    required this.adjustedWeightKg,
    required this.bmi,
    required this.confidence,
    required this.pendingActions,
    required this.trace,
    required this.recommendedMethod,
    required this.energyBaseKg,
    required this.proteinBaseKg,
    required this.recalculatedRealKg,
    required this.workWeightKg,
    required this.workWeightLabel,
  });

  final double? heightUsedCm;
  final String? heightMethod;
  final double? idealWeightKg;
  final double? adjustedWeightKg;
  final double? bmi;
  final WeightConfidence confidence;
  final List<String> pendingActions;
  final Map<String, dynamic> trace;
  final WorkWeightMethod recommendedMethod;
  final double? energyBaseKg;
  final double? proteinBaseKg;
  final double? recalculatedRealKg;
  final double? workWeightKg;
  final String? workWeightLabel;
}

class WeightAssessmentService {
  WeightAssessmentComputation evaluate(WeightAssessmentInput input) {
    final trace = <String, dynamic>{
      'fecha_medicion': input.measurementDate.toIso8601String(),
      'source': input.weightSource.name,
    };

    final pending = <String>[];
    var confidence = WeightConfidence.alta;
    trace['peso_real_disponible'] = input.hasRealWeight;
    trace['peso_confiable'] = input.weightTrusted;

    final bool hasWeightData =
        input.hasRealWeight && input.weightKg != null && input.weightKg! > 0;

    final heightData = _resolveHeight(
      input.patient,
      input.heightCm,
      input.heightReliable,
      input.kneeHeightCm,
      input.ulnaLengthCm,
    );

    final heightUsed = heightData.heightCm;
    final heightMethod = heightData.method;
    trace.addAll(heightData.trace);

    if (heightUsed == null) {
      pending.add('Capturar talla (rodilla/ulna)');
      confidence = _downgrade(confidence, WeightConfidence.media);
    }

    if (input.heightCm != null &&
        (input.heightCm! < 120 || input.heightCm! > 210)) {
      pending.add('Validar talla fuera de rango (120-210 cm)');
      confidence = _downgrade(confidence, WeightConfidence.media);
    }

    var adjustedRealWeight = hasWeightData ? input.weightKg : null;

    if (!input.hasRealWeight) {
      pending.add('Sin peso real disponible');
      confidence = _downgrade(confidence, WeightConfidence.media);
    }

    if (!input.weightTrusted && hasWeightData) {
      pending.add('Peso real no confirmado/en seco');
      confidence = _downgrade(confidence, WeightConfidence.media);
    }

    final weightAfterRetention =
        _applyFluidRetention(adjustedRealWeight, input.flags, trace, pending);

    if (weightAfterRetention != null &&
        (weightAfterRetention < 30 || weightAfterRetention > 250)) {
      pending.add('Validar peso fuera de rango (30-250 kg)');
      confidence = _downgrade(confidence, WeightConfidence.media);
    }

    final weightAfterAmputations =
        _applyAmputations(weightAfterRetention, input.flags, trace, pending);

    final bmi =
        (weightAfterAmputations != null && heightUsed != null && heightUsed > 0)
            ? weightAfterAmputations / pow(heightUsed / 100, 2)
            : null;

    final isObese = input.flags.obesidad ||
        (bmi != null && bmi >= 30) ||
        (input.weightKg != null &&
            heightUsed != null &&
            input.weightKg! / pow(heightUsed / 100, 2) >= 30);

    final idealWeight =
        heightUsed != null ? _devine(heightUsed, input.patient.sex) : null;

    final adjustedWeight = (idealWeight != null && weightAfterAmputations != null)
        ? _adjustedWeight(
            idealWeight: idealWeight,
            realWeight: weightAfterAmputations,
            factor: input.overrideFactor,
          )
        : null;

    if (hasWeightData &&
        (!input.measurementRecent || input.weightSource == WeightSource.estimado)) {
      confidence = _downgrade(confidence, WeightConfidence.baja);
      pending.add('Confirmar peso actualizado (<72h)');
    }

    if ((input.flags.edema || input.flags.ascitis) &&
        !input.flags.pesoSecoConfirmado) {
      confidence = _downgrade(confidence, WeightConfidence.media);
      if (!pending.contains('Confirmar peso en seco')) {
        pending.add('Confirmar peso en seco');
      }
    }

    final realReliable = hasWeightData &&
        input.weightTrusted &&
        confidence == WeightConfidence.alta &&
        !input.flags.edema &&
        !input.flags.ascitis;

    WorkWeightMethod recommendedMethod = WorkWeightMethod.real;
    double? energyBase = weightAfterAmputations;
    double? proteinBase = weightAfterAmputations;

    if (!realReliable) {
      if (input.flags.edema || input.flags.ascitis) {
        recommendedMethod = adjustedWeight != null
            ? WorkWeightMethod.ajustado
            : WorkWeightMethod.ideal;
        energyBase = adjustedWeight ?? idealWeight;
        proteinBase = idealWeight;
      }
    }

    if (isObese) {
      recommendedMethod = WorkWeightMethod.ajustado;
      energyBase = adjustedWeight ?? weightAfterAmputations;
      proteinBase = idealWeight ?? weightAfterAmputations;
    }

    if (!hasWeightData) {
      recommendedMethod = WorkWeightMethod.ideal;
      energyBase = adjustedWeight ?? idealWeight;
      proteinBase = idealWeight ?? adjustedWeight;
    }

    energyBase ??= weightAfterAmputations ?? idealWeight ?? adjustedWeight;
    proteinBase ??= idealWeight ?? energyBase;

    if (bmi != null && (bmi < 12 || bmi > 60)) {
      pending.add('IMC fuera de rango (12-60)');
      confidence = _downgrade(confidence, WeightConfidence.media);
    }

    trace.addAll({
      'bmi': bmi,
      'isObese': isObese,
      'idealWeightKg': idealWeight,
      'adjustedWeightKg': adjustedWeight,
      'factor': input.overrideFactor,
    });

    final workWeight = _workWeightForMethod(
      method: recommendedMethod,
      realWeight: weightAfterAmputations ?? weightAfterRetention ?? adjustedRealWeight,
      idealWeight: idealWeight,
      adjustedWeight: adjustedWeight,
      energyBase: energyBase,
    );

    return WeightAssessmentComputation(
      heightUsedCm: heightUsed,
      heightMethod: heightMethod,
      idealWeightKg: idealWeight,
      adjustedWeightKg: adjustedWeight,
      bmi: bmi,
      confidence: confidence,
      pendingActions: pending,
      trace: trace,
      recommendedMethod: recommendedMethod,
      energyBaseKg: energyBase,
      proteinBaseKg: proteinBase,
      recalculatedRealKg: weightAfterAmputations,
      workWeightKg: workWeight,
      workWeightLabel: _methodLabel(recommendedMethod),
    );
  }

  _HeightResolution _resolveHeight(
    PatientProfile patient,
    double? recordedHeight,
    bool heightReliable,
    double? kneeHeight,
    double? ulnaLength,
  ) {
    final trace = <String, dynamic>{};
    if (recordedHeight != null &&
        recordedHeight >= 120 &&
        recordedHeight <= 210 &&
        heightReliable) {
      trace['height_used'] = 'registro';
      return _HeightResolution(
        heightCm: recordedHeight,
        method: 'registro',
        trace: trace,
      );
    }

    double? kneeEstimate;
    if (kneeHeight != null) {
      final isMale = _isMale(patient.sex);
      kneeEstimate = isMale
          ? 64.19 + 2.02 * kneeHeight - 0.04 * patient.age
          : 84.88 + 1.83 * kneeHeight - 0.24 * patient.age;
      trace['altura_rodilla_cm'] = kneeEstimate;
    }

    double? ulnaEstimate;
    if (ulnaLength != null) {
      ulnaEstimate = _isMale(patient.sex)
          ? 79.2 + 3.60 * ulnaLength
          : 68.1 + 3.53 * ulnaLength;
      trace['altura_ulna_cm'] = ulnaEstimate;
    }

    double? finalHeight;
    String? method;
    if (kneeEstimate != null && ulnaEstimate != null) {
      finalHeight = (kneeEstimate * 0.6) + (ulnaEstimate * 0.4);
      method = 'rodilla_ulna';
    } else if (kneeEstimate != null) {
      finalHeight = kneeEstimate;
      method = 'rodilla';
    } else if (ulnaEstimate != null) {
      finalHeight = ulnaEstimate;
      method = 'ulna';
    }

    if (finalHeight != null) {
      trace['height_used'] = method;
    }

    return _HeightResolution(
      heightCm: finalHeight,
      method: method,
      trace: trace,
    );
  }

  double? _applyAmputations(
    double? realWeight,
    WeightFlags flags,
    Map<String, dynamic> trace,
    List<String> pending,
  ) {
    if (realWeight == null || flags.amputaciones.isEmpty) {
      return realWeight;
    }
    double percent = 0;
    for (final amputation in flags.amputaciones) {
      final key = amputation.toLowerCase();
      percent += _amputationMap[key] ?? 0;
    }
    if (percent == 0) {
      return realWeight;
    }
    trace['amputacion_pct'] = percent;
    final adjusted = realWeight * (1 - percent);
    if (percent > 0.15) {
      pending.add('Verificar peso de trabajo por amputación mayor');
    }
    return adjusted;
  }

  double? _applyFluidRetention(
    double? weight,
    WeightFlags flags,
    Map<String, dynamic> trace,
    List<String> pending,
  ) {
    if (weight == null) {
      return null;
    }
    if (!flags.ascitis || flags.pesoSecoConfirmado) {
      return weight;
    }
    double deduction = 0;
    switch (flags.ascitisSeveridad) {
      case 'moderada':
        deduction = 4.5;
        break;
      case 'severa':
        deduction = 7;
        break;
      default:
        deduction = 3;
    }
    trace['ascitis_deduccion'] = deduction;
    pending.add('Considerar paracentesis / peso seco');
    final adjusted = (weight - deduction).clamp(0, double.infinity);
    return adjusted.toDouble();
  }

  double _devine(double heightCm, String sex) {
    final base = _isMale(sex) ? 50.0 : 45.5;
    return base + 0.9 * (heightCm - 152.4);
  }

  double _adjustedWeight({
    required double idealWeight,
    required double realWeight,
    required double factor,
  }) {
    if (realWeight <= idealWeight) {
      return realWeight;
    }
    return idealWeight + factor * (realWeight - idealWeight);
  }

  bool _isMale(String sex) {
    final normalized = sex.toLowerCase();
    return normalized.contains('masc') || normalized.contains('hombre');
  }

  WeightConfidence _downgrade(
    WeightConfidence current,
    WeightConfidence target,
  ) {
    if (target.index > current.index) {
      return target;
    }
    return current;
  }

  double? _workWeightForMethod({
    required WorkWeightMethod method,
    double? realWeight,
    double? idealWeight,
    double? adjustedWeight,
    double? energyBase,
  }) {
    switch (method) {
      case WorkWeightMethod.real:
        return realWeight;
      case WorkWeightMethod.ideal:
        return idealWeight;
      case WorkWeightMethod.ajustado:
        return adjustedWeight;
      case WorkWeightMethod.realAjustado:
        return energyBase ?? realWeight;
      case WorkWeightMethod.otro:
        return null;
    }
  }

  String _methodLabel(WorkWeightMethod method) {
    switch (method) {
      case WorkWeightMethod.real:
        return 'Peso real';
      case WorkWeightMethod.ideal:
        return 'Peso ideal';
      case WorkWeightMethod.ajustado:
        return 'Peso ajustado';
      case WorkWeightMethod.realAjustado:
        return 'Peso real ajustado';
      case WorkWeightMethod.otro:
        return 'Otro';
    }
  }
}

class _HeightResolution {
  _HeightResolution({this.heightCm, this.method, required this.trace});

  final double? heightCm;
  final String? method;
  final Map<String, dynamic> trace;
}

const Map<String, double> _amputationMap = {
  'mano': 0.007,
  'antebrazo': 0.023,
  'brazo': 0.05,
  'pie': 0.019,
  'pierna': 0.059,
  'muslo': 0.116,
  'hemicuerpo': 0.5,
  'dedo': 0.002,
};
