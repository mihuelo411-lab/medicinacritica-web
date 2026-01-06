import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../../../core/database/database.dart';

class AdmissionPdfGenerator {
  static Future<void> generateAndPrint({
    required Patient patient,
    required AdmissionsCompanion admission,
    required String bedNumber,
    required String age,
    required String sex,
    // New Demographic Fields
    required String birthDate,
    required String civilStatus,
    required String education,
    required String religion,
    required String occupation,
    required String placeOfBirth,
    required String insuranceType,
    required String familyPhone,
    required String responsibleFamily,
    required String uciPriority,
    
    // Admission Dates
    required String hospitalAdmissionDateTime,
    required String uciAdmissionDateTime,
    
    // Clinical
    required Map<String, String> vitals,
    required String signsSymptoms,
    required String timeOfDisease,
    required String illnessStart, // Forma de inicio
    required String illnessCourse, // Curso
    required String story, // Relato
    
    // Details
    required Map<String, String> biolFunctions,
    required Map<String, String> antecedents,
    required Map<String, String> physicalExam,
    required String diagnosis,
    
    // Scores with details
    required String sofaScore,
    required String apacheScore,
    required String nutricScore,
    
    required String plan,
    required String procedures,
    String? preparedByName,
    String? preparedByRole,
    String? secondarySignatureName,
    String? secondarySignatureRole,
  }) async {
    final pdf = pw.Document();

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

    // Auto-scaling Loop
    double fontSize = 11.0;
    pw.Document? bestPdf;

    while (fontSize >= 6.0) {
      final pdf = _generateDocument(
        fontSize: fontSize,
        logoImage: logoImage,
        fontRegular: fontRegular,
        fontBold: fontBold,
        patient: patient,
        bedNumber: bedNumber,
        age: age,
        sex: sex,
        birthDate: birthDate,
        civilStatus: civilStatus, 
        education: education,
        religion: religion,
        occupation: occupation,
        placeOfBirth: placeOfBirth,
        insuranceType: insuranceType,
        responsibleFamily: responsibleFamily,
        familyPhone: familyPhone,
        uciPriority: uciPriority,
        hospitalAdmissionDateTime: hospitalAdmissionDateTime,
        uciAdmissionDateTime: uciAdmissionDateTime,
        sofaScore: sofaScore,
        apacheScore: apacheScore,
        nutricScore: nutricScore,
        signsSymptoms: signsSymptoms,
        timeOfDisease: timeOfDisease,
        illnessStart: illnessStart,
        illnessCourse: illnessCourse,
        story: story,
        biolFunctions: biolFunctions,
        antecedents: antecedents,
        vitals: vitals,
        physicalExam: physicalExam,
        diagnosis: diagnosis,
        plan: plan,
        procedures: procedures,
        preparedByName: preparedByName,
        preparedByRole: preparedByRole,
        secondarySignatureName: secondarySignatureName,
        secondarySignatureRole: secondarySignatureRole,
      );

      // Check if it fits in 2 pages
      if (pdf.document.pdfPageList.pages.length <= 2) {
        bestPdf = pdf;
        break; 
      }
      
      fontSize -= 0.5;
      
      // If we reached the minimum and still haven't broken, we'll use the last one generated (size 6)
      if (fontSize < 6.0) {
        bestPdf = pdf; 
      }
    }

    if (bestPdf != null) {
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => bestPdf!.save(),
        name: 'Nota_Ingreso_${patient.name}_${DateTime.now().toIso8601String()}',
      );
    }
  }

  static pw.Document _generateDocument({
    required double fontSize,
    required pw.ImageProvider? logoImage,
    required pw.Font fontRegular,
    required pw.Font fontBold,
    required Patient patient,
    required String bedNumber,
    required String age,
    required String sex,
    required String birthDate,
    required String civilStatus,
    required String education,
    required String religion,
    required String occupation,
    required String placeOfBirth,
    required String insuranceType,
    required String responsibleFamily,
    required String familyPhone,
    required String uciPriority,
    required String hospitalAdmissionDateTime,
    required String uciAdmissionDateTime,
    required String sofaScore,
    required String apacheScore,
    required String nutricScore,
    required String signsSymptoms,
    required String timeOfDisease,
    required String illnessStart,
    required String illnessCourse,
    required String story,
    required Map<String, String> biolFunctions,
    required Map<String, String> antecedents,
    required Map<String, String> vitals,
    required Map<String, String> physicalExam,
    required String diagnosis,
    required String plan,
    required String procedures,
    String? preparedByName,
    String? preparedByRole,
    String? secondarySignatureName,
    String? secondarySignatureRole,
  }) {
    final pdf = pw.Document();
    pdf.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          margin: const pw.EdgeInsets.all(20),
          theme: pw.ThemeData.withFont(
            base: fontRegular,
            bold: fontBold,
          ).copyWith(defaultTextStyle: pw.TextStyle(fontSize: fontSize, font: fontRegular)),
        ),
        header: (context) => _buildHeader(logoImage, bedNumber),
        footer: (context) => _buildFooter(context, patient, bedNumber),
        build: (context) => [
          // 1. FILIACIÓN
          _buildSectionHeader('I. FILIACIÓN Y DATOS ADMINISTRATIVOS'),
          _buildPatientInfo(
            patient, age, sex, birthDate, civilStatus, education, religion, 
            occupation, placeOfBirth, insuranceType, uciPriority, responsibleFamily, familyPhone, 
            hospitalAdmissionDateTime, uciAdmissionDateTime,
            sofaScore, apacheScore, nutricScore
          ),

          // 3. ENFERMEDAD ACTUAL - Re-numbered to II
          _buildSectionHeader('II. ENFERMEDAD ACTUAL'),
          _buildKeyValue('Síntomas Principales:', signsSymptoms, fontSize),
          pw.SizedBox(height: 4),
          pw.Row(children: [
            pw.Expanded(child: _buildKeyValue('Tiempo de Enfermedad:', timeOfDisease, fontSize)),
            pw.SizedBox(width: 10),
            pw.Expanded(child: _buildKeyValue('Forma de Inicio:', illnessStart, fontSize)),
          ]),
          pw.SizedBox(height: 4),
          _buildKeyValue('Curso:', illnessCourse, fontSize),
          pw.SizedBox(height: 4),
            _buildKeyValue('Relato Cronológico:', story, fontSize),
          pw.SizedBox(height: 10),

          // 4. FUNCIONES BIOLÓGICAS - Re-numbered to III
          _buildSectionHeader('III. FUNCIONES BIOLÓGICAS'),
          _buildGrid(biolFunctions, fontSize),
          pw.SizedBox(height: 10),

          // 5. ANTECEDENTES - Re-numbered to IV
          _buildSectionHeader('IV. ANTECEDENTES'),
          _buildGrid(antecedents, fontSize),
          pw.SizedBox(height: 10),

          // 6. EXAMEN FÍSICO - Re-numbered to V
          _buildSectionHeader('V. EXAMEN FÍSICO'),
          pw.Text('Funciones Vitales:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: fontSize, decoration: pw.TextDecoration.underline)),
          pw.SizedBox(height: 4),
          _buildVitalsRow(vitals, fontSize),
          pw.SizedBox(height: 8),
          pw.Text('Examen Regional:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: fontSize, decoration: pw.TextDecoration.underline)),
          pw.SizedBox(height: 4),
          _buildGrid(physicalExam, fontSize),
          pw.SizedBox(height: 10),

          // 7. DIAGNÓSTICOS - Re-numbered to VI
          _buildSectionHeader('VI. IMPRESIÓN DIAGNÓSTICA'),
          pw.Text(diagnosis, style: pw.TextStyle(fontSize: fontSize)),
          pw.SizedBox(height: 10),

          // 8. PLAN - Re-numbered to VII
          _buildSectionHeader('VII. PLAN DIAGNÓSTICO Y TERAPÉUTICO'),
          pw.Text(plan, style: pw.TextStyle(fontSize: fontSize)),
          pw.SizedBox(height: 10),

          // 9. PROCEDIMIENTOS - Re-numbered to VIII
          _buildSectionHeader('VIII. PROCEDIMIENTOS DE INGRESO'),
          pw.Text(procedures, style: pw.TextStyle(fontSize: fontSize)),
          pw.SizedBox(height: 30),
          
          // SIGNATURES
          _buildSignatureSection(
            fontSize: fontSize,
            preparedByName: preparedByName,
            preparedByRole: preparedByRole,
            secondarySignatureName: secondarySignatureName,
            secondarySignatureRole: secondarySignatureRole,
          ),
        ],
      ),
    );
    return pdf;
  }


  static pw.Widget _buildHeader(pw.ImageProvider? logo, String bed) {
    return pw.Column(
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            if (logo != null) pw.Image(logo, width: 50, height: 50),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text('HOSPITAL REGIONAL DOCENTE DE TRUJILLO', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14)),
                pw.Text('DEPARTAMENTO DE EMERGENCIA Y CUIDADOS CRÍTICOS', style: const pw.TextStyle(fontSize: 10)),
                pw.Text('UNIDAD DE CUIDADOS INTENSIVOS', style: const pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
              ],
            ),
            pw.Container(
              padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: pw.BoxDecoration(border: pw.Border.all(), borderRadius: pw.BorderRadius.circular(4)),
              child: pw.Text('CAMA: $bed', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
            ),
          ],
        ),
        pw.Divider(),
        pw.Center(child: pw.Text('NOTA DE INGRESO MÉDICO', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, decoration: pw.TextDecoration.underline))),
        pw.SizedBox(height: 15),
      ],
    );
  }

  static pw.Widget _buildFooter(pw.Context context, Patient patient, String bed) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(top: 10),
      padding: const pw.EdgeInsets.only(top: 5),
      decoration: const pw.BoxDecoration(
        border: pw.Border(top: pw.BorderSide(color: PdfColors.grey400, width: 0.5)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            '${patient.name.toUpperCase()}  |  HC: ${patient.hc}  |  SERVICIO: DECC  |  CAMA: $bed',
            style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold, color: PdfColors.grey700),
          ),
          pw.Text(
            'Pág. ${context.pageNumber} de ${context.pagesCount}',
            style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildSignatureSection({
    required double fontSize,
    String? preparedByName,
    String? preparedByRole,
    String? secondarySignatureName,
    String? secondarySignatureRole,
  }) {
    final entries = <Map<String, String>>[];
    final primaryName = preparedByName?.trim();
    final primaryRole = preparedByRole?.trim();
    if ((primaryName != null && primaryName.isNotEmpty) ||
        (primaryRole != null && primaryRole.isNotEmpty)) {
      entries.add({
        'name': primaryName ?? '________________________',
        'role': primaryRole ?? '',
      });
    }
    final secondaryName = secondarySignatureName?.trim();
    final secondaryRole = secondarySignatureRole?.trim();
    if ((secondaryName != null && secondaryName.isNotEmpty) ||
        (secondaryRole != null && secondaryRole.isNotEmpty)) {
      entries.add({
        'name': secondaryName ?? '________________________',
        'role': secondaryRole ?? '',
      });
    }
    if (entries.isEmpty) {
      entries.add({
        'name': '________________________',
        'role': 'MÉDICO RESPONSABLE',
      });
      entries.add({
        'name': '________________________',
        'role': 'MÉDICO RESIDENTE',
      });
    } else if (entries.length == 1) {
      final defaultRole = entries.first['role'] == 'MÉDICO RESPONSABLE'
          ? 'MÉDICO RESIDENTE'
          : 'MÉDICO RESPONSABLE';
      entries.add({
        'name': '________________________',
        'role': defaultRole,
      });
    }

    return pw.Wrap(
      children: [
        pw.Divider(color: PdfColors.grey400),
        pw.SizedBox(height: 40),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
          children: entries.map((entry) {
            return pw.Column(children: [
              pw.Container(width: 160, height: 1, color: PdfColors.black),
              pw.SizedBox(height: 4),
              if (entry['name'] != null && entry['name']!.isNotEmpty)
                pw.Text(entry['name']!, style: pw.TextStyle(fontSize: fontSize)),
              if (entry['role'] != null && entry['role']!.isNotEmpty)
                pw.Text(entry['role']!, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: fontSize)),
            ]);
          }).toList(),
        ),
      ],
    );
  }

  static pw.Widget _buildSectionHeader(String title) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 6, top: 12),
      padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      color: PdfColors.grey200,
      width: double.infinity,
      child: pw.Text(title, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
    );
  }

  static pw.Widget _buildPatientInfo(
    Patient p, String age, String sex, String birthDate, String civil, 
    String edu, String religion, String occupation, String placeOfBirth, String insurance, String priority,
    String relative, String relPhone,
    String admHosp, String admUci,
    String sofa, String apache, String nutric,
  ) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(6),
      decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey400)),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _buildRowMulti([
            _PdfField('Nombre:', p.name, 2),
            _PdfField('Sexo:', sex),
            _PdfField('Edad:', '$age años'),
          ]),
          _buildRowMulti([
            _PdfField('DNI:', p.dni),
            _PdfField('N° Historia:', p.hc),
            _PdfField('Estado Civil:', civil),
          ]),
          _buildRowMulti([
            _PdfField('Lugar/F. Nac:', '$placeOfBirth / $birthDate', 2),
            _PdfField('Religión:', religion),
            _PdfField('Grado Instrucción:', edu),
          ]),
          _buildRowMulti([
            _PdfField('Ocupación:', occupation),
            _PdfField('Teléfono Paciente:', p.phone ?? '-'),
            _PdfField('Domicilio Actual:', p.address ?? '-', 2),
          ]),
          _buildRowMulti([
            _PdfField('Tipo Seguro:', insurance),
            _PdfField('Prioridad UCI:', priority),
            _PdfField('Familiar Responsable:', relative, 2),
          ]),
          _buildRowMulti([
            _PdfField('Teléf. Familiar:', relPhone),
            _PdfField('F. Ingreso Hosp:', admHosp),
            _PdfField('F. Ingreso UCI:', admUci),
          ]),
          pw.Divider(color: PdfColors.grey300),
          pw.Row(children: [
            pw.Expanded(child: _buildKeyValue('SOFA:', sofa)),
            pw.Expanded(child: _buildKeyValue('APACHE II:', apache)),
            pw.Expanded(child: _buildKeyValue('NUTRIC:', nutric)),
          ]),
          pw.Divider(color: PdfColors.grey300),
        ],
      ),
    );
  }

  static pw.Widget _buildRowMulti(List<_PdfField> fields) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 1.5),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < fields.length; i++) ...[
            if (i > 0) pw.SizedBox(width: 8),
            pw.Expanded(
              flex: fields[i].flex,
              child: _buildKeyValue(fields[i].label, fields[i].value),
            ),
          ],
        ],
      ),
    );
  }

  static pw.Widget _buildKeyValue(String key, String value, [double fontSize = 9]) {
    return pw.RichText(
      text: pw.TextSpan(
        children: [
          pw.TextSpan(text: '$key ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: fontSize)),
          pw.TextSpan(text: value, style: pw.TextStyle(fontSize: fontSize)),
        ],
      ),
    );
  }

  static pw.Widget _buildGrid(Map<String, String> data, [double fontSize = 9]) {
    return pw.Wrap(
      spacing: 15,
      runSpacing: 4,
      children: data.entries.map((e) => pw.SizedBox(
        width: 150, // Fixed width for cleaner columns
        child: _buildKeyValue('${e.key}:', e.value, fontSize)
      )).toList(),
    );
  }

  static pw.Widget _buildVitalsRow(Map<String, String> vitals, [double fontSize = 9]) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: vitals.entries.map((e) => pw.Container(
        padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey300), borderRadius: pw.BorderRadius.circular(4)),
        child: pw.Column(
          children: [
            pw.Text(e.key, style: pw.TextStyle(fontSize: fontSize - 1, fontWeight: pw.FontWeight.bold)), // Slightly smaller label
            pw.Text(e.value, style: pw.TextStyle(fontSize: fontSize, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900)),
          ],
        ),
      )).toList(),
    );
  }
}

class _PdfField {
  final String label;
  final String value;
  final int flex;
  const _PdfField(this.label, this.value, [this.flex = 1]);
}
