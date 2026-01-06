import 'package:flutter/material.dart';

class NutritionScreen extends StatefulWidget {
  final int bedNumber;
  const NutritionScreen({super.key, required this.bedNumber});

  @override
  State<NutritionScreen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen> {
  // Inputs pre-filled from Patient Data
  final TextEditingController _weightController = TextEditingController(text: '75.0');
  final TextEditingController _heightController = TextEditingController(text: '172');
  final TextEditingController _ageController = TextEditingController(text: '58');
  String _sex = 'M';
  
  // Results
  double _calories = 0;
  double _proteins = 0;
  String _nrsScore = '3 (Riesgo)';
  String _nutricScore = '5 (Alto Riesgo)';

  @override
  void initState() {
    super.initState();
    _calculateNeeds();
  }

  void _calculateNeeds() {
    final weight = double.tryParse(_weightController.text) ?? 70;
    final height = double.tryParse(_heightController.text) ?? 170;
    final age = double.tryParse(_ageController.text) ?? 50;
    
    // Mifflin-St Jeor (Standard)
    double bmr = (10 * weight) + (6.25 * height) - (5 * age) + (_sex == 'M' ? 5 : -161);
    
    // Stress Factor (UCI)
    double stress = 1.3; 

    setState(() {
      _calories = bmr * stress;
      _proteins = weight * 1.3; // 1.3g/kg standard
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NutriLogic: Evaluación Automática'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header Scores
            Row(
              children: [
                _buildScoreCard('NUTRIC Score', _nutricScore, Colors.red.shade100, Colors.red),
                const SizedBox(width: 16),
                _buildScoreCard('NRS-2002', _nrsScore, Colors.orange.shade100, Colors.deepOrange),
              ],
            ),
            const SizedBox(height: 24),

            // Calculator Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Parámetros Antropométricos', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: _buildInput('Peso (kg)', _weightController)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildInput('Talla (cm)', _heightController)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildInput('Edad', _ageController)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Results Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.teal.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.teal.shade200),
              ),
              child: Column(
                children: [
                  const Text('META NUTRICIONAL SUGERIDA', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildResultItem(Icons.local_fire_department, '${_calories.toStringAsFixed(0)} kcal', 'Calorías/día'),
                      _buildResultItem(Icons.fitness_center, '${_proteins.toStringAsFixed(1)} g', 'Proteínas/día'),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                   Navigator.pop(context);
                   ScaffoldMessenger.of(context).showSnackBar(
                     const SnackBar(content: Text('Interconsulta Nutricional Generada y Anexada.')),
                   );
                },
                icon: const Icon(Icons.check_circle),
                label: const Text('ACEPTAR Y ANEXAR A HISTORIA'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildScoreCard(String title, String value, Color bg, Color text) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(title, style: TextStyle(color: text, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: text)),
          ],
        ),
      ),
    );
  }

  Widget _buildInput(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      onChanged: (v) => _calculateNeeds(),
    );
  }

  Widget _buildResultItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, size: 32, color: Colors.teal),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}
