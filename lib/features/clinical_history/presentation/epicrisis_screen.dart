import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:drift/drift.dart' as drift;

import '../../../../core/database/database.dart';
import '../../../../main.dart';
import '../../auth/domain/current_user.dart';
import '../../patients/data/patient_repository.dart';
import 'pdf/epicrisis_pdf_generator.dart';

class EpicrisisScreen extends StatelessWidget {
  final ActiveAdmission activeAdmission;
  final Future<void> Function()? onDischarge;
  const EpicrisisScreen({super.key, required this.activeAdmission, this.onDischarge});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<_EpicrisisFormState>();
    final admission = activeAdmission.admission;
    final patient = activeAdmission.patient;
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Epicrisis'),
            Text(
              'Cama ${admission.bedNumber ?? '-'} • ${patient.name}',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
      body: EpicrisisForm(
        key: formKey,
        activeAdmission: activeAdmission,
        compact: false,
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            heroTag: 'print_epicrisis',
            icon: const Icon(Icons.print),
            label: const Text('IMPRIMIR'),
            onPressed: () => formKey.currentState?.printEpicrisis(context),
          ),
          const SizedBox(height: 12),
          FloatingActionButton.extended(
            heroTag: 'save_epicrisis',
            icon: const Icon(Icons.save),
            label: const Text('GUARDAR'),
            onPressed: () => formKey.currentState?.saveEpicrisis(context),
          ),
          if (onDischarge != null) ...[
            const SizedBox(height: 12),
              FloatingActionButton.extended(
                heroTag: 'save_discharge_epicrisis',
                icon: const Icon(Icons.local_hospital_outlined),
                label: const Text('GUARDAR Y DAR ALTA'),
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                onPressed: () async {
                  final success = await formKey.currentState?.saveEpicrisis(context, silent: true);
                  if (success == true) {
                    try {
                      await onDischarge!();
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Epicrisis registrada y alta completada')),
                      );
                      Navigator.of(context).pop(true);
                    } catch (error) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('No se completó el alta: $error')),
                      );
                    }
                  }
                },
              ),
            ],
        ],
      ),
    );
  }
}

class EpicrisisBoard extends StatelessWidget {
  final ActiveAdmission activeAdmission;
  const EpicrisisBoard({super.key, required this.activeAdmission});

  @override
  Widget build(BuildContext context) {
    return EpicrisisForm(
      activeAdmission: activeAdmission,
      compact: true,
    );
  }
}

class EpicrisisForm extends StatefulWidget {
  final ActiveAdmission activeAdmission;
  final bool compact;
  const EpicrisisForm({
    super.key,
    required this.activeAdmission,
    required this.compact,
  });

  @override
  State<EpicrisisForm> createState() => _EpicrisisFormState();
}

class _EpicrisisFormState extends State<EpicrisisForm> {
  final _servicioEgresoCtl = TextEditingController(text: 'Unidad de Cuidados Intensivos');
  final _diagIngresoCtl = TextEditingController();
  final _diagEgresoCtl = TextEditingController();
  final _anamnesisCtl = TextEditingController();
  final _examenClinicoCtl = TextEditingController();
  final _examenAuxCtl = TextEditingController();
  final _evolucionCtl = TextEditingController();
  final _procedimientosCtl = TextEditingController();
  final _transferDestinoCtl = TextEditingController();
  final _firmaCtl = TextEditingController(text: 'Médico tratante');
  final _pieCtl = TextEditingController(text: 'Epicrisis emitida según normativa del servicio.');
  final _mortFinalCtl = TextEditingController();
  final _mortInterCtl = TextEditingController();
  final _mortBasicaCtl = TextEditingController();

  final List<_MedicationRow> _medications = [];
  String _transferType = 'Domiciliaria';
  String _condicionAlta = 'Mejorado';
  String _pronostico = 'Reservado';
  bool _autopsia = false;
  bool _loading = true;
  bool _saving = false;
  int _totalStayDays = 0;
  int _icuStayDays = 0;
  int? _existingNoteId;

  @override
  void initState() {
    super.initState();
    _medications.add(_MedicationRow());
    _computeStays();
    final profile = CurrentUserStore.profile;
    if (profile?.fullName != null && profile!.fullName!.isNotEmpty) {
      _firmaCtl.text = profile.fullName!;
    }
    _loadEpicrisisData();
  }

  void _computeStays() {
    final admission = widget.activeAdmission.admission;
    final now = DateTime.now();
    _totalStayDays = now.difference(admission.admissionDate).inDays + 1;
    _icuStayDays = now.difference(admission.createdAt).inDays + 1;
  }

  Future<void> _loadEpicrisisData() async {
    final admissionId = widget.activeAdmission.admission.id;
    final note = await (appDatabase.select(appDatabase.epicrisisNotes)
          ..where((tbl) => tbl.admissionId.equals(admissionId))
          ..orderBy([(tbl) => drift.OrderingTerm.desc(tbl.updatedAt)])
          ..limit(1))
        .getSingleOrNull();
    if (note != null) {
      _existingNoteId = note.id;
      _applyPayload(note.payload);
    } else {
      await _prefillFromClinicalHistory();
    }
    if (mounted) {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _prefillFromClinicalHistory() async {
    final admission = widget.activeAdmission.admission;
    _diagIngresoCtl.text = admission.diagnosis ?? '';
    _anamnesisCtl.text = [
      admission.signsSymptoms,
      admission.story,
      admission.illnessCourse,
    ].whereType<String>().where((value) => value.trim().isNotEmpty).join('\n\n');
    _procedimientosCtl.text = admission.procedures ?? '';
    _diagEgresoCtl.text = _diagIngresoCtl.text;
    final lastEvolution = await (appDatabase.select(appDatabase.evolutions)
          ..where((tbl) => tbl.admissionId.equals(admission.id))
          ..orderBy([(tbl) => drift.OrderingTerm.desc(tbl.date)])
          ..limit(1))
        .getSingleOrNull();
    if (lastEvolution != null) {
      _examenClinicoCtl.text = _flattenObjective(lastEvolution.objectiveJson) ?? admission.physicalExam ?? '';
      _evolucionCtl.text = lastEvolution.analysis ?? '';
      if ((lastEvolution.diagnosis ?? '').trim().isNotEmpty) {
        _diagEgresoCtl.text = lastEvolution.diagnosis!;
      }
    } else {
      _examenClinicoCtl.text = admission.physicalExam ?? '';
    }
  }

  void _applyPayload(String raw) {
    try {
      final Map<String, dynamic> data = Map<String, dynamic>.from(jsonDecode(raw));
      final diag = data['diagnosticos'] as Map<String, dynamic>? ?? {};
      _diagIngresoCtl.text = diag['ingreso']?.toString() ?? _diagIngresoCtl.text;
      _diagEgresoCtl.text = diag['egreso']?.toString() ?? _diagEgresoCtl.text;
      final resumen = data['resumen'] as Map<String, dynamic>? ?? {};
      _anamnesisCtl.text = resumen['anamnesis']?.toString() ?? _anamnesisCtl.text;
      _examenClinicoCtl.text = resumen['examenClinico']?.toString() ?? _examenClinicoCtl.text;
      _examenAuxCtl.text = resumen['examenesAuxiliares']?.toString() ?? '';
      _evolucionCtl.text = resumen['evolucion']?.toString() ?? '';
      _procedimientosCtl.text = data['procedimientos']?.toString() ?? '';
      _firmaCtl.text = data['firmaMedico']?.toString() ?? _firmaCtl.text;
      _pieCtl.text = data['pie']?.toString() ?? _pieCtl.text;
      _transferType = data['transferenciaTipo']?.toString() ?? _transferType;
      _transferDestinoCtl.text = data['transferenciaDestino']?.toString() ?? '';
      _condicionAlta = data['condicionAlta']?.toString() ?? _condicionAlta;
      _pronostico = data['pronostico']?.toString() ?? _pronostico;
      final mortality = data['mortalidad'] as Map<String, dynamic>? ?? {};
      _autopsia = mortality['autopsia'] == true;
      _mortFinalCtl.text = mortality['causaFinal']?.toString() ?? '';
      _mortInterCtl.text = mortality['causaIntermedia']?.toString() ?? '';
      _mortBasicaCtl.text = mortality['causaBasica']?.toString() ?? '';
      _servicioEgresoCtl.text = data['servicioEgreso']?.toString() ?? _servicioEgresoCtl.text;
      final meds = data['medicamentos'] as List<dynamic>? ?? [];
      if (meds.isNotEmpty) {
        _medications
          ..clear()
          ..addAll(meds.map((m) => _MedicationRow(
                nombre: m['nombre']?.toString() ?? '',
                dias: m['dias']?.toString() ?? '',
              )));
      }
    } catch (e) {
      debugPrint('Error parsing epicrisis payload: $e');
    }
  }

  String? _flattenObjective(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    try {
      final map = jsonDecode(raw);
      if (map is Map) {
        final buffer = StringBuffer();
        map.forEach((key, value) {
          if (value == null) return;
          buffer.writeln('$key: $value');
        });
        return buffer.toString().trim();
      }
    } catch (_) {
      return raw;
    }
    return raw;
  }

  @override
  void dispose() {
    _servicioEgresoCtl.dispose();
    _diagIngresoCtl.dispose();
    _diagEgresoCtl.dispose();
    _anamnesisCtl.dispose();
    _examenClinicoCtl.dispose();
    _examenAuxCtl.dispose();
    _evolucionCtl.dispose();
    _procedimientosCtl.dispose();
    _transferDestinoCtl.dispose();
    _firmaCtl.dispose();
    _pieCtl.dispose();
    _mortFinalCtl.dispose();
    _mortInterCtl.dispose();
    _mortBasicaCtl.dispose();
    for (final row in _medications) {
      row.dispose();
    }
    super.dispose();
  }

  Future<bool> saveEpicrisis(BuildContext context, {bool silent = false}) async {
    if (_saving) return false;
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _saving = true);
    final payload = jsonEncode(_collectPayload());
    final admissionId = widget.activeAdmission.admission.id;
    try {
      final companion = EpicrisisNotesCompanion(
        admissionId: drift.Value(admissionId),
        payload: drift.Value(payload),
        updatedAt: drift.Value(DateTime.now()),
        isSynced: const drift.Value(false),
      );
      if (_existingNoteId == null) {
        final inserted = await appDatabase.into(appDatabase.epicrisisNotes).insert(
              companion.copyWith(createdAt: drift.Value(DateTime.now())),
            );
        _existingNoteId = inserted;
      } else {
        await (appDatabase.update(appDatabase.epicrisisNotes)..where((tbl) => tbl.id.equals(_existingNoteId!))).write(companion);
      }
      if (!silent) {
        messenger.showSnackBar(const SnackBar(content: Text('Epicrisis guardada correctamente')));
      }
      return true;
    } catch (e) {
      if (!silent) {
        messenger.showSnackBar(SnackBar(content: Text('No se pudo guardar: $e')));
      }
      return false;
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  Future<void> printEpicrisis(BuildContext context) async {
    if (_loading) return;
    final payload = _collectPayload();
    await EpicrisisPdfGenerator.generateAndPrint(
      patient: widget.activeAdmission.patient,
      admission: widget.activeAdmission.admission,
      payload: payload,
    );
  }

  Map<String, dynamic> _collectPayload() {
    final patient = widget.activeAdmission.patient;
    final admission = widget.activeAdmission.admission;
    return {
      'filiacion': {
        'nombre': patient.name,
        'dni': patient.dni,
        'hc': patient.hc,
        'duracionTotal': _totalStayDays,
        'duracionUci': _icuStayDays,
        'fechaIngreso': DateFormat('dd/MM/yyyy').format(admission.admissionDate),
        'fechaEgreso': DateFormat('dd/MM/yyyy').format(DateTime.now()),
        'servicioEgreso': _servicioEgresoCtl.text.trim(),
        'cama': admission.bedNumber?.toString() ?? '-',
      },
      'diagnosticos': {
        'ingreso': _diagIngresoCtl.text.trim(),
        'egreso': _diagEgresoCtl.text.trim(),
      },
      'resumen': {
        'anamnesis': _anamnesisCtl.text.trim(),
        'examenClinico': _examenClinicoCtl.text.trim(),
        'examenesAuxiliares': _examenAuxCtl.text.trim(),
        'evolucion': _evolucionCtl.text.trim(),
      },
      'medicamentos': _medications
          .asMap()
          .entries
          .map((entry) => {
                'nombre': entry.value.nombreCtl.text.trim(),
                'dias': entry.value.diasCtl.text.trim(),
              })
          .where((m) => m['nombre']!.isNotEmpty)
          .toList(),
      'transferenciaTipo': _transferType,
      'transferenciaDestino': _transferDestinoCtl.text.trim(),
      'procedimientos': _procedimientosCtl.text.trim(),
      'condicionAlta': _condicionAlta,
      'pronostico': _pronostico,
      'mortalidad': {
        'autopsia': _autopsia,
        'causaFinal': _mortFinalCtl.text.trim(),
        'causaIntermedia': _mortInterCtl.text.trim(),
        'causaBasica': _mortBasicaCtl.text.trim(),
      },
      'firmaMedico': _firmaCtl.text.trim(),
      'pie': _pieCtl.text.trim(),
      'servicioEgreso': _servicioEgresoCtl.text.trim(),
      'firmantes': _buildSignersPayload(),
    };
  }

  Map<String, dynamic> _buildSignersPayload() {
    final profile = CurrentUserStore.profile;
    if (profile == null) return {};
    Map<String, String> infoFor() => {
          'nombre': profile.fullName ?? '',
          'cmp': profile.cmp ?? '',
          'dni': profile.dni ?? '',
          'rol': profile.role,
        };
    if (profile.role == 'residente') {
      return {'residente': infoFor()};
    }
    return {'medico': infoFor()};
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    final padding = widget.compact ? const EdgeInsets.all(12) : const EdgeInsets.symmetric(horizontal: 16, vertical: 20);
    return SingleChildScrollView(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFiliationCard(context),
          const SizedBox(height: 12),
          _buildDiagnosticosCard(context),
          const SizedBox(height: 12),
          _buildResumenCard(context),
          const SizedBox(height: 12),
          _buildMedicamentosCard(context),
          const SizedBox(height: 12),
          _buildTransferenciaCard(context),
          const SizedBox(height: 12),
          _buildProcedimientosCard(context),
          const SizedBox(height: 12),
          _buildOutcomeCard(context),
          const SizedBox(height: 12),
          _buildSignatureCard(context),
        ],
      ),
    );
  }

  Widget _buildFiliationCard(BuildContext context) {
    final patient = widget.activeAdmission.patient;
    final admission = widget.activeAdmission.admission;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Filiación', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Wrap(
              spacing: 16,
              runSpacing: 12,
              children: [
                _readonlyField('Nombre completo', patient.name),
                _readonlyField('DNI', patient.dni),
                _readonlyField('Historia Clínica', patient.hc),
                _readonlyField('Duración total internamiento', '$_totalStayDays días'),
                _readonlyField('Estancia en UCI', '$_icuStayDays días'),
                _readonlyField('Fecha de ingreso', DateFormat('dd/MM/yyyy').format(admission.admissionDate)),
                _readonlyField('Cama', admission.bedNumber?.toString() ?? '-'),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _servicioEgresoCtl,
              decoration: const InputDecoration(labelText: 'Servicio de egreso', border: OutlineInputBorder()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _readonlyField(String label, String value) {
    return SizedBox(
      width: 220,
      child: TextFormField(
        initialValue: value,
        enabled: false,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      ),
    );
  }

  Widget _buildDiagnosticosCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Diagnósticos', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _diagIngresoCtl,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Diagnóstico de ingreso',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _diagEgresoCtl,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Diagnóstico de egreso',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResumenCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Resumen clínico', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            _buildMultiline('Anamnesis', _anamnesisCtl),
            const SizedBox(height: 12),
            _buildMultiline('Examen clínico', _examenClinicoCtl),
            const SizedBox(height: 12),
            _buildMultiline('Exámenes auxiliares', _examenAuxCtl),
            const SizedBox(height: 12),
            _buildMultiline('Evolución', _evolucionCtl),
          ],
        ),
      ),
    );
  }

  Widget _buildMultiline(String label, TextEditingController controller, {int minLines = 4}) {
    return TextField(
      controller: controller,
      minLines: minLines,
      maxLines: 8,
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
    );
  }

  Widget _buildMedicamentosCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Medicamentos administrados', style: Theme.of(context).textTheme.titleMedium),
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _medications.add(_MedicationRow());
                    });
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Agregar'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ..._medications.map((row) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: TextField(
                          controller: row.nombreCtl,
                          decoration: const InputDecoration(
                            labelText: 'Medicamento',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 1,
                        child: TextField(
                          controller: row.diasCtl,
                          decoration: const InputDecoration(
                            labelText: 'Días',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      IconButton(
                        onPressed: _medications.length > 1
                            ? () {
                                setState(() {
                                  row.dispose();
                                  _medications.remove(row);
                                });
                              }
                            : null,
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildTransferenciaCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Transferencia', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              children: [
                ChoiceChip(
                  label: const Text('Domiciliaria'),
                  selected: _transferType == 'Domiciliaria',
                  onSelected: (value) {
                    if (value) {
                      setState(() {
                        _transferType = 'Domiciliaria';
                      });
                    }
                  },
                ),
                ChoiceChip(
                  label: const Text('Otro servicio'),
                  selected: _transferType == 'Otro servicio',
                  onSelected: (value) {
                    if (value) {
                      setState(() {
                        _transferType = 'Otro servicio';
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _transferDestinoCtl,
              decoration: InputDecoration(
                labelText: _transferType == 'Domiciliaria' ? 'Dirección o comentarios' : 'Servicio receptor',
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProcedimientosCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Procedimientos terapéuticos y diagnósticos realizados', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            _buildMultiline('Detalle de procedimientos', _procedimientosCtl, minLines: 4),
          ],
        ),
      ),
    );
  }

  Widget _buildOutcomeCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Condición y egreso', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    // ignore: deprecated_member_use
                    value: _condicionAlta,
                    decoration: const InputDecoration(labelText: 'Condición de alta', border: OutlineInputBorder()),
                    items: const [
                      DropdownMenuItem(value: 'Curado', child: Text('Curado')),
                      DropdownMenuItem(value: 'Mejorado', child: Text('Mejorado')),
                      DropdownMenuItem(value: 'Inalterado', child: Text('Inalterado')),
                      DropdownMenuItem(value: 'Fallecido', child: Text('Fallecido')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _condicionAlta = value);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    // ignore: deprecated_member_use
                    value: _pronostico,
                    decoration: const InputDecoration(labelText: 'Pronóstico', border: OutlineInputBorder()),
                    items: const [
                      DropdownMenuItem(value: 'Bueno', child: Text('Bueno')),
                      DropdownMenuItem(value: 'Reservado', child: Text('Reservado')),
                      DropdownMenuItem(value: 'Malo', child: Text('Malo')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _pronostico = value);
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_condicionAlta == 'Fallecido') ...[
              SwitchListTile(
                value: _autopsia,
                onChanged: (value) => setState(() => _autopsia = value),
                title: const Text('¿Se realizó necropsia?'),
              ),
              const SizedBox(height: 8),
              _buildMultiline('Causa final de muerte', _mortFinalCtl, minLines: 2),
              const SizedBox(height: 12),
              _buildMultiline('Causa intermedia', _mortInterCtl, minLines: 2),
              const SizedBox(height: 12),
              _buildMultiline('Causa básica', _mortBasicaCtl, minLines: 2),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSignatureCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Firma del médico responsable', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            TextField(
              controller: _firmaCtl,
              decoration: const InputDecoration(labelText: 'Nombre y colegiatura', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _pieCtl,
              decoration: const InputDecoration(labelText: 'Nota al pie', border: OutlineInputBorder()),
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}

class _MedicationRow {
  final TextEditingController nombreCtl;
  final TextEditingController diasCtl;
  _MedicationRow({String nombre = '', String dias = ''})
      : nombreCtl = TextEditingController(text: nombre),
        diasCtl = TextEditingController(text: dias);

  String get nombre => nombreCtl.text;
  String get dias => diasCtl.text;

  void dispose() {
    nombreCtl.dispose();
    diasCtl.dispose();
  }
}
