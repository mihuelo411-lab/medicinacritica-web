import 'dart:convert';
import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../patients/data/patient_repository.dart';
import '../../auth/domain/current_user.dart';
import '../../../main.dart';
import '../data/exam_repository.dart';
import '../../../core/database/database.dart';
import '../../../core/services/sync_service.dart';
import '../../../core/services/supabase_service.dart';

class ExamResultsScreen extends StatefulWidget {
  final ActiveAdmission activeAdmission;
  const ExamResultsScreen({super.key, required this.activeAdmission});

  @override
  State<ExamResultsScreen> createState() => _ExamResultsScreenState();
}

class _ExamResultsScreenState extends State<ExamResultsScreen> {
  bool _loading = true;
  List<ExamResultEntry> _results = [];
  List<ExamTemplate> _templates = [];
  final Map<int, List<ExamFieldConfig>> _templateFields = {};
  final Map<String, _FieldHistory> _fieldHistories = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    try {
      await SyncService(appDatabase, SupabaseService()).syncAll();
    } catch (e) {
      debugPrint('Sync exams failed: $e');
    }
    final templates = await examRepository.fetchTemplates();
    final results = await examRepository.fetchResultsForAdmission(widget.activeAdmission.admission.id);
    final fieldsByTemplate = <int, List<ExamFieldConfig>>{};
    for (final template in templates) {
      fieldsByTemplate[template.id] = await examRepository.getTemplateFields(template);
    }
    final histories = _buildFieldHistories(results, fieldsByTemplate);
    if (!mounted) return;
    setState(() {
      _templates = templates;
      _results = results;
      _templateFields
        ..clear()
        ..addAll(fieldsByTemplate);
      _fieldHistories
        ..clear()
        ..addAll(histories);
      _loading = false;
    });
  }

  Future<void> _openRegisterSheet() async {
    final success = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (context) => ExamResultFormSheet(
        templates: _templates,
        admission: widget.activeAdmission,
      ),
    );
    if (success == true) {
      _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final patient = widget.activeAdmission.patient;
    final admission = widget.activeAdmission.admission;
    final visibleTemplates = _templates.where((template) {
      final fields = _templateFields[template.id] ?? const [];
      if (fields.isEmpty) return false;
      return fields.any(
        (field) =>
            (_fieldHistories['${template.id}:${field.id}']?.entries.isNotEmpty ??
                false),
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Exámenes auxiliares'),
            Text('${patient.name} • Cama ${admission.bedNumber ?? '-'}',
                style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _templates.isEmpty ? null : _openRegisterSheet,
        icon: const Icon(Icons.add),
        label: const Text('Registrar'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: visibleTemplates.isEmpty
                  ? const Center(
                      child: Text('Aún no hay exámenes registrados.'),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: visibleTemplates.length,
                      itemBuilder: (context, index) {
                        final template = visibleTemplates[index];
                        final fields = _templateFields[template.id] ?? const [];
                        return _TemplateCard(
                          template: template,
                          fields: fields,
                          histories: _fieldHistories,
                          onFieldTap: (history) => _showFieldHistory(history),
                        );
                      },
                    ),
            ),
    );
  }

  Map<String, dynamic> _parseValues(String raw) {
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map) {
        return Map<String, dynamic>.from(
          decoded.map((key, value) => MapEntry(key.toString(), value)),
        );
      }
    } catch (_) {}
    return {};
  }

  Map<String, _FieldHistory> _buildFieldHistories(
    List<ExamResultEntry> results,
    Map<int, List<ExamFieldConfig>> fieldsByTemplate,
  ) {
    final histories = <String, _FieldHistory>{};
    for (final entry in results) {
      final template = entry.template;
      final fields = fieldsByTemplate[template.id] ?? const [];
      if (fields.isEmpty) continue;
      final values = _parseValues(entry.result.valuesJson);
      for (final field in fields) {
        final dynamic raw = values[field.id];
        final key = '${template.id}:${field.id}';
        final history = histories.putIfAbsent(
          key,
          () => _FieldHistory(template: template, field: field),
        );
        history.entries.add(
          _FieldEntry(
            recordedAt: entry.result.recordedAt,
            value: raw?.toString() ?? '',
          ),
        );
        if (field.type == 'number' && raw != null) {
          final num? numeric = raw is num ? raw : num.tryParse(raw.toString());
          if (numeric != null) {
            history.points.add(
              _FieldPoint(recordedAt: entry.result.recordedAt, value: numeric.toDouble()),
            );
          }
        }
      }
    }
    for (final history in histories.values) {
      history.entries.sort((a, b) => b.recordedAt.compareTo(a.recordedAt));
      history.points.sort((a, b) => a.recordedAt.compareTo(b.recordedAt));
    }
    return histories;
  }

  Future<void> _showFieldHistory(_FieldHistory history) async {
    if (history.entries.isEmpty) return;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        final points = List<_FieldPoint>.from(history.points);
        final showTrend = points.length >= 2;
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text(history.field.label),
                  subtitle: Text(history.template.name),
                  trailing: Text('${history.entries.length} registros'),
                ),
                if (showTrend)
                  SizedBox(
                    height: 220,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: LineChart(
                        LineChartData(
                          lineBarsData: [
                            LineChartBarData(
                              spots: List.generate(
                                points.length,
                                (index) =>
                                    FlSpot(index.toDouble(), points[index].value),
                              ),
                              isCurved: false,
                              color: Colors.indigo,
                              dotData: const FlDotData(show: true),
                            ),
                          ],
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 32,
                                interval: math.max(1, (points.length - 1) / 3),
                                getTitlesWidget: (value, meta) {
                                  final index = value.round();
                                  if (index < 0 || index >= points.length) {
                                    return const SizedBox.shrink();
                                  }
                                  final step =
                                      math.max(1, (points.length / 3).floor());
                                  if (index != 0 &&
                                      index != points.length - 1 &&
                                      index % step != 0) {
                                    return const SizedBox.shrink();
                                  }
                                  final date = points[index].recordedAt;
                                  return Text(
                                    DateFormat('dd/MM').format(date),
                                    style: const TextStyle(fontSize: 10),
                                  );
                                },
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                                getTitlesWidget: (value, meta) => Text(
                                  value.toStringAsFixed(1),
                                  style: const TextStyle(fontSize: 10),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(16),
                    itemCount: history.entries.length,
                    separatorBuilder: (_, __) => const Divider(height: 8),
                    itemBuilder: (context, index) {
                      final entry = history.entries[index];
                      return ListTile(
                        dense: true,
                        title: Text(entry.value.isEmpty ? '-' : entry.value),
                        subtitle: Text(DateFormat('dd/MM/yyyy HH:mm').format(entry.recordedAt)),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _TemplateCard extends StatelessWidget {
  final ExamTemplate template;
  final List<ExamFieldConfig> fields;
  final Map<String, _FieldHistory> histories;
  final ValueChanged<_FieldHistory> onFieldTap;

  const _TemplateCard({
    required this.template,
    required this.fields,
    required this.histories,
    required this.onFieldTap,
  });

  @override
  Widget build(BuildContext context) {
    final description = template.description?.trim();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(template.name, style: Theme.of(context).textTheme.titleMedium),
            if (description != null && description.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4, bottom: 8),
                child: Text(description, style: const TextStyle(color: Colors.grey)),
              ),
            if (fields.isEmpty)
              const Text('No hay campos configurados para esta plantilla.'),
            ...fields.map((field) {
              final history = histories['${template.id}:${field.id}'];
              final latest = history?.entries.isNotEmpty == true ? history!.entries.first : null;
              final hasEntries = history != null && history.entries.isNotEmpty;
              final subtitle = hasEntries
                  ? 'Último: ${latest!.value}${field.unit != null ? ' ${field.unit}' : ''}'
                  : 'Sin datos registrados';
              final trailing = hasEntries
                  ? Text(
                      DateFormat('dd/MM HH:mm').format(latest!.recordedAt),
                      style: const TextStyle(fontSize: 12),
                    )
                  : null;
              return ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(field.label),
                subtitle: Text(subtitle),
                trailing: trailing,
                onTap: hasEntries ? () => onFieldTap(history!) : null,
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _FieldHistory {
  final ExamTemplate template;
  final ExamFieldConfig field;
  final List<_FieldEntry> entries = [];
  final List<_FieldPoint> points = [];

  _FieldHistory({required this.template, required this.field});
}

class _FieldEntry {
  final DateTime recordedAt;
  final String value;
  _FieldEntry({required this.recordedAt, required this.value});
}

class _FieldPoint {
  final DateTime recordedAt;
  final double value;
  _FieldPoint({required this.recordedAt, required this.value});
}


class ExamResultFormSheet extends StatefulWidget {
  final List<ExamTemplate> templates;
  final ActiveAdmission admission;
  const ExamResultFormSheet({super.key, required this.templates, required this.admission});

  @override
  State<ExamResultFormSheet> createState() => _ExamResultFormSheetState();
}

class _ExamResultFormSheetState extends State<ExamResultFormSheet> {
  ExamTemplate? _selectedTemplate;
  List<ExamFieldConfig> _fields = [];
  final Map<String, TextEditingController> _valueControllers = {};
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    for (final ctl in _valueControllers.values) {
      ctl.dispose();
    }
    _noteController.dispose();
    super.dispose();
  }

  void _onTemplateChanged(ExamTemplate? template) async {
    setState(() {
      _selectedTemplate = template;
      _fields = [];
      for (final ctl in _valueControllers.values) {
        ctl.dispose();
      }
      _valueControllers.clear();
    });
    if (template != null) {
      final fields = await examRepository.getTemplateFields(template);
      if (!mounted) return;
      setState(() {
        _fields = fields;
        for (final field in fields) {
          _valueControllers[field.id] = TextEditingController();
        }
      });
    }
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now(),
    );
    if (date == null) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDate),
    );
    final result = DateTime(
      date.year,
      date.month,
      date.day,
      time?.hour ?? _selectedDate.hour,
      time?.minute ?? _selectedDate.minute,
    );
    setState(() => _selectedDate = result);
  }

  Future<void> _submit() async {
    if (_selectedTemplate == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Selecciona una plantilla.')));
      return;
    }
    final values = <String, dynamic>{};
    for (final field in _fields) {
      final text = _valueControllers[field.id]?.text.trim() ?? '';
      if (text.isEmpty) continue;
      if (field.type == 'number') {
        final number = num.tryParse(text);
        if (number == null) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Valor inválido para ${field.label}')));
          return;
        }
        values[field.id] = number;
      } else {
        values[field.id] = text;
      }
    }
    await examRepository.saveExamResult(
      admissionId: widget.admission.admission.id,
      template: _selectedTemplate!,
      values: values,
      recordedAt: _selectedDate,
      note: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
      recordedBy: CurrentUserStore.profile?.fullName ?? 'Usuario',
    );
    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Registrar examen', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            DropdownButtonFormField<ExamTemplate>(
              value: _selectedTemplate,
              decoration: const InputDecoration(labelText: 'Plantilla'),
              items: widget.templates
                  .map((template) => DropdownMenuItem(
                        value: template,
                        child: Text(template.name),
                      ))
                  .toList(),
              onChanged: _onTemplateChanged,
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.access_time),
              title: Text(DateFormat('dd/MM/yyyy HH:mm').format(_selectedDate)),
              trailing: TextButton(
                onPressed: _pickDate,
                child: const Text('Cambiar'),
              ),
            ),
            if (_fields.isNotEmpty) ...[
              const Divider(),
              ..._fields.map((field) {
                final ctl = _valueControllers[field.id]!;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: TextField(
                    controller: ctl,
                    keyboardType: field.type == 'number' ? TextInputType.number : TextInputType.text,
                    decoration: InputDecoration(
                      labelText: '${field.label}${field.unit != null ? ' (${field.unit})' : ''}',
                      border: const OutlineInputBorder(),
                    ),
                  ),
                );
              }),
            ],
            const SizedBox(height: 8),
            TextField(
              controller: _noteController,
              decoration: const InputDecoration(labelText: 'Notas', border: OutlineInputBorder()),
              maxLines: 2,
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton(
                onPressed: _submit,
                child: const Text('Guardar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
