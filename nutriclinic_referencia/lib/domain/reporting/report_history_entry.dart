import 'dart:convert';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';

class ReportHistoryEntry extends Equatable {
  const ReportHistoryEntry({
    required this.id,
    required this.patientId,
    required this.patientName,
    required this.createdAt,
    required this.pdfData,
  });

  final String id;
  final String patientId;
  final String patientName;
  final DateTime createdAt;
  final Uint8List pdfData;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'patientName': patientName,
      'createdAt': createdAt.toIso8601String(),
      'pdfData': base64Encode(pdfData),
    };
  }

  factory ReportHistoryEntry.fromJson(Map<String, dynamic> json) {
    return ReportHistoryEntry(
      id: json['id'] as String,
      patientId: json['patientId'] as String,
      patientName: json['patientName'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      pdfData: base64Decode(json['pdfData'] as String),
    );
  }

  @override
  List<Object?> get props => [id, patientId, patientName, createdAt, pdfData];
}
