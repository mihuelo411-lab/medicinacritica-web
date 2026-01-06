import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';

import 'package:nutrivigil/core/di/dependencies.dart';
import 'package:nutrivigil/data/repositories/report_history_repository.dart';
import 'package:nutrivigil/domain/reporting/report_history_entry.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  late Future<List<ReportHistoryEntry>> _entriesFuture;

  @override
  void initState() {
    super.initState();
    _entriesFuture = _loadEntries();
  }

  Future<List<ReportHistoryEntry>> _loadEntries() {
    return sl<ReportHistoryRepository>().fetchAll();
  }

  Future<void> _refresh() async {
    setState(() {
      _entriesFuture = _loadEntries();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Historial nutricional')),
      body: FutureBuilder<List<ReportHistoryEntry>>(
        future: _entriesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'No se pudo cargar el historial: ${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          final entries = snapshot.data ?? const [];
          if (entries.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Aún no has finalizado ninguna evaluación. Guarda un PDF desde la Síntesis del episodio y aparecerá aquí.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            );
          }
          final summaries = _groupByPatient(entries);
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final summary = summaries[index];
                final latestDate =
                    DateFormat('dd/MM/yyyy HH:mm').format(summary.latestEntry.createdAt);
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.folder_shared_outlined),
                    title: Text(summary.patientName),
                    subtitle: Text('Último informe: $latestDate'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (summary.entries.length > 1)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${summary.entries.length}',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        const Icon(Icons.chevron_right),
                      ],
                    ),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => _PatientHistoryDetailPage(summary: summary),
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemCount: summaries.length,
            ),
          );
        },
      ),
    );
  }

  List<_PatientHistorySummary> _groupByPatient(List<ReportHistoryEntry> entries) {
    final ordered = entries.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final grouped = <String, _PatientHistorySummary>{};
    for (final entry in ordered) {
      final summary = grouped.putIfAbsent(
        entry.patientId,
        () => _PatientHistorySummary(
          patientId: entry.patientId,
          patientName: entry.patientName,
        ),
      );
      summary.entries.add(entry);
    }
    final summaries = grouped.values.toList()
      ..sort(
        (a, b) => b.latestEntry.createdAt.compareTo(a.latestEntry.createdAt),
      );
    return summaries;
  }
}

class _PatientHistoryDetailPage extends StatelessWidget {
  const _PatientHistoryDetailPage({required this.summary});

  final _PatientHistorySummary summary;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final latest = summary.latestEntry;
    final followUps = summary.entries.skip(1).toList();
    final df = DateFormat('dd/MM/yyyy HH:mm');

    return Scaffold(
      appBar: AppBar(title: Text(summary.patientName)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Evaluación nutricional',
                    style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Generada el ${df.format(latest.createdAt)}. Incluye antropometría, escalas de riesgo, plan energético y recomendaciones.',
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => _ReportPdfViewerPage(entry: latest),
                      ),
                    ),
                    icon: const Icon(Icons.picture_as_pdf),
                    label: const Text('Abrir / reimprimir PDF'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Seguimientos nutricionales',
                    style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  if (followUps.isEmpty)
                    Text(
                      'Aún no se registran seguimientos para este paciente. Podrás documentarlos desde los módulos diarios.',
                      style: textTheme.bodyMedium,
                    )
                  else ...[
                    Text(
                      'Historial de reportes:',
                      style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    ...followUps.map(
                      (entry) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.event_note),
                        title: Text(df.format(entry.createdAt)),
                        trailing: IconButton(
                          icon: const Icon(Icons.picture_as_pdf),
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => _ReportPdfViewerPage(entry: entry),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  Text(
                    'Próximamente podrás iniciar nuevas evaluaciones de seguimiento directamente desde aquí.',
                    style: textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReportPdfViewerPage extends StatelessWidget {
  const _ReportPdfViewerPage({required this.entry});

  final ReportHistoryEntry entry;

  @override
  Widget build(BuildContext context) {
    final fileName =
        'NutriVigil_${entry.patientName.replaceAll(' ', '_')}_${entry.createdAt.millisecondsSinceEpoch}.pdf';
    return Scaffold(
      appBar: AppBar(title: Text(entry.patientName)),
      body: PdfPreview(
        canChangePageFormat: false,
        canChangeOrientation: false,
        pdfFileName: fileName,
        build: (_) async => entry.pdfData,
      ),
    );
  }
}

class _PatientHistorySummary {
  _PatientHistorySummary({
    required this.patientId,
    required this.patientName,
  });

  final String patientId;
  final String patientName;
  final List<ReportHistoryEntry> entries = [];

  ReportHistoryEntry get latestEntry => entries.first;
}
