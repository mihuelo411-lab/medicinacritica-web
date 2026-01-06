import 'package:drift/drift.dart';

import '../../domain/alerts/alert_entity.dart';
import 'package:nutrivigil/data/local/app_database.dart';

extension AlertRowMapper on Alert {
  AlertItem toDomain() {
    return AlertItem(
      id: id,
      patientId: patientId,
      type: type,
      message: message,
      createdAt: createdAt,
      dueDate: dueDate,
      resolved: resolved,
    );
  }
}

extension AlertItemMapper on AlertItem {
  AlertsCompanion toCompanion() {
    return AlertsCompanion(
      id: Value(id),
      patientId: Value(patientId),
      type: Value(type),
      message: Value(message),
      resolved: Value(resolved),
      createdAt: Value(createdAt),
      dueDate: Value(dueDate),
    );
  }
}
