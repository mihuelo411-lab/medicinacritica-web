import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

import 'package:nutrivigil/core/di/dependencies.dart';
import 'package:nutrivigil/domain/care_episode/care_episode.dart';
import 'package:nutrivigil/domain/reporting/report_service.dart';

class ReportPreviewPage extends StatelessWidget {
  const ReportPreviewPage({
    super.key,
    required this.patientId,
    required this.patientName,
    this.episode,
  });

  final String patientId;
  final String patientName;
  final CareEpisode? episode;

  @override
  Widget build(BuildContext context) {
    final fileName = 'NutriVigil_${patientName.replaceAll(' ', '_')}.pdf';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reporte nutricional'),
      ),
      body: PdfPreview(
        padding: const EdgeInsets.all(8),
        pdfFileName: fileName,
        canChangePageFormat: false,
        canChangeOrientation: false,
        build: (_) => sl<ReportService>().buildPatientSummary(
          patientId,
          episode: episode,
        ),
      ),
    );
  }
}
