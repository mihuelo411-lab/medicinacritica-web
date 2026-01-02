import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class AdmissionDemographicsForm extends StatelessWidget {
  // Controllers
  final TextEditingController nameController;
  final TextEditingController dniController;
  final TextEditingController hcController;
  final TextEditingController ageController;
  final TextEditingController addressController;
  final TextEditingController occupationController;
  final TextEditingController religionController;
  final TextEditingController civilStatusController;
  final TextEditingController educationController;
  final TextEditingController phoneController;
  final TextEditingController placeOfBirthController;
  final TextEditingController insuranceTypeController;
  final TextEditingController uciPriorityController;
  
  // State Values
  final String selectedSex;
  final Function(String?) onSexChanged;
  final DateTime? birthDate;
  final Function(DateTime) onBirthDateChanged;
  
  // Focus Nodes
  final FocusNode? nameFocus;
  final FocusNode? hcFocus;
  
  // Robot Trigger
  final Function(String)? onSearchRobot;
  final Function(String)? onSearchDni;

  const AdmissionDemographicsForm({
    super.key,
    required this.nameController,
    required this.dniController,
    required this.hcController,
    required this.ageController,
    required this.addressController,
    required this.occupationController,
    required this.religionController,
    required this.civilStatusController,
    required this.educationController,
    required this.phoneController,
    required this.placeOfBirthController,
    required this.insuranceTypeController,
    required this.uciPriorityController,
    required this.selectedSex,
    required this.onSexChanged,
    required this.birthDate,
    required this.onBirthDateChanged,
    this.nameFocus,
    this.hcFocus,
    this.onSearchRobot,
    required this.hospitalDate,
    required this.onHospitalDateChanged,
    required this.uciDate,
    required this.onUciDateChanged,
    this.onSearchDni,
  });

  final DateTime? hospitalDate;
  final Function(DateTime) onHospitalDateChanged;
  final DateTime? uciDate;
  final Function(DateTime) onUciDateChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(Icons.person, 'I. Filiación y Datos Administrativos'),
            const SizedBox(height: 20),
            
            // Name
            TextFormField(
              controller: nameController,
              focusNode: nameFocus,
              decoration: _inputDecoration('Nombre Completo del Paciente', Icons.person_outline),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 16),
            
            // DNI - HC
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: dniController,
                    decoration: _inputDecoration('DNI', Icons.badge).copyWith(
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search, color: Colors.blue),
                        tooltip: 'Buscar Paciente (Nube)',
                        onPressed: () => onSearchDni?.call(dniController.text),
                      ),
                    ),
                    onChanged: (val) {
                      // Búsqueda automática al terminar de digitar (umbral 8)
                      if (val.trim().length >= 8) {
                        onSearchDni?.call(val.trim());
                      }
                    },
                    onFieldSubmitted: (val) => onSearchDni?.call(val),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: hcController,
                    focusNode: hcFocus,
                    decoration: _inputDecoration('Historia Clínica', Icons.folder_shared_outlined).copyWith(
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.smart_toy, color: Colors.indigo),
                        tooltip: 'Buscar con Robot',
                        onPressed: () => onSearchRobot?.call(hcController.text),
                      ),
                    ),
                    onFieldSubmitted: (val) => onSearchRobot?.call(val),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Birth Date - Age - Sex
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: birthDate ?? DateTime(1970),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        onBirthDateChanged(picked);
                      }
                    },
                    child: InputDecorator(
                      decoration: _inputDecoration('Fecha de Nacimiento', Icons.calendar_today),
                      child: Text(
                        birthDate != null 
                          ? '${birthDate!.day}/${birthDate!.month}/${birthDate!.year}' 
                          : 'Seleccionar',
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: ageController,
                    decoration: _inputDecoration('Edad', Icons.cake),
                    readOnly: true, // Calculated automatically
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: placeOfBirthController,
                    decoration: _inputDecoration('Lugar de Nacimiento', Icons.location_on),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<String>(
                    value: selectedSex,
                    decoration: _inputDecoration('Sexo', Icons.male),
                    items: ['Masculino', 'Femenino'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                    onChanged: onSexChanged,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Address - Phone
             TextFormField(
               controller: addressController,
               decoration: _inputDecoration('Domicilio Actual (Dirección)', Icons.home_outlined),
             ),
             const SizedBox(height: 16),
             TextFormField(
               controller: phoneController,
               decoration: _inputDecoration('Teléfono / Celular', Icons.phone_android),
               keyboardType: TextInputType.number,
             ),
             
             const SizedBox(height: 16),
             
             // Admission Dates (Hospital & UCI)
             Row(
               children: [
                 Expanded(
                   child: InkWell(
                     onTap: () => _pickDateTime(context, hospitalDate, onHospitalDateChanged),
                     child: InputDecorator(
                       decoration: _inputDecoration('Fecha/Hora Ingreso Hospital', Icons.local_hospital),
                       child: Text(
                         hospitalDate != null 
                           ? '${hospitalDate!.day}/${hospitalDate!.month}/${hospitalDate!.year} ${hospitalDate!.hour.toString().padLeft(2, '0')}:${hospitalDate!.minute.toString().padLeft(2, '0')}' 
                           : 'Seleccionar',
                       ),
                     ),
                   ),
                 ),
                 const SizedBox(width: 12),
                 Expanded(
                   child: InkWell(
                     onTap: () => _pickDateTime(context, uciDate, onUciDateChanged),
                     child: InputDecorator(
                       decoration: _inputDecoration('Fecha/Hora Ingreso UCI', Icons.access_time),
                       child: Text(
                         uciDate != null 
                           ? '${uciDate!.day}/${uciDate!.month}/${uciDate!.year} ${uciDate!.hour.toString().padLeft(2, '0')}:${uciDate!.minute.toString().padLeft(2, '0')}' 
                           : 'Seleccionar',
                       ),
                     ),
                   ),
                 ),
               ],
             ),
             
             const SizedBox(height: 16),
             Row(
                children: [
                   Expanded(
                     child: DropdownButtonFormField<String>(
                        value: uciPriorityController.text.isNotEmpty ? uciPriorityController.text : null,
                        decoration: _inputDecoration('Prioridad UCI', Icons.priority_high),
                        items: ['I', 'II', 'III', 'IV'].map((s) => DropdownMenuItem(value: s, child: Text('Prioridad $s'))).toList(),
                        onChanged: (val) {
                           if (val != null) uciPriorityController.text = val;
                        },
                     ),
                   ),
                   const SizedBox(width: 12),
                   Expanded(
                     child: DropdownButtonFormField<String>(
                        value: insuranceTypeController.text.isNotEmpty && ['SIS', 'EsSalud', 'SOAT', 'Privado', 'Otros'].contains(insuranceTypeController.text) 
                              ? insuranceTypeController.text : null,
                        decoration: _inputDecoration('Tipo Seguro', Icons.health_and_safety),
                        items: ['SIS', 'EsSalud', 'SOAT', 'Privado', 'Otros'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                        onChanged: (val) {
                           if (val != null) insuranceTypeController.text = val;
                        },
                     ),
                   ),
                ],
             ),
             
             const SizedBox(height: 16),
             const Divider(),
             const SizedBox(height: 16),
             
             // Socio-economic
             Row(
               children: [
                 Expanded(child: TextFormField(controller: civilStatusController, decoration: _inputDecoration('Estado Civil', Icons.people_outline))),
                 const SizedBox(width: 12),
                 Expanded(child: TextFormField(controller: educationController, decoration: _inputDecoration('Grado Instrucción', Icons.school_outlined))),
               ],
             ),
             const SizedBox(height: 16),
             Row(
               children: [
                 Expanded(child: TextFormField(controller: occupationController, decoration: _inputDecoration('Ocupación', Icons.work_outline))),
                 const SizedBox(width: 12),
                 Expanded(child: TextFormField(controller: religionController, decoration: _inputDecoration('Religión', Icons.church_outlined))),
               ],
             ),
             
           ],
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

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.blueGrey),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
      filled: true,
      fillColor: Colors.grey.shade50,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  Future<void> _pickDateTime(BuildContext context, DateTime? current, Function(DateTime) onChanged) async {
    final date = await showDatePicker(
      context: context,
      initialDate: current ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (date == null) return;

    if (!context.mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(current ?? DateTime.now()),
    );
    if (time == null) return;

    onChanged(DateTime(
      date.year, date.month, date.day,
      time.hour, time.minute,
    ));
  }
}
