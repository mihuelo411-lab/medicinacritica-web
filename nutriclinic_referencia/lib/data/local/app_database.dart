import 'package:drift/drift.dart';
import 'package:nutrivigil/data/local/connection/open_connection.dart';

part 'app_database.g.dart';

class Patients extends Table {
  TextColumn get id => text()();
  TextColumn get fullName => text()();
  IntColumn get age => integer()();
  TextColumn get sex => text()();
  TextColumn get diagnosis => text()();
  RealColumn get weightKg => real()();
  RealColumn get heightCm => real()();
  TextColumn get bedNumber => text().nullable()();
  TextColumn get supportType =>
      text().nullable()(); // enteral, parenteral, mixto
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class MonitoringEntries extends Table {
  TextColumn get id => text()();
  TextColumn get patientId => text().references(Patients, #id)();
  DateTimeColumn get date => dateTime()();
  RealColumn get weightKg => real().nullable()();
  RealColumn get fluidBalanceMl => real().nullable()();
  RealColumn get caloricIntakeKcal => real().nullable()();
  RealColumn get proteinIntakeGrams => real().nullable()();
  RealColumn get glucoseMin => real().nullable()();
  RealColumn get glucoseMax => real().nullable()();
  RealColumn get triglyceridesMgDl => real().nullable()();
  RealColumn get creatinineMgDl => real().nullable()();
  RealColumn get ast => real().nullable()();
  RealColumn get alt => real().nullable()();
  RealColumn get cReactiveProtein => real().nullable()();
  RealColumn get procalcitonin => real().nullable()();
  TextColumn get notes => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class NutritionTargets extends Table {
  TextColumn get id => text()();
  TextColumn get patientId => text().references(Patients, #id)();
  TextColumn get method => text()();
  RealColumn get caloriesPerDay => real()();
  RealColumn get proteinGrams => real()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class Alerts extends Table {
  TextColumn get id => text()();
  TextColumn get patientId => text().references(Patients, #id)();
  TextColumn get type =>
      text()(); // falta_dato, exceso_trigliceridos, bajo_aporte, etc.
  TextColumn get message => text()();
  BoolColumn get resolved => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get dueDate => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class NutritionalAssessments extends Table {
  TextColumn get id => text()();
  TextColumn get patientId => text().references(Patients, #id)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  RealColumn get nutricScore => real().nullable()();
  RealColumn get nrsScore => real().nullable()();
  RealColumn get apacheScore => real().nullable()();
  RealColumn get sofaScore => real().nullable()();
  TextColumn get pendingItemsJson => text().nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get traceJson => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class WeightAssessments extends Table {
  TextColumn get id => text()();
  TextColumn get patientId => text().references(Patients, #id)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  RealColumn get weightRealKg => real().nullable()();
  RealColumn get heightCm => real().nullable()();
  TextColumn get heightMethod => text().nullable()();
  TextColumn get weightSource => text().nullable()(); // bascula, cama, estimado
  TextColumn get confidence => text().nullable()(); // alta, media, baja
  RealColumn get bmi => real().nullable()();
  RealColumn get idealWeightKg => real().nullable()();
  RealColumn get adjustedWeightKg => real().nullable()();
  RealColumn get workWeightKg => real().nullable()();
  TextColumn get workWeightLabel => text().nullable()();
  RealColumn get proteinBaseKg => real().nullable()();
  RealColumn get kcalBaseKg => real().nullable()();
  TextColumn get overrideJustification => text().nullable()();
  RealColumn get kneeHeightCm => real().nullable()();
  RealColumn get ulnaLengthCm => real().nullable()();
  RealColumn get estimatedHeightCm => real().nullable()();
  BoolColumn get obesitySuspected =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get edemaPresent => boolean().withDefault(const Constant(false))();
  BoolColumn get ascitesPresent =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get dryWeightConfirmed =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get amputationsPresent =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get pregnancyPresent =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get spinalIssues => boolean().withDefault(const Constant(false))();
  TextColumn get ascitesSeverity => text().nullable()(); // moderada, severa
  TextColumn get amputationsJson => text().nullable()();
  TextColumn get pendingActionsJson => text().nullable()();
  TextColumn get traceJson => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class EnergyPlans extends Table {
  TextColumn get id => text()();
  TextColumn get patientId => text().references(Patients, #id)();
  TextColumn get snapshotJson => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(
  tables: [
    Patients,
    MonitoringEntries,
    NutritionTargets,
    Alerts,
    WeightAssessments,
    NutritionalAssessments,
    EnergyPlans,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openConnection());

  @override
  int get schemaVersion => 6;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (migrator, from, to) async {
          if (from < 2) {
            await migrator.addColumn(patients, patients.bedNumber);
          }
          if (from < 3) {
            await migrator.createTable(weightAssessments);
          }
          if (from < 4) {
            await migrator.createTable(nutritionalAssessments);
          }
          if (from < 5) {
            await migrator.addColumn(
              nutritionalAssessments,
              nutritionalAssessments.traceJson,
            );
          }
          if (from < 6) {
            await migrator.createTable(energyPlans);
          }
        },
      );
}
