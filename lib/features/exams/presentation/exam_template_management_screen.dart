import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../main.dart';
import '../../../core/database/database.dart';
import '../data/exam_repository.dart';
import '../../../core/services/sync_service.dart';
import '../../../core/services/supabase_service.dart';

class ExamTemplateManagementScreen extends StatefulWidget {
  const ExamTemplateManagementScreen({super.key});

  @override
  State<ExamTemplateManagementScreen> createState() => _ExamTemplateManagementScreenState();
}

class _ExamTemplateManagementScreenState extends State<ExamTemplateManagementScreen> {
  bool _loading = true;
  List<ExamTemplate> _templates = [];

  @override
  void initState() {
    super.initState();
    _loadTemplates();
  }

  Future<void> _loadTemplates() async {
    setState(() => _loading = true);
    try {
      await SyncService(appDatabase, SupabaseService()).syncAll();
    } catch (e) {
      debugPrint('Sync exams failed: $e');
    }
    final list = await examRepository.fetchTemplates(includeArchived: true);
    if (!mounted) return;
    setState(() {
      _templates = list;
      _loading = false;
    });
  }

  Future<void> _openEditor({ExamTemplate? template}) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => _TemplateEditorDialog(template: template),
    );
    if (result == true) {
      _loadTemplates();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plantillas de exámenes'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openEditor(),
        icon: const Icon(Icons.add),
        label: const Text('Nueva plantilla'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadTemplates,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _templates.length,
                itemBuilder: (context, index) {
                  final template = _templates[index];
                  final fields = _safeFields(template);
                  return Card(
                    child: ListTile(
                      title: Text(template.name),
                      subtitle: Text(fields.isEmpty
                          ? 'Sin campos definidos'
                          : '${fields.length} campos • ${template.category ?? 'Sin categoría'}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _openEditor(template: template),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }

  List<ExamFieldConfig> _safeFields(ExamTemplate template) {
    try {
      final data = jsonDecode(template.fieldsJson);
      if (data is List) {
        return data
            .whereType<Map>()
            .map((item) => ExamFieldConfig.fromMap(Map<String, dynamic>.from(item as Map)))
            .toList();
      }
    } catch (_) {}
    return const [];
  }
}

class _TemplateEditorDialog extends StatefulWidget {
  final ExamTemplate? template;
  const _TemplateEditorDialog({this.template});

  @override
  State<_TemplateEditorDialog> createState() => _TemplateEditorDialogState();
}

class _TemplateEditorDialogState extends State<_TemplateEditorDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtl;
  late TextEditingController _categoryCtl;
  late TextEditingController _descriptionCtl;
  final List<_EditableField> _fields = [];
  bool _archived = false;

  @override
  void initState() {
    super.initState();
    final template = widget.template;
    _nameCtl = TextEditingController(text: template?.name ?? '');
    _categoryCtl = TextEditingController(text: template?.category ?? '');
    _descriptionCtl = TextEditingController(text: template?.description ?? '');
    _archived = template?.isArchived ?? false;
    if (template != null) {
      try {
        final decoded = jsonDecode(template.fieldsJson);
        if (decoded is List) {
          for (final item in decoded) {
            if (item is Map) {
              _fields.add(_EditableField.fromMap(Map<String, dynamic>.from(item as Map)));
            }
          }
        }
      } catch (_) {}
    }
    if (_fields.isEmpty) {
      _fields.add(_EditableField());
    }
  }

  @override
  void dispose() {
    _nameCtl.dispose();
    _categoryCtl.dispose();
    _descriptionCtl.dispose();
    for (final field in _fields) {
      field.dispose();
    }
    super.dispose();
  }

  void _addField() {
    setState(() {
      _fields.add(_EditableField());
    });
  }

  void _removeField(int index) {
    if (_fields.length == 1) return;
    setState(() {
      _fields.removeAt(index);
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final configs = _fields
        .where((field) => field.labelCtl.text.trim().isNotEmpty)
        .map(
          (field) => ExamFieldConfig(
            id: field.idCtl.text.trim().isEmpty ? field.generateId() : field.idCtl.text.trim(),
            label: field.labelCtl.text.trim(),
            type: field.type,
            unit: field.unitCtl.text.trim().isEmpty ? null : field.unitCtl.text.trim(),
            minValue: field.minCtl.text.trim().isEmpty ? null : num.tryParse(field.minCtl.text.trim()),
            maxValue: field.maxCtl.text.trim().isEmpty ? null : num.tryParse(field.maxCtl.text.trim()),
            isCritical: field.isCritical,
          ),
        )
        .toList();
    if (configs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Agrega al menos un campo')));
      return;
    }
    await examRepository.saveTemplate(
      id: widget.template?.id,
      name: _nameCtl.text.trim(),
      category: _categoryCtl.text.trim().isEmpty ? null : _categoryCtl.text.trim(),
      description: _descriptionCtl.text.trim().isEmpty ? null : _descriptionCtl.text.trim(),
      fields: configs,
      archived: _archived,
    );
    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.template == null ? 'Nueva plantilla' : 'Editar plantilla'),
      content: SizedBox(
        width: 520,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameCtl,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                  validator: (value) => value == null || value.trim().isEmpty ? 'Requerido' : null,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _categoryCtl,
                  decoration: const InputDecoration(labelText: 'Categoría (opcional)'),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _descriptionCtl,
                  maxLines: 2,
                  decoration: const InputDecoration(labelText: 'Descripción'),
                ),
                const SizedBox(height: 12),
                SwitchListTile(
                  value: _archived,
                  onChanged: (value) => setState(() => _archived = value),
                  title: const Text('Archivar plantilla'),
                  subtitle: const Text('Las plantillas archivadas no aparecerán en los formularios.'),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Campos', style: Theme.of(context).textTheme.titleMedium),
                ),
                const SizedBox(height: 8),
                ..._fields.asMap().entries.map((entry) {
                  final index = entry.key;
                  final field = entry.value;
                  return _FieldCard(
                    key: ValueKey(field),
                    field: field,
                    onRemove: () => _removeField(index),
                  );
                }),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: _addField,
                    icon: const Icon(Icons.add),
                    label: const Text('Agregar campo'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
        FilledButton(onPressed: _save, child: const Text('Guardar')),
      ],
    );
  }
}

class _FieldCard extends StatelessWidget {
  final _EditableField field;
  final VoidCallback onRemove;
  const _FieldCard({required Key key, required this.field, required this.onRemove}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: field.labelCtl,
                    decoration: const InputDecoration(labelText: 'Etiqueta'),
                    validator: (value) => value == null || value.trim().isEmpty ? 'Requerido' : null,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: onRemove,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: field.type,
                    decoration: const InputDecoration(labelText: 'Tipo'),
                    items: const [
                      DropdownMenuItem(value: 'number', child: Text('Numérico')),
                      DropdownMenuItem(value: 'text', child: Text('Texto')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        field.type = value;
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: field.unitCtl,
                    decoration: const InputDecoration(labelText: 'Unidad'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: field.minCtl,
                    decoration: const InputDecoration(labelText: 'Mínimo'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: field.maxCtl,
                    decoration: const InputDecoration(labelText: 'Máximo'),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              value: field.isCritical,
              onChanged: (value) => field.isCritical = value ?? false,
              title: const Text('Resaltar cuando se salga de rango'),
            ),
          ],
        ),
      ),
    );
  }
}

class _EditableField {
  final TextEditingController idCtl;
  final TextEditingController labelCtl;
  final TextEditingController unitCtl;
  final TextEditingController minCtl;
  final TextEditingController maxCtl;
  bool isCritical;
  String type;

  _EditableField({
    String? id,
    String? label,
    this.type = 'number',
    String? unit,
    num? minValue,
    num? maxValue,
    this.isCritical = false,
  })  : idCtl = TextEditingController(text: id ?? ''),
        labelCtl = TextEditingController(text: label ?? ''),
        unitCtl = TextEditingController(text: unit ?? ''),
        minCtl = TextEditingController(text: minValue?.toString() ?? ''),
        maxCtl = TextEditingController(text: maxValue?.toString() ?? '');

  factory _EditableField.fromMap(Map<String, dynamic> map) {
    return _EditableField(
      id: map['id']?.toString(),
      label: map['label']?.toString(),
      type: map['type']?.toString() ?? 'number',
      unit: map['unit']?.toString(),
      minValue: map['minValue'] is num ? map['minValue'] : num.tryParse('${map['minValue']}'),
      maxValue: map['maxValue'] is num ? map['maxValue'] : num.tryParse('${map['maxValue']}'),
      isCritical: map['isCritical'] == true,
    );
  }

  String generateId() => labelCtl.text.trim().toLowerCase().replaceAll(' ', '_');

  void dispose() {
    idCtl.dispose();
    labelCtl.dispose();
    unitCtl.dispose();
    minCtl.dispose();
    maxCtl.dispose();
  }
}
