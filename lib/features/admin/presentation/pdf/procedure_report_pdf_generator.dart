import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ProcedureReportPdfGenerator {
  static Future<void> generateAndPrint({
    required String periodLabel,
    required List<List<String>> rows,
  }) async {
    final pdf = pw.Document();
    final headers = const [
      'FECHA y HORA',
      'CAMA / SERVICIO',
      'PACIENTE',
      'HC',
      'DIAGNÓSTICO',
      'PROCEDIMIENTO',
      'ASISTENTE',
      'RESIDENTE',
    ];

    final headerSection = await _buildHeader(periodLabel);
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        margin: const pw.EdgeInsets.all(18),
        build: (context) => [
          headerSection,
          pw.SizedBox(height: 12),
          _buildTable(headers, rows),
        ],
      ),
    );

    await Printing.layoutPdf(
      name: 'Procedimientos_$periodLabel.pdf',
      onLayout: (format) async => pdf.save(),
    );
  }

  static Future<pw.Widget> _buildHeader(String periodLabel) async {
    pw.ImageProvider? logoImage;
    try {
      logoImage = await imageFromAssetBundle('assets/images/logo_hospital.jpeg');
    } catch (_) {}

    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        if (logoImage != null)
          pw.Container(
            width: 60,
            height: 60,
            margin: const pw.EdgeInsets.only(right: 12),
            child: pw.Image(logoImage),
          ),
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'UNIDAD DE CUIDADOS INTENSIVOS',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                  letterSpacing: 0.5,
                  color: PdfColors.blueGrey900,
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                'REPORTE DE PROCEDIMIENTOS',
                style: pw.TextStyle(
                  fontSize: 12,
                  color: PdfColors.blueGrey700,
                ),
              ),
              pw.Text(
                periodLabel,
                style: pw.TextStyle(
                  fontSize: 11,
                  color: PdfColors.blueGrey700,
                ),
              ),
            ],
          ),
        ),
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.blueGrey400, width: 0.5),
            borderRadius: pw.BorderRadius.circular(6),
          ),
          child: pw.Text(
            'Formato Excel oficial',
            style: pw.TextStyle(
              fontSize: 9,
              color: PdfColors.blueGrey700,
            ),
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildTable(List<String> headers, List<List<String>> rows) {
    return pw.Table.fromTextArray(
      headers: headers,
      data: rows,
      headerStyle: pw.TextStyle(
        fontWeight: pw.FontWeight.bold,
        color: PdfColors.white,
      ),
      headerDecoration: const pw.BoxDecoration(
        color: PdfColors.blueGrey800,
      ),
      headerAlignment: pw.Alignment.centerLeft,
      cellStyle: const pw.TextStyle(fontSize: 9),
      cellAlignment: pw.Alignment.topLeft,
      border: pw.TableBorder.symmetric(
        inside: const pw.BorderSide(color: PdfColors.grey300, width: 0.3),
        outside: const pw.BorderSide(color: PdfColors.grey500, width: 0.5),
      ),
      cellHeight: 30,
      columnWidths: {
        0: const pw.FlexColumnWidth(1.5),
        1: const pw.FlexColumnWidth(1.5),
        2: const pw.FlexColumnWidth(1.9),
        3: const pw.FlexColumnWidth(1.1),
        4: const pw.FlexColumnWidth(2.2),
        5: const pw.FlexColumnWidth(1.6),
        6: const pw.FlexColumnWidth(1.2),
        7: const pw.FlexColumnWidth(1.2),
      },
      rowDecoration: const pw.BoxDecoration(color: PdfColors.white),
      oddRowDecoration: const pw.BoxDecoration(color: PdfColors.grey100),
    );
  }
}
