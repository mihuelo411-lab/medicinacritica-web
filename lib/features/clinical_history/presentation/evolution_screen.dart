import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import 'package:intl/intl.dart';
import '../../../../main.dart';
import '../../../../core/database/database.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../../core/services/sync_service.dart';
import 'pdf/evolution_pdf_generator.dart';
import '../../patients/presentation/widgets/admission_dx_form.dart';
import '../../patients/presentation/widgets/score_calculators_dialog.dart';
import '../../dashboard/data/cie10_service.dart';
import '../../common/presentation/procedure_selector_widget.dart';
import '../../common/utils/procedure_narrative_builder.dart';
import '../../auth/domain/current_user.dart';
import '../../auth/domain/profile.dart';

class EvolutionScreen extends StatefulWidget {
  final int bedNumber;
  const EvolutionScreen({super.key, required this.bedNumber});

  @override
  State<EvolutionScreen> createState() => _EvolutionScreenState();
}

class _EvolutionScreenState extends State<EvolutionScreen> {
  // Data State
  bool _isLoading = true;
  Admission? _admission;
  Patient? _patient;
  final Cie10Service _cie10Service = Cie10Service();
  String _guardia = 'Guardia Diurna';
  TimeOfDay _noteTime = TimeOfDay.now();
  bool _vmActive = true;
  int _vmDays = 0;
  bool _vasoactivesActive = false;
  final List<String> _vmModes = const [
    'V-CMV',
    'PC-CMV',
    'A/C',
    'SIMV',
    'PSV',
    'CPAP',
    'BIPAP',
    'HFNC',
    'Tubo T'
  ];
  
  // --- CONTROLLERS ---
  
  // Diagnosis
  final _dxController = TextEditingController();

  // Vitals
  final _paController = TextEditingController();
  final _pamController = TextEditingController();
  final _fcController = TextEditingController();
  final _frController = TextEditingController();
  final _frTotalController = TextEditingController(); // FR medida
  final _tempController = TextEditingController();
  final _satController = TextEditingController();
  final _fio2Controller = TextEditingController(); // Also in VM but this is measured
  final _pao2Controller = TextEditingController(); // PaO2 arterial
  final _pafiController = TextEditingController(); // Calculated PaFi
  final _vtExpController = TextEditingController(); // Volumen tidal espirado
  
  // VM Settings
  final _vmModeController = TextEditingController();
  final _vmVtController = TextEditingController(); // Tidal Volume Set
  final _vmFrSetController = TextEditingController();
  final _vmPeepController = TextEditingController();
  final _vmFio2SetController = TextEditingController();
  final _vmTriggerController = TextEditingController();
  final _vmFlowController = TextEditingController();

  // VM Mechanics (Monitor)
  final _pPeakController = TextEditingController();
  final _pPlateauController = TextEditingController();
  final _cStatController = TextEditingController(); // Compliance
  final _drivingPressureController = TextEditingController(); // DP

  // SOAP
  final _subjectiveController = TextEditingController();
  
  // Objective (Systems)
  final _neuroController = TextEditingController();
  final _hemoController = TextEditingController();
  final _cardioController = TextEditingController(); // Ruidos, Soplos
  final _respExamController = TextEditingController(); // Murmullo
  final _digestiveController = TextEditingController();
  final _osteoController = TextEditingController();
  final _renalController = TextEditingController();
  final _infectiousController = TextEditingController(); // Cultivos, Curvas febriles
  final _othersController = TextEditingController();
  final _diuresisController = TextEditingController();
  final _balanceController = TextEditingController();
  final _sofaScoreController = TextEditingController();
  final _apacheScoreController = TextEditingController();
  final _nutricScoreController = TextEditingController();

  final _analysisController = TextEditingController();
  final _planController = TextEditingController();
  final _procedureNotesController = TextEditingController();
  final Set<TextEditingController> _prefilledControllers = {};
  bool get _isDayShift => _guardia == 'Guardia Diurna';
  UserProfile? _currentProfile;
  bool get _isResidentSession => _currentProfile?.role == 'residente';
  bool get _isAssistantSession =>
      _currentProfile?.role == 'medico' || _currentProfile?.role == 'admin';
  final PhysiologicalData _physiology = PhysiologicalData();
  void _applyVentDynamicsToResp() {
    if (!_vmActive) {
      setState(() {
        _respExamController.text = 'Paciente sin VM en este turno (respiración espontánea).';
      });
      return;
    }
    final parts = <String>[];

    void addVal(String label, TextEditingController c, {String suffix = ''}) {
      if (c.text.trim().isNotEmpty) {
        parts.add('$label ${c.text.trim()}$suffix');
      }
    }

    addVal('Modo', _vmModeController);
    addVal('VT', _vmVtController, suffix: ' ml');
    addVal('VT esp', _vtExpController, suffix: ' ml');
    addVal('FR set', _vmFrSetController, suffix: ' rpm');
    addVal('FR total', _frTotalController, suffix: ' rpm');
    addVal('PEEP', _vmPeepController, suffix: ' cmH2O');
    addVal('FiO2', _vmFio2SetController, suffix: '%');
    addVal('PaFi', _pafiController);
    addVal('Trigger/Flow', _vmFlowController);

    // Mecánica
    addVal('Ppico', _pPeakController);
    addVal('Pplat', _pPlateauController);
    addVal('Cstat', _cStatController);

    double? dpVal;
    if (_drivingPressureController.text.trim().isNotEmpty) {
      dpVal = double.tryParse(_drivingPressureController.text.trim());
      addVal('DP', _drivingPressureController);
    } else {
      final pplat = double.tryParse(_pPlateauController.text.trim());
      final peep = double.tryParse(_vmPeepController.text.trim());
      if (pplat != null && peep != null) {
        dpVal = pplat - peep;
        parts.add('DP ${dpVal.toStringAsFixed(1)}');
      }
    }

    final suggestions = <String>[];
    final pplatVal = double.tryParse(_pPlateauController.text.trim());
    final cstatVal = double.tryParse(_cStatController.text.trim());
    final pafiVal = double.tryParse(_pafiController.text.trim());
    if (dpVal != null && dpVal > 15) {
      suggestions.add('DP alta, considere reducir VT/PEEP');
    }
    if (pplatVal != null && pplatVal > 30) {
      suggestions.add('Pplat >30, proteja pulmón');
    }
    if (cstatVal != null && cstatVal < 30) {
      suggestions.add('Cstat baja, evaluar reclutamiento o ajuste de PEEP');
    }
    if (pafiVal != null && pafiVal < 200) {
      suggestions.add('PaFi <200, vigilar estrategia de oxigenación');
    }

    final text = StringBuffer();
    if (parts.isNotEmpty) {
      text.write('Ventilatorio: ${parts.join(', ')}.');
    }
    if (suggestions.isNotEmpty) {
      text.write(' Sugerencias: ${suggestions.join('; ')}.');
    }

    setState(() {
      _respExamController.text = text.toString();
    });
  }

  @override
  void initState() {
    super.initState();
    _currentProfile = CurrentUserStore.profile;
    _cie10Service.loadData();
    _loadPatientData();
    _dxController.addListener(() {
      if (mounted) setState(() {});
    });
    _paController.addListener(_updatePamFromPa);
    _pao2Controller.addListener(_updatePaFi);
    _fio2Controller.addListener(_updatePaFi);
  }

  void _updatePaFi() {
    final pao2 = double.tryParse(_pao2Controller.text.replaceAll(',', '.').trim());
    final fio2Raw = _fio2Controller.text.replaceAll(',', '.').trim();
    final fio2 = double.tryParse(fio2Raw.endsWith('%') ? fio2Raw.substring(0, fio2Raw.length - 1) : fio2Raw);
    if (pao2 != null && fio2 != null && fio2 > 0) {
      final denominator = fio2 > 1 ? (fio2 / 100) : fio2;
      if (denominator > 0) {
        final pafi = pao2 / denominator;
        if (mounted) {
          setState(() {
            _pafiController.text = pafi.toStringAsFixed(0);
          });
        }
        return;
      }
    }
    if (mounted) {
      setState(() {
        _pafiController.clear();
      });
    }
  }

  void _updatePamFromPa() {
    final text = _paController.text.trim();
    final matches = RegExp(r'\d{2,3}').allMatches(text).toList();
    if (matches.length >= 2) {
      final sys = int.tryParse(matches[0].group(0)!);
      final dia = int.tryParse(matches[1].group(0)!);
      if (sys != null && dia != null) {
        final pam = (sys + 2 * dia) / 3;
        if (mounted) {
          setState(() {
            _pamController.text = pam.toStringAsFixed(0);
          });
        }
        return;
      }
    }
    if (mounted) {
      setState(() {
        _pamController.clear();
      });
    }
  }

  bool _isVmActiveFromJson(String? jsonStr) {
    if (jsonStr == null || jsonStr.isEmpty) return true;
    try {
      final map = jsonDecode(jsonStr) as Map<String, dynamic>;
      final val = map['VM_Activa'];
      if (val is bool) return val;
      if (val is String) return val == '1' || val.toLowerCase() == 'true';
    } catch (_) {}
    return true;
  }

  Future<int> _computeVmDays({bool includeTodayVm = false}) async {
    final evoList = await (appDatabase.select(appDatabase.evolutions)
          ..where((t) => t.admissionId.equals(_admission!.id))
          ..orderBy([(t) => drift.OrderingTerm.desc(t.date)]))
        .get();
    final Set<DateTime> days = {};
    for (final ev in evoList) {
      if (_isVmActiveFromJson(ev.vmSettingsJson)) {
        final d = DateTime(ev.date.year, ev.date.month, ev.date.day);
        days.add(d);
      }
    }
    if (includeTodayVm) {
      final today = DateTime.now();
      days.add(DateTime(today.year, today.month, today.day));
    }
    return days.length;
  }

  Future<void> _loadPatientData() async {
    // 1. Find Active Admission for Bed
    final activeAdmissions = await (appDatabase.select(appDatabase.admissions)
      ..where((t) => t.bedNumber.equals(widget.bedNumber))
      ..where((t) => t.dischargedAt.isNull())
      ..limit(1))
      .get();

    if (activeAdmissions.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No hay paciente activo en esta cama')));
        Navigator.pop(context);
      }
      return;
    }

    _admission = activeAdmissions.first;
    _vasoactivesActive = false;
    
    // 2. Load Patient Details
    _patient = await (appDatabase.select(appDatabase.patients)
      ..where((t) => t.id.equals(_admission!.patientId)))
      .getSingle();
      
    // 3. Pre-fill Diagnosis (if evolutions exist, use last; else admission dx)
    final lastEvolution = await (appDatabase.select(appDatabase.evolutions)
          ..where((t) => t.admissionId.equals(_admission!.id))
          ..orderBy([(t) => drift.OrderingTerm.desc(t.date)])
          ..limit(1))
        .get();
    _prefilledControllers.clear();
    if (lastEvolution.isNotEmpty && lastEvolution.first.diagnosis != null) {
      _dxController.text = lastEvolution.first.diagnosis!;
    } else {
      _dxController.text = _admission?.diagnosis ?? '';
    }
    // VM active flag and vm days
    if (lastEvolution.isNotEmpty) {
      _vmActive = _isVmActiveFromJson(lastEvolution.first.vmSettingsJson);
    } else {
      _vmActive = true;
    }
    _vmDays = await _computeVmDays(includeTodayVm: _vmActive);
    if (lastEvolution.isNotEmpty) {
      final ev = lastEvolution.first;
      void setCtl(TextEditingController c, String? val) {
        if (val != null && val.isNotEmpty) {
          c.text = val;
          _prefilledControllers.add(c);
        }
      }

      setCtl(_subjectiveController, ev.subjective);
      setCtl(_analysisController, ev.analysis);
      setCtl(_planController, ev.plan);
      setCtl(_procedureNotesController, ev.proceduresNote);
      // Objective json
      if (ev.objectiveJson != null && ev.objectiveJson!.isNotEmpty) {
        try {
          final map = jsonDecode(ev.objectiveJson!) as Map<String, dynamic>;
          setCtl(_neuroController, map['Neuro'] as String?);
          setCtl(_hemoController, map['Hemo'] as String?);
          setCtl(_cardioController, map['Cardio'] as String?);
          setCtl(_respExamController, map['Resp'] as String?);
          setCtl(_digestiveController, map['Digest'] as String?);
          setCtl(_osteoController, map['Osteo'] as String?);
          setCtl(_renalController, map['Renal'] as String?);
          setCtl(_infectiousController, map['Infec'] as String?);
          setCtl(_othersController, map['Otros'] as String?);
          setCtl(_diuresisController, map['Diuresis'] as String?);
          setCtl(_balanceController, map['Balance'] as String?);
          final scoresRaw = map['Scores'];
          if (scoresRaw is String) {
            _prefillScoresFromSummary(scoresRaw);
          }
          final bool? vasoFlag = _parseVasoactivesValue(map['Vasoactivos']?.toString());
          if (vasoFlag != null) {
            _vasoactivesActive = vasoFlag;
          }
        } catch (_) {}
      }
    }

    _prefillScoresFromAdmission();

    setState(() {
      _isLoading = false;
      _noteTime = TimeOfDay.fromDateTime(DateTime.now());
    });
  }

  Future<void> _saveOnly() async {
    if (_admission == null) return;
    
    setState(() => _isLoading = true);
    try {
      final computedVmDays = await _computeVmDays(includeTodayVm: _vmActive);
      _vmDays = computedVmDays;

      await appDatabase.into(appDatabase.evolutions).insert(
        EvolutionsCompanion(
          admissionId: drift.Value(_admission!.id),
          date: drift.Value(DateTime.now()),
          vitalsJson: drift.Value(jsonEncode(_packVitals())),
          vmSettingsJson: drift.Value(jsonEncode(_packVmSettings(computedVmDays))),
          vmMechanicsJson: drift.Value(jsonEncode(_packMechanics())),
          subjective: drift.Value(_subjectiveController.text),
          objectiveJson: drift.Value(jsonEncode(_packObjective())),
          analysis: drift.Value(_analysisController.text),
          plan: drift.Value(_planController.text),
          proceduresNote: drift.Value(_procedureNotesController.text),
          diagnosis: drift.Value(_dxController.text),
          authorName: drift.Value(_currentProfile?.fullName?.trim()),
          authorRole: drift.Value(_deriveRoleLabel(_currentProfile?.role)),
          isSynced: const drift.Value(false),
        )
      );

      // Sync best-effort to Supabase (no bloqueante)
      await _syncEvolutionToSupabase(
        vmDays: computedVmDays,
        vmActive: _vmActive,
        proceduresNote: _procedureNotesController.text,
      );
      await _forceFullSync();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Evolución guardada.'), backgroundColor: Colors.green));
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al guardar: $e'), backgroundColor: Colors.red));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _printOnly() async {
    if (_admission == null) return;
    
    final now = DateTime.now();
    final noteDateTime = DateTime(now.year, now.month, now.day, _noteTime.hour, _noteTime.minute);

    final computedVmDays = await _computeVmDays(includeTodayVm: _vmActive);
    _vmDays = computedVmDays;

    final proceduresText = await _buildProceduresNarrativeForGuardia(
      _guardia,
      generalNotesOverride: _procedureNotesController.text,
    );
    final preparedByName = _currentProfile?.fullName?.trim();
    final preparedByRole = _deriveRoleLabel(_currentProfile?.role);

    await EvolutionPdfGenerator.generateAndPrint(
      patient: _patient!, 
      admission: _admission!,
      currentDiagnosis: _dxController.text,
      vitals: _packVitals(), 
      vmSettings: _packVmSettings(computedVmDays), 
      vmMechanics: _packMechanics(), 
      subjective: _subjectiveController.text, 
      objective: _packObjective(), 
      analysis: _analysisController.text, 
      plan: _planController.text,
      guardia: _guardia,
      noteDateTime: noteDateTime,
      procedures: proceduresText,
      preparedByName: preparedByName,
      preparedByRole: preparedByRole,
    );
  }

  // Helper Packing Methods
  Map<String, String> _packVitals() => {
    'PA': _paController.text,
    'PAM': _pamController.text,
    'FC': _fcController.text,
    'FR': _frController.text,
    'T': _tempController.text,
    'SatO2': _satController.text,
    'FiO2': _fio2Controller.text,
    'PaO2': _pao2Controller.text,
    'PaFi': _pafiController.text,
    'VTesp': _vtExpController.text,
  };
  
  Map<String, String> _packVmSettings(int vmDays) => {
    'VM_Activa': _vmActive ? '1' : '0',
    'VM_Days': vmDays.toString(),
    'Guardia': _guardia,
    'Mode': _vmModeController.text,
    'Vt': _vmVtController.text,
    'FR_Set': _vmFrSetController.text,
    'PEEP': _vmPeepController.text,
    'FiO2_Set': _vmFio2SetController.text,
    'Trigger': _vmTriggerController.text,
    'Flow': _vmFlowController.text,
    'BalanceNum': _parseBalanceNumeric(),
  };

  Map<String, String> _packMechanics() => {
    'Ppeak': _pPeakController.text, 'Pplateau': _pPlateauController.text,
    'Cstat': _cStatController.text, 'DP': _drivingPressureController.text
  };

  Future<String> _buildProceduresNarrativeForGuardia(
    String? guardiaValue, {
    String? generalNotesOverride,
  }) async {
    final admission = _admission;
    if (admission == null) return '';
    final query = appDatabase.select(appDatabase.performedProcedures)
      ..where((t) => t.admissionId.equals(admission.id))
      ..where((t) => t.origin.equals('evolucion'));
    final guardiaTrimmed = guardiaValue?.trim();
    if (guardiaTrimmed != null && guardiaTrimmed.isNotEmpty) {
      query.where((t) => t.guardia.equals(guardiaTrimmed));
    } else {
      query.where((t) => t.guardia.isNull());
    }
    final rows = await query.get();
    if (rows.isEmpty && (generalNotesOverride == null || generalNotesOverride.trim().isEmpty)) {
      return '';
    }
    final generalNotes = generalNotesOverride?.trim();
    return buildProcedureNarrative(
      generalNotes: generalNotes,
      entries: rows.map((p) => ProcedureNarrativeEntry(
        procedureName: p.procedureName,
        performedAt: p.performedAt,
        assistant: p.assistant,
        resident: p.resident,
        guardia: p.guardia,
        note: p.note,
      )),
    );
  }

  Future<void> _syncEvolutionToSupabase({
    required int vmDays,
    required bool vmActive,
    String? proceduresNote,
  }) async {
    try {
      await SupabaseService().createEvolution(
        admissionId: _admission!.id,
        date: DateTime.now(),
        vitals: _packVitals(),
        vmSettings: _packVmSettings(vmDays),
        vmMechanics: _packMechanics(),
        objective: _packObjective(),
        subjective: _subjectiveController.text,
        analysis: _analysisController.text,
        plan: _planController.text,
        diagnosis: _dxController.text,
        authorName: _currentProfile?.fullName?.trim(),
        authorRole: _deriveRoleLabel(_currentProfile?.role),
        vmDays: vmDays,
        vmActive: vmActive,
        proceduresNote: proceduresNote,
      );
    } catch (e) {
      // No bloquear el flujo local si falla la nube
      debugPrint('Supabase sync evolution failed: $e');
    }
  }

  Future<void> _forceFullSync() async {
    try {
      final syncService = SyncService(appDatabase, SupabaseService());
      await syncService.syncAll();
    } catch (e) {
      debugPrint('Full Supabase sync failed: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No se pudo sincronizar con Supabase: $e'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  String? _deriveRoleLabel(String? roleCode) {
    if (roleCode == null) return null;
    switch (roleCode.toLowerCase()) {
      case 'residente':
        return 'MÉDICO RESIDENTE';
      case 'medico':
      case 'admin':
        return 'MÉDICO ASISTENTE';
      default:
        return null;
    }
  }
  
  Map<String, String> _packObjective() {
    final map = <String, String>{
      'Neuro': _neuroController.text,
      'Hemo': _hemoController.text,
      'Cardio': _cardioController.text,
      'Resp': _respExamController.text,
      'Digest': _digestiveController.text,
      'Osteo': _osteoController.text,
      'Renal': _renalController.text,
      'Infec': _infectiousController.text,
      'Diuresis': _diuresisController.text,
      'Balance': _balanceController.text,
      'Otros': _othersController.text,
    };
    map['Vasoactivos'] = _vasoactivesActive ? 'En uso' : 'Suspendidos';
    final scores = _buildScoresSummary();
    if (scores.isNotEmpty) {
      map['Scores'] = scores;
    }
    return map;
  }

  String _parseBalanceNumeric() {
    final txt = _balanceController.text.replaceAll(',', '.');
    final numVal = double.tryParse(RegExp(r'-?\\d+(\\.\\d+)?').stringMatch(txt) ?? '');
    return numVal?.toStringAsFixed(1) ?? '';
  }

  bool? _parseVasoactivesValue(String? raw) {
    if (raw == null) return null;
    final normalized = raw.toLowerCase().trim();
    if (normalized.isEmpty) return null;
    if (normalized == '1' || normalized == 'true' || normalized == 'sí' || normalized == 'si') {
      return true;
    }
    if (normalized == '0' || normalized == 'false') {
      return false;
    }
    if (normalized.contains('sin') || normalized.contains('suspend')) return false;
    if (normalized.contains('uso') || normalized.contains('activo')) return true;
    return null;
  }

String _buildScoresSummary() {
    final parts = <String>[];
    void addPart(String label, TextEditingController ctl) {
      final val = ctl.text?.trim();
      if (val != null && val.isNotEmpty) parts.add('$label: $val');
    }

    addPart('SOFA', _sofaScoreController);
    addPart('APACHE', _apacheScoreController);
    addPart('NUTRIC', _nutricScoreController);
    return parts.join(' | ');
  }

  void _prefillScoresFromSummary(String? raw) {
    if (raw == null || raw.isEmpty) return;
    void setScore(TextEditingController ctl, String? value) {
      if (value != null && value.isNotEmpty) {
        ctl.text = value;
        _prefilledControllers.add(ctl);
      }
    }

    setScore(_sofaScoreController, _extractScoreValue(raw, 'SOFA'));
    setScore(_apacheScoreController, _extractScoreValue(raw, 'APACHE'));
    setScore(_nutricScoreController, _extractScoreValue(raw, 'NUTRIC'));
  }

  void _prefillScoresFromAdmission() {
    if (_admission == null) return;
    void setIfEmpty(TextEditingController ctl, double? value) {
      if (ctl.text.trim().isEmpty && value != null) {
        ctl.text = value.toStringAsFixed(1);
      }
    }

    setIfEmpty(_sofaScoreController, _admission!.sofaScore);
    setIfEmpty(_apacheScoreController, _admission!.apacheScore);
    setIfEmpty(_nutricScoreController, _admission!.nutricScore);
  }

  String? _extractScoreValue(String source, String label) {
    final regex = RegExp('$label\\s*: ?(\\d+(?:\\.\\d+)?)', caseSensitive: false);
    final match = regex.firstMatch(source);
    return match?.group(1);
  }

  int? _parseNumericScore(TextEditingController controller) {
    final match = RegExp(r'(\\d+)').firstMatch(controller.text);
    if (match != null) {
      return int.tryParse(match.group(1)!);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      appBar: AppBar(
        title: Text('Evolución: Cama ${widget.bedNumber} - ${_patient?.name ?? ""}'),
        actions: [
          IconButton(onPressed: _printOnly, icon: const Icon(Icons.print), tooltip: 'Imprimir Actual'),
        ],
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // LEFT PANEL: METRICS (30%)
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.grey.shade50,
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle(context, 'FUNCIONES VITALES'),
                    _buildGridInputs([
                      _InputDef('PA', _paController),
                      _InputDef('PAM', _pamController),
                      _InputDef('FC', _fcController),
                      _InputDef('FR', _frController),
                      _InputDef('Temp', _tempController),
                      _InputDef('SatO2', _satController),
                      _InputDef('FiO2 %', _fio2Controller),
                      _InputDef('PaO2', _pao2Controller),
                      _InputDef('PaFi', _pafiController),
                    ]),
                    const Divider(height: 32),
                    
                    _buildSectionTitle(context, 'VENTILACIÓN MECÁNICA'),
                    Row(
                      children: [
                        const Text('Ventilación mecánica activa'),
                        const Spacer(),
                        Switch(
                          value: _vmActive,
                          onChanged: (val) {
                            setState(() {
                              _vmActive = val;
                              if (!val) {
                                _vmModeController.clear();
                              } else if (_vmModeController.text.isEmpty && _vmModes.isNotEmpty) {
                                _vmModeController.text = _vmModes.first;
                              }
                            });
                          },
                        ),
                      ],
                    ),
                    DropdownButtonFormField<String>(
                      value: _vmModeController.text.isNotEmpty ? _vmModeController.text : (_vmModes.isNotEmpty ? _vmModes.first : null),
                      onChanged: _vmActive
                          ? (val) => setState(() => _vmModeController.text = val ?? '')
                          : null,
                      items: _vmModes.map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                      decoration: const InputDecoration(
                        labelText: 'Modo',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildGridInputs([
                      _InputDef('Vt (ml)', _vmVtController, enabled: _vmActive),
                      _InputDef('FR (Set)', _vmFrSetController, enabled: _vmActive),
                      _InputDef('PEEP', _vmPeepController, enabled: _vmActive),
                      _InputDef('FiO2 (Set)', _vmFio2SetController, enabled: _vmActive),
                      _InputDef('Trigger', _vmTriggerController, enabled: _vmActive),
                      _InputDef('Flujo/I:E', _vmFlowController, enabled: _vmActive),
                    ]),
                    const Divider(height: 32),

                    _buildSectionTitle(context, 'MECÁNICA VENTILATORIA'),
                    _buildGridInputs([
                      _InputDef('P. Pico', _pPeakController, enabled: _vmActive),
                      _InputDef('P. Plateau', _pPlateauController, enabled: _vmActive),
                      _InputDef('C. Stat', _cStatController, enabled: _vmActive),
                      _InputDef('Driving P.', _drivingPressureController, enabled: _vmActive),
                    ]),
                  ],
                ),
              ),
            ),
          ),
          const VerticalDivider(width: 1),
          // RIGHT PANEL: SOAP (70%)
          Expanded(
            flex: 7,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderCard(),
                   // Header Info
                  Card(
                    color: Colors.blue.shade50,
                    elevation: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                            Text("PACIENTE: ${_patient?.name} (${_patient?.age} años)", style: Theme.of(context).textTheme.titleMedium),
                           const SizedBox(height: 8),
                           // Editable Diagnosis
                           AdmissionDxForm(
                              dxController: _dxController, 
                              cie10Service: _cie10Service,
                           ),
                           const SizedBox(height: 8),
                            Text("INGRESO UCI: ${DateFormat('dd/MM/yyyy HH:mm').format(_admission!.admissionDate)}", style: Theme.of(context).textTheme.bodySmall),
                            Text("FECHA ACT: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}", style: Theme.of(context).textTheme.bodySmall),
                         ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  if (_isDayShift) ...[
                    _buildScoresSection(),
                    const SizedBox(height: 16),
                  ],

                  _buildSoapHeader(context, 'S (SUBJETIVO)'),
                  TextField(
                    controller: _subjectiveController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: 'Evolución del estado, intercurrencias...',
                      filled: _prefilledControllers.contains(_subjectiveController),
                      fillColor: _prefillColor(_subjectiveController),
                    ),
                  ),
                  const SizedBox(height: 24),

                  _buildSoapHeader(context, 'O (OBJETIVO) - Examen Físico'),
                  _buildObjectiveSection('Neurológico', 'SAS, Glasgow, Pupilas...', _neuroController),
                  _buildObjectiveSection('Hemodinamia', 'Llenado capilar, Lactato, Vasopresores...', _hemoController),
                  _buildVasoactivesToggle(),
                  _buildObjectiveSection('Cardiovascular', 'Ruidos, Soplos...', _cardioController),
                  _buildRespiratoryObjective(),
                  _buildObjectiveSection('Digestivo', 'RHA, Abdomen, Residuo Gástrico...', _digestiveController),
                  _buildObjectiveSection('Renal', 'Diuresis (cc/kg/hr), Balance...', _renalController),
                  Row(
                    children: [
                      Expanded(child: _buildObjectiveSection('Diuresis', 'cc/kg/hr o total', _diuresisController)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildObjectiveSection('Balance hídrico', 'Balance neto (cc)', _balanceController)),
                    ],
                  ),
                  _buildObjectiveSection('Osteomuscular', 'Edemas, Escaras...', _osteoController),
                  _buildObjectiveSection('Infeccioso', 'Curva febril, Cultivos, Antibióticos (Días)...', _infectiousController),
                  _buildObjectiveSection('Otros', 'Hallazgos adicionales', _othersController),
                  
                  const SizedBox(height: 24),
                   _buildSoapHeader(context, 'A (ANÁLISIS)'),
                  TextField(
                    controller: _analysisController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: 'Interpretación, problemas activos...',
                      filled: _prefilledControllers.contains(_analysisController),
                      fillColor: _prefillColor(_analysisController),
                    ),
                  ),

                  const SizedBox(height: 24),
                   _buildSoapHeader(context, 'P (PLAN)'),
                  TextField(
                    controller: _planController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: 'Medidas terapéuticas, exámenes pendientes...',
                      filled: _prefilledControllers.contains(_planController),
                      fillColor: _prefillColor(_planController),
                    ),
                  ),

                  if (_admission != null) ...[
                    const SizedBox(height: 24),
                    _buildProceduresSection(context),
                  ],
                  
                  const SizedBox(height: 48),
                  
                  Row(
                    children: [
                       Expanded(
                         child: SizedBox(
                          height: 50,
                          child: ElevatedButton.icon(
                            onPressed: _saveOnly,
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white),
                            icon: const Icon(Icons.save),
                            label: const Text('GUARDAR'),
                          ),
                         ),
                       ),
                       const SizedBox(width: 24),
                       Expanded(
                         child: SizedBox(
                          height: 50,
                          child: ElevatedButton.icon(
                            onPressed: _printOnly,
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, foregroundColor: Colors.white),
                            icon: const Icon(Icons.print),
                            label: const Text('IMPRIMIR'),
                          ),
                         ),
                       ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSoapHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.indigo)),
    );
  }

  Widget _buildProceduresSection(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.healing, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Procedimientos del turno',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ProcedureSelectorWidget(
              admissionId: _admission?.id,
              origin: 'evolucion',
              guardia: _guardia,
              defaultAssistant: _isAssistantSession ? _currentProfile?.fullName : null,
              defaultResident: _isResidentSession ? _currentProfile?.fullName : null,
              showPersistedProcedures: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoresSection() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Scores pronósticos',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildScoreField(
                    'SOFA',
                    _sofaScoreController,
                    onTap: () async {
                      try {
                        final res = await ScoreCalculators.showSofaCalculator(context, data: _physiology);
                        if (res != null) {
                          setState(() {
                            _sofaScoreController.text = "${res['score']} (Mort: ${res['mortality']})";
                          });
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error SOFA: $e')));
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildScoreField(
                    'APACHE II',
                    _apacheScoreController,
                    onTap: () async {
                      try {
                        final res = await ScoreCalculators.showApacheCalculator(context, data: _physiology);
                        if (res != null) {
                          setState(() {
                            _apacheScoreController.text = "${res['score']} (Mort: ${res['mortality']})";
                          });
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error APACHE: $e')));
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildScoreField(
                    'NUTRIC',
                    _nutricScoreController,
                    onTap: () async {
                      final sofa = _parseNumericScore(_sofaScoreController);
                      final apache = _parseNumericScore(_apacheScoreController);
                      try {
                        final res = await ScoreCalculators.showNutricCalculator(context, sofa: sofa, apache: apache);
                        if (res != null) {
                          setState(() {
                            _nutricScoreController.text = '${res['score']} (${res['mortality']})';
                          });
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error NUTRIC: $e')));
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreField(String label, TextEditingController controller, {VoidCallback? onTap}) {
    return TextField(
      controller: controller,
      readOnly: true,
      canRequestFocus: false,
      enableInteractiveSelection: false,
      textAlign: TextAlign.center,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        suffixIcon: onTap != null ? const Icon(Icons.calculate, size: 16, color: Colors.indigo) : null,
      ),
    );
  }

  Color? _prefillColor(TextEditingController controller) {
    return _prefilledControllers.contains(controller) ? Colors.amber.shade50 : null;
  }

  Widget _buildHeaderCard() {
    final stayDays = _admission != null ? DateTime.now().difference(_admission!.admissionDate).inDays + 1 : 0;
    final hospitalStayDays = stayDays; // No fecha de ingreso hospital en modelo, usamos ingreso UCI como referencia
    final noteDate = DateTime.now();

    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                DropdownButton<String>(
                  value: _guardia,
                  items: const [
                    DropdownMenuItem(value: 'Guardia Diurna', child: Text('Guardia Diurna')),
                    DropdownMenuItem(value: 'Guardia Nocturna', child: Text('Guardia Nocturna')),
                  ],
                  onChanged: (val) => setState(() => _guardia = val ?? _guardia),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () async {
                    final picked = await showTimePicker(context: context, initialTime: _noteTime);
                    if (picked != null) setState(() => _noteTime = picked);
                  },
                  icon: const Icon(Icons.schedule),
                  label: Text('Hora ${_noteTime.format(context)}'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Paciente: ${_patient?.name ?? '-'}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text('Edad: ${_patient?.age != null ? '${_patient!.age} años' : '-'} • HC: ${_patient?.hc ?? "-"}'),
                      Text('VM: $_vmDays días'),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Fecha nota: ${DateFormat('dd/MM/yyyy').format(noteDate)} ${_noteTime.format(context)}'),
                      Text('Ingreso UCI: ${_admission != null ? DateFormat('dd/MM/yyyy HH:mm').format(_admission!.admissionDate) : "-"}'),
                      Text('Día de estancia UCI: $stayDays'),
                      Text('Día de estancia hospital: $hospitalStayDays'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProblemsCard() {
    return const SizedBox.shrink();
  }

  Widget _buildVasoactivesToggle() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            width: 100,
            child: Padding(
              padding: EdgeInsets.only(top: 12),
              child: Text('Vasoactivos', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: _vasoactivesActive ? Colors.orange.shade50 : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _vasoactivesActive ? Colors.orange.shade200 : Colors.grey.shade300,
                ),
              ),
              child: SwitchListTile(
                dense: true,
                title: Text(_vasoactivesActive ? 'En uso' : 'No utilizados'),
                subtitle: const Text('Marca si el paciente recibe soporte con aminas/vasopresores.'),
                secondary: Icon(Icons.bolt, color: _vasoactivesActive ? Colors.orange : Colors.grey),
                value: _vasoactivesActive,
                onChanged: (val) => setState(() => _vasoactivesActive = val),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                activeColor: Colors.orange,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildObjectiveSection(String title, String hint, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 100, child: Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          )),
          Expanded(
            child: TextField(
              controller: controller,
              maxLines: 2,
              minLines: 1,
              style: const TextStyle(fontSize: 13),
              decoration: InputDecoration(
                isDense: true,
                hintText: hint,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.all(12),
                filled: _prefilledControllers.contains(controller),
                fillColor: _prefillColor(controller),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRespiratoryObjective() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                width: 100,
                child: Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: Text('Respiratorio', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                ),
              ),
              Expanded(
                child: TextField(
                  controller: _respExamController,
                  maxLines: 2,
                  minLines: 1,
                  style: const TextStyle(fontSize: 13),
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: 'Murmullo vesicular, secreciones...',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.all(12),
                    filled: _prefilledControllers.contains(_respExamController),
                    fillColor: _prefillColor(_respExamController),
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: _applyVentDynamicsToResp,
              icon: const Icon(Icons.auto_awesome, size: 16),
              label: const Text('Auto rellenar dinámica ventilatoria'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.blueGrey),
      ),
    );
  }

  Widget _buildGridInputs(List<_InputDef> inputs) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: inputs.map((e) => SizedBox(
        width: 80,
        child: TextField(
          controller: e.controller,
          textAlign: TextAlign.center,
          enabled: e.enabled,
          decoration: InputDecoration(
            labelText: e.label,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            filled: true,
            fillColor: e.enabled ? Colors.white : Colors.grey.shade200,
          ),
          style: const TextStyle(fontSize: 12),
        ),
      )).toList(),
    );
  }
}

class _InputDef {
  final String label;
  final TextEditingController controller;
  final bool enabled;
  _InputDef(this.label, this.controller, {this.enabled = true});
}
