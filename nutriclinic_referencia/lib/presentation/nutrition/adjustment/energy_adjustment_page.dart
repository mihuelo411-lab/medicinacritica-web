import 'package:flutter/material.dart';

import 'package:nutrivigil/core/di/dependencies.dart';
import 'package:nutrivigil/core/routes/app_router.dart';
import 'package:nutrivigil/domain/nutrition/services/energy_adjustment_service.dart';
import 'package:nutrivigil/domain/care_episode/care_episode_cubit.dart';
import 'package:nutrivigil/presentation/nutrition/product_selector/formula_selector_page.dart';

class EnergyAdjustmentPageArgs {
  const EnergyAdjustmentPageArgs({
    required this.patientId,
    required this.patientName,
    required this.targetCalories,
    required this.targetProtein,
    this.riskLabel,
    this.weightKg,
    this.heightCm,
    this.bmi,
    this.diagnosis,
    this.lipidGrams,
    this.carbohydrateGrams,
    this.triglycerides,
  });

  final String patientId;
  final String patientName;
  final double targetCalories;
  final double targetProtein;
  final String? riskLabel;
  final double? weightKg;
  final double? heightCm;
  final double? bmi;
  final String? diagnosis;
  final double? lipidGrams;
  final double? carbohydrateGrams;
  final double? triglycerides;
}

class EnergyAdjustmentPage extends StatefulWidget {
  const EnergyAdjustmentPage({super.key, required this.args});

  final EnergyAdjustmentPageArgs args;

  @override
  State<EnergyAdjustmentPage> createState() => _EnergyAdjustmentPageState();
}

class _EnergyAdjustmentPageState extends State<EnergyAdjustmentPage> {
  final _intakeCaloriesController = TextEditingController();
  final _intakeProteinController = TextEditingController();
  final _residualController = TextEditingController();
  final _balanceController = TextEditingController();
  final _diuresisController = TextEditingController();
  final _lactateController = TextEditingController();
  final _triglyceridesController = TextEditingController();
  final _propofolController = TextEditingController(); // New

  NutritionRoute _route = NutritionRoute.enteral;
  VasopressorLevel _vasopressorLevel = VasopressorLevel.none;
  VentilationMode _ventilationMode = VentilationMode.none;
  double? _manualTriglycerides;
  bool _hasShownTriglycerideWarning = false;

  bool _hasVomiting = false;
  bool _hasDistension = false;
  bool _hasDiarrhea = false;
  bool _hasAbdominalPain = false;
  bool _hyperglycemia = false;
  bool _isRecentAdmission = false; 
  bool _isRenalFailure = false; // New

  EnergyAdjustmentResult? _result;

  EnergyAdjustmentService get _service => sl<EnergyAdjustmentService>();
  CareEpisodeCubit get _episodeCubit => sl<CareEpisodeCubit>();

  @override
  void initState() {
    super.initState();
    if (widget.args.triglycerides != null) {
      _manualTriglycerides = widget.args.triglycerides;
      _triglyceridesController.text =
          widget.args.triglycerides!.toStringAsFixed(0);
      _applyTriglycerideRule();
    }
    // Auto-detect renal from diagnosis
    if (widget.args.diagnosis != null && 
        widget.args.diagnosis!.toLowerCase().contains('renal')) {
      _isRenalFailure = true;
    }
  }

  @override
  void dispose() {
    _intakeCaloriesController.dispose();
    _intakeProteinController.dispose();
    _residualController.dispose();
    _balanceController.dispose();
    _diuresisController.dispose();
    _lactateController.dispose();
    _triglyceridesController.dispose();
    _propofolController.dispose(); // New
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final targetCalories = widget.args.targetCalories;
    final targetProtein = widget.args.targetProtein;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajuste práctico'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TargetCard(
                patientName: widget.args.patientName,
                calories: targetCalories,
                protein: targetProtein,
                riskLabel: widget.args.riskLabel,
                weightKg: widget.args.weightKg,
                heightCm: widget.args.heightCm,
                bmi: widget.args.bmi,
                diagnosis: widget.args.diagnosis,
                lipidGrams: widget.args.lipidGrams,
                carbohydrateGrams: widget.args.carbohydrateGrams,
              ),
              const SizedBox(height: 16),
              _buildIntakeSection(),
              const SizedBox(height: 16),
              _buildToleranceSection(),
              const SizedBox(height: 16),
              _buildSupportSection(),
              const SizedBox(height: 16),
              _buildLabsSection(),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () => _calculate(context),
                icon: const Icon(Icons.auto_graph),
                label: const Text('Calcular recomendación'),
              ),
              const SizedBox(height: 16),
              if (_result != null) ...[
                _AdjustmentResultCard(
                  result: _result!,
                  targetCalories: targetCalories,
                  targetProtein: targetProtein,
                ),
                const SizedBox(height: 16),
                _buildFinalAdjustmentControls(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIntakeSection() {
    final isNewAdmission = _intakeCaloriesController.text.isEmpty &&
        _intakeProteinController.text.isEmpty;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Aporte previo',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Checkbox(
                  value: _isRecentAdmission,
                  onChanged: (value) {
                    setState(() {
                      _isRecentAdmission = value ?? false;
                      if (_isRecentAdmission) {
                        _intakeCaloriesController.clear();
                        _intakeProteinController.clear();
                      }
                    });
                  },
                ),
                const Text('Ingreso <24h'),
              ],
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _intakeCaloriesController,
              enabled: !_isRecentAdmission,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Ingesta calórica (kcal)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _intakeProteinController,
              enabled: !_isRecentAdmission,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Ingesta proteica (g)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<NutritionRoute>(
              value: _route,
              decoration: const InputDecoration(
                labelText: 'Ruta actual',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: NutritionRoute.enteral,
                  child: Text('Enteral'),
                ),
                DropdownMenuItem(
                  value: NutritionRoute.parenteral,
                  child: Text('Parenteral'),
                ),
                DropdownMenuItem(
                  value: NutritionRoute.mixed,
                  child: Text('Mixta'),
                ),
                DropdownMenuItem(
                  value: NutritionRoute.fasting,
                  child: Text('Ayuno / sin aporte'),
                ),
              ],
              onChanged: (value) {
                if (value == null) return;
                setState(() => _route = value);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToleranceSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tolerancia digestiva',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _residualController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Residuo gástrico (ml)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                _SymptomChip(
                  label: 'Vómito',
                  value: _hasVomiting,
                  onChanged: (value) =>
                      setState(() => _hasVomiting = value ?? false),
                ),
                _SymptomChip(
                  label: 'Distensión',
                  value: _hasDistension,
                  onChanged: (value) =>
                      setState(() => _hasDistension = value ?? false),
                ),
                _SymptomChip(
                  label: 'Diarrea',
                  value: _hasDiarrhea,
                  onChanged: (value) =>
                      setState(() => _hasDiarrhea = value ?? false),
                ),
                _SymptomChip(
                  label: 'Dolor abdominal',
                  value: _hasAbdominalPain,
                  onChanged: (value) =>
                      setState(() => _hasAbdominalPain = value ?? false),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Soporte y contraindicaciones',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<VasopressorLevel>(
              value: _vasopressorLevel,
              decoration: const InputDecoration(
                labelText: 'Vasopresores',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: VasopressorLevel.none,
                  child: Text('Sin vasopresores'),
                ),
                DropdownMenuItem(
                  value: VasopressorLevel.low,
                  child: Text('Baja dosis (<0.1 µg/kg/min)'),
                ),
                DropdownMenuItem(
                  value: VasopressorLevel.high,
                  child: Text('Alta dosis (≥0.1 µg/kg/min)'),
                ),
              ],
              onChanged: (value) {
                if (value == null) return;
                setState(() => _vasopressorLevel = value);
              },
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              title: const Text('Falla Renal (Aguda/Crónica)'),
              subtitle: const Text('Activa restricción proteica y fórmulas especializadas'),
              value: _isRenalFailure,
              onChanged: (val) => setState(() => _isRenalFailure = val),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<VentilationMode>(
              value: _ventilationMode,
              decoration: const InputDecoration(
                labelText: 'Soporte respiratorio',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: VentilationMode.none,
                  child: Text('Sin soporte'),
                ),
                DropdownMenuItem(
                  value: VentilationMode.nonInvasive,
                  child: Text('No invasivo'),
                ),
                DropdownMenuItem(
                  value: VentilationMode.invasive,
                  child: Text('Ventilación invasiva'),
                ),
                DropdownMenuItem(
                  value: VentilationMode.ecmo,
                  child: Text('ECMO'),
                ),
              ],
              onChanged: (value) {
                if (value == null) return;
                setState(() => _ventilationMode = value);
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _balanceController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Balance hídrico (ml)',
                helperText: 'Acepta valores positivos (+) o negativos (-).',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _diuresisController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Diuresis (ml/kg/h)',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Laboratorios y metabolismo',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _propofolController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Propofol (ml/h)',
                helperText: 'Se descontará energía lipídica (1.1 kcal/ml)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _lactateController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Lactato (mmol/L)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            if (widget.args.triglycerides == null) ...[
              TextFormField(
                controller: _triglyceridesController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Triglicéridos (mg/dL)',
                  border: OutlineInputBorder(),
                  helperText: 'Solicita TG antes de la próxima evaluación',
                ),
                onChanged: _onTriglyceridesChanged,
              ),
              const SizedBox(height: 12),
            ] else ...[
              ListTile(
                leading: const Icon(Icons.water_drop_outlined),
                title: Text(
                  'Triglicéridos recientes: ${widget.args.triglycerides!.toStringAsFixed(0)} mg/dL',
                ),
                subtitle: const Text(
                  'Dato heredado, solicitar nuevo control sólo si cambia la condición.',
                ),
              ),
            ],
            SwitchListTile(
              title: const Text('Hiperglucemia reciente (>180 mg/dL)'),
              value: _hyperglycemia,
              onChanged: (value) => setState(() => _hyperglycemia = value),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinalAdjustmentControls() {
    if (_result == null) {
      return const SizedBox.shrink();
    }
    final percent = _result!.recommendedPercent.toDouble();
    final calories = _result!.adjustedCalories;
    final protein = _result!.adjustedProtein;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recomendación aplicada',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              '${percent.toStringAsFixed(0)} % del objetivo → '
              '${calories.toStringAsFixed(0)} kcal · ${protein.toStringAsFixed(1)} g',
            ),
            if (_result?.level == AdjustmentLevel.trophic &&
                _result?.trophicRateLabel != null) ...[
              const SizedBox(height: 8),
              Text(
                'Sugerencia trófica: ${_result!.trophicRateLabel}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
            const SizedBox(height: 8),
            FilledButton.icon(
              onPressed: () => _finalize(context, percent),
              icon: const Icon(Icons.check_circle_outline),
              label: const Text('Finalizar y ver resumen'),
            ),
          ],
        ),
      ),
    );
  }

  void _calculate(BuildContext context) {
    final input = EnergyAdjustmentInput(
      targetCalories: widget.args.targetCalories,
      targetProtein: widget.args.targetProtein,
      intakeCalories: _parseDouble(_intakeCaloriesController.text) ?? 0,
      intakeProtein: _parseDouble(_intakeProteinController.text) ?? 0,
      route: _route,
      hasVomiting: _hasVomiting,
      hasDistension: _hasDistension,
      hasDiarrhea: _hasDiarrhea,
      hasAbdominalPain: _hasAbdominalPain,
      residualVolume: _parseDouble(_residualController.text),
      vasopressorLevel: _vasopressorLevel,
      hasEcmo: _ventilationMode == VentilationMode.ecmo,
      ventilationMode: _ventilationMode,
      balanceMl: _parseDouble(_balanceController.text),
      diuresisMlKgH: _parseDouble(_diuresisController.text),
      lactate: _parseDouble(_lactateController.text),
      triglycerides: _parseDouble(_triglyceridesController.text),
      hyperglycemia: _hyperglycemia,
      propofolMlH: _parseDouble(_propofolController.text) ?? 0,
      currentBmi: widget.args.bmi,
      isRenalFailure: _isRenalFailure,
      comment: null,
    );

    final result = _service.evaluate(input);
    setState(() => _result = result);
    
    // Check for NPT suggestion
    if (result.suggestedRoute == NutritionRoute.parenteral && 
        _route != NutritionRoute.parenteral) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Sugerencia Clínica: NPT'),
          content: const Text(
            'El algoritmo ha detectado criterios de fallo intestinal o inestabilidad severa.\n\n'
            'Se recomienda cambiar a Nutrición Parenteral Total (NPT).\n'
            '¿Desea cambiar la ruta de administración ahora?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Mantener Enteral'),
            ),
            FilledButton(
              onPressed: () {
                setState(() => _route = NutritionRoute.parenteral);
                Navigator.pop(context);
                // Re-calculate or just let finalize handle it?
                // Ideally re-run evaluate to update notes if needed, but route change is enough for _finalize logic.
              },
              child: const Text('Cambiar a NPT'),
            ),
          ],
        ),
      );
    }
  }

  void _finalize(BuildContext context, double percent) {
    final result = _result;
    if (result == null) {
      return;
    }
    
    // Convert enum to string for storage
    final routeStr = _route.name; 
    
    _episodeCubit.setAdjustment(
      result: result,
      appliedPercent: percent,
      notes: null,
      route: routeStr,
    );

    // If Parenteral, skip Formula Selector and go to Summary
    if (_route == NutritionRoute.parenteral) {
      // Clear any previous prescription in case of re-edit
      // We might need a way to clear prescription in Cubit, but for now just navigating away relies on the Report logic checking the adjustment route.
      Navigator.of(context).pushNamed(AppRouter.evaluationSummary);
      return;
    }
    
    Navigator.of(context).pushNamed(
      AppRouter.formulaSelector,
      arguments: FormulaSelectorPageArgs(
        patientName: widget.args.patientName,
        targetCalories: result.adjustedCalories,
        targetProtein: result.adjustedProtein,
        isDiabetic: _hyperglycemia,
        isRenal: _isRenalFailure,
      ),
    );
  }

  void _onTriglyceridesChanged(String value) {
    final parsed = _parseDouble(value);
    setState(() {
      _manualTriglycerides = parsed;
      if (parsed == null || parsed < 400) {
        _hasShownTriglycerideWarning = false;
      }
    });
    _applyTriglycerideRule();
  }

  void _applyTriglycerideRule() {
    final trig = _manualTriglycerides ?? widget.args.triglycerides;
    if (trig == null) {
      return;
    }
    if (trig >= 400) {
      if (_hasShownTriglycerideWarning) {
        return;
      }
      _hasShownTriglycerideWarning = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Triglicéridos ≥400 mg/dL: limita lípidos y verifica tolerancia antes de subir aporte.',
            ),
          ),
        );
      });
    } else {
      _hasShownTriglycerideWarning = false;
    }
  }

  double? _parseDouble(String value) {
    if (value.trim().isEmpty) {
      return null;
    }
    return double.tryParse(value.replaceAll(',', '.'));
  }
}

class _TargetCard extends StatelessWidget {
  const _TargetCard({
    required this.patientName,
    required this.calories,
    required this.protein,
    this.riskLabel,
    this.weightKg,
    this.heightCm,
    this.bmi,
    this.diagnosis,
    this.lipidGrams,
    this.carbohydrateGrams,
  });

  final String patientName;
  final double calories;
  final double protein;
  final String? riskLabel;
  final double? weightKg;
  final double? heightCm;
  final double? bmi;
  final String? diagnosis;
  final double? lipidGrams;
  final double? carbohydrateGrams;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.flag_circle_outlined),
        title: Text(patientName),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${calories.toStringAsFixed(0)} kcal · ${protein.toStringAsFixed(1)} g proteína',
            ),
            if (weightKg != null || heightCm != null || bmi != null)
              Text(
                [
                  if (weightKg != null) '${weightKg!.toStringAsFixed(1)} kg',
                  if (heightCm != null) '${heightCm!.toStringAsFixed(0)} cm',
                  if (bmi != null) 'IMC ${bmi!.toStringAsFixed(1)}',
                ].join(' · '),
              ),
            if (diagnosis != null && diagnosis!.isNotEmpty)
              Text('Dx principal: $diagnosis'),
            if (lipidGrams != null || carbohydrateGrams != null)
              Text(
                [
                  if (lipidGrams != null)
                    'Lípidos: ${lipidGrams!.toStringAsFixed(1)} g',
                  if (carbohydrateGrams != null)
                    'Carbohidratos: ${carbohydrateGrams!.toStringAsFixed(1)} g',
                ].join(' · '),
              ),
            if (riskLabel != null) Text('Riesgo: $riskLabel'),
          ],
        ),
      ),
    );
  }
}

class _AdjustmentResultCard extends StatelessWidget {
  const _AdjustmentResultCard({
    required this.result,
    required this.targetCalories,
    required this.targetProtein,
  });

  final EnergyAdjustmentResult result;
  final double targetCalories;
  final double targetProtein;

  String get _levelLabel {
    switch (result.level) {
      case AdjustmentLevel.trophic:
        return 'Dieta trófica';
      case AdjustmentLevel.hypocaloric:
        return 'Hipocalórica progresiva';
      case AdjustmentLevel.full:
        return 'Meta completa';
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final kcal = result.adjustedCalories.toStringAsFixed(0);
    final protein = result.adjustedProtein.toStringAsFixed(1);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _levelLabel,
              style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              '${result.recommendedPercent}% del objetivo → $kcal kcal · $protein g',
              style: textTheme.bodyMedium,
            ),
            if (result.trophicRateLabel != null) ...[
              const SizedBox(height: 4),
              Text(
                'Sugerencia: ${result.trophicRateLabel}',
                style: textTheme.bodySmall,
              ),
            ],
            const SizedBox(height: 8),
            for (final note in result.notes)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  '• $note',
                  style: textTheme.bodySmall,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SymptomChip extends StatelessWidget {
  const _SymptomChip({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: value,
      onSelected: onChanged,
    );
  }
}
