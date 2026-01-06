import 'dart:ui';
import 'package:flutter/material.dart';

class ClinicalCalculator extends StatefulWidget {
  final String title;
  final Function(int score, String mortality, List<String> missingExams) onSave;
  final VoidCallback onCancel;

  final int? initialApacheScore;
  final int? initialSofaScore;
  final int? initialAge;
  final int? initialHospitalDays;

  const ClinicalCalculator({
    super.key,
    required this.title,
    required this.onSave,
    required this.onCancel,
    this.initialApacheScore,
    this.initialSofaScore,
    this.initialAge,
    this.initialHospitalDays,
  });

  static void show({
    required BuildContext context,
    required String title,
    required Function(int score, String mortality, List<String> missingExams) onSave,
    int? initialApacheScore,
    int? initialSofaScore,
    int? initialAge,
    int? initialHospitalDays,
  }) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Cerrar',
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return ClinicalCalculator(
          title: title,
          onSave: onSave,
          onCancel: () => Navigator.pop(context),
          initialApacheScore: initialApacheScore,
          initialSofaScore: initialSofaScore,
          initialAge: initialAge,
          initialHospitalDays: initialHospitalDays,
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: anim1, curve: Curves.easeOutBack),
          child: child,
        );
      },
    );
  }

  @override
  State<ClinicalCalculator> createState() => _ClinicalCalculatorState();
}

class _ClinicalCalculatorState extends State<ClinicalCalculator> {
  // SOFA Parameters (Default -1 = Pending/Missing)
  int _pao2Score = -1;
  int _plateletsScore = -1;
  int _bilirubinScore = -1;
  int _hypotensionScore = -1;
  int _glasgowScore = -1;
  int _creatinineScore = -1;

  // APACHE II Parameters
  int _apacheAge = -1;
  int _apacheChronic = -1;
  // Physiology (12 variables)
  int _apacheTemp = -1;
  int _apacheMap = -1;
  int _apacheHr = -1;
  int _apacheRr = -1;
  int _apacheOxygen = -1;
  int _apachePh = -1;
  int _apacheNa = -1;
  int _apacheK = -1;
  int _apacheCr = -1;
  int _apacheHct = -1;
  int _apacheWbc = -1;
  int _apacheGlasgow = -1;

  // NUTRIC Score Parameters
  int _nutricAge = -1;
  int _nutricApache = -1;
  int _nutricSofa = -1;
  int _nutricComorbidities = -1;
  int _nutricDays = -1;

  @override
  void initState() {
    super.initState();
    if (widget.title == 'NUTRIC') {
      // Auto-fill Age
      if (widget.initialAge != null) {
        final age = widget.initialAge!;
        if (age < 50) _nutricAge = 0;
        else if (age <= 74) _nutricAge = 1;
        else _nutricAge = 2; // >= 75
      }
      // Auto-fill Hospital Days
      if (widget.initialHospitalDays != null) {
        final days = widget.initialHospitalDays!;
        if (days <= 0) _nutricDays = 0; // 0-1 days usually counts as 0 pts in simplified versions, strictly >=1 day pre-ICU is risk
        else _nutricDays = 1; // >= 1 day
      }
      // Auto-fill APACHE
      if (widget.initialApacheScore != null) {
        final score = widget.initialApacheScore!;
        if (score < 15) _nutricApache = 0;
        else if (score <= 19) _nutricApache = 1;
        else if (score <= 27) _nutricApache = 2;
        else _nutricApache = 3;
      }
      // Auto-fill SOFA
      if (widget.initialSofaScore != null) {
        final score = widget.initialSofaScore!;
        if (score < 6) _nutricSofa = 0;
        else if (score <= 9) _nutricSofa = 1;
        else _nutricSofa = 2; // >= 10
      }
    } else if (widget.title == 'APACHE II') {
      // Auto-fill Age
      if (widget.initialAge != null) {
        final age = widget.initialAge!;
        if (age <= 44) _apacheAge = 0;
        else if (age <= 54) _apacheAge = 2;
        else if (age <= 64) _apacheAge = 3;
        else if (age <= 74) _apacheAge = 5;
        else _apacheAge = 6; // >= 75
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    int totalScore = 0;
    String mortality = '';
    List<String> missingExams = [];

    if (widget.title == 'SOFA') {
      totalScore = _calculateSofaTotal();
      mortality = _calculateSofaMortality(totalScore);
      missingExams = _getSofaMissingExams();
    } else if (widget.title == 'APACHE II') {
      totalScore = _calculateApacheTotal();
      mortality = _calculateApacheMortality(totalScore);
      missingExams = _getApacheMissingExams();
    } else if (widget.title == 'NUTRIC') {
      totalScore = _calculateNutricTotal();
      mortality = _calculateNutricMortality(totalScore);
      missingExams = _getNutricMissingExams();
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              constraints: const BoxConstraints(maxWidth: 500, maxHeight: 700),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9), // High contrast for visibility
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.indigo.shade900,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calculate, color: Colors.white),
                        const SizedBox(width: 12),
                        Text(
                          'Calculadora ${widget.title}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white70),
                          onPressed: widget.onCancel,
                        ),
                      ],
                    ),
                  ),

                  // Content
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(24),
                      physics: const BouncingScrollPhysics(),
                      children: [
                        if (widget.title == 'SOFA') ...[
                          _buildDropdown('Respiración (PaO2/FiO2)', [
                            const DropdownMenuItem(value: -1, child: Text('No disponible / Pendiente', style: TextStyle(color: Colors.red))),
                            const DropdownMenuItem(value: 0, child: Text('> 400 mmHg (0)')),
                            const DropdownMenuItem(value: 1, child: Text('< 400 mmHg (1)')),
                            const DropdownMenuItem(value: 2, child: Text('< 300 mmHg (2)')),
                            const DropdownMenuItem(value: 3, child: Text('< 200 c/ soporte (3)')),
                            const DropdownMenuItem(value: 4, child: Text('< 100 c/ soporte (4)')),
                          ], _pao2Score, (v) => setState(() => _pao2Score = v!)),
                          
                          _buildDropdown('Coagulación (Plaquetas)', [
                            const DropdownMenuItem(value: -1, child: Text('No disponible / Pendiente', style: TextStyle(color: Colors.red))),
                            const DropdownMenuItem(value: 0, child: Text('> 150 (0)')),
                            const DropdownMenuItem(value: 1, child: Text('< 150 (1)')),
                            const DropdownMenuItem(value: 2, child: Text('< 100 (2)')),
                            const DropdownMenuItem(value: 3, child: Text('< 50 (3)')),
                            const DropdownMenuItem(value: 4, child: Text('< 20 (4)')),
                          ], _plateletsScore, (v) => setState(() => _plateletsScore = v!)),

                          _buildDropdown('Hígado (Bilirrubina)', [
                            const DropdownMenuItem(value: -1, child: Text('No disponible / Pendiente', style: TextStyle(color: Colors.red))),
                            const DropdownMenuItem(value: 0, child: Text('< 1.2 mg/dL (0)')),
                            const DropdownMenuItem(value: 1, child: Text('1.2 - 1.9 (1)')),
                            const DropdownMenuItem(value: 2, child: Text('2.0 - 5.9 (2)')),
                            const DropdownMenuItem(value: 3, child: Text('6.0 - 11.9 (3)')),
                            const DropdownMenuItem(value: 4, child: Text('> 12.0 (4)')),
                          ], _bilirubinScore, (v) => setState(() => _bilirubinScore = v!)),

                          _buildDropdown('Cardiovascular (Hipotensión)', [
                            const DropdownMenuItem(value: -1, child: Text('No disponible / Pendiente', style: TextStyle(color: Colors.red))),
                            const DropdownMenuItem(value: 0, child: Text('No hipotensión (0)')),
                            const DropdownMenuItem(value: 1, child: Text('MAP < 70 mmHg (1)')),
                            const DropdownMenuItem(value: 2, child: Text('Dopamina <= 5 (2)')),
                            const DropdownMenuItem(value: 3, child: Text('Dopamina > 5 (3)')),
                            const DropdownMenuItem(value: 4, child: Text('Dopamina > 15 (4)')),
                          ], _hypotensionScore, (v) => setState(() => _hypotensionScore = v!)),

                          _buildDropdown('S.N.C. (Glasgow)', [
                            const DropdownMenuItem(value: -1, child: Text('No disponible / Pendiente', style: TextStyle(color: Colors.red))),
                            const DropdownMenuItem(value: 0, child: Text('15 (0)')),
                            const DropdownMenuItem(value: 1, child: Text('13 - 14 (1)')),
                            const DropdownMenuItem(value: 2, child: Text('10 - 12 (2)')),
                            const DropdownMenuItem(value: 3, child: Text('6 - 9 (3)')),
                            const DropdownMenuItem(value: 4, child: Text('< 6 (4)')),
                          ], _glasgowScore, (v) => setState(() => _glasgowScore = v!)),

                          _buildDropdown('Renal (Creatinina)', [
                            const DropdownMenuItem(value: -1, child: Text('No disponible / Pendiente', style: TextStyle(color: Colors.red))),
                            const DropdownMenuItem(value: 0, child: Text('< 1.2 mg/dL (0)')),
                            const DropdownMenuItem(value: 1, child: Text('1.2 - 1.9 (1)')),
                            const DropdownMenuItem(value: 2, child: Text('2.0 - 3.4 (2)')),
                            const DropdownMenuItem(value: 3, child: Text('3.5 - 4.9 (3)')),
                            const DropdownMenuItem(value: 4, child: Text('> 5.0 (4)')),
                          ], _creatinineScore, (v) => setState(() => _creatinineScore = v!)),

                        ] else if (widget.title == 'APACHE II') ...[
                          _buildDropdown('Edad', [
                            const DropdownMenuItem(value: -1, child: Text('No disponible', style: TextStyle(color: Colors.red))),
                            const DropdownMenuItem(value: 0, child: Text('< 44 años (0)')),
                            const DropdownMenuItem(value: 2, child: Text('45 - 54 (2)')),
                            const DropdownMenuItem(value: 3, child: Text('55 - 64 (3)')),
                            const DropdownMenuItem(value: 5, child: Text('65 - 74 (5)')),
                            const DropdownMenuItem(value: 6, child: Text('> 75 (6)')),
                          ], _apacheAge, (v) => setState(() => _apacheAge = v!)),
                           _buildDropdown('Salud Crónica', [
                            const DropdownMenuItem(value: -1, child: Text('No disponible', style: TextStyle(color: Colors.red))),
                            const DropdownMenuItem(value: 0, child: Text('No (0)')),
                            const DropdownMenuItem(value: 2, child: Text('Cirugía Electiva (2)')),
                            const DropdownMenuItem(value: 5, child: Text('No Quirúrgico / Emergencia (5)')),
                           ], _apacheChronic, (v) => setState(() => _apacheChronic = v!)),

                           const Divider(),
                           const Text("Fisiología Aguda (APS)", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo)),
                           
                           _buildDropdown('1. Temperatura Rectal (°C)', [
                            const DropdownMenuItem(value: -1, child: Text('Pendiente', style: TextStyle(color: Colors.red))),
                            const DropdownMenuItem(value: 4, child: Text('>= 41° (4) / <= 29.9° (4)')),
                            const DropdownMenuItem(value: 3, child: Text('39° - 40.9° (3) / 30° - 31.9° (3)')),
                            const DropdownMenuItem(value: 1, child: Text('32° - 33.9° (1)')),
                            const DropdownMenuItem(value: 0, child: Text('36° - 38.4° (0) [Normal]')),
                            const DropdownMenuItem(value: 2, child: Text('34° - 35.9° (1)')), // Typo in standard adjusted logic usually, keeping simple ranges
                           ], _apacheTemp, (v) => setState(() => _apacheTemp = v!)),

                           _buildDropdown('2. Presión Arterial Media (MAP)', [
                            const DropdownMenuItem(value: -1, child: Text('Pendiente', style: TextStyle(color: Colors.red))),
                            const DropdownMenuItem(value: 4, child: Text('>= 160 (4) / <= 49 (4)')),
                            const DropdownMenuItem(value: 3, child: Text('130-159 (3)')),
                            const DropdownMenuItem(value: 2, child: Text('110-129 (2) / 50-69 (2)')),
                            const DropdownMenuItem(value: 0, child: Text('70-109 (0) [Normal]')),
                           ], _apacheMap, (v) => setState(() => _apacheMap = v!)),

                           _buildDropdown('3. Frecuencia Cardíaca (HR)', [
                            const DropdownMenuItem(value: -1, child: Text('Pendiente', style: TextStyle(color: Colors.red))),
                            const DropdownMenuItem(value: 4, child: Text('>= 180 (4) / <= 39 (4)')),
                            const DropdownMenuItem(value: 3, child: Text('140-179 (3) / 40-54 (3)')),
                            const DropdownMenuItem(value: 2, child: Text('110-139 (2) / 55-69 (2)')),
                            const DropdownMenuItem(value: 0, child: Text('70-109 (0) [Normal]')),
                           ], _apacheHr, (v) => setState(() => _apacheHr = v!)),

                           _buildDropdown('4. Frecuencia Respiratoria (RR)', [
                            const DropdownMenuItem(value: -1, child: Text('Pendiente', style: TextStyle(color: Colors.red))),
                            const DropdownMenuItem(value: 4, child: Text('>= 50 (4) / <= 5 (4)')),
                            const DropdownMenuItem(value: 3, child: Text('35-49 (3)')),
                            const DropdownMenuItem(value: 2, child: Text('25-34 (2) / 6-9 (2)')),
                            const DropdownMenuItem(value: 1, child: Text('10-11 (1)')),
                            const DropdownMenuItem(value: 0, child: Text('12-24 (0) [Normal]')),
                           ], _apacheRr, (v) => setState(() => _apacheRr = v!)),

                           _buildDropdown('5. Oxigenación (AaDO2 o PaO2)', [
                            const DropdownMenuItem(value: -1, child: Text('Pendiente', style: TextStyle(color: Colors.red))),
                            const DropdownMenuItem(value: 4, child: Text('AaDO2 >= 500 (4)')),
                            const DropdownMenuItem(value: 3, child: Text('AaDO2 350-499 (3) / PaO2 < 55 (3)')),
                            const DropdownMenuItem(value: 2, child: Text('AaDO2 200-349 (2)')),
                            const DropdownMenuItem(value: 1, child: Text('PaO2 61-70 (1)')),
                            const DropdownMenuItem(value: 0, child: Text('PaO2 > 70 (0) [Normal]')),
                           ], _apacheOxygen, (v) => setState(() => _apacheOxygen = v!)),

                           _buildDropdown('6. pH Arterial', [
                            const DropdownMenuItem(value: -1, child: Text('Pendiente', style: TextStyle(color: Colors.red))),
                            const DropdownMenuItem(value: 4, child: Text('>= 7.7 (4) / < 7.15 (4)')),
                            const DropdownMenuItem(value: 3, child: Text('7.6-7.69 (3) / 7.15-7.24 (3)')),
                            const DropdownMenuItem(value: 2, child: Text('7.5-7.59 (2)')),
                            const DropdownMenuItem(value: 1, child: Text('7.25-7.32 (1)')),
                            const DropdownMenuItem(value: 0, child: Text('7.33-7.49 (0) [Normal]')),
                           ], _apachePh, (v) => setState(() => _apachePh = v!)),

                           _buildDropdown('7. Sodio Serico (Na)', [
                            const DropdownMenuItem(value: -1, child: Text('Pendiente', style: TextStyle(color: Colors.red))),
                            const DropdownMenuItem(value: 4, child: Text('>= 180 (4) / <= 110 (4)')),
                            const DropdownMenuItem(value: 3, child: Text('160-179 (3) / 111-119 (3)')),
                            const DropdownMenuItem(value: 2, child: Text('155-159 (2) / 120-129 (2)')),
                            const DropdownMenuItem(value: 0, child: Text('130-154 (0) [Normal]')),
                           ], _apacheNa, (v) => setState(() => _apacheNa = v!)),

                           _buildDropdown('8. Potasio Serico (K)', [
                            const DropdownMenuItem(value: -1, child: Text('Pendiente', style: TextStyle(color: Colors.red))),
                            const DropdownMenuItem(value: 4, child: Text('>= 7 (4) / < 2.5 (4)')),
                            const DropdownMenuItem(value: 3, child: Text('6-6.9 (3)')),
                            const DropdownMenuItem(value: 2, child: Text('2.5-2.9 (2)')),
                            const DropdownMenuItem(value: 1, child: Text('3-3.4 (1) / 5.5-5.9 (1)')),
                            const DropdownMenuItem(value: 0, child: Text('3.5-5.4 (0) [Normal]')),
                           ], _apacheK, (v) => setState(() => _apacheK = v!)),

                           _buildDropdown('9. Creatinina Serica (Cr)', [
                            const DropdownMenuItem(value: -1, child: Text('Pendiente', style: TextStyle(color: Colors.red))),
                            const DropdownMenuItem(value: 4, child: Text('>= 3.5 (4)')),
                            const DropdownMenuItem(value: 3, child: Text('2.0-3.4 (3)')),
                            const DropdownMenuItem(value: 2, child: Text('1.5-1.9 (2) / < 0.6 (2)')),
                            const DropdownMenuItem(value: 0, child: Text('0.6-1.4 (0) [Normal]')),
                           ], _apacheCr, (v) => setState(() => _apacheCr = v!)),

                           _buildDropdown('10. Hematocrito (Hct)', [
                            const DropdownMenuItem(value: -1, child: Text('Pendiente', style: TextStyle(color: Colors.red))),
                            const DropdownMenuItem(value: 4, child: Text('>= 60 (4) / < 20 (4)')),
                            const DropdownMenuItem(value: 2, child: Text('50-59.9 (2) / 20-29.9 (2)')),
                            const DropdownMenuItem(value: 1, child: Text('46-49.9 (1)')),
                            const DropdownMenuItem(value: 0, child: Text('30-45.9 (0) [Normal]')),
                           ], _apacheHct, (v) => setState(() => _apacheHct = v!)),

                           _buildDropdown('11. Leucocitos (WBC)', [
                            const DropdownMenuItem(value: -1, child: Text('Pendiente', style: TextStyle(color: Colors.red))),
                            const DropdownMenuItem(value: 4, child: Text('>= 40k (4) / < 1k (4)')),
                            const DropdownMenuItem(value: 2, child: Text('20k-39.9k (2) / 1k-2.9k (2)')),
                            const DropdownMenuItem(value: 1, child: Text('15k-19.9k (1)')),
                            const DropdownMenuItem(value: 0, child: Text('3k-14.9k (0) [Normal]')),
                           ], _apacheWbc, (v) => setState(() => _apacheWbc = v!)),

                           _buildDropdown('12. Glasgow Coma Scale (15 - GCS)', [
                            const DropdownMenuItem(value: -1, child: Text('Pendiente', style: TextStyle(color: Colors.red))),
                            const DropdownMenuItem(value: 12, child: Text('GCS 3 (12 pts)')),
                            const DropdownMenuItem(value: 10, child: Text('GCS 5 (10 pts)')),
                            const DropdownMenuItem(value: 7, child: Text('GCS 8 (7 pts)')),
                            const DropdownMenuItem(value: 5, child: Text('GCS 10 (5 pts)')),
                            const DropdownMenuItem(value: 2, child: Text('GCS 13 (2 pts)')),
                            const DropdownMenuItem(value: 0, child: Text('GCS 15 (0 pts) [Normal]')),
                           ], _apacheGlasgow, (v) => setState(() => _apacheGlasgow = v!)),

                        ] else if (widget.title == 'NUTRIC') ...[
                           _buildDropdown('Edad', [
                            const DropdownMenuItem(value: -1, child: Text('No disponible', style: TextStyle(color: Colors.red))),
                            const DropdownMenuItem(value: 0, child: Text('< 50 (0)')),
                            const DropdownMenuItem(value: 1, child: Text('50 - 74 (1)')),
                            const DropdownMenuItem(value: 2, child: Text('>= 75 (2)')),
                           ], _nutricAge, (v) => setState(() => _nutricAge = v!)),
                           _buildDropdown('APACHE II', [
                            const DropdownMenuItem(value: -1, child: Text('No disponible', style: TextStyle(color: Colors.red))),
                            const DropdownMenuItem(value: 0, child: Text('< 15 (0)')),
                            const DropdownMenuItem(value: 1, child: Text('15 - 19 (1)')),
                            const DropdownMenuItem(value: 2, child: Text('20 - 27 (2)')),
                            const DropdownMenuItem(value: 3, child: Text('>= 28 (3)')),
                           ], _nutricApache, (v) => setState(() => _nutricApache = v!)),
                           _buildDropdown('SOFA', [
                            const DropdownMenuItem(value: -1, child: Text('No disponible', style: TextStyle(color: Colors.red))),
                            const DropdownMenuItem(value: 0, child: Text('< 6 (0)')),
                            const DropdownMenuItem(value: 1, child: Text('6 - 9 (1)')),
                            const DropdownMenuItem(value: 2, child: Text('>= 10 (2)')),
                           ], _nutricSofa, (v) => setState(() => _nutricSofa = v!)),
                           _buildDropdown('Comorbilidades', [
                            const DropdownMenuItem(value: -1, child: Text('No disponible', style: TextStyle(color: Colors.red))),
                            const DropdownMenuItem(value: 0, child: Text('0 - 1 (0)')),
                            const DropdownMenuItem(value: 1, child: Text('>= 2 (1)')),
                           ], _nutricComorbidities, (v) => setState(() => _nutricComorbidities = v!)),
                           _buildDropdown('Días Hospital (Pre-UCI)', [
                            const DropdownMenuItem(value: -1, child: Text('No disponible', style: TextStyle(color: Colors.red))),
                            const DropdownMenuItem(value: 0, child: Text('0 - 1 día (0)')),
                            const DropdownMenuItem(value: 1, child: Text('>= 1 (1)')),
                           ], _nutricDays, (v) => setState(() => _nutricDays = v!)),
                        ]
                      ],
                    ),
                  ),

                  // Footer Result
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(22)),
                      border: Border(top: BorderSide(color: Colors.grey.shade200)),
                    ),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Puntaje Total',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade600),
                            ),
                            Text(
                              '$totalScore pts',
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.indigo.shade900),
                            ),
                            Text(
                              'Mortalidad Est.: $mortality',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.red.shade400),
                            ),
                          ],
                        ),
                        const Spacer(),
                        FilledButton.icon(
                          onPressed: () {
                            widget.onSave(totalScore, mortality, missingExams);
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.check),
                          label: const Text('USAR'),
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.indigo.shade900,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, List<DropdownMenuItem<int>> items, int value, ValueChanged<int?> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: value,
                isExpanded: true,
                items: items,
                onChanged: onChanged,
                style: const TextStyle(color: Colors.black87, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  int _calculateSofaTotal() {
    // If -1 (missing), count as 0 for score but track elsewhere
    int score = 0;
    if (_pao2Score > 0) score += _pao2Score;
    if (_plateletsScore > 0) score += _plateletsScore;
    if (_bilirubinScore > 0) score += _bilirubinScore;
    if (_hypotensionScore > 0) score += _hypotensionScore;
    if (_glasgowScore > 0) score += _glasgowScore;
    if (_creatinineScore > 0) score += _creatinineScore;
    return score;
  }

  List<String> _getSofaMissingExams() {
    List<String> missing = [];
    if (_pao2Score == -1) missing.add('AGA (PaO2/FiO2)');
    if (_plateletsScore == -1) missing.add('Hemograma (Plaquetas)');
    if (_bilirubinScore == -1) missing.add('Bioquímica (Bilirrubina)');
    if (_hypotensionScore == -1) missing.add('Presión Arterial Media');
    if (_glasgowScore == -1) missing.add('Evaluación Neurológica');
    if (_creatinineScore == -1) missing.add('Función Renal (Creatinina)');
    return missing;
  }

  String _calculateSofaMortality(int score) {
    if (score <= 6) return '< 10%';
    if (score <= 9) return '15 - 20%';
    if (score <= 12) return '40 - 50%';
    if (score <= 14) return '50 - 60%';
    if (score > 14) return '> 80%';
    return '0%';
  }

  int _calculateApacheTotal() {
    int score = 0;
    if (_apacheAge > 0) score += _apacheAge;
    if (_apacheChronic > 0) score += _apacheChronic;
    // Physiology
    if (_apacheTemp > 0) score += _apacheTemp;
    if (_apacheMap > 0) score += _apacheMap;
    if (_apacheHr > 0) score += _apacheHr;
    if (_apacheRr > 0) score += _apacheRr;
    if (_apacheOxygen > 0) score += _apacheOxygen;
    if (_apachePh > 0) score += _apachePh;
    if (_apacheNa > 0) score += _apacheNa;
    if (_apacheK > 0) score += _apacheK;
    if (_apacheCr > 0) score += _apacheCr;
    if (_apacheHct > 0) score += _apacheHct;
    if (_apacheWbc > 0) score += _apacheWbc;
    if (_apacheGlasgow > 0) score += _apacheGlasgow;
    
    return score;
  }

  List<String> _getApacheMissingExams() {
    List<String> missing = [];
    if (_apacheAge == -1) missing.add('Edad Paciente');
    if (_apacheChronic == -1) missing.add('Antecedentes Crónicos');
    // Labs check
    if (_apacheTemp == -1) missing.add('Control Temperatura');
    if (_apacheMap == -1) missing.add('Control Presión Arterial (MAP)');
    if (_apacheHr == -1) missing.add('Control Frecuencia Cardíaca');
    if (_apacheRr == -1) missing.add('Control Frecuencia Respiratoria');
    if (_apacheOxygen == -1) missing.add('AGA (PaO2/AaDO2)');
    if (_apachePh == -1) missing.add('AGA (pH Arterial)');
    if (_apacheNa == -1) missing.add('Electrolitos (Sodio)');
    if (_apacheK == -1) missing.add('Electrolitos (Potasio)');
    if (_apacheCr == -1) missing.add('Bioquímica (Creatinina)');
    if (_apacheHct == -1) missing.add('Hemograma (Hematocrito)');
    if (_apacheWbc == -1) missing.add('Hemograma (Leucocitos)');
    if (_apacheGlasgow == -1) missing.add('Escala Glasgow');
    
    return missing;
  }

  String _calculateApacheMortality(int score) {
    if (score <= 4) return '4%';
    if (score <= 9) return '8%';
    if (score <= 14) return '15%';
    if (score <= 19) return '25%';
    if (score <= 24) return '40%';
    if (score <= 29) return '55%';
    if (score <= 34) return '75%';
    return '> 85%';
  }

  int _calculateNutricTotal() {
    int score = 0;
    if (_nutricAge > 0) score += _nutricAge;
    if (_nutricApache > 0) score += _nutricApache;
    if (_nutricSofa > 0) score += _nutricSofa;
    if (_nutricComorbidities > 0) score += _nutricComorbidities;
    if (_nutricDays > 0) score += _nutricDays;
    return score;
  }

  List<String> _getNutricMissingExams() {
    List<String> missing = [];
    if (_nutricAge == -1) missing.add('Edad (NUTRIC)');
    if (_nutricApache == -1) missing.add('Valor APACHE II');
    if (_nutricSofa == -1) missing.add('Valor SOFA');
    if (_nutricComorbidities == -1) missing.add('Comorbilidades');
    if (_nutricDays == -1) missing.add('Días Hospitalización');
    return missing;
  }

  String _calculateNutricMortality(int score) {
    if (score <= 5) return 'Bajo Riesgo';
    return 'Alto Riesgo';
  }
}
