import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:nutrivigil/domain/patient/patient_entity.dart';
import 'package:nutrivigil/core/di/dependencies.dart';
import 'package:nutrivigil/core/routes/app_router.dart';
import 'package:nutrivigil/presentation/patient/bloc/patient_form_cubit.dart';
import 'package:nutrivigil/domain/care_episode/care_episode_cubit.dart';

class PatientFormPage extends StatefulWidget {
  const PatientFormPage({super.key, this.patientId});

  final String? patientId;

  @override
  State<PatientFormPage> createState() => _PatientFormPageState();
}

class _PatientFormPageState extends State<PatientFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _ageController;
  late final TextEditingController _diagnosisController;
  late final TextEditingController _weightController;
  late final TextEditingController _heightController;
  late final TextEditingController _bedNumberController;
  String? _selectedSupport;
  String? _selectedSex;
  static const List<String> _sexOptions = ['Hombre', 'Mujer'];
  static const List<String> _supportOptions = [
    'Sin soporte',
    'Enteral',
    'Parenteral',
    'Mixto',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _ageController = TextEditingController();
    _diagnosisController = TextEditingController();
    _weightController = TextEditingController();
    _heightController = TextEditingController();
    _bedNumberController = TextEditingController();
    _selectedSupport = 'Sin soporte';

    context.read<PatientFormCubit>().loadPatient(widget.patientId);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _diagnosisController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _bedNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PatientFormCubit, PatientFormState>(
      listenWhen: (previous, current) =>
          previous.patient != current.patient || current.saveSuccess,
      listener: (context, state) {
        final patient = state.patient;
        if (patient != null) {
          _populate(patient);
        }
        if (state.saveSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Paciente guardado correctamente')),
          );
          final savedPatient = state.patient;
          final episodeCubit = sl<CareEpisodeCubit>();
          if (widget.patientId == null) {
            episodeCubit.reset();
          }
          if (savedPatient != null) {
            episodeCubit.setPatient(savedPatient);
          }
          if (widget.patientId == null && savedPatient != null) {
            Navigator.of(context).pushNamed(
              AppRouter.weightAssessment,
              arguments: WeightAssessmentPageArgs(patientId: savedPatient.id),
            );
          } else {
            Navigator.of(context).pop(savedPatient);
          }
        }
        if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error!)),
          );
        }
      },
      builder: (context, state) {
        final isEditing = widget.patientId != null;
        return Scaffold(
          appBar: AppBar(
              title: Text(isEditing ? 'Editar paciente' : 'Nuevo paciente')),
          body: state.patient == null && !state.isSaving
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      children: [
                        const Text('Datos generales',
                            style: TextStyle(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                              labelText: 'Nombre completo'),
                          validator: (value) => value == null || value.isEmpty
                              ? 'Requerido'
                              : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _ageController,
                          decoration: const InputDecoration(labelText: 'Edad'),
                          keyboardType: TextInputType.number,
                          validator: _numericValidator,
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          value: _selectedSex,
                          items: _sexOptions
                              .map(
                                (option) => DropdownMenuItem<String>(
                                  value: option,
                                  child: Text(option),
                                ),
                              )
                              .toList(),
                          decoration: const InputDecoration(labelText: 'Sexo'),
                          hint: const Text('Seleccione sexo'),
                          onChanged: (value) =>
                              setState(() => _selectedSex = value),
                          validator: (value) => value == null || value.isEmpty
                              ? 'Seleccione una opción'
                              : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _bedNumberController,
                          decoration: const InputDecoration(
                              labelText: 'Número de cama'),
                          textCapitalization: TextCapitalization.characters,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _diagnosisController,
                          decoration: const InputDecoration(
                              labelText: 'Diagnóstico principal'),
                          maxLines: 2,
                        ),
                        const SizedBox(height: 24),
                        const Text('Antropometría',
                            style: TextStyle(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _weightController,
                          decoration: const InputDecoration(
                            labelText: 'Peso actual (kg)',
                            helperText: 'Solo registra valores confirmados/peso en seco.',
                          ),
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          validator: _numericValidator,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _heightController,
                          decoration:
                              const InputDecoration(
                            labelText: 'Talla (cm)',
                            helperText: 'Captura únicamente si la talla es confiable/verificada.',
                          ),
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          validator: _numericValidator,
                        ),
                        const SizedBox(height: 24),
                        const Text('Soporte nutricional',
                            style: TextStyle(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          value: _selectedSupport,
                          items: _supportOptions
                              .map(
                                (option) => DropdownMenuItem(
                                  value: option,
                                  child: Text(option),
                                ),
                              )
                              .toList(),
                          decoration: const InputDecoration(
                            labelText: 'Tipo de soporte',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) =>
                              setState(() => _selectedSupport = value),
                        ),
                        const SizedBox(height: 24),
                        FilledButton.icon(
                          onPressed:
                              state.isSaving ? null : () => _submit(context),
                          icon: state.isSaving
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.save),
                          label: Text(isEditing ? 'Actualizar' : 'Crear'),
                        ),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }

  void _populate(PatientProfile patient) {
    setState(() {
      _nameController.text = patient.fullName;
      _ageController.text = patient.age.toString();
      _selectedSex = _mapExistingSex(patient.sex);
      _bedNumberController.text = patient.bedNumber ?? '';
      _diagnosisController.text = patient.diagnosis;
      _weightController.text =
          patient.weightKg > 0 ? patient.weightKg.toStringAsFixed(1) : '';
      _heightController.text =
          patient.heightCm > 0 ? patient.heightCm.toStringAsFixed(1) : '';
      _selectedSupport = _supportOptions.firstWhere(
        (option) =>
            option.toLowerCase() == (patient.supportType ?? '').toLowerCase(),
        orElse: () => 'Sin soporte',
      );
    });
  }

  String? _mapExistingSex(String value) {
    final normalized = value.toLowerCase().trim();
    if (normalized.isEmpty) {
      return null;
    }
    if (normalized.contains('mascul') || normalized.contains('hombre')) {
      return 'Hombre';
    }
    if (normalized.contains('femen') || normalized.contains('mujer')) {
      return 'Mujer';
    }
    return null;
  }

  String? _numericValidator(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    return double.tryParse(value) == null ? 'Valor numérico no válido' : null;
  }

  void _submit(BuildContext context) {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final current = context.read<PatientFormCubit>().state.patient ??
        const PatientProfile(
          id: '',
          fullName: '',
          age: 0,
          sex: '',
          diagnosis: '',
          weightKg: 0,
          heightCm: 0,
        );
    final bedNumber = _bedNumberController.text.trim();
    final profile = current.copyWith(
      fullName: _nameController.text.trim(),
      age: int.tryParse(_ageController.text) ?? current.age,
      sex: (_selectedSex ?? current.sex).trim(),
      diagnosis: _diagnosisController.text.trim(),
      bedNumber: bedNumber.isEmpty ? null : bedNumber,
      weightKg: double.tryParse(_weightController.text) ?? current.weightKg,
      heightCm: double.tryParse(_heightController.text) ?? current.heightCm,
      supportType: _selectedSupport == null || _selectedSupport == 'Sin soporte'
          ? null
          : _selectedSupport,
    );
    context.read<PatientFormCubit>().save(profile);
  }
}
