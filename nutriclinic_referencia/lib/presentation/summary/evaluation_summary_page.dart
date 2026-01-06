import 'package:flutter/material.dart';

import 'package:nutrivigil/core/di/dependencies.dart';
import 'package:nutrivigil/core/routes/app_router.dart';
import 'package:nutrivigil/data/repositories/report_history_repository.dart';
import 'package:nutrivigil/domain/care_episode/care_episode_cubit.dart';
import 'package:nutrivigil/domain/care_episode/care_episode.dart';
import 'package:nutrivigil/domain/patient/patient_entity.dart';
import 'package:nutrivigil/domain/patient/services/weight_assessment_service.dart';
import 'package:nutrivigil/domain/nutrition/services/energy_adjustment_service.dart';
import 'package:nutrivigil/domain/reporting/report_history_entry.dart';
import 'package:nutrivigil/domain/reporting/report_service.dart';
import 'package:nutrivigil/presentation/report/report_preview_page.dart';
import 'package:uuid/uuid.dart';

class EvaluationSummaryPage extends StatelessWidget {
  const EvaluationSummaryPage({super.key});

  CareEpisode get _episode => sl<CareEpisodeCubit>().state;

  @override
  Widget build(BuildContext context) {
    final episode = _episode;
    final patient = episode.patient;
    final followUpExams = _buildFollowUpExams(episode);
    final patientNotes = patient?.notes?.trim() ?? '';
    return Scaffold(
      appBar: AppBar(title: const Text('Síntesis del episodio')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const _SectionHeading('Panorama general'),
            if (patient != null)
              _PatientSection(patient: patient)
            else
              const _PlaceholderCard(
                title: 'Sin información del paciente',
                message: 'Selecciona o registra un paciente para continuar.',
              ),
            if (patientNotes.isNotEmpty) ...[
              const SizedBox(height: 12),
              _NotesCard(notes: patientNotes),
            ],
            const SizedBox(height: 16),
            const _SectionHeading('1. Antropometría y peso de trabajo'),
            if (episode.weightAssessment != null)
              _WeightSection(computation: episode.weightAssessment!)
            else
              const _PlaceholderCard(
                title: 'Sin valoración antropométrica capturada.',
                message:
                    'Completa el módulo "Estimador de peso" para documentar el peso de trabajo.',
              ),
            const SizedBox(height: 16),
            const _SectionHeading('2. Clasificación del riesgo nutricional'),
            if (episode.riskSnapshot != null)
              _RiskSection(snapshot: episode.riskSnapshot!)
            else
              const _PlaceholderCard(
                title: 'Sin escalas de riesgo registradas.',
                message: 'Guarda el estado nutricional para habilitar esta sección.',
              ),
            const SizedBox(height: 16),
            const _SectionHeading('3. Plan energético y macronutrientes'),
            if (episode.energyPlan != null)
              _EnergySection(plan: episode.energyPlan!)
            else
              const _PlaceholderCard(
                title: 'Sin cálculos energéticos guardados.',
                message: 'Utiliza el calculador de requerimientos para completar esta sección.',
              ),
            const SizedBox(height: 16),
            const _SectionHeading('4. Ajustes diarios al soporte nutricio'),
            if (episode.adjustment != null)
              _AdjustmentSection(snapshot: episode.adjustment!)
            else
              const _PlaceholderCard(
                title: 'Sin ajuste práctico documentado.',
                message: 'Registra el ajuste diario para mostrar el aporte recomendado.',
              ),
            const SizedBox(height: 16),
            const _SectionHeading('5. Recomendaciones y reevaluación'),
            _FollowUpSection(
              exams: followUpExams,
              checklist: _dailyMonitoringExams,
            ),
            const SizedBox(height: 24),
            const _SignatureLine(),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: patient?.id == null
                  ? null
                  : () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ReportPreviewPage(
                            patientId: patient!.id,
                            patientName: patient.fullName,
                            episode: episode,
                          ),
                        ),
                      );
                    },
              icon: const Icon(Icons.picture_as_pdf),
              label: const Text('Exportar PDF'),
            ),
            const SizedBox(height: 12),
            FilledButton.tonalIcon(
              onPressed: patient?.id == null
                  ? null
                  : () => _finalizeEvaluation(context),
              icon: const Icon(Icons.done_all),
              label: const Text('Finalizar evaluación'),
            ),
          ],
        ),
      ),
    );
  }

  List<String> _buildFollowUpExams(CareEpisode episode) {
    final exams = <String>[];
    final triglycerides = episode.energyPlan?.triglycerides;
    if (triglycerides == null) {
      exams.add('Triglicéridos plasmáticos (sin dato reciente)');
    } else if (triglycerides >= 400) {
      exams.add(
          'Triglicéridos de control (último ${triglycerides.toStringAsFixed(0)} mg/dL)');
      exams.add('Perfil hepático (AST/ALT) por límite de lípidos');
    }

    final actions = episode.weightAssessment?.pendingActions ?? [];
    if (actions.any((action) =>
        action.toLowerCase().contains('peso en seco') ||
        action.toLowerCase().contains('validar talla'))) {
      exams.add('Revaluar antropometría (peso en seco / talla estimada)');
    }

    final adjustment = episode.adjustment;
    if (adjustment != null &&
        adjustment.result.level == AdjustmentLevel.trophic) {
      exams.add('Marcadores de perfusión (lactato, balances) por soporte trófico');
    }

    return exams;
  }

  Future<void> _finalizeEvaluation(BuildContext context) async {
    final episode = _episode;
    final patient = episode.patient;
    if (patient == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona un paciente antes de finalizar.')),
      );
      return;
    }

    final navigator = Navigator.of(context, rootNavigator: true);
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final pdfBytes = await sl<ReportService>().buildPatientSummary(
        patient.id,
        episode: episode,
      );
      final entry = ReportHistoryEntry(
        id: const Uuid().v4(),
        patientId: patient.id,
        patientName: patient.fullName,
        createdAt: DateTime.now(),
        pdfData: pdfBytes,
      );
      await sl<ReportHistoryRepository>().save(entry);
      navigator.pop();

      sl<CareEpisodeCubit>().reset();
      if (!context.mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRouter.home,
        (route) => false,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Informe de ${patient.fullName} guardado en historial.')),
      );
    } catch (error) {
      navigator.pop();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo guardar el historial: $error')),
        );
      }
    }
  }
}

class _PatientSection extends StatelessWidget {
  const _PatientSection({required this.patient});

  final PatientProfile patient;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[
      _KeyValueRow(label: 'Nombre completo', value: patient.fullName),
      _KeyValueRow(label: 'Edad / sexo', value: '${patient.age} años · ${patient.sex}'),
      _KeyValueRow(label: 'Diagnóstico principal', value: patient.diagnosis),
      _KeyValueRow(
        label: 'Peso / talla de ingreso',
        value:
            '${patient.weightKg.toStringAsFixed(1)} kg · ${patient.heightCm.toStringAsFixed(0)} cm',
      ),
    ];
    if ((patient.bedNumber ?? '').isNotEmpty) {
      rows.add(_KeyValueRow(label: 'Cama / servicio', value: patient.bedNumber!));
    }
    if ((patient.supportType ?? '').isNotEmpty) {
      rows.add(_KeyValueRow(label: 'Soporte actual', value: patient.supportType!));
    }
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: rows,
        ),
      ),
    );
  }
}

class _WeightSection extends StatelessWidget {
  const _WeightSection({required this.computation});

  final WeightAssessmentComputation computation;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Antropometría y peso de trabajo',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text('Peso de trabajo: '
                '${computation.workWeightKg?.toStringAsFixed(1) ?? 'N/D'} kg '
                '(${computation.workWeightLabel ?? 'sin etiqueta'})'),
            Text('Peso ideal: '
                '${computation.idealWeightKg?.toStringAsFixed(1) ?? 'N/D'} kg'),
            Text('Peso ajustado: '
                '${computation.adjustedWeightKg?.toStringAsFixed(1) ?? 'N/D'} kg'),
            if (computation.bmi != null)
              Text('IMC: ${computation.bmi!.toStringAsFixed(1)}'),
            if (computation.pendingActions.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text('Pendientes:', style: Theme.of(context).textTheme.labelMedium),
              for (final action in computation.pendingActions)
                Text('• $action', style: Theme.of(context).textTheme.bodySmall),
            ],
          ],
        ),
      ),
    );
  }
}

class _RiskSection extends StatelessWidget {
  const _RiskSection({required this.snapshot});

  final RiskSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final chips = <String>[];
    if (snapshot.aspenCategory != null) {
      chips.add('ASPEN/GLIM: ${snapshot.aspenCategory}');
    }
    if (snapshot.mustCategory != null) {
      chips.add('MUST: ${snapshot.mustCategory}');
    }
    if (snapshot.sgaCategory != null) {
      chips.add('SGA: ${snapshot.sgaCategory}');
    }
    if (snapshot.nutricScore != null) {
      chips.add('NUTRIC: ${snapshot.nutricScore!.toStringAsFixed(1)}');
    }
    if (snapshot.nrsScore != null) {
      chips.add('NRS-2002: ${snapshot.nrsScore!.toStringAsFixed(1)}');
    }
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Clasificación del riesgo',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            if (snapshot.primaryLabel != null)
              Text(snapshot.primaryLabel!,
                  style: Theme.of(context).textTheme.bodyMedium),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: chips
                  .map((chip) => Chip(label: Text(chip)))
                  .toList(growable: false),
            ),
          ],
        ),
      ),
    );
  }
}

class _EnergySection extends StatelessWidget {
  const _EnergySection({required this.plan});

  final EnergyPlanSnapshot plan;

  @override
  Widget build(BuildContext context) {
    final macros = plan.macroTargets;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Requerimiento objetivo',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              '${plan.requirements.caloriesPerDay.toStringAsFixed(0)} kcal · '
              '${plan.requirements.proteinGrams.toStringAsFixed(1)} g proteína',
            ),
            if (plan.factorStressLabel != null)
              Text('Factor de estrés: ${plan.factorStressLabel}'),
            if (plan.proteinPerKg != null &&
                plan.referenceWeightLabel != null)
              Text(
                'Proteína: ${plan.proteinPerKg!.toStringAsFixed(1)} g/kg '
                'sobre ${plan.referenceWeightLabel}',
              ),
            if (plan.lipidPercent != null)
              Text('Lípidos: ${plan.lipidPercent!.toStringAsFixed(0)} %'),
            if (plan.triglycerides != null)
              Text(
                  'Triglicéridos recientes: ${plan.triglycerides!.toStringAsFixed(0)} mg/dL'),
            if (macros != null) ...[
              const SizedBox(height: 8),
              Text(
                'Distribución estimada: '
                '${macros.proteinGrams.toStringAsFixed(1)} g proteína · '
                '${macros.carbohydrateGrams.toStringAsFixed(1)} g CHO · '
                '${macros.lipidGrams.toStringAsFixed(1)} g lípidos',
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _AdjustmentSection extends StatelessWidget {
  const _AdjustmentSection({required this.snapshot});

  final AdjustmentSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final applied = snapshot.appliedPercent ?? snapshot.result.recommendedPercent;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Plan aplicado al día',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              '${snapshot.result.adjustedCalories.toStringAsFixed(0)} kcal · '
              '${snapshot.result.adjustedProtein.toStringAsFixed(1)} g '
              '(${snapshot.result.recommendedPercent}% sugerido)',
            ),
            if (snapshot.result.trophicRateLabel != null)
              Text('Sugerencia: ${snapshot.result.trophicRateLabel}'),
            Text('Aplicado: ${applied.toStringAsFixed(0)} % del objetivo'),
            if (snapshot.notes != null)
              Text('Notas: ${snapshot.notes}'),
          ],
        ),
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
    );
  }
}

class _PlaceholderCard extends StatelessWidget {
  const _PlaceholderCard({required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotesCard extends StatelessWidget {
  const _NotesCard({required this.notes});

  final String notes;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Notas administrativas / antecedentes',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(notes, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

class _FollowUpSection extends StatelessWidget {
  const _FollowUpSection({required this.exams, required this.checklist});

  final List<String> exams;
  final List<String> checklist;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    if (exams.isEmpty && checklist.isEmpty) {
      children.add(
        Text(
          'Sin recomendaciones registradas.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    } else {
      if (exams.isNotEmpty) {
        children.add(
          Text(
            'Estudios / acciones sugeridas',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        );
        children.add(const SizedBox(height: 8));
        children.add(_BulletList(items: exams));
        if (checklist.isNotEmpty) {
          children.add(const SizedBox(height: 12));
        }
      }
      if (checklist.isNotEmpty) {
        children.add(
          Text(
            'Panel diario recomendado',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        );
        children.add(const SizedBox(height: 8));
        children.add(_BulletList(items: checklist));
      }
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }
}

class _BulletList extends StatelessWidget {
  const _BulletList({required this.items});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    final bodyStyle = Theme.of(context).textTheme.bodyMedium;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• '),
                  Expanded(child: Text(item, style: bodyStyle)),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

class _SignatureLine extends StatelessWidget {
  const _SignatureLine();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(height: 1, color: Colors.grey.shade400),
        const SizedBox(height: 4),
        Text(
          'Firma del médico responsable',
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: Colors.grey[600], fontStyle: FontStyle.italic),
        ),
      ],
    );
  }
}

class _KeyValueRow extends StatelessWidget {
  const _KeyValueRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: theme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value, style: theme.bodyMedium),
          ),
        ],
      ),
    );
  }
}

const List<String> _dailyMonitoringExams = [
  'Peso, balance hídrico y aporte calórico/proteico',
  'Glucosa mínima/máxima',
  'Triglicéridos plasmáticos',
  'Creatinina sérica',
  'AST / ALT',
  'Proteína C reactiva',
  'Procalcitonina',
];
