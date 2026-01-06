import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/services/supabase_service.dart';
import '../../../core/services/sync_service.dart';
import '../../../main.dart';

class ExternalProcedureForm extends StatefulWidget {
  const ExternalProcedureForm({super.key});

  @override
  State<ExternalProcedureForm> createState() =>
      _ExternalProcedureFormState();
}

class _ExternalProcedureFormState extends State<ExternalProcedureForm> {
  final _patientNameCtl = TextEditingController();
  final _patientDniCtl = TextEditingController();
  final _patientHcCtl = TextEditingController();
  final _procedureCtl = TextEditingController();
  final _serviceRoomCtl = TextEditingController();
  final _diagnosisCtl = TextEditingController();
  final _assistantCtl = TextEditingController();
  final _residentCtl = TextEditingController();

  DateTime _performedAt = DateTime.now();
  bool _saving = false;

  @override
  void dispose() {
    _patientNameCtl.dispose();
    _patientDniCtl.dispose();
    _patientHcCtl.dispose();
    _procedureCtl.dispose();
    _serviceRoomCtl.dispose();
    _diagnosisCtl.dispose();
    _assistantCtl.dispose();
    _residentCtl.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _performedAt,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
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

  Future<void> _submit() async {
    final name = _patientNameCtl.text.trim();
    final dni = _patientDniCtl.text.trim();
    final hcRaw = _patientHcCtl.text.trim();
    if (name.isEmpty || dni.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Completa nombre y DNI.'),
        ),
      );
      return;
    }
    if (_procedureCtl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ingresa el nombre del procedimiento.'),
        ),
      );
      return;
    }
    setState(() => _saving = true);
    try {
      final supabase = SupabaseService();
      final patientId = await supabase.ensureExternalPatient(
        name: name,
        dni: dni,
        hc: hcRaw.isEmpty ? null : hcRaw,
      );
      await supabase.createExternalProcedure(
        patientId: patientId,
        procedureName: _procedureCtl.text.trim(),
        performedAt: _performedAt,
        serviceRoom: _serviceRoomCtl.text.trim().isEmpty
            ? null
            : _serviceRoomCtl.text.trim(),
        diagnosis: _diagnosisCtl.text.trim().isEmpty
            ? null
            : _diagnosisCtl.text.trim(),
        assistantName: _assistantCtl.text.trim().isEmpty
            ? null
            : _assistantCtl.text.trim(),
        residentName: _residentCtl.text.trim().isEmpty
            ? null
            : _residentCtl.text.trim(),
      );
      await SyncService(appDatabase, supabase).syncAll();
      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo registrar: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Procedimiento externo / interconsulta',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _patientNameCtl,
            decoration: const InputDecoration(
              labelText: 'Nombre del paciente',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _patientDniCtl,
                  decoration: const InputDecoration(
                    labelText: 'DNI',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _patientHcCtl,
                  decoration: const InputDecoration(
                    labelText: 'Historia clínica',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _procedureCtl,
            decoration: const InputDecoration(
              labelText: 'Procedimiento',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _serviceRoomCtl,
            decoration: const InputDecoration(
              labelText: 'Servicio / Cama',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _diagnosisCtl,
            decoration: const InputDecoration(
              labelText: 'Diagnóstico',
              border: OutlineInputBorder(),
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _assistantCtl,
                  decoration: const InputDecoration(
                    labelText: 'Asistente',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _residentCtl,
                  decoration: const InputDecoration(
                    labelText: 'Residente',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              TextButton.icon(
                onPressed: _pickDateTime,
                icon: const Icon(Icons.schedule),
                label: Text(
                  DateFormat('dd/MM/yyyy HH:mm').format(_performedAt),
                ),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: _saving ? null : _submit,
                icon: _saving
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save_outlined),
                label: const Text('Guardar'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
