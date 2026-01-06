import 'dart:convert';

import 'package:uuid/uuid.dart';

import 'package:nutrivigil/data/local/daos/energy_plan_dao.dart';
import 'package:nutrivigil/data/mappers/energy_plan_mapper.dart';
import 'package:nutrivigil/data/repositories/energy_plan_repository.dart';
import 'package:nutrivigil/domain/care_episode/care_episode.dart';

class EnergyPlanRepositoryImpl implements EnergyPlanRepository {
  EnergyPlanRepositoryImpl(this._dao, {Uuid? uuid}) : _uuid = uuid ?? const Uuid();

  final EnergyPlanDao _dao;
  final Uuid _uuid;

  @override
  Future<void> saveSnapshot({
    required String patientId,
    required EnergyPlanSnapshot snapshot,
  }) async {
    final json = jsonEncode(snapshot.toJson());
    await _dao.insertSnapshot(_uuid.v4(), patientId, json);
  }

  @override
  Future<EnergyPlanSnapshot?> latestSnapshot(String patientId) async {
    final row = await _dao.latestForPatient(patientId);
    if (row == null) {
      return null;
    }
    return EnergyPlanSnapshotJsonMapper.fromJson(jsonDecode(row.snapshotJson));
  }

  @override
  Future<List<EnergyPlanSnapshot>> historyForPatient(String patientId) async {
    final rows = await _dao.historyForPatient(patientId);
    return rows.map((row) {
      final json = jsonDecode(row.snapshotJson);
      return EnergyPlanSnapshotJsonMapper.fromJson(json, createdAt: row.createdAt);
    }).toList();
  }
}
