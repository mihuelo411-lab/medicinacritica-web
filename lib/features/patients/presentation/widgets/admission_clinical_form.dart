import 'package:flutter/material.dart';

class AdmissionClinicalForm extends StatelessWidget {
  final TextEditingController admissionReasonController; // Signs & Symptoms
  final TextEditingController illnessTimeController;
  final TextEditingController illnessStartController;
  final TextEditingController illnessCourseController;
  final TextEditingController symptomsController; // Relato

  const AdmissionClinicalForm({
    super.key,
    required this.admissionReasonController,
    required this.illnessTimeController,
    required this.illnessStartController,
    required this.illnessCourseController,
    required this.symptomsController,
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
             _buildSectionTitle(Icons.local_hospital, 'II. Enfermedad Actual'),
             const SizedBox(height: 20),
             
             // Order: 1. Signs/Symptoms, 2. Time, 3. Start, 4. Course, 5. Story
             _buildMultilineField('Signos y Síntomas Principales', Icons.warning_amber, admissionReasonController),
             const SizedBox(height: 16),
             
             Row(
               children: [
                 Expanded(child: _buildMultilineField('Tiempo Enf.', Icons.timer, illnessTimeController)),
                 const SizedBox(width: 12),
                 Expanded(child: _buildMultilineField('Forma Inicio', Icons.start, illnessStartController)),
               ],
             ),
             const SizedBox(height: 16),
             
             _buildMultilineField('Curso de la Enfermedad', Icons.timeline, illnessCourseController),
             const SizedBox(height: 16),
             
             _buildMultilineField('Relato Cronológico', Icons.history_edu, symptomsController, 5),
          ],
        ),
      ),
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

  Widget _buildSectionTitle(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue.shade800),
        const SizedBox(width: 10),
        Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue.shade900)),
      ],
    );
  }
}
