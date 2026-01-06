import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:nutrivigil/core/routes/app_router.dart';
import 'package:nutrivigil/presentation/patient/bloc/patient_list_bloc.dart';
import 'package:nutrivigil/presentation/widgets/empty_state.dart';

class PatientListPage extends StatelessWidget {
  const PatientListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pacientes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<PatientListBloc>().add(const PatientsRequested()),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context)
            .pushNamed(AppRouter.patientForm)
            .then((_) => context.read<PatientListBloc>().add(const PatientsRequested())),
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<PatientListBloc, PatientListState>(
        builder: (context, state) {
          if (state.status == PatientListStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == PatientListStatus.failure) {
            return EmptyState(message: state.errorMessage ?? 'Error al cargar pacientes');
          }

          if (state.patients.isEmpty) {
            return const EmptyState(message: 'Sin pacientes registrados todavía.');
          }

          return ListView.separated(
            itemCount: state.patients.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final patient = state.patients[index];
              return ListTile(
                title: Text(patient.fullName),
                subtitle: Text('${patient.age} años • ${patient.diagnosis}'),
                onTap: () => Navigator.of(context).pushNamed(
                  AppRouter.monitoring,
                  arguments: MonitoringPageArgs(
                    patientId: patient.id,
                    patientName: patient.fullName,
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      onPressed: () => Navigator.of(context)
                          .pushNamed(
                            AppRouter.patientForm,
                            arguments: patient.id,
                          )
                          .then((_) => context.read<PatientListBloc>().add(const PatientsRequested())),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => context.read<PatientListBloc>().add(PatientDeleted(patient.id)),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
