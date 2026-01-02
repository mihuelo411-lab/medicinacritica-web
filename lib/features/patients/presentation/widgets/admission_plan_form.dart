import 'package:flutter/material.dart';
import '../../common/presentation/procedure_selector_widget.dart';

class AdmissionPlanForm extends StatelessWidget {
  final TextEditingController planController;
  final int? admissionId; // Optional, enabled only if Saved
  final TextEditingController proceduresController;
  final List<DraftProcedure> draftProcedures;
  final ValueChanged<List<DraftProcedure>> onDraftChanged;
  final String? defaultAssistant;
  final String? defaultResident;

  const AdmissionPlanForm({
    super.key,
    required this.planController,
    this.admissionId,
    required this.proceduresController,
    required this.draftProcedures,
    required this.onDraftChanged,
    this.defaultAssistant,
    this.defaultResident,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 Expanded(child: _buildSectionTitle(Icons.assignment, 'VII. Plan Diagnóstico y Terapéutico')),
                 TextButton.icon(
                   onPressed: () => _showImportDialog(context),
                   icon: const Icon(Icons.paste, color: Colors.indigo),
                   label: const Text('IMPORTAR TEXTO'),
                   style: TextButton.styleFrom(
                     backgroundColor: Colors.indigo.withOpacity(0.1),
                   ),
                 ),
               ],
             ),
             const SizedBox(height: 20),
             
             _buildMultilineField('Plan Diagnóstico y Terapéutico', Icons.checklist, planController, 5),
             const SizedBox(height: 30), // Spacing between sections if separate? Or same card?
             // User requested "Plan ... Procedures". 
             // PDF uses VIII for Procedures.
             // If I put them in same Card, UI looks better.
             // But Section Title should be distinct? 
             // PDF Header 8 and 9.
             
             _buildSectionTitle(Icons.healing, 'VIII. Procedimientos de Ingreso'),
             const SizedBox(height: 16),
             ProcedureSelectorWidget(
               admissionId: admissionId,
               origin: 'ingreso',
               draftProcedures: draftProcedures,
               onDraftChanged: onDraftChanged,
               defaultAssistant: defaultAssistant,
               defaultResident: defaultResident,
               footerContent: _buildMultilineField(
                 'Notas adicionales de procedimientos',
                 Icons.note,
                 proceduresController,
                 2,
               ),
             ),
           ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue.shade800),
        const SizedBox(width: 10),
        Flexible(child: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue.shade900))),
      ],
    );
  }

  Widget _buildMultilineField(String label, IconData icon, TextEditingController controller, [int lines = 1]) {
    return TextFormField(
      controller: controller,
      maxLines: lines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Padding(
          padding: const EdgeInsets.only(bottom: 0), 
          child: Icon(icon, color: Colors.blueGrey),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
    );
  }


  void _showImportDialog(BuildContext context) {
    final textController = TextEditingController();
    
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: const Text('Importar desde Portal del Hospital'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
             const Text('Copia todo el texto de la página del laboratorio (Ctrl+A -> Ctrl+C) y pégalo aquí:'),
             const SizedBox(height: 10),
             TextField(
               controller: textController,
               maxLines: 6,
               decoration: const InputDecoration(
                 hintText: 'Pegar texto aquí...',
                 border: OutlineInputBorder(),
               ),
             ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCELAR')),
          FilledButton(
            onPressed: () {
              _parseAndPopulate(textController.text);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('✅ Datos extraídos y agregados el Plan.')),
              );
            }, 
            child: const Text('PROCESAR DATO'),
          ),
        ],
      )
    );
  }

  void _parseAndPopulate(String text) {
     String extracted = "";
     
     // Helper regex
     String? find(RegExp re) {
       final match = re.firstMatch(text);
       return match?.group(1);
     }

     final hb = find(RegExp(r'Hemoglobina\s*[:.-]?\s*(\d+(?:\.\d+)?)', caseSensitive: false)) ?? 
                find(RegExp(r'Hb\s*(\d+(?:\.\d+)?)', caseSensitive: false));
                
     final leu = find(RegExp(r'Leucocitos\s*[:.-]?\s*(\d+(?:\.\d+)?)', caseSensitive: false));
     final plaq = find(RegExp(r'Plaquetas\s*[:.-]?\s*(\d+(?:\.\d+)?)', caseSensitive: false));
     final crea = find(RegExp(r'Creatinina\s*[:.-]?\s*(\d+(?:\.\d+)?)', caseSensitive: false));
     final urea = find(RegExp(r'Urea\s*[:.-]?\s*(\d+(?:\.\d+)?)', caseSensitive: false));
     final pcr = find(RegExp(r'PCR\s*[:.-]?\s*(\d+(?:\.\d+)?)', caseSensitive: false));
     
     List<String> found = [];
     if (hb != null) found.add("Hb: $hb");
     if (leu != null) found.add("Leuc: $leu");
     if (plaq != null) found.add("Plaq: $plaq");
     if (crea != null) found.add("Cr: $crea");
     if (urea != null) found.add("Urea: $urea");
     if (pcr != null) found.add("PCR: $pcr");
     
     if (found.isNotEmpty) {
       final resultString = "\n[LAB IMPORTADO]: ${found.join(' | ')}";
       
       if (planController.text.isEmpty) {
         planController.text = "Plan de Trabajo:$resultString";
       } else {
         planController.text = "${planController.text}$resultString";
       }
     }
  }
}
