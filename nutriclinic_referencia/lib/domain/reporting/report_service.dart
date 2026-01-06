import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:nutrivigil/data/repositories/energy_plan_repository.dart';
import 'package:nutrivigil/data/repositories/nutrition_repository.dart';
import 'package:nutrivigil/data/repositories/nutritional_assessment_repository.dart';
import 'package:nutrivigil/data/repositories/patient_repository.dart';
import 'package:nutrivigil/domain/care_episode/care_episode.dart';
import 'package:nutrivigil/domain/nutrition/nutrition_requirements.dart';
import 'package:nutrivigil/domain/nutrition/nutritional_assessment.dart';
import 'package:nutrivigil/domain/nutrition/services/energy_adjustment_service.dart';
import 'package:nutrivigil/domain/patient/patient_entity.dart';
import 'package:nutrivigil/domain/patient/services/weight_assessment_service.dart';
import 'package:nutrivigil/domain/nutrition/products/formula_selection.dart';
import 'package:nutrivigil/domain/patient/weight_assessment.dart';

class ReportService {
  ReportService(
    this._patientRepository,
    this._nutritionRepository,
    this._assessmentRepository,
    this._energyPlanRepository,
  );

  final PatientRepository _patientRepository;
  final NutritionRepository _nutritionRepository;
  final NutritionalAssessmentRepository _assessmentRepository;
  final EnergyPlanRepository _energyPlanRepository;

  final DateFormat _dayFormat = DateFormat('dd/MM/yyyy');

  Future<Uint8List> buildPatientSummary(
    String patientId, {
    CareEpisode? episode,
  }) async {
    final patient = await _patientRepository.fetchById(patientId);
    if (patient == null) {
      throw Exception('Paciente no encontrado');
    }

    final requirementsHistory = await _nutritionRepository.historyForPatient(patientId);
    final latestAssessment = await _assessmentRepository.latestForPatient(patientId);
    final storedPlan = await _energyPlanRepository.latestSnapshot(patientId);

    final generatedAt = DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now());
    final followUpExams = _buildFollowUpExams(episode);
    final weightAssessment = episode?.weightAssessment;
    final riskSnapshot = episode?.riskSnapshot;
    final energyPlan = episode?.energyPlan ?? storedPlan;
    final adjustment = episode?.adjustment;

    final doc = pw.Document();
    doc.addPage(
      pw.MultiPage(
        pageTheme: _pageTheme(),
        header: (_) => _reportHeader(patient, generatedAt),
        footer: (_) => _footer(generatedAt),
        build: (context) => [
          _sectionTitle('Panorama general'),
          _patientOverview(patient: patient, assessment: latestAssessment),
          if ((patient.notes ?? '').isNotEmpty) _patientNotes(patient.notes!),
          _sectionTitle('1. Antropometría y peso de trabajo'),
          _weightSection(weightAssessment),
          _sectionTitle('2. Clasificación del riesgo nutricional'),
          _riskSection(riskSnapshot, latestAssessment),
          _sectionTitle('3. Plan energético y macronutrientes'),
          _energyPlanSection(
            energyPlan: energyPlan,
            history: requirementsHistory,
          ),
          _sectionTitle('4. Prescripción nutricional'),
          if (episode?.prescription != null)
             _prescriptionSection(episode!.prescription!)
          else if (episode?.adjustment?.route == 'parenteral')
             _parenteralPlaceholder()
          else
             _placeholderCard('Sin prescripción final', 'No se ha seleccionado fórmula enteral.'),
          _sectionTitle('5. Ajustes diarios al soporte nutricio'),
          _adjustmentSection(adjustment),
          if (followUpExams.isNotEmpty || _dailyMonitoringChecklist.isNotEmpty) ...[
            _sectionTitle('5. Recomendaciones y reevaluación'),
            _followUpSection(followUpExams, _dailyMonitoringChecklist),
          ],
          _signatureLine(),
        ],
      ),
    );

    return doc.save();
  }

  pw.PageTheme _pageTheme() {
    return pw.PageTheme(
      margin: const pw.EdgeInsets.symmetric(horizontal: 32, vertical: 44),
      theme: pw.ThemeData.withFont(
        base: pw.Font.helvetica(),
        bold: pw.Font.helveticaBold(),
      ),
      buildBackground: (_) => pw.Container(
        decoration: pw.BoxDecoration(
          border: pw.Border.all(color: PdfColors.grey200, width: 1),
        ),
      ),
    );
  }

  pw.Widget _reportHeader(PatientProfile patient, String generatedAt) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'NutriVigil · Informe integral del episodio',
          style: pw.TextStyle(
            fontSize: 12,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.Text(
          '${patient.fullName} · ${patient.id}',
          style: const pw.TextStyle(fontSize: 10),
        ),
        pw.Text(
          'Generado: $generatedAt',
          style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
        ),
        pw.SizedBox(height: 8),
        pw.Divider(color: PdfColors.grey400, height: 1),
        pw.SizedBox(height: 8),
      ],
    );
  }

  pw.Widget _footer(String generatedAt) {
    return pw.Align(
      alignment: pw.Alignment.centerRight,
      child: pw.Text(
        'Emitido $generatedAt · NutriVigil',
        style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
      ),
    );
  }

  pw.Widget _sectionTitle(String title) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.only(top: 16, bottom: 8),
      decoration: const pw.BoxDecoration(
        border: pw.Border(bottom: pw.BorderSide(color: PdfColors.blueGrey200, width: 1)),
      ),
      child: pw.Text(
        title,
        style: pw.TextStyle(
          fontSize: 14, 
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.blueGrey800,
        ),
      ),
    );
  }

  pw.Widget _patientOverview({
    required PatientProfile patient,
    required NutritionalAssessment? assessment,
  }) {
    final rows = <pw.Widget>[
      _keyValueRow('Nombre completo', patient.fullName),
      _keyValueRow('Edad / sexo', '${patient.age} años · ${patient.sex}'),
      _keyValueRow('Diagnóstico principal', patient.diagnosis),
      _keyValueRow(
        'Peso / talla de ingreso',
        '${_formatValue(patient.weightKg, unit: 'kg')} · '
        '${_formatValue(patient.heightCm, unit: 'cm', decimals: 0)}',
      ),
    ];

    if ((patient.bedNumber ?? '').isNotEmpty) {
      rows.add(_keyValueRow('Cama / servicio', patient.bedNumber!));
    }
    if ((patient.supportType ?? '').isNotEmpty) {
      rows.add(_keyValueRow('Soporte actual', patient.supportType!));
    }
    if (assessment != null) {
      rows.add(
        _keyValueRow(
          'Última valoración registrada',
          _dayFormat.format(assessment.createdAt),
        ),
      );
    }

    return _sectionContainer(rows);
  }

  pw.Widget _patientNotes(String notes) {
    return _sectionContainer([
      pw.Text(
        'Notas administrativas / antecedentes',
        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
      ),
      pw.SizedBox(height: 4),
      pw.Text(notes),
    ]);
  }

  pw.Widget _weightSection(WeightAssessmentComputation? computation) {
    if (computation == null) {
      return _placeholderCard(
        'Sin valoración antropométrica capturada.',
        'Completa el módulo "Estimador de peso" para documentar el peso de trabajo.',
      );
    }

    final rows = <pw.Widget>[
      _keyValueRow(
        'Peso de trabajo sugerido',
        '${_formatValue(computation.workWeightKg, unit: 'kg')} '
        '(${computation.workWeightLabel ?? '--'})',
      ),
      _keyValueRow(
        'Método recomendado',
        _workMethodLabel(computation.recommendedMethod),
      ),
      _keyValueRow(
        'Talla utilizada',
        _heightLabel(computation),
      ),
      _keyValueRow('IMC estimado', _formatValue(computation.bmi, unit: 'kg/m²')),
      _keyValueRow(
        'Peso ideal / ajustado',
        '${_formatValue(computation.idealWeightKg, unit: 'kg')} · '
        '${_formatValue(computation.adjustedWeightKg, unit: 'kg')}',
      ),
      _keyValueRow(
        'Base calórica / proteica',
        '${_formatValue(computation.energyBaseKg, unit: 'kg')} · '
        '${_formatValue(computation.proteinBaseKg, unit: 'kg')}',
      ),
      _keyValueRow(
        'Confianza del cálculo',
        _confidenceLabel(computation.confidence),
      ),
    ];

    final pending = computation.pendingActions;
    if (pending.isNotEmpty) {
      rows.add(pw.SizedBox(height: 8));
      rows.add(_bulletList(
        'Pendientes para seguimiento',
        pending,
      ));
    }

    return _sectionContainer(rows);
  }

  pw.Widget _riskSection(
    RiskSnapshot? risk,
    NutritionalAssessment? assessment,
  ) {
    if (risk == null && assessment == null) {
      return _placeholderCard(
        'Sin escalas de riesgo registradas.',
        'Captura el estado nutricional para habilitar esta sección.',
      );
    }

    final rows = <pw.Widget>[];
    if ((risk?.primaryLabel ?? '').isNotEmpty) {
      rows.add(
        pw.Text(
          risk!.primaryLabel!,
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        ),
      );
      rows.add(pw.SizedBox(height: 6));
    }

    final scaleRows = <List<String>>[];
    if ((risk?.mustCategory ?? '').isNotEmpty) {
      scaleRows.add(['MUST', risk!.mustCategory!]);
    }
    if ((risk?.sgaCategory ?? '').isNotEmpty) {
      scaleRows.add(['SGA', risk!.sgaCategory!]);
    }
    if ((risk?.aspenCategory ?? '').isNotEmpty) {
      scaleRows.add(['ASPEN/GLIM', risk!.aspenCategory!]);
    }
    if (risk?.nutricScore != null) {
      scaleRows.add(['NUTRIC', risk!.nutricScore!.toStringAsFixed(1)]);
    }
    if (risk?.nrsScore != null) {
      scaleRows.add(['NRS-2002', risk!.nrsScore!.toStringAsFixed(1)]);
    }
    if (assessment?.apacheScore != null) {
      scaleRows.add(['APACHE II', assessment!.apacheScore!.toStringAsFixed(1)]);
    }
    if (assessment?.sofaScore != null) {
      scaleRows.add(['SOFA', assessment!.sofaScore!.toStringAsFixed(1)]);
    }

    if (scaleRows.isNotEmpty) {
      rows.add(
        pw.TableHelper.fromTextArray(
          headerStyle: pw.TextStyle(
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.white,
          ),
          headerDecoration: const pw.BoxDecoration(color: PdfColors.blueGrey800),
          headers: const ['Escala', 'Resultado'],
          data: scaleRows,
          cellStyle: const pw.TextStyle(fontSize: 10),
          cellAlignments: {
            0: pw.Alignment.centerLeft,
            1: pw.Alignment.centerLeft,
          },
        ),
      );
    }

    final pending = assessment?.pendingItems ?? const [];
    if (pending.isNotEmpty) {
      rows.add(pw.SizedBox(height: 8));
      rows.add(_bulletList('Acciones sugeridas', pending));
    }

    final notes = assessment?.notes;
    if ((notes ?? '').isNotEmpty) {
      rows.add(pw.SizedBox(height: 8));
      rows.add(_keyValueRow('Notas clínicas', notes!));
    }

    return _sectionContainer(rows);
  }

  pw.Widget _energyPlanSection({
    required EnergyPlanSnapshot? energyPlan,
    required List<NutritionRequirements> history,
  }) {
    if (energyPlan == null && history.isEmpty) {
      return _placeholderCard(
        'Sin cálculos energéticos guardados.',
        'Utiliza el calculador de requerimientos para mostrar esta sección.',
      );
    }

    final rows = <pw.Widget>[];
    if (energyPlan != null) {
      rows.addAll([
        _keyValueRow(
          'Objetivo calórico / proteico',
          '${energyPlan.requirements.caloriesPerDay.toStringAsFixed(0)} kcal · '
          '${energyPlan.requirements.proteinGrams.toStringAsFixed(1)} g proteína',
        ),
        if ((energyPlan.factorStressLabel ?? '').isNotEmpty)
          _keyValueRow('Factor de estrés aplicado', energyPlan.factorStressLabel!),
        if (energyPlan.proteinPerKg != null && (energyPlan.referenceWeightLabel ?? '').isNotEmpty)
          _keyValueRow(
            'Proteína de referencia',
            '${energyPlan.proteinPerKg!.toStringAsFixed(1)} g/kg · '
            '${energyPlan.referenceWeightLabel}',
          ),
        if (energyPlan.lipidPercent != null)
          _keyValueRow(
            'Lípidos sugeridos',
            '${energyPlan.lipidPercent!.toStringAsFixed(0)} % de las calorías',
          ),
        if (energyPlan.triglycerides != null)
          _keyValueRow(
            'Triglicéridos más recientes',
            '${energyPlan.triglycerides!.toStringAsFixed(0)} mg/dL',
          ),
        if (energyPlan.meanCalories != null)
          _keyValueRow(
            'Promedio de fórmulas seleccionadas',
            '${energyPlan.meanCalories!.toStringAsFixed(0)} kcal',
          ),
      ]);

      if (energyPlan.macroTargets != null) {
        rows.add(pw.SizedBox(height: 6));
        rows.add(_macroDistributionTable(energyPlan.macroTargets!));
      }

      if ((energyPlan.formulas ?? []).isNotEmpty) {
        rows.add(pw.SizedBox(height: 6));
        rows.add(_formulasTable(energyPlan.formulas!));
      }
    }

    if (history.isNotEmpty) {
      rows.add(pw.SizedBox(height: 8));
      rows.add(
        pw.Text(
          'Historial reciente de cálculos',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        ),
      );
      final rowsToShow = history.take(5).map((entry) {
        return [
          entry.method,
          '${entry.caloriesPerDay.toStringAsFixed(0)} kcal',
          '${entry.proteinGrams.toStringAsFixed(1)} g',
          entry.notes ?? '',
        ];
      }).toList();
      rows.add(
        pw.TableHelper.fromTextArray(
          headers: const ['Método', 'Calorías', 'Proteína', 'Notas'],
          data: rowsToShow,
          headerStyle: pw.TextStyle(
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.white,
          ),
          headerDecoration: const pw.BoxDecoration(color: PdfColors.green700),
          cellStyle: const pw.TextStyle(fontSize: 10),
          cellAlignments: {
            0: pw.Alignment.centerLeft,
            1: pw.Alignment.centerRight,
            2: pw.Alignment.centerRight,
            3: pw.Alignment.centerLeft,
          },
        ),
      );
    }

    return _sectionContainer(rows);
  }

  pw.Widget _adjustmentSection(AdjustmentSnapshot? adjustment) {
    if (adjustment == null) {
      return _placeholderCard(
        'Sin ajuste práctico documentado.',
        'Desde el módulo de adecuación diaria podrás obtener esta sección.',
      );
    }

    final rows = <pw.Widget>[
      _keyValueRow(
        'Nivel de aporte recomendado',
        _adjustmentLevelLabel(adjustment.result.level),
      ),
      _keyValueRow(
        'Objetivo sugerido',
        '${adjustment.result.adjustedCalories.toStringAsFixed(0)} kcal · '
        '${adjustment.result.adjustedProtein.toStringAsFixed(1)} g '
        '(${adjustment.result.recommendedPercent} %)',
      ),
      _keyValueRow(
        'Porcentaje aplicado',
        '${(adjustment.appliedPercent ?? adjustment.result.recommendedPercent).toStringAsFixed(0)} %',
      ),
    ];

    if ((adjustment.result.trophicRateLabel ?? '').isNotEmpty) {
      rows.add(
        _keyValueRow('Tasa propuesta', adjustment.result.trophicRateLabel!),
      );
    }

    if (adjustment.result.notes.isNotEmpty) {
      rows.add(pw.SizedBox(height: 8));
      rows.add(_bulletList('Motivos del ajuste', adjustment.result.notes));
    }

    if ((adjustment.notes ?? '').isNotEmpty) {
      rows.add(pw.SizedBox(height: 8));
      rows.add(_keyValueRow('Notas operativas', adjustment.notes!));
    }

    return _sectionContainer(rows);
  }

  pw.Widget _followUpSection(List<String> exams, List<String> checklist) {
    final children = <pw.Widget>[];

    if (exams.isNotEmpty) {
      children.add(_bulletList('Estudios / acciones sugeridas', exams));
      children.add(pw.SizedBox(height: 8));
    }

    if (checklist.isNotEmpty) {
      children.add(_bulletList('Panel diario recomendado', checklist));
    }

    return _sectionContainer(children);
  }

  pw.Widget _signatureLine() {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(top: 24),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(height: 1, color: PdfColors.grey400),
          pw.SizedBox(height: 4),
          pw.Text(
            'Firma del médico responsable',
            style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
          ),
        ],
      ),
    );
  }

  pw.Widget _sectionContainer(List<pw.Widget> children) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey400, width: 0.6),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  pw.Widget _placeholderCard(String title, String message) {
    return _sectionContainer([
      pw.Text(
        title,
        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
      ),
      pw.SizedBox(height: 4),
      pw.Text(
        message,
        style: const pw.TextStyle(color: PdfColors.grey700),
      ),
    ]);
  }

  pw.Widget _parenteralPlaceholder() {
    return _sectionContainer([
      pw.Text(
        'ALERTA CLÍNICA: PLAN PARENTERAL',
        style: pw.TextStyle(
          fontWeight: pw.FontWeight.bold, 
          color: PdfColors.red900,
        ),
      ),
      pw.SizedBox(height: 4),
      pw.Text(
        'Se ha seleccionado la vía PARENTERAL para este paciente debido a condiciones clínicas críticas (inestabilidad hemodinámica o fallo intestinal).',
        style: const pw.TextStyle(color: PdfColors.red900),
      ),
      pw.SizedBox(height: 4),
      pw.Text(
        'Por favor consulte el protocolo de Nutrición Parenteral Total (NPT) de la unidad para la prescripción detallada.',
        style: const pw.TextStyle(
          color: PdfColors.grey800, 
          fontStyle: pw.FontStyle.italic,
        ),
      ),
    ]);
  }

  pw.Widget _keyValueRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(
            width: 150,
            padding: const pw.EdgeInsets.only(right: 8),
            child: pw.Text(
              label,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.Expanded(child: pw.Text(value)),
        ],
      ),
    );
  }

  pw.Widget _bulletList(String title, List<String> items) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty)
          pw.Text(
            title,
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
        for (final item in items)
          pw.Padding(
            padding: const pw.EdgeInsets.only(top: 2),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('• ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Expanded(child: pw.Text(item)),
              ],
            ),
          ),
      ],
    );
  }

  String _heightLabel(WeightAssessmentComputation computation) {
    final parts = <String>[
      _formatValue(computation.heightUsedCm, unit: 'cm', decimals: 0),
    ];
    final method = computation.heightMethod;
    if ((method ?? '').isNotEmpty) {
      parts.add(method!);
    }
    return parts.join(' · ');
  }

  pw.Widget _macroDistributionTable(MacroTargetsSnapshot macros) {
    final rows = [
      ['Proteínas', _macroRow(macros.proteinGrams, macros.proteinPercent)],
      ['Carbohidratos', _macroRow(macros.carbohydrateGrams, macros.carbohydratePercent)],
      ['Lípidos', _macroRow(macros.lipidGrams, macros.lipidPercent)],
    ];

    return pw.TableHelper.fromTextArray(
      headers: const ['Macronutriente', 'Distribución'],
      data: rows,
      headerStyle: pw.TextStyle(
        fontWeight: pw.FontWeight.bold,
        color: PdfColors.white,
      ),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.indigo700),
      cellStyle: const pw.TextStyle(fontSize: 10),
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.centerLeft,
      },
    );
  }

  pw.Widget _formulasTable(List<FormulaBreakdown> formulas) {
    final rows = formulas
        .map(
          (formula) => [
            formula.name,
            '${formula.calories.toStringAsFixed(0)} kcal',
            '${formula.proteinGrams.toStringAsFixed(1)} g',
            formula.notes ?? '',
          ],
        )
        .toList();

    return pw.TableHelper.fromTextArray(
      headers: const ['Fórmula', 'Calorías', 'Proteína', 'Notas'],
      data: rows,
      headerStyle: pw.TextStyle(
        fontWeight: pw.FontWeight.bold,
        color: PdfColors.white,
      ),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.deepOrange400),
      cellStyle: const pw.TextStyle(fontSize: 10),
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.centerRight,
        2: pw.Alignment.centerRight,
        3: pw.Alignment.centerLeft,
      },
    );
  }

  pw.Widget _prescriptionSection(FormulaSelection prescription) {
    
    // Header Row: Product and Goal
    final productRow = [
      _keyValueRow('Fórmula Seleccionada', prescription.product.nameDisplay),
      _keyValueRow('Densidad', '${prescription.product.densityLabel} · ${prescription.product.proteinGramsPerLiter} g Prot/L'),
      _keyValueRow('Categoría', prescription.product.description),
    ];
    
    // Prescription Details
    final detailsRow = [
      _keyValueRow('Volumen Objetivo (100%)', '${prescription.totalVolumeMl.toStringAsFixed(0)} ml/día'),
      _keyValueRow('Presentación (237ml)', '${prescription.bottlesPerDay.toStringAsFixed(1)} botellas/latas'),
      _keyValueRow('Modo de Infusión', prescription.infusionLabel),
    ];
    
    // Protein Module
    final moduleRows = <pw.Widget>[];
    if (prescription.proteinModule != null) {
      moduleRows.add(pw.SizedBox(height: 8));
      moduleRows.add(pw.Text('Suplementación Proteica:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)));
      moduleRows.add(_keyValueRow('Módulo', prescription.proteinModule!.name));
      moduleRows.add(_keyValueRow('Dosis', '${prescription.moduleDoses.toStringAsFixed(0)} ${prescription.proteinModule!.doseLabel}s'));
      moduleRows.add(_keyValueRow('Aporte Extra', '+ ${(prescription.moduleDoses * prescription.proteinModule!.proteinPerDose).toStringAsFixed(1)} g proteína'));
    }

    // Start Plan (Adjusted)
    final startVolume = prescription.totalVolumeMl * (prescription.targetPercent / 100);
    // Re-calculate start rate for display
    String startRate = '--';
    if (prescription.infusionMode == InfusionMode.continuous) {
       startRate = '${(startVolume / 24).toStringAsFixed(0)} ml/h';
    } else if (prescription.infusionMode == InfusionMode.cyclic) {
       startRate = '${(startVolume / prescription.hoursPerDay).toStringAsFixed(0)} ml/h';
    }
    
    final startPlan = pw.Container(
      margin: const pw.EdgeInsets.only(top: 8),
      padding: const pw.EdgeInsets.all(8),
      decoration: pw.BoxDecoration(
        color: PdfColors.green50,
        border: pw.Border.all(color: PdfColors.green200),
        borderRadius: pw.BorderRadius.circular(4),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('Orden de Inicio (Día 1) - ${prescription.targetPercent.toInt()}% del objetivo', 
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.green900)),
          pw.Divider(color: PdfColors.green200),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
               pw.Text('Volumen: ${startVolume.toStringAsFixed(0)} ml'),
               pw.Text('Velocidad: $startRate'),
               pw.Text('Botellas: ${(prescription.bottlesPerDay * (prescription.targetPercent/100)).toStringAsFixed(1)}'),
            ]
          )
        ],
      ),
    );

    return _sectionContainer([
      ...productRow,
      pw.SizedBox(height: 8),
      pw.Divider(color: PdfColors.grey300),
      pw.SizedBox(height: 8),
      ...detailsRow,
      ...moduleRows,
      startPlan,
    ]);
  }

  String _macroRow(double grams, double? percent) {
    final gramsLabel = '${grams.toStringAsFixed(1)} g';
    if (percent == null) {
      return gramsLabel;
    }
    return '$gramsLabel (${percent.toStringAsFixed(0)} %)';
  }

  String _formatValue(
    double? value, {
    String? unit,
    int decimals = 1,
  }) {
    if (value == null) {
      return '--';
    }
    final formatted = value.toStringAsFixed(decimals);
    return unit == null ? formatted : '$formatted $unit';
  }

  String _range(double? min, double? max) {
    if (min == null && max == null) {
      return '--';
    }
    if (min == null) {
      return '< ${max!.toStringAsFixed(1)}';
    }
    if (max == null) {
      return '> ${min.toStringAsFixed(1)}';
    }
    return '${min.toStringAsFixed(1)} - ${max.toStringAsFixed(1)}';
  }

  String _confidenceLabel(WeightConfidence confidence) {
    return switch (confidence) {
      WeightConfidence.alta => 'Alta',
      WeightConfidence.media => 'Media',
      WeightConfidence.baja => 'Baja',
    };
  }

  String _workMethodLabel(WorkWeightMethod method) {
    return switch (method) {
      WorkWeightMethod.real => 'Peso real',
      WorkWeightMethod.ideal => 'Peso ideal',
      WorkWeightMethod.ajustado => 'Peso ajustado',
      WorkWeightMethod.realAjustado => 'Peso real/ajustado',
      WorkWeightMethod.otro => 'Otro criterio',
    };
  }

  String _adjustmentLevelLabel(AdjustmentLevel level) {
    return switch (level) {
      AdjustmentLevel.trophic => 'Soporte trófico (10-20 %)',
      AdjustmentLevel.hypocaloric => 'Aporte progresivo (50 %)',
      AdjustmentLevel.full => 'Aporte completo (100 %)',
    };
  }

  List<String> _buildFollowUpExams(CareEpisode? episode) {
    if (episode == null) {
      return const [];
    }
    final exams = <String>{}; // Use Set to avoid duplicates
    
    // 1. Missing Data for Risk Scores (SOFA / NUTRIC)
    final risk = episode.riskSnapshot;
    // Heuristic: If NUTRIC is low/missing but patient is critical -> Check SOFA components
    // If SOFA is not recorded or is 0, we might need data.
    final hasSofa = risk?.nutricScore != null; // NUTRIC usually implies SOFA was done
    if (!hasSofa) {
      exams.add('Gasometría arterial (PaO2/FiO2) para completar SOFA/NUTRIC.');
      exams.add('Recuento plaquetario (Hemograma) para completar SOFA.');
      exams.add('Bilirrubinas y Creatinina sérica para completar SOFA.');
    }

    // 2. Triglycerides / Metabolic
    final triglycerides = episode.energyPlan?.triglycerides;
    if (triglycerides == null) {
      exams.add('Triglicéridos plasmáticos (dato base faltante).');
    } else if (triglycerides >= 400) {
      exams.add(
        'Triglicéridos de control (previo: ${triglycerides.toStringAsFixed(0)} mg/dL).',
      );
      exams.add('Perfil hepático completo (AST/ALT/Bilirrubinas).');
    }

    // 3. Refeeding Risk / Electrolytes
    // If patient is malnourished (High Risk) or starting feeding -> Electrolytes
    final isHighRisk = (risk?.nutricScore ?? 0) >= 5 || (risk?.nrsScore ?? 0) >= 3;
    if (isHighRisk) {
      exams.add('Electrolitos séricos (Fósforo, Magnesio, Potasio) - Riesgo Realimentación.');
      exams.add('Glucometría estricta c/6h.');
    }

    // 4. Inflammation / Visceral
    // If no recent CRP -> Suggest it
    // We don't have direct access to recent CRP in CareEpisode yet, 
    // but we can suggest it generally for critical patients.
    exams.add('PCR, Ferritina, Linfocitos (Perfil Inflamatorio/Inmunológico).');

    // 5. Renal / Nitrogen Balance
    if (episode.prescription != null && episode.prescription!.proteinGramsPerDay > 100) {
       exams.add('BUN u/o Urea urinaria (24h) para Balance Nitrogenado.');
    }

    final actions = episode.weightAssessment?.pendingActions ?? [];
    if (actions.any((a) => a.toLowerCase().contains('peso') || a.toLowerCase().contains('talla'))) {
      exams.add('Revaluar antropometría / peso en seco.');
    }

    return exams.toList();
  }

  static const List<String> _dailyMonitoringChecklist = [
    'Peso, balance hídrico y aporte calórico/proteico',
    'Glucosa mínima y máxima',
    'Triglicéridos plasmáticos',
    'Creatinina sérica',
    'AST / ALT',
    'Proteína C reactiva',
    'Procalcitonina',
  ];
}
