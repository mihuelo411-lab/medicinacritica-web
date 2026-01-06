
import 'package:flutter/material.dart';
import 'package:nutrivigil/core/di/dependencies.dart';
import 'package:nutrivigil/core/routes/app_router.dart';
import 'package:nutrivigil/domain/care_episode/care_episode_cubit.dart';
import 'package:nutrivigil/domain/nutrition/products/enteral_product.dart';
import 'package:nutrivigil/domain/nutrition/products/formula_selection.dart';
import 'package:nutrivigil/domain/nutrition/services/formula_service.dart';

class FormulaSelectorPageArgs {
  const FormulaSelectorPageArgs({
    required this.patientName,
    required this.targetCalories,
    required this.targetProtein,
    this.isDiabetic = false,
    this.isRenal = false,
    this.fluidRestriction = false,
  });

  final String patientName;
  final double targetCalories;
  final double targetProtein;
  final bool isDiabetic;
  final bool isRenal;
  final bool fluidRestriction;
}

class FormulaSelectorPage extends StatefulWidget {
  const FormulaSelectorPage({super.key, required this.args});

  final FormulaSelectorPageArgs args;

  @override
  State<FormulaSelectorPage> createState() => _FormulaSelectorPageState();
}

class _FormulaSelectorPageState extends State<FormulaSelectorPage> {
  // Filters
  late bool _filterDiabetes;
  late bool _filterRenal;
  late bool _filterHighProt;
  late bool _filterFluid;

  // Selection
  EnteralProduct? _selectedProduct;
  ProteinModule? _selectedModule;
  InfusionMode _infusionMode = InfusionMode.continuous;
  
  // Settings
  double _startPercent = 50; // Default Day 1
  int _cyclicHours = 16;
  
  // Service
  FormulaService get _service => sl<FormulaService>();
  final CareEpisodeCubit _cubit = sl<CareEpisodeCubit>();

  @override
  void initState() {
    super.initState();
    _filterDiabetes = widget.args.isDiabetic;
    _filterRenal = widget.args.isRenal;
    _filterFluid = widget.args.fluidRestriction;
    _filterHighProt = false;
    
    _loadRecommendations();
  }

  void _loadRecommendations() {
    final recs = _service.getRecommendations(
      isDiabetic: _filterDiabetes,
      isRenal: _filterRenal,
      fluidRestriction: _filterFluid,
      highProteinAndCalorie: _filterHighProt,
    );
    if (recs.isNotEmpty && _selectedProduct == null) {
      _selectedProduct = recs.first;
    } else if (recs.isNotEmpty && !recs.contains(_selectedProduct)) {
        // Keep selection if valid, else pick first
         _selectedProduct = recs.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Re-calculate recommendations on every build to react to chips
    final recommendations = _service.getRecommendations(
      isDiabetic: _filterDiabetes,
      isRenal: _filterRenal,
      fluidRestriction: _filterFluid,
      highProteinAndCalorie: _filterHighProt,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Prescripción de Fórmula'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFilterSection(),
              const SizedBox(height: 16),
              _buildProductSelector(recommendations),
              const SizedBox(height: 24),
              // Main Logic Display
              if (_selectedProduct != null) ...[
                 _buildDualGoalSection(),
                 const SizedBox(height: 16),
                 _buildInfusionSettings(),
                 const SizedBox(height: 16),
                 _buildProteinModuleSection(),
                 const SizedBox(height: 24),
                 _buildActionButtons(),
              ] else 
                 const Center(child: Text('Selecciona un producto para ver el cálculo')),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Filtros Clínicos (Vademécum)', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            FilterChip(
              label: const Text('Diabetes/Glucemia'),
              selected: _filterDiabetes,
              onSelected: (v) => setState(() { _filterDiabetes = v; _loadRecommendations(); }),
            ),
             FilterChip(
              label: const Text('Renal'),
              selected: _filterRenal,
              onSelected: (v) => setState(() { _filterRenal = v; _loadRecommendations(); }),
            ),
             FilterChip(
              label: const Text('Restricción Hídrica'),
              selected: _filterFluid,
              onSelected: (v) => setState(() { _filterFluid = v; _loadRecommendations(); }),
            ),
             FilterChip(
              label: const Text('Alta Proteína'),
              selected: _filterHighProt,
              onSelected: (v) => setState(() { _filterHighProt = v; _loadRecommendations(); }),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProductSelector(List<EnteralProduct> options) {
    return DropdownButtonFormField<EnteralProduct>(
      value: options.contains(_selectedProduct) ? _selectedProduct : null,
      decoration: const InputDecoration(
        labelText: 'Producto Seleccionado',
        border: OutlineInputBorder(),
        helperText: 'Basado en los filtros activos',
      ),
      isExpanded: true,
      items: options.map((p) => DropdownMenuItem(
        value: p,
        child: Text('${p.nameDisplay} [${p.densityLabel}, ${p.proteinGramsPerLiter}g P/L]'),
      )).toList(),
      onChanged: (v) => setState(() => _selectedProduct = v),
    );
  }

  Widget _buildDualGoalSection() {
    if (_selectedProduct == null) return const SizedBox.shrink();

    // Calculate GOAL (100%)
    final goalPrescription = _service.calculatePrescription(
      product: _selectedProduct!,
      targetCalories: widget.args.targetCalories,
      targetProtein: widget.args.targetProtein,
      mode: _infusionMode, // Layout depends on mode, but values are totals
      hoursDuration: _infusionMode == InfusionMode.cyclic ? _cyclicHours : 24,
      selectedModule: _selectedModule,
    );

    // Calculate START (Percent)
    final startCalories = widget.args.targetCalories * (_startPercent / 100);
    // Note: Day 1 usually doesn't include modules, but logic dictates
    // simply scaling calculation is often safer. 
    // Let's scale pure formula volume.
    final startVolume = goalPrescription.totalVolumeMl * (_startPercent / 100);
    
    // Bottles
    final bottlesGoal = goalPrescription.bottlesPerDay;
    final bottlesStart = bottlesGoal * (_startPercent / 100);

    return Column(
      children: [
        Row(
          children: [
             Expanded(
               child: _InfoCard(
                 title: 'Meta (100%)',
                 color: Colors.blue.shade50,
                 volume: goalPrescription.totalVolumeMl,
                 bottles: bottlesGoal,
                 calories: goalPrescription.providedCalories,
                 infusionLabel: goalPrescription.infusionLabel,
               ),
             ),
             const SizedBox(width: 8),
             Expanded(
               child: _InfoCard(
                 title: 'Inicio (${_startPercent.toInt()}%)',
                 color: Colors.green.shade50,
                 volume: startVolume,
                 bottles: bottlesStart,
                 calories: startCalories,
                 // Simple Rate scaling
                 infusionLabel: _getScaledInfusionLabel(goalPrescription, _startPercent / 100),
                 isStart: true,
               ),
             ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Text('Ajuste Día 1: '),
            Expanded(
              child: Slider(
                value: _startPercent,
                min: 25,
                max: 100,
                divisions: 3, // 25, 50, 75, 100
                label: '${_startPercent.toInt()}%',
                onChanged: (v) => setState(() => _startPercent = v),
              ),
            ),
            Text('${_startPercent.toInt()}%'),
          ],
        ),
      ],
    );
  }
  
  String _getScaledInfusionLabel(FormulaSelection goal, double factor) {
     if (goal.infusionMode == InfusionMode.bolus) {
       final vol = goal.bolusVolume * factor;
       return '${vol.toStringAsFixed(0)} ml / toma';
     } else {
       final rate = goal.mlPerHour * factor;
       return '${rate.toStringAsFixed(0)} ml/h';
     }
  }

  Widget _buildInfusionSettings() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            const Text('Modo de Infusión', style: TextStyle(fontWeight: FontWeight.w600)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _ModeButton(
                  mode: InfusionMode.continuous,
                  current: _infusionMode,
                  label: 'Continua (24h)',
                  onTap: () => setState(() => _infusionMode = InfusionMode.continuous),
                ),
                 _ModeButton(
                  mode: InfusionMode.cyclic,
                  current: _infusionMode,
                  label: 'Cíclica',
                  onTap: () => setState(() => _infusionMode = InfusionMode.cyclic),
                ),
                 _ModeButton(
                  mode: InfusionMode.bolus,
                  current: _infusionMode,
                  label: 'Bolos',
                  onTap: () => setState(() => _infusionMode = InfusionMode.bolus),
                ),
              ],
            ),
            if (_infusionMode == InfusionMode.cyclic)
               Padding(
                 padding: const EdgeInsets.only(top: 8),
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     const Text('Horas de infusión: '),
                     DropdownButton<int>(
                       value: _cyclicHours,
                       items: [12, 14, 16, 18, 20].map((h) => DropdownMenuItem(value: h, child: Text('${h}h'))).toList(),
                       onChanged: (v) => setState(() => _cyclicHours = v!),
                     )
                   ],
                 ),
               ),
          ],
        ),
      ),
    );
  }

  Widget _buildProteinModuleSection() {
    if (_selectedProduct == null) return const SizedBox.shrink();
    
    // Calculate deficit PURELY based on formula (Goal volume)
    final volL = (widget.args.targetCalories / _selectedProduct!.kcalPerMl) / 1000;
    final formulaProtein = volL * _selectedProduct!.proteinGramsPerLiter;
    final deficit = widget.args.targetProtein - formulaProtein;
    
    final hasDeficit = deficit > 2; // Tolerance
    Color color = hasDeficit ? Colors.orange.shade100 : Colors.green.shade100;
    
    return Card(
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              hasDeficit 
                ? 'Déficit Proteico: ${deficit.toStringAsFixed(1)} g'
                : 'Meta Proteica Cubierta con Fórmula',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: hasDeficit ? Colors.orange.shade900 : Colors.green.shade900,
              ),
            ),
            if (hasDeficit) ...[
               const SizedBox(height: 12),
               const Text('Selecciona Módulo para complementar:'),
               DropdownButton<ProteinModule>(
                 value: _selectedModule,
                 hint: const Text('Ninguno'),
                 isExpanded: true,
                 items: [
                   const DropdownMenuItem(value: null, child: Text('Sin módulo (Aceptar déficit)')),
                   ...ProductDatabase.modules.map((m) => DropdownMenuItem(
                     value: m,
                     child: Text('${m.name} (${m.proteinPerDose}g / ${m.doseLabel})'),
                   )),
                 ],
                 onChanged: (v) => setState(() => _selectedModule = v),
               ),
               if (_selectedModule != null) ...[
                 const SizedBox(height: 8),
                 // Calculate Doses
                 Builder(builder: (_) {
                   final doses = (deficit / _selectedModule!.proteinPerDose).ceil();
                   return Text(
                     'Sugerencia: Añadir $doses ${_selectedModule!.doseLabel}s al día '
                     '(+${(doses * _selectedModule!.proteinPerDose).toStringAsFixed(0)} g).',
                     style: const TextStyle(fontWeight: FontWeight.bold),
                   );
                 }),
               ]
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        icon: const Icon(Icons.picture_as_pdf),
        label: const Text('Generar PDF con Prescripción'),
        onPressed: () {
          if (_selectedProduct == null) return;
          
          final selection = _service.calculatePrescription(
            product: _selectedProduct!, 
            targetCalories: widget.args.targetCalories, 
            targetProtein: widget.args.targetProtein, 
            mode: _infusionMode, 
            hoursDuration: _infusionMode == InfusionMode.cyclic ? _cyclicHours : 24,
            selectedModule: _selectedModule,
          );
          
          _cubit.setPrescription(selection);
          
          Navigator.of(context).pushNamed(AppRouter.evaluationSummary);
        },
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.title,
    required this.color,
    required this.volume,
    required this.bottles,
    required this.calories,
    required this.infusionLabel,
    this.isStart = false,
  });
  
  final String title;
  final Color color;
  final double volume;
  final double bottles;
  final double calories;
  final String infusionLabel;
  final bool isStart;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const Divider(),
          Text('${volume.toStringAsFixed(0)} ml', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text('~${bottles.toStringAsFixed(1)} botellas', style: const TextStyle(fontSize: 12)),
          const SizedBox(height: 8),
          Container(
             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
             decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
             child: Text(infusionLabel, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
          ),
          const SizedBox(height: 4),
          Text('${calories.toStringAsFixed(0)} kcal', style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  const _ModeButton({required this.mode, required this.current, required this.label, required this.onTap});
  final InfusionMode mode;
  final InfusionMode current;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final selected = mode == current;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? Theme.of(context).primaryColor : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(color: selected ? Colors.white : Colors.black),
        ),
      ),
    );
  }
}
