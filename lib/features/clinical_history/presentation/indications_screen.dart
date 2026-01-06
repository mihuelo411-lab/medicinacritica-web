import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:drift/drift.dart' as drift;
import '../../patients/data/patient_repository.dart';
import '../../patients/presentation/widgets/admission_dx_form.dart';
import '../../dashboard/data/cie10_service.dart';
import '../../../../main.dart';
import '../../../../core/database/database.dart';
import '../../../../core/services/supabase_service.dart';
import 'pdf/indications_pdf_generator.dart';
import '../../auth/domain/current_user.dart';

class IndicationsScreen extends StatelessWidget {
  final ActiveAdmission activeAdmission;
  const IndicationsScreen({super.key, required this.activeAdmission});

  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<_IndicationsFormState>();
    final bedLabel = activeAdmission.admission.bedNumber != null
        ? 'Cama ${activeAdmission.admission.bedNumber}'
        : 'Sin cama asignada';
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Hoja de indicaciones'),
            Text(
              '$bedLabel • ${activeAdmission.patient.name}',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
      body: IndicationsForm(
        key: key,
        activeAdmission: activeAdmission,
        compact: false,
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            heroTag: 'print_indication_sheet',
            onPressed: () => key.currentState?.printSheet(context),
            icon: const Icon(Icons.print),
            label: const Text('IMPRIMIR'),
          ),
          const SizedBox(height: 12),
          FloatingActionButton.extended(
            heroTag: 'save_indication_sheet',
            onPressed: () => key.currentState?.submitSheet(context),
            icon: const Icon(Icons.save),
            label: const Text('GUARDAR'),
          ),
        ],
      ),
    );
  }
}

class IndicationsBoard extends StatelessWidget {
  final ActiveAdmission activeAdmission;
  final bool compact;
  const IndicationsBoard({
    super.key,
    required this.activeAdmission,
    this.compact = true,
  });

  @override
  Widget build(BuildContext context) {
    return IndicationsForm(
      activeAdmission: activeAdmission,
      compact: compact,
    );
  }
}

class IndicationsForm extends StatefulWidget {
  final ActiveAdmission activeAdmission;
  final bool compact;
  const IndicationsForm({
    super.key,
    required this.activeAdmission,
    required this.compact,
  });

  @override
  State<IndicationsForm> createState() => _IndicationsFormState();
}

class _IndicationsFormState extends State<IndicationsForm> {
  static int _sheetCounter = 1;
  final _hojaController = TextEditingController();
  final _unidadController = TextEditingController();
  final _expedienteController = TextEditingController();
  final _servicioController = TextEditingController();
  final _fechaController = TextEditingController();
  final _horaController = TextEditingController();
  final _pesoController = TextEditingController();
  final _tallaController = TextEditingController();
  final _medicoController = TextEditingController();
  final _indicacionesGeneralesController = TextEditingController();
  String _generoSeleccionado = 'Masculino';

  final TextEditingController _diagnosisController = TextEditingController();
  final List<_IndicationRow> _indicationRows = [];
  final Cie10Service _cie10Service = Cie10Service();
  String? _admissionDiagnosisSnapshot;
  List<String> _suggestionPool = [];
  List<_StoredIndicationSheet> _historySheets = [];
  bool _historyLoading = false;

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
  void initState() {
    super.initState();
    _bootstrapDefaults();
  }

  void _bootstrapDefaults() {
    final patient = widget.activeAdmission.patient;
    final admission = widget.activeAdmission.admission;
    _admissionDiagnosisSnapshot = admission.diagnosis;
    _hojaController.text = _generateSheetNumber();
    _unidadController.text = 'Unidad de Cuidados Intensivos';
    _expedienteController.text = patient.hc;
    _servicioController.text = 'UCI';
    _fechaController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    _horaController.text = DateFormat('HH:mm').format(DateTime.now());
    _generoSeleccionado = patient.sex;
    final vitalsMap = _safeParse(admission.vitalsJson);
    _pesoController.text = vitalsMap['Peso'] ?? '';
    _tallaController.text = vitalsMap['Talla'] ?? '';
    final profile = CurrentUserStore.profile;
    if (profile?.fullName != null && profile!.fullName!.isNotEmpty) {
      _medicoController.text = profile.fullName!;
    } else {
      _medicoController.text = 'Médico tratante';
    }
    _indicacionesGeneralesController.text =
        'Revisar plan actual y documentar indicaciones específicas para enfermería.';

    _cie10Service.loadData();
    _prefillDiagnosis();
    _indicationRows.add(_IndicationRow());
    _prefillLatestSheet();
    _loadIndicationSuggestions();
    _loadHistory();
  }

  Future<void> _prefillDiagnosis() async {
    final admission = widget.activeAdmission.admission;
    final admissionId = admission.id;
    final latest = await (appDatabase.select(appDatabase.evolutions)
          ..where((t) => t.admissionId.equals(admissionId))
          ..orderBy([(t) => drift.OrderingTerm.desc(t.date)])
          ..limit(1))
        .getSingleOrNull();

    String diagText = '';
    if (latest != null && latest.diagnosis != null && latest.diagnosis!.trim().isNotEmpty) {
      diagText = latest.diagnosis!;
    } else {
      diagText = (_admissionDiagnosisSnapshot ?? admission.diagnosis ?? '').trim();
    }

    if (!mounted) return;
    if (diagText.isNotEmpty) {
      setState(() {
        _diagnosisController.text = diagText;
      });
    }
  }

  Future<void> _prefillLatestSheet() async {
    final admissionId = widget.activeAdmission.admission.id;
    final latestSheet = await (appDatabase.select(appDatabase.indicationSheets)
          ..where((tbl) => tbl.admissionId.equals(admissionId))
          ..orderBy([(tbl) => drift.OrderingTerm.desc(tbl.createdAt)])
          ..limit(1))
        .getSingleOrNull();

    if (latestSheet == null) return;
    Map<String, dynamic> sheetData;
    try {
      final decoded = jsonDecode(latestSheet.payload);
      if (decoded is! Map<String, dynamic>) return;
      sheetData = Map<String, dynamic>.from(decoded);
    } catch (e) {
      debugPrint('No se pudo decodificar la hoja previa: $e');
      return;
    }

    if (!mounted) return;

    final previousIndications = (sheetData['indicaciones'] as List?) ?? [];
    final rows = previousIndications.map((item) {
      String text = '';
      if (item is Map && item['texto'] != null) {
        text = item['texto'].toString();
      } else if (item is String) {
        text = item;
      }
      return _IndicationRow(initialText: text);
    }).toList();
    setState(() {
      if (rows.isNotEmpty) {
        _replaceIndicationRows(rows);
      }
      if (_indicationRows.isEmpty) {
        _indicationRows.add(_IndicationRow());
      }

      final comment = sheetData['comentarioGeneral'];
      if (comment is String && comment.isNotEmpty) {
        _indicacionesGeneralesController.text = comment;
      }
      final medico = sheetData['medico'];
      if (medico is String && medico.isNotEmpty) {
        _medicoController.text = medico;
      }
      final diag = sheetData['diagnosticos'];
      if (diag is String && diag.isNotEmpty) {
        _diagnosisController.text = diag;
      }
    });
  }

  Future<void> _loadHistory() async {
    setState(() {
      _historyLoading = true;
    });
    final admissionId = widget.activeAdmission.admission.id;
    final rows = await (appDatabase.select(appDatabase.indicationSheets)
          ..where((tbl) => tbl.admissionId.equals(admissionId))
          ..orderBy([(tbl) => drift.OrderingTerm.desc(tbl.createdAt)]))
        .get();
    final parsed = <_StoredIndicationSheet>[];
    for (final sheet in rows) {
      try {
        final decoded = jsonDecode(sheet.payload);
        if (decoded is Map<String, dynamic>) {
          parsed.add(
            _StoredIndicationSheet(
              id: sheet.id,
              createdAt: sheet.createdAt,
              payload: Map<String, dynamic>.from(decoded),
            ),
          );
        }
      } catch (_) {
        continue;
      }
    }
    if (!mounted) return;
    setState(() {
      _historySheets = parsed;
      _historyLoading = false;
    });
  }

  Future<void> _loadIndicationSuggestions() async {
    final records = await appDatabase.select(appDatabase.indicationSheets).get();
    final suggestions = <String>{};
    for (final sheet in records) {
      try {
        final decoded = jsonDecode(sheet.payload);
        if (decoded is Map<String, dynamic>) {
          final items = decoded['indicaciones'];
          if (items is List) {
            for (final entry in items) {
              if (entry is Map && entry['texto'] != null) {
                final text = entry['texto'].toString().trim();
                if (text.isNotEmpty) {
                  suggestions.add(text);
                }
              } else if (entry is String) {
                final text = entry.trim();
                if (text.isNotEmpty) {
                  suggestions.add(text);
                }
              }
            }
          }
        }
      } catch (_) {
        continue;
      }
    }
    if (!mounted) return;
    final list = suggestions.toList()..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    setState(() {
      _suggestionPool = list;
    });
  }

  String _generateSheetNumber() {
    final number = _sheetCounter.toString().padLeft(4, '0');
    _sheetCounter += 1;
    return number;
  }

  @override
  void dispose() {
    _diagnosisController.dispose();
    for (final row in _indicationRows) {
      row.dispose();
    }
    _hojaController.dispose();
    _unidadController.dispose();
    _expedienteController.dispose();
    _servicioController.dispose();
    _fechaController.dispose();
    _horaController.dispose();
    _pesoController.dispose();
    _tallaController.dispose();
    _medicoController.dispose();
    _indicacionesGeneralesController.dispose();
    super.dispose();
  }

  void _addIndicationRow() {
    setState(() {
      _indicationRows.add(_IndicationRow());
    });
  }

  void _replaceIndicationRows(List<_IndicationRow> rows) {
    for (final row in _indicationRows) {
      row.dispose();
    }
    _indicationRows
      ..clear()
      ..addAll(rows);
  }

  Future<void> submitSheet(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final payload = _collectSheetData();
    final diagnosisText = payload['diagnosticos'] as String;
    await _persistDiagnosis(diagnosisText);
    await _persistSheetPayload(payload);
    await _loadIndicationSuggestions();
    debugPrint('Indicaciones guardadas: ${jsonEncode(payload)}');
    messenger.showSnackBar(
      SnackBar(
        content: Text('Indicaciones registradas (${_indicationRows.length})'),
      ),
    );
  }

  Future<void> printSheet(BuildContext context) async {
    final payload = _collectSheetData();
    final indicationsData = _normalizeIndicationsList(payload['indicaciones']);
    final diagnosis = payload['diagnosticos'] as String;
    final profile = CurrentUserStore.profile;
    final physicianName = profile?.fullName?.isNotEmpty == true
        ? profile!.fullName!
        : payload['medico'] as String;
    await IndicationsPdfGenerator.generateAndPrint(
      patient: widget.activeAdmission.patient,
      admission: widget.activeAdmission.admission,
      sheetNumber: payload['hoja'] as String,
      unit: payload['unidad'] as String,
      expediente: payload['expediente'] as String,
      service: payload['servicio'] as String,
      date: payload['fecha'] as String,
      time: payload['hora'] as String,
      gender: payload['genero'] as String,
      weight: payload['peso'] as String,
      height: payload['talla'] as String,
      physician: physicianName,
      diagnosis: diagnosis,
      indications: indicationsData,
      comment: payload['comentarioGeneral'] as String,
      signatures: payload['firmantes'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> _collectSheetData() {
    final diagnosisText = _diagnosisController.text.trim();
    return {
      'hoja': _hojaController.text,
      'unidad': _unidadController.text,
      'expediente': _expedienteController.text,
      'servicio': _servicioController.text,
      'fecha': _fechaController.text,
      'hora': _horaController.text,
      'peso': _pesoController.text,
      'talla': _tallaController.text,
      'medico': _medicoController.text,
      'genero': _generoSeleccionado,
      'diagnosticos': diagnosisText,
      'indicaciones': _indicationRows
          .asMap()
          .entries
          .map((entry) => entry.value.toMap(order: entry.key + 1))
          .toList(),
      'comentarioGeneral': _indicacionesGeneralesController.text,
      'firmantes': _buildSignersPayload(),
    };
  }

  Future<void> _reprintStoredSheet(_StoredIndicationSheet sheet) async {
    try {
      final payload = sheet.payload;
      final indications = _normalizeIndicationsList(payload['indicaciones']);
      await IndicationsPdfGenerator.generateAndPrint(
        patient: widget.activeAdmission.patient,
        admission: widget.activeAdmission.admission,
        sheetNumber: payload['hoja']?.toString() ?? sheet.id.toString(),
        unit: payload['unidad']?.toString() ?? 'Unidad de Cuidados Intensivos',
        expediente: payload['expediente']?.toString() ?? widget.activeAdmission.patient.hc,
        service: payload['servicio']?.toString() ?? 'UCI',
        date: payload['fecha']?.toString() ?? DateFormat('dd/MM/yyyy').format(sheet.createdAt),
        time: payload['hora']?.toString() ?? DateFormat('HH:mm').format(sheet.createdAt),
        gender: payload['genero']?.toString() ?? widget.activeAdmission.patient.sex,
        weight: payload['peso']?.toString() ?? '',
        height: payload['talla']?.toString() ?? '',
        physician: payload['medico']?.toString() ?? 'Médico tratante',
        diagnosis: payload['diagnosticos']?.toString() ?? '',
        indications: indications,
        comment: payload['comentarioGeneral']?.toString() ?? '',
        signatures: _normalizeSignatures(payload['firmantes']),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hoja ${payload['hoja'] ?? sheet.id} enviada a impresión')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo reimprimir la hoja: $e')),
        );
      }
    }
  }

  Future<void> _persistDiagnosis(String text) async {
    if (text.isEmpty) return;
    final admissionId = widget.activeAdmission.admission.id;
    final companion = AdmissionsCompanion(
      id: drift.Value(admissionId),
      diagnosis: drift.Value(text),
    );
    await (appDatabase.update(appDatabase.admissions)..where((tbl) => tbl.id.equals(admissionId))).write(companion);
    _admissionDiagnosisSnapshot = text;
    try {
      await SupabaseService().updateAdmissionDiagnosis(admissionId: admissionId, diagnosis: text);
    } catch (e) {
      debugPrint('Supabase diagnosis update failed: $e');
    }
  }

  Future<void> _persistSheetPayload(Map<String, dynamic> payload) async {
    final admissionId = widget.activeAdmission.admission.id;
    final companion = IndicationSheetsCompanion(
      admissionId: drift.Value(admissionId),
      payload: drift.Value(jsonEncode(payload)),
    );
    try {
      await appDatabase.into(appDatabase.indicationSheets).insert(companion);
      await _loadHistory();
    } catch (e) {
      debugPrint('No se pudo guardar la hoja de indicaciones: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final padding = widget.compact ? const EdgeInsets.all(12) : const EdgeInsets.symmetric(horizontal: 16, vertical: 20);
    return SingleChildScrollView(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHistoryCard(context),
          const SizedBox(height: 12),
          _buildHeaderCard(context),
          const SizedBox(height: 12),
          _buildDiagnosisCard(context),
          const SizedBox(height: 12),
          _buildIndicationsCard(context),
          const SizedBox(height: 12),
          _buildSignatureCard(context),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Historial de indicaciones', style: Theme.of(context).textTheme.titleMedium),
                IconButton(
                  tooltip: 'Actualizar historial',
                  onPressed: _historyLoading ? null : () => _loadHistory(),
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (_historyLoading)
              const LinearProgressIndicator()
            else if (_historySheets.isEmpty)
              const Text('Aún no hay hojas de indicaciones registradas para este paciente.')
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _historySheets.length,
                separatorBuilder: (context, _) => const Divider(),
                itemBuilder: (context, index) {
                  final sheet = _historySheets[index];
                  final diag = (sheet.payload['diagnosticos']?.toString() ?? '').trim();
                  final indications = _normalizeIndicationsList(sheet.payload['indicaciones']);
                  final sheetNumber = sheet.payload['hoja']?.toString() ?? sheet.id.toString();
                  final createdAt = DateFormat('dd/MM/yyyy HH:mm').format(sheet.createdAt);
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('Hoja $sheetNumber • $createdAt'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${indications.length} indicaciones registradas'),
                        if (diag.isNotEmpty)
                          Text(
                            diag.length > 120 ? '${diag.substring(0, 120)}…' : diag,
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                      ],
                    ),
                    trailing: TextButton.icon(
                      onPressed: () => _reprintStoredSheet(sheet),
                      icon: const Icon(Icons.print),
                      label: const Text('Reimprimir'),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context) {
    final patient = widget.activeAdmission.patient;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Datos generales', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Wrap(
              spacing: 16,
              runSpacing: 12,
              children: [
                _buildTextField('Hoja No.', _hojaController, width: 120, readOnly: true),
                _buildTextField('Unidad médica', _unidadController, width: 220, readOnly: true),
                _buildTextField('No. expediente', _expedienteController, width: 160, readOnly: true),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 16,
              runSpacing: 12,
              children: [
                _buildReadOnlyField('Paciente', patient.name),
                _buildReadOnlyField('Edad', '${patient.age} años', width: 120),
                _buildReadOnlyField('Género', patient.sex, width: 180),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 16,
              runSpacing: 12,
              children: [
                _buildTextField('Servicio', _servicioController, width: 160, readOnly: true),
                _buildTextField('Fecha', _fechaController, width: 140, readOnly: true),
                _buildTextField('Hora', _horaController, width: 120, readOnly: true),
                _buildTextField('Peso (kg)', _pesoController, width: 140, readOnly: true),
                _buildTextField('Talla (cm)', _tallaController, width: 140, readOnly: true),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiagnosisCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Diagnóstico principal', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            AdmissionDxForm(
              dxController: _diagnosisController,
              cie10Service: _cie10Service,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIndicationsCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Indicaciones médicas', style: Theme.of(context).textTheme.titleMedium),
                TextButton.icon(
                  onPressed: _addIndicationRow,
                  icon: const Icon(Icons.add),
                  label: const Text('Agregar indicación'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ReorderableListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (newIndex > oldIndex) newIndex -= 1;
                  final item = _indicationRows.removeAt(oldIndex);
                  _indicationRows.insert(newIndex, item);
                });
              },
              itemCount: _indicationRows.length,
              itemBuilder: (context, idx) {
                final row = _indicationRows[idx];
                return Padding(
                  key: ValueKey(row.id),
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 40,
                        height: 48,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: Text('${idx + 1}'),
                      ),
                      const SizedBox(width: 8),
                      Expanded(child: _buildIndicationInput(row, idx)),
                      const SizedBox(width: 8),
                      const Icon(Icons.drag_handle),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _indicacionesGeneralesController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Comentarios adicionales',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIndicationInput(_IndicationRow row, int index) {
    return RawAutocomplete<String>(
      textEditingController: row.textCtl,
      focusNode: row.focusNode,
      optionsBuilder: (textEditingValue) {
        if (_suggestionPool.isEmpty) return const Iterable<String>.empty();
        final query = textEditingValue.text.trim().toLowerCase();
        final Iterable<String> matches = query.isEmpty
            ? _suggestionPool.take(6)
            : _suggestionPool.where((option) => option.toLowerCase().contains(query));
        return matches.take(8).toList();
      },
      fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
        return TextField(
          controller: textEditingController,
          focusNode: focusNode,
          maxLines: 2,
          decoration: InputDecoration(
            labelText: 'Indicacion ${index + 1}',
            isDense: true,
            border: const OutlineInputBorder(),
          ),
        );
      },
      optionsViewBuilder: (context, onSelected, options) {
        final list = options.toList();
        if (list.isEmpty) {
          return const SizedBox.shrink();
        }
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(8),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 220, maxWidth: 360),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: list.length,
                itemBuilder: (context, idx) {
                  final option = list[idx];
                  return ListTile(
                    dense: true,
                    title: Text(option),
                    onTap: () => onSelected(option),
                  );
                },
              ),
            ),
          ),
        );
      },
      onSelected: (selection) {
        row.textCtl
          ..text = selection
          ..selection = TextSelection.collapsed(offset: selection.length);
      },
    );
  }

  Widget _buildSignatureCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Responsable', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            TextField(
              controller: _medicoController,
              decoration: const InputDecoration(
                labelText: 'Nombre y firma del personal tratante',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Nota: Todas las notas médicas deben estar firmadas por el personal adscrito del servicio.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController ctl, {double? width, bool readOnly = false}) {
    return SizedBox(
      width: width ?? 220,
      child: TextField(
        controller: ctl,
        readOnly: readOnly,
        enabled: !readOnly,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      ),
    );
  }

  Widget _buildReadOnlyField(String label, String value, {double? width}) {
    return SizedBox(
      width: width ?? 220,
      child: TextFormField(
        initialValue: value,
        enabled: false,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      ),
    );
  }

}

class _IndicationRow {
  final String id;
  final TextEditingController textCtl;
  final FocusNode focusNode;
  _IndicationRow({String? initialText})
      : id = UniqueKey().toString(),
        textCtl = TextEditingController(text: initialText ?? ''),
        focusNode = FocusNode();

  Map<String, String> toMap({required int order}) => {
        'numero': order.toString(),
        'texto': textCtl.text,
      };

  void dispose() {
    textCtl.dispose();
    focusNode.dispose();
  }
}

class _StoredIndicationSheet {
  final int id;
  final DateTime createdAt;
  final Map<String, dynamic> payload;
  const _StoredIndicationSheet({
    required this.id,
    required this.createdAt,
    required this.payload,
  });
}

List<Map<String, String>> _normalizeIndicationsList(dynamic rawList) {
  final result = <Map<String, String>>[];
  if (rawList is List) {
    var order = 1;
    for (final entry in rawList) {
      String text = '';
      String number = order.toString();
      if (entry is Map) {
        if (entry['texto'] != null) {
          text = entry['texto'].toString();
        }
        if (entry['numero'] != null) {
          number = entry['numero'].toString();
        }
      } else if (entry is String) {
        text = entry;
      }
      if (text.trim().isEmpty) continue;
      result.add({'numero': number, 'texto': text.trim()});
      order++;
    }
  }
  return result;
}

Map<String, dynamic>? _normalizeSignatures(dynamic raw) {
  if (raw is Map<String, dynamic>) return raw;
  if (raw is Map) {
    return raw.map((key, value) => MapEntry(key.toString(), value));
  }
  return null;
}
  Map<String, String> _safeParse(String? raw) {
    if (raw == null || raw.isEmpty) return {};
    try {
      final Map<String, dynamic> decoded = Map<String, dynamic>.from(jsonDecode(raw));
      return decoded.map((k, v) => MapEntry(k, v?.toString() ?? ''));
    } catch (_) {
      return {};
    }
  }
