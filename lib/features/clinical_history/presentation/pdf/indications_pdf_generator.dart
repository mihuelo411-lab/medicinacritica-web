import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../../../core/database/database.dart';

class IndicationsPdfGenerator {
  static Future<void> generateAndPrint({
    required Patient patient,
    required Admission admission,
    required String sheetNumber,
    required String unit,
    required String expediente,
    required String service,
    required String date,
    required String time,
    required String gender,
    required String weight,
    required String height,
    required String physician,
    required String diagnosis,
    required List<Map<String, String>> indications,
    required String comment,
    Map<String, dynamic>? signatures,
  }) async {
    final doc = pw.Document();
    final sanitizedPhysician = physician.trim().isEmpty ? 'Medico' : physician.trim();

    pw.ImageProvider? logoImage;
    try {
      logoImage = await imageFromAssetBundle('assets/images/logo_hospital.jpeg');
    } catch (_) {}

    doc.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          margin: const pw.EdgeInsets.all(24),
        ),
        header: (context) => _buildHeader(
          logoImage,
          sheetNumber,
          admission.bedNumber,
        ),
        build: (context) => [
          _buildGeneralInfoSection(
            unit: unit,
            expediente: expediente,
            service: service,
            date: date,
            time: time,
            gender: gender,
            patient: patient,
            weight: weight,
            height: height,
          ),
          pw.SizedBox(height: 12),
          _buildDiagnosisSection(diagnosis),
          pw.SizedBox(height: 12),
          _buildIndicationsSection(indications),
          pw.SizedBox(height: 12),
          _buildObservationsSection(weight: weight, height: height, comment: comment),
          pw.SizedBox(height: 24),
          _buildSignatureSection(signatures, physician),
        ],
      ),
    );

    final bytes = await doc.save();
    final printingInfo = await Printing.info();
    if (printingInfo.canPrint) {
      await Printing.layoutPdf(
        onLayout: (_) async => bytes,
        name: _buildFileName(patient.name, sanitizedPhysician),
      );
    } else {
      await Printing.sharePdf(
        bytes: bytes,
        filename: _buildFileName(patient.name, sanitizedPhysician),
      );
    }
  }

  static String _buildFileName(String patientName, String physicianName) {
    final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
    final cleanPatient = patientName.replaceAll(' ', '_');
    final cleanPhysician = physicianName.replaceAll(' ', '_');
    return 'Indicaciones_${cleanPatient}_${cleanPhysician}_$timestamp.pdf';
  }

  static pw.Widget _buildHeader(
    pw.ImageProvider? logo,
    String sheetNumber,
    int? bedNumber,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            if (logo != null) pw.Image(logo, width: 48, height: 48),
            pw.Column(
              children: [
                pw.Text(
                  'HOSPITAL REGIONAL DOCENTE',
                  style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
                ),
                pw.Text(
                  'UNIDAD DE CUIDADOS INTENSIVOS',
                  style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.normal),
                ),
                pw.Text(
                  'HOJA DE INDICACIONES MÉDICAS',
                  style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
                ),
              ],
            ),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                if (bedNumber != null)
                  pw.Text('Cama $bedNumber', style: const pw.TextStyle(fontSize: 10)),
                pw.Text('Hoja No. $sheetNumber', style: const pw.TextStyle(fontSize: 10)),
              ],
            ),
          ],
        ),
        pw.SizedBox(height: 4),
        pw.Divider(thickness: 1),
      ],
    );
  }

  static pw.Widget _buildGeneralInfoSection({
    required String unit,
    required String expediente,
    required String service,
    required String date,
    required String time,
    required String gender,
    required Patient patient,
    required String weight,
    required String height,
  }) {
    pw.Widget field(String label, String value) {
      return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
          ),
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(vertical: 2),
            decoration: const pw.BoxDecoration(
              border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey300)),
            ),
            child: pw.Text(value.isEmpty ? '-' : value, style: const pw.TextStyle(fontSize: 11)),
          ),
        ],
      );
    }

    return pw.Column(
      children: [
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(child: field('Unidad médica', unit)),
            pw.SizedBox(width: 16),
            pw.Expanded(child: field('Paciente', patient.name)),
            pw.SizedBox(width: 16),
            pw.SizedBox(
              width: 80,
              child: field('Edad', '${patient.age} años'),
            ),
          ],
        ),
        pw.SizedBox(height: 8),
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(child: field('No. expediente', expediente)),
            pw.SizedBox(width: 16),
            pw.Expanded(child: field('Servicio', service)),
            pw.SizedBox(width: 16),
            pw.SizedBox(
              width: 80,
              child: field('Género', gender),
            ),
          ],
        ),
        pw.SizedBox(height: 8),
        pw.Row(
          children: [
            pw.Expanded(child: field('Fecha', date)),
            pw.SizedBox(width: 16),
            pw.SizedBox(width: 100, child: field('Hora', time)),
            pw.SizedBox(width: 16),
            pw.SizedBox(width: 100, child: field('Peso (kg)', weight)),
            pw.SizedBox(width: 16),
            pw.SizedBox(width: 100, child: field('Talla (cm)', height)),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildDiagnosisSection(String diagnosis) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Container(
          width: double.infinity,
          color: PdfColors.grey300,
          padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: pw.Text('Diagnóstico(s)',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        ),
        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.all(8),
          child: pw.Text(
            diagnosis.isEmpty ? 'Sin diagnóstico registrado.' : diagnosis,
            style: const pw.TextStyle(fontSize: 11),
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildIndicationsSection(List<Map<String, String>> indications) {
    if (indications.isEmpty) {
      return pw.Container(
        width: double.infinity,
        padding: const pw.EdgeInsets.all(8),
        decoration: pw.BoxDecoration(
          border: pw.Border.all(color: PdfColors.grey300),
        ),
        child: pw.Text('Sin indicaciones registradas.'),
      );
    }

    final rows = indications
        .map((item) => pw.TableRow(children: [
              _cellText(item['hora'] ?? ''),
              _cellText(item['texto'] ?? ''),
            ]))
        .toList();

    return pw.Table(
      columnWidths: {
        0: const pw.FlexColumnWidth(1),
        1: const pw.FlexColumnWidth(4),
      },
      border: pw.TableBorder.all(color: PdfColors.grey400),
      children: [
        pw.TableRow(
          decoration: pw.BoxDecoration(color: PdfColors.grey200),
          children: [
            _cellHeader('Hora'),
            _cellHeader('Indicaciones'),
          ],
        ),
        ...rows,
      ],
    );
  }

  static pw.Widget _buildObservationsSection({
    required String weight,
    required String height,
    required String comment,
  }) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Datos antropométricos',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 4),
        pw.Text('Peso: ${weight.isEmpty ? "-" : weight} kg'),
        pw.Text('Talla: ${height.isEmpty ? "-" : height} cm'),
        pw.SizedBox(height: 8),
        pw.Text('Comentarios / Observaciones',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.all(8),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.grey300),
          ),
          child: pw.Text(
            comment.isEmpty ? 'Sin observaciones adicionales.' : comment,
            style: const pw.TextStyle(fontSize: 11),
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildSignatureSection(Map<String, dynamic>? signatures, String fallbackPhysician) {
    final medico = signatures?['medico'];
    final residente = signatures?['residente'];
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        _signatureLine(
          title: 'Médico tratante',
          data: medico ?? (fallbackPhysician.isNotEmpty ? {'nombre': fallbackPhysician} : null),
        ),
        pw.SizedBox(height: 18),
        _signatureLine(
          title: 'Residente',
          data: residente,
        ),
      ],
    );
  }

  static pw.Widget _signatureLine({required String title, Map<String, dynamic>? data}) {
    final name = data == null ? '' : (data['nombre']?.toString() ?? '');
    final cmp = data == null ? '' : (data['cmp']?.toString() ?? '');
    final displayName = name.isEmpty ? '__________________________' : name;
    final cmpText = cmp.isNotEmpty ? ' (CMP: $cmp)' : '';
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Text('$title - Firma y sello', style: pw.TextStyle(fontSize: 11)),
        pw.SizedBox(height: 40),
        pw.Container(height: 1, color: PdfColors.grey700),
        pw.SizedBox(height: 4),
        pw.Text('$displayName$cmpText', style: const pw.TextStyle(fontSize: 11)),
      ],
    );
  }

  static pw.Widget _cellHeader(String text) => pw.Container(
        alignment: pw.Alignment.centerLeft,
        padding: const pw.EdgeInsets.all(6),
        child: pw.Text(
          text,
          style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
        ),
      );

  static pw.Widget _cellText(String text) => pw.Container(
        alignment: pw.Alignment.centerLeft,
        padding: const pw.EdgeInsets.all(6),
        child: pw.Text(
          text.isEmpty ? '-' : text,
          style: pw.TextStyle(fontSize: 10),
        ),
      );
}
