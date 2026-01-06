// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $PatientsTable extends Patients with TableInfo<$PatientsTable, Patient> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PatientsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dniMeta = const VerificationMeta('dni');
  @override
  late final GeneratedColumn<String> dni = GeneratedColumn<String>(
    'dni',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _hcMeta = const VerificationMeta('hc');
  @override
  late final GeneratedColumn<String> hc = GeneratedColumn<String>(
    'hc',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _ageMeta = const VerificationMeta('age');
  @override
  late final GeneratedColumn<int> age = GeneratedColumn<int>(
    'age',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sexMeta = const VerificationMeta('sex');
  @override
  late final GeneratedColumn<String> sex = GeneratedColumn<String>(
    'sex',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _occupationMeta = const VerificationMeta(
    'occupation',
  );
  @override
  late final GeneratedColumn<String> occupation = GeneratedColumn<String>(
    'occupation',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _familyContactMeta = const VerificationMeta(
    'familyContact',
  );
  @override
  late final GeneratedColumn<String> familyContact = GeneratedColumn<String>(
    'family_contact',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _placeOfBirthMeta = const VerificationMeta(
    'placeOfBirth',
  );
  @override
  late final GeneratedColumn<String> placeOfBirth = GeneratedColumn<String>(
    'place_of_birth',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _insuranceTypeMeta = const VerificationMeta(
    'insuranceType',
  );
  @override
  late final GeneratedColumn<String> insuranceType = GeneratedColumn<String>(
    'insurance_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    dni,
    hc,
    age,
    sex,
    address,
    occupation,
    phone,
    familyContact,
    placeOfBirth,
    insuranceType,
    createdAt,
    updatedAt,
    isSynced,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'patients';
  @override
  VerificationContext validateIntegrity(
    Insertable<Patient> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('dni')) {
      context.handle(
        _dniMeta,
        dni.isAcceptableOrUnknown(data['dni']!, _dniMeta),
      );
    } else if (isInserting) {
      context.missing(_dniMeta);
    }
    if (data.containsKey('hc')) {
      context.handle(_hcMeta, hc.isAcceptableOrUnknown(data['hc']!, _hcMeta));
    } else if (isInserting) {
      context.missing(_hcMeta);
    }
    if (data.containsKey('age')) {
      context.handle(
        _ageMeta,
        age.isAcceptableOrUnknown(data['age']!, _ageMeta),
      );
    } else if (isInserting) {
      context.missing(_ageMeta);
    }
    if (data.containsKey('sex')) {
      context.handle(
        _sexMeta,
        sex.isAcceptableOrUnknown(data['sex']!, _sexMeta),
      );
    } else if (isInserting) {
      context.missing(_sexMeta);
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('occupation')) {
      context.handle(
        _occupationMeta,
        occupation.isAcceptableOrUnknown(data['occupation']!, _occupationMeta),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('family_contact')) {
      context.handle(
        _familyContactMeta,
        familyContact.isAcceptableOrUnknown(
          data['family_contact']!,
          _familyContactMeta,
        ),
      );
    }
    if (data.containsKey('place_of_birth')) {
      context.handle(
        _placeOfBirthMeta,
        placeOfBirth.isAcceptableOrUnknown(
          data['place_of_birth']!,
          _placeOfBirthMeta,
        ),
      );
    }
    if (data.containsKey('insurance_type')) {
      context.handle(
        _insuranceTypeMeta,
        insuranceType.isAcceptableOrUnknown(
          data['insurance_type']!,
          _insuranceTypeMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Patient map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Patient(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      dni: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dni'],
      )!,
      hc: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hc'],
      )!,
      age: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}age'],
      )!,
      sex: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sex'],
      )!,
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      ),
      occupation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}occupation'],
      ),
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      familyContact: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}family_contact'],
      ),
      placeOfBirth: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}place_of_birth'],
      ),
      insuranceType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}insurance_type'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
    );
  }

  @override
  $PatientsTable createAlias(String alias) {
    return $PatientsTable(attachedDatabase, alias);
  }
}

class Patient extends DataClass implements Insertable<Patient> {
  final int id;
  final String name;
  final String dni;
  final String hc;
  final int age;
  final String sex;
  final String? address;
  final String? occupation;
  final String? phone;
  final String? familyContact;
  final String? placeOfBirth;
  final String? insuranceType;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isSynced;
  const Patient({
    required this.id,
    required this.name,
    required this.dni,
    required this.hc,
    required this.age,
    required this.sex,
    this.address,
    this.occupation,
    this.phone,
    this.familyContact,
    this.placeOfBirth,
    this.insuranceType,
    required this.createdAt,
    required this.updatedAt,
    required this.isSynced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['dni'] = Variable<String>(dni);
    map['hc'] = Variable<String>(hc);
    map['age'] = Variable<int>(age);
    map['sex'] = Variable<String>(sex);
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || occupation != null) {
      map['occupation'] = Variable<String>(occupation);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || familyContact != null) {
      map['family_contact'] = Variable<String>(familyContact);
    }
    if (!nullToAbsent || placeOfBirth != null) {
      map['place_of_birth'] = Variable<String>(placeOfBirth);
    }
    if (!nullToAbsent || insuranceType != null) {
      map['insurance_type'] = Variable<String>(insuranceType);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_synced'] = Variable<bool>(isSynced);
    return map;
  }

  PatientsCompanion toCompanion(bool nullToAbsent) {
    return PatientsCompanion(
      id: Value(id),
      name: Value(name),
      dni: Value(dni),
      hc: Value(hc),
      age: Value(age),
      sex: Value(sex),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      occupation: occupation == null && nullToAbsent
          ? const Value.absent()
          : Value(occupation),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      familyContact: familyContact == null && nullToAbsent
          ? const Value.absent()
          : Value(familyContact),
      placeOfBirth: placeOfBirth == null && nullToAbsent
          ? const Value.absent()
          : Value(placeOfBirth),
      insuranceType: insuranceType == null && nullToAbsent
          ? const Value.absent()
          : Value(insuranceType),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      isSynced: Value(isSynced),
    );
  }

  factory Patient.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Patient(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      dni: serializer.fromJson<String>(json['dni']),
      hc: serializer.fromJson<String>(json['hc']),
      age: serializer.fromJson<int>(json['age']),
      sex: serializer.fromJson<String>(json['sex']),
      address: serializer.fromJson<String?>(json['address']),
      occupation: serializer.fromJson<String?>(json['occupation']),
      phone: serializer.fromJson<String?>(json['phone']),
      familyContact: serializer.fromJson<String?>(json['familyContact']),
      placeOfBirth: serializer.fromJson<String?>(json['placeOfBirth']),
      insuranceType: serializer.fromJson<String?>(json['insuranceType']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'dni': serializer.toJson<String>(dni),
      'hc': serializer.toJson<String>(hc),
      'age': serializer.toJson<int>(age),
      'sex': serializer.toJson<String>(sex),
      'address': serializer.toJson<String?>(address),
      'occupation': serializer.toJson<String?>(occupation),
      'phone': serializer.toJson<String?>(phone),
      'familyContact': serializer.toJson<String?>(familyContact),
      'placeOfBirth': serializer.toJson<String?>(placeOfBirth),
      'insuranceType': serializer.toJson<String?>(insuranceType),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isSynced': serializer.toJson<bool>(isSynced),
    };
  }

  Patient copyWith({
    int? id,
    String? name,
    String? dni,
    String? hc,
    int? age,
    String? sex,
    Value<String?> address = const Value.absent(),
    Value<String?> occupation = const Value.absent(),
    Value<String?> phone = const Value.absent(),
    Value<String?> familyContact = const Value.absent(),
    Value<String?> placeOfBirth = const Value.absent(),
    Value<String?> insuranceType = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isSynced,
  }) => Patient(
    id: id ?? this.id,
    name: name ?? this.name,
    dni: dni ?? this.dni,
    hc: hc ?? this.hc,
    age: age ?? this.age,
    sex: sex ?? this.sex,
    address: address.present ? address.value : this.address,
    occupation: occupation.present ? occupation.value : this.occupation,
    phone: phone.present ? phone.value : this.phone,
    familyContact: familyContact.present
        ? familyContact.value
        : this.familyContact,
    placeOfBirth: placeOfBirth.present ? placeOfBirth.value : this.placeOfBirth,
    insuranceType: insuranceType.present
        ? insuranceType.value
        : this.insuranceType,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    isSynced: isSynced ?? this.isSynced,
  );
  Patient copyWithCompanion(PatientsCompanion data) {
    return Patient(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      dni: data.dni.present ? data.dni.value : this.dni,
      hc: data.hc.present ? data.hc.value : this.hc,
      age: data.age.present ? data.age.value : this.age,
      sex: data.sex.present ? data.sex.value : this.sex,
      address: data.address.present ? data.address.value : this.address,
      occupation: data.occupation.present
          ? data.occupation.value
          : this.occupation,
      phone: data.phone.present ? data.phone.value : this.phone,
      familyContact: data.familyContact.present
          ? data.familyContact.value
          : this.familyContact,
      placeOfBirth: data.placeOfBirth.present
          ? data.placeOfBirth.value
          : this.placeOfBirth,
      insuranceType: data.insuranceType.present
          ? data.insuranceType.value
          : this.insuranceType,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Patient(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('dni: $dni, ')
          ..write('hc: $hc, ')
          ..write('age: $age, ')
          ..write('sex: $sex, ')
          ..write('address: $address, ')
          ..write('occupation: $occupation, ')
          ..write('phone: $phone, ')
          ..write('familyContact: $familyContact, ')
          ..write('placeOfBirth: $placeOfBirth, ')
          ..write('insuranceType: $insuranceType, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    dni,
    hc,
    age,
    sex,
    address,
    occupation,
    phone,
    familyContact,
    placeOfBirth,
    insuranceType,
    createdAt,
    updatedAt,
    isSynced,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Patient &&
          other.id == this.id &&
          other.name == this.name &&
          other.dni == this.dni &&
          other.hc == this.hc &&
          other.age == this.age &&
          other.sex == this.sex &&
          other.address == this.address &&
          other.occupation == this.occupation &&
          other.phone == this.phone &&
          other.familyContact == this.familyContact &&
          other.placeOfBirth == this.placeOfBirth &&
          other.insuranceType == this.insuranceType &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isSynced == this.isSynced);
}

class PatientsCompanion extends UpdateCompanion<Patient> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> dni;
  final Value<String> hc;
  final Value<int> age;
  final Value<String> sex;
  final Value<String?> address;
  final Value<String?> occupation;
  final Value<String?> phone;
  final Value<String?> familyContact;
  final Value<String?> placeOfBirth;
  final Value<String?> insuranceType;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> isSynced;
  const PatientsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.dni = const Value.absent(),
    this.hc = const Value.absent(),
    this.age = const Value.absent(),
    this.sex = const Value.absent(),
    this.address = const Value.absent(),
    this.occupation = const Value.absent(),
    this.phone = const Value.absent(),
    this.familyContact = const Value.absent(),
    this.placeOfBirth = const Value.absent(),
    this.insuranceType = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
  });
  PatientsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String dni,
    required String hc,
    required int age,
    required String sex,
    this.address = const Value.absent(),
    this.occupation = const Value.absent(),
    this.phone = const Value.absent(),
    this.familyContact = const Value.absent(),
    this.placeOfBirth = const Value.absent(),
    this.insuranceType = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
  }) : name = Value(name),
       dni = Value(dni),
       hc = Value(hc),
       age = Value(age),
       sex = Value(sex);
  static Insertable<Patient> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? dni,
    Expression<String>? hc,
    Expression<int>? age,
    Expression<String>? sex,
    Expression<String>? address,
    Expression<String>? occupation,
    Expression<String>? phone,
    Expression<String>? familyContact,
    Expression<String>? placeOfBirth,
    Expression<String>? insuranceType,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isSynced,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (dni != null) 'dni': dni,
      if (hc != null) 'hc': hc,
      if (age != null) 'age': age,
      if (sex != null) 'sex': sex,
      if (address != null) 'address': address,
      if (occupation != null) 'occupation': occupation,
      if (phone != null) 'phone': phone,
      if (familyContact != null) 'family_contact': familyContact,
      if (placeOfBirth != null) 'place_of_birth': placeOfBirth,
      if (insuranceType != null) 'insurance_type': insuranceType,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isSynced != null) 'is_synced': isSynced,
    });
  }

  PatientsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? dni,
    Value<String>? hc,
    Value<int>? age,
    Value<String>? sex,
    Value<String?>? address,
    Value<String?>? occupation,
    Value<String?>? phone,
    Value<String?>? familyContact,
    Value<String?>? placeOfBirth,
    Value<String?>? insuranceType,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<bool>? isSynced,
  }) {
    return PatientsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      dni: dni ?? this.dni,
      hc: hc ?? this.hc,
      age: age ?? this.age,
      sex: sex ?? this.sex,
      address: address ?? this.address,
      occupation: occupation ?? this.occupation,
      phone: phone ?? this.phone,
      familyContact: familyContact ?? this.familyContact,
      placeOfBirth: placeOfBirth ?? this.placeOfBirth,
      insuranceType: insuranceType ?? this.insuranceType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (dni.present) {
      map['dni'] = Variable<String>(dni.value);
    }
    if (hc.present) {
      map['hc'] = Variable<String>(hc.value);
    }
    if (age.present) {
      map['age'] = Variable<int>(age.value);
    }
    if (sex.present) {
      map['sex'] = Variable<String>(sex.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (occupation.present) {
      map['occupation'] = Variable<String>(occupation.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (familyContact.present) {
      map['family_contact'] = Variable<String>(familyContact.value);
    }
    if (placeOfBirth.present) {
      map['place_of_birth'] = Variable<String>(placeOfBirth.value);
    }
    if (insuranceType.present) {
      map['insurance_type'] = Variable<String>(insuranceType.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PatientsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('dni: $dni, ')
          ..write('hc: $hc, ')
          ..write('age: $age, ')
          ..write('sex: $sex, ')
          ..write('address: $address, ')
          ..write('occupation: $occupation, ')
          ..write('phone: $phone, ')
          ..write('familyContact: $familyContact, ')
          ..write('placeOfBirth: $placeOfBirth, ')
          ..write('insuranceType: $insuranceType, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }
}

class $AdmissionsTable extends Admissions
    with TableInfo<$AdmissionsTable, Admission> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AdmissionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _patientIdMeta = const VerificationMeta(
    'patientId',
  );
  @override
  late final GeneratedColumn<int> patientId = GeneratedColumn<int>(
    'patient_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES patients (id)',
    ),
  );
  static const VerificationMeta _admissionDateMeta = const VerificationMeta(
    'admissionDate',
  );
  @override
  late final GeneratedColumn<DateTime> admissionDate =
      GeneratedColumn<DateTime>(
        'admission_date',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _sofaScoreMeta = const VerificationMeta(
    'sofaScore',
  );
  @override
  late final GeneratedColumn<double> sofaScore = GeneratedColumn<double>(
    'sofa_score',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _apacheScoreMeta = const VerificationMeta(
    'apacheScore',
  );
  @override
  late final GeneratedColumn<double> apacheScore = GeneratedColumn<double>(
    'apache_score',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nutricScoreMeta = const VerificationMeta(
    'nutricScore',
  );
  @override
  late final GeneratedColumn<double> nutricScore = GeneratedColumn<double>(
    'nutric_score',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sofaMortalityMeta = const VerificationMeta(
    'sofaMortality',
  );
  @override
  late final GeneratedColumn<String> sofaMortality = GeneratedColumn<String>(
    'sofa_mortality',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _apacheMortalityMeta = const VerificationMeta(
    'apacheMortality',
  );
  @override
  late final GeneratedColumn<String> apacheMortality = GeneratedColumn<String>(
    'apache_mortality',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _diagnosisMeta = const VerificationMeta(
    'diagnosis',
  );
  @override
  late final GeneratedColumn<String> diagnosis = GeneratedColumn<String>(
    'diagnosis',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _signsSymptomsMeta = const VerificationMeta(
    'signsSymptoms',
  );
  @override
  late final GeneratedColumn<String> signsSymptoms = GeneratedColumn<String>(
    'signs_symptoms',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _timeOfDiseaseMeta = const VerificationMeta(
    'timeOfDisease',
  );
  @override
  late final GeneratedColumn<String> timeOfDisease = GeneratedColumn<String>(
    'time_of_disease',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _illnessStartMeta = const VerificationMeta(
    'illnessStart',
  );
  @override
  late final GeneratedColumn<String> illnessStart = GeneratedColumn<String>(
    'illness_start',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _illnessCourseMeta = const VerificationMeta(
    'illnessCourse',
  );
  @override
  late final GeneratedColumn<String> illnessCourse = GeneratedColumn<String>(
    'illness_course',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _storyMeta = const VerificationMeta('story');
  @override
  late final GeneratedColumn<String> story = GeneratedColumn<String>(
    'story',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _physicalExamMeta = const VerificationMeta(
    'physicalExam',
  );
  @override
  late final GeneratedColumn<String> physicalExam = GeneratedColumn<String>(
    'physical_exam',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _planMeta = const VerificationMeta('plan');
  @override
  late final GeneratedColumn<String> plan = GeneratedColumn<String>(
    'plan',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bpMeta = const VerificationMeta('bp');
  @override
  late final GeneratedColumn<String> bp = GeneratedColumn<String>(
    'bp',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hrMeta = const VerificationMeta('hr');
  @override
  late final GeneratedColumn<String> hr = GeneratedColumn<String>(
    'hr',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rrMeta = const VerificationMeta('rr');
  @override
  late final GeneratedColumn<String> rr = GeneratedColumn<String>(
    'rr',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _o2SatMeta = const VerificationMeta('o2Sat');
  @override
  late final GeneratedColumn<String> o2Sat = GeneratedColumn<String>(
    'o2_sat',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tempMeta = const VerificationMeta('temp');
  @override
  late final GeneratedColumn<String> temp = GeneratedColumn<String>(
    'temp',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _vitalsJsonMeta = const VerificationMeta(
    'vitalsJson',
  );
  @override
  late final GeneratedColumn<String> vitalsJson = GeneratedColumn<String>(
    'vitals_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _proceduresMeta = const VerificationMeta(
    'procedures',
  );
  @override
  late final GeneratedColumn<String> procedures = GeneratedColumn<String>(
    'procedures',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bedNumberMeta = const VerificationMeta(
    'bedNumber',
  );
  @override
  late final GeneratedColumn<int> bedNumber = GeneratedColumn<int>(
    'bed_number',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dischargedAtMeta = const VerificationMeta(
    'dischargedAt',
  );
  @override
  late final GeneratedColumn<DateTime> dischargedAt = GeneratedColumn<DateTime>(
    'discharged_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _uciPriorityMeta = const VerificationMeta(
    'uciPriority',
  );
  @override
  late final GeneratedColumn<String> uciPriority = GeneratedColumn<String>(
    'uci_priority',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    patientId,
    admissionDate,
    sofaScore,
    apacheScore,
    nutricScore,
    sofaMortality,
    apacheMortality,
    diagnosis,
    signsSymptoms,
    timeOfDisease,
    illnessStart,
    illnessCourse,
    story,
    physicalExam,
    plan,
    bp,
    hr,
    rr,
    o2Sat,
    temp,
    vitalsJson,
    procedures,
    bedNumber,
    dischargedAt,
    uciPriority,
    createdAt,
    isSynced,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'admissions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Admission> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('patient_id')) {
      context.handle(
        _patientIdMeta,
        patientId.isAcceptableOrUnknown(data['patient_id']!, _patientIdMeta),
      );
    } else if (isInserting) {
      context.missing(_patientIdMeta);
    }
    if (data.containsKey('admission_date')) {
      context.handle(
        _admissionDateMeta,
        admissionDate.isAcceptableOrUnknown(
          data['admission_date']!,
          _admissionDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_admissionDateMeta);
    }
    if (data.containsKey('sofa_score')) {
      context.handle(
        _sofaScoreMeta,
        sofaScore.isAcceptableOrUnknown(data['sofa_score']!, _sofaScoreMeta),
      );
    }
    if (data.containsKey('apache_score')) {
      context.handle(
        _apacheScoreMeta,
        apacheScore.isAcceptableOrUnknown(
          data['apache_score']!,
          _apacheScoreMeta,
        ),
      );
    }
    if (data.containsKey('nutric_score')) {
      context.handle(
        _nutricScoreMeta,
        nutricScore.isAcceptableOrUnknown(
          data['nutric_score']!,
          _nutricScoreMeta,
        ),
      );
    }
    if (data.containsKey('sofa_mortality')) {
      context.handle(
        _sofaMortalityMeta,
        sofaMortality.isAcceptableOrUnknown(
          data['sofa_mortality']!,
          _sofaMortalityMeta,
        ),
      );
    }
    if (data.containsKey('apache_mortality')) {
      context.handle(
        _apacheMortalityMeta,
        apacheMortality.isAcceptableOrUnknown(
          data['apache_mortality']!,
          _apacheMortalityMeta,
        ),
      );
    }
    if (data.containsKey('diagnosis')) {
      context.handle(
        _diagnosisMeta,
        diagnosis.isAcceptableOrUnknown(data['diagnosis']!, _diagnosisMeta),
      );
    }
    if (data.containsKey('signs_symptoms')) {
      context.handle(
        _signsSymptomsMeta,
        signsSymptoms.isAcceptableOrUnknown(
          data['signs_symptoms']!,
          _signsSymptomsMeta,
        ),
      );
    }
    if (data.containsKey('time_of_disease')) {
      context.handle(
        _timeOfDiseaseMeta,
        timeOfDisease.isAcceptableOrUnknown(
          data['time_of_disease']!,
          _timeOfDiseaseMeta,
        ),
      );
    }
    if (data.containsKey('illness_start')) {
      context.handle(
        _illnessStartMeta,
        illnessStart.isAcceptableOrUnknown(
          data['illness_start']!,
          _illnessStartMeta,
        ),
      );
    }
    if (data.containsKey('illness_course')) {
      context.handle(
        _illnessCourseMeta,
        illnessCourse.isAcceptableOrUnknown(
          data['illness_course']!,
          _illnessCourseMeta,
        ),
      );
    }
    if (data.containsKey('story')) {
      context.handle(
        _storyMeta,
        story.isAcceptableOrUnknown(data['story']!, _storyMeta),
      );
    }
    if (data.containsKey('physical_exam')) {
      context.handle(
        _physicalExamMeta,
        physicalExam.isAcceptableOrUnknown(
          data['physical_exam']!,
          _physicalExamMeta,
        ),
      );
    }
    if (data.containsKey('plan')) {
      context.handle(
        _planMeta,
        plan.isAcceptableOrUnknown(data['plan']!, _planMeta),
      );
    }
    if (data.containsKey('bp')) {
      context.handle(_bpMeta, bp.isAcceptableOrUnknown(data['bp']!, _bpMeta));
    }
    if (data.containsKey('hr')) {
      context.handle(_hrMeta, hr.isAcceptableOrUnknown(data['hr']!, _hrMeta));
    }
    if (data.containsKey('rr')) {
      context.handle(_rrMeta, rr.isAcceptableOrUnknown(data['rr']!, _rrMeta));
    }
    if (data.containsKey('o2_sat')) {
      context.handle(
        _o2SatMeta,
        o2Sat.isAcceptableOrUnknown(data['o2_sat']!, _o2SatMeta),
      );
    }
    if (data.containsKey('temp')) {
      context.handle(
        _tempMeta,
        temp.isAcceptableOrUnknown(data['temp']!, _tempMeta),
      );
    }
    if (data.containsKey('vitals_json')) {
      context.handle(
        _vitalsJsonMeta,
        vitalsJson.isAcceptableOrUnknown(data['vitals_json']!, _vitalsJsonMeta),
      );
    }
    if (data.containsKey('procedures')) {
      context.handle(
        _proceduresMeta,
        procedures.isAcceptableOrUnknown(data['procedures']!, _proceduresMeta),
      );
    }
    if (data.containsKey('bed_number')) {
      context.handle(
        _bedNumberMeta,
        bedNumber.isAcceptableOrUnknown(data['bed_number']!, _bedNumberMeta),
      );
    }
    if (data.containsKey('discharged_at')) {
      context.handle(
        _dischargedAtMeta,
        dischargedAt.isAcceptableOrUnknown(
          data['discharged_at']!,
          _dischargedAtMeta,
        ),
      );
    }
    if (data.containsKey('uci_priority')) {
      context.handle(
        _uciPriorityMeta,
        uciPriority.isAcceptableOrUnknown(
          data['uci_priority']!,
          _uciPriorityMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Admission map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Admission(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      patientId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}patient_id'],
      )!,
      admissionDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}admission_date'],
      )!,
      sofaScore: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}sofa_score'],
      ),
      apacheScore: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}apache_score'],
      ),
      nutricScore: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}nutric_score'],
      ),
      sofaMortality: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sofa_mortality'],
      ),
      apacheMortality: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}apache_mortality'],
      ),
      diagnosis: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}diagnosis'],
      ),
      signsSymptoms: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}signs_symptoms'],
      ),
      timeOfDisease: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}time_of_disease'],
      ),
      illnessStart: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}illness_start'],
      ),
      illnessCourse: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}illness_course'],
      ),
      story: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}story'],
      ),
      physicalExam: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}physical_exam'],
      ),
      plan: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plan'],
      ),
      bp: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bp'],
      ),
      hr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hr'],
      ),
      rr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rr'],
      ),
      o2Sat: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}o2_sat'],
      ),
      temp: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}temp'],
      ),
      vitalsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vitals_json'],
      ),
      procedures: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}procedures'],
      ),
      bedNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bed_number'],
      ),
      dischargedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}discharged_at'],
      ),
      uciPriority: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uci_priority'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
    );
  }

  @override
  $AdmissionsTable createAlias(String alias) {
    return $AdmissionsTable(attachedDatabase, alias);
  }
}

class Admission extends DataClass implements Insertable<Admission> {
  final int id;
  final int patientId;
  final DateTime admissionDate;
  final double? sofaScore;
  final double? apacheScore;
  final double? nutricScore;
  final String? sofaMortality;
  final String? apacheMortality;
  final String? diagnosis;
  final String? signsSymptoms;
  final String? timeOfDisease;
  final String? illnessStart;
  final String? illnessCourse;
  final String? story;
  final String? physicalExam;
  final String? plan;
  final String? bp;
  final String? hr;
  final String? rr;
  final String? o2Sat;
  final String? temp;
  final String? vitalsJson;
  final String? procedures;
  final int? bedNumber;
  final DateTime? dischargedAt;
  final String? uciPriority;
  final DateTime createdAt;
  final bool isSynced;
  const Admission({
    required this.id,
    required this.patientId,
    required this.admissionDate,
    this.sofaScore,
    this.apacheScore,
    this.nutricScore,
    this.sofaMortality,
    this.apacheMortality,
    this.diagnosis,
    this.signsSymptoms,
    this.timeOfDisease,
    this.illnessStart,
    this.illnessCourse,
    this.story,
    this.physicalExam,
    this.plan,
    this.bp,
    this.hr,
    this.rr,
    this.o2Sat,
    this.temp,
    this.vitalsJson,
    this.procedures,
    this.bedNumber,
    this.dischargedAt,
    this.uciPriority,
    required this.createdAt,
    required this.isSynced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['patient_id'] = Variable<int>(patientId);
    map['admission_date'] = Variable<DateTime>(admissionDate);
    if (!nullToAbsent || sofaScore != null) {
      map['sofa_score'] = Variable<double>(sofaScore);
    }
    if (!nullToAbsent || apacheScore != null) {
      map['apache_score'] = Variable<double>(apacheScore);
    }
    if (!nullToAbsent || nutricScore != null) {
      map['nutric_score'] = Variable<double>(nutricScore);
    }
    if (!nullToAbsent || sofaMortality != null) {
      map['sofa_mortality'] = Variable<String>(sofaMortality);
    }
    if (!nullToAbsent || apacheMortality != null) {
      map['apache_mortality'] = Variable<String>(apacheMortality);
    }
    if (!nullToAbsent || diagnosis != null) {
      map['diagnosis'] = Variable<String>(diagnosis);
    }
    if (!nullToAbsent || signsSymptoms != null) {
      map['signs_symptoms'] = Variable<String>(signsSymptoms);
    }
    if (!nullToAbsent || timeOfDisease != null) {
      map['time_of_disease'] = Variable<String>(timeOfDisease);
    }
    if (!nullToAbsent || illnessStart != null) {
      map['illness_start'] = Variable<String>(illnessStart);
    }
    if (!nullToAbsent || illnessCourse != null) {
      map['illness_course'] = Variable<String>(illnessCourse);
    }
    if (!nullToAbsent || story != null) {
      map['story'] = Variable<String>(story);
    }
    if (!nullToAbsent || physicalExam != null) {
      map['physical_exam'] = Variable<String>(physicalExam);
    }
    if (!nullToAbsent || plan != null) {
      map['plan'] = Variable<String>(plan);
    }
    if (!nullToAbsent || bp != null) {
      map['bp'] = Variable<String>(bp);
    }
    if (!nullToAbsent || hr != null) {
      map['hr'] = Variable<String>(hr);
    }
    if (!nullToAbsent || rr != null) {
      map['rr'] = Variable<String>(rr);
    }
    if (!nullToAbsent || o2Sat != null) {
      map['o2_sat'] = Variable<String>(o2Sat);
    }
    if (!nullToAbsent || temp != null) {
      map['temp'] = Variable<String>(temp);
    }
    if (!nullToAbsent || vitalsJson != null) {
      map['vitals_json'] = Variable<String>(vitalsJson);
    }
    if (!nullToAbsent || procedures != null) {
      map['procedures'] = Variable<String>(procedures);
    }
    if (!nullToAbsent || bedNumber != null) {
      map['bed_number'] = Variable<int>(bedNumber);
    }
    if (!nullToAbsent || dischargedAt != null) {
      map['discharged_at'] = Variable<DateTime>(dischargedAt);
    }
    if (!nullToAbsent || uciPriority != null) {
      map['uci_priority'] = Variable<String>(uciPriority);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['is_synced'] = Variable<bool>(isSynced);
    return map;
  }

  AdmissionsCompanion toCompanion(bool nullToAbsent) {
    return AdmissionsCompanion(
      id: Value(id),
      patientId: Value(patientId),
      admissionDate: Value(admissionDate),
      sofaScore: sofaScore == null && nullToAbsent
          ? const Value.absent()
          : Value(sofaScore),
      apacheScore: apacheScore == null && nullToAbsent
          ? const Value.absent()
          : Value(apacheScore),
      nutricScore: nutricScore == null && nullToAbsent
          ? const Value.absent()
          : Value(nutricScore),
      sofaMortality: sofaMortality == null && nullToAbsent
          ? const Value.absent()
          : Value(sofaMortality),
      apacheMortality: apacheMortality == null && nullToAbsent
          ? const Value.absent()
          : Value(apacheMortality),
      diagnosis: diagnosis == null && nullToAbsent
          ? const Value.absent()
          : Value(diagnosis),
      signsSymptoms: signsSymptoms == null && nullToAbsent
          ? const Value.absent()
          : Value(signsSymptoms),
      timeOfDisease: timeOfDisease == null && nullToAbsent
          ? const Value.absent()
          : Value(timeOfDisease),
      illnessStart: illnessStart == null && nullToAbsent
          ? const Value.absent()
          : Value(illnessStart),
      illnessCourse: illnessCourse == null && nullToAbsent
          ? const Value.absent()
          : Value(illnessCourse),
      story: story == null && nullToAbsent
          ? const Value.absent()
          : Value(story),
      physicalExam: physicalExam == null && nullToAbsent
          ? const Value.absent()
          : Value(physicalExam),
      plan: plan == null && nullToAbsent ? const Value.absent() : Value(plan),
      bp: bp == null && nullToAbsent ? const Value.absent() : Value(bp),
      hr: hr == null && nullToAbsent ? const Value.absent() : Value(hr),
      rr: rr == null && nullToAbsent ? const Value.absent() : Value(rr),
      o2Sat: o2Sat == null && nullToAbsent
          ? const Value.absent()
          : Value(o2Sat),
      temp: temp == null && nullToAbsent ? const Value.absent() : Value(temp),
      vitalsJson: vitalsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(vitalsJson),
      procedures: procedures == null && nullToAbsent
          ? const Value.absent()
          : Value(procedures),
      bedNumber: bedNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(bedNumber),
      dischargedAt: dischargedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(dischargedAt),
      uciPriority: uciPriority == null && nullToAbsent
          ? const Value.absent()
          : Value(uciPriority),
      createdAt: Value(createdAt),
      isSynced: Value(isSynced),
    );
  }

  factory Admission.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Admission(
      id: serializer.fromJson<int>(json['id']),
      patientId: serializer.fromJson<int>(json['patientId']),
      admissionDate: serializer.fromJson<DateTime>(json['admissionDate']),
      sofaScore: serializer.fromJson<double?>(json['sofaScore']),
      apacheScore: serializer.fromJson<double?>(json['apacheScore']),
      nutricScore: serializer.fromJson<double?>(json['nutricScore']),
      sofaMortality: serializer.fromJson<String?>(json['sofaMortality']),
      apacheMortality: serializer.fromJson<String?>(json['apacheMortality']),
      diagnosis: serializer.fromJson<String?>(json['diagnosis']),
      signsSymptoms: serializer.fromJson<String?>(json['signsSymptoms']),
      timeOfDisease: serializer.fromJson<String?>(json['timeOfDisease']),
      illnessStart: serializer.fromJson<String?>(json['illnessStart']),
      illnessCourse: serializer.fromJson<String?>(json['illnessCourse']),
      story: serializer.fromJson<String?>(json['story']),
      physicalExam: serializer.fromJson<String?>(json['physicalExam']),
      plan: serializer.fromJson<String?>(json['plan']),
      bp: serializer.fromJson<String?>(json['bp']),
      hr: serializer.fromJson<String?>(json['hr']),
      rr: serializer.fromJson<String?>(json['rr']),
      o2Sat: serializer.fromJson<String?>(json['o2Sat']),
      temp: serializer.fromJson<String?>(json['temp']),
      vitalsJson: serializer.fromJson<String?>(json['vitalsJson']),
      procedures: serializer.fromJson<String?>(json['procedures']),
      bedNumber: serializer.fromJson<int?>(json['bedNumber']),
      dischargedAt: serializer.fromJson<DateTime?>(json['dischargedAt']),
      uciPriority: serializer.fromJson<String?>(json['uciPriority']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'patientId': serializer.toJson<int>(patientId),
      'admissionDate': serializer.toJson<DateTime>(admissionDate),
      'sofaScore': serializer.toJson<double?>(sofaScore),
      'apacheScore': serializer.toJson<double?>(apacheScore),
      'nutricScore': serializer.toJson<double?>(nutricScore),
      'sofaMortality': serializer.toJson<String?>(sofaMortality),
      'apacheMortality': serializer.toJson<String?>(apacheMortality),
      'diagnosis': serializer.toJson<String?>(diagnosis),
      'signsSymptoms': serializer.toJson<String?>(signsSymptoms),
      'timeOfDisease': serializer.toJson<String?>(timeOfDisease),
      'illnessStart': serializer.toJson<String?>(illnessStart),
      'illnessCourse': serializer.toJson<String?>(illnessCourse),
      'story': serializer.toJson<String?>(story),
      'physicalExam': serializer.toJson<String?>(physicalExam),
      'plan': serializer.toJson<String?>(plan),
      'bp': serializer.toJson<String?>(bp),
      'hr': serializer.toJson<String?>(hr),
      'rr': serializer.toJson<String?>(rr),
      'o2Sat': serializer.toJson<String?>(o2Sat),
      'temp': serializer.toJson<String?>(temp),
      'vitalsJson': serializer.toJson<String?>(vitalsJson),
      'procedures': serializer.toJson<String?>(procedures),
      'bedNumber': serializer.toJson<int?>(bedNumber),
      'dischargedAt': serializer.toJson<DateTime?>(dischargedAt),
      'uciPriority': serializer.toJson<String?>(uciPriority),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'isSynced': serializer.toJson<bool>(isSynced),
    };
  }

  Admission copyWith({
    int? id,
    int? patientId,
    DateTime? admissionDate,
    Value<double?> sofaScore = const Value.absent(),
    Value<double?> apacheScore = const Value.absent(),
    Value<double?> nutricScore = const Value.absent(),
    Value<String?> sofaMortality = const Value.absent(),
    Value<String?> apacheMortality = const Value.absent(),
    Value<String?> diagnosis = const Value.absent(),
    Value<String?> signsSymptoms = const Value.absent(),
    Value<String?> timeOfDisease = const Value.absent(),
    Value<String?> illnessStart = const Value.absent(),
    Value<String?> illnessCourse = const Value.absent(),
    Value<String?> story = const Value.absent(),
    Value<String?> physicalExam = const Value.absent(),
    Value<String?> plan = const Value.absent(),
    Value<String?> bp = const Value.absent(),
    Value<String?> hr = const Value.absent(),
    Value<String?> rr = const Value.absent(),
    Value<String?> o2Sat = const Value.absent(),
    Value<String?> temp = const Value.absent(),
    Value<String?> vitalsJson = const Value.absent(),
    Value<String?> procedures = const Value.absent(),
    Value<int?> bedNumber = const Value.absent(),
    Value<DateTime?> dischargedAt = const Value.absent(),
    Value<String?> uciPriority = const Value.absent(),
    DateTime? createdAt,
    bool? isSynced,
  }) => Admission(
    id: id ?? this.id,
    patientId: patientId ?? this.patientId,
    admissionDate: admissionDate ?? this.admissionDate,
    sofaScore: sofaScore.present ? sofaScore.value : this.sofaScore,
    apacheScore: apacheScore.present ? apacheScore.value : this.apacheScore,
    nutricScore: nutricScore.present ? nutricScore.value : this.nutricScore,
    sofaMortality: sofaMortality.present
        ? sofaMortality.value
        : this.sofaMortality,
    apacheMortality: apacheMortality.present
        ? apacheMortality.value
        : this.apacheMortality,
    diagnosis: diagnosis.present ? diagnosis.value : this.diagnosis,
    signsSymptoms: signsSymptoms.present
        ? signsSymptoms.value
        : this.signsSymptoms,
    timeOfDisease: timeOfDisease.present
        ? timeOfDisease.value
        : this.timeOfDisease,
    illnessStart: illnessStart.present ? illnessStart.value : this.illnessStart,
    illnessCourse: illnessCourse.present
        ? illnessCourse.value
        : this.illnessCourse,
    story: story.present ? story.value : this.story,
    physicalExam: physicalExam.present ? physicalExam.value : this.physicalExam,
    plan: plan.present ? plan.value : this.plan,
    bp: bp.present ? bp.value : this.bp,
    hr: hr.present ? hr.value : this.hr,
    rr: rr.present ? rr.value : this.rr,
    o2Sat: o2Sat.present ? o2Sat.value : this.o2Sat,
    temp: temp.present ? temp.value : this.temp,
    vitalsJson: vitalsJson.present ? vitalsJson.value : this.vitalsJson,
    procedures: procedures.present ? procedures.value : this.procedures,
    bedNumber: bedNumber.present ? bedNumber.value : this.bedNumber,
    dischargedAt: dischargedAt.present ? dischargedAt.value : this.dischargedAt,
    uciPriority: uciPriority.present ? uciPriority.value : this.uciPriority,
    createdAt: createdAt ?? this.createdAt,
    isSynced: isSynced ?? this.isSynced,
  );
  Admission copyWithCompanion(AdmissionsCompanion data) {
    return Admission(
      id: data.id.present ? data.id.value : this.id,
      patientId: data.patientId.present ? data.patientId.value : this.patientId,
      admissionDate: data.admissionDate.present
          ? data.admissionDate.value
          : this.admissionDate,
      sofaScore: data.sofaScore.present ? data.sofaScore.value : this.sofaScore,
      apacheScore: data.apacheScore.present
          ? data.apacheScore.value
          : this.apacheScore,
      nutricScore: data.nutricScore.present
          ? data.nutricScore.value
          : this.nutricScore,
      sofaMortality: data.sofaMortality.present
          ? data.sofaMortality.value
          : this.sofaMortality,
      apacheMortality: data.apacheMortality.present
          ? data.apacheMortality.value
          : this.apacheMortality,
      diagnosis: data.diagnosis.present ? data.diagnosis.value : this.diagnosis,
      signsSymptoms: data.signsSymptoms.present
          ? data.signsSymptoms.value
          : this.signsSymptoms,
      timeOfDisease: data.timeOfDisease.present
          ? data.timeOfDisease.value
          : this.timeOfDisease,
      illnessStart: data.illnessStart.present
          ? data.illnessStart.value
          : this.illnessStart,
      illnessCourse: data.illnessCourse.present
          ? data.illnessCourse.value
          : this.illnessCourse,
      story: data.story.present ? data.story.value : this.story,
      physicalExam: data.physicalExam.present
          ? data.physicalExam.value
          : this.physicalExam,
      plan: data.plan.present ? data.plan.value : this.plan,
      bp: data.bp.present ? data.bp.value : this.bp,
      hr: data.hr.present ? data.hr.value : this.hr,
      rr: data.rr.present ? data.rr.value : this.rr,
      o2Sat: data.o2Sat.present ? data.o2Sat.value : this.o2Sat,
      temp: data.temp.present ? data.temp.value : this.temp,
      vitalsJson: data.vitalsJson.present
          ? data.vitalsJson.value
          : this.vitalsJson,
      procedures: data.procedures.present
          ? data.procedures.value
          : this.procedures,
      bedNumber: data.bedNumber.present ? data.bedNumber.value : this.bedNumber,
      dischargedAt: data.dischargedAt.present
          ? data.dischargedAt.value
          : this.dischargedAt,
      uciPriority: data.uciPriority.present
          ? data.uciPriority.value
          : this.uciPriority,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Admission(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('admissionDate: $admissionDate, ')
          ..write('sofaScore: $sofaScore, ')
          ..write('apacheScore: $apacheScore, ')
          ..write('nutricScore: $nutricScore, ')
          ..write('sofaMortality: $sofaMortality, ')
          ..write('apacheMortality: $apacheMortality, ')
          ..write('diagnosis: $diagnosis, ')
          ..write('signsSymptoms: $signsSymptoms, ')
          ..write('timeOfDisease: $timeOfDisease, ')
          ..write('illnessStart: $illnessStart, ')
          ..write('illnessCourse: $illnessCourse, ')
          ..write('story: $story, ')
          ..write('physicalExam: $physicalExam, ')
          ..write('plan: $plan, ')
          ..write('bp: $bp, ')
          ..write('hr: $hr, ')
          ..write('rr: $rr, ')
          ..write('o2Sat: $o2Sat, ')
          ..write('temp: $temp, ')
          ..write('vitalsJson: $vitalsJson, ')
          ..write('procedures: $procedures, ')
          ..write('bedNumber: $bedNumber, ')
          ..write('dischargedAt: $dischargedAt, ')
          ..write('uciPriority: $uciPriority, ')
          ..write('createdAt: $createdAt, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    patientId,
    admissionDate,
    sofaScore,
    apacheScore,
    nutricScore,
    sofaMortality,
    apacheMortality,
    diagnosis,
    signsSymptoms,
    timeOfDisease,
    illnessStart,
    illnessCourse,
    story,
    physicalExam,
    plan,
    bp,
    hr,
    rr,
    o2Sat,
    temp,
    vitalsJson,
    procedures,
    bedNumber,
    dischargedAt,
    uciPriority,
    createdAt,
    isSynced,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Admission &&
          other.id == this.id &&
          other.patientId == this.patientId &&
          other.admissionDate == this.admissionDate &&
          other.sofaScore == this.sofaScore &&
          other.apacheScore == this.apacheScore &&
          other.nutricScore == this.nutricScore &&
          other.sofaMortality == this.sofaMortality &&
          other.apacheMortality == this.apacheMortality &&
          other.diagnosis == this.diagnosis &&
          other.signsSymptoms == this.signsSymptoms &&
          other.timeOfDisease == this.timeOfDisease &&
          other.illnessStart == this.illnessStart &&
          other.illnessCourse == this.illnessCourse &&
          other.story == this.story &&
          other.physicalExam == this.physicalExam &&
          other.plan == this.plan &&
          other.bp == this.bp &&
          other.hr == this.hr &&
          other.rr == this.rr &&
          other.o2Sat == this.o2Sat &&
          other.temp == this.temp &&
          other.vitalsJson == this.vitalsJson &&
          other.procedures == this.procedures &&
          other.bedNumber == this.bedNumber &&
          other.dischargedAt == this.dischargedAt &&
          other.uciPriority == this.uciPriority &&
          other.createdAt == this.createdAt &&
          other.isSynced == this.isSynced);
}

class AdmissionsCompanion extends UpdateCompanion<Admission> {
  final Value<int> id;
  final Value<int> patientId;
  final Value<DateTime> admissionDate;
  final Value<double?> sofaScore;
  final Value<double?> apacheScore;
  final Value<double?> nutricScore;
  final Value<String?> sofaMortality;
  final Value<String?> apacheMortality;
  final Value<String?> diagnosis;
  final Value<String?> signsSymptoms;
  final Value<String?> timeOfDisease;
  final Value<String?> illnessStart;
  final Value<String?> illnessCourse;
  final Value<String?> story;
  final Value<String?> physicalExam;
  final Value<String?> plan;
  final Value<String?> bp;
  final Value<String?> hr;
  final Value<String?> rr;
  final Value<String?> o2Sat;
  final Value<String?> temp;
  final Value<String?> vitalsJson;
  final Value<String?> procedures;
  final Value<int?> bedNumber;
  final Value<DateTime?> dischargedAt;
  final Value<String?> uciPriority;
  final Value<DateTime> createdAt;
  final Value<bool> isSynced;
  const AdmissionsCompanion({
    this.id = const Value.absent(),
    this.patientId = const Value.absent(),
    this.admissionDate = const Value.absent(),
    this.sofaScore = const Value.absent(),
    this.apacheScore = const Value.absent(),
    this.nutricScore = const Value.absent(),
    this.sofaMortality = const Value.absent(),
    this.apacheMortality = const Value.absent(),
    this.diagnosis = const Value.absent(),
    this.signsSymptoms = const Value.absent(),
    this.timeOfDisease = const Value.absent(),
    this.illnessStart = const Value.absent(),
    this.illnessCourse = const Value.absent(),
    this.story = const Value.absent(),
    this.physicalExam = const Value.absent(),
    this.plan = const Value.absent(),
    this.bp = const Value.absent(),
    this.hr = const Value.absent(),
    this.rr = const Value.absent(),
    this.o2Sat = const Value.absent(),
    this.temp = const Value.absent(),
    this.vitalsJson = const Value.absent(),
    this.procedures = const Value.absent(),
    this.bedNumber = const Value.absent(),
    this.dischargedAt = const Value.absent(),
    this.uciPriority = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isSynced = const Value.absent(),
  });
  AdmissionsCompanion.insert({
    this.id = const Value.absent(),
    required int patientId,
    required DateTime admissionDate,
    this.sofaScore = const Value.absent(),
    this.apacheScore = const Value.absent(),
    this.nutricScore = const Value.absent(),
    this.sofaMortality = const Value.absent(),
    this.apacheMortality = const Value.absent(),
    this.diagnosis = const Value.absent(),
    this.signsSymptoms = const Value.absent(),
    this.timeOfDisease = const Value.absent(),
    this.illnessStart = const Value.absent(),
    this.illnessCourse = const Value.absent(),
    this.story = const Value.absent(),
    this.physicalExam = const Value.absent(),
    this.plan = const Value.absent(),
    this.bp = const Value.absent(),
    this.hr = const Value.absent(),
    this.rr = const Value.absent(),
    this.o2Sat = const Value.absent(),
    this.temp = const Value.absent(),
    this.vitalsJson = const Value.absent(),
    this.procedures = const Value.absent(),
    this.bedNumber = const Value.absent(),
    this.dischargedAt = const Value.absent(),
    this.uciPriority = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isSynced = const Value.absent(),
  }) : patientId = Value(patientId),
       admissionDate = Value(admissionDate);
  static Insertable<Admission> custom({
    Expression<int>? id,
    Expression<int>? patientId,
    Expression<DateTime>? admissionDate,
    Expression<double>? sofaScore,
    Expression<double>? apacheScore,
    Expression<double>? nutricScore,
    Expression<String>? sofaMortality,
    Expression<String>? apacheMortality,
    Expression<String>? diagnosis,
    Expression<String>? signsSymptoms,
    Expression<String>? timeOfDisease,
    Expression<String>? illnessStart,
    Expression<String>? illnessCourse,
    Expression<String>? story,
    Expression<String>? physicalExam,
    Expression<String>? plan,
    Expression<String>? bp,
    Expression<String>? hr,
    Expression<String>? rr,
    Expression<String>? o2Sat,
    Expression<String>? temp,
    Expression<String>? vitalsJson,
    Expression<String>? procedures,
    Expression<int>? bedNumber,
    Expression<DateTime>? dischargedAt,
    Expression<String>? uciPriority,
    Expression<DateTime>? createdAt,
    Expression<bool>? isSynced,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (patientId != null) 'patient_id': patientId,
      if (admissionDate != null) 'admission_date': admissionDate,
      if (sofaScore != null) 'sofa_score': sofaScore,
      if (apacheScore != null) 'apache_score': apacheScore,
      if (nutricScore != null) 'nutric_score': nutricScore,
      if (sofaMortality != null) 'sofa_mortality': sofaMortality,
      if (apacheMortality != null) 'apache_mortality': apacheMortality,
      if (diagnosis != null) 'diagnosis': diagnosis,
      if (signsSymptoms != null) 'signs_symptoms': signsSymptoms,
      if (timeOfDisease != null) 'time_of_disease': timeOfDisease,
      if (illnessStart != null) 'illness_start': illnessStart,
      if (illnessCourse != null) 'illness_course': illnessCourse,
      if (story != null) 'story': story,
      if (physicalExam != null) 'physical_exam': physicalExam,
      if (plan != null) 'plan': plan,
      if (bp != null) 'bp': bp,
      if (hr != null) 'hr': hr,
      if (rr != null) 'rr': rr,
      if (o2Sat != null) 'o2_sat': o2Sat,
      if (temp != null) 'temp': temp,
      if (vitalsJson != null) 'vitals_json': vitalsJson,
      if (procedures != null) 'procedures': procedures,
      if (bedNumber != null) 'bed_number': bedNumber,
      if (dischargedAt != null) 'discharged_at': dischargedAt,
      if (uciPriority != null) 'uci_priority': uciPriority,
      if (createdAt != null) 'created_at': createdAt,
      if (isSynced != null) 'is_synced': isSynced,
    });
  }

  AdmissionsCompanion copyWith({
    Value<int>? id,
    Value<int>? patientId,
    Value<DateTime>? admissionDate,
    Value<double?>? sofaScore,
    Value<double?>? apacheScore,
    Value<double?>? nutricScore,
    Value<String?>? sofaMortality,
    Value<String?>? apacheMortality,
    Value<String?>? diagnosis,
    Value<String?>? signsSymptoms,
    Value<String?>? timeOfDisease,
    Value<String?>? illnessStart,
    Value<String?>? illnessCourse,
    Value<String?>? story,
    Value<String?>? physicalExam,
    Value<String?>? plan,
    Value<String?>? bp,
    Value<String?>? hr,
    Value<String?>? rr,
    Value<String?>? o2Sat,
    Value<String?>? temp,
    Value<String?>? vitalsJson,
    Value<String?>? procedures,
    Value<int?>? bedNumber,
    Value<DateTime?>? dischargedAt,
    Value<String?>? uciPriority,
    Value<DateTime>? createdAt,
    Value<bool>? isSynced,
  }) {
    return AdmissionsCompanion(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      admissionDate: admissionDate ?? this.admissionDate,
      sofaScore: sofaScore ?? this.sofaScore,
      apacheScore: apacheScore ?? this.apacheScore,
      nutricScore: nutricScore ?? this.nutricScore,
      sofaMortality: sofaMortality ?? this.sofaMortality,
      apacheMortality: apacheMortality ?? this.apacheMortality,
      diagnosis: diagnosis ?? this.diagnosis,
      signsSymptoms: signsSymptoms ?? this.signsSymptoms,
      timeOfDisease: timeOfDisease ?? this.timeOfDisease,
      illnessStart: illnessStart ?? this.illnessStart,
      illnessCourse: illnessCourse ?? this.illnessCourse,
      story: story ?? this.story,
      physicalExam: physicalExam ?? this.physicalExam,
      plan: plan ?? this.plan,
      bp: bp ?? this.bp,
      hr: hr ?? this.hr,
      rr: rr ?? this.rr,
      o2Sat: o2Sat ?? this.o2Sat,
      temp: temp ?? this.temp,
      vitalsJson: vitalsJson ?? this.vitalsJson,
      procedures: procedures ?? this.procedures,
      bedNumber: bedNumber ?? this.bedNumber,
      dischargedAt: dischargedAt ?? this.dischargedAt,
      uciPriority: uciPriority ?? this.uciPriority,
      createdAt: createdAt ?? this.createdAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (patientId.present) {
      map['patient_id'] = Variable<int>(patientId.value);
    }
    if (admissionDate.present) {
      map['admission_date'] = Variable<DateTime>(admissionDate.value);
    }
    if (sofaScore.present) {
      map['sofa_score'] = Variable<double>(sofaScore.value);
    }
    if (apacheScore.present) {
      map['apache_score'] = Variable<double>(apacheScore.value);
    }
    if (nutricScore.present) {
      map['nutric_score'] = Variable<double>(nutricScore.value);
    }
    if (sofaMortality.present) {
      map['sofa_mortality'] = Variable<String>(sofaMortality.value);
    }
    if (apacheMortality.present) {
      map['apache_mortality'] = Variable<String>(apacheMortality.value);
    }
    if (diagnosis.present) {
      map['diagnosis'] = Variable<String>(diagnosis.value);
    }
    if (signsSymptoms.present) {
      map['signs_symptoms'] = Variable<String>(signsSymptoms.value);
    }
    if (timeOfDisease.present) {
      map['time_of_disease'] = Variable<String>(timeOfDisease.value);
    }
    if (illnessStart.present) {
      map['illness_start'] = Variable<String>(illnessStart.value);
    }
    if (illnessCourse.present) {
      map['illness_course'] = Variable<String>(illnessCourse.value);
    }
    if (story.present) {
      map['story'] = Variable<String>(story.value);
    }
    if (physicalExam.present) {
      map['physical_exam'] = Variable<String>(physicalExam.value);
    }
    if (plan.present) {
      map['plan'] = Variable<String>(plan.value);
    }
    if (bp.present) {
      map['bp'] = Variable<String>(bp.value);
    }
    if (hr.present) {
      map['hr'] = Variable<String>(hr.value);
    }
    if (rr.present) {
      map['rr'] = Variable<String>(rr.value);
    }
    if (o2Sat.present) {
      map['o2_sat'] = Variable<String>(o2Sat.value);
    }
    if (temp.present) {
      map['temp'] = Variable<String>(temp.value);
    }
    if (vitalsJson.present) {
      map['vitals_json'] = Variable<String>(vitalsJson.value);
    }
    if (procedures.present) {
      map['procedures'] = Variable<String>(procedures.value);
    }
    if (bedNumber.present) {
      map['bed_number'] = Variable<int>(bedNumber.value);
    }
    if (dischargedAt.present) {
      map['discharged_at'] = Variable<DateTime>(dischargedAt.value);
    }
    if (uciPriority.present) {
      map['uci_priority'] = Variable<String>(uciPriority.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AdmissionsCompanion(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('admissionDate: $admissionDate, ')
          ..write('sofaScore: $sofaScore, ')
          ..write('apacheScore: $apacheScore, ')
          ..write('nutricScore: $nutricScore, ')
          ..write('sofaMortality: $sofaMortality, ')
          ..write('apacheMortality: $apacheMortality, ')
          ..write('diagnosis: $diagnosis, ')
          ..write('signsSymptoms: $signsSymptoms, ')
          ..write('timeOfDisease: $timeOfDisease, ')
          ..write('illnessStart: $illnessStart, ')
          ..write('illnessCourse: $illnessCourse, ')
          ..write('story: $story, ')
          ..write('physicalExam: $physicalExam, ')
          ..write('plan: $plan, ')
          ..write('bp: $bp, ')
          ..write('hr: $hr, ')
          ..write('rr: $rr, ')
          ..write('o2Sat: $o2Sat, ')
          ..write('temp: $temp, ')
          ..write('vitalsJson: $vitalsJson, ')
          ..write('procedures: $procedures, ')
          ..write('bedNumber: $bedNumber, ')
          ..write('dischargedAt: $dischargedAt, ')
          ..write('uciPriority: $uciPriority, ')
          ..write('createdAt: $createdAt, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }
}

class $EvolutionsTable extends Evolutions
    with TableInfo<$EvolutionsTable, Evolution> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EvolutionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _admissionIdMeta = const VerificationMeta(
    'admissionId',
  );
  @override
  late final GeneratedColumn<int> admissionId = GeneratedColumn<int>(
    'admission_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES admissions (id)',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _dayOfStayMeta = const VerificationMeta(
    'dayOfStay',
  );
  @override
  late final GeneratedColumn<int> dayOfStay = GeneratedColumn<int>(
    'day_of_stay',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _vitalsJsonMeta = const VerificationMeta(
    'vitalsJson',
  );
  @override
  late final GeneratedColumn<String> vitalsJson = GeneratedColumn<String>(
    'vitals_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _vmSettingsJsonMeta = const VerificationMeta(
    'vmSettingsJson',
  );
  @override
  late final GeneratedColumn<String> vmSettingsJson = GeneratedColumn<String>(
    'vm_settings_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _vmMechanicsJsonMeta = const VerificationMeta(
    'vmMechanicsJson',
  );
  @override
  late final GeneratedColumn<String> vmMechanicsJson = GeneratedColumn<String>(
    'vm_mechanics_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _subjectiveMeta = const VerificationMeta(
    'subjective',
  );
  @override
  late final GeneratedColumn<String> subjective = GeneratedColumn<String>(
    'subjective',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _objectiveJsonMeta = const VerificationMeta(
    'objectiveJson',
  );
  @override
  late final GeneratedColumn<String> objectiveJson = GeneratedColumn<String>(
    'objective_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _analysisMeta = const VerificationMeta(
    'analysis',
  );
  @override
  late final GeneratedColumn<String> analysis = GeneratedColumn<String>(
    'analysis',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _planMeta = const VerificationMeta('plan');
  @override
  late final GeneratedColumn<String> plan = GeneratedColumn<String>(
    'plan',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _proceduresNoteMeta = const VerificationMeta(
    'proceduresNote',
  );
  @override
  late final GeneratedColumn<String> proceduresNote = GeneratedColumn<String>(
    'procedures_note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _diagnosisMeta = const VerificationMeta(
    'diagnosis',
  );
  @override
  late final GeneratedColumn<String> diagnosis = GeneratedColumn<String>(
    'diagnosis',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _authorNameMeta = const VerificationMeta(
    'authorName',
  );
  @override
  late final GeneratedColumn<String> authorName = GeneratedColumn<String>(
    'author_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _authorRoleMeta = const VerificationMeta(
    'authorRole',
  );
  @override
  late final GeneratedColumn<String> authorRole = GeneratedColumn<String>(
    'author_role',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    admissionId,
    date,
    dayOfStay,
    vitalsJson,
    vmSettingsJson,
    vmMechanicsJson,
    subjective,
    objectiveJson,
    analysis,
    plan,
    proceduresNote,
    diagnosis,
    authorName,
    authorRole,
    createdAt,
    isSynced,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'evolutions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Evolution> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('admission_id')) {
      context.handle(
        _admissionIdMeta,
        admissionId.isAcceptableOrUnknown(
          data['admission_id']!,
          _admissionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_admissionIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    }
    if (data.containsKey('day_of_stay')) {
      context.handle(
        _dayOfStayMeta,
        dayOfStay.isAcceptableOrUnknown(data['day_of_stay']!, _dayOfStayMeta),
      );
    }
    if (data.containsKey('vitals_json')) {
      context.handle(
        _vitalsJsonMeta,
        vitalsJson.isAcceptableOrUnknown(data['vitals_json']!, _vitalsJsonMeta),
      );
    }
    if (data.containsKey('vm_settings_json')) {
      context.handle(
        _vmSettingsJsonMeta,
        vmSettingsJson.isAcceptableOrUnknown(
          data['vm_settings_json']!,
          _vmSettingsJsonMeta,
        ),
      );
    }
    if (data.containsKey('vm_mechanics_json')) {
      context.handle(
        _vmMechanicsJsonMeta,
        vmMechanicsJson.isAcceptableOrUnknown(
          data['vm_mechanics_json']!,
          _vmMechanicsJsonMeta,
        ),
      );
    }
    if (data.containsKey('subjective')) {
      context.handle(
        _subjectiveMeta,
        subjective.isAcceptableOrUnknown(data['subjective']!, _subjectiveMeta),
      );
    }
    if (data.containsKey('objective_json')) {
      context.handle(
        _objectiveJsonMeta,
        objectiveJson.isAcceptableOrUnknown(
          data['objective_json']!,
          _objectiveJsonMeta,
        ),
      );
    }
    if (data.containsKey('analysis')) {
      context.handle(
        _analysisMeta,
        analysis.isAcceptableOrUnknown(data['analysis']!, _analysisMeta),
      );
    }
    if (data.containsKey('plan')) {
      context.handle(
        _planMeta,
        plan.isAcceptableOrUnknown(data['plan']!, _planMeta),
      );
    }
    if (data.containsKey('procedures_note')) {
      context.handle(
        _proceduresNoteMeta,
        proceduresNote.isAcceptableOrUnknown(
          data['procedures_note']!,
          _proceduresNoteMeta,
        ),
      );
    }
    if (data.containsKey('diagnosis')) {
      context.handle(
        _diagnosisMeta,
        diagnosis.isAcceptableOrUnknown(data['diagnosis']!, _diagnosisMeta),
      );
    }
    if (data.containsKey('author_name')) {
      context.handle(
        _authorNameMeta,
        authorName.isAcceptableOrUnknown(data['author_name']!, _authorNameMeta),
      );
    }
    if (data.containsKey('author_role')) {
      context.handle(
        _authorRoleMeta,
        authorRole.isAcceptableOrUnknown(data['author_role']!, _authorRoleMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Evolution map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Evolution(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      admissionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}admission_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      dayOfStay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}day_of_stay'],
      ),
      vitalsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vitals_json'],
      ),
      vmSettingsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vm_settings_json'],
      ),
      vmMechanicsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vm_mechanics_json'],
      ),
      subjective: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subjective'],
      ),
      objectiveJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}objective_json'],
      ),
      analysis: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}analysis'],
      ),
      plan: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plan'],
      ),
      proceduresNote: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}procedures_note'],
      ),
      diagnosis: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}diagnosis'],
      ),
      authorName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}author_name'],
      ),
      authorRole: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}author_role'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
    );
  }

  @override
  $EvolutionsTable createAlias(String alias) {
    return $EvolutionsTable(attachedDatabase, alias);
  }
}

class Evolution extends DataClass implements Insertable<Evolution> {
  final int id;
  final int admissionId;
  final DateTime date;
  final int? dayOfStay;
  final String? vitalsJson;
  final String? vmSettingsJson;
  final String? vmMechanicsJson;
  final String? subjective;
  final String? objectiveJson;
  final String? analysis;
  final String? plan;
  final String? proceduresNote;
  final String? diagnosis;
  final String? authorName;
  final String? authorRole;
  final DateTime createdAt;
  final bool isSynced;
  const Evolution({
    required this.id,
    required this.admissionId,
    required this.date,
    this.dayOfStay,
    this.vitalsJson,
    this.vmSettingsJson,
    this.vmMechanicsJson,
    this.subjective,
    this.objectiveJson,
    this.analysis,
    this.plan,
    this.proceduresNote,
    this.diagnosis,
    this.authorName,
    this.authorRole,
    required this.createdAt,
    required this.isSynced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['admission_id'] = Variable<int>(admissionId);
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || dayOfStay != null) {
      map['day_of_stay'] = Variable<int>(dayOfStay);
    }
    if (!nullToAbsent || vitalsJson != null) {
      map['vitals_json'] = Variable<String>(vitalsJson);
    }
    if (!nullToAbsent || vmSettingsJson != null) {
      map['vm_settings_json'] = Variable<String>(vmSettingsJson);
    }
    if (!nullToAbsent || vmMechanicsJson != null) {
      map['vm_mechanics_json'] = Variable<String>(vmMechanicsJson);
    }
    if (!nullToAbsent || subjective != null) {
      map['subjective'] = Variable<String>(subjective);
    }
    if (!nullToAbsent || objectiveJson != null) {
      map['objective_json'] = Variable<String>(objectiveJson);
    }
    if (!nullToAbsent || analysis != null) {
      map['analysis'] = Variable<String>(analysis);
    }
    if (!nullToAbsent || plan != null) {
      map['plan'] = Variable<String>(plan);
    }
    if (!nullToAbsent || proceduresNote != null) {
      map['procedures_note'] = Variable<String>(proceduresNote);
    }
    if (!nullToAbsent || diagnosis != null) {
      map['diagnosis'] = Variable<String>(diagnosis);
    }
    if (!nullToAbsent || authorName != null) {
      map['author_name'] = Variable<String>(authorName);
    }
    if (!nullToAbsent || authorRole != null) {
      map['author_role'] = Variable<String>(authorRole);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['is_synced'] = Variable<bool>(isSynced);
    return map;
  }

  EvolutionsCompanion toCompanion(bool nullToAbsent) {
    return EvolutionsCompanion(
      id: Value(id),
      admissionId: Value(admissionId),
      date: Value(date),
      dayOfStay: dayOfStay == null && nullToAbsent
          ? const Value.absent()
          : Value(dayOfStay),
      vitalsJson: vitalsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(vitalsJson),
      vmSettingsJson: vmSettingsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(vmSettingsJson),
      vmMechanicsJson: vmMechanicsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(vmMechanicsJson),
      subjective: subjective == null && nullToAbsent
          ? const Value.absent()
          : Value(subjective),
      objectiveJson: objectiveJson == null && nullToAbsent
          ? const Value.absent()
          : Value(objectiveJson),
      analysis: analysis == null && nullToAbsent
          ? const Value.absent()
          : Value(analysis),
      plan: plan == null && nullToAbsent ? const Value.absent() : Value(plan),
      proceduresNote: proceduresNote == null && nullToAbsent
          ? const Value.absent()
          : Value(proceduresNote),
      diagnosis: diagnosis == null && nullToAbsent
          ? const Value.absent()
          : Value(diagnosis),
      authorName: authorName == null && nullToAbsent
          ? const Value.absent()
          : Value(authorName),
      authorRole: authorRole == null && nullToAbsent
          ? const Value.absent()
          : Value(authorRole),
      createdAt: Value(createdAt),
      isSynced: Value(isSynced),
    );
  }

  factory Evolution.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Evolution(
      id: serializer.fromJson<int>(json['id']),
      admissionId: serializer.fromJson<int>(json['admissionId']),
      date: serializer.fromJson<DateTime>(json['date']),
      dayOfStay: serializer.fromJson<int?>(json['dayOfStay']),
      vitalsJson: serializer.fromJson<String?>(json['vitalsJson']),
      vmSettingsJson: serializer.fromJson<String?>(json['vmSettingsJson']),
      vmMechanicsJson: serializer.fromJson<String?>(json['vmMechanicsJson']),
      subjective: serializer.fromJson<String?>(json['subjective']),
      objectiveJson: serializer.fromJson<String?>(json['objectiveJson']),
      analysis: serializer.fromJson<String?>(json['analysis']),
      plan: serializer.fromJson<String?>(json['plan']),
      proceduresNote: serializer.fromJson<String?>(json['proceduresNote']),
      diagnosis: serializer.fromJson<String?>(json['diagnosis']),
      authorName: serializer.fromJson<String?>(json['authorName']),
      authorRole: serializer.fromJson<String?>(json['authorRole']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'admissionId': serializer.toJson<int>(admissionId),
      'date': serializer.toJson<DateTime>(date),
      'dayOfStay': serializer.toJson<int?>(dayOfStay),
      'vitalsJson': serializer.toJson<String?>(vitalsJson),
      'vmSettingsJson': serializer.toJson<String?>(vmSettingsJson),
      'vmMechanicsJson': serializer.toJson<String?>(vmMechanicsJson),
      'subjective': serializer.toJson<String?>(subjective),
      'objectiveJson': serializer.toJson<String?>(objectiveJson),
      'analysis': serializer.toJson<String?>(analysis),
      'plan': serializer.toJson<String?>(plan),
      'proceduresNote': serializer.toJson<String?>(proceduresNote),
      'diagnosis': serializer.toJson<String?>(diagnosis),
      'authorName': serializer.toJson<String?>(authorName),
      'authorRole': serializer.toJson<String?>(authorRole),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'isSynced': serializer.toJson<bool>(isSynced),
    };
  }

  Evolution copyWith({
    int? id,
    int? admissionId,
    DateTime? date,
    Value<int?> dayOfStay = const Value.absent(),
    Value<String?> vitalsJson = const Value.absent(),
    Value<String?> vmSettingsJson = const Value.absent(),
    Value<String?> vmMechanicsJson = const Value.absent(),
    Value<String?> subjective = const Value.absent(),
    Value<String?> objectiveJson = const Value.absent(),
    Value<String?> analysis = const Value.absent(),
    Value<String?> plan = const Value.absent(),
    Value<String?> proceduresNote = const Value.absent(),
    Value<String?> diagnosis = const Value.absent(),
    Value<String?> authorName = const Value.absent(),
    Value<String?> authorRole = const Value.absent(),
    DateTime? createdAt,
    bool? isSynced,
  }) => Evolution(
    id: id ?? this.id,
    admissionId: admissionId ?? this.admissionId,
    date: date ?? this.date,
    dayOfStay: dayOfStay.present ? dayOfStay.value : this.dayOfStay,
    vitalsJson: vitalsJson.present ? vitalsJson.value : this.vitalsJson,
    vmSettingsJson: vmSettingsJson.present
        ? vmSettingsJson.value
        : this.vmSettingsJson,
    vmMechanicsJson: vmMechanicsJson.present
        ? vmMechanicsJson.value
        : this.vmMechanicsJson,
    subjective: subjective.present ? subjective.value : this.subjective,
    objectiveJson: objectiveJson.present
        ? objectiveJson.value
        : this.objectiveJson,
    analysis: analysis.present ? analysis.value : this.analysis,
    plan: plan.present ? plan.value : this.plan,
    proceduresNote: proceduresNote.present
        ? proceduresNote.value
        : this.proceduresNote,
    diagnosis: diagnosis.present ? diagnosis.value : this.diagnosis,
    authorName: authorName.present ? authorName.value : this.authorName,
    authorRole: authorRole.present ? authorRole.value : this.authorRole,
    createdAt: createdAt ?? this.createdAt,
    isSynced: isSynced ?? this.isSynced,
  );
  Evolution copyWithCompanion(EvolutionsCompanion data) {
    return Evolution(
      id: data.id.present ? data.id.value : this.id,
      admissionId: data.admissionId.present
          ? data.admissionId.value
          : this.admissionId,
      date: data.date.present ? data.date.value : this.date,
      dayOfStay: data.dayOfStay.present ? data.dayOfStay.value : this.dayOfStay,
      vitalsJson: data.vitalsJson.present
          ? data.vitalsJson.value
          : this.vitalsJson,
      vmSettingsJson: data.vmSettingsJson.present
          ? data.vmSettingsJson.value
          : this.vmSettingsJson,
      vmMechanicsJson: data.vmMechanicsJson.present
          ? data.vmMechanicsJson.value
          : this.vmMechanicsJson,
      subjective: data.subjective.present
          ? data.subjective.value
          : this.subjective,
      objectiveJson: data.objectiveJson.present
          ? data.objectiveJson.value
          : this.objectiveJson,
      analysis: data.analysis.present ? data.analysis.value : this.analysis,
      plan: data.plan.present ? data.plan.value : this.plan,
      proceduresNote: data.proceduresNote.present
          ? data.proceduresNote.value
          : this.proceduresNote,
      diagnosis: data.diagnosis.present ? data.diagnosis.value : this.diagnosis,
      authorName: data.authorName.present
          ? data.authorName.value
          : this.authorName,
      authorRole: data.authorRole.present
          ? data.authorRole.value
          : this.authorRole,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Evolution(')
          ..write('id: $id, ')
          ..write('admissionId: $admissionId, ')
          ..write('date: $date, ')
          ..write('dayOfStay: $dayOfStay, ')
          ..write('vitalsJson: $vitalsJson, ')
          ..write('vmSettingsJson: $vmSettingsJson, ')
          ..write('vmMechanicsJson: $vmMechanicsJson, ')
          ..write('subjective: $subjective, ')
          ..write('objectiveJson: $objectiveJson, ')
          ..write('analysis: $analysis, ')
          ..write('plan: $plan, ')
          ..write('proceduresNote: $proceduresNote, ')
          ..write('diagnosis: $diagnosis, ')
          ..write('authorName: $authorName, ')
          ..write('authorRole: $authorRole, ')
          ..write('createdAt: $createdAt, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    admissionId,
    date,
    dayOfStay,
    vitalsJson,
    vmSettingsJson,
    vmMechanicsJson,
    subjective,
    objectiveJson,
    analysis,
    plan,
    proceduresNote,
    diagnosis,
    authorName,
    authorRole,
    createdAt,
    isSynced,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Evolution &&
          other.id == this.id &&
          other.admissionId == this.admissionId &&
          other.date == this.date &&
          other.dayOfStay == this.dayOfStay &&
          other.vitalsJson == this.vitalsJson &&
          other.vmSettingsJson == this.vmSettingsJson &&
          other.vmMechanicsJson == this.vmMechanicsJson &&
          other.subjective == this.subjective &&
          other.objectiveJson == this.objectiveJson &&
          other.analysis == this.analysis &&
          other.plan == this.plan &&
          other.proceduresNote == this.proceduresNote &&
          other.diagnosis == this.diagnosis &&
          other.authorName == this.authorName &&
          other.authorRole == this.authorRole &&
          other.createdAt == this.createdAt &&
          other.isSynced == this.isSynced);
}

class EvolutionsCompanion extends UpdateCompanion<Evolution> {
  final Value<int> id;
  final Value<int> admissionId;
  final Value<DateTime> date;
  final Value<int?> dayOfStay;
  final Value<String?> vitalsJson;
  final Value<String?> vmSettingsJson;
  final Value<String?> vmMechanicsJson;
  final Value<String?> subjective;
  final Value<String?> objectiveJson;
  final Value<String?> analysis;
  final Value<String?> plan;
  final Value<String?> proceduresNote;
  final Value<String?> diagnosis;
  final Value<String?> authorName;
  final Value<String?> authorRole;
  final Value<DateTime> createdAt;
  final Value<bool> isSynced;
  const EvolutionsCompanion({
    this.id = const Value.absent(),
    this.admissionId = const Value.absent(),
    this.date = const Value.absent(),
    this.dayOfStay = const Value.absent(),
    this.vitalsJson = const Value.absent(),
    this.vmSettingsJson = const Value.absent(),
    this.vmMechanicsJson = const Value.absent(),
    this.subjective = const Value.absent(),
    this.objectiveJson = const Value.absent(),
    this.analysis = const Value.absent(),
    this.plan = const Value.absent(),
    this.proceduresNote = const Value.absent(),
    this.diagnosis = const Value.absent(),
    this.authorName = const Value.absent(),
    this.authorRole = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isSynced = const Value.absent(),
  });
  EvolutionsCompanion.insert({
    this.id = const Value.absent(),
    required int admissionId,
    this.date = const Value.absent(),
    this.dayOfStay = const Value.absent(),
    this.vitalsJson = const Value.absent(),
    this.vmSettingsJson = const Value.absent(),
    this.vmMechanicsJson = const Value.absent(),
    this.subjective = const Value.absent(),
    this.objectiveJson = const Value.absent(),
    this.analysis = const Value.absent(),
    this.plan = const Value.absent(),
    this.proceduresNote = const Value.absent(),
    this.diagnosis = const Value.absent(),
    this.authorName = const Value.absent(),
    this.authorRole = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isSynced = const Value.absent(),
  }) : admissionId = Value(admissionId);
  static Insertable<Evolution> custom({
    Expression<int>? id,
    Expression<int>? admissionId,
    Expression<DateTime>? date,
    Expression<int>? dayOfStay,
    Expression<String>? vitalsJson,
    Expression<String>? vmSettingsJson,
    Expression<String>? vmMechanicsJson,
    Expression<String>? subjective,
    Expression<String>? objectiveJson,
    Expression<String>? analysis,
    Expression<String>? plan,
    Expression<String>? proceduresNote,
    Expression<String>? diagnosis,
    Expression<String>? authorName,
    Expression<String>? authorRole,
    Expression<DateTime>? createdAt,
    Expression<bool>? isSynced,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (admissionId != null) 'admission_id': admissionId,
      if (date != null) 'date': date,
      if (dayOfStay != null) 'day_of_stay': dayOfStay,
      if (vitalsJson != null) 'vitals_json': vitalsJson,
      if (vmSettingsJson != null) 'vm_settings_json': vmSettingsJson,
      if (vmMechanicsJson != null) 'vm_mechanics_json': vmMechanicsJson,
      if (subjective != null) 'subjective': subjective,
      if (objectiveJson != null) 'objective_json': objectiveJson,
      if (analysis != null) 'analysis': analysis,
      if (plan != null) 'plan': plan,
      if (proceduresNote != null) 'procedures_note': proceduresNote,
      if (diagnosis != null) 'diagnosis': diagnosis,
      if (authorName != null) 'author_name': authorName,
      if (authorRole != null) 'author_role': authorRole,
      if (createdAt != null) 'created_at': createdAt,
      if (isSynced != null) 'is_synced': isSynced,
    });
  }

  EvolutionsCompanion copyWith({
    Value<int>? id,
    Value<int>? admissionId,
    Value<DateTime>? date,
    Value<int?>? dayOfStay,
    Value<String?>? vitalsJson,
    Value<String?>? vmSettingsJson,
    Value<String?>? vmMechanicsJson,
    Value<String?>? subjective,
    Value<String?>? objectiveJson,
    Value<String?>? analysis,
    Value<String?>? plan,
    Value<String?>? proceduresNote,
    Value<String?>? diagnosis,
    Value<String?>? authorName,
    Value<String?>? authorRole,
    Value<DateTime>? createdAt,
    Value<bool>? isSynced,
  }) {
    return EvolutionsCompanion(
      id: id ?? this.id,
      admissionId: admissionId ?? this.admissionId,
      date: date ?? this.date,
      dayOfStay: dayOfStay ?? this.dayOfStay,
      vitalsJson: vitalsJson ?? this.vitalsJson,
      vmSettingsJson: vmSettingsJson ?? this.vmSettingsJson,
      vmMechanicsJson: vmMechanicsJson ?? this.vmMechanicsJson,
      subjective: subjective ?? this.subjective,
      objectiveJson: objectiveJson ?? this.objectiveJson,
      analysis: analysis ?? this.analysis,
      plan: plan ?? this.plan,
      proceduresNote: proceduresNote ?? this.proceduresNote,
      diagnosis: diagnosis ?? this.diagnosis,
      authorName: authorName ?? this.authorName,
      authorRole: authorRole ?? this.authorRole,
      createdAt: createdAt ?? this.createdAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (admissionId.present) {
      map['admission_id'] = Variable<int>(admissionId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (dayOfStay.present) {
      map['day_of_stay'] = Variable<int>(dayOfStay.value);
    }
    if (vitalsJson.present) {
      map['vitals_json'] = Variable<String>(vitalsJson.value);
    }
    if (vmSettingsJson.present) {
      map['vm_settings_json'] = Variable<String>(vmSettingsJson.value);
    }
    if (vmMechanicsJson.present) {
      map['vm_mechanics_json'] = Variable<String>(vmMechanicsJson.value);
    }
    if (subjective.present) {
      map['subjective'] = Variable<String>(subjective.value);
    }
    if (objectiveJson.present) {
      map['objective_json'] = Variable<String>(objectiveJson.value);
    }
    if (analysis.present) {
      map['analysis'] = Variable<String>(analysis.value);
    }
    if (plan.present) {
      map['plan'] = Variable<String>(plan.value);
    }
    if (proceduresNote.present) {
      map['procedures_note'] = Variable<String>(proceduresNote.value);
    }
    if (diagnosis.present) {
      map['diagnosis'] = Variable<String>(diagnosis.value);
    }
    if (authorName.present) {
      map['author_name'] = Variable<String>(authorName.value);
    }
    if (authorRole.present) {
      map['author_role'] = Variable<String>(authorRole.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EvolutionsCompanion(')
          ..write('id: $id, ')
          ..write('admissionId: $admissionId, ')
          ..write('date: $date, ')
          ..write('dayOfStay: $dayOfStay, ')
          ..write('vitalsJson: $vitalsJson, ')
          ..write('vmSettingsJson: $vmSettingsJson, ')
          ..write('vmMechanicsJson: $vmMechanicsJson, ')
          ..write('subjective: $subjective, ')
          ..write('objectiveJson: $objectiveJson, ')
          ..write('analysis: $analysis, ')
          ..write('plan: $plan, ')
          ..write('proceduresNote: $proceduresNote, ')
          ..write('diagnosis: $diagnosis, ')
          ..write('authorName: $authorName, ')
          ..write('authorRole: $authorRole, ')
          ..write('createdAt: $createdAt, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }
}

class $IndicationSheetsTable extends IndicationSheets
    with TableInfo<$IndicationSheetsTable, IndicationSheet> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IndicationSheetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _admissionIdMeta = const VerificationMeta(
    'admissionId',
  );
  @override
  late final GeneratedColumn<int> admissionId = GeneratedColumn<int>(
    'admission_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES admissions (id)',
    ),
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    admissionId,
    payload,
    createdAt,
    isSynced,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'indication_sheets';
  @override
  VerificationContext validateIntegrity(
    Insertable<IndicationSheet> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('admission_id')) {
      context.handle(
        _admissionIdMeta,
        admissionId.isAcceptableOrUnknown(
          data['admission_id']!,
          _admissionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_admissionIdMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  IndicationSheet map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IndicationSheet(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      admissionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}admission_id'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
    );
  }

  @override
  $IndicationSheetsTable createAlias(String alias) {
    return $IndicationSheetsTable(attachedDatabase, alias);
  }
}

class IndicationSheet extends DataClass implements Insertable<IndicationSheet> {
  final int id;
  final int admissionId;
  final String payload;
  final DateTime createdAt;
  final bool isSynced;
  const IndicationSheet({
    required this.id,
    required this.admissionId,
    required this.payload,
    required this.createdAt,
    required this.isSynced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['admission_id'] = Variable<int>(admissionId);
    map['payload'] = Variable<String>(payload);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['is_synced'] = Variable<bool>(isSynced);
    return map;
  }

  IndicationSheetsCompanion toCompanion(bool nullToAbsent) {
    return IndicationSheetsCompanion(
      id: Value(id),
      admissionId: Value(admissionId),
      payload: Value(payload),
      createdAt: Value(createdAt),
      isSynced: Value(isSynced),
    );
  }

  factory IndicationSheet.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return IndicationSheet(
      id: serializer.fromJson<int>(json['id']),
      admissionId: serializer.fromJson<int>(json['admissionId']),
      payload: serializer.fromJson<String>(json['payload']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'admissionId': serializer.toJson<int>(admissionId),
      'payload': serializer.toJson<String>(payload),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'isSynced': serializer.toJson<bool>(isSynced),
    };
  }

  IndicationSheet copyWith({
    int? id,
    int? admissionId,
    String? payload,
    DateTime? createdAt,
    bool? isSynced,
  }) => IndicationSheet(
    id: id ?? this.id,
    admissionId: admissionId ?? this.admissionId,
    payload: payload ?? this.payload,
    createdAt: createdAt ?? this.createdAt,
    isSynced: isSynced ?? this.isSynced,
  );
  IndicationSheet copyWithCompanion(IndicationSheetsCompanion data) {
    return IndicationSheet(
      id: data.id.present ? data.id.value : this.id,
      admissionId: data.admissionId.present
          ? data.admissionId.value
          : this.admissionId,
      payload: data.payload.present ? data.payload.value : this.payload,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('IndicationSheet(')
          ..write('id: $id, ')
          ..write('admissionId: $admissionId, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, admissionId, payload, createdAt, isSynced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IndicationSheet &&
          other.id == this.id &&
          other.admissionId == this.admissionId &&
          other.payload == this.payload &&
          other.createdAt == this.createdAt &&
          other.isSynced == this.isSynced);
}

class IndicationSheetsCompanion extends UpdateCompanion<IndicationSheet> {
  final Value<int> id;
  final Value<int> admissionId;
  final Value<String> payload;
  final Value<DateTime> createdAt;
  final Value<bool> isSynced;
  const IndicationSheetsCompanion({
    this.id = const Value.absent(),
    this.admissionId = const Value.absent(),
    this.payload = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isSynced = const Value.absent(),
  });
  IndicationSheetsCompanion.insert({
    this.id = const Value.absent(),
    required int admissionId,
    required String payload,
    this.createdAt = const Value.absent(),
    this.isSynced = const Value.absent(),
  }) : admissionId = Value(admissionId),
       payload = Value(payload);
  static Insertable<IndicationSheet> custom({
    Expression<int>? id,
    Expression<int>? admissionId,
    Expression<String>? payload,
    Expression<DateTime>? createdAt,
    Expression<bool>? isSynced,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (admissionId != null) 'admission_id': admissionId,
      if (payload != null) 'payload': payload,
      if (createdAt != null) 'created_at': createdAt,
      if (isSynced != null) 'is_synced': isSynced,
    });
  }

  IndicationSheetsCompanion copyWith({
    Value<int>? id,
    Value<int>? admissionId,
    Value<String>? payload,
    Value<DateTime>? createdAt,
    Value<bool>? isSynced,
  }) {
    return IndicationSheetsCompanion(
      id: id ?? this.id,
      admissionId: admissionId ?? this.admissionId,
      payload: payload ?? this.payload,
      createdAt: createdAt ?? this.createdAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (admissionId.present) {
      map['admission_id'] = Variable<int>(admissionId.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IndicationSheetsCompanion(')
          ..write('id: $id, ')
          ..write('admissionId: $admissionId, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }
}

class $EpicrisisNotesTable extends EpicrisisNotes
    with TableInfo<$EpicrisisNotesTable, EpicrisisNote> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EpicrisisNotesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _admissionIdMeta = const VerificationMeta(
    'admissionId',
  );
  @override
  late final GeneratedColumn<int> admissionId = GeneratedColumn<int>(
    'admission_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES admissions (id)',
    ),
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    admissionId,
    payload,
    createdAt,
    updatedAt,
    isSynced,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'epicrisis_notes';
  @override
  VerificationContext validateIntegrity(
    Insertable<EpicrisisNote> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('admission_id')) {
      context.handle(
        _admissionIdMeta,
        admissionId.isAcceptableOrUnknown(
          data['admission_id']!,
          _admissionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_admissionIdMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EpicrisisNote map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EpicrisisNote(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      admissionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}admission_id'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
    );
  }

  @override
  $EpicrisisNotesTable createAlias(String alias) {
    return $EpicrisisNotesTable(attachedDatabase, alias);
  }
}

class EpicrisisNote extends DataClass implements Insertable<EpicrisisNote> {
  final int id;
  final int admissionId;
  final String payload;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isSynced;
  const EpicrisisNote({
    required this.id,
    required this.admissionId,
    required this.payload,
    required this.createdAt,
    required this.updatedAt,
    required this.isSynced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['admission_id'] = Variable<int>(admissionId);
    map['payload'] = Variable<String>(payload);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_synced'] = Variable<bool>(isSynced);
    return map;
  }

  EpicrisisNotesCompanion toCompanion(bool nullToAbsent) {
    return EpicrisisNotesCompanion(
      id: Value(id),
      admissionId: Value(admissionId),
      payload: Value(payload),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      isSynced: Value(isSynced),
    );
  }

  factory EpicrisisNote.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EpicrisisNote(
      id: serializer.fromJson<int>(json['id']),
      admissionId: serializer.fromJson<int>(json['admissionId']),
      payload: serializer.fromJson<String>(json['payload']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'admissionId': serializer.toJson<int>(admissionId),
      'payload': serializer.toJson<String>(payload),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isSynced': serializer.toJson<bool>(isSynced),
    };
  }

  EpicrisisNote copyWith({
    int? id,
    int? admissionId,
    String? payload,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isSynced,
  }) => EpicrisisNote(
    id: id ?? this.id,
    admissionId: admissionId ?? this.admissionId,
    payload: payload ?? this.payload,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    isSynced: isSynced ?? this.isSynced,
  );
  EpicrisisNote copyWithCompanion(EpicrisisNotesCompanion data) {
    return EpicrisisNote(
      id: data.id.present ? data.id.value : this.id,
      admissionId: data.admissionId.present
          ? data.admissionId.value
          : this.admissionId,
      payload: data.payload.present ? data.payload.value : this.payload,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EpicrisisNote(')
          ..write('id: $id, ')
          ..write('admissionId: $admissionId, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, admissionId, payload, createdAt, updatedAt, isSynced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EpicrisisNote &&
          other.id == this.id &&
          other.admissionId == this.admissionId &&
          other.payload == this.payload &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isSynced == this.isSynced);
}

class EpicrisisNotesCompanion extends UpdateCompanion<EpicrisisNote> {
  final Value<int> id;
  final Value<int> admissionId;
  final Value<String> payload;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> isSynced;
  const EpicrisisNotesCompanion({
    this.id = const Value.absent(),
    this.admissionId = const Value.absent(),
    this.payload = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
  });
  EpicrisisNotesCompanion.insert({
    this.id = const Value.absent(),
    required int admissionId,
    required String payload,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
  }) : admissionId = Value(admissionId),
       payload = Value(payload);
  static Insertable<EpicrisisNote> custom({
    Expression<int>? id,
    Expression<int>? admissionId,
    Expression<String>? payload,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isSynced,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (admissionId != null) 'admission_id': admissionId,
      if (payload != null) 'payload': payload,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isSynced != null) 'is_synced': isSynced,
    });
  }

  EpicrisisNotesCompanion copyWith({
    Value<int>? id,
    Value<int>? admissionId,
    Value<String>? payload,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<bool>? isSynced,
  }) {
    return EpicrisisNotesCompanion(
      id: id ?? this.id,
      admissionId: admissionId ?? this.admissionId,
      payload: payload ?? this.payload,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (admissionId.present) {
      map['admission_id'] = Variable<int>(admissionId.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EpicrisisNotesCompanion(')
          ..write('id: $id, ')
          ..write('admissionId: $admissionId, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }
}

class $ProceduresTable extends Procedures
    with TableInfo<$ProceduresTable, Procedure> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProceduresTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    code,
    description,
    createdAt,
    isSynced,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'procedures';
  @override
  VerificationContext validateIntegrity(
    Insertable<Procedure> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Procedure map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Procedure(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
    );
  }

  @override
  $ProceduresTable createAlias(String alias) {
    return $ProceduresTable(attachedDatabase, alias);
  }
}

class Procedure extends DataClass implements Insertable<Procedure> {
  final int id;
  final String name;
  final String? code;
  final String? description;
  final DateTime createdAt;
  final bool isSynced;
  const Procedure({
    required this.id,
    required this.name,
    this.code,
    this.description,
    required this.createdAt,
    required this.isSynced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || code != null) {
      map['code'] = Variable<String>(code);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['is_synced'] = Variable<bool>(isSynced);
    return map;
  }

  ProceduresCompanion toCompanion(bool nullToAbsent) {
    return ProceduresCompanion(
      id: Value(id),
      name: Value(name),
      code: code == null && nullToAbsent ? const Value.absent() : Value(code),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      createdAt: Value(createdAt),
      isSynced: Value(isSynced),
    );
  }

  factory Procedure.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Procedure(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      code: serializer.fromJson<String?>(json['code']),
      description: serializer.fromJson<String?>(json['description']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'code': serializer.toJson<String?>(code),
      'description': serializer.toJson<String?>(description),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'isSynced': serializer.toJson<bool>(isSynced),
    };
  }

  Procedure copyWith({
    int? id,
    String? name,
    Value<String?> code = const Value.absent(),
    Value<String?> description = const Value.absent(),
    DateTime? createdAt,
    bool? isSynced,
  }) => Procedure(
    id: id ?? this.id,
    name: name ?? this.name,
    code: code.present ? code.value : this.code,
    description: description.present ? description.value : this.description,
    createdAt: createdAt ?? this.createdAt,
    isSynced: isSynced ?? this.isSynced,
  );
  Procedure copyWithCompanion(ProceduresCompanion data) {
    return Procedure(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      code: data.code.present ? data.code.value : this.code,
      description: data.description.present
          ? data.description.value
          : this.description,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Procedure(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('code: $code, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, code, description, createdAt, isSynced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Procedure &&
          other.id == this.id &&
          other.name == this.name &&
          other.code == this.code &&
          other.description == this.description &&
          other.createdAt == this.createdAt &&
          other.isSynced == this.isSynced);
}

class ProceduresCompanion extends UpdateCompanion<Procedure> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> code;
  final Value<String?> description;
  final Value<DateTime> createdAt;
  final Value<bool> isSynced;
  const ProceduresCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.code = const Value.absent(),
    this.description = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isSynced = const Value.absent(),
  });
  ProceduresCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.code = const Value.absent(),
    this.description = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isSynced = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Procedure> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? code,
    Expression<String>? description,
    Expression<DateTime>? createdAt,
    Expression<bool>? isSynced,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (code != null) 'code': code,
      if (description != null) 'description': description,
      if (createdAt != null) 'created_at': createdAt,
      if (isSynced != null) 'is_synced': isSynced,
    });
  }

  ProceduresCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? code,
    Value<String?>? description,
    Value<DateTime>? createdAt,
    Value<bool>? isSynced,
  }) {
    return ProceduresCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProceduresCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('code: $code, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }
}

class $PerformedProceduresTable extends PerformedProcedures
    with TableInfo<$PerformedProceduresTable, PerformedProcedure> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PerformedProceduresTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _admissionIdMeta = const VerificationMeta(
    'admissionId',
  );
  @override
  late final GeneratedColumn<int> admissionId = GeneratedColumn<int>(
    'admission_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES admissions (id)',
    ),
  );
  static const VerificationMeta _procedureIdMeta = const VerificationMeta(
    'procedureId',
  );
  @override
  late final GeneratedColumn<int> procedureId = GeneratedColumn<int>(
    'procedure_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES procedures (id)',
    ),
  );
  static const VerificationMeta _procedureNameMeta = const VerificationMeta(
    'procedureName',
  );
  @override
  late final GeneratedColumn<String> procedureName = GeneratedColumn<String>(
    'procedure_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _performedAtMeta = const VerificationMeta(
    'performedAt',
  );
  @override
  late final GeneratedColumn<DateTime> performedAt = GeneratedColumn<DateTime>(
    'performed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _assistantMeta = const VerificationMeta(
    'assistant',
  );
  @override
  late final GeneratedColumn<String> assistant = GeneratedColumn<String>(
    'assistant',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _residentMeta = const VerificationMeta(
    'resident',
  );
  @override
  late final GeneratedColumn<String> resident = GeneratedColumn<String>(
    'resident',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _originMeta = const VerificationMeta('origin');
  @override
  late final GeneratedColumn<String> origin = GeneratedColumn<String>(
    'origin',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _guardiaMeta = const VerificationMeta(
    'guardia',
  );
  @override
  late final GeneratedColumn<String> guardia = GeneratedColumn<String>(
    'guardia',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    admissionId,
    procedureId,
    procedureName,
    performedAt,
    assistant,
    resident,
    origin,
    guardia,
    note,
    createdAt,
    isSynced,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'performed_procedures';
  @override
  VerificationContext validateIntegrity(
    Insertable<PerformedProcedure> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('admission_id')) {
      context.handle(
        _admissionIdMeta,
        admissionId.isAcceptableOrUnknown(
          data['admission_id']!,
          _admissionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_admissionIdMeta);
    }
    if (data.containsKey('procedure_id')) {
      context.handle(
        _procedureIdMeta,
        procedureId.isAcceptableOrUnknown(
          data['procedure_id']!,
          _procedureIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_procedureIdMeta);
    }
    if (data.containsKey('procedure_name')) {
      context.handle(
        _procedureNameMeta,
        procedureName.isAcceptableOrUnknown(
          data['procedure_name']!,
          _procedureNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_procedureNameMeta);
    }
    if (data.containsKey('performed_at')) {
      context.handle(
        _performedAtMeta,
        performedAt.isAcceptableOrUnknown(
          data['performed_at']!,
          _performedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_performedAtMeta);
    }
    if (data.containsKey('assistant')) {
      context.handle(
        _assistantMeta,
        assistant.isAcceptableOrUnknown(data['assistant']!, _assistantMeta),
      );
    }
    if (data.containsKey('resident')) {
      context.handle(
        _residentMeta,
        resident.isAcceptableOrUnknown(data['resident']!, _residentMeta),
      );
    }
    if (data.containsKey('origin')) {
      context.handle(
        _originMeta,
        origin.isAcceptableOrUnknown(data['origin']!, _originMeta),
      );
    }
    if (data.containsKey('guardia')) {
      context.handle(
        _guardiaMeta,
        guardia.isAcceptableOrUnknown(data['guardia']!, _guardiaMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PerformedProcedure map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PerformedProcedure(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      admissionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}admission_id'],
      )!,
      procedureId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}procedure_id'],
      )!,
      procedureName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}procedure_name'],
      )!,
      performedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}performed_at'],
      )!,
      assistant: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}assistant'],
      ),
      resident: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}resident'],
      ),
      origin: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}origin'],
      ),
      guardia: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}guardia'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
    );
  }

  @override
  $PerformedProceduresTable createAlias(String alias) {
    return $PerformedProceduresTable(attachedDatabase, alias);
  }
}

class PerformedProcedure extends DataClass
    implements Insertable<PerformedProcedure> {
  final int id;
  final int admissionId;
  final int procedureId;
  final String procedureName;
  final DateTime performedAt;
  final String? assistant;
  final String? resident;
  final String? origin;
  final String? guardia;
  final String? note;
  final DateTime createdAt;
  final bool isSynced;
  const PerformedProcedure({
    required this.id,
    required this.admissionId,
    required this.procedureId,
    required this.procedureName,
    required this.performedAt,
    this.assistant,
    this.resident,
    this.origin,
    this.guardia,
    this.note,
    required this.createdAt,
    required this.isSynced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['admission_id'] = Variable<int>(admissionId);
    map['procedure_id'] = Variable<int>(procedureId);
    map['procedure_name'] = Variable<String>(procedureName);
    map['performed_at'] = Variable<DateTime>(performedAt);
    if (!nullToAbsent || assistant != null) {
      map['assistant'] = Variable<String>(assistant);
    }
    if (!nullToAbsent || resident != null) {
      map['resident'] = Variable<String>(resident);
    }
    if (!nullToAbsent || origin != null) {
      map['origin'] = Variable<String>(origin);
    }
    if (!nullToAbsent || guardia != null) {
      map['guardia'] = Variable<String>(guardia);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['is_synced'] = Variable<bool>(isSynced);
    return map;
  }

  PerformedProceduresCompanion toCompanion(bool nullToAbsent) {
    return PerformedProceduresCompanion(
      id: Value(id),
      admissionId: Value(admissionId),
      procedureId: Value(procedureId),
      procedureName: Value(procedureName),
      performedAt: Value(performedAt),
      assistant: assistant == null && nullToAbsent
          ? const Value.absent()
          : Value(assistant),
      resident: resident == null && nullToAbsent
          ? const Value.absent()
          : Value(resident),
      origin: origin == null && nullToAbsent
          ? const Value.absent()
          : Value(origin),
      guardia: guardia == null && nullToAbsent
          ? const Value.absent()
          : Value(guardia),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      createdAt: Value(createdAt),
      isSynced: Value(isSynced),
    );
  }

  factory PerformedProcedure.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PerformedProcedure(
      id: serializer.fromJson<int>(json['id']),
      admissionId: serializer.fromJson<int>(json['admissionId']),
      procedureId: serializer.fromJson<int>(json['procedureId']),
      procedureName: serializer.fromJson<String>(json['procedureName']),
      performedAt: serializer.fromJson<DateTime>(json['performedAt']),
      assistant: serializer.fromJson<String?>(json['assistant']),
      resident: serializer.fromJson<String?>(json['resident']),
      origin: serializer.fromJson<String?>(json['origin']),
      guardia: serializer.fromJson<String?>(json['guardia']),
      note: serializer.fromJson<String?>(json['note']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'admissionId': serializer.toJson<int>(admissionId),
      'procedureId': serializer.toJson<int>(procedureId),
      'procedureName': serializer.toJson<String>(procedureName),
      'performedAt': serializer.toJson<DateTime>(performedAt),
      'assistant': serializer.toJson<String?>(assistant),
      'resident': serializer.toJson<String?>(resident),
      'origin': serializer.toJson<String?>(origin),
      'guardia': serializer.toJson<String?>(guardia),
      'note': serializer.toJson<String?>(note),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'isSynced': serializer.toJson<bool>(isSynced),
    };
  }

  PerformedProcedure copyWith({
    int? id,
    int? admissionId,
    int? procedureId,
    String? procedureName,
    DateTime? performedAt,
    Value<String?> assistant = const Value.absent(),
    Value<String?> resident = const Value.absent(),
    Value<String?> origin = const Value.absent(),
    Value<String?> guardia = const Value.absent(),
    Value<String?> note = const Value.absent(),
    DateTime? createdAt,
    bool? isSynced,
  }) => PerformedProcedure(
    id: id ?? this.id,
    admissionId: admissionId ?? this.admissionId,
    procedureId: procedureId ?? this.procedureId,
    procedureName: procedureName ?? this.procedureName,
    performedAt: performedAt ?? this.performedAt,
    assistant: assistant.present ? assistant.value : this.assistant,
    resident: resident.present ? resident.value : this.resident,
    origin: origin.present ? origin.value : this.origin,
    guardia: guardia.present ? guardia.value : this.guardia,
    note: note.present ? note.value : this.note,
    createdAt: createdAt ?? this.createdAt,
    isSynced: isSynced ?? this.isSynced,
  );
  PerformedProcedure copyWithCompanion(PerformedProceduresCompanion data) {
    return PerformedProcedure(
      id: data.id.present ? data.id.value : this.id,
      admissionId: data.admissionId.present
          ? data.admissionId.value
          : this.admissionId,
      procedureId: data.procedureId.present
          ? data.procedureId.value
          : this.procedureId,
      procedureName: data.procedureName.present
          ? data.procedureName.value
          : this.procedureName,
      performedAt: data.performedAt.present
          ? data.performedAt.value
          : this.performedAt,
      assistant: data.assistant.present ? data.assistant.value : this.assistant,
      resident: data.resident.present ? data.resident.value : this.resident,
      origin: data.origin.present ? data.origin.value : this.origin,
      guardia: data.guardia.present ? data.guardia.value : this.guardia,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PerformedProcedure(')
          ..write('id: $id, ')
          ..write('admissionId: $admissionId, ')
          ..write('procedureId: $procedureId, ')
          ..write('procedureName: $procedureName, ')
          ..write('performedAt: $performedAt, ')
          ..write('assistant: $assistant, ')
          ..write('resident: $resident, ')
          ..write('origin: $origin, ')
          ..write('guardia: $guardia, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    admissionId,
    procedureId,
    procedureName,
    performedAt,
    assistant,
    resident,
    origin,
    guardia,
    note,
    createdAt,
    isSynced,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PerformedProcedure &&
          other.id == this.id &&
          other.admissionId == this.admissionId &&
          other.procedureId == this.procedureId &&
          other.procedureName == this.procedureName &&
          other.performedAt == this.performedAt &&
          other.assistant == this.assistant &&
          other.resident == this.resident &&
          other.origin == this.origin &&
          other.guardia == this.guardia &&
          other.note == this.note &&
          other.createdAt == this.createdAt &&
          other.isSynced == this.isSynced);
}

class PerformedProceduresCompanion extends UpdateCompanion<PerformedProcedure> {
  final Value<int> id;
  final Value<int> admissionId;
  final Value<int> procedureId;
  final Value<String> procedureName;
  final Value<DateTime> performedAt;
  final Value<String?> assistant;
  final Value<String?> resident;
  final Value<String?> origin;
  final Value<String?> guardia;
  final Value<String?> note;
  final Value<DateTime> createdAt;
  final Value<bool> isSynced;
  const PerformedProceduresCompanion({
    this.id = const Value.absent(),
    this.admissionId = const Value.absent(),
    this.procedureId = const Value.absent(),
    this.procedureName = const Value.absent(),
    this.performedAt = const Value.absent(),
    this.assistant = const Value.absent(),
    this.resident = const Value.absent(),
    this.origin = const Value.absent(),
    this.guardia = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isSynced = const Value.absent(),
  });
  PerformedProceduresCompanion.insert({
    this.id = const Value.absent(),
    required int admissionId,
    required int procedureId,
    required String procedureName,
    required DateTime performedAt,
    this.assistant = const Value.absent(),
    this.resident = const Value.absent(),
    this.origin = const Value.absent(),
    this.guardia = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isSynced = const Value.absent(),
  }) : admissionId = Value(admissionId),
       procedureId = Value(procedureId),
       procedureName = Value(procedureName),
       performedAt = Value(performedAt);
  static Insertable<PerformedProcedure> custom({
    Expression<int>? id,
    Expression<int>? admissionId,
    Expression<int>? procedureId,
    Expression<String>? procedureName,
    Expression<DateTime>? performedAt,
    Expression<String>? assistant,
    Expression<String>? resident,
    Expression<String>? origin,
    Expression<String>? guardia,
    Expression<String>? note,
    Expression<DateTime>? createdAt,
    Expression<bool>? isSynced,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (admissionId != null) 'admission_id': admissionId,
      if (procedureId != null) 'procedure_id': procedureId,
      if (procedureName != null) 'procedure_name': procedureName,
      if (performedAt != null) 'performed_at': performedAt,
      if (assistant != null) 'assistant': assistant,
      if (resident != null) 'resident': resident,
      if (origin != null) 'origin': origin,
      if (guardia != null) 'guardia': guardia,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
      if (isSynced != null) 'is_synced': isSynced,
    });
  }

  PerformedProceduresCompanion copyWith({
    Value<int>? id,
    Value<int>? admissionId,
    Value<int>? procedureId,
    Value<String>? procedureName,
    Value<DateTime>? performedAt,
    Value<String?>? assistant,
    Value<String?>? resident,
    Value<String?>? origin,
    Value<String?>? guardia,
    Value<String?>? note,
    Value<DateTime>? createdAt,
    Value<bool>? isSynced,
  }) {
    return PerformedProceduresCompanion(
      id: id ?? this.id,
      admissionId: admissionId ?? this.admissionId,
      procedureId: procedureId ?? this.procedureId,
      procedureName: procedureName ?? this.procedureName,
      performedAt: performedAt ?? this.performedAt,
      assistant: assistant ?? this.assistant,
      resident: resident ?? this.resident,
      origin: origin ?? this.origin,
      guardia: guardia ?? this.guardia,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (admissionId.present) {
      map['admission_id'] = Variable<int>(admissionId.value);
    }
    if (procedureId.present) {
      map['procedure_id'] = Variable<int>(procedureId.value);
    }
    if (procedureName.present) {
      map['procedure_name'] = Variable<String>(procedureName.value);
    }
    if (performedAt.present) {
      map['performed_at'] = Variable<DateTime>(performedAt.value);
    }
    if (assistant.present) {
      map['assistant'] = Variable<String>(assistant.value);
    }
    if (resident.present) {
      map['resident'] = Variable<String>(resident.value);
    }
    if (origin.present) {
      map['origin'] = Variable<String>(origin.value);
    }
    if (guardia.present) {
      map['guardia'] = Variable<String>(guardia.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PerformedProceduresCompanion(')
          ..write('id: $id, ')
          ..write('admissionId: $admissionId, ')
          ..write('procedureId: $procedureId, ')
          ..write('procedureName: $procedureName, ')
          ..write('performedAt: $performedAt, ')
          ..write('assistant: $assistant, ')
          ..write('resident: $resident, ')
          ..write('origin: $origin, ')
          ..write('guardia: $guardia, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }
}

class $ExamTemplatesTable extends ExamTemplates
    with TableInfo<$ExamTemplatesTable, ExamTemplate> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExamTemplatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fieldsJsonMeta = const VerificationMeta(
    'fieldsJson',
  );
  @override
  late final GeneratedColumn<String> fieldsJson = GeneratedColumn<String>(
    'fields_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _isArchivedMeta = const VerificationMeta(
    'isArchived',
  );
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
    'is_archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdByMeta = const VerificationMeta(
    'createdBy',
  );
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
    'created_by',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    category,
    description,
    fieldsJson,
    version,
    isArchived,
    createdBy,
    createdAt,
    updatedAt,
    isSynced,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exam_templates';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExamTemplate> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('fields_json')) {
      context.handle(
        _fieldsJsonMeta,
        fieldsJson.isAcceptableOrUnknown(data['fields_json']!, _fieldsJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_fieldsJsonMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('is_archived')) {
      context.handle(
        _isArchivedMeta,
        isArchived.isAcceptableOrUnknown(data['is_archived']!, _isArchivedMeta),
      );
    }
    if (data.containsKey('created_by')) {
      context.handle(
        _createdByMeta,
        createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExamTemplate map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExamTemplate(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      fieldsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fields_json'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      isArchived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_archived'],
      )!,
      createdBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_by'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
    );
  }

  @override
  $ExamTemplatesTable createAlias(String alias) {
    return $ExamTemplatesTable(attachedDatabase, alias);
  }
}

class ExamTemplate extends DataClass implements Insertable<ExamTemplate> {
  final int id;
  final String name;
  final String? category;
  final String? description;
  final String fieldsJson;
  final int version;
  final bool isArchived;
  final String? createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isSynced;
  const ExamTemplate({
    required this.id,
    required this.name,
    this.category,
    this.description,
    required this.fieldsJson,
    required this.version,
    required this.isArchived,
    this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    required this.isSynced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['fields_json'] = Variable<String>(fieldsJson);
    map['version'] = Variable<int>(version);
    map['is_archived'] = Variable<bool>(isArchived);
    if (!nullToAbsent || createdBy != null) {
      map['created_by'] = Variable<String>(createdBy);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_synced'] = Variable<bool>(isSynced);
    return map;
  }

  ExamTemplatesCompanion toCompanion(bool nullToAbsent) {
    return ExamTemplatesCompanion(
      id: Value(id),
      name: Value(name),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      fieldsJson: Value(fieldsJson),
      version: Value(version),
      isArchived: Value(isArchived),
      createdBy: createdBy == null && nullToAbsent
          ? const Value.absent()
          : Value(createdBy),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      isSynced: Value(isSynced),
    );
  }

  factory ExamTemplate.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExamTemplate(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      category: serializer.fromJson<String?>(json['category']),
      description: serializer.fromJson<String?>(json['description']),
      fieldsJson: serializer.fromJson<String>(json['fieldsJson']),
      version: serializer.fromJson<int>(json['version']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
      createdBy: serializer.fromJson<String?>(json['createdBy']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'category': serializer.toJson<String?>(category),
      'description': serializer.toJson<String?>(description),
      'fieldsJson': serializer.toJson<String>(fieldsJson),
      'version': serializer.toJson<int>(version),
      'isArchived': serializer.toJson<bool>(isArchived),
      'createdBy': serializer.toJson<String?>(createdBy),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isSynced': serializer.toJson<bool>(isSynced),
    };
  }

  ExamTemplate copyWith({
    int? id,
    String? name,
    Value<String?> category = const Value.absent(),
    Value<String?> description = const Value.absent(),
    String? fieldsJson,
    int? version,
    bool? isArchived,
    Value<String?> createdBy = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isSynced,
  }) => ExamTemplate(
    id: id ?? this.id,
    name: name ?? this.name,
    category: category.present ? category.value : this.category,
    description: description.present ? description.value : this.description,
    fieldsJson: fieldsJson ?? this.fieldsJson,
    version: version ?? this.version,
    isArchived: isArchived ?? this.isArchived,
    createdBy: createdBy.present ? createdBy.value : this.createdBy,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    isSynced: isSynced ?? this.isSynced,
  );
  ExamTemplate copyWithCompanion(ExamTemplatesCompanion data) {
    return ExamTemplate(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      category: data.category.present ? data.category.value : this.category,
      description: data.description.present
          ? data.description.value
          : this.description,
      fieldsJson: data.fieldsJson.present
          ? data.fieldsJson.value
          : this.fieldsJson,
      version: data.version.present ? data.version.value : this.version,
      isArchived: data.isArchived.present
          ? data.isArchived.value
          : this.isArchived,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExamTemplate(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('description: $description, ')
          ..write('fieldsJson: $fieldsJson, ')
          ..write('version: $version, ')
          ..write('isArchived: $isArchived, ')
          ..write('createdBy: $createdBy, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    category,
    description,
    fieldsJson,
    version,
    isArchived,
    createdBy,
    createdAt,
    updatedAt,
    isSynced,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExamTemplate &&
          other.id == this.id &&
          other.name == this.name &&
          other.category == this.category &&
          other.description == this.description &&
          other.fieldsJson == this.fieldsJson &&
          other.version == this.version &&
          other.isArchived == this.isArchived &&
          other.createdBy == this.createdBy &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isSynced == this.isSynced);
}

class ExamTemplatesCompanion extends UpdateCompanion<ExamTemplate> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> category;
  final Value<String?> description;
  final Value<String> fieldsJson;
  final Value<int> version;
  final Value<bool> isArchived;
  final Value<String?> createdBy;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> isSynced;
  const ExamTemplatesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.category = const Value.absent(),
    this.description = const Value.absent(),
    this.fieldsJson = const Value.absent(),
    this.version = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
  });
  ExamTemplatesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.category = const Value.absent(),
    this.description = const Value.absent(),
    required String fieldsJson,
    this.version = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
  }) : name = Value(name),
       fieldsJson = Value(fieldsJson);
  static Insertable<ExamTemplate> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? category,
    Expression<String>? description,
    Expression<String>? fieldsJson,
    Expression<int>? version,
    Expression<bool>? isArchived,
    Expression<String>? createdBy,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isSynced,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (category != null) 'category': category,
      if (description != null) 'description': description,
      if (fieldsJson != null) 'fields_json': fieldsJson,
      if (version != null) 'version': version,
      if (isArchived != null) 'is_archived': isArchived,
      if (createdBy != null) 'created_by': createdBy,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isSynced != null) 'is_synced': isSynced,
    });
  }

  ExamTemplatesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? category,
    Value<String?>? description,
    Value<String>? fieldsJson,
    Value<int>? version,
    Value<bool>? isArchived,
    Value<String?>? createdBy,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<bool>? isSynced,
  }) {
    return ExamTemplatesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      description: description ?? this.description,
      fieldsJson: fieldsJson ?? this.fieldsJson,
      version: version ?? this.version,
      isArchived: isArchived ?? this.isArchived,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (fieldsJson.present) {
      map['fields_json'] = Variable<String>(fieldsJson.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExamTemplatesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('description: $description, ')
          ..write('fieldsJson: $fieldsJson, ')
          ..write('version: $version, ')
          ..write('isArchived: $isArchived, ')
          ..write('createdBy: $createdBy, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }
}

class $ExamResultsTable extends ExamResults
    with TableInfo<$ExamResultsTable, ExamResult> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExamResultsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _admissionIdMeta = const VerificationMeta(
    'admissionId',
  );
  @override
  late final GeneratedColumn<int> admissionId = GeneratedColumn<int>(
    'admission_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES admissions (id)',
    ),
  );
  static const VerificationMeta _templateIdMeta = const VerificationMeta(
    'templateId',
  );
  @override
  late final GeneratedColumn<int> templateId = GeneratedColumn<int>(
    'template_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES exam_templates (id)',
    ),
  );
  static const VerificationMeta _templateVersionMeta = const VerificationMeta(
    'templateVersion',
  );
  @override
  late final GeneratedColumn<int> templateVersion = GeneratedColumn<int>(
    'template_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _recordedAtMeta = const VerificationMeta(
    'recordedAt',
  );
  @override
  late final GeneratedColumn<DateTime> recordedAt = GeneratedColumn<DateTime>(
    'recorded_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _valuesJsonMeta = const VerificationMeta(
    'valuesJson',
  );
  @override
  late final GeneratedColumn<String> valuesJson = GeneratedColumn<String>(
    'values_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _attachmentsMeta = const VerificationMeta(
    'attachments',
  );
  @override
  late final GeneratedColumn<String> attachments = GeneratedColumn<String>(
    'attachments',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _recordedByMeta = const VerificationMeta(
    'recordedBy',
  );
  @override
  late final GeneratedColumn<String> recordedBy = GeneratedColumn<String>(
    'recorded_by',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    admissionId,
    templateId,
    templateVersion,
    recordedAt,
    valuesJson,
    note,
    attachments,
    recordedBy,
    createdAt,
    isSynced,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exam_results';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExamResult> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('admission_id')) {
      context.handle(
        _admissionIdMeta,
        admissionId.isAcceptableOrUnknown(
          data['admission_id']!,
          _admissionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_admissionIdMeta);
    }
    if (data.containsKey('template_id')) {
      context.handle(
        _templateIdMeta,
        templateId.isAcceptableOrUnknown(data['template_id']!, _templateIdMeta),
      );
    } else if (isInserting) {
      context.missing(_templateIdMeta);
    }
    if (data.containsKey('template_version')) {
      context.handle(
        _templateVersionMeta,
        templateVersion.isAcceptableOrUnknown(
          data['template_version']!,
          _templateVersionMeta,
        ),
      );
    }
    if (data.containsKey('recorded_at')) {
      context.handle(
        _recordedAtMeta,
        recordedAt.isAcceptableOrUnknown(data['recorded_at']!, _recordedAtMeta),
      );
    }
    if (data.containsKey('values_json')) {
      context.handle(
        _valuesJsonMeta,
        valuesJson.isAcceptableOrUnknown(data['values_json']!, _valuesJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_valuesJsonMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('attachments')) {
      context.handle(
        _attachmentsMeta,
        attachments.isAcceptableOrUnknown(
          data['attachments']!,
          _attachmentsMeta,
        ),
      );
    }
    if (data.containsKey('recorded_by')) {
      context.handle(
        _recordedByMeta,
        recordedBy.isAcceptableOrUnknown(data['recorded_by']!, _recordedByMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExamResult map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExamResult(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      admissionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}admission_id'],
      )!,
      templateId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}template_id'],
      )!,
      templateVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}template_version'],
      )!,
      recordedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}recorded_at'],
      )!,
      valuesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}values_json'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      attachments: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}attachments'],
      ),
      recordedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recorded_by'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
    );
  }

  @override
  $ExamResultsTable createAlias(String alias) {
    return $ExamResultsTable(attachedDatabase, alias);
  }
}

class ExamResult extends DataClass implements Insertable<ExamResult> {
  final int id;
  final int admissionId;
  final int templateId;
  final int templateVersion;
  final DateTime recordedAt;
  final String valuesJson;
  final String? note;
  final String? attachments;
  final String? recordedBy;
  final DateTime createdAt;
  final bool isSynced;
  const ExamResult({
    required this.id,
    required this.admissionId,
    required this.templateId,
    required this.templateVersion,
    required this.recordedAt,
    required this.valuesJson,
    this.note,
    this.attachments,
    this.recordedBy,
    required this.createdAt,
    required this.isSynced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['admission_id'] = Variable<int>(admissionId);
    map['template_id'] = Variable<int>(templateId);
    map['template_version'] = Variable<int>(templateVersion);
    map['recorded_at'] = Variable<DateTime>(recordedAt);
    map['values_json'] = Variable<String>(valuesJson);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || attachments != null) {
      map['attachments'] = Variable<String>(attachments);
    }
    if (!nullToAbsent || recordedBy != null) {
      map['recorded_by'] = Variable<String>(recordedBy);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['is_synced'] = Variable<bool>(isSynced);
    return map;
  }

  ExamResultsCompanion toCompanion(bool nullToAbsent) {
    return ExamResultsCompanion(
      id: Value(id),
      admissionId: Value(admissionId),
      templateId: Value(templateId),
      templateVersion: Value(templateVersion),
      recordedAt: Value(recordedAt),
      valuesJson: Value(valuesJson),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      attachments: attachments == null && nullToAbsent
          ? const Value.absent()
          : Value(attachments),
      recordedBy: recordedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(recordedBy),
      createdAt: Value(createdAt),
      isSynced: Value(isSynced),
    );
  }

  factory ExamResult.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExamResult(
      id: serializer.fromJson<int>(json['id']),
      admissionId: serializer.fromJson<int>(json['admissionId']),
      templateId: serializer.fromJson<int>(json['templateId']),
      templateVersion: serializer.fromJson<int>(json['templateVersion']),
      recordedAt: serializer.fromJson<DateTime>(json['recordedAt']),
      valuesJson: serializer.fromJson<String>(json['valuesJson']),
      note: serializer.fromJson<String?>(json['note']),
      attachments: serializer.fromJson<String?>(json['attachments']),
      recordedBy: serializer.fromJson<String?>(json['recordedBy']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'admissionId': serializer.toJson<int>(admissionId),
      'templateId': serializer.toJson<int>(templateId),
      'templateVersion': serializer.toJson<int>(templateVersion),
      'recordedAt': serializer.toJson<DateTime>(recordedAt),
      'valuesJson': serializer.toJson<String>(valuesJson),
      'note': serializer.toJson<String?>(note),
      'attachments': serializer.toJson<String?>(attachments),
      'recordedBy': serializer.toJson<String?>(recordedBy),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'isSynced': serializer.toJson<bool>(isSynced),
    };
  }

  ExamResult copyWith({
    int? id,
    int? admissionId,
    int? templateId,
    int? templateVersion,
    DateTime? recordedAt,
    String? valuesJson,
    Value<String?> note = const Value.absent(),
    Value<String?> attachments = const Value.absent(),
    Value<String?> recordedBy = const Value.absent(),
    DateTime? createdAt,
    bool? isSynced,
  }) => ExamResult(
    id: id ?? this.id,
    admissionId: admissionId ?? this.admissionId,
    templateId: templateId ?? this.templateId,
    templateVersion: templateVersion ?? this.templateVersion,
    recordedAt: recordedAt ?? this.recordedAt,
    valuesJson: valuesJson ?? this.valuesJson,
    note: note.present ? note.value : this.note,
    attachments: attachments.present ? attachments.value : this.attachments,
    recordedBy: recordedBy.present ? recordedBy.value : this.recordedBy,
    createdAt: createdAt ?? this.createdAt,
    isSynced: isSynced ?? this.isSynced,
  );
  ExamResult copyWithCompanion(ExamResultsCompanion data) {
    return ExamResult(
      id: data.id.present ? data.id.value : this.id,
      admissionId: data.admissionId.present
          ? data.admissionId.value
          : this.admissionId,
      templateId: data.templateId.present
          ? data.templateId.value
          : this.templateId,
      templateVersion: data.templateVersion.present
          ? data.templateVersion.value
          : this.templateVersion,
      recordedAt: data.recordedAt.present
          ? data.recordedAt.value
          : this.recordedAt,
      valuesJson: data.valuesJson.present
          ? data.valuesJson.value
          : this.valuesJson,
      note: data.note.present ? data.note.value : this.note,
      attachments: data.attachments.present
          ? data.attachments.value
          : this.attachments,
      recordedBy: data.recordedBy.present
          ? data.recordedBy.value
          : this.recordedBy,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExamResult(')
          ..write('id: $id, ')
          ..write('admissionId: $admissionId, ')
          ..write('templateId: $templateId, ')
          ..write('templateVersion: $templateVersion, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('valuesJson: $valuesJson, ')
          ..write('note: $note, ')
          ..write('attachments: $attachments, ')
          ..write('recordedBy: $recordedBy, ')
          ..write('createdAt: $createdAt, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    admissionId,
    templateId,
    templateVersion,
    recordedAt,
    valuesJson,
    note,
    attachments,
    recordedBy,
    createdAt,
    isSynced,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExamResult &&
          other.id == this.id &&
          other.admissionId == this.admissionId &&
          other.templateId == this.templateId &&
          other.templateVersion == this.templateVersion &&
          other.recordedAt == this.recordedAt &&
          other.valuesJson == this.valuesJson &&
          other.note == this.note &&
          other.attachments == this.attachments &&
          other.recordedBy == this.recordedBy &&
          other.createdAt == this.createdAt &&
          other.isSynced == this.isSynced);
}

class ExamResultsCompanion extends UpdateCompanion<ExamResult> {
  final Value<int> id;
  final Value<int> admissionId;
  final Value<int> templateId;
  final Value<int> templateVersion;
  final Value<DateTime> recordedAt;
  final Value<String> valuesJson;
  final Value<String?> note;
  final Value<String?> attachments;
  final Value<String?> recordedBy;
  final Value<DateTime> createdAt;
  final Value<bool> isSynced;
  const ExamResultsCompanion({
    this.id = const Value.absent(),
    this.admissionId = const Value.absent(),
    this.templateId = const Value.absent(),
    this.templateVersion = const Value.absent(),
    this.recordedAt = const Value.absent(),
    this.valuesJson = const Value.absent(),
    this.note = const Value.absent(),
    this.attachments = const Value.absent(),
    this.recordedBy = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isSynced = const Value.absent(),
  });
  ExamResultsCompanion.insert({
    this.id = const Value.absent(),
    required int admissionId,
    required int templateId,
    this.templateVersion = const Value.absent(),
    this.recordedAt = const Value.absent(),
    required String valuesJson,
    this.note = const Value.absent(),
    this.attachments = const Value.absent(),
    this.recordedBy = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isSynced = const Value.absent(),
  }) : admissionId = Value(admissionId),
       templateId = Value(templateId),
       valuesJson = Value(valuesJson);
  static Insertable<ExamResult> custom({
    Expression<int>? id,
    Expression<int>? admissionId,
    Expression<int>? templateId,
    Expression<int>? templateVersion,
    Expression<DateTime>? recordedAt,
    Expression<String>? valuesJson,
    Expression<String>? note,
    Expression<String>? attachments,
    Expression<String>? recordedBy,
    Expression<DateTime>? createdAt,
    Expression<bool>? isSynced,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (admissionId != null) 'admission_id': admissionId,
      if (templateId != null) 'template_id': templateId,
      if (templateVersion != null) 'template_version': templateVersion,
      if (recordedAt != null) 'recorded_at': recordedAt,
      if (valuesJson != null) 'values_json': valuesJson,
      if (note != null) 'note': note,
      if (attachments != null) 'attachments': attachments,
      if (recordedBy != null) 'recorded_by': recordedBy,
      if (createdAt != null) 'created_at': createdAt,
      if (isSynced != null) 'is_synced': isSynced,
    });
  }

  ExamResultsCompanion copyWith({
    Value<int>? id,
    Value<int>? admissionId,
    Value<int>? templateId,
    Value<int>? templateVersion,
    Value<DateTime>? recordedAt,
    Value<String>? valuesJson,
    Value<String?>? note,
    Value<String?>? attachments,
    Value<String?>? recordedBy,
    Value<DateTime>? createdAt,
    Value<bool>? isSynced,
  }) {
    return ExamResultsCompanion(
      id: id ?? this.id,
      admissionId: admissionId ?? this.admissionId,
      templateId: templateId ?? this.templateId,
      templateVersion: templateVersion ?? this.templateVersion,
      recordedAt: recordedAt ?? this.recordedAt,
      valuesJson: valuesJson ?? this.valuesJson,
      note: note ?? this.note,
      attachments: attachments ?? this.attachments,
      recordedBy: recordedBy ?? this.recordedBy,
      createdAt: createdAt ?? this.createdAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (admissionId.present) {
      map['admission_id'] = Variable<int>(admissionId.value);
    }
    if (templateId.present) {
      map['template_id'] = Variable<int>(templateId.value);
    }
    if (templateVersion.present) {
      map['template_version'] = Variable<int>(templateVersion.value);
    }
    if (recordedAt.present) {
      map['recorded_at'] = Variable<DateTime>(recordedAt.value);
    }
    if (valuesJson.present) {
      map['values_json'] = Variable<String>(valuesJson.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (attachments.present) {
      map['attachments'] = Variable<String>(attachments.value);
    }
    if (recordedBy.present) {
      map['recorded_by'] = Variable<String>(recordedBy.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExamResultsCompanion(')
          ..write('id: $id, ')
          ..write('admissionId: $admissionId, ')
          ..write('templateId: $templateId, ')
          ..write('templateVersion: $templateVersion, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('valuesJson: $valuesJson, ')
          ..write('note: $note, ')
          ..write('attachments: $attachments, ')
          ..write('recordedBy: $recordedBy, ')
          ..write('createdAt: $createdAt, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PatientsTable patients = $PatientsTable(this);
  late final $AdmissionsTable admissions = $AdmissionsTable(this);
  late final $EvolutionsTable evolutions = $EvolutionsTable(this);
  late final $IndicationSheetsTable indicationSheets = $IndicationSheetsTable(
    this,
  );
  late final $EpicrisisNotesTable epicrisisNotes = $EpicrisisNotesTable(this);
  late final $ProceduresTable procedures = $ProceduresTable(this);
  late final $PerformedProceduresTable performedProcedures =
      $PerformedProceduresTable(this);
  late final $ExamTemplatesTable examTemplates = $ExamTemplatesTable(this);
  late final $ExamResultsTable examResults = $ExamResultsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    patients,
    admissions,
    evolutions,
    indicationSheets,
    epicrisisNotes,
    procedures,
    performedProcedures,
    examTemplates,
    examResults,
  ];
}

typedef $$PatientsTableCreateCompanionBuilder =
    PatientsCompanion Function({
      Value<int> id,
      required String name,
      required String dni,
      required String hc,
      required int age,
      required String sex,
      Value<String?> address,
      Value<String?> occupation,
      Value<String?> phone,
      Value<String?> familyContact,
      Value<String?> placeOfBirth,
      Value<String?> insuranceType,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<bool> isSynced,
    });
typedef $$PatientsTableUpdateCompanionBuilder =
    PatientsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> dni,
      Value<String> hc,
      Value<int> age,
      Value<String> sex,
      Value<String?> address,
      Value<String?> occupation,
      Value<String?> phone,
      Value<String?> familyContact,
      Value<String?> placeOfBirth,
      Value<String?> insuranceType,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<bool> isSynced,
    });

final class $$PatientsTableReferences
    extends BaseReferences<_$AppDatabase, $PatientsTable, Patient> {
  $$PatientsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$AdmissionsTable, List<Admission>>
  _admissionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.admissions,
    aliasName: $_aliasNameGenerator(db.patients.id, db.admissions.patientId),
  );

  $$AdmissionsTableProcessedTableManager get admissionsRefs {
    final manager = $$AdmissionsTableTableManager(
      $_db,
      $_db.admissions,
    ).filter((f) => f.patientId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_admissionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
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
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dni => $composableBuilder(
    column: $table.dni,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hc => $composableBuilder(
    column: $table.hc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get age => $composableBuilder(
    column: $table.age,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sex => $composableBuilder(
    column: $table.sex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get occupation => $composableBuilder(
    column: $table.occupation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get familyContact => $composableBuilder(
    column: $table.familyContact,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get placeOfBirth => $composableBuilder(
    column: $table.placeOfBirth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get insuranceType => $composableBuilder(
    column: $table.insuranceType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> admissionsRefs(
    Expression<bool> Function($$AdmissionsTableFilterComposer f) f,
  ) {
    final $$AdmissionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.admissions,
      getReferencedColumn: (t) => t.patientId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AdmissionsTableFilterComposer(
            $db: $db,
            $table: $db.admissions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
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
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dni => $composableBuilder(
    column: $table.dni,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hc => $composableBuilder(
    column: $table.hc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get age => $composableBuilder(
    column: $table.age,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sex => $composableBuilder(
    column: $table.sex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get occupation => $composableBuilder(
    column: $table.occupation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get familyContact => $composableBuilder(
    column: $table.familyContact,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get placeOfBirth => $composableBuilder(
    column: $table.placeOfBirth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get insuranceType => $composableBuilder(
    column: $table.insuranceType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );
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
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get dni =>
      $composableBuilder(column: $table.dni, builder: (column) => column);

  GeneratedColumn<String> get hc =>
      $composableBuilder(column: $table.hc, builder: (column) => column);

  GeneratedColumn<int> get age =>
      $composableBuilder(column: $table.age, builder: (column) => column);

  GeneratedColumn<String> get sex =>
      $composableBuilder(column: $table.sex, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get occupation => $composableBuilder(
    column: $table.occupation,
    builder: (column) => column,
  );

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get familyContact => $composableBuilder(
    column: $table.familyContact,
    builder: (column) => column,
  );

  GeneratedColumn<String> get placeOfBirth => $composableBuilder(
    column: $table.placeOfBirth,
    builder: (column) => column,
  );

  GeneratedColumn<String> get insuranceType => $composableBuilder(
    column: $table.insuranceType,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  Expression<T> admissionsRefs<T extends Object>(
    Expression<T> Function($$AdmissionsTableAnnotationComposer a) f,
  ) {
    final $$AdmissionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.admissions,
      getReferencedColumn: (t) => t.patientId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AdmissionsTableAnnotationComposer(
            $db: $db,
            $table: $db.admissions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PatientsTableTableManager
    extends
        RootTableManager<
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
          PrefetchHooks Function({bool admissionsRefs})
        > {
  $$PatientsTableTableManager(_$AppDatabase db, $PatientsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PatientsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PatientsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PatientsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> dni = const Value.absent(),
                Value<String> hc = const Value.absent(),
                Value<int> age = const Value.absent(),
                Value<String> sex = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String?> occupation = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> familyContact = const Value.absent(),
                Value<String?> placeOfBirth = const Value.absent(),
                Value<String?> insuranceType = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
              }) => PatientsCompanion(
                id: id,
                name: name,
                dni: dni,
                hc: hc,
                age: age,
                sex: sex,
                address: address,
                occupation: occupation,
                phone: phone,
                familyContact: familyContact,
                placeOfBirth: placeOfBirth,
                insuranceType: insuranceType,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isSynced: isSynced,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String dni,
                required String hc,
                required int age,
                required String sex,
                Value<String?> address = const Value.absent(),
                Value<String?> occupation = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> familyContact = const Value.absent(),
                Value<String?> placeOfBirth = const Value.absent(),
                Value<String?> insuranceType = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
              }) => PatientsCompanion.insert(
                id: id,
                name: name,
                dni: dni,
                hc: hc,
                age: age,
                sex: sex,
                address: address,
                occupation: occupation,
                phone: phone,
                familyContact: familyContact,
                placeOfBirth: placeOfBirth,
                insuranceType: insuranceType,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isSynced: isSynced,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PatientsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({admissionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (admissionsRefs) db.admissions],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (admissionsRefs)
                    await $_getPrefetchedData<
                      Patient,
                      $PatientsTable,
                      Admission
                    >(
                      currentTable: table,
                      referencedTable: $$PatientsTableReferences
                          ._admissionsRefsTable(db),
                      managerFromTypedResult: (p0) => $$PatientsTableReferences(
                        db,
                        table,
                        p0,
                      ).admissionsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.patientId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$PatientsTableProcessedTableManager =
    ProcessedTableManager<
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
      PrefetchHooks Function({bool admissionsRefs})
    >;
typedef $$AdmissionsTableCreateCompanionBuilder =
    AdmissionsCompanion Function({
      Value<int> id,
      required int patientId,
      required DateTime admissionDate,
      Value<double?> sofaScore,
      Value<double?> apacheScore,
      Value<double?> nutricScore,
      Value<String?> sofaMortality,
      Value<String?> apacheMortality,
      Value<String?> diagnosis,
      Value<String?> signsSymptoms,
      Value<String?> timeOfDisease,
      Value<String?> illnessStart,
      Value<String?> illnessCourse,
      Value<String?> story,
      Value<String?> physicalExam,
      Value<String?> plan,
      Value<String?> bp,
      Value<String?> hr,
      Value<String?> rr,
      Value<String?> o2Sat,
      Value<String?> temp,
      Value<String?> vitalsJson,
      Value<String?> procedures,
      Value<int?> bedNumber,
      Value<DateTime?> dischargedAt,
      Value<String?> uciPriority,
      Value<DateTime> createdAt,
      Value<bool> isSynced,
    });
typedef $$AdmissionsTableUpdateCompanionBuilder =
    AdmissionsCompanion Function({
      Value<int> id,
      Value<int> patientId,
      Value<DateTime> admissionDate,
      Value<double?> sofaScore,
      Value<double?> apacheScore,
      Value<double?> nutricScore,
      Value<String?> sofaMortality,
      Value<String?> apacheMortality,
      Value<String?> diagnosis,
      Value<String?> signsSymptoms,
      Value<String?> timeOfDisease,
      Value<String?> illnessStart,
      Value<String?> illnessCourse,
      Value<String?> story,
      Value<String?> physicalExam,
      Value<String?> plan,
      Value<String?> bp,
      Value<String?> hr,
      Value<String?> rr,
      Value<String?> o2Sat,
      Value<String?> temp,
      Value<String?> vitalsJson,
      Value<String?> procedures,
      Value<int?> bedNumber,
      Value<DateTime?> dischargedAt,
      Value<String?> uciPriority,
      Value<DateTime> createdAt,
      Value<bool> isSynced,
    });

final class $$AdmissionsTableReferences
    extends BaseReferences<_$AppDatabase, $AdmissionsTable, Admission> {
  $$AdmissionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PatientsTable _patientIdTable(_$AppDatabase db) =>
      db.patients.createAlias(
        $_aliasNameGenerator(db.admissions.patientId, db.patients.id),
      );

  $$PatientsTableProcessedTableManager get patientId {
    final $_column = $_itemColumn<int>('patient_id')!;

    final manager = $$PatientsTableTableManager(
      $_db,
      $_db.patients,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_patientIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$EvolutionsTable, List<Evolution>>
  _evolutionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.evolutions,
    aliasName: $_aliasNameGenerator(
      db.admissions.id,
      db.evolutions.admissionId,
    ),
  );

  $$EvolutionsTableProcessedTableManager get evolutionsRefs {
    final manager = $$EvolutionsTableTableManager(
      $_db,
      $_db.evolutions,
    ).filter((f) => f.admissionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_evolutionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$IndicationSheetsTable, List<IndicationSheet>>
  _indicationSheetsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.indicationSheets,
    aliasName: $_aliasNameGenerator(
      db.admissions.id,
      db.indicationSheets.admissionId,
    ),
  );

  $$IndicationSheetsTableProcessedTableManager get indicationSheetsRefs {
    final manager = $$IndicationSheetsTableTableManager(
      $_db,
      $_db.indicationSheets,
    ).filter((f) => f.admissionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _indicationSheetsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$EpicrisisNotesTable, List<EpicrisisNote>>
  _epicrisisNotesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.epicrisisNotes,
    aliasName: $_aliasNameGenerator(
      db.admissions.id,
      db.epicrisisNotes.admissionId,
    ),
  );

  $$EpicrisisNotesTableProcessedTableManager get epicrisisNotesRefs {
    final manager = $$EpicrisisNotesTableTableManager(
      $_db,
      $_db.epicrisisNotes,
    ).filter((f) => f.admissionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_epicrisisNotesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $PerformedProceduresTable,
    List<PerformedProcedure>
  >
  _performedProceduresRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.performedProcedures,
        aliasName: $_aliasNameGenerator(
          db.admissions.id,
          db.performedProcedures.admissionId,
        ),
      );

  $$PerformedProceduresTableProcessedTableManager get performedProceduresRefs {
    final manager = $$PerformedProceduresTableTableManager(
      $_db,
      $_db.performedProcedures,
    ).filter((f) => f.admissionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _performedProceduresRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ExamResultsTable, List<ExamResult>>
  _examResultsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.examResults,
    aliasName: $_aliasNameGenerator(
      db.admissions.id,
      db.examResults.admissionId,
    ),
  );

  $$ExamResultsTableProcessedTableManager get examResultsRefs {
    final manager = $$ExamResultsTableTableManager(
      $_db,
      $_db.examResults,
    ).filter((f) => f.admissionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_examResultsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$AdmissionsTableFilterComposer
    extends Composer<_$AppDatabase, $AdmissionsTable> {
  $$AdmissionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get admissionDate => $composableBuilder(
    column: $table.admissionDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get sofaScore => $composableBuilder(
    column: $table.sofaScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get apacheScore => $composableBuilder(
    column: $table.apacheScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get nutricScore => $composableBuilder(
    column: $table.nutricScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sofaMortality => $composableBuilder(
    column: $table.sofaMortality,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get apacheMortality => $composableBuilder(
    column: $table.apacheMortality,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get diagnosis => $composableBuilder(
    column: $table.diagnosis,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get signsSymptoms => $composableBuilder(
    column: $table.signsSymptoms,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get timeOfDisease => $composableBuilder(
    column: $table.timeOfDisease,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get illnessStart => $composableBuilder(
    column: $table.illnessStart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get illnessCourse => $composableBuilder(
    column: $table.illnessCourse,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get story => $composableBuilder(
    column: $table.story,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get physicalExam => $composableBuilder(
    column: $table.physicalExam,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get plan => $composableBuilder(
    column: $table.plan,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bp => $composableBuilder(
    column: $table.bp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hr => $composableBuilder(
    column: $table.hr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rr => $composableBuilder(
    column: $table.rr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get o2Sat => $composableBuilder(
    column: $table.o2Sat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get temp => $composableBuilder(
    column: $table.temp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get vitalsJson => $composableBuilder(
    column: $table.vitalsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get procedures => $composableBuilder(
    column: $table.procedures,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bedNumber => $composableBuilder(
    column: $table.bedNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dischargedAt => $composableBuilder(
    column: $table.dischargedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get uciPriority => $composableBuilder(
    column: $table.uciPriority,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  $$PatientsTableFilterComposer get patientId {
    final $$PatientsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.patientId,
      referencedTable: $db.patients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PatientsTableFilterComposer(
            $db: $db,
            $table: $db.patients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> evolutionsRefs(
    Expression<bool> Function($$EvolutionsTableFilterComposer f) f,
  ) {
    final $$EvolutionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.evolutions,
      getReferencedColumn: (t) => t.admissionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EvolutionsTableFilterComposer(
            $db: $db,
            $table: $db.evolutions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> indicationSheetsRefs(
    Expression<bool> Function($$IndicationSheetsTableFilterComposer f) f,
  ) {
    final $$IndicationSheetsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.indicationSheets,
      getReferencedColumn: (t) => t.admissionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IndicationSheetsTableFilterComposer(
            $db: $db,
            $table: $db.indicationSheets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> epicrisisNotesRefs(
    Expression<bool> Function($$EpicrisisNotesTableFilterComposer f) f,
  ) {
    final $$EpicrisisNotesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.epicrisisNotes,
      getReferencedColumn: (t) => t.admissionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EpicrisisNotesTableFilterComposer(
            $db: $db,
            $table: $db.epicrisisNotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> performedProceduresRefs(
    Expression<bool> Function($$PerformedProceduresTableFilterComposer f) f,
  ) {
    final $$PerformedProceduresTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.performedProcedures,
      getReferencedColumn: (t) => t.admissionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PerformedProceduresTableFilterComposer(
            $db: $db,
            $table: $db.performedProcedures,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> examResultsRefs(
    Expression<bool> Function($$ExamResultsTableFilterComposer f) f,
  ) {
    final $$ExamResultsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.examResults,
      getReferencedColumn: (t) => t.admissionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExamResultsTableFilterComposer(
            $db: $db,
            $table: $db.examResults,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AdmissionsTableOrderingComposer
    extends Composer<_$AppDatabase, $AdmissionsTable> {
  $$AdmissionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get admissionDate => $composableBuilder(
    column: $table.admissionDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get sofaScore => $composableBuilder(
    column: $table.sofaScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get apacheScore => $composableBuilder(
    column: $table.apacheScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get nutricScore => $composableBuilder(
    column: $table.nutricScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sofaMortality => $composableBuilder(
    column: $table.sofaMortality,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get apacheMortality => $composableBuilder(
    column: $table.apacheMortality,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get diagnosis => $composableBuilder(
    column: $table.diagnosis,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get signsSymptoms => $composableBuilder(
    column: $table.signsSymptoms,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get timeOfDisease => $composableBuilder(
    column: $table.timeOfDisease,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get illnessStart => $composableBuilder(
    column: $table.illnessStart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get illnessCourse => $composableBuilder(
    column: $table.illnessCourse,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get story => $composableBuilder(
    column: $table.story,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get physicalExam => $composableBuilder(
    column: $table.physicalExam,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get plan => $composableBuilder(
    column: $table.plan,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bp => $composableBuilder(
    column: $table.bp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hr => $composableBuilder(
    column: $table.hr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rr => $composableBuilder(
    column: $table.rr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get o2Sat => $composableBuilder(
    column: $table.o2Sat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get temp => $composableBuilder(
    column: $table.temp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get vitalsJson => $composableBuilder(
    column: $table.vitalsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get procedures => $composableBuilder(
    column: $table.procedures,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bedNumber => $composableBuilder(
    column: $table.bedNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dischargedAt => $composableBuilder(
    column: $table.dischargedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uciPriority => $composableBuilder(
    column: $table.uciPriority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  $$PatientsTableOrderingComposer get patientId {
    final $$PatientsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.patientId,
      referencedTable: $db.patients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PatientsTableOrderingComposer(
            $db: $db,
            $table: $db.patients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AdmissionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AdmissionsTable> {
  $$AdmissionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get admissionDate => $composableBuilder(
    column: $table.admissionDate,
    builder: (column) => column,
  );

  GeneratedColumn<double> get sofaScore =>
      $composableBuilder(column: $table.sofaScore, builder: (column) => column);

  GeneratedColumn<double> get apacheScore => $composableBuilder(
    column: $table.apacheScore,
    builder: (column) => column,
  );

  GeneratedColumn<double> get nutricScore => $composableBuilder(
    column: $table.nutricScore,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sofaMortality => $composableBuilder(
    column: $table.sofaMortality,
    builder: (column) => column,
  );

  GeneratedColumn<String> get apacheMortality => $composableBuilder(
    column: $table.apacheMortality,
    builder: (column) => column,
  );

  GeneratedColumn<String> get diagnosis =>
      $composableBuilder(column: $table.diagnosis, builder: (column) => column);

  GeneratedColumn<String> get signsSymptoms => $composableBuilder(
    column: $table.signsSymptoms,
    builder: (column) => column,
  );

  GeneratedColumn<String> get timeOfDisease => $composableBuilder(
    column: $table.timeOfDisease,
    builder: (column) => column,
  );

  GeneratedColumn<String> get illnessStart => $composableBuilder(
    column: $table.illnessStart,
    builder: (column) => column,
  );

  GeneratedColumn<String> get illnessCourse => $composableBuilder(
    column: $table.illnessCourse,
    builder: (column) => column,
  );

  GeneratedColumn<String> get story =>
      $composableBuilder(column: $table.story, builder: (column) => column);

  GeneratedColumn<String> get physicalExam => $composableBuilder(
    column: $table.physicalExam,
    builder: (column) => column,
  );

  GeneratedColumn<String> get plan =>
      $composableBuilder(column: $table.plan, builder: (column) => column);

  GeneratedColumn<String> get bp =>
      $composableBuilder(column: $table.bp, builder: (column) => column);

  GeneratedColumn<String> get hr =>
      $composableBuilder(column: $table.hr, builder: (column) => column);

  GeneratedColumn<String> get rr =>
      $composableBuilder(column: $table.rr, builder: (column) => column);

  GeneratedColumn<String> get o2Sat =>
      $composableBuilder(column: $table.o2Sat, builder: (column) => column);

  GeneratedColumn<String> get temp =>
      $composableBuilder(column: $table.temp, builder: (column) => column);

  GeneratedColumn<String> get vitalsJson => $composableBuilder(
    column: $table.vitalsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get procedures => $composableBuilder(
    column: $table.procedures,
    builder: (column) => column,
  );

  GeneratedColumn<int> get bedNumber =>
      $composableBuilder(column: $table.bedNumber, builder: (column) => column);

  GeneratedColumn<DateTime> get dischargedAt => $composableBuilder(
    column: $table.dischargedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get uciPriority => $composableBuilder(
    column: $table.uciPriority,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  $$PatientsTableAnnotationComposer get patientId {
    final $$PatientsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.patientId,
      referencedTable: $db.patients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PatientsTableAnnotationComposer(
            $db: $db,
            $table: $db.patients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> evolutionsRefs<T extends Object>(
    Expression<T> Function($$EvolutionsTableAnnotationComposer a) f,
  ) {
    final $$EvolutionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.evolutions,
      getReferencedColumn: (t) => t.admissionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EvolutionsTableAnnotationComposer(
            $db: $db,
            $table: $db.evolutions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> indicationSheetsRefs<T extends Object>(
    Expression<T> Function($$IndicationSheetsTableAnnotationComposer a) f,
  ) {
    final $$IndicationSheetsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.indicationSheets,
      getReferencedColumn: (t) => t.admissionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IndicationSheetsTableAnnotationComposer(
            $db: $db,
            $table: $db.indicationSheets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> epicrisisNotesRefs<T extends Object>(
    Expression<T> Function($$EpicrisisNotesTableAnnotationComposer a) f,
  ) {
    final $$EpicrisisNotesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.epicrisisNotes,
      getReferencedColumn: (t) => t.admissionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EpicrisisNotesTableAnnotationComposer(
            $db: $db,
            $table: $db.epicrisisNotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> performedProceduresRefs<T extends Object>(
    Expression<T> Function($$PerformedProceduresTableAnnotationComposer a) f,
  ) {
    final $$PerformedProceduresTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.performedProcedures,
          getReferencedColumn: (t) => t.admissionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PerformedProceduresTableAnnotationComposer(
                $db: $db,
                $table: $db.performedProcedures,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> examResultsRefs<T extends Object>(
    Expression<T> Function($$ExamResultsTableAnnotationComposer a) f,
  ) {
    final $$ExamResultsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.examResults,
      getReferencedColumn: (t) => t.admissionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExamResultsTableAnnotationComposer(
            $db: $db,
            $table: $db.examResults,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AdmissionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AdmissionsTable,
          Admission,
          $$AdmissionsTableFilterComposer,
          $$AdmissionsTableOrderingComposer,
          $$AdmissionsTableAnnotationComposer,
          $$AdmissionsTableCreateCompanionBuilder,
          $$AdmissionsTableUpdateCompanionBuilder,
          (Admission, $$AdmissionsTableReferences),
          Admission,
          PrefetchHooks Function({
            bool patientId,
            bool evolutionsRefs,
            bool indicationSheetsRefs,
            bool epicrisisNotesRefs,
            bool performedProceduresRefs,
            bool examResultsRefs,
          })
        > {
  $$AdmissionsTableTableManager(_$AppDatabase db, $AdmissionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AdmissionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AdmissionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AdmissionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> patientId = const Value.absent(),
                Value<DateTime> admissionDate = const Value.absent(),
                Value<double?> sofaScore = const Value.absent(),
                Value<double?> apacheScore = const Value.absent(),
                Value<double?> nutricScore = const Value.absent(),
                Value<String?> sofaMortality = const Value.absent(),
                Value<String?> apacheMortality = const Value.absent(),
                Value<String?> diagnosis = const Value.absent(),
                Value<String?> signsSymptoms = const Value.absent(),
                Value<String?> timeOfDisease = const Value.absent(),
                Value<String?> illnessStart = const Value.absent(),
                Value<String?> illnessCourse = const Value.absent(),
                Value<String?> story = const Value.absent(),
                Value<String?> physicalExam = const Value.absent(),
                Value<String?> plan = const Value.absent(),
                Value<String?> bp = const Value.absent(),
                Value<String?> hr = const Value.absent(),
                Value<String?> rr = const Value.absent(),
                Value<String?> o2Sat = const Value.absent(),
                Value<String?> temp = const Value.absent(),
                Value<String?> vitalsJson = const Value.absent(),
                Value<String?> procedures = const Value.absent(),
                Value<int?> bedNumber = const Value.absent(),
                Value<DateTime?> dischargedAt = const Value.absent(),
                Value<String?> uciPriority = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
              }) => AdmissionsCompanion(
                id: id,
                patientId: patientId,
                admissionDate: admissionDate,
                sofaScore: sofaScore,
                apacheScore: apacheScore,
                nutricScore: nutricScore,
                sofaMortality: sofaMortality,
                apacheMortality: apacheMortality,
                diagnosis: diagnosis,
                signsSymptoms: signsSymptoms,
                timeOfDisease: timeOfDisease,
                illnessStart: illnessStart,
                illnessCourse: illnessCourse,
                story: story,
                physicalExam: physicalExam,
                plan: plan,
                bp: bp,
                hr: hr,
                rr: rr,
                o2Sat: o2Sat,
                temp: temp,
                vitalsJson: vitalsJson,
                procedures: procedures,
                bedNumber: bedNumber,
                dischargedAt: dischargedAt,
                uciPriority: uciPriority,
                createdAt: createdAt,
                isSynced: isSynced,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int patientId,
                required DateTime admissionDate,
                Value<double?> sofaScore = const Value.absent(),
                Value<double?> apacheScore = const Value.absent(),
                Value<double?> nutricScore = const Value.absent(),
                Value<String?> sofaMortality = const Value.absent(),
                Value<String?> apacheMortality = const Value.absent(),
                Value<String?> diagnosis = const Value.absent(),
                Value<String?> signsSymptoms = const Value.absent(),
                Value<String?> timeOfDisease = const Value.absent(),
                Value<String?> illnessStart = const Value.absent(),
                Value<String?> illnessCourse = const Value.absent(),
                Value<String?> story = const Value.absent(),
                Value<String?> physicalExam = const Value.absent(),
                Value<String?> plan = const Value.absent(),
                Value<String?> bp = const Value.absent(),
                Value<String?> hr = const Value.absent(),
                Value<String?> rr = const Value.absent(),
                Value<String?> o2Sat = const Value.absent(),
                Value<String?> temp = const Value.absent(),
                Value<String?> vitalsJson = const Value.absent(),
                Value<String?> procedures = const Value.absent(),
                Value<int?> bedNumber = const Value.absent(),
                Value<DateTime?> dischargedAt = const Value.absent(),
                Value<String?> uciPriority = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
              }) => AdmissionsCompanion.insert(
                id: id,
                patientId: patientId,
                admissionDate: admissionDate,
                sofaScore: sofaScore,
                apacheScore: apacheScore,
                nutricScore: nutricScore,
                sofaMortality: sofaMortality,
                apacheMortality: apacheMortality,
                diagnosis: diagnosis,
                signsSymptoms: signsSymptoms,
                timeOfDisease: timeOfDisease,
                illnessStart: illnessStart,
                illnessCourse: illnessCourse,
                story: story,
                physicalExam: physicalExam,
                plan: plan,
                bp: bp,
                hr: hr,
                rr: rr,
                o2Sat: o2Sat,
                temp: temp,
                vitalsJson: vitalsJson,
                procedures: procedures,
                bedNumber: bedNumber,
                dischargedAt: dischargedAt,
                uciPriority: uciPriority,
                createdAt: createdAt,
                isSynced: isSynced,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AdmissionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                patientId = false,
                evolutionsRefs = false,
                indicationSheetsRefs = false,
                epicrisisNotesRefs = false,
                performedProceduresRefs = false,
                examResultsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (evolutionsRefs) db.evolutions,
                    if (indicationSheetsRefs) db.indicationSheets,
                    if (epicrisisNotesRefs) db.epicrisisNotes,
                    if (performedProceduresRefs) db.performedProcedures,
                    if (examResultsRefs) db.examResults,
                  ],
                  addJoins:
                      <
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
                          dynamic
                        >
                      >(state) {
                        if (patientId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.patientId,
                                    referencedTable: $$AdmissionsTableReferences
                                        ._patientIdTable(db),
                                    referencedColumn:
                                        $$AdmissionsTableReferences
                                            ._patientIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (evolutionsRefs)
                        await $_getPrefetchedData<
                          Admission,
                          $AdmissionsTable,
                          Evolution
                        >(
                          currentTable: table,
                          referencedTable: $$AdmissionsTableReferences
                              ._evolutionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AdmissionsTableReferences(
                                db,
                                table,
                                p0,
                              ).evolutionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.admissionId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (indicationSheetsRefs)
                        await $_getPrefetchedData<
                          Admission,
                          $AdmissionsTable,
                          IndicationSheet
                        >(
                          currentTable: table,
                          referencedTable: $$AdmissionsTableReferences
                              ._indicationSheetsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AdmissionsTableReferences(
                                db,
                                table,
                                p0,
                              ).indicationSheetsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.admissionId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (epicrisisNotesRefs)
                        await $_getPrefetchedData<
                          Admission,
                          $AdmissionsTable,
                          EpicrisisNote
                        >(
                          currentTable: table,
                          referencedTable: $$AdmissionsTableReferences
                              ._epicrisisNotesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AdmissionsTableReferences(
                                db,
                                table,
                                p0,
                              ).epicrisisNotesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.admissionId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (performedProceduresRefs)
                        await $_getPrefetchedData<
                          Admission,
                          $AdmissionsTable,
                          PerformedProcedure
                        >(
                          currentTable: table,
                          referencedTable: $$AdmissionsTableReferences
                              ._performedProceduresRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AdmissionsTableReferences(
                                db,
                                table,
                                p0,
                              ).performedProceduresRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.admissionId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (examResultsRefs)
                        await $_getPrefetchedData<
                          Admission,
                          $AdmissionsTable,
                          ExamResult
                        >(
                          currentTable: table,
                          referencedTable: $$AdmissionsTableReferences
                              ._examResultsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AdmissionsTableReferences(
                                db,
                                table,
                                p0,
                              ).examResultsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.admissionId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$AdmissionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AdmissionsTable,
      Admission,
      $$AdmissionsTableFilterComposer,
      $$AdmissionsTableOrderingComposer,
      $$AdmissionsTableAnnotationComposer,
      $$AdmissionsTableCreateCompanionBuilder,
      $$AdmissionsTableUpdateCompanionBuilder,
      (Admission, $$AdmissionsTableReferences),
      Admission,
      PrefetchHooks Function({
        bool patientId,
        bool evolutionsRefs,
        bool indicationSheetsRefs,
        bool epicrisisNotesRefs,
        bool performedProceduresRefs,
        bool examResultsRefs,
      })
    >;
typedef $$EvolutionsTableCreateCompanionBuilder =
    EvolutionsCompanion Function({
      Value<int> id,
      required int admissionId,
      Value<DateTime> date,
      Value<int?> dayOfStay,
      Value<String?> vitalsJson,
      Value<String?> vmSettingsJson,
      Value<String?> vmMechanicsJson,
      Value<String?> subjective,
      Value<String?> objectiveJson,
      Value<String?> analysis,
      Value<String?> plan,
      Value<String?> proceduresNote,
      Value<String?> diagnosis,
      Value<String?> authorName,
      Value<String?> authorRole,
      Value<DateTime> createdAt,
      Value<bool> isSynced,
    });
typedef $$EvolutionsTableUpdateCompanionBuilder =
    EvolutionsCompanion Function({
      Value<int> id,
      Value<int> admissionId,
      Value<DateTime> date,
      Value<int?> dayOfStay,
      Value<String?> vitalsJson,
      Value<String?> vmSettingsJson,
      Value<String?> vmMechanicsJson,
      Value<String?> subjective,
      Value<String?> objectiveJson,
      Value<String?> analysis,
      Value<String?> plan,
      Value<String?> proceduresNote,
      Value<String?> diagnosis,
      Value<String?> authorName,
      Value<String?> authorRole,
      Value<DateTime> createdAt,
      Value<bool> isSynced,
    });

final class $$EvolutionsTableReferences
    extends BaseReferences<_$AppDatabase, $EvolutionsTable, Evolution> {
  $$EvolutionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AdmissionsTable _admissionIdTable(_$AppDatabase db) =>
      db.admissions.createAlias(
        $_aliasNameGenerator(db.evolutions.admissionId, db.admissions.id),
      );

  $$AdmissionsTableProcessedTableManager get admissionId {
    final $_column = $_itemColumn<int>('admission_id')!;

    final manager = $$AdmissionsTableTableManager(
      $_db,
      $_db.admissions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_admissionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$EvolutionsTableFilterComposer
    extends Composer<_$AppDatabase, $EvolutionsTable> {
  $$EvolutionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dayOfStay => $composableBuilder(
    column: $table.dayOfStay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get vitalsJson => $composableBuilder(
    column: $table.vitalsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get vmSettingsJson => $composableBuilder(
    column: $table.vmSettingsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get vmMechanicsJson => $composableBuilder(
    column: $table.vmMechanicsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subjective => $composableBuilder(
    column: $table.subjective,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get objectiveJson => $composableBuilder(
    column: $table.objectiveJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get analysis => $composableBuilder(
    column: $table.analysis,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get plan => $composableBuilder(
    column: $table.plan,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get proceduresNote => $composableBuilder(
    column: $table.proceduresNote,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get diagnosis => $composableBuilder(
    column: $table.diagnosis,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get authorName => $composableBuilder(
    column: $table.authorName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get authorRole => $composableBuilder(
    column: $table.authorRole,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  $$AdmissionsTableFilterComposer get admissionId {
    final $$AdmissionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.admissionId,
      referencedTable: $db.admissions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AdmissionsTableFilterComposer(
            $db: $db,
            $table: $db.admissions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EvolutionsTableOrderingComposer
    extends Composer<_$AppDatabase, $EvolutionsTable> {
  $$EvolutionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dayOfStay => $composableBuilder(
    column: $table.dayOfStay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get vitalsJson => $composableBuilder(
    column: $table.vitalsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get vmSettingsJson => $composableBuilder(
    column: $table.vmSettingsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get vmMechanicsJson => $composableBuilder(
    column: $table.vmMechanicsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subjective => $composableBuilder(
    column: $table.subjective,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get objectiveJson => $composableBuilder(
    column: $table.objectiveJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get analysis => $composableBuilder(
    column: $table.analysis,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get plan => $composableBuilder(
    column: $table.plan,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get proceduresNote => $composableBuilder(
    column: $table.proceduresNote,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get diagnosis => $composableBuilder(
    column: $table.diagnosis,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get authorName => $composableBuilder(
    column: $table.authorName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get authorRole => $composableBuilder(
    column: $table.authorRole,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  $$AdmissionsTableOrderingComposer get admissionId {
    final $$AdmissionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.admissionId,
      referencedTable: $db.admissions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AdmissionsTableOrderingComposer(
            $db: $db,
            $table: $db.admissions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EvolutionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EvolutionsTable> {
  $$EvolutionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get dayOfStay =>
      $composableBuilder(column: $table.dayOfStay, builder: (column) => column);

  GeneratedColumn<String> get vitalsJson => $composableBuilder(
    column: $table.vitalsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get vmSettingsJson => $composableBuilder(
    column: $table.vmSettingsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get vmMechanicsJson => $composableBuilder(
    column: $table.vmMechanicsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get subjective => $composableBuilder(
    column: $table.subjective,
    builder: (column) => column,
  );

  GeneratedColumn<String> get objectiveJson => $composableBuilder(
    column: $table.objectiveJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get analysis =>
      $composableBuilder(column: $table.analysis, builder: (column) => column);

  GeneratedColumn<String> get plan =>
      $composableBuilder(column: $table.plan, builder: (column) => column);

  GeneratedColumn<String> get proceduresNote => $composableBuilder(
    column: $table.proceduresNote,
    builder: (column) => column,
  );

  GeneratedColumn<String> get diagnosis =>
      $composableBuilder(column: $table.diagnosis, builder: (column) => column);

  GeneratedColumn<String> get authorName => $composableBuilder(
    column: $table.authorName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get authorRole => $composableBuilder(
    column: $table.authorRole,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  $$AdmissionsTableAnnotationComposer get admissionId {
    final $$AdmissionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.admissionId,
      referencedTable: $db.admissions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AdmissionsTableAnnotationComposer(
            $db: $db,
            $table: $db.admissions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EvolutionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EvolutionsTable,
          Evolution,
          $$EvolutionsTableFilterComposer,
          $$EvolutionsTableOrderingComposer,
          $$EvolutionsTableAnnotationComposer,
          $$EvolutionsTableCreateCompanionBuilder,
          $$EvolutionsTableUpdateCompanionBuilder,
          (Evolution, $$EvolutionsTableReferences),
          Evolution,
          PrefetchHooks Function({bool admissionId})
        > {
  $$EvolutionsTableTableManager(_$AppDatabase db, $EvolutionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EvolutionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EvolutionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EvolutionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> admissionId = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<int?> dayOfStay = const Value.absent(),
                Value<String?> vitalsJson = const Value.absent(),
                Value<String?> vmSettingsJson = const Value.absent(),
                Value<String?> vmMechanicsJson = const Value.absent(),
                Value<String?> subjective = const Value.absent(),
                Value<String?> objectiveJson = const Value.absent(),
                Value<String?> analysis = const Value.absent(),
                Value<String?> plan = const Value.absent(),
                Value<String?> proceduresNote = const Value.absent(),
                Value<String?> diagnosis = const Value.absent(),
                Value<String?> authorName = const Value.absent(),
                Value<String?> authorRole = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
              }) => EvolutionsCompanion(
                id: id,
                admissionId: admissionId,
                date: date,
                dayOfStay: dayOfStay,
                vitalsJson: vitalsJson,
                vmSettingsJson: vmSettingsJson,
                vmMechanicsJson: vmMechanicsJson,
                subjective: subjective,
                objectiveJson: objectiveJson,
                analysis: analysis,
                plan: plan,
                proceduresNote: proceduresNote,
                diagnosis: diagnosis,
                authorName: authorName,
                authorRole: authorRole,
                createdAt: createdAt,
                isSynced: isSynced,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int admissionId,
                Value<DateTime> date = const Value.absent(),
                Value<int?> dayOfStay = const Value.absent(),
                Value<String?> vitalsJson = const Value.absent(),
                Value<String?> vmSettingsJson = const Value.absent(),
                Value<String?> vmMechanicsJson = const Value.absent(),
                Value<String?> subjective = const Value.absent(),
                Value<String?> objectiveJson = const Value.absent(),
                Value<String?> analysis = const Value.absent(),
                Value<String?> plan = const Value.absent(),
                Value<String?> proceduresNote = const Value.absent(),
                Value<String?> diagnosis = const Value.absent(),
                Value<String?> authorName = const Value.absent(),
                Value<String?> authorRole = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
              }) => EvolutionsCompanion.insert(
                id: id,
                admissionId: admissionId,
                date: date,
                dayOfStay: dayOfStay,
                vitalsJson: vitalsJson,
                vmSettingsJson: vmSettingsJson,
                vmMechanicsJson: vmMechanicsJson,
                subjective: subjective,
                objectiveJson: objectiveJson,
                analysis: analysis,
                plan: plan,
                proceduresNote: proceduresNote,
                diagnosis: diagnosis,
                authorName: authorName,
                authorRole: authorRole,
                createdAt: createdAt,
                isSynced: isSynced,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$EvolutionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({admissionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
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
                      dynamic
                    >
                  >(state) {
                    if (admissionId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.admissionId,
                                referencedTable: $$EvolutionsTableReferences
                                    ._admissionIdTable(db),
                                referencedColumn: $$EvolutionsTableReferences
                                    ._admissionIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$EvolutionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EvolutionsTable,
      Evolution,
      $$EvolutionsTableFilterComposer,
      $$EvolutionsTableOrderingComposer,
      $$EvolutionsTableAnnotationComposer,
      $$EvolutionsTableCreateCompanionBuilder,
      $$EvolutionsTableUpdateCompanionBuilder,
      (Evolution, $$EvolutionsTableReferences),
      Evolution,
      PrefetchHooks Function({bool admissionId})
    >;
typedef $$IndicationSheetsTableCreateCompanionBuilder =
    IndicationSheetsCompanion Function({
      Value<int> id,
      required int admissionId,
      required String payload,
      Value<DateTime> createdAt,
      Value<bool> isSynced,
    });
typedef $$IndicationSheetsTableUpdateCompanionBuilder =
    IndicationSheetsCompanion Function({
      Value<int> id,
      Value<int> admissionId,
      Value<String> payload,
      Value<DateTime> createdAt,
      Value<bool> isSynced,
    });

final class $$IndicationSheetsTableReferences
    extends
        BaseReferences<_$AppDatabase, $IndicationSheetsTable, IndicationSheet> {
  $$IndicationSheetsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $AdmissionsTable _admissionIdTable(_$AppDatabase db) =>
      db.admissions.createAlias(
        $_aliasNameGenerator(db.indicationSheets.admissionId, db.admissions.id),
      );

  $$AdmissionsTableProcessedTableManager get admissionId {
    final $_column = $_itemColumn<int>('admission_id')!;

    final manager = $$AdmissionsTableTableManager(
      $_db,
      $_db.admissions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_admissionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$IndicationSheetsTableFilterComposer
    extends Composer<_$AppDatabase, $IndicationSheetsTable> {
  $$IndicationSheetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  $$AdmissionsTableFilterComposer get admissionId {
    final $$AdmissionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.admissionId,
      referencedTable: $db.admissions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AdmissionsTableFilterComposer(
            $db: $db,
            $table: $db.admissions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IndicationSheetsTableOrderingComposer
    extends Composer<_$AppDatabase, $IndicationSheetsTable> {
  $$IndicationSheetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  $$AdmissionsTableOrderingComposer get admissionId {
    final $$AdmissionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.admissionId,
      referencedTable: $db.admissions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AdmissionsTableOrderingComposer(
            $db: $db,
            $table: $db.admissions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IndicationSheetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $IndicationSheetsTable> {
  $$IndicationSheetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  $$AdmissionsTableAnnotationComposer get admissionId {
    final $$AdmissionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.admissionId,
      referencedTable: $db.admissions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AdmissionsTableAnnotationComposer(
            $db: $db,
            $table: $db.admissions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IndicationSheetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $IndicationSheetsTable,
          IndicationSheet,
          $$IndicationSheetsTableFilterComposer,
          $$IndicationSheetsTableOrderingComposer,
          $$IndicationSheetsTableAnnotationComposer,
          $$IndicationSheetsTableCreateCompanionBuilder,
          $$IndicationSheetsTableUpdateCompanionBuilder,
          (IndicationSheet, $$IndicationSheetsTableReferences),
          IndicationSheet,
          PrefetchHooks Function({bool admissionId})
        > {
  $$IndicationSheetsTableTableManager(
    _$AppDatabase db,
    $IndicationSheetsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IndicationSheetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IndicationSheetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IndicationSheetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> admissionId = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
              }) => IndicationSheetsCompanion(
                id: id,
                admissionId: admissionId,
                payload: payload,
                createdAt: createdAt,
                isSynced: isSynced,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int admissionId,
                required String payload,
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
              }) => IndicationSheetsCompanion.insert(
                id: id,
                admissionId: admissionId,
                payload: payload,
                createdAt: createdAt,
                isSynced: isSynced,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$IndicationSheetsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({admissionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
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
                      dynamic
                    >
                  >(state) {
                    if (admissionId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.admissionId,
                                referencedTable:
                                    $$IndicationSheetsTableReferences
                                        ._admissionIdTable(db),
                                referencedColumn:
                                    $$IndicationSheetsTableReferences
                                        ._admissionIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$IndicationSheetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $IndicationSheetsTable,
      IndicationSheet,
      $$IndicationSheetsTableFilterComposer,
      $$IndicationSheetsTableOrderingComposer,
      $$IndicationSheetsTableAnnotationComposer,
      $$IndicationSheetsTableCreateCompanionBuilder,
      $$IndicationSheetsTableUpdateCompanionBuilder,
      (IndicationSheet, $$IndicationSheetsTableReferences),
      IndicationSheet,
      PrefetchHooks Function({bool admissionId})
    >;
typedef $$EpicrisisNotesTableCreateCompanionBuilder =
    EpicrisisNotesCompanion Function({
      Value<int> id,
      required int admissionId,
      required String payload,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<bool> isSynced,
    });
typedef $$EpicrisisNotesTableUpdateCompanionBuilder =
    EpicrisisNotesCompanion Function({
      Value<int> id,
      Value<int> admissionId,
      Value<String> payload,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<bool> isSynced,
    });

final class $$EpicrisisNotesTableReferences
    extends BaseReferences<_$AppDatabase, $EpicrisisNotesTable, EpicrisisNote> {
  $$EpicrisisNotesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $AdmissionsTable _admissionIdTable(_$AppDatabase db) =>
      db.admissions.createAlias(
        $_aliasNameGenerator(db.epicrisisNotes.admissionId, db.admissions.id),
      );

  $$AdmissionsTableProcessedTableManager get admissionId {
    final $_column = $_itemColumn<int>('admission_id')!;

    final manager = $$AdmissionsTableTableManager(
      $_db,
      $_db.admissions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_admissionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$EpicrisisNotesTableFilterComposer
    extends Composer<_$AppDatabase, $EpicrisisNotesTable> {
  $$EpicrisisNotesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  $$AdmissionsTableFilterComposer get admissionId {
    final $$AdmissionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.admissionId,
      referencedTable: $db.admissions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AdmissionsTableFilterComposer(
            $db: $db,
            $table: $db.admissions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EpicrisisNotesTableOrderingComposer
    extends Composer<_$AppDatabase, $EpicrisisNotesTable> {
  $$EpicrisisNotesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  $$AdmissionsTableOrderingComposer get admissionId {
    final $$AdmissionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.admissionId,
      referencedTable: $db.admissions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AdmissionsTableOrderingComposer(
            $db: $db,
            $table: $db.admissions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EpicrisisNotesTableAnnotationComposer
    extends Composer<_$AppDatabase, $EpicrisisNotesTable> {
  $$EpicrisisNotesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  $$AdmissionsTableAnnotationComposer get admissionId {
    final $$AdmissionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.admissionId,
      referencedTable: $db.admissions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AdmissionsTableAnnotationComposer(
            $db: $db,
            $table: $db.admissions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EpicrisisNotesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EpicrisisNotesTable,
          EpicrisisNote,
          $$EpicrisisNotesTableFilterComposer,
          $$EpicrisisNotesTableOrderingComposer,
          $$EpicrisisNotesTableAnnotationComposer,
          $$EpicrisisNotesTableCreateCompanionBuilder,
          $$EpicrisisNotesTableUpdateCompanionBuilder,
          (EpicrisisNote, $$EpicrisisNotesTableReferences),
          EpicrisisNote,
          PrefetchHooks Function({bool admissionId})
        > {
  $$EpicrisisNotesTableTableManager(
    _$AppDatabase db,
    $EpicrisisNotesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EpicrisisNotesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EpicrisisNotesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EpicrisisNotesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> admissionId = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
              }) => EpicrisisNotesCompanion(
                id: id,
                admissionId: admissionId,
                payload: payload,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isSynced: isSynced,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int admissionId,
                required String payload,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
              }) => EpicrisisNotesCompanion.insert(
                id: id,
                admissionId: admissionId,
                payload: payload,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isSynced: isSynced,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$EpicrisisNotesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({admissionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
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
                      dynamic
                    >
                  >(state) {
                    if (admissionId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.admissionId,
                                referencedTable: $$EpicrisisNotesTableReferences
                                    ._admissionIdTable(db),
                                referencedColumn:
                                    $$EpicrisisNotesTableReferences
                                        ._admissionIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$EpicrisisNotesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EpicrisisNotesTable,
      EpicrisisNote,
      $$EpicrisisNotesTableFilterComposer,
      $$EpicrisisNotesTableOrderingComposer,
      $$EpicrisisNotesTableAnnotationComposer,
      $$EpicrisisNotesTableCreateCompanionBuilder,
      $$EpicrisisNotesTableUpdateCompanionBuilder,
      (EpicrisisNote, $$EpicrisisNotesTableReferences),
      EpicrisisNote,
      PrefetchHooks Function({bool admissionId})
    >;
typedef $$ProceduresTableCreateCompanionBuilder =
    ProceduresCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> code,
      Value<String?> description,
      Value<DateTime> createdAt,
      Value<bool> isSynced,
    });
typedef $$ProceduresTableUpdateCompanionBuilder =
    ProceduresCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> code,
      Value<String?> description,
      Value<DateTime> createdAt,
      Value<bool> isSynced,
    });

final class $$ProceduresTableReferences
    extends BaseReferences<_$AppDatabase, $ProceduresTable, Procedure> {
  $$ProceduresTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<
    $PerformedProceduresTable,
    List<PerformedProcedure>
  >
  _performedProceduresRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.performedProcedures,
        aliasName: $_aliasNameGenerator(
          db.procedures.id,
          db.performedProcedures.procedureId,
        ),
      );

  $$PerformedProceduresTableProcessedTableManager get performedProceduresRefs {
    final manager = $$PerformedProceduresTableTableManager(
      $_db,
      $_db.performedProcedures,
    ).filter((f) => f.procedureId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _performedProceduresRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProceduresTableFilterComposer
    extends Composer<_$AppDatabase, $ProceduresTable> {
  $$ProceduresTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> performedProceduresRefs(
    Expression<bool> Function($$PerformedProceduresTableFilterComposer f) f,
  ) {
    final $$PerformedProceduresTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.performedProcedures,
      getReferencedColumn: (t) => t.procedureId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PerformedProceduresTableFilterComposer(
            $db: $db,
            $table: $db.performedProcedures,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProceduresTableOrderingComposer
    extends Composer<_$AppDatabase, $ProceduresTable> {
  $$ProceduresTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProceduresTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProceduresTable> {
  $$ProceduresTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  Expression<T> performedProceduresRefs<T extends Object>(
    Expression<T> Function($$PerformedProceduresTableAnnotationComposer a) f,
  ) {
    final $$PerformedProceduresTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.performedProcedures,
          getReferencedColumn: (t) => t.procedureId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PerformedProceduresTableAnnotationComposer(
                $db: $db,
                $table: $db.performedProcedures,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$ProceduresTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProceduresTable,
          Procedure,
          $$ProceduresTableFilterComposer,
          $$ProceduresTableOrderingComposer,
          $$ProceduresTableAnnotationComposer,
          $$ProceduresTableCreateCompanionBuilder,
          $$ProceduresTableUpdateCompanionBuilder,
          (Procedure, $$ProceduresTableReferences),
          Procedure,
          PrefetchHooks Function({bool performedProceduresRefs})
        > {
  $$ProceduresTableTableManager(_$AppDatabase db, $ProceduresTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProceduresTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProceduresTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProceduresTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> code = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
              }) => ProceduresCompanion(
                id: id,
                name: name,
                code: code,
                description: description,
                createdAt: createdAt,
                isSynced: isSynced,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> code = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
              }) => ProceduresCompanion.insert(
                id: id,
                name: name,
                code: code,
                description: description,
                createdAt: createdAt,
                isSynced: isSynced,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProceduresTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({performedProceduresRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (performedProceduresRefs) db.performedProcedures,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (performedProceduresRefs)
                    await $_getPrefetchedData<
                      Procedure,
                      $ProceduresTable,
                      PerformedProcedure
                    >(
                      currentTable: table,
                      referencedTable: $$ProceduresTableReferences
                          ._performedProceduresRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ProceduresTableReferences(
                            db,
                            table,
                            p0,
                          ).performedProceduresRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.procedureId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ProceduresTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProceduresTable,
      Procedure,
      $$ProceduresTableFilterComposer,
      $$ProceduresTableOrderingComposer,
      $$ProceduresTableAnnotationComposer,
      $$ProceduresTableCreateCompanionBuilder,
      $$ProceduresTableUpdateCompanionBuilder,
      (Procedure, $$ProceduresTableReferences),
      Procedure,
      PrefetchHooks Function({bool performedProceduresRefs})
    >;
typedef $$PerformedProceduresTableCreateCompanionBuilder =
    PerformedProceduresCompanion Function({
      Value<int> id,
      required int admissionId,
      required int procedureId,
      required String procedureName,
      required DateTime performedAt,
      Value<String?> assistant,
      Value<String?> resident,
      Value<String?> origin,
      Value<String?> guardia,
      Value<String?> note,
      Value<DateTime> createdAt,
      Value<bool> isSynced,
    });
typedef $$PerformedProceduresTableUpdateCompanionBuilder =
    PerformedProceduresCompanion Function({
      Value<int> id,
      Value<int> admissionId,
      Value<int> procedureId,
      Value<String> procedureName,
      Value<DateTime> performedAt,
      Value<String?> assistant,
      Value<String?> resident,
      Value<String?> origin,
      Value<String?> guardia,
      Value<String?> note,
      Value<DateTime> createdAt,
      Value<bool> isSynced,
    });

final class $$PerformedProceduresTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $PerformedProceduresTable,
          PerformedProcedure
        > {
  $$PerformedProceduresTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $AdmissionsTable _admissionIdTable(_$AppDatabase db) =>
      db.admissions.createAlias(
        $_aliasNameGenerator(
          db.performedProcedures.admissionId,
          db.admissions.id,
        ),
      );

  $$AdmissionsTableProcessedTableManager get admissionId {
    final $_column = $_itemColumn<int>('admission_id')!;

    final manager = $$AdmissionsTableTableManager(
      $_db,
      $_db.admissions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_admissionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ProceduresTable _procedureIdTable(_$AppDatabase db) =>
      db.procedures.createAlias(
        $_aliasNameGenerator(
          db.performedProcedures.procedureId,
          db.procedures.id,
        ),
      );

  $$ProceduresTableProcessedTableManager get procedureId {
    final $_column = $_itemColumn<int>('procedure_id')!;

    final manager = $$ProceduresTableTableManager(
      $_db,
      $_db.procedures,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_procedureIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PerformedProceduresTableFilterComposer
    extends Composer<_$AppDatabase, $PerformedProceduresTable> {
  $$PerformedProceduresTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get procedureName => $composableBuilder(
    column: $table.procedureName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get performedAt => $composableBuilder(
    column: $table.performedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get assistant => $composableBuilder(
    column: $table.assistant,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get resident => $composableBuilder(
    column: $table.resident,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get origin => $composableBuilder(
    column: $table.origin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get guardia => $composableBuilder(
    column: $table.guardia,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  $$AdmissionsTableFilterComposer get admissionId {
    final $$AdmissionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.admissionId,
      referencedTable: $db.admissions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AdmissionsTableFilterComposer(
            $db: $db,
            $table: $db.admissions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProceduresTableFilterComposer get procedureId {
    final $$ProceduresTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.procedureId,
      referencedTable: $db.procedures,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProceduresTableFilterComposer(
            $db: $db,
            $table: $db.procedures,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PerformedProceduresTableOrderingComposer
    extends Composer<_$AppDatabase, $PerformedProceduresTable> {
  $$PerformedProceduresTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get procedureName => $composableBuilder(
    column: $table.procedureName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get performedAt => $composableBuilder(
    column: $table.performedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get assistant => $composableBuilder(
    column: $table.assistant,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get resident => $composableBuilder(
    column: $table.resident,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get origin => $composableBuilder(
    column: $table.origin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get guardia => $composableBuilder(
    column: $table.guardia,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  $$AdmissionsTableOrderingComposer get admissionId {
    final $$AdmissionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.admissionId,
      referencedTable: $db.admissions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AdmissionsTableOrderingComposer(
            $db: $db,
            $table: $db.admissions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProceduresTableOrderingComposer get procedureId {
    final $$ProceduresTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.procedureId,
      referencedTable: $db.procedures,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProceduresTableOrderingComposer(
            $db: $db,
            $table: $db.procedures,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PerformedProceduresTableAnnotationComposer
    extends Composer<_$AppDatabase, $PerformedProceduresTable> {
  $$PerformedProceduresTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get procedureName => $composableBuilder(
    column: $table.procedureName,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get performedAt => $composableBuilder(
    column: $table.performedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get assistant =>
      $composableBuilder(column: $table.assistant, builder: (column) => column);

  GeneratedColumn<String> get resident =>
      $composableBuilder(column: $table.resident, builder: (column) => column);

  GeneratedColumn<String> get origin =>
      $composableBuilder(column: $table.origin, builder: (column) => column);

  GeneratedColumn<String> get guardia =>
      $composableBuilder(column: $table.guardia, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  $$AdmissionsTableAnnotationComposer get admissionId {
    final $$AdmissionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.admissionId,
      referencedTable: $db.admissions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AdmissionsTableAnnotationComposer(
            $db: $db,
            $table: $db.admissions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProceduresTableAnnotationComposer get procedureId {
    final $$ProceduresTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.procedureId,
      referencedTable: $db.procedures,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProceduresTableAnnotationComposer(
            $db: $db,
            $table: $db.procedures,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PerformedProceduresTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PerformedProceduresTable,
          PerformedProcedure,
          $$PerformedProceduresTableFilterComposer,
          $$PerformedProceduresTableOrderingComposer,
          $$PerformedProceduresTableAnnotationComposer,
          $$PerformedProceduresTableCreateCompanionBuilder,
          $$PerformedProceduresTableUpdateCompanionBuilder,
          (PerformedProcedure, $$PerformedProceduresTableReferences),
          PerformedProcedure,
          PrefetchHooks Function({bool admissionId, bool procedureId})
        > {
  $$PerformedProceduresTableTableManager(
    _$AppDatabase db,
    $PerformedProceduresTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PerformedProceduresTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PerformedProceduresTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$PerformedProceduresTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> admissionId = const Value.absent(),
                Value<int> procedureId = const Value.absent(),
                Value<String> procedureName = const Value.absent(),
                Value<DateTime> performedAt = const Value.absent(),
                Value<String?> assistant = const Value.absent(),
                Value<String?> resident = const Value.absent(),
                Value<String?> origin = const Value.absent(),
                Value<String?> guardia = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
              }) => PerformedProceduresCompanion(
                id: id,
                admissionId: admissionId,
                procedureId: procedureId,
                procedureName: procedureName,
                performedAt: performedAt,
                assistant: assistant,
                resident: resident,
                origin: origin,
                guardia: guardia,
                note: note,
                createdAt: createdAt,
                isSynced: isSynced,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int admissionId,
                required int procedureId,
                required String procedureName,
                required DateTime performedAt,
                Value<String?> assistant = const Value.absent(),
                Value<String?> resident = const Value.absent(),
                Value<String?> origin = const Value.absent(),
                Value<String?> guardia = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
              }) => PerformedProceduresCompanion.insert(
                id: id,
                admissionId: admissionId,
                procedureId: procedureId,
                procedureName: procedureName,
                performedAt: performedAt,
                assistant: assistant,
                resident: resident,
                origin: origin,
                guardia: guardia,
                note: note,
                createdAt: createdAt,
                isSynced: isSynced,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PerformedProceduresTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({admissionId = false, procedureId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
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
                      dynamic
                    >
                  >(state) {
                    if (admissionId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.admissionId,
                                referencedTable:
                                    $$PerformedProceduresTableReferences
                                        ._admissionIdTable(db),
                                referencedColumn:
                                    $$PerformedProceduresTableReferences
                                        ._admissionIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (procedureId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.procedureId,
                                referencedTable:
                                    $$PerformedProceduresTableReferences
                                        ._procedureIdTable(db),
                                referencedColumn:
                                    $$PerformedProceduresTableReferences
                                        ._procedureIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PerformedProceduresTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PerformedProceduresTable,
      PerformedProcedure,
      $$PerformedProceduresTableFilterComposer,
      $$PerformedProceduresTableOrderingComposer,
      $$PerformedProceduresTableAnnotationComposer,
      $$PerformedProceduresTableCreateCompanionBuilder,
      $$PerformedProceduresTableUpdateCompanionBuilder,
      (PerformedProcedure, $$PerformedProceduresTableReferences),
      PerformedProcedure,
      PrefetchHooks Function({bool admissionId, bool procedureId})
    >;
typedef $$ExamTemplatesTableCreateCompanionBuilder =
    ExamTemplatesCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> category,
      Value<String?> description,
      required String fieldsJson,
      Value<int> version,
      Value<bool> isArchived,
      Value<String?> createdBy,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<bool> isSynced,
    });
typedef $$ExamTemplatesTableUpdateCompanionBuilder =
    ExamTemplatesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> category,
      Value<String?> description,
      Value<String> fieldsJson,
      Value<int> version,
      Value<bool> isArchived,
      Value<String?> createdBy,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<bool> isSynced,
    });

final class $$ExamTemplatesTableReferences
    extends BaseReferences<_$AppDatabase, $ExamTemplatesTable, ExamTemplate> {
  $$ExamTemplatesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$ExamResultsTable, List<ExamResult>>
  _examResultsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.examResults,
    aliasName: $_aliasNameGenerator(
      db.examTemplates.id,
      db.examResults.templateId,
    ),
  );

  $$ExamResultsTableProcessedTableManager get examResultsRefs {
    final manager = $$ExamResultsTableTableManager(
      $_db,
      $_db.examResults,
    ).filter((f) => f.templateId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_examResultsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ExamTemplatesTableFilterComposer
    extends Composer<_$AppDatabase, $ExamTemplatesTable> {
  $$ExamTemplatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fieldsJson => $composableBuilder(
    column: $table.fieldsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> examResultsRefs(
    Expression<bool> Function($$ExamResultsTableFilterComposer f) f,
  ) {
    final $$ExamResultsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.examResults,
      getReferencedColumn: (t) => t.templateId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExamResultsTableFilterComposer(
            $db: $db,
            $table: $db.examResults,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ExamTemplatesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExamTemplatesTable> {
  $$ExamTemplatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fieldsJson => $composableBuilder(
    column: $table.fieldsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ExamTemplatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExamTemplatesTable> {
  $$ExamTemplatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fieldsJson => $composableBuilder(
    column: $table.fieldsJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => column,
  );

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  Expression<T> examResultsRefs<T extends Object>(
    Expression<T> Function($$ExamResultsTableAnnotationComposer a) f,
  ) {
    final $$ExamResultsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.examResults,
      getReferencedColumn: (t) => t.templateId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExamResultsTableAnnotationComposer(
            $db: $db,
            $table: $db.examResults,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ExamTemplatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExamTemplatesTable,
          ExamTemplate,
          $$ExamTemplatesTableFilterComposer,
          $$ExamTemplatesTableOrderingComposer,
          $$ExamTemplatesTableAnnotationComposer,
          $$ExamTemplatesTableCreateCompanionBuilder,
          $$ExamTemplatesTableUpdateCompanionBuilder,
          (ExamTemplate, $$ExamTemplatesTableReferences),
          ExamTemplate,
          PrefetchHooks Function({bool examResultsRefs})
        > {
  $$ExamTemplatesTableTableManager(_$AppDatabase db, $ExamTemplatesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExamTemplatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExamTemplatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExamTemplatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String> fieldsJson = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<String?> createdBy = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
              }) => ExamTemplatesCompanion(
                id: id,
                name: name,
                category: category,
                description: description,
                fieldsJson: fieldsJson,
                version: version,
                isArchived: isArchived,
                createdBy: createdBy,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isSynced: isSynced,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> category = const Value.absent(),
                Value<String?> description = const Value.absent(),
                required String fieldsJson,
                Value<int> version = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<String?> createdBy = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
              }) => ExamTemplatesCompanion.insert(
                id: id,
                name: name,
                category: category,
                description: description,
                fieldsJson: fieldsJson,
                version: version,
                isArchived: isArchived,
                createdBy: createdBy,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isSynced: isSynced,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ExamTemplatesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({examResultsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (examResultsRefs) db.examResults],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (examResultsRefs)
                    await $_getPrefetchedData<
                      ExamTemplate,
                      $ExamTemplatesTable,
                      ExamResult
                    >(
                      currentTable: table,
                      referencedTable: $$ExamTemplatesTableReferences
                          ._examResultsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ExamTemplatesTableReferences(
                            db,
                            table,
                            p0,
                          ).examResultsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.templateId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ExamTemplatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExamTemplatesTable,
      ExamTemplate,
      $$ExamTemplatesTableFilterComposer,
      $$ExamTemplatesTableOrderingComposer,
      $$ExamTemplatesTableAnnotationComposer,
      $$ExamTemplatesTableCreateCompanionBuilder,
      $$ExamTemplatesTableUpdateCompanionBuilder,
      (ExamTemplate, $$ExamTemplatesTableReferences),
      ExamTemplate,
      PrefetchHooks Function({bool examResultsRefs})
    >;
typedef $$ExamResultsTableCreateCompanionBuilder =
    ExamResultsCompanion Function({
      Value<int> id,
      required int admissionId,
      required int templateId,
      Value<int> templateVersion,
      Value<DateTime> recordedAt,
      required String valuesJson,
      Value<String?> note,
      Value<String?> attachments,
      Value<String?> recordedBy,
      Value<DateTime> createdAt,
      Value<bool> isSynced,
    });
typedef $$ExamResultsTableUpdateCompanionBuilder =
    ExamResultsCompanion Function({
      Value<int> id,
      Value<int> admissionId,
      Value<int> templateId,
      Value<int> templateVersion,
      Value<DateTime> recordedAt,
      Value<String> valuesJson,
      Value<String?> note,
      Value<String?> attachments,
      Value<String?> recordedBy,
      Value<DateTime> createdAt,
      Value<bool> isSynced,
    });

final class $$ExamResultsTableReferences
    extends BaseReferences<_$AppDatabase, $ExamResultsTable, ExamResult> {
  $$ExamResultsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AdmissionsTable _admissionIdTable(_$AppDatabase db) =>
      db.admissions.createAlias(
        $_aliasNameGenerator(db.examResults.admissionId, db.admissions.id),
      );

  $$AdmissionsTableProcessedTableManager get admissionId {
    final $_column = $_itemColumn<int>('admission_id')!;

    final manager = $$AdmissionsTableTableManager(
      $_db,
      $_db.admissions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_admissionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ExamTemplatesTable _templateIdTable(_$AppDatabase db) =>
      db.examTemplates.createAlias(
        $_aliasNameGenerator(db.examResults.templateId, db.examTemplates.id),
      );

  $$ExamTemplatesTableProcessedTableManager get templateId {
    final $_column = $_itemColumn<int>('template_id')!;

    final manager = $$ExamTemplatesTableTableManager(
      $_db,
      $_db.examTemplates,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_templateIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ExamResultsTableFilterComposer
    extends Composer<_$AppDatabase, $ExamResultsTable> {
  $$ExamResultsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get templateVersion => $composableBuilder(
    column: $table.templateVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get valuesJson => $composableBuilder(
    column: $table.valuesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get attachments => $composableBuilder(
    column: $table.attachments,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recordedBy => $composableBuilder(
    column: $table.recordedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  $$AdmissionsTableFilterComposer get admissionId {
    final $$AdmissionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.admissionId,
      referencedTable: $db.admissions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AdmissionsTableFilterComposer(
            $db: $db,
            $table: $db.admissions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExamTemplatesTableFilterComposer get templateId {
    final $$ExamTemplatesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.templateId,
      referencedTable: $db.examTemplates,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExamTemplatesTableFilterComposer(
            $db: $db,
            $table: $db.examTemplates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExamResultsTableOrderingComposer
    extends Composer<_$AppDatabase, $ExamResultsTable> {
  $$ExamResultsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get templateVersion => $composableBuilder(
    column: $table.templateVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get valuesJson => $composableBuilder(
    column: $table.valuesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get attachments => $composableBuilder(
    column: $table.attachments,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recordedBy => $composableBuilder(
    column: $table.recordedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  $$AdmissionsTableOrderingComposer get admissionId {
    final $$AdmissionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.admissionId,
      referencedTable: $db.admissions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AdmissionsTableOrderingComposer(
            $db: $db,
            $table: $db.admissions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExamTemplatesTableOrderingComposer get templateId {
    final $$ExamTemplatesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.templateId,
      referencedTable: $db.examTemplates,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExamTemplatesTableOrderingComposer(
            $db: $db,
            $table: $db.examTemplates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExamResultsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExamResultsTable> {
  $$ExamResultsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get templateVersion => $composableBuilder(
    column: $table.templateVersion,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get valuesJson => $composableBuilder(
    column: $table.valuesJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get attachments => $composableBuilder(
    column: $table.attachments,
    builder: (column) => column,
  );

  GeneratedColumn<String> get recordedBy => $composableBuilder(
    column: $table.recordedBy,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  $$AdmissionsTableAnnotationComposer get admissionId {
    final $$AdmissionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.admissionId,
      referencedTable: $db.admissions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AdmissionsTableAnnotationComposer(
            $db: $db,
            $table: $db.admissions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExamTemplatesTableAnnotationComposer get templateId {
    final $$ExamTemplatesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.templateId,
      referencedTable: $db.examTemplates,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExamTemplatesTableAnnotationComposer(
            $db: $db,
            $table: $db.examTemplates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExamResultsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExamResultsTable,
          ExamResult,
          $$ExamResultsTableFilterComposer,
          $$ExamResultsTableOrderingComposer,
          $$ExamResultsTableAnnotationComposer,
          $$ExamResultsTableCreateCompanionBuilder,
          $$ExamResultsTableUpdateCompanionBuilder,
          (ExamResult, $$ExamResultsTableReferences),
          ExamResult,
          PrefetchHooks Function({bool admissionId, bool templateId})
        > {
  $$ExamResultsTableTableManager(_$AppDatabase db, $ExamResultsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExamResultsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExamResultsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExamResultsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> admissionId = const Value.absent(),
                Value<int> templateId = const Value.absent(),
                Value<int> templateVersion = const Value.absent(),
                Value<DateTime> recordedAt = const Value.absent(),
                Value<String> valuesJson = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String?> attachments = const Value.absent(),
                Value<String?> recordedBy = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
              }) => ExamResultsCompanion(
                id: id,
                admissionId: admissionId,
                templateId: templateId,
                templateVersion: templateVersion,
                recordedAt: recordedAt,
                valuesJson: valuesJson,
                note: note,
                attachments: attachments,
                recordedBy: recordedBy,
                createdAt: createdAt,
                isSynced: isSynced,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int admissionId,
                required int templateId,
                Value<int> templateVersion = const Value.absent(),
                Value<DateTime> recordedAt = const Value.absent(),
                required String valuesJson,
                Value<String?> note = const Value.absent(),
                Value<String?> attachments = const Value.absent(),
                Value<String?> recordedBy = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
              }) => ExamResultsCompanion.insert(
                id: id,
                admissionId: admissionId,
                templateId: templateId,
                templateVersion: templateVersion,
                recordedAt: recordedAt,
                valuesJson: valuesJson,
                note: note,
                attachments: attachments,
                recordedBy: recordedBy,
                createdAt: createdAt,
                isSynced: isSynced,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ExamResultsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({admissionId = false, templateId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
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
                      dynamic
                    >
                  >(state) {
                    if (admissionId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.admissionId,
                                referencedTable: $$ExamResultsTableReferences
                                    ._admissionIdTable(db),
                                referencedColumn: $$ExamResultsTableReferences
                                    ._admissionIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (templateId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.templateId,
                                referencedTable: $$ExamResultsTableReferences
                                    ._templateIdTable(db),
                                referencedColumn: $$ExamResultsTableReferences
                                    ._templateIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ExamResultsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExamResultsTable,
      ExamResult,
      $$ExamResultsTableFilterComposer,
      $$ExamResultsTableOrderingComposer,
      $$ExamResultsTableAnnotationComposer,
      $$ExamResultsTableCreateCompanionBuilder,
      $$ExamResultsTableUpdateCompanionBuilder,
      (ExamResult, $$ExamResultsTableReferences),
      ExamResult,
      PrefetchHooks Function({bool admissionId, bool templateId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PatientsTableTableManager get patients =>
      $$PatientsTableTableManager(_db, _db.patients);
  $$AdmissionsTableTableManager get admissions =>
      $$AdmissionsTableTableManager(_db, _db.admissions);
  $$EvolutionsTableTableManager get evolutions =>
      $$EvolutionsTableTableManager(_db, _db.evolutions);
  $$IndicationSheetsTableTableManager get indicationSheets =>
      $$IndicationSheetsTableTableManager(_db, _db.indicationSheets);
  $$EpicrisisNotesTableTableManager get epicrisisNotes =>
      $$EpicrisisNotesTableTableManager(_db, _db.epicrisisNotes);
  $$ProceduresTableTableManager get procedures =>
      $$ProceduresTableTableManager(_db, _db.procedures);
  $$PerformedProceduresTableTableManager get performedProcedures =>
      $$PerformedProceduresTableTableManager(_db, _db.performedProcedures);
  $$ExamTemplatesTableTableManager get examTemplates =>
      $$ExamTemplatesTableTableManager(_db, _db.examTemplates);
  $$ExamResultsTableTableManager get examResults =>
      $$ExamResultsTableTableManager(_db, _db.examResults);
}
