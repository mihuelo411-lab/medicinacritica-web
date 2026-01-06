import 'package:equatable/equatable.dart';

class PatientProfile extends Equatable {
  const PatientProfile({
    required this.id,
    required this.fullName,
    required this.age,
    required this.sex,
    required this.diagnosis,
    required this.weightKg,
    required this.heightCm,
    this.bedNumber,
    this.supportType,
    this.notes,
    this.createdAt,
    this.updatedAt,
  });

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
  final DateTime? createdAt;
  final DateTime? updatedAt;

  @override
  List<Object?> get props => [
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
        updatedAt,
      ];

  PatientProfile copyWith({
    String? id,
    String? fullName,
    int? age,
    String? sex,
    String? diagnosis,
    double? weightKg,
    double? heightCm,
    Object? bedNumber = _sentinel,
    String? supportType,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PatientProfile(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      age: age ?? this.age,
      sex: sex ?? this.sex,
      diagnosis: diagnosis ?? this.diagnosis,
      weightKg: weightKg ?? this.weightKg,
      heightCm: heightCm ?? this.heightCm,
      bedNumber: identical(bedNumber, _sentinel)
          ? this.bedNumber
          : bedNumber as String?,
      supportType: supportType ?? this.supportType,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static const Object _sentinel = Object();
}
