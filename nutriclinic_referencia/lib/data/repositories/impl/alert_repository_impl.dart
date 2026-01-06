import 'package:uuid/uuid.dart';

import 'package:nutrivigil/data/local/daos/alert_dao.dart';
import 'package:nutrivigil/data/mappers/alert_mapper.dart';
import 'package:nutrivigil/data/repositories/alert_repository.dart';
import 'package:nutrivigil/domain/alerts/alert_entity.dart';

class AlertRepositoryImpl implements AlertRepository {
  AlertRepositoryImpl(this._dao, {Uuid? uuid}) : _uuid = uuid ?? const Uuid();

  final AlertDao _dao;
  final Uuid _uuid;

  @override
  Future<List<AlertItem>> fetchPending() async {
    final rows = await _dao.pendingAlerts();
    return rows.map((row) => row.toDomain()).toList();
  }

  @override
  Future<List<AlertItem>> fetchByPatient(String patientId) async {
    final rows = await _dao.alertsForPatient(patientId);
    return rows.map((row) => row.toDomain()).toList();
  }

  @override
  Future<void> save(AlertItem alert) {
    final model = alert.id.isEmpty ? alert.copyWith(id: _uuid.v4()) : alert;
    return _dao.upsertAlert(model.toCompanion());
  }

  @override
  Future<void> markResolved(String id) {
    return _dao.markResolved(id);
  }
}
