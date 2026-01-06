import 'package:flutter/material.dart';

import 'score_capture_result.dart';

class SofaCalculatorPage extends StatefulWidget {
  const SofaCalculatorPage({
    super.key,
    this.initialScore,
    this.initialDetails,
  });

  final double? initialScore;
  final Map<String, dynamic>? initialDetails;

  @override
  State<SofaCalculatorPage> createState() => _SofaCalculatorPageState();
}

class _SofaCalculatorPageState extends State<SofaCalculatorPage> {
  static const Map<String, List<_SofaOption>> _options = {
    'respiratorio': [
      _SofaOption(0, '0: PaO₂/FiO₂ ≥ 400 (sin soporte)'),
      _SofaOption(1, '1: PaO₂/FiO₂ < 400'),
      _SofaOption(2, '2: PaO₂/FiO₂ < 300'),
      _SofaOption(3, '3: PaO₂/FiO₂ < 200 con ventilación'),
      _SofaOption(4, '4: PaO₂/FiO₂ < 100 con ventilación'),
    ],
    'coagulacion': [
      _SofaOption(0, '0: Plaquetas ≥ 150 x10³/µL'),
      _SofaOption(1, '1: Plaquetas < 150'),
      _SofaOption(2, '2: Plaquetas < 100'),
      _SofaOption(3, '3: Plaquetas < 50'),
      _SofaOption(4, '4: Plaquetas < 20'),
    ],
    'higado': [
      _SofaOption(0, '0: Bilirrubina < 1.2 mg/dL'),
      _SofaOption(1, '1: Bilirrubina 1.2 - 1.9'),
      _SofaOption(2, '2: Bilirrubina 2.0 - 5.9'),
      _SofaOption(3, '3: Bilirrubina 6.0 - 11.9'),
      _SofaOption(4, '4: Bilirrubina ≥ 12'),
    ],
    'cardiovascular': [
      _SofaOption(0, '0: PAM ≥ 70 mmHg'),
      _SofaOption(1, '1: PAM < 70 mmHg'),
      _SofaOption(2, '2: Dopamina ≤5 o dobutamina cualquier dosis'),
      _SofaOption(
        3,
        '3: Dopamina >5 o noradrenalina/epinefrina ≤0.1 µg/kg/min',
      ),
      _SofaOption(
        4,
        '4: Dopamina >15 o noradrenalina/epinefrina >0.1 µg/kg/min',
      ),
    ],
    'cns': [
      _SofaOption(0, '0: Glasgow 15'),
      _SofaOption(1, '1: Glasgow 13-14'),
      _SofaOption(2, '2: Glasgow 10-12'),
      _SofaOption(3, '3: Glasgow 6-9'),
      _SofaOption(4, '4: Glasgow < 6'),
    ],
    'renal': [
      _SofaOption(0, '0: Creatinina < 1.2 mg/dL'),
      _SofaOption(1, '1: Creatinina 1.2 - 1.9'),
      _SofaOption(2, '2: Creatinina 2.0 - 3.4'),
      _SofaOption(
        3,
        '3: Creatinina 3.5 - 4.9 o diuresis < 500 mL/día',
      ),
      _SofaOption(
        4,
        '4: Creatinina ≥ 5.0 o diuresis < 200 mL/día',
      ),
    ],
  };

  late Map<String, int> _scores;

  @override
  void initState() {
    super.initState();
    final details = widget.initialDetails ?? const <String, dynamic>{};
    final parsedComponents = <String, int>{};
    final rawComponents = details['components'];
    if (rawComponents is Map) {
      rawComponents.forEach((key, value) {
        final k = key.toString();
        final v = value is num ? value.toInt() : int.tryParse('$value') ?? 0;
        parsedComponents[k] = v;
      });
    }
    _scores = {
      for (final domain in _options.keys)
        domain: parsedComponents[domain] ?? _options[domain]!.first.score,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calcular SOFA')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Selecciona el puntaje (0-4) para cada órgano según los datos clínicos más recientes.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          ..._options.entries.map(
            (domain) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: DropdownButtonFormField<int>(
                value: _scores[domain.key],
                decoration: InputDecoration(
                  labelText: _labelForDomain(domain.key),
                  border: const OutlineInputBorder(),
                ),
                items: domain.value
                    .map(
                      (option) => DropdownMenuItem(
                        value: option.score,
                        child: Text(option.label),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value == null) return;
                  setState(() => _scores[domain.key] = value);
                },
              ),
            ),
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

  String _labelForDomain(String key) {
    return switch (key) {
      'respiratorio' => 'Respiratorio (PaO2/FiO2)',
      'coagulacion' => 'Coagulación (Plaquetas)',
      'higado' => 'Hígado (Bilirrubina)',
      'cardiovascular' => 'Cardiovascular (PAM/vasoactivos)',
      'cns' => 'Neurológico (Glasgow)',
      'renal' => 'Renal (Creatinina/diuresis)',
      _ => key,
    };
  }

  void _submit() {
    final total = _scores.values.fold<int>(0, (sum, value) => sum + value);
    Navigator.of(context).pop(
      ScoreCaptureResult(
        value: total.toDouble(),
        details: {
          'components': _scores,
          'total': total,
        },
      ),
    );
  }
}

class _SofaOption {
  const _SofaOption(this.score, this.label);

  final int score;
  final String label;
}
