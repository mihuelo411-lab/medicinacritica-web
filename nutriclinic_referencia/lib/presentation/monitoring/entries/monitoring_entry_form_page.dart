import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import 'package:nutrivigil/domain/monitoring/daily_monitoring_entry.dart';
import 'package:nutrivigil/presentation/monitoring/bloc/monitoring_bloc.dart';

class MonitoringEntryFormPage extends StatefulWidget {
  const MonitoringEntryFormPage({super.key, required this.patientId});

  final String patientId;

  @override
  State<MonitoringEntryFormPage> createState() => _MonitoringEntryFormPageState();
}

class _MonitoringEntryFormPageState extends State<MonitoringEntryFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _uuid = const Uuid();

  late final TextEditingController _dateController;
  late final DateTime _selectedDate;
  late final TextEditingController _weightController;
  late final TextEditingController _fluidsController;
  late final TextEditingController _caloriesController;
  late final TextEditingController _proteinsController;
  late final TextEditingController _glucoseMinController;
  late final TextEditingController _glucoseMaxController;
  late final TextEditingController _triglyceridesController;
  late final TextEditingController _creatinineController;
  late final TextEditingController _astController;
  late final TextEditingController _altController;
  late final TextEditingController _crpController;
  late final TextEditingController _pctController;
  late final TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    final today = DateTime.now();
    _selectedDate = DateTime(today.year, today.month, today.day);
    _dateController = TextEditingController(text: _formatDate(_selectedDate));
    _weightController = TextEditingController();
    _fluidsController = TextEditingController();
    _caloriesController = TextEditingController();
    _proteinsController = TextEditingController();
    _glucoseMinController = TextEditingController();
    _glucoseMaxController = TextEditingController();
    _triglyceridesController = TextEditingController();
    _creatinineController = TextEditingController();
    _astController = TextEditingController();
    _altController = TextEditingController();
    _crpController = TextEditingController();
    _pctController = TextEditingController();
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _dateController.dispose();
    _weightController.dispose();
    _fluidsController.dispose();
    _caloriesController.dispose();
    _proteinsController.dispose();
    _glucoseMinController.dispose();
    _glucoseMaxController.dispose();
    _triglyceridesController.dispose();
    _creatinineController.dispose();
    _astController.dispose();
    _altController.dispose();
    _crpController.dispose();
    _pctController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nuevo registro diario')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _dateController,
                readOnly: true,
                decoration: const InputDecoration(labelText: 'Fecha'),
                onTap: _pickDate,
              ),
              const SizedBox(height: 12),
              _numberField(_weightController, 'Peso (kg)'),
              const SizedBox(height: 12),
              _numberField(_fluidsController, 'Balance hídrico (ml)'),
              const SizedBox(height: 12),
              _numberField(_caloriesController, 'Ingesta calórica (kcal)'),
              const SizedBox(height: 12),
              _numberField(_proteinsController, 'Proteínas (g)'),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _numberField(_glucoseMinController, 'Glucosa mín.')),
                  const SizedBox(width: 12),
                  Expanded(child: _numberField(_glucoseMaxController, 'Glucosa máx.')),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _numberField(_triglyceridesController, 'Triglicéridos')), 
                  const SizedBox(width: 12),
                  Expanded(child: _numberField(_creatinineController, 'Creatinina')),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _numberField(_astController, 'AST')), 
                  const SizedBox(width: 12),
                  Expanded(child: _numberField(_altController, 'ALT')),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _numberField(_crpController, 'PCR')), 
                  const SizedBox(width: 12),
                  Expanded(child: _numberField(_pctController, 'Procalcitonina')),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _notesController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Notas'),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.save),
                label: const Text('Guardar registro'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _numberField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
      decoration: InputDecoration(labelText: label),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      locale: const Locale('es'),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = _formatDate(picked);
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  void _submit() {
    final entry = DailyMonitoringEntry(
      id: _uuid.v4(),
      patientId: widget.patientId,
      date: _selectedDate,
      weightKg: _parseDouble(_weightController.text),
      fluidBalanceMl: _parseDouble(_fluidsController.text),
      caloricIntakeKcal: _parseDouble(_caloriesController.text),
      proteinIntakeGrams: _parseDouble(_proteinsController.text),
      glucoseMin: _parseDouble(_glucoseMinController.text),
      glucoseMax: _parseDouble(_glucoseMaxController.text),
      triglyceridesMgDl: _parseDouble(_triglyceridesController.text),
      creatinineMgDl: _parseDouble(_creatinineController.text),
      ast: _parseDouble(_astController.text),
      alt: _parseDouble(_altController.text),
      cReactiveProtein: _parseDouble(_crpController.text),
      procalcitonin: _parseDouble(_pctController.text),
      notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
    );
    context.read<MonitoringBloc>().add(MonitoringEntrySaved(entry));
    Navigator.of(context).pop();
  }

  double? _parseDouble(String value) {
    if (value.isEmpty) {
      return null;
    }
    return double.tryParse(value);
  }
}
