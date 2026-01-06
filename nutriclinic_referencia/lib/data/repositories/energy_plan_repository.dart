import 'package:nutrivigil/domain/care_episode/care_episode.dart';

abstract class EnergyPlanRepository {
  Future<void> saveSnapshot({
    required String patientId,
    required EnergyPlanSnapshot snapshot,
  });

  Future<EnergyPlanSnapshot?> latestSnapshot(String patientId);
  
  Future<List<EnergyPlanSnapshot>> historyForPatient(String patientId);
}
