import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrivigil/core/routes/app_router.dart';
import 'package:nutrivigil/presentation/patient/bloc/patient_list_bloc.dart';
import 'package:nutrivigil/presentation/widgets/empty_state.dart';

class FollowUpPage extends StatelessWidget {
  const FollowUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleccionar Paciente'),
        centerTitle: false,
      ),
      body: BlocBuilder<PatientListBloc, PatientListState>(
        builder: (context, state) {
          if (state.status == PatientListStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == PatientListStatus.failure) {
            return Center(child: Text(state.errorMessage ?? 'Error'));
          }
          if (state.patients.isEmpty) {
            return const EmptyState(message: 'No hay pacientes activos para seguimiento.');
          }

          return ListView.separated(
            itemCount: state.patients.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final patient = state.patients[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.teal.shade50,
                  foregroundColor: Colors.teal.shade700,
                  child: Text(patient.fullName.substring(0, 1).toUpperCase()),
                ),
                title: Text(patient.fullName),
                subtitle: Text('ID: ${patient.id} • ${patient.age} años'), // TODO: Show last evaluation date
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.of(context).pushNamed(
                    AppRouter.patientTimeline,
                    arguments: patient.id,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
