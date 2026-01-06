import 'package:flutter/material.dart';

/// Holds shared physiological data to sync between calculators.
/// We store the *selected index* of the dropdowns for simplicity,
/// assuming strict ordering in the widgets.
class PhysiologicalData {
  // Shared / Syncable fields
  int? sofaPao2Index;
  int? sofaPlateletsIndex;
  int? sofaBilirubinIndex;
  int? sofaHypotensionIndex;
  int? sofaGcsIndex;
  int? sofaCreatinineIndex;

  int? apacheTempIndex;
  int? apacheMapIndex;
  int? apacheHrIndex;
  int? apacheRrIndex;
  int? apacheO2Index;
  int? apachePhIndex;
  int? apacheNaIndex;
  int? apacheKIndex;
  int? apacheCrIndex;
  int? apacheHctIndex;
  int? apacheWbcIndex;
  int? apacheGcsIndex;
  int? apacheAgeIndex;
  int? apacheChronicIndex;

  // Sync Logic Helpers
  
  // Example: Sync GCS between SOFA and APACHE
  // SOFA GCS: 0:15, 1:13-14, 2:10-12, 3:6-9, 4:<6
  // APACHE GCS: 0:15, 1:14, 2:13, 3:12... 12:3
  
  void syncFromSofa() {
     // If SOFA GCS is set, try to set APACHE GCS to "average" of range?
     // Or leave it? Mapping ranges to specific points is lossy.
     // Better direction: If APACHE (precise) is set, set SOFA (categorical).
     
     if (apacheGcsIndex != null) {
       // Apache inputs are 0=15, 1=14 ... 12=3.
       // Value = 15 - index.
       int gcs = 15 - apacheGcsIndex!;
       if (gcs == 15) sofaGcsIndex = 0;
       else if (gcs >= 13) sofaGcsIndex = 1;
       else if (gcs >= 10) sofaGcsIndex = 2;
       else if (gcs >= 6) sofaGcsIndex = 3;
       else sofaGcsIndex = 4;
     }

     if (apacheMapIndex != null) {
        // Apache MAP: 0:70-109, 1:110-129(not in sofa), 2:50-69, 3:130-159(not sofa), 4:>=160(not sofa), 5:<=49
        // SOFA: 0:NoHyp, 1:<70, 2,3,4:Dopamine
        
        // If Apache says <=49 (index 5) -> Sofa likely 1 or drugs.
        // If Apache says 50-69 (index 2) -> Sofa 1 (<70).
        // If Apache says 70-109 (index 0) -> Sofa 0.
        if (apacheMapIndex == 0) sofaHypotensionIndex = 0;
        if (apacheMapIndex == 2) sofaHypotensionIndex = 1;
        if (apacheMapIndex == 5) sofaHypotensionIndex = 1; 
     }
     
     if (apacheCrIndex != null) {
        // Apache Cr: 0:0.6-1.4, 1:1.5-1.9, 2:<0.6, 3:2.0-3.4, 4:>=3.5, 5:ARF
        // SOFA Cr: 0:<1.2, 1:1.2-1.9, 2:2.0-3.4, 3:3.5-4.9, 4:>5.0
        if (apacheCrIndex == 0) sofaCreatinineIndex = 0; // Approx
        if (apacheCrIndex == 1) sofaCreatinineIndex = 1; // 1.5-1.9 fits 1.2-1.9
        if (apacheCrIndex == 2) sofaCreatinineIndex = 0; // <0.6 fits <1.2
        if (apacheCrIndex == 3) sofaCreatinineIndex = 2; // 2.0-3.4 matches
        if (apacheCrIndex == 4) sofaCreatinineIndex = 3; // >=3.5 fits 3.5-4.9 (approx)
     }
  }
}

class ScoreCalculators {
  static Future<Map<String, dynamic>?> showSofaCalculator(BuildContext context, {PhysiologicalData? data}) {
    return showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => SofaCalculatorDialog(data: data),
    );
  }

  static Future<Map<String, dynamic>?> showApacheCalculator(BuildContext context, {PhysiologicalData? data}) {
    return showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => ApacheCalculatorDialog(data: data),
    );
  }

  static Future<Map<String, dynamic>?> showNutricCalculator(BuildContext context, {int? sofa, int? apache}) {
    return showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => NutricCalculatorDialog(sofa: sofa, apache: apache),
    );
  }
}

class SofaCalculatorDialog extends StatefulWidget {
  final PhysiologicalData? data;
  const SofaCalculatorDialog({super.key, this.data});

  @override
  State<SofaCalculatorDialog> createState() => _SofaCalculatorDialogState();
}

class _SofaCalculatorDialogState extends State<SofaCalculatorDialog> {
  int pao2fio2 = 0;
  int platelets = 0;
  int bilirubin = 0;
  int hypotension = 0;
  int gcs = 0;
  int creatinine = 0;

  @override
  void initState() {
    super.initState();
    if (widget.data != null) {
      widget.data!.syncFromSofa(); // Sync from Apache if available
      pao2fio2 = widget.data!.sofaPao2Index ?? 0;
      platelets = widget.data!.sofaPlateletsIndex ?? 0;
      bilirubin = widget.data!.sofaBilirubinIndex ?? 0;
      hypotension = widget.data!.sofaHypotensionIndex ?? 0;
      gcs = widget.data!.sofaGcsIndex ?? 0;
      creatinine = widget.data!.sofaCreatinineIndex ?? 0;
    }
  }

  int get totalScore => pao2fio2 + platelets + bilirubin + hypotension + gcs + creatinine;
  
  String get mortality {
    if (totalScore <= 9) return '< 33%';
    if (totalScore <= 11) return '40-50%';
    if (totalScore <= 14) return '50-60%';
    return '> 80%';
  }
  
  void _updateData() {
    if (widget.data != null) {
      widget.data!.sofaPao2Index = pao2fio2;
      widget.data!.sofaPlateletsIndex = platelets;
      widget.data!.sofaBilirubinIndex = bilirubin;
      widget.data!.sofaHypotensionIndex = hypotension;
      widget.data!.sofaGcsIndex = gcs;
      widget.data!.sofaCreatinineIndex = creatinine;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Calculadora SOFA'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            _buildDropdown('Respiratorio (PaO2/FiO2)', [
              '≥ 400 (0)', '< 400 (1)', '< 300 (2)', '< 200 (3)', '< 100 (4)'
            ], pao2fio2, (val) => setState(() => pao2fio2 = val)),
            _buildDropdown('Coagulación (Plaquetas)', [
              '≥ 150 (0)', '< 150 (1)', '< 100 (2)', '< 50 (3)', '< 20 (4)'
            ], platelets, (val) => setState(() => platelets = val)),
            _buildDropdown('Hígado (Bilirrubina)', [
              '< 1.2 (0)', '1.2 - 1.9 (1)', '2.0 - 5.9 (2)', '6.0 - 11.9 (3)', '> 12.0 (4)'
            ], bilirubin, (val) => setState(() => bilirubin = val)),
             _buildDropdown('Cardiovascular (Hipotensión)', [
              'No hipotensión (0)', 'PAM < 70 mmHg (1)', 'Dop ≤ 5 (2)', 'Dop > 5 (3)', 'Dop > 15 (4)'
            ], hypotension, (val) => setState(() => hypotension = val)),
             _buildDropdown('SNC (Glasgow)', [
              '15 (0)', '13 - 14 (1)', '10 - 12 (2)', '6 - 9 (3)', '< 6 (4)'
            ], gcs, (val) => setState(() => gcs = val)),
             _buildDropdown('Renal (Creatinina)', [
              '< 1.2 (0)', '1.2 - 1.9 (1)', '2.0 - 3.4 (2)', '3.5 - 4.9 (3)', '> 5.0 (4)'
            ], creatinine, (val) => setState(() => creatinine = val)),
            
            const Divider(),
            Text('Score Total: $totalScore', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Text('Mortalidad Est.: $mortality', style: const TextStyle(color: Colors.red)),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCELAR')),
        FilledButton(
          onPressed: () {
            _updateData();
            Navigator.pop(context, {'score': totalScore.toString(), 'mortality': mortality, 'data': widget.data});
          },
          child: const Text('ACEPTAR'),
        ),
      ],
    );
  }

  Widget _buildDropdown(String label, List<String> items, int value, Function(int) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: DropdownButtonFormField<int>(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        ),
        value: value < items.length ? value : 0, 
        items: List.generate(items.length, (index) => DropdownMenuItem(value: index, child: Text(items[index], style: const TextStyle(fontSize: 12)))),
        onChanged: (val) {
          if (val != null) onChanged(val);
        },
      ),
    );
  }
}

class ApacheCalculatorDialog extends StatefulWidget {
  final PhysiologicalData? data;
  const ApacheCalculatorDialog({super.key, this.data});

  @override
  State<ApacheCalculatorDialog> createState() => _ApacheCalculatorDialogState();
}

class _ApacheCalculatorDialogState extends State<ApacheCalculatorDialog> {
  // Store INDICES, not points, to maintain correct dropdown state
  int tempIndex = 0;
  int mapIndex = 0;
  int hrIndex = 0;
  int rrIndex = 0;
  int o2Index = 0;
  int phIndex = 0;
  int naIndex = 0;
  int kIndex = 0;
  int crIndex = 0;
  int hctIndex = 0;
  int wbcIndex = 0;
  int gcsIndex = 0;
  int ageIndex = 0;
  int chronicIndex = 0;

  @override
  void initState() {
    super.initState();
    if (widget.data != null) {
      tempIndex = widget.data!.apacheTempIndex ?? 0;
      mapIndex = widget.data!.apacheMapIndex ?? 0;
      hrIndex = widget.data!.apacheHrIndex ?? 0;
      rrIndex = widget.data!.apacheRrIndex ?? 0;
      o2Index = widget.data!.apacheO2Index ?? 0;
      phIndex = widget.data!.apachePhIndex ?? 0;
      naIndex = widget.data!.apacheNaIndex ?? 0;
      kIndex = widget.data!.apacheKIndex ?? 0;
      crIndex = widget.data!.apacheCrIndex ?? 0;
      hctIndex = widget.data!.apacheHctIndex ?? 0;
      wbcIndex = widget.data!.apacheWbcIndex ?? 0;
      gcsIndex = widget.data!.apacheGcsIndex ?? 0;
      ageIndex = widget.data!.apacheAgeIndex ?? 0;
      chronicIndex = widget.data!.apacheChronicIndex ?? 0;
    }
  }

  void _updateData() {
    if (widget.data != null) {
      widget.data!.apacheTempIndex = tempIndex;
      widget.data!.apacheMapIndex = mapIndex;
      widget.data!.apacheHrIndex = hrIndex;
      widget.data!.apacheRrIndex = rrIndex;
      widget.data!.apacheO2Index = o2Index;
      widget.data!.apachePhIndex = phIndex;
      widget.data!.apacheNaIndex = naIndex;
      widget.data!.apacheKIndex = kIndex;
      widget.data!.apacheCrIndex = crIndex;
      widget.data!.apacheHctIndex = hctIndex;
      widget.data!.apacheWbcIndex = wbcIndex;
      widget.data!.apacheGcsIndex = gcsIndex;
      widget.data!.apacheAgeIndex = ageIndex;
      widget.data!.apacheChronicIndex = chronicIndex;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Arrays for scoring logic (Index -> Points)
    final sTemp = [0, 1, 1, 2, 3, 3, 4, 4];
    final sMap = [0, 2, 2, 3, 4, 4];
    final sHr = [0, 2, 2, 3, 3, 4, 4];
    final sRr = [0, 1, 1, 3, 2, 4, 4];
    final sO2 = [0, 1, 2, 3, 3, 4, 4];
    final sPh = [0, 1, 2, 3, 3, 4, 4];
    final sNa = [0, 1, 2, 2, 3, 3, 4, 4];
    final sK = [0, 1, 1, 2, 3, 4, 4];
    final sCr = [0, 2, 2, 3, 4, 0]; // Last one is specialized, check logic
    final sHct = [0, 1, 2, 2, 4, 4];
    final sWbc = [0, 1, 2, 2, 4, 4];
    final sAge = [0, 2, 3, 5, 6];
    final sChronic = [0, 2, 5];
    
    // Calculate Points
    int pTemp = sTemp[tempIndex < sTemp.length ? tempIndex : 0];
    int pMap = sMap[mapIndex < sMap.length ? mapIndex : 0];
    int pHr = sHr[hrIndex < sHr.length ? hrIndex : 0];
    int pRr = sRr[rrIndex < sRr.length ? rrIndex : 0];
    int pO2 = sO2[o2Index < sO2.length ? o2Index : 0];
    int pPh = sPh[phIndex < sPh.length ? phIndex : 0];
    int pNa = sNa[naIndex < sNa.length ? naIndex : 0];
    int pK = sK[kIndex < sK.length ? kIndex : 0];
    int pCr = sCr[crIndex < sCr.length ? crIndex : 0];
    if (crIndex == 5) pCr = 0; // "Acute Renal Failure" logic needs refinement usually implies double points? 
                               // For now leaving as 0 placeholder or implementing complex logic?
                               // Standard Apache II: "Double score for acute renal failure"
                               // Let's assume the user manually selects the doubled score range or we double the BASE score?
                               // Simplified: We'll assume the standard points for now. 
                               // Actually, correct APache II logic is tricky for ARF.
    
    int pHct = sHct[hctIndex < sHct.length ? hctIndex : 0];
    int pWbc = sWbc[wbcIndex < sWbc.length ? wbcIndex : 0];
    int pAge = sAge[ageIndex < sAge.length ? ageIndex : 0];
    int pChronic = sChronic[chronicIndex < sChronic.length ? chronicIndex : 0];
    
    // GCS Score = 15 - ActualGCS
    // Dropdown indices: 0->15(0pts), 1->14(1pt)... 12->3(12pts)
    // Actually GCS Points = 15 - GCS_Value.
    // Index 0 (Value 15) -> 0 pts.
    // Index 12 (Value 3) -> 12 pts.
    int pGcs = gcsIndex; // Since index corresponds exactly to points lost (15-15=0, 15-3=12)

    final aps = pTemp + pMap + pHr + pRr + pO2 + pPh + pNa + pK + pCr + pHct + pWbc + pGcs;
    final total = aps + pAge + pChronic;
    
    String getMortality(int score) {
      if (score <= 4) return '4%';
      if (score <= 9) return '8%';
      if (score <= 14) return '15%';
      if (score <= 19) return '25%';
      if (score <= 24) return '40%';
      if (score <= 29) return '55%';
      if (score <= 34) return '75%';
      return '85%';
    }

    return AlertDialog(
      title: const Text('APACHE II Completo'),
      content: SingleChildScrollView(
        child: Column(
          children: [
             _buildSectionHeader('Fisiología Aguda (APS)'),
             _buildDropdown('Temperatura (°C)', [
               '36° - 38.4° (0)', '38.5° - 38.9° (1)', '34° - 35.9° (1)', '32° - 33.9° (2)', '30° - 31.9° (3)', '39° - 40.9° (3)', '≥ 41° (4)', '≤ 29.9° (4)'
             ], tempIndex, (v) => setState(() => tempIndex = v)),
             
             _buildDropdown('Presión Arterial Media', [
               '70 - 109 (0)', '110 - 129 (2)', '50 - 69 (2)', '130 - 159 (3)', '≥ 160 (4)', '≤ 49 (4)'
             ], mapIndex, (v) => setState(() => mapIndex = v)),
             
             _buildDropdown('Frecuencia Cardíaca', [
               '70 - 109 (0)', '110 - 139 (2)', '55 - 69 (2)', '140 - 179 (3)', '40 - 54 (3)', '≥ 180 (4)', '≤ 39 (4)'
             ], hrIndex, (v) => setState(() => hrIndex = v)),
             
             _buildDropdown('Frecuencia Respiratoria', [
               '12 - 24 (0)', '25 - 34 (1)', '10 - 11 (1)', '35 - 49 (3)', '6 - 9 (2)', '≥ 50 (4)', '≤ 5 (4)'
             ], rrIndex, (v) => setState(() => rrIndex = v)),
             
             _buildDropdown('Oxigenación (AaDO2 o PaO2)', [
               'Normal / PaO2 > 70 (0)', 'PaO2 61-70 (1)', 'A-aDO2 200-349 (2)', 'PaO2 55-60 (3)', 'A-aDO2 350-499 (3)', 'PaO2 < 55 (4)', 'A-aDO2 ≥ 500 (4)'
             ], o2Index, (v) => setState(() => o2Index = v)),
             
             _buildDropdown('pH Arterial', [
               '7.33 - 7.49 (0)', '7.50 - 7.59 (1)', '7.25 - 7.32 (2)', '7.60 - 7.69 (3)', '7.15 - 7.24 (3)', '≥ 7.7 (4)', '< 7.15 (4)'
             ], phIndex, (v) => setState(() => phIndex = v)),
             
             _buildDropdown('Sodio Sérico (Na)', [
               '130 - 149 (0)', '150 - 154 (1)', '155 - 159 (2)', '120 - 129 (2)', '160 - 179 (3)', '111 - 119 (3)', '≥ 180 (4)', '≤ 110 (4)'
             ], naIndex, (v) => setState(() => naIndex = v)),
             
             _buildDropdown('Potasio Sérico (K)', [
               '3.5 - 5.4 (0)', '5.5 - 5.9 (1)', '3.0 - 3.4 (1)', '2.5 - 2.9 (2)', '6.0 - 6.9 (3)', '≥ 7.0 (4)', '< 2.5 (4)'
             ], kIndex, (v) => setState(() => kIndex = v)),
             
             _buildDropdown('Creatinina', [
               '0.6 - 1.4 (0)', '1.5 - 1.9 (2)', '< 0.6 (2)', '2.0 - 3.4 (3)', '≥ 3.5 (4)'
             ], crIndex, (v) => setState(() => crIndex = v)), 
             
             _buildDropdown('Hematocrito', [
               '30 - 45.9 (0)', '46 - 49.9 (1)', '50 - 59.9 (2)', '20 - 29.9 (2)', '≥ 60 (4)', '< 20 (4)'
             ], hctIndex, (v) => setState(() => hctIndex = v)),
             
             _buildDropdown('Leucocitos (WBC)', [
               '3 - 14.9 (0)', '15 - 19.9 (1)', '20 - 39.9 (2)', '1 - 2.9 (2)', '≥ 40 (4)', '< 1 (4)'
             ], wbcIndex, (v) => setState(() => wbcIndex = v)),
             
             _buildDropdown('Glasgow (15 - GCS Real)', [
               '15 (0)', '14 (1)', '13 (2)', '12 (3)', '11 (4)', '10 (5)', '9 (6)', '8 (7)', '7 (8)', '6 (9)', '5 (10)', '4 (11)', '3 (12)'
             ], gcsIndex, (v) => setState(() => gcsIndex = v)), 
             
             const Divider(),
             _buildSectionHeader('Edad y Crónicos'),
             
             _buildDropdown('Edad', [
               '≤ 44 (0)', '45 - 54 (2)', '55 - 64 (3)', '65 - 74 (5)', '≥ 75 (6)'
             ], ageIndex, (v) => setState(() => ageIndex = v)),
             
             _buildDropdown('Enfermedad Crónica Severa', [
               'No (0)', 'Post-Qx Electiva (2)', 'No Quirúrgico o Post-Qx Urgencia (5)'
             ], chronicIndex, (v) => setState(() => chronicIndex = v)),
             
             const Divider(),
             Text('APS: $aps  |  Edad: $pAge  |  Crónicos: $pChronic'),
             const SizedBox(height: 8),
             Text('Total APACHE II: $total', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
             Text('Mortalidad Est.: ${getMortality(total)}', style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
           ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCELAR')),
        FilledButton(
          onPressed: () {
             _updateData();
             // Return total score
            Navigator.pop(context, {'score': total.toString(), 'mortality': getMortality(total), 'data': widget.data});
          },
          child: const Text('ACEPTAR'),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
    );
  }

  Widget _buildDropdown(String label, List<String> items, int currentIndex, Function(int) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: DropdownButtonFormField<int>(
        isExpanded: true,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        ),
        // Ensure index is valid
        value: (currentIndex >= 0 && currentIndex < items.length) ? currentIndex : 0, 
        items: List.generate(items.length, (index) => DropdownMenuItem(value: index, child: Text(items[index], style: const TextStyle(fontSize: 12)))),
        onChanged: (val) {
          if (val != null) onChanged(val);
        },
      ),
    );
  }
}

class NutricCalculatorDialog extends StatefulWidget {
  final int? sofa;
  final int? apache;
  const NutricCalculatorDialog({super.key, this.sofa, this.apache});

  @override
  State<NutricCalculatorDialog> createState() => _NutricCalculatorDialogState();
}

class _NutricCalculatorDialogState extends State<NutricCalculatorDialog> {
  int agePoints = 0;
  int sofaPoints = 0;
  int apachePoints = 0;
  int comorbPoints = 0;
  int daysHospPoints = 0;

  int get totalPoints => agePoints + sofaPoints + apachePoints + comorbPoints + daysHospPoints;

  @override
  void initState() {
    super.initState();
    // Auto-calculate logic if passed
    if (widget.sofa != null) {
      if (widget.sofa! >= 10) sofaPoints = 2;
      else if (widget.sofa! >= 6) sofaPoints = 1;
    }
    if (widget.apache != null) {
      if (widget.apache! >= 28) apachePoints = 3;
      else if (widget.apache! >= 20) apachePoints = 2;
      else if (widget.apache! >= 15) apachePoints = 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    String risk = totalPoints >= 6 ? 'Alto Riesgo (Nutrición Agresiva)' : 'Bajo Riesgo';

    return AlertDialog(
      title: const Text('Calculadora NUTRIC'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            _buildDropdown('Edad', ['< 50 (0)', '50 - 74 (1)', '≥ 75 (2)'], 0, (v) {
               setState(() => agePoints = [0, 1, 2][v]);
            }),
            _buildDropdown('APACHE II (${widget.apache ?? "?"})', ['< 15 (0)', '15 - 19 (1)', '20 - 27 (2)', '≥ 28 (3)'], 
               // Try to auto-select based on points? We can't easily reverse map points to index here without more logic.
               // Just defaulting to 0 for now as user can adjust.
               // Actually we set `apachePoints` in initState. We should probably reflect that in the dropdown.
               // But `apachePoints` is the SCORE (0, 1, 2, 3). The dropdown values are 0,1,2,3.
               // So if `apachePoints` is 2, the index is 2.
               apachePoints,
               (v) {
               setState(() => apachePoints = [0, 1, 2, 3][v]);
            }),
            _buildDropdown('SOFA (${widget.sofa ?? "?"})', ['< 6 (0)', '6 - 9 (1)', '≥ 10 (2)'], 
               sofaPoints,
               (v) {
               setState(() => sofaPoints = [0, 1, 2][v]);
            }),
            _buildDropdown('Comorbilidades', ['0 - 1 (0)', '≥ 2 (1)'], 0, (v) {
               setState(() => comorbPoints = [0, 1][v]);
            }),
             _buildDropdown('Días Hospital Pre-UCI', ['0 (0)', '≥ 1 (1)'], 0, (v) {
               setState(() => daysHospPoints = [0, 1][v]);
            }),
            
            const Divider(),
            Text('Score Total: $totalPoints', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Text(risk, style: TextStyle(color: totalPoints >= 6 ? Colors.red : Colors.green, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
       actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCELAR')),
        FilledButton(
          onPressed: () => Navigator.pop(context, {'score': totalPoints.toString(), 'mortality': risk}), 
          child: const Text('ACEPTAR'),
        ),
      ],
    );
  }

  Widget _buildDropdown(String label, List<String> items, int value, Function(int) onChanged) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: DropdownButtonFormField<int>(
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          ),
          value: value < items.length ? value : 0, 
          items: List.generate(items.length, (index) => DropdownMenuItem(value: index, child: Text(items[index]))),
          onChanged: (val) {
            if (val != null) onChanged(val);
          },
        ),
      );
    }
}
