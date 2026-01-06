// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $PatientsTable extends Patients with TableInfo<$PatientsTable, Patient> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PatientsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fullNameMeta =
      const VerificationMeta('fullName');
  @override
  late final GeneratedColumn<String> fullName = GeneratedColumn<String>(
      'full_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _ageMeta = const VerificationMeta('age');
  @override
  late final GeneratedColumn<int> age = GeneratedColumn<int>(
      'age', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _sexMeta = const VerificationMeta('sex');
  @override
  late final GeneratedColumn<String> sex = GeneratedColumn<String>(
      'sex', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _diagnosisMeta =
      const VerificationMeta('diagnosis');
  @override
  late final GeneratedColumn<String> diagnosis = GeneratedColumn<String>(
      'diagnosis', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _weightKgMeta =
      const VerificationMeta('weightKg');
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
      'weight_kg', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _heightCmMeta =
      const VerificationMeta('heightCm');
  @override
  late final GeneratedColumn<double> heightCm = GeneratedColumn<double>(
      'height_cm', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _bedNumberMeta =
      const VerificationMeta('bedNumber');
  @override
  late final GeneratedColumn<String> bedNumber = GeneratedColumn<String>(
      'bed_number', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _supportTypeMeta =
      const VerificationMeta('supportType');
  @override
  late final GeneratedColumn<String> supportType = GeneratedColumn<String>(
      'support_type', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        fullName,
        age,
        sex,
        diagnosis,
        weightKg,
        heightCm,
        bedNumber,
        supportType,
        notes,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'patients';
  @override
  VerificationContext validateIntegrity(Insertable<Patient> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('full_name')) {
      context.handle(_fullNameMeta,
          fullName.isAcceptableOrUnknown(data['full_name']!, _fullNameMeta));
    } else if (isInserting) {
      context.missing(_fullNameMeta);
    }
    if (data.containsKey('age')) {
      context.handle(
          _ageMeta, age.isAcceptableOrUnknown(data['age']!, _ageMeta));
    } else if (isInserting) {
      context.missing(_ageMeta);
    }
    if (data.containsKey('sex')) {
      context.handle(
          _sexMeta, sex.isAcceptableOrUnknown(data['sex']!, _sexMeta));
    } else if (isInserting) {
      context.missing(_sexMeta);
    }
    if (data.containsKey('diagnosis')) {
      context.handle(_diagnosisMeta,
          diagnosis.isAcceptableOrUnknown(data['diagnosis']!, _diagnosisMeta));
    } else if (isInserting) {
      context.missing(_diagnosisMeta);
    }
    if (data.containsKey('weight_kg')) {
      context.handle(_weightKgMeta,
          weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta));
    } else if (isInserting) {
      context.missing(_weightKgMeta);
    }
    if (data.containsKey('height_cm')) {
      context.handle(_heightCmMeta,
          heightCm.isAcceptableOrUnknown(data['height_cm']!, _heightCmMeta));
    } else if (isInserting) {
      context.missing(_heightCmMeta);
    }
    if (data.containsKey('bed_number')) {
      context.handle(_bedNumberMeta,
          bedNumber.isAcceptableOrUnknown(data['bed_number']!, _bedNumberMeta));
    }
    if (data.containsKey('support_type')) {
      context.handle(
          _supportTypeMeta,
          supportType.isAcceptableOrUnknown(
              data['support_type']!, _supportTypeMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Patient map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Patient(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      fullName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}full_name'])!,
      age: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}age'])!,
      sex: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sex'])!,
      diagnosis: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}diagnosis'])!,
      weightKg: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}weight_kg'])!,
      heightCm: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}height_cm'])!,
      bedNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bed_number']),
      supportType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}support_type']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $PatientsTable createAlias(String alias) {
    return $PatientsTable(attachedDatabase, alias);
  }
}

class Patient extends DataClass implements Insertable<Patient> {
  final String id;
  final String fullName;
  final int age;
  final String sex;
  final String diagnosis;
  final double weightKg;
  final double heightCm;
  final String? bedNumber;
  final String? supportType;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Patient(
      {required this.id,
      required this.fullName,
      required this.age,
      required this.sex,
      required this.diagnosis,
      required this.weightKg,
      required this.heightCm,
      this.bedNumber,
      this.supportType,
      this.notes,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['full_name'] = Variable<String>(fullName);
    map['age'] = Variable<int>(age);
    map['sex'] = Variable<String>(sex);
    map['diagnosis'] = Variable<String>(diagnosis);
    map['weight_kg'] = Variable<double>(weightKg);
    map['height_cm'] = Variable<double>(heightCm);
    if (!nullToAbsent || bedNumber != null) {
      map['bed_number'] = Variable<String>(bedNumber);
    }
    if (!nullToAbsent || supportType != null) {
      map['support_type'] = Variable<String>(supportType);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PatientsCompanion toCompanion(bool nullToAbsent) {
    return PatientsCompanion(
      id: Value(id),
      fullName: Value(fullName),
      age: Value(age),
      sex: Value(sex),
      diagnosis: Value(diagnosis),
      weightKg: Value(weightKg),
      heightCm: Value(heightCm),
      bedNumber: bedNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(bedNumber),
      supportType: supportType == null && nullToAbsent
          ? const Value.absent()
          : Value(supportType),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Patient.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Patient(
      id: serializer.fromJson<String>(json['id']),
      fullName: serializer.fromJson<String>(json['fullName']),
      age: serializer.fromJson<int>(json['age']),
      sex: serializer.fromJson<String>(json['sex']),
      diagnosis: serializer.fromJson<String>(json['diagnosis']),
      weightKg: serializer.fromJson<double>(json['weightKg']),
      heightCm: serializer.fromJson<double>(json['heightCm']),
      bedNumber: serializer.fromJson<String?>(json['bedNumber']),
      supportType: serializer.fromJson<String?>(json['supportType']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'fullName': serializer.toJson<String>(fullName),
      'age': serializer.toJson<int>(age),
      'sex': serializer.toJson<String>(sex),
      'diagnosis': serializer.toJson<String>(diagnosis),
      'weightKg': serializer.toJson<double>(weightKg),
      'heightCm': serializer.toJson<double>(heightCm),
      'bedNumber': serializer.toJson<String?>(bedNumber),
      'supportType': serializer.toJson<String?>(supportType),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Patient copyWith(
          {String? id,
          String? fullName,
          int? age,
          String? sex,
          String? diagnosis,
          double? weightKg,
          double? heightCm,
          Value<String?> bedNumber = const Value.absent(),
          Value<String?> supportType = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Patient(
        id: id ?? this.id,
        fullName: fullName ?? this.fullName,
        age: age ?? this.age,
        sex: sex ?? this.sex,
        diagnosis: diagnosis ?? this.diagnosis,
        weightKg: weightKg ?? this.weightKg,
        heightCm: heightCm ?? this.heightCm,
        bedNumber: bedNumber.present ? bedNumber.value : this.bedNumber,
        supportType: supportType.present ? supportType.value : this.supportType,
        notes: notes.present ? notes.value : this.notes,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Patient copyWithCompanion(PatientsCompanion data) {
    return Patient(
      id: data.id.present ? data.id.value : this.id,
      fullName: data.fullName.present ? data.fullName.value : this.fullName,
      age: data.age.present ? data.age.value : this.age,
      sex: data.sex.present ? data.sex.value : this.sex,
      diagnosis: data.diagnosis.present ? data.diagnosis.value : this.diagnosis,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      heightCm: data.heightCm.present ? data.heightCm.value : this.heightCm,
      bedNumber: data.bedNumber.present ? data.bedNumber.value : this.bedNumber,
      supportType:
          data.supportType.present ? data.supportType.value : this.supportType,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Patient(')
          ..write('id: $id, ')
          ..write('fullName: $fullName, ')
          ..write('age: $age, ')
          ..write('sex: $sex, ')
          ..write('diagnosis: $diagnosis, ')
          ..write('weightKg: $weightKg, ')
          ..write('heightCm: $heightCm, ')
          ..write('bedNumber: $bedNumber, ')
          ..write('supportType: $supportType, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, fullName, age, sex, diagnosis, weightKg,
      heightCm, bedNumber, supportType, notes, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Patient &&
          other.id == this.id &&
          other.fullName == this.fullName &&
          other.age == this.age &&
          other.sex == this.sex &&
          other.diagnosis == this.diagnosis &&
          other.weightKg == this.weightKg &&
          other.heightCm == this.heightCm &&
          other.bedNumber == this.bedNumber &&
          other.supportType == this.supportType &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PatientsCompanion extends UpdateCompanion<Patient> {
  final Value<String> id;
  final Value<String> fullName;
  final Value<int> age;
  final Value<String> sex;
  final Value<String> diagnosis;
  final Value<double> weightKg;
  final Value<double> heightCm;
  final Value<String?> bedNumber;
  final Value<String?> supportType;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const PatientsCompanion({
    this.id = const Value.absent(),
    this.fullName = const Value.absent(),
    this.age = const Value.absent(),
    this.sex = const Value.absent(),
    this.diagnosis = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.heightCm = const Value.absent(),
    this.bedNumber = const Value.absent(),
    this.supportType = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PatientsCompanion.insert({
    required String id,
    required String fullName,
    required int age,
    required String sex,
    required String diagnosis,
    required double weightKg,
    required double heightCm,
    this.bedNumber = const Value.absent(),
    this.supportType = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        fullName = Value(fullName),
        age = Value(age),
        sex = Value(sex),
        diagnosis = Value(diagnosis),
        weightKg = Value(weightKg),
        heightCm = Value(heightCm);
  static Insertable<Patient> custom({
    Expression<String>? id,
    Expression<String>? fullName,
    Expression<int>? age,
    Expression<String>? sex,
    Expression<String>? diagnosis,
    Expression<double>? weightKg,
    Expression<double>? heightCm,
    Expression<String>? bedNumber,
    Expression<String>? supportType,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fullName != null) 'full_name': fullName,
      if (age != null) 'age': age,
      if (sex != null) 'sex': sex,
      if (diagnosis != null) 'diagnosis': diagnosis,
      if (weightKg != null) 'weight_kg': weightKg,
      if (heightCm != null) 'height_cm': heightCm,
      if (bedNumber != null) 'bed_number': bedNumber,
      if (supportType != null) 'support_type': supportType,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PatientsCompanion copyWith(
      {Value<String>? id,
      Value<String>? fullName,
      Value<int>? age,
      Value<String>? sex,
      Value<String>? diagnosis,
      Value<double>? weightKg,
      Value<double>? heightCm,
      Value<String?>? bedNumber,
      Value<String?>? supportType,
      Value<String?>? notes,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return PatientsCompanion(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      age: age ?? this.age,
      sex: sex ?? this.sex,
      diagnosis: diagnosis ?? this.diagnosis,
      weightKg: weightKg ?? this.weightKg,
      heightCm: heightCm ?? this.heightCm,
      bedNumber: bedNumber ?? this.bedNumber,
      supportType: supportType ?? this.supportType,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (fullName.present) {
      map['full_name'] = Variable<String>(fullName.value);
    }
    if (age.present) {
      map['age'] = Variable<int>(age.value);
    }
    if (sex.present) {
      map['sex'] = Variable<String>(sex.value);
    }
    if (diagnosis.present) {
      map['diagnosis'] = Variable<String>(diagnosis.value);
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    if (heightCm.present) {
      map['height_cm'] = Variable<double>(heightCm.value);
    }
    if (bedNumber.present) {
      map['bed_number'] = Variable<String>(bedNumber.value);
    }
    if (supportType.present) {
      map['support_type'] = Variable<String>(supportType.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PatientsCompanion(')
          ..write('id: $id, ')
          ..write('fullName: $fullName, ')
          ..write('age: $age, ')
          ..write('sex: $sex, ')
          ..write('diagnosis: $diagnosis, ')
          ..write('weightKg: $weightKg, ')
          ..write('heightCm: $heightCm, ')
          ..write('bedNumber: $bedNumber, ')
          ..write('supportType: $supportType, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MonitoringEntriesTable extends MonitoringEntries
    with TableInfo<$MonitoringEntriesTable, MonitoringEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MonitoringEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _patientIdMeta =
      const VerificationMeta('patientId');
  @override
  late final GeneratedColumn<String> patientId = GeneratedColumn<String>(
      'patient_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES patients (id)'));
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _weightKgMeta =
      const VerificationMeta('weightKg');
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
      'weight_kg', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _fluidBalanceMlMeta =
      const VerificationMeta('fluidBalanceMl');
  @override
  late final GeneratedColumn<double> fluidBalanceMl = GeneratedColumn<double>(
      'fluid_balance_ml', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _caloricIntakeKcalMeta =
      const VerificationMeta('caloricIntakeKcal');
  @override
  late final GeneratedColumn<double> caloricIntakeKcal =
      GeneratedColumn<double>('caloric_intake_kcal', aliasedName, true,
          type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _proteinIntakeGramsMeta =
      const VerificationMeta('proteinIntakeGrams');
  @override
  late final GeneratedColumn<double> proteinIntakeGrams =
      GeneratedColumn<double>('protein_intake_grams', aliasedName, true,
          type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _glucoseMinMeta =
      const VerificationMeta('glucoseMin');
  @override
  late final GeneratedColumn<double> glucoseMin = GeneratedColumn<double>(
      'glucose_min', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _glucoseMaxMeta =
      const VerificationMeta('glucoseMax');
  @override
  late final GeneratedColumn<double> glucoseMax = GeneratedColumn<double>(
      'glucose_max', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _triglyceridesMgDlMeta =
      const VerificationMeta('triglyceridesMgDl');
  @override
  late final GeneratedColumn<double> triglyceridesMgDl =
      GeneratedColumn<double>('triglycerides_mg_dl', aliasedName, true,
          type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _creatinineMgDlMeta =
      const VerificationMeta('creatinineMgDl');
  @override
  late final GeneratedColumn<double> creatinineMgDl = GeneratedColumn<double>(
      'creatinine_mg_dl', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _astMeta = const VerificationMeta('ast');
  @override
  late final GeneratedColumn<double> ast = GeneratedColumn<double>(
      'ast', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _altMeta = const VerificationMeta('alt');
  @override
  late final GeneratedColumn<double> alt = GeneratedColumn<double>(
      'alt', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _cReactiveProteinMeta =
      const VerificationMeta('cReactiveProtein');
  @override
  late final GeneratedColumn<double> cReactiveProtein = GeneratedColumn<double>(
      'c_reactive_protein', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _procalcitoninMeta =
      const VerificationMeta('procalcitonin');
  @override
  late final GeneratedColumn<double> procalcitonin = GeneratedColumn<double>(
      'procalcitonin', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        patientId,
        date,
        weightKg,
        fluidBalanceMl,
        caloricIntakeKcal,
        proteinIntakeGrams,
        glucoseMin,
        glucoseMax,
        triglyceridesMgDl,
        creatinineMgDl,
        ast,
        alt,
        cReactiveProtein,
        procalcitonin,
        notes
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'monitoring_entries';
  @override
  VerificationContext validateIntegrity(Insertable<MonitoringEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('patient_id')) {
      context.handle(_patientIdMeta,
          patientId.isAcceptableOrUnknown(data['patient_id']!, _patientIdMeta));
    } else if (isInserting) {
      context.missing(_patientIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('weight_kg')) {
      context.handle(_weightKgMeta,
          weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta));
    }
    if (data.containsKey('fluid_balance_ml')) {
      context.handle(
          _fluidBalanceMlMeta,
          fluidBalanceMl.isAcceptableOrUnknown(
              data['fluid_balance_ml']!, _fluidBalanceMlMeta));
    }
    if (data.containsKey('caloric_intake_kcal')) {
      context.handle(
          _caloricIntakeKcalMeta,
          caloricIntakeKcal.isAcceptableOrUnknown(
              data['caloric_intake_kcal']!, _caloricIntakeKcalMeta));
    }
    if (data.containsKey('protein_intake_grams')) {
      context.handle(
          _proteinIntakeGramsMeta,
          proteinIntakeGrams.isAcceptableOrUnknown(
              data['protein_intake_grams']!, _proteinIntakeGramsMeta));
    }
    if (data.containsKey('glucose_min')) {
      context.handle(
          _glucoseMinMeta,
          glucoseMin.isAcceptableOrUnknown(
              data['glucose_min']!, _glucoseMinMeta));
    }
    if (data.containsKey('glucose_max')) {
      context.handle(
          _glucoseMaxMeta,
          glucoseMax.isAcceptableOrUnknown(
              data['glucose_max']!, _glucoseMaxMeta));
    }
    if (data.containsKey('triglycerides_mg_dl')) {
      context.handle(
          _triglyceridesMgDlMeta,
          triglyceridesMgDl.isAcceptableOrUnknown(
              data['triglycerides_mg_dl']!, _triglyceridesMgDlMeta));
    }
    if (data.containsKey('creatinine_mg_dl')) {
      context.handle(
          _creatinineMgDlMeta,
          creatinineMgDl.isAcceptableOrUnknown(
              data['creatinine_mg_dl']!, _creatinineMgDlMeta));
    }
    if (data.containsKey('ast')) {
      context.handle(
          _astMeta, ast.isAcceptableOrUnknown(data['ast']!, _astMeta));
    }
    if (data.containsKey('alt')) {
      context.handle(
          _altMeta, alt.isAcceptableOrUnknown(data['alt']!, _altMeta));
    }
    if (data.containsKey('c_reactive_protein')) {
      context.handle(
          _cReactiveProteinMeta,
          cReactiveProtein.isAcceptableOrUnknown(
              data['c_reactive_protein']!, _cReactiveProteinMeta));
    }
    if (data.containsKey('procalcitonin')) {
      context.handle(
          _procalcitoninMeta,
          procalcitonin.isAcceptableOrUnknown(
              data['procalcitonin']!, _procalcitoninMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MonitoringEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MonitoringEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      patientId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}patient_id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      weightKg: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}weight_kg']),
      fluidBalanceMl: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}fluid_balance_ml']),
      caloricIntakeKcal: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}caloric_intake_kcal']),
      proteinIntakeGrams: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}protein_intake_grams']),
      glucoseMin: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}glucose_min']),
      glucoseMax: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}glucose_max']),
      triglyceridesMgDl: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}triglycerides_mg_dl']),
      creatinineMgDl: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}creatinine_mg_dl']),
      ast: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}ast']),
      alt: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}alt']),
      cReactiveProtein: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}c_reactive_protein']),
      procalcitonin: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}procalcitonin']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
    );
  }

  @override
  $MonitoringEntriesTable createAlias(String alias) {
    return $MonitoringEntriesTable(attachedDatabase, alias);
  }
}

class MonitoringEntry extends DataClass implements Insertable<MonitoringEntry> {
  final String id;
  final String patientId;
  final DateTime date;
  final double? weightKg;
  final double? fluidBalanceMl;
  final double? caloricIntakeKcal;
  final double? proteinIntakeGrams;
  final double? glucoseMin;
  final double? glucoseMax;
  final double? triglyceridesMgDl;
  final double? creatinineMgDl;
  final double? ast;
  final double? alt;
  final double? cReactiveProtein;
  final double? procalcitonin;
  final String? notes;
  const MonitoringEntry(
      {required this.id,
      required this.patientId,
      required this.date,
      this.weightKg,
      this.fluidBalanceMl,
      this.caloricIntakeKcal,
      this.proteinIntakeGrams,
      this.glucoseMin,
      this.glucoseMax,
      this.triglyceridesMgDl,
      this.creatinineMgDl,
      this.ast,
      this.alt,
      this.cReactiveProtein,
      this.procalcitonin,
      this.notes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['patient_id'] = Variable<String>(patientId);
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || weightKg != null) {
      map['weight_kg'] = Variable<double>(weightKg);
    }
    if (!nullToAbsent || fluidBalanceMl != null) {
      map['fluid_balance_ml'] = Variable<double>(fluidBalanceMl);
    }
    if (!nullToAbsent || caloricIntakeKcal != null) {
      map['caloric_intake_kcal'] = Variable<double>(caloricIntakeKcal);
    }
    if (!nullToAbsent || proteinIntakeGrams != null) {
      map['protein_intake_grams'] = Variable<double>(proteinIntakeGrams);
    }
    if (!nullToAbsent || glucoseMin != null) {
      map['glucose_min'] = Variable<double>(glucoseMin);
    }
    if (!nullToAbsent || glucoseMax != null) {
      map['glucose_max'] = Variable<double>(glucoseMax);
    }
    if (!nullToAbsent || triglyceridesMgDl != null) {
      map['triglycerides_mg_dl'] = Variable<double>(triglyceridesMgDl);
    }
    if (!nullToAbsent || creatinineMgDl != null) {
      map['creatinine_mg_dl'] = Variable<double>(creatinineMgDl);
    }
    if (!nullToAbsent || ast != null) {
      map['ast'] = Variable<double>(ast);
    }
    if (!nullToAbsent || alt != null) {
      map['alt'] = Variable<double>(alt);
    }
    if (!nullToAbsent || cReactiveProtein != null) {
      map['c_reactive_protein'] = Variable<double>(cReactiveProtein);
    }
    if (!nullToAbsent || procalcitonin != null) {
      map['procalcitonin'] = Variable<double>(procalcitonin);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  MonitoringEntriesCompanion toCompanion(bool nullToAbsent) {
    return MonitoringEntriesCompanion(
      id: Value(id),
      patientId: Value(patientId),
      date: Value(date),
      weightKg: weightKg == null && nullToAbsent
          ? const Value.absent()
          : Value(weightKg),
      fluidBalanceMl: fluidBalanceMl == null && nullToAbsent
          ? const Value.absent()
          : Value(fluidBalanceMl),
      caloricIntakeKcal: caloricIntakeKcal == null && nullToAbsent
          ? const Value.absent()
          : Value(caloricIntakeKcal),
      proteinIntakeGrams: proteinIntakeGrams == null && nullToAbsent
          ? const Value.absent()
          : Value(proteinIntakeGrams),
      glucoseMin: glucoseMin == null && nullToAbsent
          ? const Value.absent()
          : Value(glucoseMin),
      glucoseMax: glucoseMax == null && nullToAbsent
          ? const Value.absent()
          : Value(glucoseMax),
      triglyceridesMgDl: triglyceridesMgDl == null && nullToAbsent
          ? const Value.absent()
          : Value(triglyceridesMgDl),
      creatinineMgDl: creatinineMgDl == null && nullToAbsent
          ? const Value.absent()
          : Value(creatinineMgDl),
      ast: ast == null && nullToAbsent ? const Value.absent() : Value(ast),
      alt: alt == null && nullToAbsent ? const Value.absent() : Value(alt),
      cReactiveProtein: cReactiveProtein == null && nullToAbsent
          ? const Value.absent()
          : Value(cReactiveProtein),
      procalcitonin: procalcitonin == null && nullToAbsent
          ? const Value.absent()
          : Value(procalcitonin),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
    );
  }

  factory MonitoringEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MonitoringEntry(
      id: serializer.fromJson<String>(json['id']),
      patientId: serializer.fromJson<String>(json['patientId']),
      date: serializer.fromJson<DateTime>(json['date']),
      weightKg: serializer.fromJson<double?>(json['weightKg']),
      fluidBalanceMl: serializer.fromJson<double?>(json['fluidBalanceMl']),
      caloricIntakeKcal:
          serializer.fromJson<double?>(json['caloricIntakeKcal']),
      proteinIntakeGrams:
          serializer.fromJson<double?>(json['proteinIntakeGrams']),
      glucoseMin: serializer.fromJson<double?>(json['glucoseMin']),
      glucoseMax: serializer.fromJson<double?>(json['glucoseMax']),
      triglyceridesMgDl:
          serializer.fromJson<double?>(json['triglyceridesMgDl']),
      creatinineMgDl: serializer.fromJson<double?>(json['creatinineMgDl']),
      ast: serializer.fromJson<double?>(json['ast']),
      alt: serializer.fromJson<double?>(json['alt']),
      cReactiveProtein: serializer.fromJson<double?>(json['cReactiveProtein']),
      procalcitonin: serializer.fromJson<double?>(json['procalcitonin']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'patientId': serializer.toJson<String>(patientId),
      'date': serializer.toJson<DateTime>(date),
      'weightKg': serializer.toJson<double?>(weightKg),
      'fluidBalanceMl': serializer.toJson<double?>(fluidBalanceMl),
      'caloricIntakeKcal': serializer.toJson<double?>(caloricIntakeKcal),
      'proteinIntakeGrams': serializer.toJson<double?>(proteinIntakeGrams),
      'glucoseMin': serializer.toJson<double?>(glucoseMin),
      'glucoseMax': serializer.toJson<double?>(glucoseMax),
      'triglyceridesMgDl': serializer.toJson<double?>(triglyceridesMgDl),
      'creatinineMgDl': serializer.toJson<double?>(creatinineMgDl),
      'ast': serializer.toJson<double?>(ast),
      'alt': serializer.toJson<double?>(alt),
      'cReactiveProtein': serializer.toJson<double?>(cReactiveProtein),
      'procalcitonin': serializer.toJson<double?>(procalcitonin),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  MonitoringEntry copyWith(
          {String? id,
          String? patientId,
          DateTime? date,
          Value<double?> weightKg = const Value.absent(),
          Value<double?> fluidBalanceMl = const Value.absent(),
          Value<double?> caloricIntakeKcal = const Value.absent(),
          Value<double?> proteinIntakeGrams = const Value.absent(),
          Value<double?> glucoseMin = const Value.absent(),
          Value<double?> glucoseMax = const Value.absent(),
          Value<double?> triglyceridesMgDl = const Value.absent(),
          Value<double?> creatinineMgDl = const Value.absent(),
          Value<double?> ast = const Value.absent(),
          Value<double?> alt = const Value.absent(),
          Value<double?> cReactiveProtein = const Value.absent(),
          Value<double?> procalcitonin = const Value.absent(),
          Value<String?> notes = const Value.absent()}) =>
      MonitoringEntry(
        id: id ?? this.id,
        patientId: patientId ?? this.patientId,
        date: date ?? this.date,
        weightKg: weightKg.present ? weightKg.value : this.weightKg,
        fluidBalanceMl:
            fluidBalanceMl.present ? fluidBalanceMl.value : this.fluidBalanceMl,
        caloricIntakeKcal: caloricIntakeKcal.present
            ? caloricIntakeKcal.value
            : this.caloricIntakeKcal,
        proteinIntakeGrams: proteinIntakeGrams.present
            ? proteinIntakeGrams.value
            : this.proteinIntakeGrams,
        glucoseMin: glucoseMin.present ? glucoseMin.value : this.glucoseMin,
        glucoseMax: glucoseMax.present ? glucoseMax.value : this.glucoseMax,
        triglyceridesMgDl: triglyceridesMgDl.present
            ? triglyceridesMgDl.value
            : this.triglyceridesMgDl,
        creatinineMgDl:
            creatinineMgDl.present ? creatinineMgDl.value : this.creatinineMgDl,
        ast: ast.present ? ast.value : this.ast,
        alt: alt.present ? alt.value : this.alt,
        cReactiveProtein: cReactiveProtein.present
            ? cReactiveProtein.value
            : this.cReactiveProtein,
        procalcitonin:
            procalcitonin.present ? procalcitonin.value : this.procalcitonin,
        notes: notes.present ? notes.value : this.notes,
      );
  MonitoringEntry copyWithCompanion(MonitoringEntriesCompanion data) {
    return MonitoringEntry(
      id: data.id.present ? data.id.value : this.id,
      patientId: data.patientId.present ? data.patientId.value : this.patientId,
      date: data.date.present ? data.date.value : this.date,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      fluidBalanceMl: data.fluidBalanceMl.present
          ? data.fluidBalanceMl.value
          : this.fluidBalanceMl,
      caloricIntakeKcal: data.caloricIntakeKcal.present
          ? data.caloricIntakeKcal.value
          : this.caloricIntakeKcal,
      proteinIntakeGrams: data.proteinIntakeGrams.present
          ? data.proteinIntakeGrams.value
          : this.proteinIntakeGrams,
      glucoseMin:
          data.glucoseMin.present ? data.glucoseMin.value : this.glucoseMin,
      glucoseMax:
          data.glucoseMax.present ? data.glucoseMax.value : this.glucoseMax,
      triglyceridesMgDl: data.triglyceridesMgDl.present
          ? data.triglyceridesMgDl.value
          : this.triglyceridesMgDl,
      creatinineMgDl: data.creatinineMgDl.present
          ? data.creatinineMgDl.value
          : this.creatinineMgDl,
      ast: data.ast.present ? data.ast.value : this.ast,
      alt: data.alt.present ? data.alt.value : this.alt,
      cReactiveProtein: data.cReactiveProtein.present
          ? data.cReactiveProtein.value
          : this.cReactiveProtein,
      procalcitonin: data.procalcitonin.present
          ? data.procalcitonin.value
          : this.procalcitonin,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MonitoringEntry(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('date: $date, ')
          ..write('weightKg: $weightKg, ')
          ..write('fluidBalanceMl: $fluidBalanceMl, ')
          ..write('caloricIntakeKcal: $caloricIntakeKcal, ')
          ..write('proteinIntakeGrams: $proteinIntakeGrams, ')
          ..write('glucoseMin: $glucoseMin, ')
          ..write('glucoseMax: $glucoseMax, ')
          ..write('triglyceridesMgDl: $triglyceridesMgDl, ')
          ..write('creatinineMgDl: $creatinineMgDl, ')
          ..write('ast: $ast, ')
          ..write('alt: $alt, ')
          ..write('cReactiveProtein: $cReactiveProtein, ')
          ..write('procalcitonin: $procalcitonin, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      patientId,
      date,
      weightKg,
      fluidBalanceMl,
      caloricIntakeKcal,
      proteinIntakeGrams,
      glucoseMin,
      glucoseMax,
      triglyceridesMgDl,
      creatinineMgDl,
      ast,
      alt,
      cReactiveProtein,
      procalcitonin,
      notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MonitoringEntry &&
          other.id == this.id &&
          other.patientId == this.patientId &&
          other.date == this.date &&
          other.weightKg == this.weightKg &&
          other.fluidBalanceMl == this.fluidBalanceMl &&
          other.caloricIntakeKcal == this.caloricIntakeKcal &&
          other.proteinIntakeGrams == this.proteinIntakeGrams &&
          other.glucoseMin == this.glucoseMin &&
          other.glucoseMax == this.glucoseMax &&
          other.triglyceridesMgDl == this.triglyceridesMgDl &&
          other.creatinineMgDl == this.creatinineMgDl &&
          other.ast == this.ast &&
          other.alt == this.alt &&
          other.cReactiveProtein == this.cReactiveProtein &&
          other.procalcitonin == this.procalcitonin &&
          other.notes == this.notes);
}

class MonitoringEntriesCompanion extends UpdateCompanion<MonitoringEntry> {
  final Value<String> id;
  final Value<String> patientId;
  final Value<DateTime> date;
  final Value<double?> weightKg;
  final Value<double?> fluidBalanceMl;
  final Value<double?> caloricIntakeKcal;
  final Value<double?> proteinIntakeGrams;
  final Value<double?> glucoseMin;
  final Value<double?> glucoseMax;
  final Value<double?> triglyceridesMgDl;
  final Value<double?> creatinineMgDl;
  final Value<double?> ast;
  final Value<double?> alt;
  final Value<double?> cReactiveProtein;
  final Value<double?> procalcitonin;
  final Value<String?> notes;
  final Value<int> rowid;
  const MonitoringEntriesCompanion({
    this.id = const Value.absent(),
    this.patientId = const Value.absent(),
    this.date = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.fluidBalanceMl = const Value.absent(),
    this.caloricIntakeKcal = const Value.absent(),
    this.proteinIntakeGrams = const Value.absent(),
    this.glucoseMin = const Value.absent(),
    this.glucoseMax = const Value.absent(),
    this.triglyceridesMgDl = const Value.absent(),
    this.creatinineMgDl = const Value.absent(),
    this.ast = const Value.absent(),
    this.alt = const Value.absent(),
    this.cReactiveProtein = const Value.absent(),
    this.procalcitonin = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MonitoringEntriesCompanion.insert({
    required String id,
    required String patientId,
    required DateTime date,
    this.weightKg = const Value.absent(),
    this.fluidBalanceMl = const Value.absent(),
    this.caloricIntakeKcal = const Value.absent(),
    this.proteinIntakeGrams = const Value.absent(),
    this.glucoseMin = const Value.absent(),
    this.glucoseMax = const Value.absent(),
    this.triglyceridesMgDl = const Value.absent(),
    this.creatinineMgDl = const Value.absent(),
    this.ast = const Value.absent(),
    this.alt = const Value.absent(),
    this.cReactiveProtein = const Value.absent(),
    this.procalcitonin = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        patientId = Value(patientId),
        date = Value(date);
  static Insertable<MonitoringEntry> custom({
    Expression<String>? id,
    Expression<String>? patientId,
    Expression<DateTime>? date,
    Expression<double>? weightKg,
    Expression<double>? fluidBalanceMl,
    Expression<double>? caloricIntakeKcal,
    Expression<double>? proteinIntakeGrams,
    Expression<double>? glucoseMin,
    Expression<double>? glucoseMax,
    Expression<double>? triglyceridesMgDl,
    Expression<double>? creatinineMgDl,
    Expression<double>? ast,
    Expression<double>? alt,
    Expression<double>? cReactiveProtein,
    Expression<double>? procalcitonin,
    Expression<String>? notes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (patientId != null) 'patient_id': patientId,
      if (date != null) 'date': date,
      if (weightKg != null) 'weight_kg': weightKg,
      if (fluidBalanceMl != null) 'fluid_balance_ml': fluidBalanceMl,
      if (caloricIntakeKcal != null) 'caloric_intake_kcal': caloricIntakeKcal,
      if (proteinIntakeGrams != null)
        'protein_intake_grams': proteinIntakeGrams,
      if (glucoseMin != null) 'glucose_min': glucoseMin,
      if (glucoseMax != null) 'glucose_max': glucoseMax,
      if (triglyceridesMgDl != null) 'triglycerides_mg_dl': triglyceridesMgDl,
      if (creatinineMgDl != null) 'creatinine_mg_dl': creatinineMgDl,
      if (ast != null) 'ast': ast,
      if (alt != null) 'alt': alt,
      if (cReactiveProtein != null) 'c_reactive_protein': cReactiveProtein,
      if (procalcitonin != null) 'procalcitonin': procalcitonin,
      if (notes != null) 'notes': notes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MonitoringEntriesCompanion copyWith(
      {Value<String>? id,
      Value<String>? patientId,
      Value<DateTime>? date,
      Value<double?>? weightKg,
      Value<double?>? fluidBalanceMl,
      Value<double?>? caloricIntakeKcal,
      Value<double?>? proteinIntakeGrams,
      Value<double?>? glucoseMin,
      Value<double?>? glucoseMax,
      Value<double?>? triglyceridesMgDl,
      Value<double?>? creatinineMgDl,
      Value<double?>? ast,
      Value<double?>? alt,
      Value<double?>? cReactiveProtein,
      Value<double?>? procalcitonin,
      Value<String?>? notes,
      Value<int>? rowid}) {
    return MonitoringEntriesCompanion(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      date: date ?? this.date,
      weightKg: weightKg ?? this.weightKg,
      fluidBalanceMl: fluidBalanceMl ?? this.fluidBalanceMl,
      caloricIntakeKcal: caloricIntakeKcal ?? this.caloricIntakeKcal,
      proteinIntakeGrams: proteinIntakeGrams ?? this.proteinIntakeGrams,
      glucoseMin: glucoseMin ?? this.glucoseMin,
      glucoseMax: glucoseMax ?? this.glucoseMax,
      triglyceridesMgDl: triglyceridesMgDl ?? this.triglyceridesMgDl,
      creatinineMgDl: creatinineMgDl ?? this.creatinineMgDl,
      ast: ast ?? this.ast,
      alt: alt ?? this.alt,
      cReactiveProtein: cReactiveProtein ?? this.cReactiveProtein,
      procalcitonin: procalcitonin ?? this.procalcitonin,
      notes: notes ?? this.notes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (patientId.present) {
      map['patient_id'] = Variable<String>(patientId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    if (fluidBalanceMl.present) {
      map['fluid_balance_ml'] = Variable<double>(fluidBalanceMl.value);
    }
    if (caloricIntakeKcal.present) {
      map['caloric_intake_kcal'] = Variable<double>(caloricIntakeKcal.value);
    }
    if (proteinIntakeGrams.present) {
      map['protein_intake_grams'] = Variable<double>(proteinIntakeGrams.value);
    }
    if (glucoseMin.present) {
      map['glucose_min'] = Variable<double>(glucoseMin.value);
    }
    if (glucoseMax.present) {
      map['glucose_max'] = Variable<double>(glucoseMax.value);
    }
    if (triglyceridesMgDl.present) {
      map['triglycerides_mg_dl'] = Variable<double>(triglyceridesMgDl.value);
    }
    if (creatinineMgDl.present) {
      map['creatinine_mg_dl'] = Variable<double>(creatinineMgDl.value);
    }
    if (ast.present) {
      map['ast'] = Variable<double>(ast.value);
    }
    if (alt.present) {
      map['alt'] = Variable<double>(alt.value);
    }
    if (cReactiveProtein.present) {
      map['c_reactive_protein'] = Variable<double>(cReactiveProtein.value);
    }
    if (procalcitonin.present) {
      map['procalcitonin'] = Variable<double>(procalcitonin.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MonitoringEntriesCompanion(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('date: $date, ')
          ..write('weightKg: $weightKg, ')
          ..write('fluidBalanceMl: $fluidBalanceMl, ')
          ..write('caloricIntakeKcal: $caloricIntakeKcal, ')
          ..write('proteinIntakeGrams: $proteinIntakeGrams, ')
          ..write('glucoseMin: $glucoseMin, ')
          ..write('glucoseMax: $glucoseMax, ')
          ..write('triglyceridesMgDl: $triglyceridesMgDl, ')
          ..write('creatinineMgDl: $creatinineMgDl, ')
          ..write('ast: $ast, ')
          ..write('alt: $alt, ')
          ..write('cReactiveProtein: $cReactiveProtein, ')
          ..write('procalcitonin: $procalcitonin, ')
          ..write('notes: $notes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NutritionTargetsTable extends NutritionTargets
    with TableInfo<$NutritionTargetsTable, NutritionTarget> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NutritionTargetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _patientIdMeta =
      const VerificationMeta('patientId');
  @override
  late final GeneratedColumn<String> patientId = GeneratedColumn<String>(
      'patient_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES patients (id)'));
  static const VerificationMeta _methodMeta = const VerificationMeta('method');
  @override
  late final GeneratedColumn<String> method = GeneratedColumn<String>(
      'method', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _caloriesPerDayMeta =
      const VerificationMeta('caloriesPerDay');
  @override
  late final GeneratedColumn<double> caloriesPerDay = GeneratedColumn<double>(
      'calories_per_day', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _proteinGramsMeta =
      const VerificationMeta('proteinGrams');
  @override
  late final GeneratedColumn<double> proteinGrams = GeneratedColumn<double>(
      'protein_grams', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, patientId, method, caloriesPerDay, proteinGrams, notes, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'nutrition_targets';
  @override
  VerificationContext validateIntegrity(Insertable<NutritionTarget> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('patient_id')) {
      context.handle(_patientIdMeta,
          patientId.isAcceptableOrUnknown(data['patient_id']!, _patientIdMeta));
    } else if (isInserting) {
      context.missing(_patientIdMeta);
    }
    if (data.containsKey('method')) {
      context.handle(_methodMeta,
          method.isAcceptableOrUnknown(data['method']!, _methodMeta));
    } else if (isInserting) {
      context.missing(_methodMeta);
    }
    if (data.containsKey('calories_per_day')) {
      context.handle(
          _caloriesPerDayMeta,
          caloriesPerDay.isAcceptableOrUnknown(
              data['calories_per_day']!, _caloriesPerDayMeta));
    } else if (isInserting) {
      context.missing(_caloriesPerDayMeta);
    }
    if (data.containsKey('protein_grams')) {
      context.handle(
          _proteinGramsMeta,
          proteinGrams.isAcceptableOrUnknown(
              data['protein_grams']!, _proteinGramsMeta));
    } else if (isInserting) {
      context.missing(_proteinGramsMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NutritionTarget map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NutritionTarget(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      patientId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}patient_id'])!,
      method: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}method'])!,
      caloriesPerDay: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}calories_per_day'])!,
      proteinGrams: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}protein_grams'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $NutritionTargetsTable createAlias(String alias) {
    return $NutritionTargetsTable(attachedDatabase, alias);
  }
}

class NutritionTarget extends DataClass implements Insertable<NutritionTarget> {
  final String id;
  final String patientId;
  final String method;
  final double caloriesPerDay;
  final double proteinGrams;
  final String? notes;
  final DateTime createdAt;
  const NutritionTarget(
      {required this.id,
      required this.patientId,
      required this.method,
      required this.caloriesPerDay,
      required this.proteinGrams,
      this.notes,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['patient_id'] = Variable<String>(patientId);
    map['method'] = Variable<String>(method);
    map['calories_per_day'] = Variable<double>(caloriesPerDay);
    map['protein_grams'] = Variable<double>(proteinGrams);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  NutritionTargetsCompanion toCompanion(bool nullToAbsent) {
    return NutritionTargetsCompanion(
      id: Value(id),
      patientId: Value(patientId),
      method: Value(method),
      caloriesPerDay: Value(caloriesPerDay),
      proteinGrams: Value(proteinGrams),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      createdAt: Value(createdAt),
    );
  }

  factory NutritionTarget.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NutritionTarget(
      id: serializer.fromJson<String>(json['id']),
      patientId: serializer.fromJson<String>(json['patientId']),
      method: serializer.fromJson<String>(json['method']),
      caloriesPerDay: serializer.fromJson<double>(json['caloriesPerDay']),
      proteinGrams: serializer.fromJson<double>(json['proteinGrams']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'patientId': serializer.toJson<String>(patientId),
      'method': serializer.toJson<String>(method),
      'caloriesPerDay': serializer.toJson<double>(caloriesPerDay),
      'proteinGrams': serializer.toJson<double>(proteinGrams),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  NutritionTarget copyWith(
          {String? id,
          String? patientId,
          String? method,
          double? caloriesPerDay,
          double? proteinGrams,
          Value<String?> notes = const Value.absent(),
          DateTime? createdAt}) =>
      NutritionTarget(
        id: id ?? this.id,
        patientId: patientId ?? this.patientId,
        method: method ?? this.method,
        caloriesPerDay: caloriesPerDay ?? this.caloriesPerDay,
        proteinGrams: proteinGrams ?? this.proteinGrams,
        notes: notes.present ? notes.value : this.notes,
        createdAt: createdAt ?? this.createdAt,
      );
  NutritionTarget copyWithCompanion(NutritionTargetsCompanion data) {
    return NutritionTarget(
      id: data.id.present ? data.id.value : this.id,
      patientId: data.patientId.present ? data.patientId.value : this.patientId,
      method: data.method.present ? data.method.value : this.method,
      caloriesPerDay: data.caloriesPerDay.present
          ? data.caloriesPerDay.value
          : this.caloriesPerDay,
      proteinGrams: data.proteinGrams.present
          ? data.proteinGrams.value
          : this.proteinGrams,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NutritionTarget(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('method: $method, ')
          ..write('caloriesPerDay: $caloriesPerDay, ')
          ..write('proteinGrams: $proteinGrams, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, patientId, method, caloriesPerDay, proteinGrams, notes, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NutritionTarget &&
          other.id == this.id &&
          other.patientId == this.patientId &&
          other.method == this.method &&
          other.caloriesPerDay == this.caloriesPerDay &&
          other.proteinGrams == this.proteinGrams &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt);
}

class NutritionTargetsCompanion extends UpdateCompanion<NutritionTarget> {
  final Value<String> id;
  final Value<String> patientId;
  final Value<String> method;
  final Value<double> caloriesPerDay;
  final Value<double> proteinGrams;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const NutritionTargetsCompanion({
    this.id = const Value.absent(),
    this.patientId = const Value.absent(),
    this.method = const Value.absent(),
    this.caloriesPerDay = const Value.absent(),
    this.proteinGrams = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NutritionTargetsCompanion.insert({
    required String id,
    required String patientId,
    required String method,
    required double caloriesPerDay,
    required double proteinGrams,
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        patientId = Value(patientId),
        method = Value(method),
        caloriesPerDay = Value(caloriesPerDay),
        proteinGrams = Value(proteinGrams);
  static Insertable<NutritionTarget> custom({
    Expression<String>? id,
    Expression<String>? patientId,
    Expression<String>? method,
    Expression<double>? caloriesPerDay,
    Expression<double>? proteinGrams,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (patientId != null) 'patient_id': patientId,
      if (method != null) 'method': method,
      if (caloriesPerDay != null) 'calories_per_day': caloriesPerDay,
      if (proteinGrams != null) 'protein_grams': proteinGrams,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NutritionTargetsCompanion copyWith(
      {Value<String>? id,
      Value<String>? patientId,
      Value<String>? method,
      Value<double>? caloriesPerDay,
      Value<double>? proteinGrams,
      Value<String?>? notes,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return NutritionTargetsCompanion(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      method: method ?? this.method,
      caloriesPerDay: caloriesPerDay ?? this.caloriesPerDay,
      proteinGrams: proteinGrams ?? this.proteinGrams,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (patientId.present) {
      map['patient_id'] = Variable<String>(patientId.value);
    }
    if (method.present) {
      map['method'] = Variable<String>(method.value);
    }
    if (caloriesPerDay.present) {
      map['calories_per_day'] = Variable<double>(caloriesPerDay.value);
    }
    if (proteinGrams.present) {
      map['protein_grams'] = Variable<double>(proteinGrams.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NutritionTargetsCompanion(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('method: $method, ')
          ..write('caloriesPerDay: $caloriesPerDay, ')
          ..write('proteinGrams: $proteinGrams, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AlertsTable extends Alerts with TableInfo<$AlertsTable, Alert> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AlertsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _patientIdMeta =
      const VerificationMeta('patientId');
  @override
  late final GeneratedColumn<String> patientId = GeneratedColumn<String>(
      'patient_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES patients (id)'));
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _messageMeta =
      const VerificationMeta('message');
  @override
  late final GeneratedColumn<String> message = GeneratedColumn<String>(
      'message', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _resolvedMeta =
      const VerificationMeta('resolved');
  @override
  late final GeneratedColumn<bool> resolved = GeneratedColumn<bool>(
      'resolved', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("resolved" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _dueDateMeta =
      const VerificationMeta('dueDate');
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
      'due_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, patientId, type, message, resolved, createdAt, dueDate];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'alerts';
  @override
  VerificationContext validateIntegrity(Insertable<Alert> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('patient_id')) {
      context.handle(_patientIdMeta,
          patientId.isAcceptableOrUnknown(data['patient_id']!, _patientIdMeta));
    } else if (isInserting) {
      context.missing(_patientIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('message')) {
      context.handle(_messageMeta,
          message.isAcceptableOrUnknown(data['message']!, _messageMeta));
    } else if (isInserting) {
      context.missing(_messageMeta);
    }
    if (data.containsKey('resolved')) {
      context.handle(_resolvedMeta,
          resolved.isAcceptableOrUnknown(data['resolved']!, _resolvedMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('due_date')) {
      context.handle(_dueDateMeta,
          dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Alert map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Alert(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      patientId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}patient_id'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      message: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}message'])!,
      resolved: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}resolved'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      dueDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}due_date']),
    );
  }

  @override
  $AlertsTable createAlias(String alias) {
    return $AlertsTable(attachedDatabase, alias);
  }
}

class Alert extends DataClass implements Insertable<Alert> {
  final String id;
  final String patientId;
  final String type;
  final String message;
  final bool resolved;
  final DateTime createdAt;
  final DateTime? dueDate;
  const Alert(
      {required this.id,
      required this.patientId,
      required this.type,
      required this.message,
      required this.resolved,
      required this.createdAt,
      this.dueDate});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['patient_id'] = Variable<String>(patientId);
    map['type'] = Variable<String>(type);
    map['message'] = Variable<String>(message);
    map['resolved'] = Variable<bool>(resolved);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || dueDate != null) {
      map['due_date'] = Variable<DateTime>(dueDate);
    }
    return map;
  }

  AlertsCompanion toCompanion(bool nullToAbsent) {
    return AlertsCompanion(
      id: Value(id),
      patientId: Value(patientId),
      type: Value(type),
      message: Value(message),
      resolved: Value(resolved),
      createdAt: Value(createdAt),
      dueDate: dueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDate),
    );
  }

  factory Alert.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Alert(
      id: serializer.fromJson<String>(json['id']),
      patientId: serializer.fromJson<String>(json['patientId']),
      type: serializer.fromJson<String>(json['type']),
      message: serializer.fromJson<String>(json['message']),
      resolved: serializer.fromJson<bool>(json['resolved']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      dueDate: serializer.fromJson<DateTime?>(json['dueDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'patientId': serializer.toJson<String>(patientId),
      'type': serializer.toJson<String>(type),
      'message': serializer.toJson<String>(message),
      'resolved': serializer.toJson<bool>(resolved),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'dueDate': serializer.toJson<DateTime?>(dueDate),
    };
  }

  Alert copyWith(
          {String? id,
          String? patientId,
          String? type,
          String? message,
          bool? resolved,
          DateTime? createdAt,
          Value<DateTime?> dueDate = const Value.absent()}) =>
      Alert(
        id: id ?? this.id,
        patientId: patientId ?? this.patientId,
        type: type ?? this.type,
        message: message ?? this.message,
        resolved: resolved ?? this.resolved,
        createdAt: createdAt ?? this.createdAt,
        dueDate: dueDate.present ? dueDate.value : this.dueDate,
      );
  Alert copyWithCompanion(AlertsCompanion data) {
    return Alert(
      id: data.id.present ? data.id.value : this.id,
      patientId: data.patientId.present ? data.patientId.value : this.patientId,
      type: data.type.present ? data.type.value : this.type,
      message: data.message.present ? data.message.value : this.message,
      resolved: data.resolved.present ? data.resolved.value : this.resolved,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Alert(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('type: $type, ')
          ..write('message: $message, ')
          ..write('resolved: $resolved, ')
          ..write('createdAt: $createdAt, ')
          ..write('dueDate: $dueDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, patientId, type, message, resolved, createdAt, dueDate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Alert &&
          other.id == this.id &&
          other.patientId == this.patientId &&
          other.type == this.type &&
          other.message == this.message &&
          other.resolved == this.resolved &&
          other.createdAt == this.createdAt &&
          other.dueDate == this.dueDate);
}

class AlertsCompanion extends UpdateCompanion<Alert> {
  final Value<String> id;
  final Value<String> patientId;
  final Value<String> type;
  final Value<String> message;
  final Value<bool> resolved;
  final Value<DateTime> createdAt;
  final Value<DateTime?> dueDate;
  final Value<int> rowid;
  const AlertsCompanion({
    this.id = const Value.absent(),
    this.patientId = const Value.absent(),
    this.type = const Value.absent(),
    this.message = const Value.absent(),
    this.resolved = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AlertsCompanion.insert({
    required String id,
    required String patientId,
    required String type,
    required String message,
    this.resolved = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        patientId = Value(patientId),
        type = Value(type),
        message = Value(message);
  static Insertable<Alert> custom({
    Expression<String>? id,
    Expression<String>? patientId,
    Expression<String>? type,
    Expression<String>? message,
    Expression<bool>? resolved,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? dueDate,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (patientId != null) 'patient_id': patientId,
      if (type != null) 'type': type,
      if (message != null) 'message': message,
      if (resolved != null) 'resolved': resolved,
      if (createdAt != null) 'created_at': createdAt,
      if (dueDate != null) 'due_date': dueDate,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AlertsCompanion copyWith(
      {Value<String>? id,
      Value<String>? patientId,
      Value<String>? type,
      Value<String>? message,
      Value<bool>? resolved,
      Value<DateTime>? createdAt,
      Value<DateTime?>? dueDate,
      Value<int>? rowid}) {
    return AlertsCompanion(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      type: type ?? this.type,
      message: message ?? this.message,
      resolved: resolved ?? this.resolved,
      createdAt: createdAt ?? this.createdAt,
      dueDate: dueDate ?? this.dueDate,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (patientId.present) {
      map['patient_id'] = Variable<String>(patientId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (message.present) {
      map['message'] = Variable<String>(message.value);
    }
    if (resolved.present) {
      map['resolved'] = Variable<bool>(resolved.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AlertsCompanion(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('type: $type, ')
          ..write('message: $message, ')
          ..write('resolved: $resolved, ')
          ..write('createdAt: $createdAt, ')
          ..write('dueDate: $dueDate, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WeightAssessmentsTable extends WeightAssessments
    with TableInfo<$WeightAssessmentsTable, WeightAssessment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WeightAssessmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _patientIdMeta =
      const VerificationMeta('patientId');
  @override
  late final GeneratedColumn<String> patientId = GeneratedColumn<String>(
      'patient_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES patients (id)'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _weightRealKgMeta =
      const VerificationMeta('weightRealKg');
  @override
  late final GeneratedColumn<double> weightRealKg = GeneratedColumn<double>(
      'weight_real_kg', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _heightCmMeta =
      const VerificationMeta('heightCm');
  @override
  late final GeneratedColumn<double> heightCm = GeneratedColumn<double>(
      'height_cm', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _heightMethodMeta =
      const VerificationMeta('heightMethod');
  @override
  late final GeneratedColumn<String> heightMethod = GeneratedColumn<String>(
      'height_method', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _weightSourceMeta =
      const VerificationMeta('weightSource');
  @override
  late final GeneratedColumn<String> weightSource = GeneratedColumn<String>(
      'weight_source', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _confidenceMeta =
      const VerificationMeta('confidence');
  @override
  late final GeneratedColumn<String> confidence = GeneratedColumn<String>(
      'confidence', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _bmiMeta = const VerificationMeta('bmi');
  @override
  late final GeneratedColumn<double> bmi = GeneratedColumn<double>(
      'bmi', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _idealWeightKgMeta =
      const VerificationMeta('idealWeightKg');
  @override
  late final GeneratedColumn<double> idealWeightKg = GeneratedColumn<double>(
      'ideal_weight_kg', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _adjustedWeightKgMeta =
      const VerificationMeta('adjustedWeightKg');
  @override
  late final GeneratedColumn<double> adjustedWeightKg = GeneratedColumn<double>(
      'adjusted_weight_kg', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _workWeightKgMeta =
      const VerificationMeta('workWeightKg');
  @override
  late final GeneratedColumn<double> workWeightKg = GeneratedColumn<double>(
      'work_weight_kg', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _workWeightLabelMeta =
      const VerificationMeta('workWeightLabel');
  @override
  late final GeneratedColumn<String> workWeightLabel = GeneratedColumn<String>(
      'work_weight_label', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _proteinBaseKgMeta =
      const VerificationMeta('proteinBaseKg');
  @override
  late final GeneratedColumn<double> proteinBaseKg = GeneratedColumn<double>(
      'protein_base_kg', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _kcalBaseKgMeta =
      const VerificationMeta('kcalBaseKg');
  @override
  late final GeneratedColumn<double> kcalBaseKg = GeneratedColumn<double>(
      'kcal_base_kg', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _overrideJustificationMeta =
      const VerificationMeta('overrideJustification');
  @override
  late final GeneratedColumn<String> overrideJustification =
      GeneratedColumn<String>('override_justification', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _kneeHeightCmMeta =
      const VerificationMeta('kneeHeightCm');
  @override
  late final GeneratedColumn<double> kneeHeightCm = GeneratedColumn<double>(
      'knee_height_cm', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _ulnaLengthCmMeta =
      const VerificationMeta('ulnaLengthCm');
  @override
  late final GeneratedColumn<double> ulnaLengthCm = GeneratedColumn<double>(
      'ulna_length_cm', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _estimatedHeightCmMeta =
      const VerificationMeta('estimatedHeightCm');
  @override
  late final GeneratedColumn<double> estimatedHeightCm =
      GeneratedColumn<double>('estimated_height_cm', aliasedName, true,
          type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _obesitySuspectedMeta =
      const VerificationMeta('obesitySuspected');
  @override
  late final GeneratedColumn<bool> obesitySuspected = GeneratedColumn<bool>(
      'obesity_suspected', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("obesity_suspected" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _edemaPresentMeta =
      const VerificationMeta('edemaPresent');
  @override
  late final GeneratedColumn<bool> edemaPresent = GeneratedColumn<bool>(
      'edema_present', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("edema_present" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _ascitesPresentMeta =
      const VerificationMeta('ascitesPresent');
  @override
  late final GeneratedColumn<bool> ascitesPresent = GeneratedColumn<bool>(
      'ascites_present', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("ascites_present" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _dryWeightConfirmedMeta =
      const VerificationMeta('dryWeightConfirmed');
  @override
  late final GeneratedColumn<bool> dryWeightConfirmed = GeneratedColumn<bool>(
      'dry_weight_confirmed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("dry_weight_confirmed" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _amputationsPresentMeta =
      const VerificationMeta('amputationsPresent');
  @override
  late final GeneratedColumn<bool> amputationsPresent = GeneratedColumn<bool>(
      'amputations_present', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("amputations_present" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _pregnancyPresentMeta =
      const VerificationMeta('pregnancyPresent');
  @override
  late final GeneratedColumn<bool> pregnancyPresent = GeneratedColumn<bool>(
      'pregnancy_present', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("pregnancy_present" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _spinalIssuesMeta =
      const VerificationMeta('spinalIssues');
  @override
  late final GeneratedColumn<bool> spinalIssues = GeneratedColumn<bool>(
      'spinal_issues', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("spinal_issues" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _ascitesSeverityMeta =
      const VerificationMeta('ascitesSeverity');
  @override
  late final GeneratedColumn<String> ascitesSeverity = GeneratedColumn<String>(
      'ascites_severity', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _amputationsJsonMeta =
      const VerificationMeta('amputationsJson');
  @override
  late final GeneratedColumn<String> amputationsJson = GeneratedColumn<String>(
      'amputations_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _pendingActionsJsonMeta =
      const VerificationMeta('pendingActionsJson');
  @override
  late final GeneratedColumn<String> pendingActionsJson =
      GeneratedColumn<String>('pending_actions_json', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _traceJsonMeta =
      const VerificationMeta('traceJson');
  @override
  late final GeneratedColumn<String> traceJson = GeneratedColumn<String>(
      'trace_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        patientId,
        createdAt,
        weightRealKg,
        heightCm,
        heightMethod,
        weightSource,
        confidence,
        bmi,
        idealWeightKg,
        adjustedWeightKg,
        workWeightKg,
        workWeightLabel,
        proteinBaseKg,
        kcalBaseKg,
        overrideJustification,
        kneeHeightCm,
        ulnaLengthCm,
        estimatedHeightCm,
        obesitySuspected,
        edemaPresent,
        ascitesPresent,
        dryWeightConfirmed,
        amputationsPresent,
        pregnancyPresent,
        spinalIssues,
        ascitesSeverity,
        amputationsJson,
        pendingActionsJson,
        traceJson
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'weight_assessments';
  @override
  VerificationContext validateIntegrity(Insertable<WeightAssessment> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('patient_id')) {
      context.handle(_patientIdMeta,
          patientId.isAcceptableOrUnknown(data['patient_id']!, _patientIdMeta));
    } else if (isInserting) {
      context.missing(_patientIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('weight_real_kg')) {
      context.handle(
          _weightRealKgMeta,
          weightRealKg.isAcceptableOrUnknown(
              data['weight_real_kg']!, _weightRealKgMeta));
    }
    if (data.containsKey('height_cm')) {
      context.handle(_heightCmMeta,
          heightCm.isAcceptableOrUnknown(data['height_cm']!, _heightCmMeta));
    }
    if (data.containsKey('height_method')) {
      context.handle(
          _heightMethodMeta,
          heightMethod.isAcceptableOrUnknown(
              data['height_method']!, _heightMethodMeta));
    }
    if (data.containsKey('weight_source')) {
      context.handle(
          _weightSourceMeta,
          weightSource.isAcceptableOrUnknown(
              data['weight_source']!, _weightSourceMeta));
    }
    if (data.containsKey('confidence')) {
      context.handle(
          _confidenceMeta,
          confidence.isAcceptableOrUnknown(
              data['confidence']!, _confidenceMeta));
    }
    if (data.containsKey('bmi')) {
      context.handle(
          _bmiMeta, bmi.isAcceptableOrUnknown(data['bmi']!, _bmiMeta));
    }
    if (data.containsKey('ideal_weight_kg')) {
      context.handle(
          _idealWeightKgMeta,
          idealWeightKg.isAcceptableOrUnknown(
              data['ideal_weight_kg']!, _idealWeightKgMeta));
    }
    if (data.containsKey('adjusted_weight_kg')) {
      context.handle(
          _adjustedWeightKgMeta,
          adjustedWeightKg.isAcceptableOrUnknown(
              data['adjusted_weight_kg']!, _adjustedWeightKgMeta));
    }
    if (data.containsKey('work_weight_kg')) {
      context.handle(
          _workWeightKgMeta,
          workWeightKg.isAcceptableOrUnknown(
              data['work_weight_kg']!, _workWeightKgMeta));
    }
    if (data.containsKey('work_weight_label')) {
      context.handle(
          _workWeightLabelMeta,
          workWeightLabel.isAcceptableOrUnknown(
              data['work_weight_label']!, _workWeightLabelMeta));
    }
    if (data.containsKey('protein_base_kg')) {
      context.handle(
          _proteinBaseKgMeta,
          proteinBaseKg.isAcceptableOrUnknown(
              data['protein_base_kg']!, _proteinBaseKgMeta));
    }
    if (data.containsKey('kcal_base_kg')) {
      context.handle(
          _kcalBaseKgMeta,
          kcalBaseKg.isAcceptableOrUnknown(
              data['kcal_base_kg']!, _kcalBaseKgMeta));
    }
    if (data.containsKey('override_justification')) {
      context.handle(
          _overrideJustificationMeta,
          overrideJustification.isAcceptableOrUnknown(
              data['override_justification']!, _overrideJustificationMeta));
    }
    if (data.containsKey('knee_height_cm')) {
      context.handle(
          _kneeHeightCmMeta,
          kneeHeightCm.isAcceptableOrUnknown(
              data['knee_height_cm']!, _kneeHeightCmMeta));
    }
    if (data.containsKey('ulna_length_cm')) {
      context.handle(
          _ulnaLengthCmMeta,
          ulnaLengthCm.isAcceptableOrUnknown(
              data['ulna_length_cm']!, _ulnaLengthCmMeta));
    }
    if (data.containsKey('estimated_height_cm')) {
      context.handle(
          _estimatedHeightCmMeta,
          estimatedHeightCm.isAcceptableOrUnknown(
              data['estimated_height_cm']!, _estimatedHeightCmMeta));
    }
    if (data.containsKey('obesity_suspected')) {
      context.handle(
          _obesitySuspectedMeta,
          obesitySuspected.isAcceptableOrUnknown(
              data['obesity_suspected']!, _obesitySuspectedMeta));
    }
    if (data.containsKey('edema_present')) {
      context.handle(
          _edemaPresentMeta,
          edemaPresent.isAcceptableOrUnknown(
              data['edema_present']!, _edemaPresentMeta));
    }
    if (data.containsKey('ascites_present')) {
      context.handle(
          _ascitesPresentMeta,
          ascitesPresent.isAcceptableOrUnknown(
              data['ascites_present']!, _ascitesPresentMeta));
    }
    if (data.containsKey('dry_weight_confirmed')) {
      context.handle(
          _dryWeightConfirmedMeta,
          dryWeightConfirmed.isAcceptableOrUnknown(
              data['dry_weight_confirmed']!, _dryWeightConfirmedMeta));
    }
    if (data.containsKey('amputations_present')) {
      context.handle(
          _amputationsPresentMeta,
          amputationsPresent.isAcceptableOrUnknown(
              data['amputations_present']!, _amputationsPresentMeta));
    }
    if (data.containsKey('pregnancy_present')) {
      context.handle(
          _pregnancyPresentMeta,
          pregnancyPresent.isAcceptableOrUnknown(
              data['pregnancy_present']!, _pregnancyPresentMeta));
    }
    if (data.containsKey('spinal_issues')) {
      context.handle(
          _spinalIssuesMeta,
          spinalIssues.isAcceptableOrUnknown(
              data['spinal_issues']!, _spinalIssuesMeta));
    }
    if (data.containsKey('ascites_severity')) {
      context.handle(
          _ascitesSeverityMeta,
          ascitesSeverity.isAcceptableOrUnknown(
              data['ascites_severity']!, _ascitesSeverityMeta));
    }
    if (data.containsKey('amputations_json')) {
      context.handle(
          _amputationsJsonMeta,
          amputationsJson.isAcceptableOrUnknown(
              data['amputations_json']!, _amputationsJsonMeta));
    }
    if (data.containsKey('pending_actions_json')) {
      context.handle(
          _pendingActionsJsonMeta,
          pendingActionsJson.isAcceptableOrUnknown(
              data['pending_actions_json']!, _pendingActionsJsonMeta));
    }
    if (data.containsKey('trace_json')) {
      context.handle(_traceJsonMeta,
          traceJson.isAcceptableOrUnknown(data['trace_json']!, _traceJsonMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WeightAssessment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WeightAssessment(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      patientId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}patient_id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      weightRealKg: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}weight_real_kg']),
      heightCm: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}height_cm']),
      heightMethod: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}height_method']),
      weightSource: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}weight_source']),
      confidence: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}confidence']),
      bmi: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}bmi']),
      idealWeightKg: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}ideal_weight_kg']),
      adjustedWeightKg: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}adjusted_weight_kg']),
      workWeightKg: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}work_weight_kg']),
      workWeightLabel: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}work_weight_label']),
      proteinBaseKg: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}protein_base_kg']),
      kcalBaseKg: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}kcal_base_kg']),
      overrideJustification: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}override_justification']),
      kneeHeightCm: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}knee_height_cm']),
      ulnaLengthCm: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}ulna_length_cm']),
      estimatedHeightCm: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}estimated_height_cm']),
      obesitySuspected: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}obesity_suspected'])!,
      edemaPresent: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}edema_present'])!,
      ascitesPresent: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}ascites_present'])!,
      dryWeightConfirmed: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}dry_weight_confirmed'])!,
      amputationsPresent: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}amputations_present'])!,
      pregnancyPresent: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}pregnancy_present'])!,
      spinalIssues: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}spinal_issues'])!,
      ascitesSeverity: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}ascites_severity']),
      amputationsJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}amputations_json']),
      pendingActionsJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}pending_actions_json']),
      traceJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}trace_json']),
    );
  }

  @override
  $WeightAssessmentsTable createAlias(String alias) {
    return $WeightAssessmentsTable(attachedDatabase, alias);
  }
}

class WeightAssessment extends DataClass
    implements Insertable<WeightAssessment> {
  final String id;
  final String patientId;
  final DateTime createdAt;
  final double? weightRealKg;
  final double? heightCm;
  final String? heightMethod;
  final String? weightSource;
  final String? confidence;
  final double? bmi;
  final double? idealWeightKg;
  final double? adjustedWeightKg;
  final double? workWeightKg;
  final String? workWeightLabel;
  final double? proteinBaseKg;
  final double? kcalBaseKg;
  final String? overrideJustification;
  final double? kneeHeightCm;
  final double? ulnaLengthCm;
  final double? estimatedHeightCm;
  final bool obesitySuspected;
  final bool edemaPresent;
  final bool ascitesPresent;
  final bool dryWeightConfirmed;
  final bool amputationsPresent;
  final bool pregnancyPresent;
  final bool spinalIssues;
  final String? ascitesSeverity;
  final String? amputationsJson;
  final String? pendingActionsJson;
  final String? traceJson;
  const WeightAssessment(
      {required this.id,
      required this.patientId,
      required this.createdAt,
      this.weightRealKg,
      this.heightCm,
      this.heightMethod,
      this.weightSource,
      this.confidence,
      this.bmi,
      this.idealWeightKg,
      this.adjustedWeightKg,
      this.workWeightKg,
      this.workWeightLabel,
      this.proteinBaseKg,
      this.kcalBaseKg,
      this.overrideJustification,
      this.kneeHeightCm,
      this.ulnaLengthCm,
      this.estimatedHeightCm,
      required this.obesitySuspected,
      required this.edemaPresent,
      required this.ascitesPresent,
      required this.dryWeightConfirmed,
      required this.amputationsPresent,
      required this.pregnancyPresent,
      required this.spinalIssues,
      this.ascitesSeverity,
      this.amputationsJson,
      this.pendingActionsJson,
      this.traceJson});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['patient_id'] = Variable<String>(patientId);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || weightRealKg != null) {
      map['weight_real_kg'] = Variable<double>(weightRealKg);
    }
    if (!nullToAbsent || heightCm != null) {
      map['height_cm'] = Variable<double>(heightCm);
    }
    if (!nullToAbsent || heightMethod != null) {
      map['height_method'] = Variable<String>(heightMethod);
    }
    if (!nullToAbsent || weightSource != null) {
      map['weight_source'] = Variable<String>(weightSource);
    }
    if (!nullToAbsent || confidence != null) {
      map['confidence'] = Variable<String>(confidence);
    }
    if (!nullToAbsent || bmi != null) {
      map['bmi'] = Variable<double>(bmi);
    }
    if (!nullToAbsent || idealWeightKg != null) {
      map['ideal_weight_kg'] = Variable<double>(idealWeightKg);
    }
    if (!nullToAbsent || adjustedWeightKg != null) {
      map['adjusted_weight_kg'] = Variable<double>(adjustedWeightKg);
    }
    if (!nullToAbsent || workWeightKg != null) {
      map['work_weight_kg'] = Variable<double>(workWeightKg);
    }
    if (!nullToAbsent || workWeightLabel != null) {
      map['work_weight_label'] = Variable<String>(workWeightLabel);
    }
    if (!nullToAbsent || proteinBaseKg != null) {
      map['protein_base_kg'] = Variable<double>(proteinBaseKg);
    }
    if (!nullToAbsent || kcalBaseKg != null) {
      map['kcal_base_kg'] = Variable<double>(kcalBaseKg);
    }
    if (!nullToAbsent || overrideJustification != null) {
      map['override_justification'] = Variable<String>(overrideJustification);
    }
    if (!nullToAbsent || kneeHeightCm != null) {
      map['knee_height_cm'] = Variable<double>(kneeHeightCm);
    }
    if (!nullToAbsent || ulnaLengthCm != null) {
      map['ulna_length_cm'] = Variable<double>(ulnaLengthCm);
    }
    if (!nullToAbsent || estimatedHeightCm != null) {
      map['estimated_height_cm'] = Variable<double>(estimatedHeightCm);
    }
    map['obesity_suspected'] = Variable<bool>(obesitySuspected);
    map['edema_present'] = Variable<bool>(edemaPresent);
    map['ascites_present'] = Variable<bool>(ascitesPresent);
    map['dry_weight_confirmed'] = Variable<bool>(dryWeightConfirmed);
    map['amputations_present'] = Variable<bool>(amputationsPresent);
    map['pregnancy_present'] = Variable<bool>(pregnancyPresent);
    map['spinal_issues'] = Variable<bool>(spinalIssues);
    if (!nullToAbsent || ascitesSeverity != null) {
      map['ascites_severity'] = Variable<String>(ascitesSeverity);
    }
    if (!nullToAbsent || amputationsJson != null) {
      map['amputations_json'] = Variable<String>(amputationsJson);
    }
    if (!nullToAbsent || pendingActionsJson != null) {
      map['pending_actions_json'] = Variable<String>(pendingActionsJson);
    }
    if (!nullToAbsent || traceJson != null) {
      map['trace_json'] = Variable<String>(traceJson);
    }
    return map;
  }

  WeightAssessmentsCompanion toCompanion(bool nullToAbsent) {
    return WeightAssessmentsCompanion(
      id: Value(id),
      patientId: Value(patientId),
      createdAt: Value(createdAt),
      weightRealKg: weightRealKg == null && nullToAbsent
          ? const Value.absent()
          : Value(weightRealKg),
      heightCm: heightCm == null && nullToAbsent
          ? const Value.absent()
          : Value(heightCm),
      heightMethod: heightMethod == null && nullToAbsent
          ? const Value.absent()
          : Value(heightMethod),
      weightSource: weightSource == null && nullToAbsent
          ? const Value.absent()
          : Value(weightSource),
      confidence: confidence == null && nullToAbsent
          ? const Value.absent()
          : Value(confidence),
      bmi: bmi == null && nullToAbsent ? const Value.absent() : Value(bmi),
      idealWeightKg: idealWeightKg == null && nullToAbsent
          ? const Value.absent()
          : Value(idealWeightKg),
      adjustedWeightKg: adjustedWeightKg == null && nullToAbsent
          ? const Value.absent()
          : Value(adjustedWeightKg),
      workWeightKg: workWeightKg == null && nullToAbsent
          ? const Value.absent()
          : Value(workWeightKg),
      workWeightLabel: workWeightLabel == null && nullToAbsent
          ? const Value.absent()
          : Value(workWeightLabel),
      proteinBaseKg: proteinBaseKg == null && nullToAbsent
          ? const Value.absent()
          : Value(proteinBaseKg),
      kcalBaseKg: kcalBaseKg == null && nullToAbsent
          ? const Value.absent()
          : Value(kcalBaseKg),
      overrideJustification: overrideJustification == null && nullToAbsent
          ? const Value.absent()
          : Value(overrideJustification),
      kneeHeightCm: kneeHeightCm == null && nullToAbsent
          ? const Value.absent()
          : Value(kneeHeightCm),
      ulnaLengthCm: ulnaLengthCm == null && nullToAbsent
          ? const Value.absent()
          : Value(ulnaLengthCm),
      estimatedHeightCm: estimatedHeightCm == null && nullToAbsent
          ? const Value.absent()
          : Value(estimatedHeightCm),
      obesitySuspected: Value(obesitySuspected),
      edemaPresent: Value(edemaPresent),
      ascitesPresent: Value(ascitesPresent),
      dryWeightConfirmed: Value(dryWeightConfirmed),
      amputationsPresent: Value(amputationsPresent),
      pregnancyPresent: Value(pregnancyPresent),
      spinalIssues: Value(spinalIssues),
      ascitesSeverity: ascitesSeverity == null && nullToAbsent
          ? const Value.absent()
          : Value(ascitesSeverity),
      amputationsJson: amputationsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(amputationsJson),
      pendingActionsJson: pendingActionsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(pendingActionsJson),
      traceJson: traceJson == null && nullToAbsent
          ? const Value.absent()
          : Value(traceJson),
    );
  }

  factory WeightAssessment.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WeightAssessment(
      id: serializer.fromJson<String>(json['id']),
      patientId: serializer.fromJson<String>(json['patientId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      weightRealKg: serializer.fromJson<double?>(json['weightRealKg']),
      heightCm: serializer.fromJson<double?>(json['heightCm']),
      heightMethod: serializer.fromJson<String?>(json['heightMethod']),
      weightSource: serializer.fromJson<String?>(json['weightSource']),
      confidence: serializer.fromJson<String?>(json['confidence']),
      bmi: serializer.fromJson<double?>(json['bmi']),
      idealWeightKg: serializer.fromJson<double?>(json['idealWeightKg']),
      adjustedWeightKg: serializer.fromJson<double?>(json['adjustedWeightKg']),
      workWeightKg: serializer.fromJson<double?>(json['workWeightKg']),
      workWeightLabel: serializer.fromJson<String?>(json['workWeightLabel']),
      proteinBaseKg: serializer.fromJson<double?>(json['proteinBaseKg']),
      kcalBaseKg: serializer.fromJson<double?>(json['kcalBaseKg']),
      overrideJustification:
          serializer.fromJson<String?>(json['overrideJustification']),
      kneeHeightCm: serializer.fromJson<double?>(json['kneeHeightCm']),
      ulnaLengthCm: serializer.fromJson<double?>(json['ulnaLengthCm']),
      estimatedHeightCm:
          serializer.fromJson<double?>(json['estimatedHeightCm']),
      obesitySuspected: serializer.fromJson<bool>(json['obesitySuspected']),
      edemaPresent: serializer.fromJson<bool>(json['edemaPresent']),
      ascitesPresent: serializer.fromJson<bool>(json['ascitesPresent']),
      dryWeightConfirmed: serializer.fromJson<bool>(json['dryWeightConfirmed']),
      amputationsPresent: serializer.fromJson<bool>(json['amputationsPresent']),
      pregnancyPresent: serializer.fromJson<bool>(json['pregnancyPresent']),
      spinalIssues: serializer.fromJson<bool>(json['spinalIssues']),
      ascitesSeverity: serializer.fromJson<String?>(json['ascitesSeverity']),
      amputationsJson: serializer.fromJson<String?>(json['amputationsJson']),
      pendingActionsJson:
          serializer.fromJson<String?>(json['pendingActionsJson']),
      traceJson: serializer.fromJson<String?>(json['traceJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'patientId': serializer.toJson<String>(patientId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'weightRealKg': serializer.toJson<double?>(weightRealKg),
      'heightCm': serializer.toJson<double?>(heightCm),
      'heightMethod': serializer.toJson<String?>(heightMethod),
      'weightSource': serializer.toJson<String?>(weightSource),
      'confidence': serializer.toJson<String?>(confidence),
      'bmi': serializer.toJson<double?>(bmi),
      'idealWeightKg': serializer.toJson<double?>(idealWeightKg),
      'adjustedWeightKg': serializer.toJson<double?>(adjustedWeightKg),
      'workWeightKg': serializer.toJson<double?>(workWeightKg),
      'workWeightLabel': serializer.toJson<String?>(workWeightLabel),
      'proteinBaseKg': serializer.toJson<double?>(proteinBaseKg),
      'kcalBaseKg': serializer.toJson<double?>(kcalBaseKg),
      'overrideJustification':
          serializer.toJson<String?>(overrideJustification),
      'kneeHeightCm': serializer.toJson<double?>(kneeHeightCm),
      'ulnaLengthCm': serializer.toJson<double?>(ulnaLengthCm),
      'estimatedHeightCm': serializer.toJson<double?>(estimatedHeightCm),
      'obesitySuspected': serializer.toJson<bool>(obesitySuspected),
      'edemaPresent': serializer.toJson<bool>(edemaPresent),
      'ascitesPresent': serializer.toJson<bool>(ascitesPresent),
      'dryWeightConfirmed': serializer.toJson<bool>(dryWeightConfirmed),
      'amputationsPresent': serializer.toJson<bool>(amputationsPresent),
      'pregnancyPresent': serializer.toJson<bool>(pregnancyPresent),
      'spinalIssues': serializer.toJson<bool>(spinalIssues),
      'ascitesSeverity': serializer.toJson<String?>(ascitesSeverity),
      'amputationsJson': serializer.toJson<String?>(amputationsJson),
      'pendingActionsJson': serializer.toJson<String?>(pendingActionsJson),
      'traceJson': serializer.toJson<String?>(traceJson),
    };
  }

  WeightAssessment copyWith(
          {String? id,
          String? patientId,
          DateTime? createdAt,
          Value<double?> weightRealKg = const Value.absent(),
          Value<double?> heightCm = const Value.absent(),
          Value<String?> heightMethod = const Value.absent(),
          Value<String?> weightSource = const Value.absent(),
          Value<String?> confidence = const Value.absent(),
          Value<double?> bmi = const Value.absent(),
          Value<double?> idealWeightKg = const Value.absent(),
          Value<double?> adjustedWeightKg = const Value.absent(),
          Value<double?> workWeightKg = const Value.absent(),
          Value<String?> workWeightLabel = const Value.absent(),
          Value<double?> proteinBaseKg = const Value.absent(),
          Value<double?> kcalBaseKg = const Value.absent(),
          Value<String?> overrideJustification = const Value.absent(),
          Value<double?> kneeHeightCm = const Value.absent(),
          Value<double?> ulnaLengthCm = const Value.absent(),
          Value<double?> estimatedHeightCm = const Value.absent(),
          bool? obesitySuspected,
          bool? edemaPresent,
          bool? ascitesPresent,
          bool? dryWeightConfirmed,
          bool? amputationsPresent,
          bool? pregnancyPresent,
          bool? spinalIssues,
          Value<String?> ascitesSeverity = const Value.absent(),
          Value<String?> amputationsJson = const Value.absent(),
          Value<String?> pendingActionsJson = const Value.absent(),
          Value<String?> traceJson = const Value.absent()}) =>
      WeightAssessment(
        id: id ?? this.id,
        patientId: patientId ?? this.patientId,
        createdAt: createdAt ?? this.createdAt,
        weightRealKg:
            weightRealKg.present ? weightRealKg.value : this.weightRealKg,
        heightCm: heightCm.present ? heightCm.value : this.heightCm,
        heightMethod:
            heightMethod.present ? heightMethod.value : this.heightMethod,
        weightSource:
            weightSource.present ? weightSource.value : this.weightSource,
        confidence: confidence.present ? confidence.value : this.confidence,
        bmi: bmi.present ? bmi.value : this.bmi,
        idealWeightKg:
            idealWeightKg.present ? idealWeightKg.value : this.idealWeightKg,
        adjustedWeightKg: adjustedWeightKg.present
            ? adjustedWeightKg.value
            : this.adjustedWeightKg,
        workWeightKg:
            workWeightKg.present ? workWeightKg.value : this.workWeightKg,
        workWeightLabel: workWeightLabel.present
            ? workWeightLabel.value
            : this.workWeightLabel,
        proteinBaseKg:
            proteinBaseKg.present ? proteinBaseKg.value : this.proteinBaseKg,
        kcalBaseKg: kcalBaseKg.present ? kcalBaseKg.value : this.kcalBaseKg,
        overrideJustification: overrideJustification.present
            ? overrideJustification.value
            : this.overrideJustification,
        kneeHeightCm:
            kneeHeightCm.present ? kneeHeightCm.value : this.kneeHeightCm,
        ulnaLengthCm:
            ulnaLengthCm.present ? ulnaLengthCm.value : this.ulnaLengthCm,
        estimatedHeightCm: estimatedHeightCm.present
            ? estimatedHeightCm.value
            : this.estimatedHeightCm,
        obesitySuspected: obesitySuspected ?? this.obesitySuspected,
        edemaPresent: edemaPresent ?? this.edemaPresent,
        ascitesPresent: ascitesPresent ?? this.ascitesPresent,
        dryWeightConfirmed: dryWeightConfirmed ?? this.dryWeightConfirmed,
        amputationsPresent: amputationsPresent ?? this.amputationsPresent,
        pregnancyPresent: pregnancyPresent ?? this.pregnancyPresent,
        spinalIssues: spinalIssues ?? this.spinalIssues,
        ascitesSeverity: ascitesSeverity.present
            ? ascitesSeverity.value
            : this.ascitesSeverity,
        amputationsJson: amputationsJson.present
            ? amputationsJson.value
            : this.amputationsJson,
        pendingActionsJson: pendingActionsJson.present
            ? pendingActionsJson.value
            : this.pendingActionsJson,
        traceJson: traceJson.present ? traceJson.value : this.traceJson,
      );
  WeightAssessment copyWithCompanion(WeightAssessmentsCompanion data) {
    return WeightAssessment(
      id: data.id.present ? data.id.value : this.id,
      patientId: data.patientId.present ? data.patientId.value : this.patientId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      weightRealKg: data.weightRealKg.present
          ? data.weightRealKg.value
          : this.weightRealKg,
      heightCm: data.heightCm.present ? data.heightCm.value : this.heightCm,
      heightMethod: data.heightMethod.present
          ? data.heightMethod.value
          : this.heightMethod,
      weightSource: data.weightSource.present
          ? data.weightSource.value
          : this.weightSource,
      confidence:
          data.confidence.present ? data.confidence.value : this.confidence,
      bmi: data.bmi.present ? data.bmi.value : this.bmi,
      idealWeightKg: data.idealWeightKg.present
          ? data.idealWeightKg.value
          : this.idealWeightKg,
      adjustedWeightKg: data.adjustedWeightKg.present
          ? data.adjustedWeightKg.value
          : this.adjustedWeightKg,
      workWeightKg: data.workWeightKg.present
          ? data.workWeightKg.value
          : this.workWeightKg,
      workWeightLabel: data.workWeightLabel.present
          ? data.workWeightLabel.value
          : this.workWeightLabel,
      proteinBaseKg: data.proteinBaseKg.present
          ? data.proteinBaseKg.value
          : this.proteinBaseKg,
      kcalBaseKg:
          data.kcalBaseKg.present ? data.kcalBaseKg.value : this.kcalBaseKg,
      overrideJustification: data.overrideJustification.present
          ? data.overrideJustification.value
          : this.overrideJustification,
      kneeHeightCm: data.kneeHeightCm.present
          ? data.kneeHeightCm.value
          : this.kneeHeightCm,
      ulnaLengthCm: data.ulnaLengthCm.present
          ? data.ulnaLengthCm.value
          : this.ulnaLengthCm,
      estimatedHeightCm: data.estimatedHeightCm.present
          ? data.estimatedHeightCm.value
          : this.estimatedHeightCm,
      obesitySuspected: data.obesitySuspected.present
          ? data.obesitySuspected.value
          : this.obesitySuspected,
      edemaPresent: data.edemaPresent.present
          ? data.edemaPresent.value
          : this.edemaPresent,
      ascitesPresent: data.ascitesPresent.present
          ? data.ascitesPresent.value
          : this.ascitesPresent,
      dryWeightConfirmed: data.dryWeightConfirmed.present
          ? data.dryWeightConfirmed.value
          : this.dryWeightConfirmed,
      amputationsPresent: data.amputationsPresent.present
          ? data.amputationsPresent.value
          : this.amputationsPresent,
      pregnancyPresent: data.pregnancyPresent.present
          ? data.pregnancyPresent.value
          : this.pregnancyPresent,
      spinalIssues: data.spinalIssues.present
          ? data.spinalIssues.value
          : this.spinalIssues,
      ascitesSeverity: data.ascitesSeverity.present
          ? data.ascitesSeverity.value
          : this.ascitesSeverity,
      amputationsJson: data.amputationsJson.present
          ? data.amputationsJson.value
          : this.amputationsJson,
      pendingActionsJson: data.pendingActionsJson.present
          ? data.pendingActionsJson.value
          : this.pendingActionsJson,
      traceJson: data.traceJson.present ? data.traceJson.value : this.traceJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WeightAssessment(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('createdAt: $createdAt, ')
          ..write('weightRealKg: $weightRealKg, ')
          ..write('heightCm: $heightCm, ')
          ..write('heightMethod: $heightMethod, ')
          ..write('weightSource: $weightSource, ')
          ..write('confidence: $confidence, ')
          ..write('bmi: $bmi, ')
          ..write('idealWeightKg: $idealWeightKg, ')
          ..write('adjustedWeightKg: $adjustedWeightKg, ')
          ..write('workWeightKg: $workWeightKg, ')
          ..write('workWeightLabel: $workWeightLabel, ')
          ..write('proteinBaseKg: $proteinBaseKg, ')
          ..write('kcalBaseKg: $kcalBaseKg, ')
          ..write('overrideJustification: $overrideJustification, ')
          ..write('kneeHeightCm: $kneeHeightCm, ')
          ..write('ulnaLengthCm: $ulnaLengthCm, ')
          ..write('estimatedHeightCm: $estimatedHeightCm, ')
          ..write('obesitySuspected: $obesitySuspected, ')
          ..write('edemaPresent: $edemaPresent, ')
          ..write('ascitesPresent: $ascitesPresent, ')
          ..write('dryWeightConfirmed: $dryWeightConfirmed, ')
          ..write('amputationsPresent: $amputationsPresent, ')
          ..write('pregnancyPresent: $pregnancyPresent, ')
          ..write('spinalIssues: $spinalIssues, ')
          ..write('ascitesSeverity: $ascitesSeverity, ')
          ..write('amputationsJson: $amputationsJson, ')
          ..write('pendingActionsJson: $pendingActionsJson, ')
          ..write('traceJson: $traceJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        patientId,
        createdAt,
        weightRealKg,
        heightCm,
        heightMethod,
        weightSource,
        confidence,
        bmi,
        idealWeightKg,
        adjustedWeightKg,
        workWeightKg,
        workWeightLabel,
        proteinBaseKg,
        kcalBaseKg,
        overrideJustification,
        kneeHeightCm,
        ulnaLengthCm,
        estimatedHeightCm,
        obesitySuspected,
        edemaPresent,
        ascitesPresent,
        dryWeightConfirmed,
        amputationsPresent,
        pregnancyPresent,
        spinalIssues,
        ascitesSeverity,
        amputationsJson,
        pendingActionsJson,
        traceJson
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WeightAssessment &&
          other.id == this.id &&
          other.patientId == this.patientId &&
          other.createdAt == this.createdAt &&
          other.weightRealKg == this.weightRealKg &&
          other.heightCm == this.heightCm &&
          other.heightMethod == this.heightMethod &&
          other.weightSource == this.weightSource &&
          other.confidence == this.confidence &&
          other.bmi == this.bmi &&
          other.idealWeightKg == this.idealWeightKg &&
          other.adjustedWeightKg == this.adjustedWeightKg &&
          other.workWeightKg == this.workWeightKg &&
          other.workWeightLabel == this.workWeightLabel &&
          other.proteinBaseKg == this.proteinBaseKg &&
          other.kcalBaseKg == this.kcalBaseKg &&
          other.overrideJustification == this.overrideJustification &&
          other.kneeHeightCm == this.kneeHeightCm &&
          other.ulnaLengthCm == this.ulnaLengthCm &&
          other.estimatedHeightCm == this.estimatedHeightCm &&
          other.obesitySuspected == this.obesitySuspected &&
          other.edemaPresent == this.edemaPresent &&
          other.ascitesPresent == this.ascitesPresent &&
          other.dryWeightConfirmed == this.dryWeightConfirmed &&
          other.amputationsPresent == this.amputationsPresent &&
          other.pregnancyPresent == this.pregnancyPresent &&
          other.spinalIssues == this.spinalIssues &&
          other.ascitesSeverity == this.ascitesSeverity &&
          other.amputationsJson == this.amputationsJson &&
          other.pendingActionsJson == this.pendingActionsJson &&
          other.traceJson == this.traceJson);
}

class WeightAssessmentsCompanion extends UpdateCompanion<WeightAssessment> {
  final Value<String> id;
  final Value<String> patientId;
  final Value<DateTime> createdAt;
  final Value<double?> weightRealKg;
  final Value<double?> heightCm;
  final Value<String?> heightMethod;
  final Value<String?> weightSource;
  final Value<String?> confidence;
  final Value<double?> bmi;
  final Value<double?> idealWeightKg;
  final Value<double?> adjustedWeightKg;
  final Value<double?> workWeightKg;
  final Value<String?> workWeightLabel;
  final Value<double?> proteinBaseKg;
  final Value<double?> kcalBaseKg;
  final Value<String?> overrideJustification;
  final Value<double?> kneeHeightCm;
  final Value<double?> ulnaLengthCm;
  final Value<double?> estimatedHeightCm;
  final Value<bool> obesitySuspected;
  final Value<bool> edemaPresent;
  final Value<bool> ascitesPresent;
  final Value<bool> dryWeightConfirmed;
  final Value<bool> amputationsPresent;
  final Value<bool> pregnancyPresent;
  final Value<bool> spinalIssues;
  final Value<String?> ascitesSeverity;
  final Value<String?> amputationsJson;
  final Value<String?> pendingActionsJson;
  final Value<String?> traceJson;
  final Value<int> rowid;
  const WeightAssessmentsCompanion({
    this.id = const Value.absent(),
    this.patientId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.weightRealKg = const Value.absent(),
    this.heightCm = const Value.absent(),
    this.heightMethod = const Value.absent(),
    this.weightSource = const Value.absent(),
    this.confidence = const Value.absent(),
    this.bmi = const Value.absent(),
    this.idealWeightKg = const Value.absent(),
    this.adjustedWeightKg = const Value.absent(),
    this.workWeightKg = const Value.absent(),
    this.workWeightLabel = const Value.absent(),
    this.proteinBaseKg = const Value.absent(),
    this.kcalBaseKg = const Value.absent(),
    this.overrideJustification = const Value.absent(),
    this.kneeHeightCm = const Value.absent(),
    this.ulnaLengthCm = const Value.absent(),
    this.estimatedHeightCm = const Value.absent(),
    this.obesitySuspected = const Value.absent(),
    this.edemaPresent = const Value.absent(),
    this.ascitesPresent = const Value.absent(),
    this.dryWeightConfirmed = const Value.absent(),
    this.amputationsPresent = const Value.absent(),
    this.pregnancyPresent = const Value.absent(),
    this.spinalIssues = const Value.absent(),
    this.ascitesSeverity = const Value.absent(),
    this.amputationsJson = const Value.absent(),
    this.pendingActionsJson = const Value.absent(),
    this.traceJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WeightAssessmentsCompanion.insert({
    required String id,
    required String patientId,
    this.createdAt = const Value.absent(),
    this.weightRealKg = const Value.absent(),
    this.heightCm = const Value.absent(),
    this.heightMethod = const Value.absent(),
    this.weightSource = const Value.absent(),
    this.confidence = const Value.absent(),
    this.bmi = const Value.absent(),
    this.idealWeightKg = const Value.absent(),
    this.adjustedWeightKg = const Value.absent(),
    this.workWeightKg = const Value.absent(),
    this.workWeightLabel = const Value.absent(),
    this.proteinBaseKg = const Value.absent(),
    this.kcalBaseKg = const Value.absent(),
    this.overrideJustification = const Value.absent(),
    this.kneeHeightCm = const Value.absent(),
    this.ulnaLengthCm = const Value.absent(),
    this.estimatedHeightCm = const Value.absent(),
    this.obesitySuspected = const Value.absent(),
    this.edemaPresent = const Value.absent(),
    this.ascitesPresent = const Value.absent(),
    this.dryWeightConfirmed = const Value.absent(),
    this.amputationsPresent = const Value.absent(),
    this.pregnancyPresent = const Value.absent(),
    this.spinalIssues = const Value.absent(),
    this.ascitesSeverity = const Value.absent(),
    this.amputationsJson = const Value.absent(),
    this.pendingActionsJson = const Value.absent(),
    this.traceJson = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        patientId = Value(patientId);
  static Insertable<WeightAssessment> custom({
    Expression<String>? id,
    Expression<String>? patientId,
    Expression<DateTime>? createdAt,
    Expression<double>? weightRealKg,
    Expression<double>? heightCm,
    Expression<String>? heightMethod,
    Expression<String>? weightSource,
    Expression<String>? confidence,
    Expression<double>? bmi,
    Expression<double>? idealWeightKg,
    Expression<double>? adjustedWeightKg,
    Expression<double>? workWeightKg,
    Expression<String>? workWeightLabel,
    Expression<double>? proteinBaseKg,
    Expression<double>? kcalBaseKg,
    Expression<String>? overrideJustification,
    Expression<double>? kneeHeightCm,
    Expression<double>? ulnaLengthCm,
    Expression<double>? estimatedHeightCm,
    Expression<bool>? obesitySuspected,
    Expression<bool>? edemaPresent,
    Expression<bool>? ascitesPresent,
    Expression<bool>? dryWeightConfirmed,
    Expression<bool>? amputationsPresent,
    Expression<bool>? pregnancyPresent,
    Expression<bool>? spinalIssues,
    Expression<String>? ascitesSeverity,
    Expression<String>? amputationsJson,
    Expression<String>? pendingActionsJson,
    Expression<String>? traceJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (patientId != null) 'patient_id': patientId,
      if (createdAt != null) 'created_at': createdAt,
      if (weightRealKg != null) 'weight_real_kg': weightRealKg,
      if (heightCm != null) 'height_cm': heightCm,
      if (heightMethod != null) 'height_method': heightMethod,
      if (weightSource != null) 'weight_source': weightSource,
      if (confidence != null) 'confidence': confidence,
      if (bmi != null) 'bmi': bmi,
      if (idealWeightKg != null) 'ideal_weight_kg': idealWeightKg,
      if (adjustedWeightKg != null) 'adjusted_weight_kg': adjustedWeightKg,
      if (workWeightKg != null) 'work_weight_kg': workWeightKg,
      if (workWeightLabel != null) 'work_weight_label': workWeightLabel,
      if (proteinBaseKg != null) 'protein_base_kg': proteinBaseKg,
      if (kcalBaseKg != null) 'kcal_base_kg': kcalBaseKg,
      if (overrideJustification != null)
        'override_justification': overrideJustification,
      if (kneeHeightCm != null) 'knee_height_cm': kneeHeightCm,
      if (ulnaLengthCm != null) 'ulna_length_cm': ulnaLengthCm,
      if (estimatedHeightCm != null) 'estimated_height_cm': estimatedHeightCm,
      if (obesitySuspected != null) 'obesity_suspected': obesitySuspected,
      if (edemaPresent != null) 'edema_present': edemaPresent,
      if (ascitesPresent != null) 'ascites_present': ascitesPresent,
      if (dryWeightConfirmed != null)
        'dry_weight_confirmed': dryWeightConfirmed,
      if (amputationsPresent != null) 'amputations_present': amputationsPresent,
      if (pregnancyPresent != null) 'pregnancy_present': pregnancyPresent,
      if (spinalIssues != null) 'spinal_issues': spinalIssues,
      if (ascitesSeverity != null) 'ascites_severity': ascitesSeverity,
      if (amputationsJson != null) 'amputations_json': amputationsJson,
      if (pendingActionsJson != null)
        'pending_actions_json': pendingActionsJson,
      if (traceJson != null) 'trace_json': traceJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WeightAssessmentsCompanion copyWith(
      {Value<String>? id,
      Value<String>? patientId,
      Value<DateTime>? createdAt,
      Value<double?>? weightRealKg,
      Value<double?>? heightCm,
      Value<String?>? heightMethod,
      Value<String?>? weightSource,
      Value<String?>? confidence,
      Value<double?>? bmi,
      Value<double?>? idealWeightKg,
      Value<double?>? adjustedWeightKg,
      Value<double?>? workWeightKg,
      Value<String?>? workWeightLabel,
      Value<double?>? proteinBaseKg,
      Value<double?>? kcalBaseKg,
      Value<String?>? overrideJustification,
      Value<double?>? kneeHeightCm,
      Value<double?>? ulnaLengthCm,
      Value<double?>? estimatedHeightCm,
      Value<bool>? obesitySuspected,
      Value<bool>? edemaPresent,
      Value<bool>? ascitesPresent,
      Value<bool>? dryWeightConfirmed,
      Value<bool>? amputationsPresent,
      Value<bool>? pregnancyPresent,
      Value<bool>? spinalIssues,
      Value<String?>? ascitesSeverity,
      Value<String?>? amputationsJson,
      Value<String?>? pendingActionsJson,
      Value<String?>? traceJson,
      Value<int>? rowid}) {
    return WeightAssessmentsCompanion(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      createdAt: createdAt ?? this.createdAt,
      weightRealKg: weightRealKg ?? this.weightRealKg,
      heightCm: heightCm ?? this.heightCm,
      heightMethod: heightMethod ?? this.heightMethod,
      weightSource: weightSource ?? this.weightSource,
      confidence: confidence ?? this.confidence,
      bmi: bmi ?? this.bmi,
      idealWeightKg: idealWeightKg ?? this.idealWeightKg,
      adjustedWeightKg: adjustedWeightKg ?? this.adjustedWeightKg,
      workWeightKg: workWeightKg ?? this.workWeightKg,
      workWeightLabel: workWeightLabel ?? this.workWeightLabel,
      proteinBaseKg: proteinBaseKg ?? this.proteinBaseKg,
      kcalBaseKg: kcalBaseKg ?? this.kcalBaseKg,
      overrideJustification:
          overrideJustification ?? this.overrideJustification,
      kneeHeightCm: kneeHeightCm ?? this.kneeHeightCm,
      ulnaLengthCm: ulnaLengthCm ?? this.ulnaLengthCm,
      estimatedHeightCm: estimatedHeightCm ?? this.estimatedHeightCm,
      obesitySuspected: obesitySuspected ?? this.obesitySuspected,
      edemaPresent: edemaPresent ?? this.edemaPresent,
      ascitesPresent: ascitesPresent ?? this.ascitesPresent,
      dryWeightConfirmed: dryWeightConfirmed ?? this.dryWeightConfirmed,
      amputationsPresent: amputationsPresent ?? this.amputationsPresent,
      pregnancyPresent: pregnancyPresent ?? this.pregnancyPresent,
      spinalIssues: spinalIssues ?? this.spinalIssues,
      ascitesSeverity: ascitesSeverity ?? this.ascitesSeverity,
      amputationsJson: amputationsJson ?? this.amputationsJson,
      pendingActionsJson: pendingActionsJson ?? this.pendingActionsJson,
      traceJson: traceJson ?? this.traceJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (patientId.present) {
      map['patient_id'] = Variable<String>(patientId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (weightRealKg.present) {
      map['weight_real_kg'] = Variable<double>(weightRealKg.value);
    }
    if (heightCm.present) {
      map['height_cm'] = Variable<double>(heightCm.value);
    }
    if (heightMethod.present) {
      map['height_method'] = Variable<String>(heightMethod.value);
    }
    if (weightSource.present) {
      map['weight_source'] = Variable<String>(weightSource.value);
    }
    if (confidence.present) {
      map['confidence'] = Variable<String>(confidence.value);
    }
    if (bmi.present) {
      map['bmi'] = Variable<double>(bmi.value);
    }
    if (idealWeightKg.present) {
      map['ideal_weight_kg'] = Variable<double>(idealWeightKg.value);
    }
    if (adjustedWeightKg.present) {
      map['adjusted_weight_kg'] = Variable<double>(adjustedWeightKg.value);
    }
    if (workWeightKg.present) {
      map['work_weight_kg'] = Variable<double>(workWeightKg.value);
    }
    if (workWeightLabel.present) {
      map['work_weight_label'] = Variable<String>(workWeightLabel.value);
    }
    if (proteinBaseKg.present) {
      map['protein_base_kg'] = Variable<double>(proteinBaseKg.value);
    }
    if (kcalBaseKg.present) {
      map['kcal_base_kg'] = Variable<double>(kcalBaseKg.value);
    }
    if (overrideJustification.present) {
      map['override_justification'] =
          Variable<String>(overrideJustification.value);
    }
    if (kneeHeightCm.present) {
      map['knee_height_cm'] = Variable<double>(kneeHeightCm.value);
    }
    if (ulnaLengthCm.present) {
      map['ulna_length_cm'] = Variable<double>(ulnaLengthCm.value);
    }
    if (estimatedHeightCm.present) {
      map['estimated_height_cm'] = Variable<double>(estimatedHeightCm.value);
    }
    if (obesitySuspected.present) {
      map['obesity_suspected'] = Variable<bool>(obesitySuspected.value);
    }
    if (edemaPresent.present) {
      map['edema_present'] = Variable<bool>(edemaPresent.value);
    }
    if (ascitesPresent.present) {
      map['ascites_present'] = Variable<bool>(ascitesPresent.value);
    }
    if (dryWeightConfirmed.present) {
      map['dry_weight_confirmed'] = Variable<bool>(dryWeightConfirmed.value);
    }
    if (amputationsPresent.present) {
      map['amputations_present'] = Variable<bool>(amputationsPresent.value);
    }
    if (pregnancyPresent.present) {
      map['pregnancy_present'] = Variable<bool>(pregnancyPresent.value);
    }
    if (spinalIssues.present) {
      map['spinal_issues'] = Variable<bool>(spinalIssues.value);
    }
    if (ascitesSeverity.present) {
      map['ascites_severity'] = Variable<String>(ascitesSeverity.value);
    }
    if (amputationsJson.present) {
      map['amputations_json'] = Variable<String>(amputationsJson.value);
    }
    if (pendingActionsJson.present) {
      map['pending_actions_json'] = Variable<String>(pendingActionsJson.value);
    }
    if (traceJson.present) {
      map['trace_json'] = Variable<String>(traceJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeightAssessmentsCompanion(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('createdAt: $createdAt, ')
          ..write('weightRealKg: $weightRealKg, ')
          ..write('heightCm: $heightCm, ')
          ..write('heightMethod: $heightMethod, ')
          ..write('weightSource: $weightSource, ')
          ..write('confidence: $confidence, ')
          ..write('bmi: $bmi, ')
          ..write('idealWeightKg: $idealWeightKg, ')
          ..write('adjustedWeightKg: $adjustedWeightKg, ')
          ..write('workWeightKg: $workWeightKg, ')
          ..write('workWeightLabel: $workWeightLabel, ')
          ..write('proteinBaseKg: $proteinBaseKg, ')
          ..write('kcalBaseKg: $kcalBaseKg, ')
          ..write('overrideJustification: $overrideJustification, ')
          ..write('kneeHeightCm: $kneeHeightCm, ')
          ..write('ulnaLengthCm: $ulnaLengthCm, ')
          ..write('estimatedHeightCm: $estimatedHeightCm, ')
          ..write('obesitySuspected: $obesitySuspected, ')
          ..write('edemaPresent: $edemaPresent, ')
          ..write('ascitesPresent: $ascitesPresent, ')
          ..write('dryWeightConfirmed: $dryWeightConfirmed, ')
          ..write('amputationsPresent: $amputationsPresent, ')
          ..write('pregnancyPresent: $pregnancyPresent, ')
          ..write('spinalIssues: $spinalIssues, ')
          ..write('ascitesSeverity: $ascitesSeverity, ')
          ..write('amputationsJson: $amputationsJson, ')
          ..write('pendingActionsJson: $pendingActionsJson, ')
          ..write('traceJson: $traceJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NutritionalAssessmentsTable extends NutritionalAssessments
    with TableInfo<$NutritionalAssessmentsTable, NutritionalAssessment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NutritionalAssessmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _patientIdMeta =
      const VerificationMeta('patientId');
  @override
  late final GeneratedColumn<String> patientId = GeneratedColumn<String>(
      'patient_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES patients (id)'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _nutricScoreMeta =
      const VerificationMeta('nutricScore');
  @override
  late final GeneratedColumn<double> nutricScore = GeneratedColumn<double>(
      'nutric_score', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _nrsScoreMeta =
      const VerificationMeta('nrsScore');
  @override
  late final GeneratedColumn<double> nrsScore = GeneratedColumn<double>(
      'nrs_score', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _apacheScoreMeta =
      const VerificationMeta('apacheScore');
  @override
  late final GeneratedColumn<double> apacheScore = GeneratedColumn<double>(
      'apache_score', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _sofaScoreMeta =
      const VerificationMeta('sofaScore');
  @override
  late final GeneratedColumn<double> sofaScore = GeneratedColumn<double>(
      'sofa_score', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _pendingItemsJsonMeta =
      const VerificationMeta('pendingItemsJson');
  @override
  late final GeneratedColumn<String> pendingItemsJson = GeneratedColumn<String>(
      'pending_items_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _traceJsonMeta =
      const VerificationMeta('traceJson');
  @override
  late final GeneratedColumn<String> traceJson = GeneratedColumn<String>(
      'trace_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        patientId,
        createdAt,
        nutricScore,
        nrsScore,
        apacheScore,
        sofaScore,
        pendingItemsJson,
        notes,
        traceJson
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'nutritional_assessments';
  @override
  VerificationContext validateIntegrity(
      Insertable<NutritionalAssessment> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('patient_id')) {
      context.handle(_patientIdMeta,
          patientId.isAcceptableOrUnknown(data['patient_id']!, _patientIdMeta));
    } else if (isInserting) {
      context.missing(_patientIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('nutric_score')) {
      context.handle(
          _nutricScoreMeta,
          nutricScore.isAcceptableOrUnknown(
              data['nutric_score']!, _nutricScoreMeta));
    }
    if (data.containsKey('nrs_score')) {
      context.handle(_nrsScoreMeta,
          nrsScore.isAcceptableOrUnknown(data['nrs_score']!, _nrsScoreMeta));
    }
    if (data.containsKey('apache_score')) {
      context.handle(
          _apacheScoreMeta,
          apacheScore.isAcceptableOrUnknown(
              data['apache_score']!, _apacheScoreMeta));
    }
    if (data.containsKey('sofa_score')) {
      context.handle(_sofaScoreMeta,
          sofaScore.isAcceptableOrUnknown(data['sofa_score']!, _sofaScoreMeta));
    }
    if (data.containsKey('pending_items_json')) {
      context.handle(
          _pendingItemsJsonMeta,
          pendingItemsJson.isAcceptableOrUnknown(
              data['pending_items_json']!, _pendingItemsJsonMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('trace_json')) {
      context.handle(_traceJsonMeta,
          traceJson.isAcceptableOrUnknown(data['trace_json']!, _traceJsonMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NutritionalAssessment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NutritionalAssessment(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      patientId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}patient_id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      nutricScore: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}nutric_score']),
      nrsScore: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}nrs_score']),
      apacheScore: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}apache_score']),
      sofaScore: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}sofa_score']),
      pendingItemsJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}pending_items_json']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      traceJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}trace_json']),
    );
  }

  @override
  $NutritionalAssessmentsTable createAlias(String alias) {
    return $NutritionalAssessmentsTable(attachedDatabase, alias);
  }
}

class NutritionalAssessment extends DataClass
    implements Insertable<NutritionalAssessment> {
  final String id;
  final String patientId;
  final DateTime createdAt;
  final double? nutricScore;
  final double? nrsScore;
  final double? apacheScore;
  final double? sofaScore;
  final String? pendingItemsJson;
  final String? notes;
  final String? traceJson;
  const NutritionalAssessment(
      {required this.id,
      required this.patientId,
      required this.createdAt,
      this.nutricScore,
      this.nrsScore,
      this.apacheScore,
      this.sofaScore,
      this.pendingItemsJson,
      this.notes,
      this.traceJson});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['patient_id'] = Variable<String>(patientId);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || nutricScore != null) {
      map['nutric_score'] = Variable<double>(nutricScore);
    }
    if (!nullToAbsent || nrsScore != null) {
      map['nrs_score'] = Variable<double>(nrsScore);
    }
    if (!nullToAbsent || apacheScore != null) {
      map['apache_score'] = Variable<double>(apacheScore);
    }
    if (!nullToAbsent || sofaScore != null) {
      map['sofa_score'] = Variable<double>(sofaScore);
    }
    if (!nullToAbsent || pendingItemsJson != null) {
      map['pending_items_json'] = Variable<String>(pendingItemsJson);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || traceJson != null) {
      map['trace_json'] = Variable<String>(traceJson);
    }
    return map;
  }

  NutritionalAssessmentsCompanion toCompanion(bool nullToAbsent) {
    return NutritionalAssessmentsCompanion(
      id: Value(id),
      patientId: Value(patientId),
      createdAt: Value(createdAt),
      nutricScore: nutricScore == null && nullToAbsent
          ? const Value.absent()
          : Value(nutricScore),
      nrsScore: nrsScore == null && nullToAbsent
          ? const Value.absent()
          : Value(nrsScore),
      apacheScore: apacheScore == null && nullToAbsent
          ? const Value.absent()
          : Value(apacheScore),
      sofaScore: sofaScore == null && nullToAbsent
          ? const Value.absent()
          : Value(sofaScore),
      pendingItemsJson: pendingItemsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(pendingItemsJson),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      traceJson: traceJson == null && nullToAbsent
          ? const Value.absent()
          : Value(traceJson),
    );
  }

  factory NutritionalAssessment.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NutritionalAssessment(
      id: serializer.fromJson<String>(json['id']),
      patientId: serializer.fromJson<String>(json['patientId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      nutricScore: serializer.fromJson<double?>(json['nutricScore']),
      nrsScore: serializer.fromJson<double?>(json['nrsScore']),
      apacheScore: serializer.fromJson<double?>(json['apacheScore']),
      sofaScore: serializer.fromJson<double?>(json['sofaScore']),
      pendingItemsJson: serializer.fromJson<String?>(json['pendingItemsJson']),
      notes: serializer.fromJson<String?>(json['notes']),
      traceJson: serializer.fromJson<String?>(json['traceJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'patientId': serializer.toJson<String>(patientId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'nutricScore': serializer.toJson<double?>(nutricScore),
      'nrsScore': serializer.toJson<double?>(nrsScore),
      'apacheScore': serializer.toJson<double?>(apacheScore),
      'sofaScore': serializer.toJson<double?>(sofaScore),
      'pendingItemsJson': serializer.toJson<String?>(pendingItemsJson),
      'notes': serializer.toJson<String?>(notes),
      'traceJson': serializer.toJson<String?>(traceJson),
    };
  }

  NutritionalAssessment copyWith(
          {String? id,
          String? patientId,
          DateTime? createdAt,
          Value<double?> nutricScore = const Value.absent(),
          Value<double?> nrsScore = const Value.absent(),
          Value<double?> apacheScore = const Value.absent(),
          Value<double?> sofaScore = const Value.absent(),
          Value<String?> pendingItemsJson = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          Value<String?> traceJson = const Value.absent()}) =>
      NutritionalAssessment(
        id: id ?? this.id,
        patientId: patientId ?? this.patientId,
        createdAt: createdAt ?? this.createdAt,
        nutricScore: nutricScore.present ? nutricScore.value : this.nutricScore,
        nrsScore: nrsScore.present ? nrsScore.value : this.nrsScore,
        apacheScore: apacheScore.present ? apacheScore.value : this.apacheScore,
        sofaScore: sofaScore.present ? sofaScore.value : this.sofaScore,
        pendingItemsJson: pendingItemsJson.present
            ? pendingItemsJson.value
            : this.pendingItemsJson,
        notes: notes.present ? notes.value : this.notes,
        traceJson: traceJson.present ? traceJson.value : this.traceJson,
      );
  NutritionalAssessment copyWithCompanion(
      NutritionalAssessmentsCompanion data) {
    return NutritionalAssessment(
      id: data.id.present ? data.id.value : this.id,
      patientId: data.patientId.present ? data.patientId.value : this.patientId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      nutricScore:
          data.nutricScore.present ? data.nutricScore.value : this.nutricScore,
      nrsScore: data.nrsScore.present ? data.nrsScore.value : this.nrsScore,
      apacheScore:
          data.apacheScore.present ? data.apacheScore.value : this.apacheScore,
      sofaScore: data.sofaScore.present ? data.sofaScore.value : this.sofaScore,
      pendingItemsJson: data.pendingItemsJson.present
          ? data.pendingItemsJson.value
          : this.pendingItemsJson,
      notes: data.notes.present ? data.notes.value : this.notes,
      traceJson: data.traceJson.present ? data.traceJson.value : this.traceJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NutritionalAssessment(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('createdAt: $createdAt, ')
          ..write('nutricScore: $nutricScore, ')
          ..write('nrsScore: $nrsScore, ')
          ..write('apacheScore: $apacheScore, ')
          ..write('sofaScore: $sofaScore, ')
          ..write('pendingItemsJson: $pendingItemsJson, ')
          ..write('notes: $notes, ')
          ..write('traceJson: $traceJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, patientId, createdAt, nutricScore,
      nrsScore, apacheScore, sofaScore, pendingItemsJson, notes, traceJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NutritionalAssessment &&
          other.id == this.id &&
          other.patientId == this.patientId &&
          other.createdAt == this.createdAt &&
          other.nutricScore == this.nutricScore &&
          other.nrsScore == this.nrsScore &&
          other.apacheScore == this.apacheScore &&
          other.sofaScore == this.sofaScore &&
          other.pendingItemsJson == this.pendingItemsJson &&
          other.notes == this.notes &&
          other.traceJson == this.traceJson);
}

class NutritionalAssessmentsCompanion
    extends UpdateCompanion<NutritionalAssessment> {
  final Value<String> id;
  final Value<String> patientId;
  final Value<DateTime> createdAt;
  final Value<double?> nutricScore;
  final Value<double?> nrsScore;
  final Value<double?> apacheScore;
  final Value<double?> sofaScore;
  final Value<String?> pendingItemsJson;
  final Value<String?> notes;
  final Value<String?> traceJson;
  final Value<int> rowid;
  const NutritionalAssessmentsCompanion({
    this.id = const Value.absent(),
    this.patientId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.nutricScore = const Value.absent(),
    this.nrsScore = const Value.absent(),
    this.apacheScore = const Value.absent(),
    this.sofaScore = const Value.absent(),
    this.pendingItemsJson = const Value.absent(),
    this.notes = const Value.absent(),
    this.traceJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NutritionalAssessmentsCompanion.insert({
    required String id,
    required String patientId,
    this.createdAt = const Value.absent(),
    this.nutricScore = const Value.absent(),
    this.nrsScore = const Value.absent(),
    this.apacheScore = const Value.absent(),
    this.sofaScore = const Value.absent(),
    this.pendingItemsJson = const Value.absent(),
    this.notes = const Value.absent(),
    this.traceJson = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        patientId = Value(patientId);
  static Insertable<NutritionalAssessment> custom({
    Expression<String>? id,
    Expression<String>? patientId,
    Expression<DateTime>? createdAt,
    Expression<double>? nutricScore,
    Expression<double>? nrsScore,
    Expression<double>? apacheScore,
    Expression<double>? sofaScore,
    Expression<String>? pendingItemsJson,
    Expression<String>? notes,
    Expression<String>? traceJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (patientId != null) 'patient_id': patientId,
      if (createdAt != null) 'created_at': createdAt,
      if (nutricScore != null) 'nutric_score': nutricScore,
      if (nrsScore != null) 'nrs_score': nrsScore,
      if (apacheScore != null) 'apache_score': apacheScore,
      if (sofaScore != null) 'sofa_score': sofaScore,
      if (pendingItemsJson != null) 'pending_items_json': pendingItemsJson,
      if (notes != null) 'notes': notes,
      if (traceJson != null) 'trace_json': traceJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NutritionalAssessmentsCompanion copyWith(
      {Value<String>? id,
      Value<String>? patientId,
      Value<DateTime>? createdAt,
      Value<double?>? nutricScore,
      Value<double?>? nrsScore,
      Value<double?>? apacheScore,
      Value<double?>? sofaScore,
      Value<String?>? pendingItemsJson,
      Value<String?>? notes,
      Value<String?>? traceJson,
      Value<int>? rowid}) {
    return NutritionalAssessmentsCompanion(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      createdAt: createdAt ?? this.createdAt,
      nutricScore: nutricScore ?? this.nutricScore,
      nrsScore: nrsScore ?? this.nrsScore,
      apacheScore: apacheScore ?? this.apacheScore,
      sofaScore: sofaScore ?? this.sofaScore,
      pendingItemsJson: pendingItemsJson ?? this.pendingItemsJson,
      notes: notes ?? this.notes,
      traceJson: traceJson ?? this.traceJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (patientId.present) {
      map['patient_id'] = Variable<String>(patientId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (nutricScore.present) {
      map['nutric_score'] = Variable<double>(nutricScore.value);
    }
    if (nrsScore.present) {
      map['nrs_score'] = Variable<double>(nrsScore.value);
    }
    if (apacheScore.present) {
      map['apache_score'] = Variable<double>(apacheScore.value);
    }
    if (sofaScore.present) {
      map['sofa_score'] = Variable<double>(sofaScore.value);
    }
    if (pendingItemsJson.present) {
      map['pending_items_json'] = Variable<String>(pendingItemsJson.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (traceJson.present) {
      map['trace_json'] = Variable<String>(traceJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NutritionalAssessmentsCompanion(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('createdAt: $createdAt, ')
          ..write('nutricScore: $nutricScore, ')
          ..write('nrsScore: $nrsScore, ')
          ..write('apacheScore: $apacheScore, ')
          ..write('sofaScore: $sofaScore, ')
          ..write('pendingItemsJson: $pendingItemsJson, ')
          ..write('notes: $notes, ')
          ..write('traceJson: $traceJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EnergyPlansTable extends EnergyPlans
    with TableInfo<$EnergyPlansTable, EnergyPlan> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EnergyPlansTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _patientIdMeta =
      const VerificationMeta('patientId');
  @override
  late final GeneratedColumn<String> patientId = GeneratedColumn<String>(
      'patient_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES patients (id)'));
  static const VerificationMeta _snapshotJsonMeta =
      const VerificationMeta('snapshotJson');
  @override
  late final GeneratedColumn<String> snapshotJson = GeneratedColumn<String>(
      'snapshot_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, patientId, snapshotJson, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'energy_plans';
  @override
  VerificationContext validateIntegrity(Insertable<EnergyPlan> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('patient_id')) {
      context.handle(_patientIdMeta,
          patientId.isAcceptableOrUnknown(data['patient_id']!, _patientIdMeta));
    } else if (isInserting) {
      context.missing(_patientIdMeta);
    }
    if (data.containsKey('snapshot_json')) {
      context.handle(
          _snapshotJsonMeta,
          snapshotJson.isAcceptableOrUnknown(
              data['snapshot_json']!, _snapshotJsonMeta));
    } else if (isInserting) {
      context.missing(_snapshotJsonMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EnergyPlan map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EnergyPlan(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      patientId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}patient_id'])!,
      snapshotJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}snapshot_json'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $EnergyPlansTable createAlias(String alias) {
    return $EnergyPlansTable(attachedDatabase, alias);
  }
}

class EnergyPlan extends DataClass implements Insertable<EnergyPlan> {
  final String id;
  final String patientId;
  final String snapshotJson;
  final DateTime createdAt;
  const EnergyPlan(
      {required this.id,
      required this.patientId,
      required this.snapshotJson,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['patient_id'] = Variable<String>(patientId);
    map['snapshot_json'] = Variable<String>(snapshotJson);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  EnergyPlansCompanion toCompanion(bool nullToAbsent) {
    return EnergyPlansCompanion(
      id: Value(id),
      patientId: Value(patientId),
      snapshotJson: Value(snapshotJson),
      createdAt: Value(createdAt),
    );
  }

  factory EnergyPlan.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EnergyPlan(
      id: serializer.fromJson<String>(json['id']),
      patientId: serializer.fromJson<String>(json['patientId']),
      snapshotJson: serializer.fromJson<String>(json['snapshotJson']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'patientId': serializer.toJson<String>(patientId),
      'snapshotJson': serializer.toJson<String>(snapshotJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  EnergyPlan copyWith(
          {String? id,
          String? patientId,
          String? snapshotJson,
          DateTime? createdAt}) =>
      EnergyPlan(
        id: id ?? this.id,
        patientId: patientId ?? this.patientId,
        snapshotJson: snapshotJson ?? this.snapshotJson,
        createdAt: createdAt ?? this.createdAt,
      );
  EnergyPlan copyWithCompanion(EnergyPlansCompanion data) {
    return EnergyPlan(
      id: data.id.present ? data.id.value : this.id,
      patientId: data.patientId.present ? data.patientId.value : this.patientId,
      snapshotJson: data.snapshotJson.present
          ? data.snapshotJson.value
          : this.snapshotJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EnergyPlan(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('snapshotJson: $snapshotJson, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, patientId, snapshotJson, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EnergyPlan &&
          other.id == this.id &&
          other.patientId == this.patientId &&
          other.snapshotJson == this.snapshotJson &&
          other.createdAt == this.createdAt);
}

class EnergyPlansCompanion extends UpdateCompanion<EnergyPlan> {
  final Value<String> id;
  final Value<String> patientId;
  final Value<String> snapshotJson;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const EnergyPlansCompanion({
    this.id = const Value.absent(),
    this.patientId = const Value.absent(),
    this.snapshotJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EnergyPlansCompanion.insert({
    required String id,
    required String patientId,
    required String snapshotJson,
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        patientId = Value(patientId),
        snapshotJson = Value(snapshotJson);
  static Insertable<EnergyPlan> custom({
    Expression<String>? id,
    Expression<String>? patientId,
    Expression<String>? snapshotJson,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (patientId != null) 'patient_id': patientId,
      if (snapshotJson != null) 'snapshot_json': snapshotJson,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EnergyPlansCompanion copyWith(
      {Value<String>? id,
      Value<String>? patientId,
      Value<String>? snapshotJson,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return EnergyPlansCompanion(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      snapshotJson: snapshotJson ?? this.snapshotJson,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (patientId.present) {
      map['patient_id'] = Variable<String>(patientId.value);
    }
    if (snapshotJson.present) {
      map['snapshot_json'] = Variable<String>(snapshotJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EnergyPlansCompanion(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('snapshotJson: $snapshotJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PatientsTable patients = $PatientsTable(this);
  late final $MonitoringEntriesTable monitoringEntries =
      $MonitoringEntriesTable(this);
  late final $NutritionTargetsTable nutritionTargets =
      $NutritionTargetsTable(this);
  late final $AlertsTable alerts = $AlertsTable(this);
  late final $WeightAssessmentsTable weightAssessments =
      $WeightAssessmentsTable(this);
  late final $NutritionalAssessmentsTable nutritionalAssessments =
      $NutritionalAssessmentsTable(this);
  late final $EnergyPlansTable energyPlans = $EnergyPlansTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        patients,
        monitoringEntries,
        nutritionTargets,
        alerts,
        weightAssessments,
        nutritionalAssessments,
        energyPlans
      ];
}

typedef $$PatientsTableCreateCompanionBuilder = PatientsCompanion Function({
  required String id,
  required String fullName,
  required int age,
  required String sex,
  required String diagnosis,
  required double weightKg,
  required double heightCm,
  Value<String?> bedNumber,
  Value<String?> supportType,
  Value<String?> notes,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$PatientsTableUpdateCompanionBuilder = PatientsCompanion Function({
  Value<String> id,
  Value<String> fullName,
  Value<int> age,
  Value<String> sex,
  Value<String> diagnosis,
  Value<double> weightKg,
  Value<double> heightCm,
  Value<String?> bedNumber,
  Value<String?> supportType,
  Value<String?> notes,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$PatientsTableReferences
    extends BaseReferences<_$AppDatabase, $PatientsTable, Patient> {
  $$PatientsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MonitoringEntriesTable, List<MonitoringEntry>>
      _monitoringEntriesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.monitoringEntries,
              aliasName: $_aliasNameGenerator(
                  db.patients.id, db.monitoringEntries.patientId));

  $$MonitoringEntriesTableProcessedTableManager get monitoringEntriesRefs {
    final manager =
        $$MonitoringEntriesTableTableManager($_db, $_db.monitoringEntries)
            .filter((f) => f.patientId.id($_item.id));

    final cache =
        $_typedResult.readTableOrNull(_monitoringEntriesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$NutritionTargetsTable, List<NutritionTarget>>
      _nutritionTargetsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.nutritionTargets,
              aliasName: $_aliasNameGenerator(
                  db.patients.id, db.nutritionTargets.patientId));

  $$NutritionTargetsTableProcessedTableManager get nutritionTargetsRefs {
    final manager =
        $$NutritionTargetsTableTableManager($_db, $_db.nutritionTargets)
            .filter((f) => f.patientId.id($_item.id));

    final cache =
        $_typedResult.readTableOrNull(_nutritionTargetsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$AlertsTable, List<Alert>> _alertsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.alerts,
          aliasName: $_aliasNameGenerator(db.patients.id, db.alerts.patientId));

  $$AlertsTableProcessedTableManager get alertsRefs {
    final manager = $$AlertsTableTableManager($_db, $_db.alerts)
        .filter((f) => f.patientId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_alertsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$WeightAssessmentsTable, List<WeightAssessment>>
      _weightAssessmentsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.weightAssessments,
              aliasName: $_aliasNameGenerator(
                  db.patients.id, db.weightAssessments.patientId));

  $$WeightAssessmentsTableProcessedTableManager get weightAssessmentsRefs {
    final manager =
        $$WeightAssessmentsTableTableManager($_db, $_db.weightAssessments)
            .filter((f) => f.patientId.id($_item.id));

    final cache =
        $_typedResult.readTableOrNull(_weightAssessmentsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$NutritionalAssessmentsTable,
      List<NutritionalAssessment>> _nutritionalAssessmentsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.nutritionalAssessments,
          aliasName: $_aliasNameGenerator(
              db.patients.id, db.nutritionalAssessments.patientId));

  $$NutritionalAssessmentsTableProcessedTableManager
      get nutritionalAssessmentsRefs {
    final manager = $$NutritionalAssessmentsTableTableManager(
            $_db, $_db.nutritionalAssessments)
        .filter((f) => f.patientId.id($_item.id));

    final cache =
        $_typedResult.readTableOrNull(_nutritionalAssessmentsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$EnergyPlansTable, List<EnergyPlan>>
      _energyPlansRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.energyPlans,
          aliasName:
              $_aliasNameGenerator(db.patients.id, db.energyPlans.patientId));

  $$EnergyPlansTableProcessedTableManager get energyPlansRefs {
    final manager = $$EnergyPlansTableTableManager($_db, $_db.energyPlans)
        .filter((f) => f.patientId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_energyPlansRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$PatientsTableFilterComposer
    extends Composer<_$AppDatabase, $PatientsTable> {
  $$PatientsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fullName => $composableBuilder(
      column: $table.fullName, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get age => $composableBuilder(
      column: $table.age, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sex => $composableBuilder(
      column: $table.sex, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get diagnosis => $composableBuilder(
      column: $table.diagnosis, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get weightKg => $composableBuilder(
      column: $table.weightKg, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get heightCm => $composableBuilder(
      column: $table.heightCm, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get bedNumber => $composableBuilder(
      column: $table.bedNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get supportType => $composableBuilder(
      column: $table.supportType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> monitoringEntriesRefs(
      Expression<bool> Function($$MonitoringEntriesTableFilterComposer f) f) {
    final $$MonitoringEntriesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.monitoringEntries,
        getReferencedColumn: (t) => t.patientId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MonitoringEntriesTableFilterComposer(
              $db: $db,
              $table: $db.monitoringEntries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> nutritionTargetsRefs(
      Expression<bool> Function($$NutritionTargetsTableFilterComposer f) f) {
    final $$NutritionTargetsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.nutritionTargets,
        getReferencedColumn: (t) => t.patientId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$NutritionTargetsTableFilterComposer(
              $db: $db,
              $table: $db.nutritionTargets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> alertsRefs(
      Expression<bool> Function($$AlertsTableFilterComposer f) f) {
    final $$AlertsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.alerts,
        getReferencedColumn: (t) => t.patientId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AlertsTableFilterComposer(
              $db: $db,
              $table: $db.alerts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> weightAssessmentsRefs(
      Expression<bool> Function($$WeightAssessmentsTableFilterComposer f) f) {
    final $$WeightAssessmentsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.weightAssessments,
        getReferencedColumn: (t) => t.patientId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WeightAssessmentsTableFilterComposer(
              $db: $db,
              $table: $db.weightAssessments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> nutritionalAssessmentsRefs(
      Expression<bool> Function($$NutritionalAssessmentsTableFilterComposer f)
          f) {
    final $$NutritionalAssessmentsTableFilterComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.nutritionalAssessments,
            getReferencedColumn: (t) => t.patientId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$NutritionalAssessmentsTableFilterComposer(
                  $db: $db,
                  $table: $db.nutritionalAssessments,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<bool> energyPlansRefs(
      Expression<bool> Function($$EnergyPlansTableFilterComposer f) f) {
    final $$EnergyPlansTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.energyPlans,
        getReferencedColumn: (t) => t.patientId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EnergyPlansTableFilterComposer(
              $db: $db,
              $table: $db.energyPlans,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$PatientsTableOrderingComposer
    extends Composer<_$AppDatabase, $PatientsTable> {
  $$PatientsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fullName => $composableBuilder(
      column: $table.fullName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get age => $composableBuilder(
      column: $table.age, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sex => $composableBuilder(
      column: $table.sex, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get diagnosis => $composableBuilder(
      column: $table.diagnosis, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get weightKg => $composableBuilder(
      column: $table.weightKg, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get heightCm => $composableBuilder(
      column: $table.heightCm, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get bedNumber => $composableBuilder(
      column: $table.bedNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get supportType => $composableBuilder(
      column: $table.supportType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$PatientsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PatientsTable> {
  $$PatientsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get fullName =>
      $composableBuilder(column: $table.fullName, builder: (column) => column);

  GeneratedColumn<int> get age =>
      $composableBuilder(column: $table.age, builder: (column) => column);

  GeneratedColumn<String> get sex =>
      $composableBuilder(column: $table.sex, builder: (column) => column);

  GeneratedColumn<String> get diagnosis =>
      $composableBuilder(column: $table.diagnosis, builder: (column) => column);

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<double> get heightCm =>
      $composableBuilder(column: $table.heightCm, builder: (column) => column);

  GeneratedColumn<String> get bedNumber =>
      $composableBuilder(column: $table.bedNumber, builder: (column) => column);

  GeneratedColumn<String> get supportType => $composableBuilder(
      column: $table.supportType, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> monitoringEntriesRefs<T extends Object>(
      Expression<T> Function($$MonitoringEntriesTableAnnotationComposer a) f) {
    final $$MonitoringEntriesTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.monitoringEntries,
            getReferencedColumn: (t) => t.patientId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$MonitoringEntriesTableAnnotationComposer(
                  $db: $db,
                  $table: $db.monitoringEntries,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> nutritionTargetsRefs<T extends Object>(
      Expression<T> Function($$NutritionTargetsTableAnnotationComposer a) f) {
    final $$NutritionTargetsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.nutritionTargets,
        getReferencedColumn: (t) => t.patientId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$NutritionTargetsTableAnnotationComposer(
              $db: $db,
              $table: $db.nutritionTargets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> alertsRefs<T extends Object>(
      Expression<T> Function($$AlertsTableAnnotationComposer a) f) {
    final $$AlertsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.alerts,
        getReferencedColumn: (t) => t.patientId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AlertsTableAnnotationComposer(
              $db: $db,
              $table: $db.alerts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> weightAssessmentsRefs<T extends Object>(
      Expression<T> Function($$WeightAssessmentsTableAnnotationComposer a) f) {
    final $$WeightAssessmentsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.weightAssessments,
            getReferencedColumn: (t) => t.patientId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$WeightAssessmentsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.weightAssessments,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> nutritionalAssessmentsRefs<T extends Object>(
      Expression<T> Function($$NutritionalAssessmentsTableAnnotationComposer a)
          f) {
    final $$NutritionalAssessmentsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.nutritionalAssessments,
            getReferencedColumn: (t) => t.patientId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$NutritionalAssessmentsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.nutritionalAssessments,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> energyPlansRefs<T extends Object>(
      Expression<T> Function($$EnergyPlansTableAnnotationComposer a) f) {
    final $$EnergyPlansTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.energyPlans,
        getReferencedColumn: (t) => t.patientId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EnergyPlansTableAnnotationComposer(
              $db: $db,
              $table: $db.energyPlans,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$PatientsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PatientsTable,
    Patient,
    $$PatientsTableFilterComposer,
    $$PatientsTableOrderingComposer,
    $$PatientsTableAnnotationComposer,
    $$PatientsTableCreateCompanionBuilder,
    $$PatientsTableUpdateCompanionBuilder,
    (Patient, $$PatientsTableReferences),
    Patient,
    PrefetchHooks Function(
        {bool monitoringEntriesRefs,
        bool nutritionTargetsRefs,
        bool alertsRefs,
        bool weightAssessmentsRefs,
        bool nutritionalAssessmentsRefs,
        bool energyPlansRefs})> {
  $$PatientsTableTableManager(_$AppDatabase db, $PatientsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PatientsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PatientsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PatientsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> fullName = const Value.absent(),
            Value<int> age = const Value.absent(),
            Value<String> sex = const Value.absent(),
            Value<String> diagnosis = const Value.absent(),
            Value<double> weightKg = const Value.absent(),
            Value<double> heightCm = const Value.absent(),
            Value<String?> bedNumber = const Value.absent(),
            Value<String?> supportType = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PatientsCompanion(
            id: id,
            fullName: fullName,
            age: age,
            sex: sex,
            diagnosis: diagnosis,
            weightKg: weightKg,
            heightCm: heightCm,
            bedNumber: bedNumber,
            supportType: supportType,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String fullName,
            required int age,
            required String sex,
            required String diagnosis,
            required double weightKg,
            required double heightCm,
            Value<String?> bedNumber = const Value.absent(),
            Value<String?> supportType = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PatientsCompanion.insert(
            id: id,
            fullName: fullName,
            age: age,
            sex: sex,
            diagnosis: diagnosis,
            weightKg: weightKg,
            heightCm: heightCm,
            bedNumber: bedNumber,
            supportType: supportType,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$PatientsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {monitoringEntriesRefs = false,
              nutritionTargetsRefs = false,
              alertsRefs = false,
              weightAssessmentsRefs = false,
              nutritionalAssessmentsRefs = false,
              energyPlansRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (monitoringEntriesRefs) db.monitoringEntries,
                if (nutritionTargetsRefs) db.nutritionTargets,
                if (alertsRefs) db.alerts,
                if (weightAssessmentsRefs) db.weightAssessments,
                if (nutritionalAssessmentsRefs) db.nutritionalAssessments,
                if (energyPlansRefs) db.energyPlans
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (monitoringEntriesRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$PatientsTableReferences
                            ._monitoringEntriesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PatientsTableReferences(db, table, p0)
                                .monitoringEntriesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.patientId == item.id),
                        typedResults: items),
                  if (nutritionTargetsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$PatientsTableReferences
                            ._nutritionTargetsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PatientsTableReferences(db, table, p0)
                                .nutritionTargetsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.patientId == item.id),
                        typedResults: items),
                  if (alertsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable:
                            $$PatientsTableReferences._alertsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PatientsTableReferences(db, table, p0).alertsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.patientId == item.id),
                        typedResults: items),
                  if (weightAssessmentsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$PatientsTableReferences
                            ._weightAssessmentsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PatientsTableReferences(db, table, p0)
                                .weightAssessmentsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.patientId == item.id),
                        typedResults: items),
                  if (nutritionalAssessmentsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$PatientsTableReferences
                            ._nutritionalAssessmentsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PatientsTableReferences(db, table, p0)
                                .nutritionalAssessmentsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.patientId == item.id),
                        typedResults: items),
                  if (energyPlansRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable:
                            $$PatientsTableReferences._energyPlansRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PatientsTableReferences(db, table, p0)
                                .energyPlansRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.patientId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$PatientsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PatientsTable,
    Patient,
    $$PatientsTableFilterComposer,
    $$PatientsTableOrderingComposer,
    $$PatientsTableAnnotationComposer,
    $$PatientsTableCreateCompanionBuilder,
    $$PatientsTableUpdateCompanionBuilder,
    (Patient, $$PatientsTableReferences),
    Patient,
    PrefetchHooks Function(
        {bool monitoringEntriesRefs,
        bool nutritionTargetsRefs,
        bool alertsRefs,
        bool weightAssessmentsRefs,
        bool nutritionalAssessmentsRefs,
        bool energyPlansRefs})>;
typedef $$MonitoringEntriesTableCreateCompanionBuilder
    = MonitoringEntriesCompanion Function({
  required String id,
  required String patientId,
  required DateTime date,
  Value<double?> weightKg,
  Value<double?> fluidBalanceMl,
  Value<double?> caloricIntakeKcal,
  Value<double?> proteinIntakeGrams,
  Value<double?> glucoseMin,
  Value<double?> glucoseMax,
  Value<double?> triglyceridesMgDl,
  Value<double?> creatinineMgDl,
  Value<double?> ast,
  Value<double?> alt,
  Value<double?> cReactiveProtein,
  Value<double?> procalcitonin,
  Value<String?> notes,
  Value<int> rowid,
});
typedef $$MonitoringEntriesTableUpdateCompanionBuilder
    = MonitoringEntriesCompanion Function({
  Value<String> id,
  Value<String> patientId,
  Value<DateTime> date,
  Value<double?> weightKg,
  Value<double?> fluidBalanceMl,
  Value<double?> caloricIntakeKcal,
  Value<double?> proteinIntakeGrams,
  Value<double?> glucoseMin,
  Value<double?> glucoseMax,
  Value<double?> triglyceridesMgDl,
  Value<double?> creatinineMgDl,
  Value<double?> ast,
  Value<double?> alt,
  Value<double?> cReactiveProtein,
  Value<double?> procalcitonin,
  Value<String?> notes,
  Value<int> rowid,
});

final class $$MonitoringEntriesTableReferences extends BaseReferences<
    _$AppDatabase, $MonitoringEntriesTable, MonitoringEntry> {
  $$MonitoringEntriesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $PatientsTable _patientIdTable(_$AppDatabase db) =>
      db.patients.createAlias(
          $_aliasNameGenerator(db.monitoringEntries.patientId, db.patients.id));

  $$PatientsTableProcessedTableManager? get patientId {
    if ($_item.patientId == null) return null;
    final manager = $$PatientsTableTableManager($_db, $_db.patients)
        .filter((f) => f.id($_item.patientId!));
    final item = $_typedResult.readTableOrNull(_patientIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$MonitoringEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $MonitoringEntriesTable> {
  $$MonitoringEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get weightKg => $composableBuilder(
      column: $table.weightKg, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get fluidBalanceMl => $composableBuilder(
      column: $table.fluidBalanceMl,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get caloricIntakeKcal => $composableBuilder(
      column: $table.caloricIntakeKcal,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get proteinIntakeGrams => $composableBuilder(
      column: $table.proteinIntakeGrams,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get glucoseMin => $composableBuilder(
      column: $table.glucoseMin, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get glucoseMax => $composableBuilder(
      column: $table.glucoseMax, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get triglyceridesMgDl => $composableBuilder(
      column: $table.triglyceridesMgDl,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get creatinineMgDl => $composableBuilder(
      column: $table.creatinineMgDl,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get ast => $composableBuilder(
      column: $table.ast, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get alt => $composableBuilder(
      column: $table.alt, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get cReactiveProtein => $composableBuilder(
      column: $table.cReactiveProtein,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get procalcitonin => $composableBuilder(
      column: $table.procalcitonin, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  $$PatientsTableFilterComposer get patientId {
    final $$PatientsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.patientId,
        referencedTable: $db.patients,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PatientsTableFilterComposer(
              $db: $db,
              $table: $db.patients,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MonitoringEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $MonitoringEntriesTable> {
  $$MonitoringEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get weightKg => $composableBuilder(
      column: $table.weightKg, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get fluidBalanceMl => $composableBuilder(
      column: $table.fluidBalanceMl,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get caloricIntakeKcal => $composableBuilder(
      column: $table.caloricIntakeKcal,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get proteinIntakeGrams => $composableBuilder(
      column: $table.proteinIntakeGrams,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get glucoseMin => $composableBuilder(
      column: $table.glucoseMin, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get glucoseMax => $composableBuilder(
      column: $table.glucoseMax, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get triglyceridesMgDl => $composableBuilder(
      column: $table.triglyceridesMgDl,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get creatinineMgDl => $composableBuilder(
      column: $table.creatinineMgDl,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get ast => $composableBuilder(
      column: $table.ast, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get alt => $composableBuilder(
      column: $table.alt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get cReactiveProtein => $composableBuilder(
      column: $table.cReactiveProtein,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get procalcitonin => $composableBuilder(
      column: $table.procalcitonin,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  $$PatientsTableOrderingComposer get patientId {
    final $$PatientsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.patientId,
        referencedTable: $db.patients,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PatientsTableOrderingComposer(
              $db: $db,
              $table: $db.patients,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MonitoringEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MonitoringEntriesTable> {
  $$MonitoringEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<double> get fluidBalanceMl => $composableBuilder(
      column: $table.fluidBalanceMl, builder: (column) => column);

  GeneratedColumn<double> get caloricIntakeKcal => $composableBuilder(
      column: $table.caloricIntakeKcal, builder: (column) => column);

  GeneratedColumn<double> get proteinIntakeGrams => $composableBuilder(
      column: $table.proteinIntakeGrams, builder: (column) => column);

  GeneratedColumn<double> get glucoseMin => $composableBuilder(
      column: $table.glucoseMin, builder: (column) => column);

  GeneratedColumn<double> get glucoseMax => $composableBuilder(
      column: $table.glucoseMax, builder: (column) => column);

  GeneratedColumn<double> get triglyceridesMgDl => $composableBuilder(
      column: $table.triglyceridesMgDl, builder: (column) => column);

  GeneratedColumn<double> get creatinineMgDl => $composableBuilder(
      column: $table.creatinineMgDl, builder: (column) => column);

  GeneratedColumn<double> get ast =>
      $composableBuilder(column: $table.ast, builder: (column) => column);

  GeneratedColumn<double> get alt =>
      $composableBuilder(column: $table.alt, builder: (column) => column);

  GeneratedColumn<double> get cReactiveProtein => $composableBuilder(
      column: $table.cReactiveProtein, builder: (column) => column);

  GeneratedColumn<double> get procalcitonin => $composableBuilder(
      column: $table.procalcitonin, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$PatientsTableAnnotationComposer get patientId {
    final $$PatientsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.patientId,
        referencedTable: $db.patients,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PatientsTableAnnotationComposer(
              $db: $db,
              $table: $db.patients,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MonitoringEntriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MonitoringEntriesTable,
    MonitoringEntry,
    $$MonitoringEntriesTableFilterComposer,
    $$MonitoringEntriesTableOrderingComposer,
    $$MonitoringEntriesTableAnnotationComposer,
    $$MonitoringEntriesTableCreateCompanionBuilder,
    $$MonitoringEntriesTableUpdateCompanionBuilder,
    (MonitoringEntry, $$MonitoringEntriesTableReferences),
    MonitoringEntry,
    PrefetchHooks Function({bool patientId})> {
  $$MonitoringEntriesTableTableManager(
      _$AppDatabase db, $MonitoringEntriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MonitoringEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MonitoringEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MonitoringEntriesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> patientId = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<double?> weightKg = const Value.absent(),
            Value<double?> fluidBalanceMl = const Value.absent(),
            Value<double?> caloricIntakeKcal = const Value.absent(),
            Value<double?> proteinIntakeGrams = const Value.absent(),
            Value<double?> glucoseMin = const Value.absent(),
            Value<double?> glucoseMax = const Value.absent(),
            Value<double?> triglyceridesMgDl = const Value.absent(),
            Value<double?> creatinineMgDl = const Value.absent(),
            Value<double?> ast = const Value.absent(),
            Value<double?> alt = const Value.absent(),
            Value<double?> cReactiveProtein = const Value.absent(),
            Value<double?> procalcitonin = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MonitoringEntriesCompanion(
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
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String patientId,
            required DateTime date,
            Value<double?> weightKg = const Value.absent(),
            Value<double?> fluidBalanceMl = const Value.absent(),
            Value<double?> caloricIntakeKcal = const Value.absent(),
            Value<double?> proteinIntakeGrams = const Value.absent(),
            Value<double?> glucoseMin = const Value.absent(),
            Value<double?> glucoseMax = const Value.absent(),
            Value<double?> triglyceridesMgDl = const Value.absent(),
            Value<double?> creatinineMgDl = const Value.absent(),
            Value<double?> ast = const Value.absent(),
            Value<double?> alt = const Value.absent(),
            Value<double?> cReactiveProtein = const Value.absent(),
            Value<double?> procalcitonin = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MonitoringEntriesCompanion.insert(
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
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$MonitoringEntriesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({patientId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (patientId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.patientId,
                    referencedTable:
                        $$MonitoringEntriesTableReferences._patientIdTable(db),
                    referencedColumn: $$MonitoringEntriesTableReferences
                        ._patientIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$MonitoringEntriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MonitoringEntriesTable,
    MonitoringEntry,
    $$MonitoringEntriesTableFilterComposer,
    $$MonitoringEntriesTableOrderingComposer,
    $$MonitoringEntriesTableAnnotationComposer,
    $$MonitoringEntriesTableCreateCompanionBuilder,
    $$MonitoringEntriesTableUpdateCompanionBuilder,
    (MonitoringEntry, $$MonitoringEntriesTableReferences),
    MonitoringEntry,
    PrefetchHooks Function({bool patientId})>;
typedef $$NutritionTargetsTableCreateCompanionBuilder
    = NutritionTargetsCompanion Function({
  required String id,
  required String patientId,
  required String method,
  required double caloriesPerDay,
  required double proteinGrams,
  Value<String?> notes,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$NutritionTargetsTableUpdateCompanionBuilder
    = NutritionTargetsCompanion Function({
  Value<String> id,
  Value<String> patientId,
  Value<String> method,
  Value<double> caloriesPerDay,
  Value<double> proteinGrams,
  Value<String?> notes,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$NutritionTargetsTableReferences extends BaseReferences<
    _$AppDatabase, $NutritionTargetsTable, NutritionTarget> {
  $$NutritionTargetsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $PatientsTable _patientIdTable(_$AppDatabase db) =>
      db.patients.createAlias(
          $_aliasNameGenerator(db.nutritionTargets.patientId, db.patients.id));

  $$PatientsTableProcessedTableManager? get patientId {
    if ($_item.patientId == null) return null;
    final manager = $$PatientsTableTableManager($_db, $_db.patients)
        .filter((f) => f.id($_item.patientId!));
    final item = $_typedResult.readTableOrNull(_patientIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$NutritionTargetsTableFilterComposer
    extends Composer<_$AppDatabase, $NutritionTargetsTable> {
  $$NutritionTargetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get method => $composableBuilder(
      column: $table.method, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get caloriesPerDay => $composableBuilder(
      column: $table.caloriesPerDay,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get proteinGrams => $composableBuilder(
      column: $table.proteinGrams, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$PatientsTableFilterComposer get patientId {
    final $$PatientsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.patientId,
        referencedTable: $db.patients,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PatientsTableFilterComposer(
              $db: $db,
              $table: $db.patients,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$NutritionTargetsTableOrderingComposer
    extends Composer<_$AppDatabase, $NutritionTargetsTable> {
  $$NutritionTargetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get method => $composableBuilder(
      column: $table.method, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get caloriesPerDay => $composableBuilder(
      column: $table.caloriesPerDay,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get proteinGrams => $composableBuilder(
      column: $table.proteinGrams,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$PatientsTableOrderingComposer get patientId {
    final $$PatientsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.patientId,
        referencedTable: $db.patients,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PatientsTableOrderingComposer(
              $db: $db,
              $table: $db.patients,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$NutritionTargetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $NutritionTargetsTable> {
  $$NutritionTargetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get method =>
      $composableBuilder(column: $table.method, builder: (column) => column);

  GeneratedColumn<double> get caloriesPerDay => $composableBuilder(
      column: $table.caloriesPerDay, builder: (column) => column);

  GeneratedColumn<double> get proteinGrams => $composableBuilder(
      column: $table.proteinGrams, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$PatientsTableAnnotationComposer get patientId {
    final $$PatientsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.patientId,
        referencedTable: $db.patients,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PatientsTableAnnotationComposer(
              $db: $db,
              $table: $db.patients,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$NutritionTargetsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $NutritionTargetsTable,
    NutritionTarget,
    $$NutritionTargetsTableFilterComposer,
    $$NutritionTargetsTableOrderingComposer,
    $$NutritionTargetsTableAnnotationComposer,
    $$NutritionTargetsTableCreateCompanionBuilder,
    $$NutritionTargetsTableUpdateCompanionBuilder,
    (NutritionTarget, $$NutritionTargetsTableReferences),
    NutritionTarget,
    PrefetchHooks Function({bool patientId})> {
  $$NutritionTargetsTableTableManager(
      _$AppDatabase db, $NutritionTargetsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NutritionTargetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NutritionTargetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NutritionTargetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> patientId = const Value.absent(),
            Value<String> method = const Value.absent(),
            Value<double> caloriesPerDay = const Value.absent(),
            Value<double> proteinGrams = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              NutritionTargetsCompanion(
            id: id,
            patientId: patientId,
            method: method,
            caloriesPerDay: caloriesPerDay,
            proteinGrams: proteinGrams,
            notes: notes,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String patientId,
            required String method,
            required double caloriesPerDay,
            required double proteinGrams,
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              NutritionTargetsCompanion.insert(
            id: id,
            patientId: patientId,
            method: method,
            caloriesPerDay: caloriesPerDay,
            proteinGrams: proteinGrams,
            notes: notes,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$NutritionTargetsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({patientId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (patientId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.patientId,
                    referencedTable:
                        $$NutritionTargetsTableReferences._patientIdTable(db),
                    referencedColumn: $$NutritionTargetsTableReferences
                        ._patientIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$NutritionTargetsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $NutritionTargetsTable,
    NutritionTarget,
    $$NutritionTargetsTableFilterComposer,
    $$NutritionTargetsTableOrderingComposer,
    $$NutritionTargetsTableAnnotationComposer,
    $$NutritionTargetsTableCreateCompanionBuilder,
    $$NutritionTargetsTableUpdateCompanionBuilder,
    (NutritionTarget, $$NutritionTargetsTableReferences),
    NutritionTarget,
    PrefetchHooks Function({bool patientId})>;
typedef $$AlertsTableCreateCompanionBuilder = AlertsCompanion Function({
  required String id,
  required String patientId,
  required String type,
  required String message,
  Value<bool> resolved,
  Value<DateTime> createdAt,
  Value<DateTime?> dueDate,
  Value<int> rowid,
});
typedef $$AlertsTableUpdateCompanionBuilder = AlertsCompanion Function({
  Value<String> id,
  Value<String> patientId,
  Value<String> type,
  Value<String> message,
  Value<bool> resolved,
  Value<DateTime> createdAt,
  Value<DateTime?> dueDate,
  Value<int> rowid,
});

final class $$AlertsTableReferences
    extends BaseReferences<_$AppDatabase, $AlertsTable, Alert> {
  $$AlertsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PatientsTable _patientIdTable(_$AppDatabase db) => db.patients
      .createAlias($_aliasNameGenerator(db.alerts.patientId, db.patients.id));

  $$PatientsTableProcessedTableManager? get patientId {
    if ($_item.patientId == null) return null;
    final manager = $$PatientsTableTableManager($_db, $_db.patients)
        .filter((f) => f.id($_item.patientId!));
    final item = $_typedResult.readTableOrNull(_patientIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$AlertsTableFilterComposer
    extends Composer<_$AppDatabase, $AlertsTable> {
  $$AlertsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get message => $composableBuilder(
      column: $table.message, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get resolved => $composableBuilder(
      column: $table.resolved, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dueDate => $composableBuilder(
      column: $table.dueDate, builder: (column) => ColumnFilters(column));

  $$PatientsTableFilterComposer get patientId {
    final $$PatientsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.patientId,
        referencedTable: $db.patients,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PatientsTableFilterComposer(
              $db: $db,
              $table: $db.patients,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AlertsTableOrderingComposer
    extends Composer<_$AppDatabase, $AlertsTable> {
  $$AlertsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get message => $composableBuilder(
      column: $table.message, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get resolved => $composableBuilder(
      column: $table.resolved, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(
      column: $table.dueDate, builder: (column) => ColumnOrderings(column));

  $$PatientsTableOrderingComposer get patientId {
    final $$PatientsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.patientId,
        referencedTable: $db.patients,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PatientsTableOrderingComposer(
              $db: $db,
              $table: $db.patients,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AlertsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AlertsTable> {
  $$AlertsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get message =>
      $composableBuilder(column: $table.message, builder: (column) => column);

  GeneratedColumn<bool> get resolved =>
      $composableBuilder(column: $table.resolved, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  $$PatientsTableAnnotationComposer get patientId {
    final $$PatientsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.patientId,
        referencedTable: $db.patients,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PatientsTableAnnotationComposer(
              $db: $db,
              $table: $db.patients,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AlertsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AlertsTable,
    Alert,
    $$AlertsTableFilterComposer,
    $$AlertsTableOrderingComposer,
    $$AlertsTableAnnotationComposer,
    $$AlertsTableCreateCompanionBuilder,
    $$AlertsTableUpdateCompanionBuilder,
    (Alert, $$AlertsTableReferences),
    Alert,
    PrefetchHooks Function({bool patientId})> {
  $$AlertsTableTableManager(_$AppDatabase db, $AlertsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AlertsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AlertsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AlertsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> patientId = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> message = const Value.absent(),
            Value<bool> resolved = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> dueDate = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AlertsCompanion(
            id: id,
            patientId: patientId,
            type: type,
            message: message,
            resolved: resolved,
            createdAt: createdAt,
            dueDate: dueDate,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String patientId,
            required String type,
            required String message,
            Value<bool> resolved = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> dueDate = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AlertsCompanion.insert(
            id: id,
            patientId: patientId,
            type: type,
            message: message,
            resolved: resolved,
            createdAt: createdAt,
            dueDate: dueDate,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$AlertsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({patientId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (patientId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.patientId,
                    referencedTable:
                        $$AlertsTableReferences._patientIdTable(db),
                    referencedColumn:
                        $$AlertsTableReferences._patientIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$AlertsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AlertsTable,
    Alert,
    $$AlertsTableFilterComposer,
    $$AlertsTableOrderingComposer,
    $$AlertsTableAnnotationComposer,
    $$AlertsTableCreateCompanionBuilder,
    $$AlertsTableUpdateCompanionBuilder,
    (Alert, $$AlertsTableReferences),
    Alert,
    PrefetchHooks Function({bool patientId})>;
typedef $$WeightAssessmentsTableCreateCompanionBuilder
    = WeightAssessmentsCompanion Function({
  required String id,
  required String patientId,
  Value<DateTime> createdAt,
  Value<double?> weightRealKg,
  Value<double?> heightCm,
  Value<String?> heightMethod,
  Value<String?> weightSource,
  Value<String?> confidence,
  Value<double?> bmi,
  Value<double?> idealWeightKg,
  Value<double?> adjustedWeightKg,
  Value<double?> workWeightKg,
  Value<String?> workWeightLabel,
  Value<double?> proteinBaseKg,
  Value<double?> kcalBaseKg,
  Value<String?> overrideJustification,
  Value<double?> kneeHeightCm,
  Value<double?> ulnaLengthCm,
  Value<double?> estimatedHeightCm,
  Value<bool> obesitySuspected,
  Value<bool> edemaPresent,
  Value<bool> ascitesPresent,
  Value<bool> dryWeightConfirmed,
  Value<bool> amputationsPresent,
  Value<bool> pregnancyPresent,
  Value<bool> spinalIssues,
  Value<String?> ascitesSeverity,
  Value<String?> amputationsJson,
  Value<String?> pendingActionsJson,
  Value<String?> traceJson,
  Value<int> rowid,
});
typedef $$WeightAssessmentsTableUpdateCompanionBuilder
    = WeightAssessmentsCompanion Function({
  Value<String> id,
  Value<String> patientId,
  Value<DateTime> createdAt,
  Value<double?> weightRealKg,
  Value<double?> heightCm,
  Value<String?> heightMethod,
  Value<String?> weightSource,
  Value<String?> confidence,
  Value<double?> bmi,
  Value<double?> idealWeightKg,
  Value<double?> adjustedWeightKg,
  Value<double?> workWeightKg,
  Value<String?> workWeightLabel,
  Value<double?> proteinBaseKg,
  Value<double?> kcalBaseKg,
  Value<String?> overrideJustification,
  Value<double?> kneeHeightCm,
  Value<double?> ulnaLengthCm,
  Value<double?> estimatedHeightCm,
  Value<bool> obesitySuspected,
  Value<bool> edemaPresent,
  Value<bool> ascitesPresent,
  Value<bool> dryWeightConfirmed,
  Value<bool> amputationsPresent,
  Value<bool> pregnancyPresent,
  Value<bool> spinalIssues,
  Value<String?> ascitesSeverity,
  Value<String?> amputationsJson,
  Value<String?> pendingActionsJson,
  Value<String?> traceJson,
  Value<int> rowid,
});

final class $$WeightAssessmentsTableReferences extends BaseReferences<
    _$AppDatabase, $WeightAssessmentsTable, WeightAssessment> {
  $$WeightAssessmentsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $PatientsTable _patientIdTable(_$AppDatabase db) =>
      db.patients.createAlias(
          $_aliasNameGenerator(db.weightAssessments.patientId, db.patients.id));

  $$PatientsTableProcessedTableManager? get patientId {
    if ($_item.patientId == null) return null;
    final manager = $$PatientsTableTableManager($_db, $_db.patients)
        .filter((f) => f.id($_item.patientId!));
    final item = $_typedResult.readTableOrNull(_patientIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$WeightAssessmentsTableFilterComposer
    extends Composer<_$AppDatabase, $WeightAssessmentsTable> {
  $$WeightAssessmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get weightRealKg => $composableBuilder(
      column: $table.weightRealKg, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get heightCm => $composableBuilder(
      column: $table.heightCm, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get heightMethod => $composableBuilder(
      column: $table.heightMethod, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get weightSource => $composableBuilder(
      column: $table.weightSource, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get confidence => $composableBuilder(
      column: $table.confidence, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get bmi => $composableBuilder(
      column: $table.bmi, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get idealWeightKg => $composableBuilder(
      column: $table.idealWeightKg, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get adjustedWeightKg => $composableBuilder(
      column: $table.adjustedWeightKg,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get workWeightKg => $composableBuilder(
      column: $table.workWeightKg, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get workWeightLabel => $composableBuilder(
      column: $table.workWeightLabel,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get proteinBaseKg => $composableBuilder(
      column: $table.proteinBaseKg, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get kcalBaseKg => $composableBuilder(
      column: $table.kcalBaseKg, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get overrideJustification => $composableBuilder(
      column: $table.overrideJustification,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get kneeHeightCm => $composableBuilder(
      column: $table.kneeHeightCm, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get ulnaLengthCm => $composableBuilder(
      column: $table.ulnaLengthCm, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get estimatedHeightCm => $composableBuilder(
      column: $table.estimatedHeightCm,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get obesitySuspected => $composableBuilder(
      column: $table.obesitySuspected,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get edemaPresent => $composableBuilder(
      column: $table.edemaPresent, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get ascitesPresent => $composableBuilder(
      column: $table.ascitesPresent,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get dryWeightConfirmed => $composableBuilder(
      column: $table.dryWeightConfirmed,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get amputationsPresent => $composableBuilder(
      column: $table.amputationsPresent,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get pregnancyPresent => $composableBuilder(
      column: $table.pregnancyPresent,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get spinalIssues => $composableBuilder(
      column: $table.spinalIssues, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get ascitesSeverity => $composableBuilder(
      column: $table.ascitesSeverity,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get amputationsJson => $composableBuilder(
      column: $table.amputationsJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get pendingActionsJson => $composableBuilder(
      column: $table.pendingActionsJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get traceJson => $composableBuilder(
      column: $table.traceJson, builder: (column) => ColumnFilters(column));

  $$PatientsTableFilterComposer get patientId {
    final $$PatientsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.patientId,
        referencedTable: $db.patients,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PatientsTableFilterComposer(
              $db: $db,
              $table: $db.patients,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$WeightAssessmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $WeightAssessmentsTable> {
  $$WeightAssessmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get weightRealKg => $composableBuilder(
      column: $table.weightRealKg,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get heightCm => $composableBuilder(
      column: $table.heightCm, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get heightMethod => $composableBuilder(
      column: $table.heightMethod,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get weightSource => $composableBuilder(
      column: $table.weightSource,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get confidence => $composableBuilder(
      column: $table.confidence, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get bmi => $composableBuilder(
      column: $table.bmi, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get idealWeightKg => $composableBuilder(
      column: $table.idealWeightKg,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get adjustedWeightKg => $composableBuilder(
      column: $table.adjustedWeightKg,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get workWeightKg => $composableBuilder(
      column: $table.workWeightKg,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get workWeightLabel => $composableBuilder(
      column: $table.workWeightLabel,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get proteinBaseKg => $composableBuilder(
      column: $table.proteinBaseKg,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get kcalBaseKg => $composableBuilder(
      column: $table.kcalBaseKg, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get overrideJustification => $composableBuilder(
      column: $table.overrideJustification,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get kneeHeightCm => $composableBuilder(
      column: $table.kneeHeightCm,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get ulnaLengthCm => $composableBuilder(
      column: $table.ulnaLengthCm,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get estimatedHeightCm => $composableBuilder(
      column: $table.estimatedHeightCm,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get obesitySuspected => $composableBuilder(
      column: $table.obesitySuspected,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get edemaPresent => $composableBuilder(
      column: $table.edemaPresent,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get ascitesPresent => $composableBuilder(
      column: $table.ascitesPresent,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get dryWeightConfirmed => $composableBuilder(
      column: $table.dryWeightConfirmed,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get amputationsPresent => $composableBuilder(
      column: $table.amputationsPresent,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get pregnancyPresent => $composableBuilder(
      column: $table.pregnancyPresent,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get spinalIssues => $composableBuilder(
      column: $table.spinalIssues,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get ascitesSeverity => $composableBuilder(
      column: $table.ascitesSeverity,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get amputationsJson => $composableBuilder(
      column: $table.amputationsJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pendingActionsJson => $composableBuilder(
      column: $table.pendingActionsJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get traceJson => $composableBuilder(
      column: $table.traceJson, builder: (column) => ColumnOrderings(column));

  $$PatientsTableOrderingComposer get patientId {
    final $$PatientsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.patientId,
        referencedTable: $db.patients,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PatientsTableOrderingComposer(
              $db: $db,
              $table: $db.patients,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$WeightAssessmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WeightAssessmentsTable> {
  $$WeightAssessmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<double> get weightRealKg => $composableBuilder(
      column: $table.weightRealKg, builder: (column) => column);

  GeneratedColumn<double> get heightCm =>
      $composableBuilder(column: $table.heightCm, builder: (column) => column);

  GeneratedColumn<String> get heightMethod => $composableBuilder(
      column: $table.heightMethod, builder: (column) => column);

  GeneratedColumn<String> get weightSource => $composableBuilder(
      column: $table.weightSource, builder: (column) => column);

  GeneratedColumn<String> get confidence => $composableBuilder(
      column: $table.confidence, builder: (column) => column);

  GeneratedColumn<double> get bmi =>
      $composableBuilder(column: $table.bmi, builder: (column) => column);

  GeneratedColumn<double> get idealWeightKg => $composableBuilder(
      column: $table.idealWeightKg, builder: (column) => column);

  GeneratedColumn<double> get adjustedWeightKg => $composableBuilder(
      column: $table.adjustedWeightKg, builder: (column) => column);

  GeneratedColumn<double> get workWeightKg => $composableBuilder(
      column: $table.workWeightKg, builder: (column) => column);

  GeneratedColumn<String> get workWeightLabel => $composableBuilder(
      column: $table.workWeightLabel, builder: (column) => column);

  GeneratedColumn<double> get proteinBaseKg => $composableBuilder(
      column: $table.proteinBaseKg, builder: (column) => column);

  GeneratedColumn<double> get kcalBaseKg => $composableBuilder(
      column: $table.kcalBaseKg, builder: (column) => column);

  GeneratedColumn<String> get overrideJustification => $composableBuilder(
      column: $table.overrideJustification, builder: (column) => column);

  GeneratedColumn<double> get kneeHeightCm => $composableBuilder(
      column: $table.kneeHeightCm, builder: (column) => column);

  GeneratedColumn<double> get ulnaLengthCm => $composableBuilder(
      column: $table.ulnaLengthCm, builder: (column) => column);

  GeneratedColumn<double> get estimatedHeightCm => $composableBuilder(
      column: $table.estimatedHeightCm, builder: (column) => column);

  GeneratedColumn<bool> get obesitySuspected => $composableBuilder(
      column: $table.obesitySuspected, builder: (column) => column);

  GeneratedColumn<bool> get edemaPresent => $composableBuilder(
      column: $table.edemaPresent, builder: (column) => column);

  GeneratedColumn<bool> get ascitesPresent => $composableBuilder(
      column: $table.ascitesPresent, builder: (column) => column);

  GeneratedColumn<bool> get dryWeightConfirmed => $composableBuilder(
      column: $table.dryWeightConfirmed, builder: (column) => column);

  GeneratedColumn<bool> get amputationsPresent => $composableBuilder(
      column: $table.amputationsPresent, builder: (column) => column);

  GeneratedColumn<bool> get pregnancyPresent => $composableBuilder(
      column: $table.pregnancyPresent, builder: (column) => column);

  GeneratedColumn<bool> get spinalIssues => $composableBuilder(
      column: $table.spinalIssues, builder: (column) => column);

  GeneratedColumn<String> get ascitesSeverity => $composableBuilder(
      column: $table.ascitesSeverity, builder: (column) => column);

  GeneratedColumn<String> get amputationsJson => $composableBuilder(
      column: $table.amputationsJson, builder: (column) => column);

  GeneratedColumn<String> get pendingActionsJson => $composableBuilder(
      column: $table.pendingActionsJson, builder: (column) => column);

  GeneratedColumn<String> get traceJson =>
      $composableBuilder(column: $table.traceJson, builder: (column) => column);

  $$PatientsTableAnnotationComposer get patientId {
    final $$PatientsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.patientId,
        referencedTable: $db.patients,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PatientsTableAnnotationComposer(
              $db: $db,
              $table: $db.patients,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$WeightAssessmentsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $WeightAssessmentsTable,
    WeightAssessment,
    $$WeightAssessmentsTableFilterComposer,
    $$WeightAssessmentsTableOrderingComposer,
    $$WeightAssessmentsTableAnnotationComposer,
    $$WeightAssessmentsTableCreateCompanionBuilder,
    $$WeightAssessmentsTableUpdateCompanionBuilder,
    (WeightAssessment, $$WeightAssessmentsTableReferences),
    WeightAssessment,
    PrefetchHooks Function({bool patientId})> {
  $$WeightAssessmentsTableTableManager(
      _$AppDatabase db, $WeightAssessmentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WeightAssessmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WeightAssessmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WeightAssessmentsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> patientId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<double?> weightRealKg = const Value.absent(),
            Value<double?> heightCm = const Value.absent(),
            Value<String?> heightMethod = const Value.absent(),
            Value<String?> weightSource = const Value.absent(),
            Value<String?> confidence = const Value.absent(),
            Value<double?> bmi = const Value.absent(),
            Value<double?> idealWeightKg = const Value.absent(),
            Value<double?> adjustedWeightKg = const Value.absent(),
            Value<double?> workWeightKg = const Value.absent(),
            Value<String?> workWeightLabel = const Value.absent(),
            Value<double?> proteinBaseKg = const Value.absent(),
            Value<double?> kcalBaseKg = const Value.absent(),
            Value<String?> overrideJustification = const Value.absent(),
            Value<double?> kneeHeightCm = const Value.absent(),
            Value<double?> ulnaLengthCm = const Value.absent(),
            Value<double?> estimatedHeightCm = const Value.absent(),
            Value<bool> obesitySuspected = const Value.absent(),
            Value<bool> edemaPresent = const Value.absent(),
            Value<bool> ascitesPresent = const Value.absent(),
            Value<bool> dryWeightConfirmed = const Value.absent(),
            Value<bool> amputationsPresent = const Value.absent(),
            Value<bool> pregnancyPresent = const Value.absent(),
            Value<bool> spinalIssues = const Value.absent(),
            Value<String?> ascitesSeverity = const Value.absent(),
            Value<String?> amputationsJson = const Value.absent(),
            Value<String?> pendingActionsJson = const Value.absent(),
            Value<String?> traceJson = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              WeightAssessmentsCompanion(
            id: id,
            patientId: patientId,
            createdAt: createdAt,
            weightRealKg: weightRealKg,
            heightCm: heightCm,
            heightMethod: heightMethod,
            weightSource: weightSource,
            confidence: confidence,
            bmi: bmi,
            idealWeightKg: idealWeightKg,
            adjustedWeightKg: adjustedWeightKg,
            workWeightKg: workWeightKg,
            workWeightLabel: workWeightLabel,
            proteinBaseKg: proteinBaseKg,
            kcalBaseKg: kcalBaseKg,
            overrideJustification: overrideJustification,
            kneeHeightCm: kneeHeightCm,
            ulnaLengthCm: ulnaLengthCm,
            estimatedHeightCm: estimatedHeightCm,
            obesitySuspected: obesitySuspected,
            edemaPresent: edemaPresent,
            ascitesPresent: ascitesPresent,
            dryWeightConfirmed: dryWeightConfirmed,
            amputationsPresent: amputationsPresent,
            pregnancyPresent: pregnancyPresent,
            spinalIssues: spinalIssues,
            ascitesSeverity: ascitesSeverity,
            amputationsJson: amputationsJson,
            pendingActionsJson: pendingActionsJson,
            traceJson: traceJson,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String patientId,
            Value<DateTime> createdAt = const Value.absent(),
            Value<double?> weightRealKg = const Value.absent(),
            Value<double?> heightCm = const Value.absent(),
            Value<String?> heightMethod = const Value.absent(),
            Value<String?> weightSource = const Value.absent(),
            Value<String?> confidence = const Value.absent(),
            Value<double?> bmi = const Value.absent(),
            Value<double?> idealWeightKg = const Value.absent(),
            Value<double?> adjustedWeightKg = const Value.absent(),
            Value<double?> workWeightKg = const Value.absent(),
            Value<String?> workWeightLabel = const Value.absent(),
            Value<double?> proteinBaseKg = const Value.absent(),
            Value<double?> kcalBaseKg = const Value.absent(),
            Value<String?> overrideJustification = const Value.absent(),
            Value<double?> kneeHeightCm = const Value.absent(),
            Value<double?> ulnaLengthCm = const Value.absent(),
            Value<double?> estimatedHeightCm = const Value.absent(),
            Value<bool> obesitySuspected = const Value.absent(),
            Value<bool> edemaPresent = const Value.absent(),
            Value<bool> ascitesPresent = const Value.absent(),
            Value<bool> dryWeightConfirmed = const Value.absent(),
            Value<bool> amputationsPresent = const Value.absent(),
            Value<bool> pregnancyPresent = const Value.absent(),
            Value<bool> spinalIssues = const Value.absent(),
            Value<String?> ascitesSeverity = const Value.absent(),
            Value<String?> amputationsJson = const Value.absent(),
            Value<String?> pendingActionsJson = const Value.absent(),
            Value<String?> traceJson = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              WeightAssessmentsCompanion.insert(
            id: id,
            patientId: patientId,
            createdAt: createdAt,
            weightRealKg: weightRealKg,
            heightCm: heightCm,
            heightMethod: heightMethod,
            weightSource: weightSource,
            confidence: confidence,
            bmi: bmi,
            idealWeightKg: idealWeightKg,
            adjustedWeightKg: adjustedWeightKg,
            workWeightKg: workWeightKg,
            workWeightLabel: workWeightLabel,
            proteinBaseKg: proteinBaseKg,
            kcalBaseKg: kcalBaseKg,
            overrideJustification: overrideJustification,
            kneeHeightCm: kneeHeightCm,
            ulnaLengthCm: ulnaLengthCm,
            estimatedHeightCm: estimatedHeightCm,
            obesitySuspected: obesitySuspected,
            edemaPresent: edemaPresent,
            ascitesPresent: ascitesPresent,
            dryWeightConfirmed: dryWeightConfirmed,
            amputationsPresent: amputationsPresent,
            pregnancyPresent: pregnancyPresent,
            spinalIssues: spinalIssues,
            ascitesSeverity: ascitesSeverity,
            amputationsJson: amputationsJson,
            pendingActionsJson: pendingActionsJson,
            traceJson: traceJson,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$WeightAssessmentsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({patientId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (patientId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.patientId,
                    referencedTable:
                        $$WeightAssessmentsTableReferences._patientIdTable(db),
                    referencedColumn: $$WeightAssessmentsTableReferences
                        ._patientIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$WeightAssessmentsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $WeightAssessmentsTable,
    WeightAssessment,
    $$WeightAssessmentsTableFilterComposer,
    $$WeightAssessmentsTableOrderingComposer,
    $$WeightAssessmentsTableAnnotationComposer,
    $$WeightAssessmentsTableCreateCompanionBuilder,
    $$WeightAssessmentsTableUpdateCompanionBuilder,
    (WeightAssessment, $$WeightAssessmentsTableReferences),
    WeightAssessment,
    PrefetchHooks Function({bool patientId})>;
typedef $$NutritionalAssessmentsTableCreateCompanionBuilder
    = NutritionalAssessmentsCompanion Function({
  required String id,
  required String patientId,
  Value<DateTime> createdAt,
  Value<double?> nutricScore,
  Value<double?> nrsScore,
  Value<double?> apacheScore,
  Value<double?> sofaScore,
  Value<String?> pendingItemsJson,
  Value<String?> notes,
  Value<String?> traceJson,
  Value<int> rowid,
});
typedef $$NutritionalAssessmentsTableUpdateCompanionBuilder
    = NutritionalAssessmentsCompanion Function({
  Value<String> id,
  Value<String> patientId,
  Value<DateTime> createdAt,
  Value<double?> nutricScore,
  Value<double?> nrsScore,
  Value<double?> apacheScore,
  Value<double?> sofaScore,
  Value<String?> pendingItemsJson,
  Value<String?> notes,
  Value<String?> traceJson,
  Value<int> rowid,
});

final class $$NutritionalAssessmentsTableReferences extends BaseReferences<
    _$AppDatabase, $NutritionalAssessmentsTable, NutritionalAssessment> {
  $$NutritionalAssessmentsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $PatientsTable _patientIdTable(_$AppDatabase db) =>
      db.patients.createAlias($_aliasNameGenerator(
          db.nutritionalAssessments.patientId, db.patients.id));

  $$PatientsTableProcessedTableManager? get patientId {
    if ($_item.patientId == null) return null;
    final manager = $$PatientsTableTableManager($_db, $_db.patients)
        .filter((f) => f.id($_item.patientId!));
    final item = $_typedResult.readTableOrNull(_patientIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$NutritionalAssessmentsTableFilterComposer
    extends Composer<_$AppDatabase, $NutritionalAssessmentsTable> {
  $$NutritionalAssessmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get nutricScore => $composableBuilder(
      column: $table.nutricScore, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get nrsScore => $composableBuilder(
      column: $table.nrsScore, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get apacheScore => $composableBuilder(
      column: $table.apacheScore, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get sofaScore => $composableBuilder(
      column: $table.sofaScore, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get pendingItemsJson => $composableBuilder(
      column: $table.pendingItemsJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get traceJson => $composableBuilder(
      column: $table.traceJson, builder: (column) => ColumnFilters(column));

  $$PatientsTableFilterComposer get patientId {
    final $$PatientsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.patientId,
        referencedTable: $db.patients,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PatientsTableFilterComposer(
              $db: $db,
              $table: $db.patients,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$NutritionalAssessmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $NutritionalAssessmentsTable> {
  $$NutritionalAssessmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get nutricScore => $composableBuilder(
      column: $table.nutricScore, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get nrsScore => $composableBuilder(
      column: $table.nrsScore, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get apacheScore => $composableBuilder(
      column: $table.apacheScore, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get sofaScore => $composableBuilder(
      column: $table.sofaScore, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pendingItemsJson => $composableBuilder(
      column: $table.pendingItemsJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get traceJson => $composableBuilder(
      column: $table.traceJson, builder: (column) => ColumnOrderings(column));

  $$PatientsTableOrderingComposer get patientId {
    final $$PatientsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.patientId,
        referencedTable: $db.patients,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PatientsTableOrderingComposer(
              $db: $db,
              $table: $db.patients,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$NutritionalAssessmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $NutritionalAssessmentsTable> {
  $$NutritionalAssessmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<double> get nutricScore => $composableBuilder(
      column: $table.nutricScore, builder: (column) => column);

  GeneratedColumn<double> get nrsScore =>
      $composableBuilder(column: $table.nrsScore, builder: (column) => column);

  GeneratedColumn<double> get apacheScore => $composableBuilder(
      column: $table.apacheScore, builder: (column) => column);

  GeneratedColumn<double> get sofaScore =>
      $composableBuilder(column: $table.sofaScore, builder: (column) => column);

  GeneratedColumn<String> get pendingItemsJson => $composableBuilder(
      column: $table.pendingItemsJson, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get traceJson =>
      $composableBuilder(column: $table.traceJson, builder: (column) => column);

  $$PatientsTableAnnotationComposer get patientId {
    final $$PatientsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.patientId,
        referencedTable: $db.patients,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PatientsTableAnnotationComposer(
              $db: $db,
              $table: $db.patients,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$NutritionalAssessmentsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $NutritionalAssessmentsTable,
    NutritionalAssessment,
    $$NutritionalAssessmentsTableFilterComposer,
    $$NutritionalAssessmentsTableOrderingComposer,
    $$NutritionalAssessmentsTableAnnotationComposer,
    $$NutritionalAssessmentsTableCreateCompanionBuilder,
    $$NutritionalAssessmentsTableUpdateCompanionBuilder,
    (NutritionalAssessment, $$NutritionalAssessmentsTableReferences),
    NutritionalAssessment,
    PrefetchHooks Function({bool patientId})> {
  $$NutritionalAssessmentsTableTableManager(
      _$AppDatabase db, $NutritionalAssessmentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NutritionalAssessmentsTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$NutritionalAssessmentsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NutritionalAssessmentsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> patientId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<double?> nutricScore = const Value.absent(),
            Value<double?> nrsScore = const Value.absent(),
            Value<double?> apacheScore = const Value.absent(),
            Value<double?> sofaScore = const Value.absent(),
            Value<String?> pendingItemsJson = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String?> traceJson = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              NutritionalAssessmentsCompanion(
            id: id,
            patientId: patientId,
            createdAt: createdAt,
            nutricScore: nutricScore,
            nrsScore: nrsScore,
            apacheScore: apacheScore,
            sofaScore: sofaScore,
            pendingItemsJson: pendingItemsJson,
            notes: notes,
            traceJson: traceJson,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String patientId,
            Value<DateTime> createdAt = const Value.absent(),
            Value<double?> nutricScore = const Value.absent(),
            Value<double?> nrsScore = const Value.absent(),
            Value<double?> apacheScore = const Value.absent(),
            Value<double?> sofaScore = const Value.absent(),
            Value<String?> pendingItemsJson = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String?> traceJson = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              NutritionalAssessmentsCompanion.insert(
            id: id,
            patientId: patientId,
            createdAt: createdAt,
            nutricScore: nutricScore,
            nrsScore: nrsScore,
            apacheScore: apacheScore,
            sofaScore: sofaScore,
            pendingItemsJson: pendingItemsJson,
            notes: notes,
            traceJson: traceJson,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$NutritionalAssessmentsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({patientId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (patientId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.patientId,
                    referencedTable: $$NutritionalAssessmentsTableReferences
                        ._patientIdTable(db),
                    referencedColumn: $$NutritionalAssessmentsTableReferences
                        ._patientIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$NutritionalAssessmentsTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $NutritionalAssessmentsTable,
        NutritionalAssessment,
        $$NutritionalAssessmentsTableFilterComposer,
        $$NutritionalAssessmentsTableOrderingComposer,
        $$NutritionalAssessmentsTableAnnotationComposer,
        $$NutritionalAssessmentsTableCreateCompanionBuilder,
        $$NutritionalAssessmentsTableUpdateCompanionBuilder,
        (NutritionalAssessment, $$NutritionalAssessmentsTableReferences),
        NutritionalAssessment,
        PrefetchHooks Function({bool patientId})>;
typedef $$EnergyPlansTableCreateCompanionBuilder = EnergyPlansCompanion
    Function({
  required String id,
  required String patientId,
  required String snapshotJson,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$EnergyPlansTableUpdateCompanionBuilder = EnergyPlansCompanion
    Function({
  Value<String> id,
  Value<String> patientId,
  Value<String> snapshotJson,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$EnergyPlansTableReferences
    extends BaseReferences<_$AppDatabase, $EnergyPlansTable, EnergyPlan> {
  $$EnergyPlansTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PatientsTable _patientIdTable(_$AppDatabase db) =>
      db.patients.createAlias(
          $_aliasNameGenerator(db.energyPlans.patientId, db.patients.id));

  $$PatientsTableProcessedTableManager? get patientId {
    if ($_item.patientId == null) return null;
    final manager = $$PatientsTableTableManager($_db, $_db.patients)
        .filter((f) => f.id($_item.patientId!));
    final item = $_typedResult.readTableOrNull(_patientIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$EnergyPlansTableFilterComposer
    extends Composer<_$AppDatabase, $EnergyPlansTable> {
  $$EnergyPlansTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get snapshotJson => $composableBuilder(
      column: $table.snapshotJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$PatientsTableFilterComposer get patientId {
    final $$PatientsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.patientId,
        referencedTable: $db.patients,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PatientsTableFilterComposer(
              $db: $db,
              $table: $db.patients,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$EnergyPlansTableOrderingComposer
    extends Composer<_$AppDatabase, $EnergyPlansTable> {
  $$EnergyPlansTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get snapshotJson => $composableBuilder(
      column: $table.snapshotJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$PatientsTableOrderingComposer get patientId {
    final $$PatientsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.patientId,
        referencedTable: $db.patients,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PatientsTableOrderingComposer(
              $db: $db,
              $table: $db.patients,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$EnergyPlansTableAnnotationComposer
    extends Composer<_$AppDatabase, $EnergyPlansTable> {
  $$EnergyPlansTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get snapshotJson => $composableBuilder(
      column: $table.snapshotJson, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$PatientsTableAnnotationComposer get patientId {
    final $$PatientsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.patientId,
        referencedTable: $db.patients,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PatientsTableAnnotationComposer(
              $db: $db,
              $table: $db.patients,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$EnergyPlansTableTableManager extends RootTableManager<
    _$AppDatabase,
    $EnergyPlansTable,
    EnergyPlan,
    $$EnergyPlansTableFilterComposer,
    $$EnergyPlansTableOrderingComposer,
    $$EnergyPlansTableAnnotationComposer,
    $$EnergyPlansTableCreateCompanionBuilder,
    $$EnergyPlansTableUpdateCompanionBuilder,
    (EnergyPlan, $$EnergyPlansTableReferences),
    EnergyPlan,
    PrefetchHooks Function({bool patientId})> {
  $$EnergyPlansTableTableManager(_$AppDatabase db, $EnergyPlansTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EnergyPlansTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EnergyPlansTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EnergyPlansTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> patientId = const Value.absent(),
            Value<String> snapshotJson = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              EnergyPlansCompanion(
            id: id,
            patientId: patientId,
            snapshotJson: snapshotJson,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String patientId,
            required String snapshotJson,
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              EnergyPlansCompanion.insert(
            id: id,
            patientId: patientId,
            snapshotJson: snapshotJson,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$EnergyPlansTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({patientId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (patientId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.patientId,
                    referencedTable:
                        $$EnergyPlansTableReferences._patientIdTable(db),
                    referencedColumn:
                        $$EnergyPlansTableReferences._patientIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$EnergyPlansTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $EnergyPlansTable,
    EnergyPlan,
    $$EnergyPlansTableFilterComposer,
    $$EnergyPlansTableOrderingComposer,
    $$EnergyPlansTableAnnotationComposer,
    $$EnergyPlansTableCreateCompanionBuilder,
    $$EnergyPlansTableUpdateCompanionBuilder,
    (EnergyPlan, $$EnergyPlansTableReferences),
    EnergyPlan,
    PrefetchHooks Function({bool patientId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PatientsTableTableManager get patients =>
      $$PatientsTableTableManager(_db, _db.patients);
  $$MonitoringEntriesTableTableManager get monitoringEntries =>
      $$MonitoringEntriesTableTableManager(_db, _db.monitoringEntries);
  $$NutritionTargetsTableTableManager get nutritionTargets =>
      $$NutritionTargetsTableTableManager(_db, _db.nutritionTargets);
  $$AlertsTableTableManager get alerts =>
      $$AlertsTableTableManager(_db, _db.alerts);
  $$WeightAssessmentsTableTableManager get weightAssessments =>
      $$WeightAssessmentsTableTableManager(_db, _db.weightAssessments);
  $$NutritionalAssessmentsTableTableManager get nutritionalAssessments =>
      $$NutritionalAssessmentsTableTableManager(
          _db, _db.nutritionalAssessments);
  $$EnergyPlansTableTableManager get energyPlans =>
      $$EnergyPlansTableTableManager(_db, _db.energyPlans);
}
