import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:nutrivigil/core/di/dependencies.dart';
import 'package:nutrivigil/domain/patient/weight_assessment.dart';
import 'package:nutrivigil/core/routes/app_router.dart';
import 'package:nutrivigil/presentation/weight_assessment/bloc/weight_assessment_bloc.dart';
import 'package:nutrivigil/domain/care_episode/care_episode_cubit.dart';

class WeightAssessmentPage extends StatelessWidget {
  const WeightAssessmentPage({super.key, required this.patientId});

  final String patientId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WeightAssessmentBloc(
        sl(),
        sl(),
        sl(),
      )..add(WeightAssessmentStarted(patientId)),
      child: const _WeightAssessmentView(),
    );
  }
}

class _WeightAssessmentView extends StatelessWidget {
  const _WeightAssessmentView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Estimador de peso')),
      body: BlocConsumer<WeightAssessmentBloc, WeightAssessmentState>(
        listener: (context, state) {
          if (state.errorMessage != null &&
              state.status == WeightAssessmentStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage!)),
            );
          }
          if (state.saveSuccess) {
            final assessment = state.latestAssessment;
            final computation = state.computation;
            final patient = state.patient;
            if (assessment != null &&
                computation != null &&
                patient != null &&
                context.mounted) {
              final episodeCubit = sl<CareEpisodeCubit>();
              episodeCubit.setPatient(patient);
              episodeCubit.setWeightAssessment(computation);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Valoración guardada')),
              );
              Navigator.of(context).pushNamed(
                AppRouter.nutritionalStatus,
                arguments: NutritionalStatusPageArgs(patientId: patient.id),
              );
            }
          }
        },
        builder: (context, state) {
          if (state.status == WeightAssessmentStatus.loading ||
              state.patient == null) {
            return const Center(child: CircularProgressIndicator());
          }
          final computation = state.computation;
          final showAnthropometry = !state.hasRealWeight ||
              !state.weightTrusted ||
              !state.heightReliable;
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _HeaderSummary(state: state),
                  const SizedBox(height: 16),
                  _VitalsPanel(state: state),
                  const SizedBox(height: 16),
                  if (showAnthropometry) ...[
                    _AnthropometryPanel(state: state),
                    const SizedBox(height: 16),
                  ],
                  _FlagsPanel(state: state),
                  const SizedBox(height: 16),
                  if (computation != null) ...[
                    _ResultsPanel(state: state),
                    const SizedBox(height: 16),
                    _DecisionSummary(state: state),
                    const SizedBox(height: 16),
                    _PendingActionsList(actions: computation.pendingActions),
                  ] else ...[
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          'Completa peso real o antropometría para calcular el peso de trabajo.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: state.canContinue
                        ? () => context
                            .read<WeightAssessmentBloc>()
                            .add(const WeightAssessmentSaved())
                        : null,
                    icon: state.status == WeightAssessmentStatus.saving
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.arrow_forward),
                    label: const Text('Continuar'),
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

class _HeaderSummary extends StatelessWidget {
  const _HeaderSummary({required this.state});

  final WeightAssessmentState state;

  @override
  Widget build(BuildContext context) {
    final patient = state.patient!;
    final bmi = state.computation?.bmi;
    final confidence = state.computation?.confidence ?? WeightConfidence.media;
    final color = switch (confidence) {
      WeightConfidence.alta => Colors.green,
      WeightConfidence.media => Colors.amber,
      WeightConfidence.baja => Colors.red,
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.15),
              child: Icon(Icons.monitor_weight, color: color),
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
                  Text('${patient.sex} · ${patient.age} años'),
                  if (bmi != null)
                    Text('IMC: ${bmi.toStringAsFixed(1)} kg/m²',
                        style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Confianza',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                Text(
                  confidence.name.toUpperCase(),
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(color: color),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _VitalsPanel extends StatelessWidget {
  const _VitalsPanel({required this.state});

  final WeightAssessmentState state;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<WeightAssessmentBloc>();
    final weightController = TextEditingController(
      text: state.weightKg?.toStringAsFixed(1) ?? '',
    );
    final heightController = TextEditingController(
      text: state.heightCm?.toStringAsFixed(1) ?? '',
    );

    final double weightValue = (state.weightKg != null &&
            state.weightKg! >= 30 &&
            state.weightKg! <= 250)
        ? state.weightKg!
        : 70.0;
    final double heightValue = (state.heightCm != null &&
            state.heightCm! >= 120 &&
            state.heightCm! <= 210)
        ? state.heightCm!
        : 165.0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Datos actuales',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            SwitchListTile(
              title: const Text('Tengo un peso real medido'),
              subtitle: const Text(
                'Activa sólo si el peso proviene de báscula o cama balanza reciente.',
              ),
              value: state.hasRealWeight,
              onChanged: (value) =>
                  bloc.add(WeightAssessmentAvailabilityChanged(value)),
            ),
            if (state.hasRealWeight) ...[
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: weightController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Peso actual (kg)',
                      ),
                      onChanged: (value) => bloc.add(
                        WeightAssessmentVitalsChanged(
                          weightKg: double.tryParse(value),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: heightController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Talla (cm)',
                      ),
                      onChanged: (value) => bloc.add(
                        WeightAssessmentVitalsChanged(
                          heightCm: double.tryParse(value),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const SizedBox(height: 12),
              if (!state.weightTrusted) ...[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Desliza para ajustar peso (estimación)'),
                        Text('${weightValue.toStringAsFixed(1)} kg'),
                      ],
                    ),
                    Slider(
                      min: 30,
                      max: 250,
                      divisions: 220,
                      label: '${weightValue.toStringAsFixed(1)} kg',
                      value: weightValue,
                      onChanged: (value) => bloc.add(
                        WeightAssessmentVitalsChanged(
                          weightKg: double.parse(value.toStringAsFixed(1)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Desliza para ajustar talla'),
                        Text('${heightValue.toStringAsFixed(1)} cm'),
                      ],
                    ),
                    Slider(
                      min: 120,
                      max: 210,
                      divisions: 90,
                      label: '${heightValue.toStringAsFixed(1)} cm',
                      value: heightValue,
                      onChanged: (value) => bloc.add(
                        WeightAssessmentVitalsChanged(
                          heightCm: double.parse(value.toStringAsFixed(1)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              SwitchListTile(
                title: const Text('Peso confiable / en seco'),
                subtitle: const Text(
                    'Confirma que no es estimado ni está influido por edema.'),
                value: state.weightTrusted,
                onChanged: (value) => bloc.add(
                  WeightAssessmentVitalsChanged(weightTrusted: value),
                ),
              ),
              SwitchListTile(
                value: state.measurementRecent,
                onChanged: (value) => bloc.add(
                  WeightAssessmentVitalsChanged(measurementRecent: value),
                ),
                title: const Text('Peso tomado hace < 72 h'),
              ),
              DropdownButtonFormField<WeightSource>(
                value: state.weightSource,
                items: WeightSource.values
                    .map(
                      (source) => DropdownMenuItem(
                        value: source,
                        child: Text(_sourceLabel(source)),
                      ),
                    )
                    .toList(),
                decoration: const InputDecoration(labelText: 'Fuente'),
                onChanged: (value) => bloc.add(
                  WeightAssessmentVitalsChanged(weightSource: value),
                ),
              ),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Fecha/hora de medición'),
                subtitle: Text(
                  (state.measurementDate ?? DateTime.now()).toString(),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () async {
                    final current = state.measurementDate ?? DateTime.now();
                    final date = await showDatePicker(
                      context: context,
                      initialDate: current,
                      firstDate: DateTime(current.year - 1),
                      lastDate: DateTime.now(),
                    );
                    if (date == null) return;
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(current),
                    );
                    final combined = DateTime(
                      date.year,
                      date.month,
                      date.day,
                      time?.hour ?? current.hour,
                      time?.minute ?? current.minute,
                    );
                    bloc.add(
                      WeightAssessmentVitalsChanged(measurementDate: combined),
                    );
                  },
                ),
              ),
            ],
            if (!state.hasRealWeight) ...[
              TextField(
                controller: heightController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Talla (cm)'),
                onChanged: (value) => bloc.add(
                  WeightAssessmentVitalsChanged(
                    heightCm: double.tryParse(value),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Desliza para ajustar talla'),
                  Text('${heightValue.toStringAsFixed(1)} cm'),
                ],
              ),
              Slider(
                min: 120,
                max: 210,
                divisions: 90,
                label: '${heightValue.toStringAsFixed(1)} cm',
                value: heightValue,
                onChanged: (value) => bloc.add(
                  WeightAssessmentVitalsChanged(
                    heightCm: double.parse(value.toStringAsFixed(1)),
                  ),
                ),
              ),
            ],
            SwitchListTile(
              value: state.heightReliable,
              onChanged: (value) => bloc.add(
                WeightAssessmentVitalsChanged(heightReliable: value),
              ),
              title: const Text('Talla reportada es confiable'),
            ),
          ],
        ),
      ),
    );
  }
}

class _FlagsPanel extends StatelessWidget {
  const _FlagsPanel({required this.state});

  final WeightAssessmentState state;

  @override
  Widget build(BuildContext context) {
    final flags = state.flags;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Condiciones clínicas',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                _FlagChip(
                  label: 'Obesidad sospechada',
                  value: flags.obesidad,
                  onChanged: (value) =>
                      _updateFlags(context, flags.copyWith(obesidad: value)),
                ),
                _FlagChip(
                  label: 'Edema / anasarca',
                  value: flags.edema,
                  onChanged: (value) =>
                      _updateFlags(context, flags.copyWith(edema: value)),
                ),
                _FlagChip(
                  label: 'Ascitis',
                  value: flags.ascitis,
                  onChanged: (value) =>
                      _updateFlags(context, flags.copyWith(ascitis: value)),
                ),
                _FlagChip(
                  label: 'Peso en seco confirmado',
                  value: flags.pesoSecoConfirmado,
                  onChanged: (value) => _updateFlags(
                    context,
                    flags.copyWith(pesoSecoConfirmado: value),
                  ),
                ),
                _FlagChip(
                  label: 'Embarazo',
                  value: flags.embarazo,
                  onChanged: (value) =>
                      _updateFlags(context, flags.copyWith(embarazo: value)),
                ),
                _FlagChip(
                  label: 'Columna anómala',
                  value: flags.columnaAlterada,
                  onChanged: (value) => _updateFlags(
                      context, flags.copyWith(columnaAlterada: value)),
                ),
              ],
            ),
            if (flags.ascitis)
              DropdownButtonFormField<String>(
                value: flags.ascitisSeveridad,
                decoration: const InputDecoration(
                  labelText: 'Severidad de ascitis',
                ),
                items: const [
                  DropdownMenuItem(value: 'leve', child: Text('Leve (3 kg)')),
                  DropdownMenuItem(
                      value: 'moderada', child: Text('Moderada (4.5 kg)')),
                  DropdownMenuItem(
                      value: 'severa', child: Text('Severa (7 kg)')),
                ],
                onChanged: (value) => _updateFlags(
                    context, flags.copyWith(ascitisSeveridad: value)),
              ),
            const SizedBox(height: 12),
            Text('Amputaciones', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _amputationOptions.map((option) {
                final selected = flags.amputaciones.contains(option);
                return FilterChip(
                  label: Text(option),
                  selected: selected,
                  onSelected: (value) {
                    final updated = List<String>.from(flags.amputaciones);
                    if (value) {
                      updated.add(option);
                    } else {
                      updated.remove(option);
                    }
                    _updateFlags(
                        context, flags.copyWith(amputaciones: updated));
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _updateFlags(BuildContext context, WeightFlags flags) {
    context
        .read<WeightAssessmentBloc>()
        .add(WeightAssessmentFlagsChanged(flags));
  }
}

class _AnthropometryPanel extends StatelessWidget {
  const _AnthropometryPanel({required this.state});

  final WeightAssessmentState state;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<WeightAssessmentBloc>();
    final kneeController = TextEditingController(
      text: state.kneeHeightCm?.toStringAsFixed(1) ?? '',
    );
    final ulnaController = TextEditingController(
      text: state.ulnaLengthCm?.toStringAsFixed(1) ?? '',
    );
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Antropometría',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              _anthropometryReason(state),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: kneeController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Altura de rodilla (cm)',
                    ),
                    onChanged: (value) => bloc.add(
                      WeightAssessmentAnthropometryChanged(
                        kneeHeightCm: double.tryParse(value),
                        ulnaLengthCm: state.ulnaLengthCm,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: ulnaController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Longitud ulna (cm)',
                    ),
                    onChanged: (value) => bloc.add(
                      WeightAssessmentAnthropometryChanged(
                        kneeHeightCm: state.kneeHeightCm,
                        ulnaLengthCm: double.tryParse(value),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

String _anthropometryReason(WeightAssessmentState state) {
  if (!state.hasRealWeight) {
    return 'No hay peso real registrado; estima talla/peso con mediciones anatómicas.';
  }
  if (!state.weightTrusted) {
    return 'El peso fue marcado como no confiable, captura antropometría para validar.';
  }
  if (!state.heightReliable) {
    return 'La talla ingresada es dudosa; utiliza rodilla o ulna para estimarla.';
  }
  return 'Complementa con antropometría si necesitas validar.';
}

class _ResultsPanel extends StatelessWidget {
  const _ResultsPanel({required this.state});

  final WeightAssessmentState state;

  @override
  Widget build(BuildContext context) {
    final comp = state.computation!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Resultados', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Wrap(
              spacing: 16,
              runSpacing: 12,
              children: [
                _ResultTile(
                  label: 'Peso ideal (PI)',
                  value: _formatKg(comp.idealWeightKg),
                ),
                _ResultTile(
                  label: 'Peso ajustado (PA)',
                  value: _formatKg(comp.adjustedWeightKg),
                ),
                _ResultTile(
                  label: 'Peso calculado',
                  value: _formatKg(comp.recalculatedRealKg ?? state.weightKg),
                ),
                _ResultTile(
                  label: 'IMC',
                  value: comp.bmi != null
                      ? '${comp.bmi!.toStringAsFixed(1)} kg/m²'
                      : '-',
                ),
                _ResultTile(
                  label: 'Método sugerido',
                  value: comp.recommendedMethod.name,
                ),
              ],
            ),
            if (comp.heightMethod != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Talla usada: ${comp.heightUsedCm?.toStringAsFixed(1) ?? '-'} cm '
                  '(${comp.heightMethod})',
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatKg(double? value) {
    if (value == null) return '-';
    return '${value.toStringAsFixed(1)} kg';
  }
}

class _PendingActionsList extends StatelessWidget {
  const _PendingActionsList({required this.actions});

  final List<String> actions;

  @override
  Widget build(BuildContext context) {
    if (actions.isEmpty) {
      return const SizedBox.shrink();
    }
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Acciones pendientes',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            ...actions.map(
              (action) => Row(
                children: [
                  const Icon(Icons.pending_actions, size: 16),
                  const SizedBox(width: 8),
                  Expanded(child: Text(action)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DecisionSummary extends StatelessWidget {
  const _DecisionSummary({required this.state});

  final WeightAssessmentState state;

  @override
  Widget build(BuildContext context) {
    final comp = state.computation;
    if (comp == null) {
      return const SizedBox.shrink();
    }
    final method = comp.recommendedMethod;
    final reasons = _decisionReasons(state);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Resumen de decisión',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              'Peso de trabajo: ${state.recommendedWeight?.toStringAsFixed(1) ?? '-'} kg',
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              'Método aplicado: ${_methodLabel(method)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            if (reasons.isEmpty)
              const Text(
                  'Se usa el peso real porque cumple criterios de confiabilidad.')
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: reasons
                    .map((reason) => Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('• '),
                            Expanded(child: Text(reason)),
                          ],
                        ))
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }
}

class _ResultTile extends StatelessWidget {
  const _ResultTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelSmall),
          Text(
            value,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _FlagChip extends StatelessWidget {
  const _FlagChip({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: value,
      onSelected: onChanged,
    );
  }
}

String _methodLabel(WorkWeightMethod method) {
  switch (method) {
    case WorkWeightMethod.real:
      return 'Peso real';
    case WorkWeightMethod.ideal:
      return 'Peso ideal (PI)';
    case WorkWeightMethod.ajustado:
      return 'Peso ajustado (PA)';
    case WorkWeightMethod.realAjustado:
      return 'Real ajustado (energía)';
    case WorkWeightMethod.otro:
      return 'Otro (manual)';
  }
}

String _sourceLabel(WeightSource source) {
  switch (source) {
    case WeightSource.bascula:
      return 'Báscula';
    case WeightSource.camaBalanza:
      return 'Cama balanza';
    case WeightSource.estimado:
      return 'Estimado';
    case WeightSource.desconocido:
      return 'Desconocido';
  }
}

const _amputationOptions = [
  'Mano',
  'Antebrazo',
  'Brazo',
  'Pie',
  'Pierna',
  'Muslo',
  'Hemicuerpo',
];

List<String> _decisionReasons(WeightAssessmentState state) {
  final comp = state.computation;
  if (comp == null) return const [];
  final reasons = <String>[];
  if (!state.hasRealWeight) {
    reasons.add('Sin peso real reciente: se usa PI/PA de antropometría.');
  } else if (!state.weightTrusted) {
    reasons.add('Peso marcado como no confiable (edema/estimado).');
  }
  if (!state.measurementRecent && state.hasRealWeight) {
    reasons.add('Última medición supera las 72 h.');
  }
  if (state.flags.edema || state.flags.ascitis) {
    reasons.add('Retención hídrica reportada: se evita el peso real.');
  }
  if ((comp.bmi ?? 0) >= 30 || state.flags.obesidad) {
    reasons.add('IMC ≥ 30 / obesidad sospechada → energía con peso ajustado.');
  }
  return reasons;
}
