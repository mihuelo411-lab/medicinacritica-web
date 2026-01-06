import 'package:intl/intl.dart';

class ProcedureNarrativeEntry {
  final String procedureName;
  final DateTime performedAt;
  final String? assistant;
  final String? resident;
  final String? guardia;
  final String? note;

  const ProcedureNarrativeEntry({
    required this.procedureName,
    required this.performedAt,
    this.assistant,
    this.resident,
    this.guardia,
    this.note,
  });

  String formatLine() {
    final ts = DateFormat('dd/MM HH:mm').format(performedAt);
    final tags = <String>[];
    final assistantClean = assistant?.trim();
    final residentClean = resident?.trim();
    final guardiaClean = guardia?.trim();
    if (assistantClean != null && assistantClean.isNotEmpty) {
      tags.add('A: $assistantClean');
    }
    if (residentClean != null && residentClean.isNotEmpty) {
      tags.add('R: $residentClean');
    }
    if (guardiaClean != null && guardiaClean.isNotEmpty) {
      tags.add(guardiaClean);
    }
    final header = StringBuffer('$ts • $procedureName');
    if (tags.isNotEmpty) {
      header.write(' (${tags.join(' | ')})');
    }
    final noteClean = note?.trim();
    if (noteClean != null && noteClean.isNotEmpty) {
      header.write('\n$noteClean');
    }
    return header.toString();
  }
}

String buildProcedureNarrative({
  String? generalNotes,
  Iterable<ProcedureNarrativeEntry> entries = const [],
}) {
  final buffer = StringBuffer();
  final general = generalNotes?.trim();
  if (general != null && general.isNotEmpty) {
    buffer.writeln(general);
  }

  final sortedEntries = entries
      .where((entry) => entry.procedureName.trim().isNotEmpty)
      .toList()
    ..sort((a, b) => a.performedAt.compareTo(b.performedAt));
  if (sortedEntries.isNotEmpty) {
    if (buffer.isNotEmpty) {
      buffer.writeln();
    }
    buffer.writeln('Procedimientos registrados:');
    for (final entry in sortedEntries) {
      buffer.writeln(entry.formatLine());
      buffer.writeln();
    }
  }
  return buffer.toString().trim();
}
