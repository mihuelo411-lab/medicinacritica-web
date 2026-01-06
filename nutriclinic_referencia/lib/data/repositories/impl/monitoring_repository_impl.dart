import 'package:uuid/uuid.dart';

import 'package:nutrivigil/data/local/daos/monitoring_dao.dart';
import 'package:nutrivigil/data/mappers/monitoring_mapper.dart';
import 'package:nutrivigil/data/repositories/monitoring_repository.dart';
import 'package:nutrivigil/domain/monitoring/daily_monitoring_entry.dart';

class MonitoringRepositoryImpl implements MonitoringRepository {
  MonitoringRepositoryImpl(this._dao, {Uuid? uuid}) : _uuid = uuid ?? const Uuid();

  final MonitoringDao _dao;
  final Uuid _uuid;

  @override
  Future<List<DailyMonitoringEntry>> fetchByPatient(String patientId) async {
    final rows = await _dao.forPatient(patientId);
    return rows.map((row) => row.toDomain()).toList();
  }

  @override
  Future<void> save(DailyMonitoringEntry entry) async {
    final identifier = entry.id.isEmpty ? _uuid.v4() : entry.id;
    await _dao.addEntry(entry.copyWith(id: identifier).toCompanion());
  }

  @override
  Future<void> delete(String entryId) {
    return _dao.deleteEntry(entryId);
  }
}
