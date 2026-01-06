import 'package:flutter/material.dart';
import '../../../../core/database/database.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../../main.dart';
import 'package:drift/drift.dart' as drift;
import 'package:intl/intl.dart';
class ProcedureSelectorWidget extends StatefulWidget {
  final int? admissionId;
  final String origin; // 'ingreso', 'evolucion'
  final String? guardia;
  final List<DraftProcedure>? draftProcedures;
  final ValueChanged<List<DraftProcedure>>? onDraftChanged;
  final String? defaultAssistant;
  final String? defaultResident;
  final Widget? footerContent;
  final bool showPersistedProcedures;
  
  const ProcedureSelectorWidget({
    super.key,
    required this.admissionId,
    required this.origin,
    this.guardia,
    this.draftProcedures,
    this.onDraftChanged,
    this.defaultAssistant,
    this.defaultResident,
    this.footerContent,
    this.showPersistedProcedures = true,
  });

  @override
  State<ProcedureSelectorWidget> createState() => _ProcedureSelectorWidgetState();
}

class _ProcedureSelectorWidgetState extends State<ProcedureSelectorWidget> {
  List<Procedure> _allProcedures = [];
  List<PerformedProcedure> _performed = [];
  bool _loading = true;
  bool _saving = false;
  bool get _isDraftMode => widget.admissionId == null;
  List<DraftProcedure> get _draftProcedures =>
      widget.draftProcedures ?? const [];
  final Set<int> _sessionProcedureIds = {};
  bool _historyVisible = true;

  // Form
  Procedure? _selectedProcedure;
  final _assistantCtl = TextEditingController();
  final _residentCtl = TextEditingController();
  final _noteCtl = TextEditingController();
  final _searchCtl = TextEditingController();
  DateTime _performedAt = DateTime.now();

  @override
  void initState() {
    super.initState();
    _historyVisible = widget.showPersistedProcedures;
    _applyDefaultNames(force: true);
    _loadData();
  }

  @override
  void didUpdateWidget(covariant ProcedureSelectorWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.admissionId != widget.admissionId ||
        oldWidget.origin != widget.origin ||
        oldWidget.guardia != widget.guardia) {
      _loadData();
    }
    if (oldWidget.defaultAssistant != widget.defaultAssistant ||
        oldWidget.defaultResident != widget.defaultResident) {
      _applyDefaultNames();
    }
    if (oldWidget.showPersistedProcedures !=
        widget.showPersistedProcedures) {
      _historyVisible = widget.showPersistedProcedures;
    }
  }

  Future<void> _loadData() async {
    if (!_loading) {
      setState(() => _loading = true);
    }
    _sessionProcedureIds.clear();
    await _ensureCatalogSynced();
    await _loadCatalogFromDb();
    if (!_isDraftMode) {
      await _loadPerformed();
    }
    if (mounted) {
      setState(() => _loading = false);
    }
  }

  Future<void> _ensureCatalogSynced() async {
    try {
      final data = await SupabaseService().fetchProcedureCatalog();
      if (data.isEmpty) return;
      await appDatabase.transaction(() async {
        for (final row in data) {
          await appDatabase.into(appDatabase.procedures).insertOnConflictUpdate(
                ProceduresCompanion(
                  id: drift.Value(row['id'] as int),
                  name: drift.Value(row['name'] as String),
                  code: drift.Value(row['code'] as String?),
                  description:
                      drift.Value(row['description_template'] as String?),
                  createdAt: drift.Value(
                    DateTime.tryParse(row['created_at']?.toString() ?? '') ??
                        DateTime.now(),
                  ),
                  isSynced: const drift.Value(true),
                ),
              );
        }
      });
    } catch (_) {
      // Mantener datos locales si no hay red
    }
  }

  Future<void> _loadCatalogFromDb() async {
    _allProcedures = await appDatabase.select(appDatabase.procedures).get();
  }

  Future<void> _loadPerformed() async {
    if (_isDraftMode || widget.admissionId == null) return;
    await _syncPerformedFromCloud();
    final query = appDatabase.select(appDatabase.performedProcedures)
      ..where((t) => t.admissionId.equals(widget.admissionId!))
      ..where((t) => t.origin.equals(widget.origin));
    final guardiaValue = widget.guardia;
    if (guardiaValue != null) {
      query.where((t) => t.guardia.equals(guardiaValue));
    } else {
      query.where((t) => t.guardia.isNull());
    }
    final data = await query.get();
    if (mounted) {
      setState(() => _performed = data);
    }
  }

  Future<void> _syncPerformedFromCloud() async {
    if (_isDraftMode || widget.admissionId == null) return;
    try {
      final rows = await SupabaseService().fetchPerformedProceduresForAdmission(
        admissionId: widget.admissionId!,
        origin: widget.origin,
        guardia: widget.guardia,
      );
      await appDatabase.transaction(() async {
        final deleteStmt = appDatabase.delete(appDatabase.performedProcedures)
          ..where((t) => t.admissionId.equals(widget.admissionId!))
          ..where((t) => t.origin.equals(widget.origin));
        final guardiaValue = widget.guardia;
        if (guardiaValue != null) {
          deleteStmt.where((t) => t.guardia.equals(guardiaValue));
        } else {
          deleteStmt.where((t) => t.guardia.isNull());
        }
        await deleteStmt.go();
        for (final row in rows) {
          await appDatabase.into(appDatabase.performedProcedures).insertOnConflictUpdate(
                PerformedProceduresCompanion(
                  id: drift.Value(row['id'] as int),
                  admissionId: drift.Value(widget.admissionId!),
                  procedureId: drift.Value(row['procedure_id'] as int),
                  procedureName: drift.Value(row['procedure_name'] as String),
                  performedAt: drift.Value(
                    DateTime.tryParse(row['performed_at']?.toString() ?? '') ??
                        DateTime.now(),
                  ),
                  assistant: drift.Value(row['assistant'] as String?),
                  resident: drift.Value(row['resident'] as String?),
                  origin: drift.Value(row['origin'] as String?),
                  guardia: drift.Value(row['guardia'] as String?),
                  note: drift.Value(row['note'] as String?),
                  createdAt: drift.Value(
                    DateTime.tryParse(row['created_at']?.toString() ?? '') ??
                        DateTime.now(),
                  ),
                  isSynced: const drift.Value(true),
                ),
              );
        }
      });
    } catch (_) {
      // Si falla la red, continuamos con datos locales
    }
  }

  Future<void> _addProcedure() async {
    if (_selectedProcedure == null || _saving) return;
    final selectedProcedure = _selectedProcedure!;
    final assistantText = _assistantCtl.text.trim();
    final residentText = _residentCtl.text.trim();
    final noteText = _noteCtl.text.trim();
    final assistantValue = assistantText.isEmpty ? null : assistantText;
    final residentValue = residentText.isEmpty ? null : residentText;
    final noteValue = noteText.isEmpty ? null : noteText;

    if (_isDraftMode || widget.admissionId == null) {
      final updated = List<DraftProcedure>.from(_draftProcedures)
        ..add(
          DraftProcedure(
            procedureId: selectedProcedure.id,
            procedureName: selectedProcedure.name,
            performedAt: _performedAt,
            assistant: assistantValue,
            resident: residentValue,
            origin: widget.origin,
            guardia: widget.guardia,
            note: noteValue,
          ),
        );
      widget.onDraftChanged?.call(updated);
      _resetForm();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Procedimiento agregado. Se guardará al registrar la admisión.')),
      );
      return;
    }

    setState(() => _saving = true);
    try {
      final remote = await SupabaseService().savePerformedProcedure(
        admissionId: widget.admissionId!,
        procedureId: selectedProcedure.id,
        procedureName: selectedProcedure.name,
        performedAt: _performedAt,
        assistant: assistantValue,
        resident: residentValue,
        origin: widget.origin,
        guardia: widget.guardia,
        note: noteValue,
      );
      final inserted = PerformedProceduresCompanion(
        id: drift.Value(remote['id'] as int),
        admissionId: drift.Value(widget.admissionId!),
        procedureId: drift.Value(remote['procedure_id'] as int),
        procedureName: drift.Value(remote['procedure_name'] as String),
        performedAt: drift.Value(
          DateTime.tryParse(remote['performed_at']?.toString() ?? '') ??
              _performedAt,
        ),
        assistant: drift.Value(remote['assistant'] as String?),
        resident: drift.Value(remote['resident'] as String?),
        origin: drift.Value(remote['origin'] as String?),
        guardia: drift.Value(remote['guardia'] as String?),
        note: drift.Value(remote['note'] as String? ?? noteValue),
        createdAt: drift.Value(
          DateTime.tryParse(remote['created_at']?.toString() ?? '') ??
              DateTime.now(),
        ),
        isSynced: const drift.Value(true),
      );
      await appDatabase
          .into(appDatabase.performedProcedures)
          .insertOnConflictUpdate(inserted);
      final newId = remote['id'] as int;
      _sessionProcedureIds.add(newId);
      _resetForm();
      await _loadPerformed();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Procedimiento registrado.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error registrando procedimiento: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  Future<void> _deletePerformed(int id) async {
    if (_isDraftMode || widget.admissionId == null) {
      // Not used in draft mode; handled elsewhere
      return;
    }
    try {
      await SupabaseService().deletePerformedProcedure(id);
      await (appDatabase.delete(appDatabase.performedProcedures)
            ..where((t) => t.id.equals(id)))
          .go();
      _sessionProcedureIds.remove(id);
      await _loadPerformed();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo eliminar: $e')),
        );
      }
    }
  }

  void _removeDraftAt(int index) {
    if (widget.onDraftChanged == null) return;
    final updated = List<DraftProcedure>.from(_draftProcedures);
    if (index < 0 || index >= updated.length) return;
    updated.removeAt(index);
    widget.onDraftChanged!(updated);
  }

  void _resetForm() {
    setState(() {
      _selectedProcedure = null;
      _searchCtl.clear();
      _assistantCtl.clear();
      _residentCtl.clear();
      _noteCtl.clear();
      _performedAt = DateTime.now();
    });
    _applyDefaultNames();
  }

  void _applyDefaultNames({bool force = false}) {
    final assistant = widget.defaultAssistant?.trim();
    if (assistant != null && assistant.isNotEmpty) {
      if (force || _assistantCtl.text.trim().isEmpty) {
        _assistantCtl.text = assistant;
      }
    }
    final resident = widget.defaultResident?.trim();
    if (resident != null && resident.isNotEmpty) {
      if (force || _residentCtl.text.trim().isEmpty) {
        _residentCtl.text = resident;
      }
    }
  }

  void _prefillNotesWithTemplate(Procedure procedure) {
    final template = procedure.description?.trim();
    if (template != null && template.isNotEmpty) {
      _noteCtl.text = template;
    } else {
      _noteCtl.clear();
    }
  }

  @override
  void dispose() {
    _assistantCtl.dispose();
    _residentCtl.dispose();
    _noteCtl.dispose();
    _searchCtl.dispose();
    super.dispose();
  }

  Widget _buildProceduresList(bool isDraft, List<DraftProcedure> draftList) {
    if (isDraft) {
      if (draftList.isEmpty) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text('Aún no hay procedimientos capturados para este ingreso.',
              style: TextStyle(fontStyle: FontStyle.italic)),
        );
      }
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: draftList.length,
        itemBuilder: (context, index) {
          final p = draftList[index];
          final note = p.note?.trim();
          return ListTile(
            dense: true,
            title: Text(p.procedureName),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${DateFormat('dd/MM HH:mm').format(p.performedAt)} - A: ${p.assistant ?? '-'} R: ${p.resident ?? '-'}',
                ),
                if (note != null && note.isNotEmpty)
                  Text(note, style: const TextStyle(fontSize: 12)),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.close, color: Colors.red, size: 20),
              onPressed: () => _removeDraftAt(index),
            ),
          );
        },
      );
    }

    final visibleList = _historyVisible
        ? _performed
        : _performed
            .where((p) => _sessionProcedureIds.contains(p.id))
            .toList();
    if (visibleList.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          _historyVisible
              ? 'Ninguno registrado en esta nota.'
              : 'Historial oculto. Aquí solo aparecerán los procedimientos que agregues en esta evolución.',
          style: const TextStyle(fontStyle: FontStyle.italic),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: visibleList.length,
      itemBuilder: (context, index) {
        final p = visibleList[index];
        final note = p.note?.trim();
        return ListTile(
          dense: true,
          title: Text(p.procedureName),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${DateFormat('dd/MM HH:mm').format(p.performedAt)}'
                ' - A: ${p.assistant ?? '-'} R: ${p.resident ?? '-'}',
              ),
              if (note != null && note.isNotEmpty)
                Text(note, style: const TextStyle(fontSize: 12)),
            ],
          ),
          trailing: IconButton(
            icon: const Icon(Icons.close, color: Colors.red, size: 20),
            onPressed: () => _deletePerformed(p.id),
          ),
        );
      },
    );
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _performedAt,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_performedAt),
    );
    if (time == null) return;

    setState(() {
      _performedAt = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    final isDraft = _isDraftMode;
    final draftList = _draftProcedures;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Procedimientos Realizados (${widget.origin.toUpperCase()}${widget.guardia != null ? ' • ${widget.guardia}' : ''})',
              style: Theme.of(context).textTheme.titleMedium),
            if (!_isDraftMode && !widget.showPersistedProcedures)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () {
                    setState(() => _historyVisible = !_historyVisible);
                  },
                  icon: Icon(
                    _historyVisible
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  label: Text(_historyVisible
                      ? 'Ocultar historial'
                      : 'Mostrar historial guardado'),
                ),
              ),
            const SizedBox(height: 12),
            const Text('Agregar Procedimiento:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Autocomplete<Procedure>(
              displayStringForOption: (Procedure option) => option.name,
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text == '') {
                  return const Iterable<Procedure>.empty();
                }
                return _allProcedures.where((Procedure option) {
                  return option.name.toLowerCase().contains(textEditingValue.text.toLowerCase());
                });
              },
              onSelected: (Procedure selection) {
                setState(() => _selectedProcedure = selection);
                _prefillNotesWithTemplate(selection);
              },
              fieldViewBuilder:
                  (context, textEditingController, focusNode, onFieldSubmitted) {
                if (textEditingController.text != _searchCtl.text) {
                  textEditingController.text = _searchCtl.text;
                }
                return TextField(
                  controller: textEditingController,
                  focusNode: focusNode,
                  decoration: const InputDecoration(
                    labelText: 'Buscar procedimiento (escriba para buscar)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.search),
                  ),
                );
              },
            ),
            if(_selectedProcedure != null) ...[
               const SizedBox(height: 8),
               TextField(
                 controller: _noteCtl,
                 minLines: 3,
                 maxLines: 4,
                 decoration: const InputDecoration(
                   labelText: 'Descripción / Nota del procedimiento',
                   alignLabelWithHint: true,
                   border: OutlineInputBorder(),
                 ),
               ),
               const SizedBox(height: 8),
               Row(
                 children: [
                   Expanded(
                     child: TextField(
                       controller: _assistantCtl,
                       decoration: const InputDecoration(labelText: 'Asistente', isDense: true),
                     ),
                   ),
                   const SizedBox(width: 8),
                   Expanded(
                     child: TextField(
                       controller: _residentCtl,
                       decoration: const InputDecoration(labelText: 'Residente', isDense: true),
                     ),
                   ),
                 ],
               ),
               const SizedBox(height: 8),
               Row(
                 children: [
                    TextButton.icon(
                      icon: const Icon(Icons.calendar_today),
                      label: Text(DateFormat('dd/MM HH:mm').format(_performedAt)),
                      onPressed: _pickDateTime,
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: _saving ? null : _addProcedure,
                      child: const Text('Confirmar Agregar'),
                    ),
                 ],
               )
            ],
            const SizedBox(height: 12),
            if (widget.footerContent != null) ...[
              widget.footerContent!,
              const SizedBox(height: 12),
            ],
            const Divider(),
            const SizedBox(height: 8),
            _buildProceduresList(_isDraftMode, _draftProcedures),
          ],
        ),
      ),
    );
  }
}

class DraftProcedure {
  final int procedureId;
  final String procedureName;
  final DateTime performedAt;
  final String? assistant;
  final String? resident;
  final String origin;
  final String? guardia;
  final String? note;

  DraftProcedure({
    required this.procedureId,
    required this.procedureName,
    required this.performedAt,
    this.assistant,
    this.resident,
    required this.origin,
    this.guardia,
    this.note,
  });
}
