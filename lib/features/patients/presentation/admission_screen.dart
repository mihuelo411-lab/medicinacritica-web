import 'dart:ui';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../../ward_round/presentation/ward_round_screen.dart';
import 'clinical_calculator.dart';
import 'package:drift/drift.dart' as drift;
import '../../../../main.dart'; // Access globals for now
import '../../../../core/database/database.dart';
import '../../dashboard/data/cie10_service.dart';
import 'pdf/admission_pdf_generator.dart';
import 'widgets/admission_demographics_form.dart';
import 'widgets/score_calculators_dialog.dart';
import 'widgets/admission_clinical_form.dart';
import 'widgets/admission_dx_form.dart';
import 'widgets/admission_plan_form.dart';
import '../../common/presentation/procedure_selector_widget.dart' show DraftProcedure;
import '../../common/utils/procedure_narrative_builder.dart';
import '../../auth/domain/current_user.dart';
import '../../auth/domain/profile.dart';
import '../../external_data/services/hospital_scraper_service.dart';
import '../data/patient_repository.dart';
import '../../../../core/services/supabase_service.dart';

class AdmissionScreen extends StatefulWidget {
  final int? bedNumber;
  final ActiveAdmission? admissionToEdit;
  const AdmissionScreen({super.key, this.bedNumber, this.admissionToEdit});

  @override
  State<AdmissionScreen> createState() => _AdmissionScreenState();
}

class _AdmissionScreenState extends State<AdmissionScreen> {
  // Filiation
  final _nameController = TextEditingController();
  final _dniController = TextEditingController();
  final _hcController = TextEditingController();
  final _ageController = TextEditingController();
  DateTime? _selectedBirthDate;
  String _selectedSex = 'Masculino';
  DateTime? _hospitalAdmissionDate;
  DateTime? _uciAdmissionDate;
  final _addressController = TextEditingController();
  final _occupationController = TextEditingController();
  final _religionController = TextEditingController();
  final _civilStatusController = TextEditingController();
  final _educationController = TextEditingController();
  final _familyController = TextEditingController();
  final _familyPhoneController = TextEditingController();
  TextEditingController? _familyATController;
  TextEditingController? _familyAFController;
  TextEditingController get _familyAtController => _familyATController ??= TextEditingController();
  TextEditingController get _familyAfController => _familyAFController ??= TextEditingController();
  final _nameFocus = FocusNode();
  final _hcFocus = FocusNode();
  final _phoneController = TextEditingController();
  final _placeOfBirthController = TextEditingController();
  final _insuranceTypeController = TextEditingController();
  final _uciPriorityController = TextEditingController();
  final _assistantSupervisorController = TextEditingController();
  int? _localAdmissionId;
  bool _postSavePromptShown = false;
  UserProfile? _currentProfile;

  // Clinical
  final _admissionReasonController = TextEditingController();
  final _illnessTimeSummaryController = TextEditingController(); // Tiempo enf resumido
  final _mainSymptomsController = TextEditingController(); // Signos y sintomas
  final _illnessTimeController = TextEditingController();
  final _illnessStartController = TextEditingController();
  final _illnessCourseController = TextEditingController();
  
  final _dxController = TextEditingController();
  final _symptomsController = TextEditingController(); // relato
  
  // Scores
  final _sofaController = TextEditingController();
  final _apacheController = TextEditingController();
  final _nutricController = TextEditingController();
  
  // Mortality (Read-only, populated by calculator)
  final _planController = TextEditingController(); // Smart Plan
  final _proceduresController = TextEditingController(); // Procedures
  final List<DraftProcedure> _draftProcedures = [];

  final Set<String> _pendingExams = {}; // Track unique pending exams

  // IV. Funciones Biológicas
  final _appetiteController = TextEditingController();
  final _thirstController = TextEditingController();
  final _urineController = TextEditingController();
  final _stoolController = TextEditingController();
  final _sleepController = TextEditingController();

  // V. Antecedentes
  final _pathologicalController = TextEditingController();
  final _surgicalController = TextEditingController();
  final _familyControllerHistory = TextEditingController(); // Renamed to avoid collision
  final _habitsController = TextEditingController();
  final _allergiesController = TextEditingController();

  // VI. Examen Físico Regional
  final _headNeckController = TextEditingController();
  final _thoraxController = TextEditingController(); // Resp
  final _cvController = TextEditingController();
  final _abdomenController = TextEditingController();
  final _guController = TextEditingController(); // Genito-Urinario
  final _neuroController = TextEditingController();
  final _locomotorController = TextEditingController();
  final List<String> _hemodynamicsOptions = const [
    'Sin soporte vasopresor',
    'Noradrenalina ON',
    'Noradrenalina OFF',
    'Vasopresina ON',
    'Doble vasopresor',
    'Shock refractario',
    'Otro hallazgo (describir en CV)',
  ];
  String? _selectedHemodynamics;

  // Mechanical Ventilation State
  bool _isMechanicalVentilation = false;
  final _mvModeController = TextEditingController();
  final _peepController = TextEditingController();
  final _tvController = TextEditingController(); // Tidal Volume
  final _mvFrController = TextEditingController(); // FR Set
  final _pressureSupportController = TextEditingController();
  bool get _isResidentSession => _currentProfile?.role == 'residente';
  bool get _isAssistantSession =>
      _currentProfile?.role == 'medico' || _currentProfile?.role == 'admin';
  String? get _defaultProcedureAssistant {
    if (_isResidentSession) {
      final supervisor = _assistantSupervisorController.text.trim();
      if (supervisor.isNotEmpty) return supervisor;
    } else if (_isAssistantSession) {
      final name = _currentProfile?.fullName?.trim();
      if (name != null && name.isNotEmpty) return name;
    }
    return null;
  }

  String? get _defaultProcedureResident {
    if (_isResidentSession) {
      final name = _currentProfile?.fullName?.trim();
      if (name != null && name.isNotEmpty) return name;
    }
    return null;
  }
  static final RegExp _sessionHeaderRegex = RegExp(
    r'^\[Sesión:\s*([^\]|]+)(?:\s*\|\s*Médico tratante:\s*([^\]|]+))?(?:\s*\|\s*Asistente responsable:\s*([^\]]+))?\]\s*\n*',
    caseSensitive: false,
  );

  // Service
  final _cie10Service = Cie10Service();
  bool _cie10Loaded = false;

  // Physiological Data (Shared State for Calculators)
  final PhysiologicalData _physiology = PhysiologicalData();

  // Search Patient in Cloud
  Future<void> _searchPatient(String dni) async {
    if (dni.isEmpty) return;
    
    // Show loading
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Buscando paciente...'), duration: Duration(seconds: 1)));
    
    final patient = await SupabaseService().findPatientByDni(dni);
    if (patient != null) {
      // Found! Fill data
      setState(() {
        _nameController.text = patient['name'] ?? '';
        
        // Map Age directly as per SQL Schema
        if (patient['age'] != null) {
           _ageController.text = patient['age'].toString();
        }
        
        // Map Sex
        _selectedSex = patient['sex'] ?? 'Masculino';
        
        // Expanded Fields
        _addressController.text = patient['address'] ?? '';
        _occupationController.text = patient['occupation'] ?? '';
        _phoneController.text = patient['phone'] ?? '';
        _familyController.text = patient['family_contact'] ?? '';
        _placeOfBirthController.text = patient['place_of_birth'] ?? '';
        _insuranceTypeController.text = patient['insurance_type'] ?? '';
        
        // Note: Fields like civil_status/education/antecedents are not in the current V1 SQL schema
        // simplified to match strict schema
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ Paciente encontrado'), backgroundColor: Colors.green));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Paciente no encontrado (se creará al guardar)'), backgroundColor: Colors.orange));
    }
  }

  // PAM Calculation State
  String _pamResult = '';

  void _calculatePAM() {
    final text = _paController.text;
    final RegExp regex = RegExp(r'^(\d{2,3})[\s/.-](\d{2,3})$');
    final match = regex.firstMatch(text);
    
    if (match != null) {
      final sys = int.parse(match.group(1)!);
      final dia = int.parse(match.group(2)!);
      
      // PAM Formula: (Systolic + 2 * Diastolic) / 3
      final pam = (sys + (2 * dia)) / 3;
      setState(() {
        _pamResult = 'PAM: ${pam.toStringAsFixed(0)}';
      });
    } else {
      if (_pamResult.isNotEmpty) setState(() => _pamResult = '');
    }
  }

  // Vital Signs
  final _paController = TextEditingController();
  final _fcController = TextEditingController();
  final _frController = TextEditingController();
  final _satController = TextEditingController();
  final _fio2Controller = TextEditingController();
  final _tController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _imcController = TextEditingController(); // BMI
  final _hgtController = TextEditingController(); // Glicemia

  void _poblateIfEditing() {
    if (widget.admissionToEdit != null) {
       final p = widget.admissionToEdit!.patient;
       final a = widget.admissionToEdit!.admission;
       _localAdmissionId = a.id;
       
       // Poblate Patient
       _nameController.text = p.name;
       _dniController.text = p.dni;
       _hcController.text = p.hc;
       _ageController.text = p.age.toString();
       _selectedSex = p.sex;
       _addressController.text = p.address ?? '';
       _occupationController.text = p.occupation ?? '';
       _phoneController.text = p.phone ?? '';
       _occupationController.text = p.occupation ?? '';
       _phoneController.text = p.phone ?? '';
       _familyController.text = p.familyContact ?? '';
       _placeOfBirthController.text = p.placeOfBirth ?? '';
       _insuranceTypeController.text = p.insuranceType ?? '';

       // Poblate Clinical
       _uciPriorityController.text = a.uciPriority ?? '';
       
       // Reconstruct composite string for viewing if separated in DB
       _sofaController.text = a.sofaScore != null ? '${a.sofaScore}${a.sofaMortality != null && a.sofaMortality!.isNotEmpty ? " (Mort: ${a.sofaMortality})" : ""}' : '';
       _apacheController.text = a.apacheScore != null ? '${a.apacheScore}${a.apacheMortality != null && a.apacheMortality!.isNotEmpty ? " (Mort: ${a.apacheMortality})" : ""}' : '';
       
       _dxController.text = a.diagnosis ?? '';
       _admissionReasonController.text = a.signsSymptoms ?? ''; // Using as Reason/Symptoms
       _loadPlanFromStoredText(a.plan);
       _proceduresController.text = a.procedures ?? '';
       _nutricController.text = '${a.nutricScore ?? 0} pts';

       // Parse Vitals
       if (a.vitalsJson != null) {
          try {
             final vitals = jsonDecode(a.vitalsJson!) as Map<String, dynamic>;
            _paController.text = vitals['PA'] ?? '';
            _fcController.text = vitals['FC'] ?? '';
            _frController.text = vitals['FR'] ?? '';
            _satController.text = vitals['SatO2'] ?? '';
            _fio2Controller.text = vitals['FiO2'] ?? '';
            _tController.text = vitals['T'] ?? '';
            _weightController.text = vitals['Peso'] ?? '';
            _heightController.text = vitals['Talla'] ?? '';
            _imcController.text = vitals['IMC'] ?? '';
            _hgtController.text = vitals['HGT'] ?? '';
             // ... others if needed
          } catch(_){}
       }
       
       // Populate text fields
       _illnessTimeController.text = a.timeOfDisease ?? '';
       _illnessStartController.text = a.illnessStart ?? ''; 
       _illnessCourseController.text = a.illnessCourse ?? '';
       _symptomsController.text = a.story ?? '';
       _headNeckController.text = a.physicalExam ?? '';
       
       // Attempt to restore VM state if present in the combined text
       if (a.physicalExam != null && a.physicalExam!.contains('VM: SI')) {
          _isMechanicalVentilation = true;
          // Simple extraction logic could go here if we used structured data, 
          // for now just restoring the switch. The text is already in _headNeckController (which holds the full blob currently).
       }
       if (a.physicalExam != null) {
         _selectedHemodynamics = _extractExamValue(a.physicalExam!, 'Hemodinamia');
       }
              
       // Poblate Dates
       _hospitalAdmissionDate = a.admissionDate;
    }
  } 

  @override
  void initState() {
    super.initState();
    _currentProfile = CurrentUserStore.profile;
    _poblateIfEditing();
    _loadCie10Async();
    _paController.addListener(_calculatePAM);
    _weightController.addListener(_calculateIMC);
    _heightController.addListener(_calculateIMC);
    _assistantSupervisorController.addListener(_onSupervisorChanged);
  }

  Future<void> _loadCie10Async() async {
    try {
      await _cie10Service.loadData();
    } catch (_) {}
    if (mounted) {
      setState(() => _cie10Loaded = true);
    }
  }

  void _calculateIMC() {
     final wStr = _weightController.text;
     final hStr = _heightController.text;
     
     if (wStr.isNotEmpty && hStr.isNotEmpty) {
       try {
         final w = double.parse(wStr);
         final h = double.parse(hStr) / 100.0; // cm to m
         if (h > 0) {
           final imc = w / (h * h);
           setState(() {
             _imcController.text = imc.toStringAsFixed(2);
           });
           return;
         }
       } catch (_) {}
     }
     if (_imcController.text.isNotEmpty) setState(() => _imcController.text = '');
  }

  void _onSupervisorChanged() {
    if (!_isResidentSession) return;
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _importLabs({String? term}) async {
    final searchInput = term?.trim().isNotEmpty == true ? term!.trim() : _dniController.text.trim();
    
    if (searchInput.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ingrese DNI o Historia Clínica primero')));
      return;
    }

    final scraper = HospitalScraperService();
    
    // Show Progress Dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(children: [Icon(Icons.precision_manufacturing, color: Colors.indigo), SizedBox(width: 10), Text('Robot de Laboratorio')]),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
             const SizedBox(height: 10),
             const CircularProgressIndicator(),
             const SizedBox(height: 20),
             StreamBuilder<String>(
               stream: scraper.statusStream,
               initialData: 'Iniciando sistema...',
               builder: (context, snapshot) {
                 return Text(snapshot.data ?? 'Cargando...', textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold));
               },
             ),
             const SizedBox(height: 10),
             const Text('Por favor espere, esto puede tomar unos segundos.', style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
        actions: [
          TextButton(
             onPressed: () { 
                scraper.stop(); 
                Navigator.pop(context); 
             }, 
             child: const Text('Cancelar', style: TextStyle(color: Colors.red))
          )
        ],
      ),
    );

    try {
      final data = await scraper.loginAndSearch(searchInput);
      if (mounted) Navigator.pop(context); // Close dialog

      if (data != null && data['labs'] != null) {
        final labs = data['labs'];
        setState(() {
          // Append labs to Procedures/Exams field since there are no dedicated lab fields yet
          final sb = StringBuffer();
          sb.writeln('\n--- LABORATORIO IMPORTADO (ROBOT) ---');
          if (labs['hemoglobina'] != null) sb.writeln('Hb: ${labs['hemoglobina']} g/dL');
          if (labs['leucocitos'] != null) sb.writeln('Leucocitos: ${labs['leucocitos']} /mm3');
          if (labs['plaquetas'] != null) sb.writeln('Plaquetas: ${labs['plaquetas']} /mm3');
          if (labs['creatinina'] != null) sb.writeln('Creatinina: ${labs['creatinina']} mg/dL');
          if (labs['urea'] != null) sb.writeln('Urea: ${labs['urea']} mg/dL');
          
          if (_proceduresController.text.isNotEmpty) {
             _proceduresController.text += "\n${sb.toString()}";
          } else {
             _proceduresController.text = sb.toString();
          }
        });
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('¡Datos de laboratorio importados exitosamente!'),
            backgroundColor: Colors.green,
          ));
        }
      }
    } catch (e) {
      if (mounted) Navigator.pop(context);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error del Robot: $e'), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Header
          SliverAppBar(
            expandedHeight: 120,
            backgroundColor: Colors.indigo.shade900,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('Nota de Ingreso UCI', style: Theme.of(context).textTheme.titleMedium),
              centerTitle: true,
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.primary.withOpacity(0.8)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [],
          ),

          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // 1. Unified Filiation Section (Demographics + Scores + Family)
                Card(
                  elevation: 4,
                  shadowColor: Colors.black26,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AdmissionDemographicsForm(
                          nameController: _nameController,
                          dniController: _dniController,
                          hcController: _hcController,
                          ageController: _ageController,
                          addressController: _addressController,
                          occupationController: _occupationController,
                          religionController: _religionController,
                          civilStatusController: _civilStatusController,
                          educationController: _educationController,
                          phoneController: _phoneController,
                          placeOfBirthController: _placeOfBirthController,
                          insuranceTypeController: _insuranceTypeController,
                          uciPriorityController: _uciPriorityController,
                          
                          selectedSex: _selectedSex,
                          onSexChanged: (val) {
                            if (val != null) setState(() => _selectedSex = val);
                          },
                          birthDate: _selectedBirthDate,
                          onBirthDateChanged: (val) {
                            setState(() {
                              _selectedBirthDate = val;
                              final age = DateTime.now().year - val.year;
                              _ageController.text = age.toString();
                            });
                          },

                          nameFocus: _nameFocus,
                          hcFocus: _hcFocus,
                          onSearchRobot: (val) => _importLabs(term: val),
                          onSearchDni: (val) => _searchPatient(val),
                          
                          hospitalDate: _hospitalAdmissionDate,
                          onHospitalDateChanged: (d) => setState(() => _hospitalAdmissionDate = d),
                          uciDate: _uciAdmissionDate,
                          onUciDateChanged: (d) => setState(() => _uciAdmissionDate = d),
                        ),

                        const SizedBox(height: 16),
                        const Divider(),
                        const SizedBox(height: 16),
                        
                        // Scores Integrated
                        _buildScoresSection(),
                        
                        const SizedBox(height: 16),
                        const Divider(),
                        const SizedBox(height: 16),

                        // Family Integrated
                        _buildFamilySection(),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),
                if (_currentProfile != null) ...[
                  _buildSessionBanner(),
                  const SizedBox(height: 24),
                ],

                // 2. Enfermedad Actual (Refactored Form)
                AdmissionClinicalForm(
                  admissionReasonController: _admissionReasonController,
                  illnessTimeController: _illnessTimeController,
                  illnessStartController: _illnessStartController,
                  illnessCourseController: _illnessCourseController,
                  symptomsController: _symptomsController,
                ),

                const SizedBox(height: 24),

                // 3. Funciones Biológicas
                _buildBioFunctionsSection(),

                const SizedBox(height: 24),

                // 4. Antecedentes
                _buildAntecedentsSection(),

                const SizedBox(height: 24),

                // 5. Examen Físico (Vitals + Regional)
                _buildSectionTitle('V. Examen Físico'),
                const SizedBox(height: 12),
                const Text('Signos Vitales:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 8),
                _buildVitalsSection(),
                const SizedBox(height: 16),
                const Text('Examen Regional:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 8),
                _buildPhysicalExamSection(),

                 const SizedBox(height: 24),

                 // 6. Diagnósticos
                 AdmissionDxForm(
                    dxController: _dxController,
                    cie10Service: _cie10Loaded ? _cie10Service : null,
                 ),
                
                 const SizedBox(height: 24),
                
                 // 7. Plan
                 AdmissionPlanForm(
                    planController: _planController,
                    admissionId: _localAdmissionId,
                    proceduresController: _proceduresController,
                    draftProcedures: _draftProcedures,
                    onDraftChanged: _updateDraftProcedures,
                    defaultAssistant: _defaultProcedureAssistant,
                    defaultResident: _defaultProcedureResident,
                 ),

                 const SizedBox(height: 40),

                // Actions
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: _saveToDatabase,
                        icon: const Icon(Icons.save),
                        label: const Text('GUARDAR INGRESO'),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.indigo.shade800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _generatePdfOnly,
                        icon: const Icon(Icons.print),
                        label: const Text('IMPRIMIR'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          foregroundColor: Colors.teal,
                          side: const BorderSide(color: Colors.teal),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 60),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.indigo.shade900,
        ),
      ),
    );
  }

  Widget _buildSessionBanner() {
    final profile = _currentProfile;
    if (profile == null) return const SizedBox.shrink();
    final roleText = _isResidentSession
        ? 'Sesión actual: Residente'
        : _isAssistantSession
            ? 'Sesión actual: Médico asistente'
            : 'Sesión actual';
    final subtitle = profile.fullName?.isNotEmpty == true
        ? 'Profesional: ${profile.fullName}'
        : null;
    return Card(
      color: Colors.indigo.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(roleText,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.indigo)),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(subtitle),
            ],
            if (_isResidentSession) ...[
              const SizedBox(height: 8),
              TextField(
                controller: _assistantSupervisorController,
                decoration: const InputDecoration(
                  labelText: 'Nombre del médico asistente responsable',
                  prefixIcon: Icon(Icons.medical_information_outlined),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Obligatorio para residentes.',
                style: TextStyle(fontSize: 12, color: Colors.redAccent),
              ),
            ] else if (_isAssistantSession) ...[
              const SizedBox(height: 8),
              const Text(
                'Se registrará como nota de asistente.',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildVitalsSection() {
    return SizedBox(
      height: 110,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildVitalCard('PA', 'mmHg', Colors.indigo, _paController, footer: _pamResult),
          _buildVitalCard('FC', 'lpm', Colors.red, _fcController),
          _buildVitalCard('FR', 'rpm', Colors.blue, _frController),
          _buildVitalCard('SatO2', '%', Colors.purple, _satController),
          _buildVitalCard('FiO2', '%', Colors.green, _fio2Controller),
          _buildVitalCard('T°', '°C', Colors.orange, _tController),
          _buildVitalCard('Peso', 'kg', Colors.teal, _weightController),
          _buildVitalCard('Talla', 'cm', Colors.teal.shade700, _heightController),
          _buildVitalCard('IMC', '', Colors.teal.shade900, _imcController, readOnly: true),
          _buildVitalCard('HGT', 'mg/dl', Colors.pink, _hgtController),
        ],
      ),
    );
  }

  Widget _buildVitalCard(String label, String unit, Color color, TextEditingController controller, {String? footer, bool readOnly = false}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(right: 12, bottom: 4),
      child: Container(
        width: 90,
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade700, fontSize: 12)),
            TextField(
              controller: controller, // Make sure to attach controller!
              textAlign: TextAlign.center,
              readOnly: readOnly,
              keyboardType: TextInputType.number,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
              decoration: const InputDecoration(border: InputBorder.none, isDense: true, hintText: '--'),
            ),
            if (footer != null && footer.isNotEmpty)
              Text(footer, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.indigo))
            else
              Text(unit, style: const TextStyle(fontSize: 10, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildBioFunctionsSection() {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.shade200)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(children: [
              Expanded(child: _buildSimpleField('Apetito', Icons.restaurant, _appetiteController)),
              const SizedBox(width: 12),
              Expanded(child: _buildSimpleField('Sed', Icons.water_drop, _thirstController)),
            ]),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: _buildSimpleField('Orina', Icons.opacity, _urineController)),
              const SizedBox(width: 12),
              Expanded(child: _buildSimpleField('Deposiciones', Icons.spa, _stoolController)),
            ]),
            const SizedBox(height: 12),
            _buildSimpleField('Sueño', Icons.bedtime, _sleepController),
          ],
        ),
      ),
    );
  }

  Widget _buildPhysicalExamSection() {
    return Card(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.shade200)),
        child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
                children: [
                    _buildSimpleField('Neurológico', Icons.psychology, _neuroController),
                    const Divider(),
                    _buildSimpleField('Cabeza y Cuello', Icons.face, _headNeckController),
                    const Divider(),
                    _buildThoraxSection(), // Custom section with MV support
                    const Divider(),
                    _buildSimpleField('Cardiovascular', Icons.favorite, _cvController),
                    _buildHemodynamicsSelector(),
                    const Divider(),
                    _buildSimpleField('Abdomen', Icons.circle_outlined, _abdomenController),
                    const Divider(),
                    _buildSimpleField('Genito-Urinario', Icons.wc, _guController),
                    const Divider(),
                    _buildSimpleField('Sistema Locomotor', Icons.accessibility_new, _locomotorController),
                ]
            )
        )
    );
  }

  Widget _buildScoresSection() {
    return Column(
          children: [
             // _buildSectionTitle('Scores Pronósticos'), // Removed numeric title
             const Text('Scores Pronósticos', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.indigo)),
             const SizedBox(height: 16),
             Row(
               children: [
                 Expanded(child: _buildScoreField('SOFA', _sofaController, onTap: () async {
                   try {
                     print('Opening SOFA Calculator...');
                     final res = await ScoreCalculators.showSofaCalculator(context, data: _physiology);
                     if (res != null) {
                       setState(() {
                         _sofaController.text = "${res['score']} (Mort: ${res['mortality']})";
                       });
                     }
                   } catch (e, stack) {
                     print('Error opening SOFA: $e');
                     print(stack);
                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error SOFA: $e'), backgroundColor: Colors.red));
                   }
                 })),
                 const SizedBox(width: 12),
                 Expanded(child: _buildScoreField('APACHE II', _apacheController, onTap: () async {
                   try {
                      print('Opening APACHE Calculator...');
                      final res = await ScoreCalculators.showApacheCalculator(context, data: _physiology);
                      if (res != null) {
                        setState(() {
                           _apacheController.text = "${res['score']} (Mort: ${res['mortality']})";
                        });
                      }
                   } catch (e, stack) {
                      print('Error opening APACHE: $e');
                      print(stack);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error APACHE: $e'), backgroundColor: Colors.red));
                   }
                 })),
                 const SizedBox(width: 12),
                 Expanded(child: _buildScoreField('NUTRIC', _nutricController, onTap: () async {
                    // Extract numeric part robustly
                    int? s;
                    int? a;
                    
                    try {
                       if (_sofaController.text.isNotEmpty) {
                         // Matches digits at start
                         final match = RegExp(r'^(\d+)').firstMatch(_sofaController.text);
                         if (match != null) s = int.parse(match.group(1)!);
                       }
                       if (_apacheController.text.isNotEmpty) {
                          final match = RegExp(r'^(\d+)').firstMatch(_apacheController.text);
                          if (match != null) a = int.parse(match.group(1)!);
                       }
                    } catch (_) {}
                    
                    final res = await ScoreCalculators.showNutricCalculator(context, sofa: s, apache: a);
                    if (res != null) {
                      setState(() {
                        _nutricController.text = '${res['score']} (${res['mortality']})';
                      });
                    }
                 })),
               ],
             )
          ],
    );
  }

  Widget _buildScoreField(String label, TextEditingController controller, {VoidCallback? onTap}) {
    return Column(
      children: [
        TextField(
          controller: controller,
          readOnly: true, // Prevent keyboard
          canRequestFocus: false, // Strict: Prevent focus entirely
          enableInteractiveSelection: false, // No copy/paste
          onTap: onTap, // Direct tap handling
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            labelText: label,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            suffixIcon: onTap != null ? const Icon(Icons.calculate, size: 16, color: Colors.indigo) : null,
          ),
        ),
      ],
    );
  }

  Widget _buildFamilySection() {
    return Column(
           children: [
             // _buildSectionTitle('Familiar Responsable'),
             const Text('Familiar Responsable', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.indigo)),
             const SizedBox(height: 16),
             TextFormField(
                controller: _familyController,
                decoration: InputDecoration(
                  labelText: 'Nombre Familiar Responsable',
                  prefixIcon: const Icon(Icons.family_restroom, color: Colors.blueGrey),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                ),
             ),
             const SizedBox(height: 16),
             TextFormField(
                controller: _familyPhoneController,
                decoration: InputDecoration(
                  labelText: 'Teléfono / Celular Familiar',
                  prefixIcon: const Icon(Icons.phone, color: Colors.blueGrey),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                ),
                keyboardType: TextInputType.phone,
             ),
             const SizedBox(height: 16),
             Row(
               children: [
                 Expanded(
                   child: TextFormField(
                     controller: _familyAtController,
                     decoration: InputDecoration(
                       labelText: 'A.T',
                       helperText: 'Referido en formato (solo PDF)',
                       prefixIcon: const Icon(Icons.badge, color: Colors.blueGrey),
                       border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                       filled: true,
                       fillColor: Colors.grey.shade50,
                     ),
                   ),
                 ),
                 const SizedBox(width: 12),
                 Expanded(
                   child: TextFormField(
                     controller: _familyAfController,
                     decoration: InputDecoration(
                       labelText: 'A.F',
                       helperText: 'Referido en formato (solo PDF)',
                       prefixIcon: const Icon(Icons.badge_outlined, color: Colors.blueGrey),
                       border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                       filled: true,
                       fillColor: Colors.grey.shade50,
                     ),
                   ),
                 ),
               ],
             ),
           ],
    );
  }

  Widget _buildAntecedentsSection() {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.shade200)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSimpleField('Patológicos (HTA, DM2, Asma...)', Icons.medical_services, _pathologicalController),
            const Divider(),
            _buildSimpleField('Quirúrgicos', Icons.content_cut, _surgicalController),
            const Divider(),
            _buildSimpleField('Familiares', Icons.family_restroom, _familyControllerHistory),
            const Divider(),
            _buildSimpleField('Hábitos Nocivos', Icons.smoking_rooms, _habitsController),
            const Divider(),
            _buildSimpleField('Alergias', Icons.warning, _allergiesController),
          ],
        ),
      ),
    );
  }



  Widget _buildThoraxSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSimpleField('Tórax y Pulmones', Icons.air, _thoraxController),
        Padding(
          padding: const EdgeInsets.only(left: 32, top: 4),
          child: Row(
            children: [
              Checkbox(
                value: _isMechanicalVentilation,
                activeColor: Colors.indigo,
                onChanged: (val) {
                  setState(() => _isMechanicalVentilation = val ?? false);
                },
              ),
              const Text('¿Ventilación Mecánica?', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo)),
            ],
          ),
        ),
        if (_isMechanicalVentilation)
          Padding(
             padding: const EdgeInsets.only(left: 40, right: 16, bottom: 8),
             child: Wrap(
               spacing: 12,
               runSpacing: 12,
               children: [
                 _buildMiniField('Modo', _mvModeController, width: 80),
                 _buildMiniField('PEEP', _peepController, width: 60, isNumber: true),
                 _buildMiniField('Vt (ml)', _tvController, width: 70, isNumber: true),
                 _buildMiniField('FR (set)', _mvFrController, width: 60, isNumber: true),
                 _buildMiniField('P. Sop', _pressureSupportController, width: 60, isNumber: true),
               ],
             ),
          ),
      ],
    );
  }

  Widget _buildHemodynamicsSelector() {
    return Padding(
      padding: const EdgeInsets.only(left: 32, right: 16, top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Hemodinamia',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo),
          ),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            value: _selectedHemodynamics,
            items: _hemodynamicsOptions.map((opt) {
              return DropdownMenuItem<String>(
                value: opt,
                child: Text(opt),
              );
            }).toList(),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey.shade50,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            icon: const Icon(Icons.keyboard_arrow_down),
            hint: const Text('Selecciona soporte hemodinámico'),
            onChanged: (value) {
              setState(() {
                _selectedHemodynamics = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMiniField(String label, TextEditingController controller, {double width = 80, bool isNumber = false}) {
    return SizedBox(
      width: width,
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          filled: true,
          fillColor: Colors.grey.shade50,
        ),
        style: const TextStyle(fontSize: 12),
      ),
    );
  }

  Widget _buildSimpleField(String label, IconData icon, TextEditingController controller) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey),
        const SizedBox(width: 8),
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              isDense: true,
              hintText: label,
              border: InputBorder.none,
              hintStyle: const TextStyle(color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }

  String? _extractExamValue(String source, String label) {
    final normalizedLabel = label.toLowerCase();
    for (final line in source.split('\n')) {
      final trimmed = line.trim();
      if (trimmed.toLowerCase().startsWith('$normalizedLabel:')) {
        final value = trimmed.substring(label.length + 1).trim();
        if (value.isNotEmpty) return value;
      }
    }
    return null;
  }


  Future<void> _persistDraftProcedures(int admissionId) async {
    if (_draftProcedures.isEmpty) return;
    for (final draft in List<DraftProcedure>.from(_draftProcedures)) {
      try {
        final remote = await SupabaseService().savePerformedProcedure(
          admissionId: admissionId,
          procedureId: draft.procedureId,
          procedureName: draft.procedureName,
          performedAt: draft.performedAt,
          assistant: draft.assistant,
          resident: draft.resident,
          origin: draft.origin,
          guardia: draft.guardia,
          note: draft.note,
        );
        final companion = PerformedProceduresCompanion(
          id: drift.Value(remote['id'] as int),
          admissionId: drift.Value(admissionId),
          procedureId: drift.Value(remote['procedure_id'] as int),
          procedureName: drift.Value(remote['procedure_name'] as String),
          performedAt: drift.Value(
            DateTime.tryParse(remote['performed_at']?.toString() ?? '') ??
                draft.performedAt,
          ),
          assistant: drift.Value(remote['assistant'] as String?),
          resident: drift.Value(remote['resident'] as String?),
          origin: drift.Value(remote['origin'] as String?),
          guardia: drift.Value(remote['guardia'] as String?),
          note: drift.Value(remote['note'] as String? ?? draft.note),
          createdAt: drift.Value(
            DateTime.tryParse(remote['created_at']?.toString() ?? '') ??
                DateTime.now(),
          ),
          isSynced: const drift.Value(true),
        );
        await appDatabase
            .into(appDatabase.performedProcedures)
            .insertOnConflictUpdate(companion);
      } catch (e) {
        debugPrint('Error al guardar procedimiento pendiente: $e');
      }
    }
  }

  Future<void> _saveToDatabase() async {
    if (_nameController.text.isEmpty || _dniController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Faltan datos obligatorios (Nombre/DNI)')));
      return;
    }

    try {
      final vitalsMap = {
        'PA': _paController.text,
        'FC': _fcController.text,
        'FR': _frController.text,
        'SatO2': _satController.text,
        'FiO2': _fio2Controller.text,
        'T': _tController.text,
        'Peso': _weightController.text,
        'Talla': _heightController.text,
        'IMC': _imcController.text,
        'HGT': _hgtController.text,
      };
      final planText = _buildPlanWithSessionHeader();

      // Helper to split "Score (Mort: Mortality)"
      String? extractScore(String val) {
        final match = RegExp(r'^(\d+(\.\d+)?)\s*\(Mort:.*\)').firstMatch(val);
        if (match != null) return match.group(1);
        return val.contains('(') ? val.split('(')[0].trim() : val;
      }
      String? extractMort(String val) {
        final match = RegExp(r'\(Mort:\s*(.*?)\)').firstMatch(val);
        if (match != null) return match.group(1);
        return '';
      }
      
      // 1. Prepare Data for Local & Cloud
      final double sofa = double.tryParse(extractScore(_sofaController.text) ?? '0') ?? 0;
      final double apache = double.tryParse(extractScore(_apacheController.text) ?? '0') ?? 0;
      final double nutric = double.tryParse(extractScore(_nutricController.text) ?? '0') ?? 0;
      final String smort = extractMort(_sofaController.text) ?? '';
      final String amort = extractMort(_apacheController.text) ?? '';

      // --- SUPABASE SYNC (Primary) ---
      bool isReadmissionFlag = false;
      // We assume Supabase is the source of truth for "New vs Readmission" logic via RPC
       try {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Guardando en la nube...'), duration: Duration(seconds: 1)));
        
        final service = SupabaseService();
        
        // A. Step 1: Register Patient & Basic Admission (RPC)
        final result = await service.registerPatientAdmission(
          dni: _dniController.text.trim(),
          name: _nameController.text,
          hc: _hcController.text,
          age: int.tryParse(_ageController.text) ?? 0,
          sex: _selectedSex,
          address: _addressController.text,
          occupation: _occupationController.text,
          phone: _phoneController.text,
          familyContact: _familyController.text,
          placeOfBirth: _placeOfBirthController.text,
          insuranceType: _insuranceTypeController.text,
          bedNumber: widget.bedNumber,
          diagnosis: _dxController.text,
          sofaScore: sofa,
          apacheScore: apache,
        );
        
        final admissionId = result['admission_id'] as int;
        setState(() => _localAdmissionId = admissionId);
        final remoteStatus = (result['status']?.toString().toUpperCase() ?? 'NUEVO');
        isReadmissionFlag = remoteStatus == 'REINGRESO';
        
        // B. Step 2: Update with Full Clinical Data (Vitals, Plan, etc.)
        await service.updateAdmissionClinicalData(
          admissionId: admissionId,
          vitals: vitalsMap,
          signsSymptoms: _admissionReasonController.text,
          diseaseTime: _illnessTimeController.text,
          diseaseStart: _illnessStartController.text,
          diseaseCourse: _illnessCourseController.text,
          story: _symptomsController.text, // Relato
          physicalExam: _headNeckController.text, // Mapping head/neck as main or combine? Using just one for now or we could concatenate
          plan: planText,
          procedures: _proceduresController.text,
          sofaMortality: smort,
          apacheMortality: amort,
          nutricScore: nutric,
        );

        print('✅ Supabase Sync Success. Status: $remoteStatus');
        
         if (mounted) {
           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('¡Guardado en Nube Exitoso! ($remoteStatus)'),
            backgroundColor: Colors.green,
          ));
        }
        
      } catch (e) {
        print('⚠️ Supabase Sync Failed: $e');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error guardando en nube: $e'), backgroundColor: Colors.red));
        // We continue to Local Save as backup? No, let's stop if cloud fails or ask user.
        // For now, let's return to avoid inconsistent state, or proceed to local.
        return;
      }
      
      // 3. Save to LOCAL Database (Drift) for UI updates & Offline support
      
      // Use global patientRepository from main.dart
      
      final localPatient = PatientsCompanion(
        dni: drift.Value(_dniController.text.trim()),
        name: drift.Value(_nameController.text),
        age: drift.Value(int.tryParse(_ageController.text) ?? 0),
        sex: drift.Value(_selectedSex ?? 'Masculino'),
        hc: drift.Value(_hcController.text),
        insuranceType: drift.Value(_insuranceTypeController.text),
        familyContact: drift.Value(_familyController.text),
        phone: drift.Value(_phoneController.text),
        occupation: drift.Value(_occupationController.text),
        placeOfBirth: drift.Value(_placeOfBirthController.text),
      );
      
      // Upsert local patient and get ID
      final int localId = await patientRepository.createOrUpdatePatient(localPatient);
      
      // Parse Scores & Mortality
      String sofaScoreOnly = '0';
      String sofaMortality = '';
      if (_sofaController.text.contains('(')) {
        final parts = _sofaController.text.split('(');
        sofaScoreOnly = parts[0].trim();
        sofaMortality = parts[1].replaceAll('Mort:', '').replaceAll(')', '').trim();
      } else {
        sofaScoreOnly = _sofaController.text.trim();
      }

      String apacheScoreOnly = '0';
      String apacheMortality = '';
      if (_apacheController.text.contains('(')) {
        final parts = _apacheController.text.split('(');
        apacheScoreOnly = parts[0].trim();
        apacheMortality = parts[1].replaceAll('Mort:', '').replaceAll(')', '').trim();
      } else {
         apacheScoreOnly = _apacheController.text.trim();
      }

      String nutricScoreOnly = _nutricController.text.split(' ')[0].trim(); // Usually "Score (Risk)"

      // Construct Physical Exam (Combined string for local DB)
      final String physicalExamCombined = [
        'Cabeza/Cuello: ${_headNeckController.text}',
        'Tórax: ${_thoraxController.text}${_isMechanicalVentilation ? " [VM: SI | Modo: ${_mvModeController.text} | PEEP: ${_peepController.text} | Vt: ${_tvController.text} | FR: ${_mvFrController.text} | P.Sop: ${_pressureSupportController.text}]" : ""}',
        'CV: ${_cvController.text}',
        if (_selectedHemodynamics != null && _selectedHemodynamics!.isNotEmpty)
          'Hemodinamia: ${_selectedHemodynamics!}',
        'Abdomen: ${_abdomenController.text}',
        'GU: ${_guController.text}',
        'Neuro: ${_neuroController.text}',
        'Locomotor: ${_locomotorController.text}'
      ].where((s) => !s.endsWith(': ')).join('\n'); // Only add non-empty
      
      final localAdmission = AdmissionsCompanion(
        id: drift.Value(_localAdmissionId!),
        patientId: drift.Value(localId), // Correct FK
        bedNumber: drift.Value(widget.bedNumber),
        admissionDate: drift.Value(DateTime.now()),
        diagnosis: drift.Value(_dxController.text),
        signsSymptoms: drift.Value(_admissionReasonController.text),
        vitalsJson: drift.Value(jsonEncode(vitalsMap)),
        physicalExam: drift.Value(physicalExamCombined),
        plan: drift.Value(planText),
        sofaScore: drift.Value(double.tryParse(sofaScoreOnly) ?? 0), 
        apacheScore: drift.Value(double.tryParse(apacheScoreOnly) ?? 0),
        nutricScore: drift.Value(double.tryParse(nutricScoreOnly) ?? 0),
        sofaMortality: drift.Value(sofaMortality),
        apacheMortality: drift.Value(apacheMortality),
        uciPriority: drift.Value(_uciPriorityController.text),
        isSynced: const drift.Value(true), 
        status: const drift.Value('activo'),
        isReadmission: drift.Value(isReadmissionFlag),
        
        // Detailed History Fields
        timeOfDisease: drift.Value(_illnessTimeController.text),
        illnessStart: drift.Value(_illnessStartController.text),
        illnessCourse: drift.Value(_illnessCourseController.text),
        story: drift.Value(_symptomsController.text),
        procedures: drift.Value(_proceduresController.text),
      );

      final savedId = await patientRepository.saveAdmission(localAdmission);
      print("Local DB updated successfully.");
      setState(() => _localAdmissionId = savedId);

      if (_draftProcedures.isNotEmpty) {
        await _persistDraftProcedures(savedId);
        setState(() => _draftProcedures.clear());
      }

      if (!mounted) return;

      if (widget.admissionToEdit != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ingreso actualizado correctamente'), backgroundColor: Colors.green),
        );
        return;
      }

      if (!_postSavePromptShown) {
        _postSavePromptShown = true;
        final shouldClose = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Ingreso guardado'),
            content: const Text('Ahora puedes registrar los Procedimientos de Ingreso directamente en la sección VIII. ¿Deseas volver al panel?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('SEGUIR AQUÍ'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('VOLVER AL PANEL'),
              ),
            ],
          ),
        );
        if (shouldClose == true && mounted) {
          Navigator.pop(context);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ingreso actualizado'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error general: $e'), backgroundColor: Colors.red));
    }
  }

  Future<void> _generatePdfOnly() async {
    try {
      final planForPdf = _buildPlanWithSessionHeader();
      final proceduresForPdf = await _buildProceduresNarrativeText(includeDrafts: true);
      final preparedByName = _currentProfile?.fullName?.trim();
      String? preparedByRole;
      String? secondarySignatureName;
      String? secondarySignatureRole;
      if (_isResidentSession) {
        preparedByRole = 'MÉDICO RESIDENTE';
        final supervisor = _assistantSupervisorController.text.trim();
        if (supervisor.isNotEmpty) {
          secondarySignatureName = supervisor;
          secondarySignatureRole = 'MÉDICO ASISTENTE';
        }
      } else if (_isAssistantSession) {
        preparedByRole = 'MÉDICO ASISTENTE';
      }
      // Create temporary objects for PDF generation (No DB save)
      final admissionData = AdmissionsCompanion(
        patientId: const drift.Value(0),
        admissionDate: drift.Value(DateTime.now()),
        sofaScore: drift.Value(double.tryParse(_sofaController.text.split(' ')[0]) ?? 0),
        apacheScore: drift.Value(double.tryParse(_apacheController.text.split(' ')[0]) ?? 0),
        nutricScore: drift.Value(double.tryParse(_nutricController.text.split(' ')[0]) ?? 0),
        diagnosis: drift.Value(_dxController.text),
        signsSymptoms: drift.Value(_admissionReasonController.text), 
        plan: drift.Value(planForPdf),
        procedures: drift.Value(proceduresForPdf),
      );

      final patient = Patient(
        id: 0,
        name: _nameController.text,
        dni: _dniController.text,
        hc: _hcController.text,
        age: int.tryParse(_ageController.text) ?? 0,
        sex: _selectedSex,
        address: _addressController.text,
        occupation: _occupationController.text,
        phone: _phoneController.text,
        familyContact: _familyController.text,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isSynced: false,
      );

      await AdmissionPdfGenerator.generateAndPrint(
        patient: patient,
        admission: admissionData,
        bedNumber: widget.bedNumber?.toString() ?? 'Sin Asignar',
        age: _ageController.text,
        sex: _selectedSex,
        birthDate: _selectedBirthDate != null 
            ? '${_selectedBirthDate!.day}/${_selectedBirthDate!.month}/${_selectedBirthDate!.year}'
            : '-',
        civilStatus: _civilStatusController.text,
        education: _educationController.text,
        religion: _religionController.text,
        occupation: _occupationController.text,
        familyPhone: _familyPhoneController.text,
        responsibleFamily: _familyController.text,
        familyAt: _familyAtController.text,
        familyAf: _familyAfController.text,
        placeOfBirth: _placeOfBirthController.text,
        insuranceType: _insuranceTypeController.text,
        uciPriority: _uciPriorityController.text,
        
        hospitalAdmissionDateTime: _hospitalAdmissionDate != null 
            ? '${_hospitalAdmissionDate!.day}/${_hospitalAdmissionDate!.month}/${_hospitalAdmissionDate!.year} ${_hospitalAdmissionDate!.hour.toString().padLeft(2,'0')}:${_hospitalAdmissionDate!.minute.toString().padLeft(2,'0')}' 
            : '-',
        uciAdmissionDateTime: _uciAdmissionDate != null 
            ? '${_uciAdmissionDate!.day}/${_uciAdmissionDate!.month}/${_uciAdmissionDate!.year} ${_uciAdmissionDate!.hour.toString().padLeft(2,'0')}:${_uciAdmissionDate!.minute.toString().padLeft(2,'0')}' 
            : DateTime.now().toString().split('.')[0],

        vitals: {
          'PA': _paController.text,
          'PAM': _pamResult,
          'FC': _fcController.text,
          'FR': _frController.text,
          'SatO2': _satController.text,
          'FiO2': _fio2Controller.text,
          'T°': _tController.text,
          'Peso': _weightController.text,
          'Glicemia': _hgtController.text,
        },
        
        signsSymptoms: _mainSymptomsController.text.isNotEmpty ? _mainSymptomsController.text : 'Referido en historia clínica',
        timeOfDisease: _illnessTimeController.text,
        illnessStart: _illnessStartController.text,
        illnessCourse: _illnessCourseController.text,
        story: _symptomsController.text,
        
        biolFunctions: {
          'Apetito': _appetiteController.text,
          'Sed': _thirstController.text,
          'Orina': _urineController.text,
          'Deposiciones': _stoolController.text,
          'Sueño': _sleepController.text,
        },
        antecedents: {
          'Patológicos': _pathologicalController.text,
          'Quirúrgicos': _surgicalController.text,
          'Familiares': _familyControllerHistory.text,
          'Hábitos': _habitsController.text,
          'Alergias': _allergiesController.text,
        },
        physicalExam: {
          'Neuro': _neuroController.text,
          'Cabeza/Cuello': _headNeckController.text,
          'Tórax': '${_thoraxController.text}${_isMechanicalVentilation ? " [VM: SI | Modo: ${_mvModeController.text} | PEEP: ${_peepController.text} | Vt: ${_tvController.text} | FR: ${_mvFrController.text} | P.Sop: ${_pressureSupportController.text}]" : ""}',
          'CV': _cvController.text,
          'Hemodinamia': _selectedHemodynamics ?? '',
          'Abdomen': _abdomenController.text,
          'GU': _guController.text,
          'Locomotor': _locomotorController.text,
        },
        diagnosis: _dxController.text,
        
        sofaScore: _sofaController.text,
        apacheScore: _apacheController.text,
        nutricScore: _nutricController.text,
        
        plan: planForPdf,
        procedures: proceduresForPdf,
        preparedByName: preparedByName,
        preparedByRole: preparedByRole,
        secondarySignatureName: secondarySignatureName,
        secondarySignatureRole: secondarySignatureRole,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error generando PDF: $e'), backgroundColor: Colors.red));
    }
  }

  void _populatePatientData(Patient p) {
    setState(() {
      _nameController.text = p.name;
      _dniController.text = p.dni;
      _hcController.text = p.hc;
      _ageController.text = p.age.toString();
      // _selectedBirthDate = p.birthDate; // Not in DB model currently, simplifying
      _selectedSex = p.sex;
      if (p.address != null) _addressController.text = p.address!;
      if (p.occupation != null) _occupationController.text = p.occupation!;
      if (p.familyContact != null) _familyController.text = p.familyContact!;
      if (p.phone != null) _phoneController.text = p.phone!;
      if (p.placeOfBirth != null) _placeOfBirthController.text = p.placeOfBirth!;
      if (p.insuranceType != null) _insuranceTypeController.text = p.insuranceType!;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.history, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text('¡Re-ingreso detectado! Datos de ${p.name} importados.')),
          ],
        ),
        backgroundColor: Colors.indigo.shade900,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _updateDraftProcedures(List<DraftProcedure> drafts) {
    setState(() {
      _draftProcedures
        ..clear()
        ..addAll(drafts);
    });
  }

  void _loadPlanFromStoredText(String? storedPlan) {
    _assistantSupervisorController.clear();
    if (storedPlan == null || storedPlan.isEmpty) {
      _planController.text = '';
      return;
    }
    final match = _sessionHeaderRegex.firstMatch(storedPlan);
    if (match != null) {
      final supervisor = match.group(3)?.trim();
      if (supervisor != null && supervisor.isNotEmpty) {
        _assistantSupervisorController.text = supervisor;
      }
      storedPlan = storedPlan.substring(match.end);
    }
    _planController.text = storedPlan.trimLeft();
  }

  Future<String> _buildProceduresNarrativeText({bool includeDrafts = false}) async {
    final entries = <ProcedureNarrativeEntry>[];
    if (_localAdmissionId != null) {
      final query = appDatabase.select(appDatabase.performedProcedures)
        ..where((t) => t.admissionId.equals(_localAdmissionId!))
        ..where((t) => t.origin.equals('ingreso'));
      final stored = await query.get();
      entries.addAll(stored.map(
        (p) => ProcedureNarrativeEntry(
          procedureName: p.procedureName,
          performedAt: p.performedAt,
          assistant: p.assistant,
          resident: p.resident,
          guardia: p.guardia,
          note: p.note,
        ),
      ));
    }
    if (includeDrafts && _draftProcedures.isNotEmpty) {
      entries.addAll(_draftProcedures.map(
        (draft) => ProcedureNarrativeEntry(
          procedureName: draft.procedureName,
          performedAt: draft.performedAt,
          assistant: draft.assistant,
          resident: draft.resident,
          guardia: draft.guardia,
          note: draft.note,
        ),
      ));
    }
    return buildProcedureNarrative(
      generalNotes: _proceduresController.text,
      entries: entries,
    );
  }

  String _buildPlanWithSessionHeader() {
    String planBody = _planController.text.trim();
    final headerMatch = _sessionHeaderRegex.firstMatch(planBody);
    if (headerMatch != null) {
      planBody = planBody.substring(headerMatch.end).trimLeft();
    }
    String? header;
    if (_isResidentSession) {
      final segments = <String>['Sesión: Residente'];
      final name = _currentProfile?.fullName?.trim();
      if (name != null && name.isNotEmpty) {
        segments.add('Médico tratante: $name');
      }
      final supervisor = _assistantSupervisorController.text.trim();
      if (supervisor.isNotEmpty) {
        segments.add('Asistente responsable: $supervisor');
      }
      header = '[${segments.join(' | ')}]';
    } else if (_isAssistantSession) {
      final name = _currentProfile?.fullName?.trim();
      if (name != null && name.isNotEmpty) {
        header = '[Sesión: Asistente | Médico tratante: $name]';
      }
    }
    if (header != null && header.isNotEmpty) {
      return header + (planBody.isNotEmpty ? '\n\n$planBody' : '');
    }
    return planBody;
  }

  void _updateDiagnosticPlan(List<String> newPending) {
    if (newPending.isEmpty) return;
    
    final List<String> reallyNew = [];
    for (var item in newPending) {
      if (!_pendingExams.contains(item)) {
        _pendingExams.add(item);
        reallyNew.add(item);
      }
    }

      if (reallyNew.isNotEmpty) {
      final String addition = reallyNew.map((e) => '- Solicitar $e').join('\n');
      if (_planController.text.isNotEmpty) {
        _planController.text += '\n$addition';
      } else {
        _planController.text = addition;
      }
    }
  }

  @override
  void dispose() {
    _assistantSupervisorController.removeListener(_onSupervisorChanged);
    _assistantSupervisorController.dispose();
    super.dispose();
  }
}
