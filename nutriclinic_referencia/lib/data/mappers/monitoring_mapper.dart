import 'package:drift/drift.dart';

import '../../domain/monitoring/daily_monitoring_entry.dart';
import 'package:nutrivigil/data/local/app_database.dart';

extension MonitoringRowMapper on MonitoringEntry {
  DailyMonitoringEntry toDomain() {
    return DailyMonitoringEntry(
      id: id,
      patientId: patientId,
      date: date,
      weightKg: weightKg,
      fluidBalanceMl: fluidBalanceMl,
      caloricIntakeKcal: caloricIntakeKcal,
      proteinIntakeGrams: proteinIntakeGrams,
      glucoseMin: glucoseMin,
      glucoseMax: glucoseMax,
      triglyceridesMgDl: triglyceridesMgDl,
      creatinineMgDl: creatinineMgDl,
      ast: ast,
      alt: alt,
      cReactiveProtein: cReactiveProtein,
      procalcitonin: procalcitonin,
      notes: notes,
    );
  }
}

extension DailyMonitoringMapper on DailyMonitoringEntry {
  MonitoringEntriesCompanion toCompanion() {
    return MonitoringEntriesCompanion(
      id: Value(id),
      patientId: Value(patientId),
      date: Value(date),
      weightKg: Value(weightKg),
      fluidBalanceMl: Value(fluidBalanceMl),
      caloricIntakeKcal: Value(caloricIntakeKcal),
      proteinIntakeGrams: Value(proteinIntakeGrams),
      glucoseMin: Value(glucoseMin),
      glucoseMax: Value(glucoseMax),
      triglyceridesMgDl: Value(triglyceridesMgDl),
      creatinineMgDl: Value(creatinineMgDl),
      ast: Value(ast),
      alt: Value(alt),
      cReactiveProtein: Value(cReactiveProtein),
      procalcitonin: Value(procalcitonin),
      notes: Value(notes),
    );
  }
}
