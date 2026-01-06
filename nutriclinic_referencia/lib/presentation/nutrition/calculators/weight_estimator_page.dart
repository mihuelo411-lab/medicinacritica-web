import 'package:flutter/material.dart';

import 'package:nutrivigil/domain/patient/calculators/weight_estimator.dart';

class WeightEstimatorPage extends StatefulWidget {
  const WeightEstimatorPage({
    super.key,
    this.patientName,
    this.initialHeightCm,
    this.initialWeightKg,
    this.initialIsMale,
  });

  final String? patientName;
  final double? initialHeightCm;
  final double? initialWeightKg;
  final bool? initialIsMale;

  @override
  State<WeightEstimatorPage> createState() => _WeightEstimatorPageState();
}

class _WeightEstimatorPageState extends State<WeightEstimatorPage> {
  final _formKey = GlobalKey<FormState>();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  bool _isMale = true;
  double? _idealWeight;
  double? _adjustedWeight;
  double? _bmi;

  final _estimator = const WeightEstimator();

  @override
  void initState() {
    super.initState();
    _isMale = widget.initialIsMale ?? true;
    if (widget.initialHeightCm != null && widget.initialHeightCm! > 0) {
      _heightController.text = widget.initialHeightCm!.toStringAsFixed(1);
    }
    if (widget.initialWeightKg != null && widget.initialWeightKg! > 0) {
      _weightController.text = widget.initialWeightKg!.toStringAsFixed(1);
    }
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Estimador de peso')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              if (widget.patientName != null) ...[
                Text(
                  'Paciente: ${widget.patientName}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
              ],
              SwitchListTile(
                title: Text(_isMale ? 'Sexo: masculino' : 'Sexo: femenino'),
                value: _isMale,
                onChanged: (value) => setState(() => _isMale = value),
              ),
              TextFormField(
                controller: _heightController,
                decoration: const InputDecoration(labelText: 'Talla (cm)'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: _numericValidator,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _weightController,
                decoration: const InputDecoration(labelText: 'Peso actual (kg)'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: _numericValidator,
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _calculate,
                icon: const Icon(Icons.calculate),
                label: const Text('Calcular'),
              ),
              const SizedBox(height: 24),
              if (_idealWeight != null) ...[
                Text('Peso ideal: ${_idealWeight!.toStringAsFixed(1)} kg'),
                const SizedBox(height: 8),
              ],
              if (_adjustedWeight != null)
                Text('Peso ajustado: ${_adjustedWeight!.toStringAsFixed(1)} kg'),
              const SizedBox(height: 8),
              if (_bmi != null)
                Text('IMC: ${_bmi!.toStringAsFixed(1)} kg/m²'),
            ],
          ),
        ),
      ),
    );
  }

  String? _numericValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Requerido';
    }
    return double.tryParse(value) == null ? 'Valor inválido' : null;
  }

  void _calculate() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final height = double.parse(_heightController.text);
    final weight = double.parse(_weightController.text);
    final ideal = _estimator.idealBodyWeightKg(heightCm: height, isMale: _isMale);
    final adjusted = _estimator.adjustedBodyWeightKg(actualWeightKg: weight, idealWeightKg: ideal);
    final bmi = _estimator.bmiKgM2(weightKg: weight, heightCm: height);
    setState(() {
      _idealWeight = ideal;
      _adjustedWeight = adjusted;
      _bmi = bmi;
    });
  }
}
