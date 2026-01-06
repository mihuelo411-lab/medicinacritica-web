import 'package:flutter/material.dart';

import 'package:nutrivigil/presentation/nutrition/calculators/energy_calculator_page.dart';
import 'package:nutrivigil/presentation/nutrition/calculators/weight_estimator_page.dart';

class CalculatorHubPage extends StatelessWidget {
  const CalculatorHubPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calculadoras nutricionales')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _CalculatorTile(
            title: 'Requerimiento energético',
            subtitle: 'Harris-Benedict, Penn State, Mifflin St Jeor.',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const EnergyCalculatorPage()),
            ),
          ),
          _CalculatorTile(
            title: 'Peso estimado',
            subtitle: 'Peso ideal y ajustado según antropometría.',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const WeightEstimatorPage()),
            ),
          ),
        ],
      ),
    );
  }
}

class _CalculatorTile extends StatelessWidget {
  const _CalculatorTile({required this.title, required this.subtitle, required this.onTap});

  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
