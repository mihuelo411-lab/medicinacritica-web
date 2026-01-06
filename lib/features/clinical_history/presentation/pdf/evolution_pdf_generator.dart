import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../../../core/database/database.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' show PdfGoogleFonts;

class EvolutionPdfGenerator {
  static Future<void> generateAndPrint({
    required Patient patient,
    required Admission admission,
    String? currentDiagnosis, // New parameter
    required Map<String, String> vitals,
    required Map<String, String> vmSettings,
    required Map<String, String> vmMechanics,
    required String subjective,
    required Map<String, String> objective, // Systems
    required String analysis,
    required String plan,
    required String guardia,
    required DateTime noteDateTime,
    required String procedures,
    String? preparedByName,
    String? preparedByRole,
  }) async {
    // Use currentDiagnosis if provided, else fallback to admission
    final String printDiagnosis = (currentDiagnosis != null && currentDiagnosis.isNotEmpty) 
        ? currentDiagnosis 
        : (admission.diagnosis ?? '-');

    // Load Logo safely
    pw.ImageProvider? logoImage;
    try {
      logoImage = await imageFromAssetBundle('assets/images/logo_hospital.jpeg');
    } catch (e) {
      print('Error loading logo: $e');
    }

    // Load Fonts safely
    pw.Font fontRegular;
    pw.Font fontBold;
    try {
      fontRegular = await PdfGoogleFonts.openSansRegular();
      fontBold = await PdfGoogleFonts.openSansBold();
    } catch (e) {
      fontRegular = pw.Font.courier();
      fontBold = pw.Font.courierBold();
    }

    // Autoscale to guarantee a single page sin perder datos
    double fontSize = 10.0;
    pw.Document? bestPdf;

    while (fontSize >= 5.5) {
      final candidate = _buildDocument(
        baseFontSize: fontSize,
        margin: 14 - ((10.0 - fontSize) * 1.2), // reduce margins as we reduce font
        logoImage: logoImage,
        fontRegular: fontRegular,
        fontBold: fontBold,
      patient: patient,
      admission: admission,
      printDiagnosis: printDiagnosis,
      vitals: vitals,
      vmSettings: vmSettings,
      vmMechanics: vmMechanics,
      subjective: subjective,
        objective: objective,
        analysis: analysis,
        plan: plan,
        guardia: guardia,
        noteDateTime: noteDateTime,
        procedures: procedures,
        preparedByName: preparedByName,
        preparedByRole: preparedByRole,
      );

      bestPdf = candidate;
      if (candidate.document.pdfPageList.pages.length <= 1) {
        break;
      }
      fontSize -= 0.5;
    }

    if (bestPdf != null) {
      final bytes = await bestPdf.save();
      final info = await Printing.info();
      if (info.canPrint) {
        await Printing.layoutPdf(
          onLayout: (PdfPageFormat format) async => bytes,
          name: 'Evolucion_${patient.name}_${DateTime.now().toIso8601String()}',
        );
      } else {
        await Printing.sharePdf(
          bytes: bytes,
          filename: 'Evolucion_${patient.name}_${DateTime.now().toIso8601String()}.pdf',
        );
      }
    } else {
      print('EvolutionPdfGenerator: No se pudo generar el PDF (bestPdf=null)');
    }
  }

  static pw.Document _buildDocument({
    required double baseFontSize,
    required double margin,
    required pw.ImageProvider? logoImage,
    required pw.Font fontRegular,
    required pw.Font fontBold,
    required Patient patient,
    required Admission admission,
    required String printDiagnosis,
    required Map<String, String> vitals,
    required Map<String, String> vmSettings,
    required Map<String, String> vmMechanics,
    required String subjective,
    required Map<String, String> objective,
    required String analysis,
    required String plan,
    required String guardia,
    required DateTime noteDateTime,
    required String procedures,
    String? preparedByName,
    String? preparedByRole,
  }) {
    final pdf = pw.Document();
    final resolvedMargin = margin < 8 ? 8.0 : (margin > 16 ? 16.0 : margin);
    pdf.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          margin: pw.EdgeInsets.all(resolvedMargin),
          theme: pw.ThemeData.withFont(
            base: fontRegular,
            bold: fontBold,
          ).copyWith(defaultTextStyle: pw.TextStyle(fontSize: baseFontSize, font: fontRegular)),
        ),
        header: (context) => _buildHeader(logoImage, admission.bedNumber.toString(), baseFontSize),
        footer: (context) => _buildFooter(context, patient, admission.bedNumber.toString()),
        build: (context) => [
          _buildUserInfoSection(patient, admission, printDiagnosis, baseFontSize),
          pw.SizedBox(height: 4),
          _buildGuardiaBlock(guardia, noteDateTime, printDiagnosis, baseFontSize),
          pw.SizedBox(height: 6),

          // Vitales + VM en un bloque compacto
          _buildSectionHeader('I. FUNCIONES VITALES Y SOPORTE VENTILATORIO', baseFontSize),
          _buildVitalsAndVentilation(vitals, vmSettings, vmMechanics, baseFontSize),
          pw.SizedBox(height: 6),

          // SOAP
          _buildSectionHeader('II. EVOLUCIÓN CLÍNICA (SOAP)', baseFontSize),
          _buildSoapBlock('S (Subjetivo):', subjective, baseFontSize),
          _buildSoapBlock('O (Objetivo):', '', baseFontSize),
          pw.Padding(
            padding: const pw.EdgeInsets.only(left: 8, top: 2, bottom: 2),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: objective.entries.map((e) => 
                _buildSystemRow(e.key, e.value, baseFontSize)
              ).toList(),
            ),
          ),
          _buildSoapBlock('A (Análisis):', analysis, baseFontSize),
          _buildSoapBlock('P (Plan):', plan, baseFontSize),
          pw.SizedBox(height: 10),
          if (procedures.trim().isNotEmpty) ...[
            _buildSectionHeader('III. PROCEDIMIENTOS DEL TURNO', baseFontSize),
            _buildProceduresBlock(procedures, baseFontSize),
            pw.SizedBox(height: 10),
          ],

          _buildSignatureRow(baseFontSize,
              preparedByName: preparedByName,
              preparedByRole: preparedByRole),
        ],
      ),
    );
    return pdf;
  }

  static pw.Widget _buildHeader(pw.ImageProvider? logo, String bed, double baseFontSize) {
    return pw.Column(
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            if (logo != null) pw.Image(logo, width: 36, height: 36),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text('HOSPITAL REGIONAL DOCENTE DE TRUJILLO', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: baseFontSize + 1)),
                pw.Text('UNIDAD DE CUIDADOS INTENSIVOS', style: pw.TextStyle(fontSize: baseFontSize - 0.5)),
              ],
            ),
            pw.Text('CAMA: $bed', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: baseFontSize - 1)),
          ],
        ),
        pw.Divider(),
        pw.Center(child: pw.Text('NOTA DE EVOLUCIÓN MÉDICA', style: pw.TextStyle(fontSize: baseFontSize + 2, fontWeight: pw.FontWeight.bold, decoration: pw.TextDecoration.underline))),
        pw.SizedBox(height: 6),
      ],
    );
  }

  static pw.Widget _buildFooter(pw.Context context, Patient patient, String bed) {
    return pw.Container(
      decoration: const pw.BoxDecoration(border: pw.Border(top: pw.BorderSide(color: PdfColors.grey400))),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text('${patient.name} | HC: ${patient.hc}', style: const pw.TextStyle(fontSize: 8)),
          pw.Text('Pág. ${context.pageNumber} de ${context.pagesCount}', style: const pw.TextStyle(fontSize: 8)),
        ],
      )
    );
  }

  static pw.Widget _buildProceduresBlock(String procedures, double baseFontSize) {
    return pw.Container(
      width: double.infinity,
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(6),
      ),
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        procedures,
        style: pw.TextStyle(fontSize: baseFontSize),
      ),
    );
  }

  static pw.Widget _buildSectionHeader(String title, double baseFontSize) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 4, top: 4),
      padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      color: PdfColors.grey200,
      width: double.infinity,
      child: pw.Text(title, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: baseFontSize - 0.5)),
    );
  }

  static pw.Widget _buildUserInfoSection(Patient p, Admission a, String diagnosis, double baseFontSize) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(4),
      decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey400)),
      child: pw.Row(
        children: [
           pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.RichText(text: pw.TextSpan(children: [pw.TextSpan(text: 'Paciente: ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: baseFontSize - 0.5)), pw.TextSpan(text: p.name, style: pw.TextStyle(fontSize: baseFontSize - 1.5))])),
                pw.RichText(text: pw.TextSpan(children: [pw.TextSpan(text: 'Edad: ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: baseFontSize - 0.5)), pw.TextSpan(text: '${p.age} años - Sexo: ${p.sex}', style: pw.TextStyle(fontSize: baseFontSize - 1.5))])),
              ]
            )
          ),
           pw.Expanded(
             child: pw.Column(
               crossAxisAlignment: pw.CrossAxisAlignment.start,
               children: [
                pw.RichText(text: pw.TextSpan(children: [pw.TextSpan(text: 'DX: ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: baseFontSize - 0.5)), pw.TextSpan(text: diagnosis, style: pw.TextStyle(fontSize: baseFontSize - 1.5))])),
                pw.RichText(text: pw.TextSpan(children: [pw.TextSpan(text: 'F. Ingreso UCI: ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: baseFontSize - 0.5)), pw.TextSpan(text: DateFormat('dd/MM/yyyy HH:mm').format(a.admissionDate), style: pw.TextStyle(fontSize: baseFontSize - 1.5))])),
                pw.RichText(text: pw.TextSpan(children: [pw.TextSpan(text: 'Días en UCI: ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: baseFontSize - 0.5)), pw.TextSpan(text: '${DateTime.now().difference(a.admissionDate).inDays + 1}', style: pw.TextStyle(fontSize: baseFontSize - 1.5))])),
              ]
            )
          ),
        ]
      )
    );
  }

  static pw.Widget _buildGuardiaBlock(String guardia, DateTime noteDateTime, String diagnosis, double baseFontSize) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(4),
      decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey400)),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(guardia.toUpperCase(), style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: baseFontSize)),
              pw.Text('FECHA: ${DateFormat('dd/MM/yyyy').format(noteDateTime)}  HORA: ${DateFormat('HH:mm').format(noteDateTime)}',
                  style: pw.TextStyle(fontSize: baseFontSize - 1)),
            ],
          ),
          pw.SizedBox(height: 4),
          pw.Text('Impresión diagnóstica:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: baseFontSize)),
          pw.Text(diagnosis.isNotEmpty ? diagnosis : '-', style: pw.TextStyle(fontSize: baseFontSize - 1)),
        ],
      ),
    );
  }

  static pw.Widget _buildVitalsAndVentilation(
    Map<String, String> vitals,
    Map<String, String> vmSettings,
    Map<String, String> vmMechanics,
    double baseFontSize,
  ) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(4),
      decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey300)),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Expanded(
            flex: 4,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Vitales', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: baseFontSize - 1)),
                pw.SizedBox(height: 3),
                _buildCompactGrid(vitals, baseFontSize),
              ],
            ),
          ),
          pw.SizedBox(width: 6),
          pw.Expanded(
            flex: 5,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Parámetros VM', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: baseFontSize - 1)),
                pw.SizedBox(height: 3),
                _buildCompactGrid(vmSettings, baseFontSize),
              ],
            ),
          ),
          pw.SizedBox(width: 6),
          pw.Expanded(
            flex: 4,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Mecánica Vent.', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: baseFontSize - 1)),
                pw.SizedBox(height: 3),
                _buildCompactGrid(vmMechanics, baseFontSize),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildCompactGrid(Map<String, String> data, double baseFontSize) {
    final labelFontSize = (baseFontSize - 4).clamp(5.0, 8.0);
    final valueFontSize = (baseFontSize - 2).clamp(7.0, 10.0);
    return pw.Wrap(
      spacing: 4,
      runSpacing: 2.5,
      children: data.entries.map((e) => pw.Container(
         width: 48, // más compacto
         padding: const pw.EdgeInsets.all(2.2),
         decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey300), borderRadius: pw.BorderRadius.circular(2)),
         child: pw.Column(
           children: [
             pw.Text(e.key, style: pw.TextStyle(fontSize: labelFontSize, fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.center),
             pw.Text(e.value.isEmpty ? '-' : e.value, style: pw.TextStyle(fontSize: valueFontSize, color: PdfColors.blue800), textAlign: pw.TextAlign.center),
           ]
         )
      )).toList(),
    );
  }

  static pw.Widget _buildSoapBlock(String label, String content, double baseFontSize) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 3),
      child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(label, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: baseFontSize)),
        if (content.isNotEmpty)
        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.all(3),
          decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey300)),
          child: pw.Text(content, style: pw.TextStyle(fontSize: baseFontSize - 1)),
        )
      ]
    ),
    );
  }
  
  static pw.Widget _buildSystemRow(String system, String content, double baseFontSize) {
    if (content.isEmpty) return pw.SizedBox();
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 2),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
           pw.SizedBox(width: 78, child: pw.Text('$system:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: baseFontSize - 1))),
           pw.Expanded(child: pw.Text(content, style: pw.TextStyle(fontSize: baseFontSize - 1))),
        ]
      )
    );
  }

  static pw.Widget _buildSignatureRow(double baseFontSize,
      {String? preparedByName, String? preparedByRole}) {
    final roleLabel =
        preparedByRole?.isNotEmpty == true ? preparedByRole! : 'MÉDICO RESPONSABLE';
    return pw.Wrap(
      children: [
        pw.Divider(color: PdfColors.grey400),
        pw.SizedBox(height: 14),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.center,
          children: [
            pw.Column(children: [
              pw.Container(width: 140, height: 1, color: PdfColors.black),
              pw.SizedBox(height: 3),
              if (preparedByName != null && preparedByName.isNotEmpty)
                pw.Text(preparedByName,
                    style: pw.TextStyle(fontSize: baseFontSize - 1)),
              pw.Text(roleLabel,
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: baseFontSize - 1)),
            ]),
          ],
        ),
      ]
    );
  }
}
