import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nutrivigil/core/di/dependencies.dart';
import 'package:nutrivigil/core/routes/app_router.dart';
import 'package:nutrivigil/domain/care_episode/care_episode.dart';
import 'package:nutrivigil/presentation/follow_up/cubit/patient_timeline_cubit.dart';
import 'package:nutrivigil/presentation/nutrition/calculators/energy_calculator_page.dart';
import 'package:nutrivigil/presentation/widgets/empty_state.dart';

class PatientTimelinePage extends StatelessWidget {
  const PatientTimelinePage({super.key, required this.patientId});

  final String patientId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PatientTimelineCubit(sl(), sl())..load(patientId),
      child: Scaffold(
        appBar: AppBar(title: const Text('Historia Clínica')),
        floatingActionButton: Builder(
          builder: (context) => FloatingActionButton.extended(
            icon: const Icon(Icons.add_task),
            label: const Text('Nueva Reevaluación'),
            onPressed: () {
              final state = context.read<PatientTimelineCubit>().state;
              if (state.patient != null) {
                // Navigate to Energy Calculator pre-filled
                Navigator.of(context).pushNamed(
                  AppRouter.energyCalculator,
                  arguments: EnergyCalculatorPageArgs(
                    patientId: state.patient!.id,
                    patientName: state.patient!.fullName,
                    age: state.patient!.age,
                    isMale: state.patient!.sex.toLowerCase().startsWith('m'),
                    workWeightKg: state.patient!.weightKg, // Use last weight or base?
                    heightCm: state.patient!.heightCm,
                    // We could fetch last risk/ventilation status too
                  ),
                ).then((_) => context.read<PatientTimelineCubit>().load(patientId));
              }
            },
          ),
        ),
        body: BlocBuilder<PatientTimelineCubit, PatientTimelineState>(
          builder: (context, state) {
            if (state.status == TimelineStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.status == TimelineStatus.failure) {
              return Center(child: Text(state.errorMessage ?? 'Error'));
            }
            if (state.patient == null) {
              return const Center(child: Text('Cargando datos...'));
            }

            return Column(
              children: [
                _PatientHeader(patient: state.patient!),
                Expanded(
                  child: state.history.isEmpty
                      ? const EmptyState(message: 'Sin evaluaciones registradas aún.')
                      : ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: state.history.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 16),
                          itemBuilder: (context, index) {
                            final snapshot = state.history[index];
                            return _TimelineCard(
                              snapshot: snapshot,
                              index: state.history.length - index, // Reverse index interaction
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _PatientHeader extends StatelessWidget {
  const _PatientHeader({required this.patient});
  final dynamic patient; // Using dynamic because of import alias issues, but it's PatientProfile

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            patient.fullName,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text('${patient.age} años • ${patient.diagnosis}'),
          if (patient.bedNumber != null) Text('Cama: ${patient.bedNumber}'),
        ],
      ),
    );
  }
}

class _TimelineCard extends StatelessWidget {
  const _TimelineCard({required this.snapshot, required this.index});
  final EnergyPlanSnapshot snapshot;
  final int index;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
    final dateStr = snapshot.createdAt != null 
        ? dateFormat.format(snapshot.createdAt!) 
        : 'Fecha desconocida';

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  label: Text('Evaluación #$index'),
                  backgroundColor: Colors.blue.shade50,
                  labelStyle: TextStyle(color: Colors.blue.shade900, fontWeight: FontWeight.bold),
                ),
                Text(dateStr, style: const TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 12),
            _infoRow('Meta Calórica:', '${snapshot.meanCalories?.toStringAsFixed(0) ?? '--'} kcal'),
            _infoRow('Proteína:', '${snapshot.requirements.proteinGrams.toStringAsFixed(1)} g'),
            if (snapshot.requirements.method.isNotEmpty)
              _infoRow('Fórmulas:', snapshot.requirements.method),
            
            const Divider(),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                icon: const Icon(Icons.picture_as_pdf, size: 16),
                label: const Text('Ver Reporte'),
                onPressed: () {
                   // TODO: Implement Logic to load this specific snapshot into CareEpisodeCubit 
                   // and navigate to Resume/Report page.
                   // For now, it's read-only in the list.
                   ScaffoldMessenger.of(context).showSnackBar(
                     const SnackBar(content: Text('Visualización histórica detallada disponible pronto.')),
                   );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(width: 8),
          Text(value),
        ],
      ),
    );
  }
}
