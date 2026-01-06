import 'package:flutter/material.dart';

import 'score_capture_result.dart';

class ApacheCalculatorPage extends StatefulWidget {
  const ApacheCalculatorPage({
    super.key,
    this.initialScore,
    this.initialDetails,
  });

  final double? initialScore;
  final Map<String, dynamic>? initialDetails;

  @override
  State<ApacheCalculatorPage> createState() => _ApacheCalculatorPageState();
}

class _ApacheCalculatorPageState extends State<ApacheCalculatorPage> {
  static final Map<String, List<_ApacheOption>> _componentOptions = {
    'temperatura': [
      _ApacheOption(4, '≥ 41 °C'),
      _ApacheOption(3, '39.0 - 40.9 °C'),
      _ApacheOption(1, '38.5 - 38.9 °C'),
      _ApacheOption(0, '36.0 - 38.4 °C'),
      _ApacheOption(1, '34.0 - 35.9 °C'),
      _ApacheOption(2, '32.0 - 33.9 °C'),
      _ApacheOption(3, '30.0 - 31.9 °C'),
      _ApacheOption(4, '< 29.9 °C'),
    ],
    'presion': [
      _ApacheOption(4, '≥ 160 mmHg'),
      _ApacheOption(3, '130 - 159 mmHg'),
      _ApacheOption(2, '110 - 129 mmHg'),
      _ApacheOption(0, '70 - 109 mmHg'),
      _ApacheOption(2, '50 - 69 mmHg'),
      _ApacheOption(4, '< 49 mmHg'),
    ],
    'frecuenciaCardiaca': [
      _ApacheOption(4, '≥ 180 lpm'),
      _ApacheOption(3, '140 - 179 lpm'),
      _ApacheOption(2, '110 - 139 lpm'),
      _ApacheOption(0, '70 - 109 lpm'),
      _ApacheOption(2, '55 - 69 lpm'),
      _ApacheOption(3, '40 - 54 lpm'),
      _ApacheOption(4, '< 39 lpm'),
    ],
    'respiratorio': [
      _ApacheOption(4, '≥ 50 rpm'),
      _ApacheOption(3, '35 - 49 rpm'),
      _ApacheOption(1, '25 - 34 rpm'),
      _ApacheOption(0, '12 - 24 rpm'),
      _ApacheOption(1, '10 - 11 rpm'),
      _ApacheOption(2, '6 - 9 rpm'),
      _ApacheOption(4, '< 6 rpm'),
    ],
    'oxigenacion': [
      _ApacheOption(0, 'PaO₂ ≥ 70 mmHg (o A-a < 200)'),
      _ApacheOption(2, 'PaO₂ 61-70 mmHg (o A-a 200-349)'),
      _ApacheOption(3, 'PaO₂ 55-60 mmHg (o A-a 350-499)'),
      _ApacheOption(4, 'PaO₂ < 55 mmHg (o A-a ≥ 500)'),
    ],
    'ph': [
      _ApacheOption(4, 'pH ≥ 7.70'),
      _ApacheOption(3, '7.60 - 7.69'),
      _ApacheOption(1, '7.50 - 7.59'),
      _ApacheOption(0, '7.33 - 7.49'),
      _ApacheOption(2, '7.25 - 7.32'),
      _ApacheOption(3, '7.15 - 7.24'),
      _ApacheOption(4, '< 7.15'),
    ],
    'sodio': [
      _ApacheOption(4, '≥ 180 mmol/L'),
      _ApacheOption(3, '160 - 179 mmol/L'),
      _ApacheOption(2, '155 - 159 mmol/L'),
      _ApacheOption(1, '150 - 154 mmol/L'),
      _ApacheOption(0, '130 - 149 mmol/L'),
      _ApacheOption(2, '120 - 129 mmol/L'),
      _ApacheOption(3, '111 - 119 mmol/L'),
      _ApacheOption(4, '≤ 110 mmol/L'),
    ],
    'potasio': [
      _ApacheOption(4, '≥ 7.0 mmol/L'),
      _ApacheOption(3, '6.0 - 6.9 mmol/L'),
      _ApacheOption(1, '5.5 - 5.9 mmol/L'),
      _ApacheOption(0, '3.5 - 5.4 mmol/L'),
      _ApacheOption(1, '3.0 - 3.4 mmol/L'),
      _ApacheOption(2, '2.5 - 2.9 mmol/L'),
      _ApacheOption(4, '< 2.5 mmol/L'),
    ],
    'creatinina': [
      _ApacheOption(4, '≥ 3.5 mg/dL'),
      _ApacheOption(3, '2.0 - 3.4 mg/dL'),
      _ApacheOption(2, '1.5 - 1.9 mg/dL'),
      _ApacheOption(0, '0.6 - 1.4 mg/dL'),
      _ApacheOption(2, '< 0.6 mg/dL'),
    ],
    'hematocrito': [
      _ApacheOption(4, '≥ 60 %'),
      _ApacheOption(2, '50 - 59.9 %'),
      _ApacheOption(1, '46 - 49.9 %'),
      _ApacheOption(0, '30 - 45.9 %'),
      _ApacheOption(2, '20 - 29.9 %'),
      _ApacheOption(4, '< 20 %'),
    ],
    'leucocitos': [
      _ApacheOption(4, '≥ 40 x10³/µL'),
      _ApacheOption(2, '20 - 39.9 x10³/µL'),
      _ApacheOption(1, '15 - 19.9 x10³/µL'),
      _ApacheOption(0, '3 - 14.9 x10³/µL'),
      _ApacheOption(2, '1 - 2.9 x10³/µL'),
      _ApacheOption(4, '< 1 x10³/µL'),
    ],
    'glasgow': [
      _ApacheOption(0, 'Glasgow 15 (alerta)'),
      _ApacheOption(1, 'Glasgow 13-14'),
      _ApacheOption(2, 'Glasgow 10-12'),
      _ApacheOption(3, 'Glasgow 7-9'),
      _ApacheOption(4, 'Glasgow ≤6'),
    ],
  };

  late Map<String, _ApacheOption> _componentSelections;
  int _agePoints = 0;
  int _chronicPoints = 0;

  @override
  void initState() {
    super.initState();
    final details = widget.initialDetails ?? const <String, dynamic>{};
    final components = Map<String, int>.from(details['components'] ?? const {});
    _componentSelections = {
      for (final entry in _componentOptions.entries)
        entry.key: _initialSelection(entry.value, components[entry.key]),
    };
    _agePoints = (details['agePoints'] as int?) ?? 0;
    _chronicPoints = (details['chronicHealthPoints'] as int?) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calcular APACHE II')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Selecciona el puntaje para cada componente APACHE II. Cada opción representa el rango clínico habitual.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          ..._componentOptions.entries.map(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: DropdownButtonFormField<int>(
                value: _componentSelections[entry.key]?.id,
                decoration: InputDecoration(
                  labelText: _labelFor(entry.key),
                  border: const OutlineInputBorder(),
                ),
                items: entry.value
                    .map(
                      (option) => DropdownMenuItem(
                        value: option.id,
                        child: Text(option.label),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value == null) return;
                  final selection =
                      entry.value.firstWhere((option) => option.id == value);
                  setState(() => _componentSelections[entry.key] = selection);
                },
              ),
            ),
          ),
          const SizedBox(height: 4),
          DropdownButtonFormField<int>(
            value: _agePoints,
            decoration: const InputDecoration(
              labelText: 'Edad',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(value: 0, child: Text('< 45 años (0 pts)')),
              DropdownMenuItem(value: 2, child: Text('45-54 años (2 pts)')),
              DropdownMenuItem(value: 3, child: Text('55-64 años (3 pts)')),
              DropdownMenuItem(value: 5, child: Text('65-74 años (5 pts)')),
              DropdownMenuItem(value: 6, child: Text('≥ 75 años (6 pts)')),
            ],
            onChanged: (value) => setState(() => _agePoints = value ?? 0),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<int>(
            value: _chronicPoints,
            decoration: const InputDecoration(
              labelText: 'Enfermedad crónica',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(
                value: 0,
                child: Text('Sin falla crónica (0 pts)'),
              ),
              DropdownMenuItem(
                value: 5,
                child: Text('Inmunodepresión/falla de órgano (5 pts)'),
              ),
            ],
            onChanged: (value) => setState(() => _chronicPoints = value ?? 0),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _submit,
            icon: const Icon(Icons.check),
            label: const Text('Usar puntaje'),
          ),
        ],
      ),
    );
  }

  void _submit() {
    final physiology = _componentSelections.values
        .fold<int>(0, (sum, option) => sum + option.score);
    final total = physiology + _agePoints + _chronicPoints;
    Navigator.of(context).pop(
      ScoreCaptureResult(
        value: total.toDouble(),
        details: {
          'acutePhysiology': physiology,
          'components': _componentSelections.map(
            (key, option) => MapEntry(key, option.score),
          ),
          'agePoints': _agePoints,
          'chronicHealthPoints': _chronicPoints,
          'total': total,
        },
      ),
    );
  }

  String _labelFor(String key) {
    return switch (key) {
      'temperatura' => 'Temperatura (°C)',
      'presion' => 'Presión arterial media',
      'frecuenciaCardiaca' => 'Frecuencia cardiaca',
      'respiratorio' => 'Frecuencia respiratoria',
      'oxigenacion' => 'Oxigenación (PaO₂/FiO₂)',
      'ph' => 'pH arterial',
      'sodio' => 'Sodio sérico',
      'potasio' => 'Potasio sérico',
      'creatinina' => 'Creatinina',
      'hematocrito' => 'Hematocrito',
      'leucocitos' => 'Leucocitos',
      'glasgow' => 'Glasgow',
      _ => key,
    };
  }

  _ApacheOption _initialSelection(List<_ApacheOption> options, int? stored) {
    if (stored != null) {
      final match = options.firstWhere((option) => option.score == stored,
          orElse: () => options.first);
      return match;
    }
    return options.first;
  }
}

class _ApacheOption {
  _ApacheOption(this.score, this.label) : id = _nextId++;

  final int score;
  final String label;
  final int id;

  static int _nextId = 0;
}
