import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:nutrivigil/core/di/dependencies.dart';
import 'package:nutrivigil/core/routes/app_router.dart';
import 'package:nutrivigil/data/repositories/nutritional_assessment_repository.dart';
import 'package:nutrivigil/data/repositories/patient_repository.dart';
import 'package:nutrivigil/data/repositories/weight_assessment_repository.dart';
import 'package:nutrivigil/domain/nutrition/services/nutritional_scoring_service.dart';
import 'package:nutrivigil/domain/patient/patient_entity.dart';
import 'package:nutrivigil/presentation/nutrition/status/apache_calculator_page.dart';
import 'package:nutrivigil/presentation/nutrition/status/bloc/nutritional_status_bloc.dart';
import 'package:nutrivigil/presentation/nutrition/status/score_capture_result.dart';
import 'package:nutrivigil/presentation/nutrition/status/sofa_calculator_page.dart';
import 'package:nutrivigil/domain/care_episode/care_episode.dart';
import 'package:nutrivigil/domain/care_episode/care_episode_cubit.dart';

class NutritionalStatusPage extends StatelessWidget {
  const NutritionalStatusPage({super.key, required this.patientId});

  final String patientId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NutritionalStatusBloc(
        sl<PatientRepository>(),
        sl<NutritionalAssessmentRepository>(),
        sl<WeightAssessmentRepository>(),
        sl<NutritionalScoringService>(),
      )..add(NutritionalStatusStarted(patientId)),
      child: const _NutritionalStatusView(),
    );
  }
}

class _NutritionalStatusView extends StatelessWidget {
  const _NutritionalStatusView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Estado nutricional')),
      body: BlocConsumer<NutritionalStatusBloc, NutritionalStatusState>(
        listener: (context, state) {
          if (state.saveStatus == NutritionalStatusSaveStatus.success &&
              state.patient != null) {
            final patient = state.patient!;
            sl<CareEpisodeCubit>().setRiskSnapshot(
              RiskSnapshot(
                mustCategory: state.mustCategory,
                sgaCategory: state.sgaCategory,
                aspenCategory: state.aspenCategory,
                nutricScore: state.nutricScore,
                nrsScore: state.nrsScore,
                primaryLabel: state.primaryStatusLabel,
              ),
            );
            Navigator.of(context).pushNamed(
              AppRouter.energyCalculator,
              arguments: EnergyCalculatorPageArgs(
                patientId: patient.id,
                patientName: patient.fullName,
                workWeightKg: state.displayWeight ?? patient.weightKg,
                heightCm: state.displayHeight ?? patient.heightCm,
                age: patient.age,
                isMale: _isMaleSex(patient.sex),
                riskLabel: state.energyRiskLabel,
                requiresVentilation: state.requiresVentilation,
              ),
            );
          } else if (state.saveStatus == NutritionalStatusSaveStatus.failure &&
              state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage!)),
            );
          }
        },
        builder: (context, state) {
          if (!state.isReady) {
            if (state.status == NutritionalStatusViewStatus.error) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    state.errorMessage ?? 'No se pudo cargar la información.',
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }
            return const Center(child: CircularProgressIndicator());
          }

          final patient = state.patient!;
          final bloc = context.read<NutritionalStatusBloc>();

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _PatientCard(
                    patient: patient,
                    displayWeight: state.displayWeight,
                    displayHeight: state.displayHeight,
                    displayBmi: state.displayBmi,
                    weightReferenceLabel: state.weightReferenceLabel,
                  ),
                  const SizedBox(height: 16),
                  _ClinicalInputsCard(state: state, bloc: bloc),
                  const SizedBox(height: 16),
                  _ConditionCard(state: state, bloc: bloc),
                  const SizedBox(height: 16),
                  _MetabolicRiskCard(state: state, bloc: bloc),
                  const SizedBox(height: 16),
                  _ClinicalClassificationCard(state: state, bloc: bloc),
                  const SizedBox(height: 16),
                  _CalculatorsSection(state: state),
                  const SizedBox(height: 16),
                  _SummaryCard(state: state),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: state.saveStatus ==
                            NutritionalStatusSaveStatus.saving
                        ? null
                        : () => bloc.add(const NutritionalStatusSubmitted()),
                    icon: state.saveStatus == NutritionalStatusSaveStatus.saving
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.save_outlined),
                    label: const Text('Guardar estado nutricional'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PatientCard extends StatelessWidget {
  const _PatientCard({
    required this.patient,
    this.displayWeight,
    this.displayHeight,
    this.displayBmi,
    this.weightReferenceLabel,
  });

  final PatientProfile patient;
  final double? displayWeight;
  final double? displayHeight;
  final double? displayBmi;
  final String? weightReferenceLabel;

  @override
  Widget build(BuildContext context) {
    final weight = displayWeight ?? patient.weightKg;
    final rawHeight = displayHeight ?? patient.heightCm;
    final safeHeight =
        rawHeight != null && rawHeight > 0 ? rawHeight : patient.heightCm;
    final bmi = displayBmi ??
        (safeHeight != null && safeHeight > 0
            ? weight / ((safeHeight / 100) * (safeHeight / 100))
            : null);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              child: Text(
                patient.fullName.isNotEmpty
                    ? patient.fullName.substring(0, 1).toUpperCase()
                    : '?',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    patient.fullName,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text('${patient.sex} · ${patient.age} años'),
                  Text('Diagnóstico: ${patient.diagnosis}'),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (weightReferenceLabel != null)
                  Text(
                    weightReferenceLabel!,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                Text('${weight.toStringAsFixed(1)} kg'),
                Text(
                  safeHeight != null
                      ? '${safeHeight.toStringAsFixed(0)} cm'
                      : 'Talla sin dato',
                ),
                Text(
                  bmi != null
                      ? 'IMC ${bmi.toStringAsFixed(1)}'
                      : 'IMC sin dato',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ClinicalInputsCard extends StatelessWidget {
  const _ClinicalInputsCard({required this.state, required this.bloc});

  final NutritionalStatusState state;
  final NutritionalStatusBloc bloc;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Historia reciente',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<IntakeCategory?>(
              isExpanded: true,
              value: state.intakeCategory,
              decoration: const InputDecoration(
                labelText: 'Ingesta alcanzada',
                border: OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem(
                  value: null,
                  child: Text('Sin dato'),
                ),
                DropdownMenuItem(
                  value: IntakeCategory.gte50,
                  child: Text('≥ 50% de lo indicado'),
                ),
                DropdownMenuItem(
                  value: IntakeCategory.lt50,
                  child: Text('< 50% de lo indicado'),
                ),
              ],
              onChanged: (value) => bloc.add(
                NutritionalStatusFieldChanged(
                  field: NutritionalStatusField.intakeCategory,
                  value: value,
                ),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<WeightLossCategory?>(
              isExpanded: true,
              value: state.weightLossCategory,
              decoration: const InputDecoration(
                labelText: 'Pérdida de peso (%)',
                border: OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem(
                  value: null,
                  child: Text('Sin dato'),
                ),
                DropdownMenuItem(
                  value: WeightLossCategory.none,
                  child: Text('Sin pérdida'),
                ),
                DropdownMenuItem(
                  value: WeightLossCategory.lt5,
                  child: Text('< 5 %'),
                ),
                DropdownMenuItem(
                  value: WeightLossCategory.from5to10,
                  child: Text('5 - 10 %'),
                ),
                DropdownMenuItem(
                  value: WeightLossCategory.gt10,
                  child: Text('> 10 %'),
                ),
              ],
              onChanged: (value) => bloc.add(
                NutritionalStatusFieldChanged(
                  field: NutritionalStatusField.weightLossCategory,
                  value: value,
                ),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<WeightLossPeriod?>(
              isExpanded: true,
              value: state.weightLossPeriod,
              decoration: const InputDecoration(
                labelText: 'Periodo de pérdida',
                border: OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem(
                  value: null,
                  child: Text('Sin dato'),
                ),
                DropdownMenuItem(
                  value: WeightLossPeriod.less1Month,
                  child: Text('< 1 mes'),
                ),
                DropdownMenuItem(
                  value: WeightLossPeriod.oneToThree,
                  child: Text('1 - 3 meses'),
                ),
                DropdownMenuItem(
                  value: WeightLossPeriod.threeToSix,
                  child: Text('3 - 6 meses'),
                ),
                DropdownMenuItem(
                  value: WeightLossPeriod.moreSix,
                  child: Text('> 6 meses'),
                ),
              ],
              onChanged: (value) => bloc.add(
                NutritionalStatusFieldChanged(
                  field: NutritionalStatusField.weightLossPeriod,
                  value: value,
                ),
              ),
            ),
            const SizedBox(height: 12),
            CheckboxListTile(
              value: state.hasInflammation,
              tristate: true,
              title: const Text('Inflamación/estrés metabólico activo'),
              onChanged: (value) => bloc.add(
                NutritionalStatusFieldChanged(
                  field: NutritionalStatusField.hasInflammation,
                  value: value,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConditionCard extends StatelessWidget {
  const _ConditionCard({required this.state, required this.bloc});

  final NutritionalStatusState state;
  final NutritionalStatusBloc bloc;

  @override
  Widget build(BuildContext context) {
    const labels = [
      '0: Normal',
      '1: Ligera pérdida',
      '2: Moderada',
      '3: Severa',
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Condición actual del paciente',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<int>(
              isExpanded: true,
              value: state.nutritionalStatusScore,
              decoration: const InputDecoration(
                labelText: 'Estado nutricional observado',
                helperText:
                    'Selecciona el que mejor describa la condición global',
                border: OutlineInputBorder(),
              ),
              items: List.generate(
                labels.length,
                (index) => DropdownMenuItem(
                  value: index,
                  child: Text(labels[index]),
                ),
              ),
              onChanged: (value) => bloc.add(
                NutritionalStatusFieldChanged(
                  field: NutritionalStatusField.nutritionalStatusScore,
                  value: value,
                ),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<int>(
              isExpanded: true,
              value: state.diseaseSeverityScore,
              decoration: const InputDecoration(
                labelText: 'Impacto de la enfermedad actual',
                helperText:
                    'Considera sepsis, ventilación, falla orgánica, etc.',
                border: OutlineInputBorder(),
              ),
              items: List.generate(
                labels.length,
                (index) => DropdownMenuItem(
                  value: index,
                  child: Text(labels[index]),
                ),
              ),
              onChanged: (value) => bloc.add(
                NutritionalStatusFieldChanged(
                  field: NutritionalStatusField.diseaseSeverityScore,
                  value: value,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetabolicRiskCard extends StatelessWidget {
  const _MetabolicRiskCard({required this.state, required this.bloc});

  final NutritionalStatusState state;
  final NutritionalStatusBloc bloc;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Carga metabólica y soporte',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            TextFormField(
              initialValue: state.icuDays.toString(),
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Días desde el ingreso a UCI',
                helperText: '0 si ingresa hoy',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => bloc.add(
                NutritionalStatusFieldChanged(
                  field: NutritionalStatusField.icuDays,
                  value: int.tryParse(value) ?? 0,
                ),
              ),
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              title: const Text('Comorbilidades relevantes'),
              value: state.hasComorbidities,
              onChanged: (value) => bloc.add(
                NutritionalStatusFieldChanged(
                  field: NutritionalStatusField.hasComorbidities,
                  value: value,
                ),
              ),
            ),
            SwitchListTile(
              title: const Text('Ventilación mecánica (actual)'),
              value: state.requiresVentilation,
              onChanged: (value) => bloc.add(
                NutritionalStatusFieldChanged(
                  field: NutritionalStatusField.requiresVentilation,
                  value: value,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ClinicalClassificationCard extends StatelessWidget {
  const _ClinicalClassificationCard({required this.state, required this.bloc});

  final NutritionalStatusState state;
  final NutritionalStatusBloc bloc;

  @override
  Widget build(BuildContext context) {
    const globalOptions = [
      _ClassificationOption(
        value: 'Bajo',
        label: 'Bajo • IMC ≥ 20 y sin pérdida reciente',
      ),
      _ClassificationOption(
        value: 'Moderado',
        label: 'Moderado • IMC 18.5-19.9 o pérdida 5-10%',
      ),
      _ClassificationOption(
        value: 'Alto',
        label: 'Alto • IMC < 18.5 o pérdida >10%/ingesta mínima',
      ),
    ];
    const sgaOptions = [
      _ClassificationOption(value: 'A', label: 'A • Bien nutrido'),
      _ClassificationOption(value: 'B', label: 'B • Sospecha/moderada'),
      _ClassificationOption(value: 'C', label: 'C • Desnutrición severa'),
    ];
    const aspenOptions = [
      _ClassificationOption(
        value: 'Sin criterios',
        label: 'Sin criterios fenotípicos',
      ),
      _ClassificationOption(
        value: 'Leve',
        label: 'Fenotipo inflamatorio leve (pérdida lenta, IMC limítrofe)',
      ),
      _ClassificationOption(
        value: 'Moderada',
        label:
            'Fenotipo inflamatorio moderado (pérdida 5-10%, fuerza reducida)',
      ),
      _ClassificationOption(
        value: 'Severa',
        label: 'Fenotipo inflamatorio severo (>10%, edema, falla orgánica)',
      ),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Clasificación clínica',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              isExpanded: true,
              value: state.mustCategory,
              decoration: const InputDecoration(
                labelText: 'Riesgo global',
                border: OutlineInputBorder(),
              ),
              items: globalOptions
                  .map(
                    (option) => DropdownMenuItem(
                      value: option.value,
                      child: Text(option.label),
                    ),
                  )
                  .toList(),
              onChanged: (value) => bloc.add(
                NutritionalStatusFieldChanged(
                  field: NutritionalStatusField.mustCategory,
                  value: value,
                ),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              isExpanded: true,
              value: state.sgaCategory,
              decoration: const InputDecoration(
                labelText: 'Valoración subjetiva',
                border: OutlineInputBorder(),
              ),
              items: sgaOptions
                  .map(
                    (option) => DropdownMenuItem(
                      value: option.value,
                      child: Text(option.label),
                    ),
                  )
                  .toList(),
              onChanged: (value) => bloc.add(
                NutritionalStatusFieldChanged(
                  field: NutritionalStatusField.sgaCategory,
                  value: value,
                ),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              isExpanded: true,
              value: state.aspenCategory,
              decoration: const InputDecoration(
                labelText: 'Fenotipo ASPEN/GLIM',
                border: OutlineInputBorder(),
              ),
              items: aspenOptions
                  .map(
                    (option) => DropdownMenuItem(
                      value: option.value,
                      child: Text(option.label),
                    ),
                  )
                  .toList(),
              onChanged: (value) => bloc.add(
                NutritionalStatusFieldChanged(
                  field: NutritionalStatusField.aspenCategory,
                  value: value,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ClassificationOption {
  const _ClassificationOption({required this.value, required this.label});

  final String value;
  final String label;
}

class _CalculatorsSection extends StatelessWidget {
  const _CalculatorsSection({required this.state});

  final NutritionalStatusState state;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<NutritionalStatusBloc>();
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.monitor_heart),
            title: const Text('Calcular APACHE II'),
            subtitle: Text(
              state.apacheScore == null
                  ? 'Pendiente'
                  : 'Actual: ${state.apacheScore!.toStringAsFixed(1)} pts',
            ),
            onTap: () async {
              final result =
                  await Navigator.of(context).push<ScoreCaptureResult>(
                MaterialPageRoute(
                  builder: (_) => ApacheCalculatorPage(
                    initialScore: state.apacheScore,
                    initialDetails: state.apacheDetails,
                  ),
                ),
              );
              if (result != null) {
                bloc.add(
                  NutritionalStatusApacheRecorded(
                    value: result.value,
                    details: result.details,
                  ),
                );
              }
            },
          ),
          const Divider(height: 0),
          ListTile(
            leading: const Icon(Icons.analytics_outlined),
            title: const Text('Calcular SOFA'),
            subtitle: Text(
              state.sofaScore == null
                  ? 'Pendiente'
                  : 'Actual: ${state.sofaScore!.toStringAsFixed(1)} pts',
            ),
            onTap: () async {
              final result =
                  await Navigator.of(context).push<ScoreCaptureResult>(
                MaterialPageRoute(
                  builder: (_) => SofaCalculatorPage(
                    initialScore: state.sofaScore,
                    initialDetails: state.sofaDetails,
                  ),
                ),
              );
              if (result != null) {
                bloc.add(
                  NutritionalStatusSofaRecorded(
                    value: result.value,
                    details: result.details,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.state});

  final NutritionalStatusState state;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Diagnóstico actual',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              state.primaryStatusLabel,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              'Escala primaria: ${state.primaryScale}',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.grey[700]),
            ),
            const SizedBox(height: 12),
            _NarrativeList(state: state),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                _ScoreChip(
                  label: 'NUTRIC',
                  value: state.nutricScore,
                ),
                _ScoreChip(
                  label: 'NRS',
                  value: state.nrsScore,
                ),
                _ScoreChip(
                  label: 'APACHE',
                  value: state.apacheScore,
                ),
                _ScoreChip(
                  label: 'SOFA',
                  value: state.sofaScore,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ScoreChip extends StatelessWidget {
  const _ScoreChip({required this.label, required this.value});

  final String label;
  final double? value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Chip(
      label: Text(
        value == null ? '$label: -' : '$label: ${value!.toStringAsFixed(1)}',
        style: theme.textTheme.bodyMedium,
      ),
    );
  }
}

class _NarrativeList extends StatelessWidget {
  const _NarrativeList({required this.state});

  final NutritionalStatusState state;

  @override
  Widget build(BuildContext context) {
    final narratives = [
      state.nutricNarrative,
      state.nrsNarrative,
      state.mustNarrative,
      state.sgaNarrative,
      state.aspenNarrative,
    ].whereType<String>().toList();

    if (narratives.isEmpty) {
      return Text(
        'Aún faltan datos para un diagnóstico completo.',
        style: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(color: Colors.grey[600]),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: narratives
          .map(
            (text) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• '),
                  Expanded(child: Text(text)),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

bool _isMaleSex(String sex) {
  final normalized = sex.toLowerCase();
  return normalized.contains('masc') || normalized.contains('hombre');
}
