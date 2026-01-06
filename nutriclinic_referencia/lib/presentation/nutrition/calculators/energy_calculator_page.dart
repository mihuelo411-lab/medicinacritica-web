import 'package:flutter/material.dart';

import 'package:nutrivigil/core/di/dependencies.dart';
import 'package:nutrivigil/data/repositories/nutrition_repository.dart';
import 'package:nutrivigil/data/repositories/patient_repository.dart';
import 'package:nutrivigil/data/repositories/monitoring_repository.dart';
import 'package:nutrivigil/data/repositories/energy_plan_repository.dart';
import 'package:nutrivigil/core/routes/app_router.dart';
import 'package:nutrivigil/domain/nutrition/calculators/energy_calculator.dart';
import 'package:nutrivigil/domain/nutrition/nutrition_requirements.dart';
import 'package:nutrivigil/domain/patient/patient_entity.dart';
import 'package:nutrivigil/presentation/nutrition/adjustment/energy_adjustment_page.dart';
import 'package:nutrivigil/domain/care_episode/care_episode.dart';
import 'package:nutrivigil/domain/care_episode/care_episode_cubit.dart';
import 'package:nutrivigil/domain/monitoring/daily_monitoring_entry.dart';

class FactorOption {
  const FactorOption(this.label, this.value);

  final String label;
  final double value;
}

const List<FactorOption> _stressOptions = [
  FactorOption('Reposo metabólico', 1.0),
  FactorOption('Sepsis controlada', 1.2),
  FactorOption('Trauma mayor', 1.3),
  FactorOption('Quemaduras >40%', 1.5),
  FactorOption('Personalizado', 0),
];

const List<FactorOption> _activityOptions = [
  FactorOption('Reposo en cama', 1.0),
  FactorOption('Movilización mínima', 1.1),
  FactorOption('Rehabilitación activa', 1.2),
  FactorOption('Personalizado', 0),
];

class EnergyCalculatorPage extends StatefulWidget {
  const EnergyCalculatorPage({
    super.key,
    this.initialPatientId,
    this.initialWeightKg,
    this.initialHeightCm,
    this.initialAge,
    this.initialIsMale,
    this.initialPatientName,
    this.initialStressFactor,
    this.initialActivityFactor,
    this.initialRiskLabel,
    this.initialRequiresVentilation = false,
    this.initialTriglycerides,
  });

  final String? initialPatientId;
  final double? initialWeightKg;
  final double? initialHeightCm;
  final int? initialAge;
  final bool? initialIsMale;
  final String? initialPatientName;
  final double? initialStressFactor;
  final double? initialActivityFactor;
  final String? initialRiskLabel;
  final bool initialRequiresVentilation;
  final double? initialTriglycerides;

  @override
  State<EnergyCalculatorPage> createState() => _EnergyCalculatorPageState();
}

class _EnergyCalculatorPageState extends State<EnergyCalculatorPage> {
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _ageController = TextEditingController();
  final _stressController = TextEditingController(text: '1.2');
  final _activityController = TextEditingController(text: '1.0');
  final _temperatureController = TextEditingController();
  final _veController = TextEditingController();
  final _heartRateController = TextEditingController();
  final _paco2Controller = TextEditingController();
  final _triglyceridesController = TextEditingController();

  bool _requiresVentilation = false;
  bool _isMale = true;
  PatientProfile? _patient;
  FactorOption _selectedStress = _stressOptions[1];
  FactorOption _selectedActivity = _activityOptions.first;
  bool _stressCustom = false;
  bool _activityCustom = false;
  bool _hasTrauma = false;
  bool _hasBurns = false;
  bool _isObese = false;
  double? _currentBmi;
  double _lipidPercent = 25;
  DailyMonitoringEntry? _latestMonitoring;
  double? _manualTriglycerides;
  List<_EnergyResult> _results = const [];
  bool _saving = false;
  String? _patientName;
  String? _riskLabel;
  NutritionRequirements? _persistedRequirement;
  double? _proteinPerKgOverride;

  final _calculator = const EnergyCalculator();

  @override
  void initState() {
    super.initState();
    _prefillFromArgs();
    _loadPatient();
  }

  void _prefillFromArgs() {
    if (widget.initialWeightKg != null) {
      _weightController.text = widget.initialWeightKg!.toStringAsFixed(1);
    }
    if (widget.initialHeightCm != null) {
      _heightController.text = widget.initialHeightCm!.toStringAsFixed(1);
    }
    if (widget.initialAge != null) {
      _ageController.text = widget.initialAge!.toString();
    }
    if (widget.initialIsMale != null) {
      _isMale = widget.initialIsMale!;
    }
    if (widget.initialPatientName != null) {
      _patientName = widget.initialPatientName;
    }
    _riskLabel = widget.initialRiskLabel;
    _requiresVentilation = widget.initialRequiresVentilation;
    _setStressOption(_selectedStress);
    _setActivityOption(_selectedActivity);
    final initialStress = widget.initialStressFactor;
    if (initialStress != null) {
      final match = _stressOptions.firstWhere(
        (option) =>
            option.value != 0 && (option.value - initialStress).abs() < 0.05,
        orElse: () => _stressOptions.last,
      );
      if (match.label == 'Personalizado') {
        _setStressOption(match, customValue: initialStress);
      } else {
        _setStressOption(match);
      }
    }
    final initialActivity = widget.initialActivityFactor;
    if (initialActivity != null) {
      final match = _activityOptions.firstWhere(
        (option) =>
            option.value != 0 && (option.value - initialActivity).abs() < 0.05,
        orElse: () => _activityOptions.last,
      );
      if (match.label == 'Personalizado') {
        _setActivityOption(match, customValue: initialActivity);
      } else {
        _setActivityOption(match);
      }
    }
    if (widget.initialTriglycerides != null) {
      _manualTriglycerides = widget.initialTriglycerides;
      _triglyceridesController.text =
          widget.initialTriglycerides!.toStringAsFixed(0);
      _applyTriglycerideRule();
    }
    _updateObesityFromFields();
  }

  Future<void> _loadPatient() async {
    final episodePatient = sl<CareEpisodeCubit>().state.patient;
    String? patientId = widget.initialPatientId ?? episodePatient?.id;
    PatientProfile? fetched;

    if (patientId != null) {
      fetched = await sl<PatientRepository>().fetchById(patientId);
    }
    fetched ??= episodePatient;
    if (!mounted || fetched == null) {
      return;
    }
    patientId ??= fetched.id;
    final patient = fetched;
    setState(() {
      _patient = patient;
      _patientName = patient.fullName;
      _isMale =
          widget.initialIsMale ?? patient.sex.toLowerCase().startsWith('m');
      
      // CRITICAL FIX: Only overwrite weight if NOT provided in args (Adjusted Weight) 
      // and NOT already typed by user.
      if (widget.initialWeightKg == null && _weightController.text.isEmpty) {
        _weightController.text = patient.weightKg.toStringAsFixed(1);
      }
      
      if (_heightController.text.isEmpty) {
        _heightController.text = patient.heightCm.toStringAsFixed(1);
      }
      if (_ageController.text.isEmpty) {
        _ageController.text = patient.age.toString();
      }
      _updateObesityFromFields();
    });
    await _loadLatestMonitoring(patientId);
    await _loadStoredPlan(patientId);
  }

  Future<void> _loadLatestMonitoring(String patientId) async {
    try {
      final entries = await sl<MonitoringRepository>().fetchByPatient(patientId);
      if (entries.isEmpty) return;
      entries.sort((a, b) => b.date.compareTo(a.date));
      final latest = entries.first;
      if (!mounted) return;
      setState(() {
        _latestMonitoring = latest;
        if (_triglyceridesController.text.isEmpty &&
            latest.triglyceridesMgDl != null) {
          _triglyceridesController.text =
              latest.triglyceridesMgDl!.toStringAsFixed(0);
        }
        final max = _lipidPercentMax;
        if (_lipidPercent > max) {
          _lipidPercent = max;
        }
        _applyTriglycerideRule();
      });
    } catch (_) {
      // Ignoramos errores de carga de monitoreo; no bloquean la pantalla.
    }
  }

  void _setStressOption(FactorOption option, {double? customValue}) {
    _selectedStress = option;
    _stressCustom = option.label == 'Personalizado';
    if (_stressCustom) {
      final value =
          customValue ?? double.tryParse(_stressController.text) ?? 1.2;
      _stressController.text = value.toStringAsFixed(2);
    } else {
      _stressController.text = option.value.toStringAsFixed(2);
    }
  }

  void _setActivityOption(FactorOption option, {double? customValue}) {
    _selectedActivity = option;
    _activityCustom = option.label == 'Personalizado';
    if (_activityCustom) {
      final value =
          customValue ?? double.tryParse(_activityController.text) ?? 1.0;
      _activityController.text = value.toStringAsFixed(2);
    } else {
      _activityController.text = option.value.toStringAsFixed(2);
    }
  }

  void _updateObesityFromFields() {
    final weight = double.tryParse(_weightController.text);
    final height = double.tryParse(_heightController.text);
    if (weight == null || height == null || height <= 0) {
      _currentBmi = null;
      _isObese = false;
      return;
    }
    final bmi = weight / ((height / 100) * (height / 100));
    _currentBmi = bmi;
    _isObese = bmi >= 30;
  }

  double? get _currentTriglycerides {
    if (_manualTriglycerides != null) {
      return _manualTriglycerides;
    }
    return _latestMonitoring?.triglyceridesMgDl;
  }

  void _applyTriglycerideRule({bool forceDefault = false}) {
    final trig = _currentTriglycerides;
    if (trig != null) {
      final target = trig >= 400 ? 20.0 : 25.0;
      _lipidPercent = target;
    } else if (forceDefault) {
      _lipidPercent = 25;
    }
  }

  Future<void> _loadStoredPlan(String patientId) async {
    try {
      final snapshot =
          await sl<EnergyPlanRepository>().latestSnapshot(patientId);
      if (!mounted || snapshot == null) {
        return;
      }
      setState(() {
        _persistedRequirement = snapshot.requirements;
        _proteinPerKgOverride = snapshot.proteinPerKg;
        if (snapshot.lipidPercent != null) {
          _lipidPercent = snapshot.lipidPercent!;
        }
        if (snapshot.triglycerides != null) {
          _manualTriglycerides = snapshot.triglycerides;
          _triglyceridesController.text =
              snapshot.triglycerides!.toStringAsFixed(0);
        }
        final storedResults = snapshot.formulas
                ?.map(
                  (formula) => _EnergyResult(
                    formula.name,
                    formula.calories,
                    formula.proteinGrams,
                    kcalLabel: null,
                    notes: formula.notes,
                  ),
                )
                .toList() ??
            [];
        _results = storedResults.isNotEmpty
            ? storedResults
            : [
                _EnergyResult(
                  'Objetivo registrado',
                  snapshot.requirements.caloriesPerDay,
                  snapshot.requirements.proteinGrams,
                  notes: snapshot.requirements.notes,
                ),
              ];
      });
    } catch (_) {
      // Ignoramos errores de carga del plan guardado.
    }
  }

  void _onTriglyceridesChanged(String value) {
    final parsed = double.tryParse(value);
    setState(() {
      _manualTriglycerides = parsed;
      _applyTriglycerideRule(forceDefault: parsed == null && _latestMonitoring?.triglyceridesMgDl == null);
    });
  }

  double get _lipidPercentMin => 15;

  double get _lipidPercentMax {
    final trig = _currentTriglycerides;
    if (trig != null && trig >= 400) {
      return 20;
    }
    return 35;
  }

  String? get _lipidRestrictionMessage {
    final trig = _currentTriglycerides;
    if (trig != null && trig >= 400) {
      return 'Triglicéridos recientes ${trig.toStringAsFixed(0)} mg/dL: '
          'limita los lípidos a ≤20 % de las kcal.';
    }
    return null;
  }

  String? get _lipidLabReminder {
    if (_currentTriglycerides == null) {
      return 'Sin triglicéridos recientes registrados. Solicita TG y PFH para ajustar lípidos.';
    }
    return null;
  }

  String? get _hepaticWarning {
    final ast = _latestMonitoring?.ast;
    final alt = _latestMonitoring?.alt;
    if ((ast != null && ast >= 120) || (alt != null && alt >= 120)) {
      return 'PFH elevadas (AST/ALT ≥3x VN): considera reducir el % de lípidos.';
    }
    return null;
  }

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    _ageController.dispose();
    _stressController.dispose();
    _activityController.dispose();
    _temperatureController.dispose();
    _veController.dispose();
    _heartRateController.dispose();
    _paco2Controller.dispose();
    _triglyceridesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Requerimiento energético')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          child: ListView(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Paciente',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      Text(_patientName ?? 'Paciente sin nombre'),
                      Text('Sexo: ${_isMale ? 'Masculino' : 'Femenino'}'),
                      Text(
                          'Edad: ${_ageController.text.isEmpty ? '-' : _ageController.text} años'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (_riskLabel != null)
                Card(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  child: ListTile(
                    leading: const Icon(Icons.warning_amber_outlined),
                    title: const Text('Riesgo nutricional inicial'),
                    subtitle: Text(_riskLabel!),
                  ),
                ),
              if (_riskLabel != null) const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Datos antropométricos',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 12),
                      _infoLine(
                        label: 'Peso de trabajo',
                        value: _formatNumber(_weightController.text, suffix: 'kg'),
                      ),
                      if (widget.initialWeightKg != null &&
                          _patient != null &&
                          (widget.initialWeightKg! - _patient!.weightKg).abs() > 0.1)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade100,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.orange.shade300),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.info_outline,
                                    size: 16, color: Colors.orange.shade900),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Peso ajustado (Real: ${_patient!.weightKg.toStringAsFixed(1)} kg)',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.orange.shade900,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      const SizedBox(height: 8),
                      _infoLine(
                        label: 'Talla',
                        value: _formatNumber(_heightController.text, suffix: 'cm'),
                      ),
                      const SizedBox(height: 8),
                      _infoLine(
                        label: 'Edad',
                        value: _ageController.text.isEmpty
                            ? 'Sin dato'
                            : '${_ageController.text} años',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<FactorOption>(
                value: _selectedStress,
                decoration:
                    const InputDecoration(labelText: 'Factor de estrés'),
                items: _stressOptions
                    .map(
                      (option) => DropdownMenuItem(
                        value: option,
                        child: Text(option.label),
                      ),
                    )
                    .toList(),
                onChanged: (option) {
                  if (option == null) return;
                  setState(() => _setStressOption(option));
                },
              ),
              if (_stressCustom) ...[
                const SizedBox(height: 8),
                TextFormField(
                  controller: _stressController,
                  decoration: const InputDecoration(
                    labelText: 'Factor de estrés (personalizado)',
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
              ] else ...[
                const SizedBox(height: 8),
                Text(
                    'Aplicará ${_stressController.text} según ${_selectedStress.label}'),
              ],
              const SizedBox(height: 16),
              DropdownButtonFormField<FactorOption>(
                value: _selectedActivity,
                decoration:
                    const InputDecoration(labelText: 'Factor de actividad'),
                items: _activityOptions
                    .map(
                      (option) => DropdownMenuItem(
                        value: option,
                        child: Text(option.label),
                      ),
                    )
                    .toList(),
                onChanged: (option) {
                  if (option == null) return;
                  setState(() => _setActivityOption(option));
                },
              ),
              if (_activityCustom) ...[
                const SizedBox(height: 8),
                TextFormField(
                  controller: _activityController,
                  decoration: const InputDecoration(
                    labelText: 'Factor de actividad (personalizado)',
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
              ] else ...[
                const SizedBox(height: 8),
                Text(
                    'Aplicará ${_activityController.text} según ${_selectedActivity.label}'),
              ],
              const SizedBox(height: 12),
              TextFormField(
                controller: _triglyceridesController,
                decoration: const InputDecoration(
                  labelText: 'Triglicéridos recientes (mg/dL)',
                  helperText:
                      'Ingresa valores de laboratorio <72 h para fijar el % de lípidos.',
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                onChanged: _onTriglyceridesChanged,
              ),
              const SizedBox(height: 12),
              if (_requiresVentilation) ...[
                SwitchListTile(
                  title: const Text('Trauma mayor (Ireton-Jones)'),
                  value: _hasTrauma,
                  onChanged: (value) => setState(() => _hasTrauma = value),
                ),
                SwitchListTile(
                  title: const Text('Quemaduras significativas'),
                  value: _hasBurns,
                  onChanged: (value) => setState(() => _hasBurns = value),
                ),
                TextFormField(
                  controller: _temperatureController,
                  decoration:
                      const InputDecoration(labelText: 'Temperatura (°C)'),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _veController,
                  decoration:
                      const InputDecoration(labelText: 'Volumen minuto (L)'),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(height: 12),
              ] else ...[
                Card(
                  child: ListTile(
                    leading: Icon(
                      _isObese
                          ? Icons.check_circle_outline
                          : Icons.info_outline,
                    ),
                    title: Text(
                      'IMC estimado: ${_currentBmi != null ? _currentBmi!.toStringAsFixed(1) : 'N/D'}',
                    ),
                    subtitle: Text(
                      _isObese
                          ? 'Aplicará fórmulas especiales para obesidad (IMC ≥ 30).'
                          : 'IMC < 30: fórmulas estándar.',
                    ),
                  ),
                ),
              ],
              FilledButton.icon(
                onPressed: () => _calculate(),
                icon: const Icon(Icons.calculate_outlined),
                label: const Text('Calcular'),
              ),
              const SizedBox(height: 24),
              if (_results.isNotEmpty) ...[
                Text(
                  'Resultados por fórmula',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                ..._results.map(
                  (item) => ListTile(
                    title: Text(item.label),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.caloriesLabel),
                        const SizedBox(height: 4),
                        Text(item.proteinLabel),
                        if (item.notes != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            item.notes!,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.check_circle_outline),
                  title: const Text('Requerimiento sugerido (media)'),
                  subtitle: Text(
                    '${_finalRequirement.caloriesPerDay.toStringAsFixed(0)} kcal/día • '
                    '${_finalRequirement.proteinGrams.toStringAsFixed(1)} g proteína',
                  ),
                ),
                const SizedBox(height: 12),
                _buildLipidAdjuster(context),
                const SizedBox(height: 12),
                if (_macroTargetsOrNull case final macroTargets?) ...[
                  _MacroBreakdownCard(targets: macroTargets),
                  const SizedBox(height: 16),
                ],
                FilledButton.icon(
                  onPressed: (widget.initialPatientId ?? _patient?.id) == null ||
                          _finalRequirement.caloriesPerDay <= 0 ||
                          _saving
                      ? null
                      : _saveAndContinue,
                  icon: _saving
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.navigate_next),
                  label: const Text('Guardar e ir a ajuste'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoLine({required String label, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }

  Widget _buildLipidAdjuster(BuildContext context) {
    final min = _lipidPercentMin;
    final max = _lipidPercentMax;
    final sliderValue = _lipidPercent.clamp(min, max);
    final restriction = _lipidRestrictionMessage;
    final labReminder = _lipidLabReminder;
    final hepatic = _hepaticWarning;
    final trig = _currentTriglycerides;
    if (trig != null) {
      final reason =
          trig >= 400 ? 'TG ≥ 400 mg/dL (máximo 20 %)' : 'TG disponibles';
      return Card(
        child: ListTile(
          title: const Text('Lípidos ajustados automáticamente'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Triglicéridos: ${trig.toStringAsFixed(0)} mg/dL.',
              ),
              Text(
                'Se aplicará ${sliderValue.toStringAsFixed(0)} % de las kcal (${reason}).',
              ),
              if (restriction != null) ...[
                const SizedBox(height: 4),
                Text(
                  restriction,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Theme.of(context).colorScheme.error),
                ),
              ],
              if (hepatic != null) ...[
                const SizedBox(height: 4),
                Text(
                  hepatic,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Theme.of(context).colorScheme.error),
                ),
              ],
            ],
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Distribución de lípidos',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Slider(
              value: sliderValue,
              min: min,
              max: max,
              divisions:
                  (max - min).abs() < 1 ? null : (max - min).round(),
              label: '${sliderValue.toStringAsFixed(0)}%',
              onChanged: (value) => setState(() => _lipidPercent = value),
            ),
            Text(
              'Lípidos: ${sliderValue.toStringAsFixed(0)} % de las kcal (ASPEN 20‑30 %).',
            ),
            const SizedBox(height: 4),
            const Text(
              'Los carbohidratos se ajustarán para completar el 100 % restante.',
            ),
            if (restriction != null) ...[
              const SizedBox(height: 8),
              Text(
                restriction,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Theme.of(context).colorScheme.error),
              ),
            ],
            if (hepatic != null) ...[
              const SizedBox(height: 4),
              Text(
                hepatic,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Theme.of(context).colorScheme.error),
              ),
            ],
            if (labReminder != null) ...[
              const SizedBox(height: 8),
              Text(
                labReminder,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatNumber(String text, {String? suffix}) {
    final parsed = double.tryParse(text.trim());
    final formatted = parsed == null
        ? 'Sin dato'
        : (parsed % 1 == 0 ? parsed.toStringAsFixed(0) : parsed.toStringAsFixed(1));
    if (formatted == 'Sin dato') {
      return formatted;
    }
    return suffix != null ? '$formatted $suffix' : formatted;
  }

  double get _currentStressFactor =>
      double.tryParse(_stressController.text) ?? 1.2;

  void _calculate() {
    final weight = double.tryParse(_weightController.text);
    final height = double.tryParse(_heightController.text);
    final age = int.tryParse(_ageController.text);
    if (weight == null || height == null || age == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Completa los datos antropométricos en la ficha del paciente.'),
        ),
      );
      return;
    }
    final bmi = height > 0
        ? weight / ((height / 100) * (height / 100))
        : null;
    _currentBmi = bmi;
    final hasBmiObesity = bmi != null && bmi >= 30;
    final applyObesityFormulas = hasBmiObesity;

    final patient = _patient;
    if (patient == null) return;
    
    // SMART FORMULA SELECTION (ASPEN/ESPEN Guidelines)
    final formulas = <EnergyFormula>[];
    
    // 1. Obese Patient (BMI >= 30)
    if (bmi != null && bmi >= 30) {
      if (_requiresVentilation) {
        // Obese + Vent: Penn State 2003b is Gold Standard/Preferred
        formulas.add(EnergyFormula.pennState); 
        formulas.add(EnergyFormula.mifflinStJeor); // As fallback comparison
      } else {
        // Obese + Spontaneous: Mifflin-St Jeor is preferred
        formulas.add(EnergyFormula.mifflinStJeor);
        formulas.add(EnergyFormula.harrisBenedict);
      }
    } 
    // 2. Non-Obese Patient
    else {
      if (_requiresVentilation) {
        // Vent + Normal: Penn State still good, or simple Kcal/kg
        formulas.add(EnergyFormula.pennState);
        formulas.add(EnergyFormula.harrisBenedict);
      } else {
        // Spontaneous + Normal: Harris-Benedict or Mifflin are fine
        formulas.add(EnergyFormula.harrisBenedict);
        formulas.add(EnergyFormula.mifflinStJeor);
      }
    }

    const calculator = EnergyCalculator();
    final results = formulas.map((formula) {
      return calculator.calculate(
        patient: patient,
        formula: formula,
        weightOverride: weight,
        stressFactor: _currentStressFactor,
        // activityFactor: ... (If we had it in UI)
        // temp/minuteVolume: ... (If we had fields)
      );
    }).toList();

    setState(() {
      _results = results.map((r) => _EnergyResult(
        r.method,
        r.caloriesPerDay,
        r.proteinGrams,
        kcalLabel: '${r.caloriesPerDay.toStringAsFixed(0)} kcal/día',
      )).toList();
      _currentBmi = bmi;
      _isObese = bmi != null && bmi >= 30;
    });
  }

  String _formulaName(EnergyFormula formula) {
    switch (formula) {
      case EnergyFormula.harrisBenedict:
        return 'Harris-Benedict';
      case EnergyFormula.pennState:
        return 'Penn State (2003b)';
      case EnergyFormula.mifflinStJeor:
        return 'Mifflin-St Jeor';
    }
  }

  void _notifyVentDataMissing(List<String> missing) {
    if (!mounted || missing.isEmpty) {
      return;
    }
    final message = 'Faltan datos ventilatorios: ${missing.toSet().join(', ')}.';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _saveTarget() async {
    final patientId = widget.initialPatientId ?? _patient?.id;
    if (patientId == null || patientId.isEmpty || _results.isEmpty) {
      return;
    }
    setState(() => _saving = true);
    try {
      await sl<NutritionRepository>().save(_finalRequirement, patientId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Objetivo guardado correctamente')),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar: $error')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  NutritionRequirements get _finalRequirement {
    if (_persistedRequirement != null) {
      return _persistedRequirement!;
    }
    final calories = _results.isEmpty
        ? 0.0
        : _results.map((e) => e.kcal).reduce((a, b) => a + b) / _results.length;
    final weight = double.tryParse(_weightController.text) ?? 0;
    final height = double.tryParse(_heightController.text);
    final protein = _proteinGoal(
      weight,
      bmi: _currentBmi,
      heightCm: height,
      stressFactor: _currentStressFactor,
    );
    return NutritionRequirements(
      method: 'Promedio multi-fórmula',
      caloriesPerDay: calories,
      proteinGrams: protein,
      notes:
          'Promedio de ${_results.length} fórmulas (Harris, Mifflin, Ireton, etc.)',
    );
  }

  double _faisyFagon(
    PatientProfile patient,
    double heartRate,
    double temperatureC,
    double veLmin,
    double paco2,
  ) {
    return 864 -
        (9 * patient.age) +
        (11 * heartRate) +
        (4 * temperatureC) +
        (0.037 * veLmin * 1000) +
        (5 * paco2);
  }

  double _iretonVent(PatientProfile patient, bool trauma, bool burns) {
    final genderFactor = _isMale ? 1 : 0;
    final traumaFactor = trauma ? 1 : 0;
    final burnFactor = burns ? 1 : 0;
    return 1784 -
        (11 * patient.age) +
        (5 * patient.weightKg) +
        (244 * genderFactor) +
        (239 * traumaFactor) +
        (804 * burnFactor);
  }

  double _iretonSpont(PatientProfile patient, bool obese) {
    final obeseFactor = obese ? 1 : 0;
    return 629 -
        (11 * patient.age) +
        (25 * patient.weightKg) -
        (609 * obeseFactor);
  }

  _EnergyResult? _aspenObesityResult(
    PatientProfile patient,
    double? bmi, {
    required double stressFactor,
  }) {
    if (bmi == null || bmi < 30) {
      return null;
    }
    final bool superObese = bmi >= 50;
    final double? referenceWeight = superObese
        ? _idealBodyWeight(
            patient.heightCm,
            maleOverride: patient.sex.toLowerCase().startsWith('m'),
          )
        : patient.weightKg;
    if (referenceWeight == null || referenceWeight <= 0) {
      return null;
    }
    final double lowerMultiplier = superObese ? 22 : 11;
    final double upperMultiplier = superObese ? 25 : 14;
    final double lower = referenceWeight * lowerMultiplier;
    final double upper = referenceWeight * upperMultiplier;
    final average = (lower + upper) / 2;
    final label = superObese
        ? 'ASPEN 2023 (IMC ≥ 50)'
        : 'ASPEN 2023 (IMC 30-49)';
    final kcalLabel =
        '${lower.toStringAsFixed(0)}-${upper.toStringAsFixed(0)} kcal/día '
        '(${superObese ? 'peso ideal' : 'peso actual'})';
    return _EnergyResult(
      label,
      average,
      _proteinGoal(
        referenceWeight,
        bmi: bmi,
        heightCm: patient.heightCm,
        stressFactor: stressFactor,
      ),
      kcalLabel: kcalLabel,
    );
  }

  double? _idealBodyWeight(double? heightCm, {bool? maleOverride}) {
    if (heightCm == null || heightCm <= 0) {
      return null;
    }
    final bool male = maleOverride ?? _isMale;
    final base = male ? 50.0 : 45.5;
    final delta = heightCm - 152.4;
    return base + (0.9 * delta);
  }

  double _proteinGoal(
    double weightKg, {
    double? bmi,
    double? heightCm,
    required double stressFactor,
  }) {
    if (weightKg <= 0) {
      return 0;
    }
    final weightForProtein = _proteinReferenceWeight(
      weightKg: weightKg,
      bmi: bmi,
      heightCm: heightCm,
    );
    final gramsPerKg = _proteinPerKgForStress(stressFactor);
    return weightForProtein * gramsPerKg;
  }

  double _proteinReferenceWeight({
    required double weightKg,
    double? bmi,
    double? heightCm,
  }) {
    return _resolveProteinReference(
      weightKg: weightKg,
      bmi: bmi,
      heightCm: heightCm,
    ).value;
  }

  _ProteinReferenceData _resolveProteinReference({
    required double weightKg,
    double? bmi,
    double? heightCm,
  }) {
    final bmiValue = bmi ?? _currentBmi;
    final height = heightCm ?? double.tryParse(_heightController.text);
    if (bmiValue != null && bmiValue >= 30 && height != null && height > 0) {
      final ideal = _idealBodyWeight(height);
      if (ideal != null) {
        final isSevere = bmiValue >= 40;
        final referenceWeight =
            isSevere ? _adjustedObesityWeight(ideal, weightKg) : ideal;
        final label = isSevere ? 'peso ajustado' : 'peso ideal';
        return _ProteinReferenceData(referenceWeight, label);
      }
    }
    return _ProteinReferenceData(weightKg, 'peso actual');
  }

  double _proteinPerKgForStress(double stressFactor) {
    final stress = stressFactor;
    if (_selectedStress.label.contains('Quemaduras')) {
      return 2.5;
    }
    if (stress <= 1.05) {
      return 1.2;
    } else if (stress <= 1.25) {
      return 1.5;
    } else if (stress <= 1.35) {
      return 2.0;
    }
    return 2.5;
  }

  double _adjustedObesityWeight(double idealWeight, double realWeight) {
    return idealWeight + 0.25 * (realWeight - idealWeight);
  }

  String _proteinNote(double stressFactor) {
    final gramsPerKg = _proteinPerKgForStress(stressFactor);
    final label = _selectedStress.label;
    return 'Proteínas calculadas con $label · ${gramsPerKg.toStringAsFixed(1)} g/kg.';
  }

  Future<void> _saveAndContinue() async {
    await _saveTarget();
    final patientId = widget.initialPatientId ?? _patient?.id;
    if (patientId == null || patientId.isEmpty) {
      return;
    }
    final macros = _macroTargetsOrNull;
    final referenceData = _resolveProteinReference(
      weightKg: double.tryParse(_weightController.text) ?? 0,
      bmi: _currentBmi,
      heightCm: double.tryParse(_heightController.text),
    );
    final lipidPercent =
        _lipidPercent.clamp(_lipidPercentMin, _lipidPercentMax).toDouble();
    final proteinPerKg = _proteinPerKgForStress(_currentStressFactor);
    final macroSnapshot = macros == null
        ? null
        : MacroTargetsSnapshot(
            proteinGrams: macros.proteinGrams,
            lipidGrams: macros.lipidGrams,
            carbohydrateGrams: macros.carbohydrateGrams,
            proteinPercent: macros.proteinPercent,
            lipidPercent: macros.lipidPercent,
            carbohydratePercent: macros.carbohydratePercent,
          );
    final snapshot = EnergyPlanSnapshot(
      requirements: _finalRequirement,
      lipidPercent: lipidPercent,
      proteinPerKg: proteinPerKg,
      referenceWeightLabel: referenceData.label,
      macroTargets: macroSnapshot,
      factorStressLabel: _selectedStress.label,
      triglycerides: _currentTriglycerides,
      formulas: _results
          .map(
            (result) => FormulaBreakdown(
              name: result.label,
              calories: result.kcal,
              proteinGrams: result.protein,
              notes: result.notes ?? result.kcalLabel,
            ),
          )
          .toList(),
      meanCalories: _finalRequirement.caloriesPerDay,
    );
    sl<CareEpisodeCubit>().setEnergyPlan(
      requirements: _finalRequirement,
      lipidPercent: lipidPercent,
      proteinPerKg: proteinPerKg,
      referenceWeightLabel: referenceData.label,
      macros: macroSnapshot,
      stressLabel: _selectedStress.label,
      triglycerides: _currentTriglycerides,
      formulas: snapshot.formulas,
      meanCalories: snapshot.meanCalories,
    );
    await sl<EnergyPlanRepository>().saveSnapshot(
      patientId: patientId,
      snapshot: snapshot,
    );
    setState(() {
      _persistedRequirement = snapshot.requirements;
      _proteinPerKgOverride = proteinPerKg;
    });
    Navigator.of(context).pushNamed(
      AppRouter.energyAdjustment,
      arguments: EnergyAdjustmentPageArgs(
        patientId: patientId,
        patientName: _patientName ?? 'Paciente',
        targetCalories: _finalRequirement.caloriesPerDay,
        targetProtein: _finalRequirement.proteinGrams,
        riskLabel: _riskLabel,
        weightKg: double.tryParse(_weightController.text),
        heightCm: double.tryParse(_heightController.text),
        bmi: _currentBmi,
        diagnosis: _patient?.diagnosis,
        lipidGrams: macros?.lipidGrams,
        carbohydrateGrams: macros?.carbohydrateGrams,
        triglycerides: _currentTriglycerides,
      ),
    );
  }

  _MacroTargets? get _macroTargetsOrNull {
    if (_results.isEmpty) {
      return null;
    }
    final totalCalories = _finalRequirement.caloriesPerDay;
    if (totalCalories <= 0) {
      return null;
    }
    final weight = double.tryParse(_weightController.text) ?? 0;
    final height = double.tryParse(_heightController.text);
    final stress = _currentStressFactor;
    final referenceData = _resolveProteinReference(
      weightKg: weight,
      bmi: _currentBmi,
      heightCm: height,
    );
    final gramsPerKg =
        _proteinPerKgOverride ?? _proteinPerKgForStress(stress);
    final proteinGrams = referenceData.value * gramsPerKg;
    final proteinCalories = proteinGrams * 4;
    final proteinPercent =
        totalCalories > 0 ? ((proteinCalories / totalCalories) * 100).toDouble() : 0.0;

    final lipidPercent =
        _lipidPercent.clamp(_lipidPercentMin, _lipidPercentMax).toDouble();
    final lipidCalories = totalCalories * (lipidPercent / 100);
    final lipidGrams = lipidCalories / 9;

    final rawCarbPercent = 100.0 - proteinPercent - lipidPercent;
    final adjustedCarbPercent = rawCarbPercent.clamp(0.0, 100.0).toDouble();
    final carbCalories = totalCalories * (adjustedCarbPercent / 100);
    final carbGrams = carbCalories / 4;

    final percentSum = proteinPercent + lipidPercent + adjustedCarbPercent;
    final isBalanced = (percentSum - 100).abs() <= 1;
    final carbClamped = rawCarbPercent < 0;

    final trig = _currentTriglycerides;
    final lipidSourceLabel = trig != null
        ? 'Ajustado por TG ${trig.toStringAsFixed(0)} mg/dL'
        : 'Control manual (slider)';

    return _MacroTargets(
      totalCalories: totalCalories,
      proteinGrams: proteinGrams,
      proteinPercent: proteinPercent,
      lipidGrams: lipidGrams,
      lipidPercent: lipidPercent,
      carbohydrateGrams: carbGrams,
      carbohydratePercent: adjustedCarbPercent,
      rawCarbohydratePercent: rawCarbPercent,
      percentSum: percentSum,
      isBalanced: isBalanced,
      carbClamped: carbClamped,
      proteinReferenceLabel: referenceData.label,
      proteinGramsPerKg: gramsPerKg,
      lipidSourceLabel: lipidSourceLabel,
      carbohydrateSourceLabel:
          'Resto hasta 100 % (kcal totales - proteínas - lípidos)',
    );
  }
}

class _EnergyResult {
  _EnergyResult(this.label, this.kcal, this.protein, {this.kcalLabel, this.notes});

  final String label;
  final double kcal;
  final double protein;
  final String? kcalLabel;
  final String? notes;

  String get caloriesLabel =>
      kcalLabel ?? '${kcal.toStringAsFixed(0)} kcal/día';

  String get proteinLabel => '${protein.toStringAsFixed(1)} g proteína';
}

class _MacroTargets {
  const _MacroTargets({
    required this.totalCalories,
    required this.proteinGrams,
    required this.proteinPercent,
    required this.lipidGrams,
    required this.lipidPercent,
    required this.carbohydrateGrams,
    required this.carbohydratePercent,
    required this.rawCarbohydratePercent,
    required this.percentSum,
    required this.isBalanced,
    required this.carbClamped,
    required this.proteinReferenceLabel,
    required this.proteinGramsPerKg,
    required this.lipidSourceLabel,
    required this.carbohydrateSourceLabel,
  });

  final double totalCalories;
  final double proteinGrams;
  final double proteinPercent;
  final double lipidGrams;
  final double lipidPercent;
  final double carbohydrateGrams;
  final double carbohydratePercent;
  final double rawCarbohydratePercent;
  final double percentSum;
  final bool isBalanced;
  final bool carbClamped;
  final String proteinReferenceLabel;
  final double proteinGramsPerKg;
  final String lipidSourceLabel;
  final String carbohydrateSourceLabel;
}

class _MacroBreakdownCard extends StatelessWidget {
  const _MacroBreakdownCard({required this.targets});

  final _MacroTargets targets;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Distribución diaria',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            _MacroRow(
              label: 'Proteínas',
              grams: targets.proteinGrams,
              percent: targets.proteinPercent,
              kcalPerGram: 4,
            ),
            const SizedBox(height: 8),
            _MacroRow(
              label: 'Carbohidratos',
              grams: targets.carbohydrateGrams,
              percent: targets.carbohydratePercent,
              kcalPerGram: 4,
              highlight: targets.carbClamped,
            ),
            const SizedBox(height: 8),
            _MacroRow(
              label: 'Lípidos',
              grams: targets.lipidGrams,
              percent: targets.lipidPercent,
              kcalPerGram: 9,
            ),
            const SizedBox(height: 12),
            Text(
              'Suma actual: ${targets.percentSum.toStringAsFixed(1)} %. '
              'Los % deben completar 100 % de ${targets.totalCalories.toStringAsFixed(0)} kcal.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            if (!targets.isBalanced || targets.carbClamped) ...[
              const SizedBox(height: 4),
              Text(
                targets.carbClamped
                    ? 'Proteínas + lípidos exceden el 100 %. Reduce el factor proteico o el % de lípidos.'
                    : 'Ajusta los parámetros hasta equilibrar los porcentajes.',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Theme.of(context).colorScheme.error),
              ),
            ],
            const SizedBox(height: 4),
            Text(
              'Proteínas: ${targets.proteinGramsPerKg.toStringAsFixed(1)} g/kg sobre ${targets.proteinReferenceLabel}.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              'Lípidos: ${targets.lipidPercent.toStringAsFixed(0)} % · ${targets.lipidSourceLabel}.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              'Carbohidratos: ${targets.carbohydrateSourceLabel}.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 4),
            Text(
              'Solicita triglicéridos y PFH antes de modificar la carga lipídica.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _MacroRow extends StatelessWidget {
  const _MacroRow({
    required this.label,
    required this.grams,
    required this.percent,
    required this.kcalPerGram,
    this.highlight = false,
  });

  final String label;
  final double grams;
  final double percent;
  final double kcalPerGram;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final percentText = '${percent.clamp(0, 100).toStringAsFixed(1)} %';
    final gramsText = grams <= 0 ? '0 g' : '${grams.toStringAsFixed(1)} g';
    final kcal = grams * kcalPerGram;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: highlight ? theme.colorScheme.error : null,
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              gramsText,
              style: theme.textTheme.titleMedium?.copyWith(
                color: highlight ? theme.colorScheme.error : null,
              ),
            ),
            Text(
              '$percentText · ${kcal.toStringAsFixed(0)} kcal',
              style: theme.textTheme.bodySmall?.copyWith(
                color: highlight ? theme.colorScheme.error : null,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ProteinReferenceData {
  const _ProteinReferenceData(this.value, this.label);

  final double value;
  final String label;
}
