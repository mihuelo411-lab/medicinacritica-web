import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'database.g.dart';

class Patients extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get dni => text().unique()();
  TextColumn get hc => text().unique()(); // Historia Clinica
  IntColumn get age => integer()();
  TextColumn get sex => text()();
  TextColumn get address => text().nullable()();
  TextColumn get occupation => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get familyContact => text().nullable()();
  TextColumn get placeOfBirth => text().nullable()();
  TextColumn get insuranceType => text().nullable()();
  
  // Audit / Sync
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
}

class Admissions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get patientId => integer().references(Patients, #id)();
  DateTimeColumn get admissionDate => dateTime()();
  
  // Scores
  RealColumn get sofaScore => real().nullable()();
  RealColumn get apacheScore => real().nullable()();
  RealColumn get nutricScore => real().nullable()();
  TextColumn get sofaMortality => text().nullable()();
  TextColumn get apacheMortality => text().nullable()();
  
  // Clinical
  TextColumn get diagnosis => text().nullable()();
  TextColumn get signsSymptoms => text().nullable()();
  TextColumn get timeOfDisease => text().nullable()();
  TextColumn get illnessStart => text().nullable()();
  TextColumn get illnessCourse => text().nullable()();
  TextColumn get story => text().nullable()(); // Relato Cronológico
  TextColumn get physicalExam => text().nullable()();
  TextColumn get plan => text().nullable()(); // Plan Diagnóstico y Terapéutico
  
  // Vitals (Stored as columns for direct access as per UI requirements)
  TextColumn get bp => text().nullable()(); // Presion Arterial
  TextColumn get hr => text().nullable()(); // Frecuencia Cardiaca
  TextColumn get rr => text().nullable()(); // Frecuencia Respiratoria
  TextColumn get o2Sat => text().nullable()(); // Saturacion O2
  TextColumn get temp => text().nullable()(); // Temperatura
  
  TextColumn get vitalsJson => text().nullable()(); // Keep for backward compat or extra data
  
  // Procedures
  TextColumn get procedures => text().nullable()();
  
  // Bed Management
  IntColumn get bedNumber => integer().nullable()();
  DateTimeColumn get dischargedAt => dateTime().nullable()();
  TextColumn get uciPriority => text().nullable()();

  // Audit
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
}

class Evolutions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get admissionId => integer().references(Admissions, #id)();
  DateTimeColumn get date => dateTime().withDefault(currentDateAndTime)();
  
  // Header Info (Snapshot at time of evolution)
  IntColumn get dayOfStay => integer().nullable()(); // Dia de Estancia
  
  // Vitals (JSON: PA, PAM, FC, FR, T, SatO2, FiO2)
  TextColumn get vitalsJson => text().nullable()();
  
  // Ventilación Mecánica Settings (JSON: Mode, VT, FR, PEEP, FiO2, Trigger, Flow)
  TextColumn get vmSettingsJson => text().nullable()();
  
  // Ventilación Mecánica Mechanics (JSON: Ppeak, Pplateau, Cstat, DrivingPressure)
  TextColumn get vmMechanicsJson => text().nullable()();
  
  // SOAP - Subjetivo
  TextColumn get subjective => text().nullable()();
  
  // SOAP - Objetivo (System by System)
  // neuro, hemo, resp, digest, osteo, renal, infec
  TextColumn get objectiveJson => text().nullable()();
  
  // SOAP - Análisis & Plan
  TextColumn get analysis => text().nullable()();
  TextColumn get plan => text().nullable()();
  TextColumn get proceduresNote => text().nullable()();
  
  TextColumn get diagnosis => text().nullable()();

  // Meta
  TextColumn get authorName => text().nullable()();
  TextColumn get authorRole => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
}

class IndicationSheets extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get admissionId => integer().references(Admissions, #id)();
  TextColumn get payload => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
}

class EpicrisisNotes extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get admissionId => integer().references(Admissions, #id)();
  TextColumn get payload => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
}

class Procedures extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get code => text().nullable()();
  TextColumn get description => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
}

class PerformedProcedures extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get admissionId => integer().references(Admissions, #id)();
  IntColumn get procedureId => integer().references(Procedures, #id)();
  TextColumn get procedureName => text()(); // Snapshot for history
  DateTimeColumn get performedAt => dateTime()();
  TextColumn get assistant => text().nullable()();
  TextColumn get resident => text().nullable()();
  TextColumn get origin => text().nullable()(); // 'ingreso', 'evolucion'
  TextColumn get guardia => text().nullable()(); // Guardia Diurna / Guardia Nocturna
  TextColumn get note => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
}

class ExamTemplates extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get category => text().nullable()();
  TextColumn get description => text().nullable()();
  TextColumn get fieldsJson => text()();
  IntColumn get version => integer().withDefault(const Constant(1))();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
  TextColumn get createdBy => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
}

class ExamResults extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get admissionId => integer().references(Admissions, #id)();
  IntColumn get templateId => integer().references(ExamTemplates, #id)();
  IntColumn get templateVersion => integer().withDefault(const Constant(1))();
  DateTimeColumn get recordedAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get valuesJson => text()();
  TextColumn get note => text().nullable()();
  TextColumn get attachments => text().nullable()();
  TextColumn get recordedBy => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
}

@DriftDatabase(
  tables: [
    Patients,
    Admissions,
    Evolutions,
    IndicationSheets,
    EpicrisisNotes,
    Procedures,
    PerformedProcedures,
    ExamTemplates,
    ExamResults,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 16;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          await m.addColumn(admissions, admissions.bedNumber);
          await m.addColumn(admissions, admissions.dischargedAt);
        }
        if (from < 3) {
           await m.addColumn(admissions, admissions.signsSymptoms);
           await m.addColumn(admissions, admissions.timeOfDisease);
           await m.addColumn(admissions, admissions.illnessStart);
           await m.addColumn(admissions, admissions.illnessCourse);
           await m.addColumn(admissions, admissions.story);
           await m.addColumn(admissions, admissions.physicalExam);
           await m.addColumn(admissions, admissions.vitalsJson);
        }
        if (from < 4) {
           await m.addColumn(admissions, admissions.plan);
           await m.addColumn(admissions, admissions.bp);
           await m.addColumn(admissions, admissions.hr);
           await m.addColumn(admissions, admissions.rr);
           await m.addColumn(admissions, admissions.o2Sat);
           await m.addColumn(admissions, admissions.temp);
        }
        if (from < 5) {
           await m.addColumn(patients, patients.placeOfBirth);
           await m.addColumn(patients, patients.insuranceType);
           await m.addColumn(admissions, admissions.uciPriority);
           await m.addColumn(admissions, admissions.sofaMortality);
           await m.addColumn(admissions, admissions.apacheMortality);
        }
        if (from < 6) {
           await m.createTable(evolutions);
        }
        if (from < 7) {
           await m.addColumn(evolutions, evolutions.diagnosis);
        }
        if (from < 8) {
           await m.createTable(indicationSheets);
        }
        if (from < 9) {
           await m.addColumn(indicationSheets, indicationSheets.isSynced);
        }
        if (from < 10) {
           await m.createTable(epicrisisNotes);
        }
        if (from < 11) {
           await m.createTable(procedures);
           await m.createTable(performedProcedures);
        }
        if (from < 12) {
           await m.addColumn(performedProcedures, performedProcedures.guardia);
        }
        if (from < 13) {
           await m.addColumn(performedProcedures, performedProcedures.note);
        }
        if (from < 14) {
           await m.addColumn(evolutions, evolutions.authorRole);
        }
        if (from < 15) {
           await m.addColumn(evolutions, evolutions.proceduresNote);
        }
        if (from < 16) {
           await m.createTable(examTemplates);
           await m.createTable(examResults);
        }
      },
    );
  }

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'uci_system_db',
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.js'),
      ),
    );
  }

  Future<void> clearAllData() async {
    await transaction(() async {
      await delete(examResults).go();
      await delete(examTemplates).go();
      await delete(performedProcedures).go();
      await delete(procedures).go();
      await delete(epicrisisNotes).go();
      await delete(indicationSheets).go();
      await delete(evolutions).go();
      await delete(admissions).go();
      await delete(patients).go();
    });
  }
}
