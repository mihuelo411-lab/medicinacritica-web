import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../../../../core/database/database.dart';

class EpicrisisPdfGenerator {
  static Future<void> generateAndPrint({
    required Patient patient,
    required Admission admission,
    required Map<String, dynamic> payload,
  }) async {
    final doc = pw.Document();
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) => _buildFirstPage(patient, admission, payload),
      ),
    );
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) => _buildSecondPage(payload),
      ),
    );
    await Printing.layoutPdf(onLayout: (format) => doc.save());
  }

  static pw.Widget _sectionTitle(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 4),
      child: pw.Text(
        text,
        style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
      ),
    );
  }

  static pw.Widget _buildFirstPage(Patient patient, Admission admission, Map<String, dynamic> payload) {
    final filiacion = payload['filiacion'] as Map<String, dynamic>? ?? {};
    final diag = payload['diagnosticos'] as Map<String, dynamic>? ?? {};
    final resumen = payload['resumen'] as Map<String, dynamic>? ?? {};
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Center(
          child: pw.Column(
            children: [
              pw.Text('UNIDAD DE CUIDADOS INTENSIVOS', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
              pw.Text('EPICRISIS', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
            ],
          ),
        ),
        pw.SizedBox(height: 12),
        _sectionTitle('Filiación'),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
          columnWidths: {
            0: const pw.FlexColumnWidth(1),
            1: const pw.FlexColumnWidth(1),
          },
          children: [
            pw.TableRow(children: [
              _cell('Paciente: ${patient.name}'),
              _cell('DNI: ${patient.dni}'),
            ]),
            pw.TableRow(children: [
              _cell('Historia Clínica: ${patient.hc}'),
              _cell('Cama: ${filiacion['cama'] ?? '-'}'),
            ]),
            pw.TableRow(children: [
              _cell('Ingreso: ${filiacion['fechaIngreso'] ?? ''}'),
              _cell('Egreso: ${filiacion['fechaEgreso'] ?? ''}'),
            ]),
            pw.TableRow(children: [
              _cell('Estancia total: ${filiacion['duracionTotal'] ?? ''} días'),
              _cell('Estancia UCI: ${filiacion['duracionUci'] ?? ''} días'),
            ]),
            pw.TableRow(children: [
              _cell('Servicio de egreso: ${filiacion['servicioEgreso'] ?? payload['servicioEgreso'] ?? ''}'),
              _cell(''),
            ]),
          ],
        ),
        pw.SizedBox(height: 12),
        pw.Row(
          children: [
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  _sectionTitle('Diagnóstico de ingreso'),
                  pw.Text(diag['ingreso'] ?? '-', style: const pw.TextStyle(fontSize: 11)),
                ],
              ),
            ),
            pw.SizedBox(width: 12),
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  _sectionTitle('Diagnóstico de egreso'),
                  pw.Text(diag['egreso'] ?? '-', style: const pw.TextStyle(fontSize: 11)),
                ],
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 12),
        _sectionTitle('Anamnesis'),
        pw.Text(resumen['anamnesis'] ?? '-', style: const pw.TextStyle(fontSize: 11)),
        pw.SizedBox(height: 12),
        _sectionTitle('Examen clínico'),
        pw.Text(resumen['examenClinico'] ?? '-', style: const pw.TextStyle(fontSize: 11)),
      ],
    );
  }

  static pw.Widget _buildSecondPage(Map<String, dynamic> payload) {
    final resumen = payload['resumen'] as Map<String, dynamic>? ?? {};
    final medicamentos = payload['medicamentos'] as List<dynamic>? ?? [];
    final mortalidad = payload['mortalidad'] as Map<String, dynamic>? ?? {};
    final transfer = payload['transferenciaTipo'] == 'Otro servicio'
        ? 'Transferencia a: ${payload['transferenciaDestino'] ?? ''}'
        : 'Alta domiciliaria: ${payload['transferenciaDestino'] ?? ''}';
    final firmas = payload['firmantes'] as Map<String, dynamic>?;
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _sectionTitle('Exámenes auxiliares'),
        pw.Text(resumen['examenesAuxiliares'] ?? '-', style: const pw.TextStyle(fontSize: 11)),
        pw.SizedBox(height: 12),
        _sectionTitle('Evolución'),
        pw.Text(resumen['evolucion'] ?? '-', style: const pw.TextStyle(fontSize: 11)),
        pw.SizedBox(height: 12),
        _sectionTitle('Medicamentos administrados'),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
          columnWidths: {
            0: const pw.FlexColumnWidth(3),
            1: const pw.FlexColumnWidth(1),
          },
          children: [
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey200),
              children: [
                _cell('Medicamento', bold: true),
                _cell('Días', bold: true),
              ],
            ),
            ...medicamentos.map<pw.TableRow>((m) {
              return pw.TableRow(children: [
                _cell(m['nombre']?.toString() ?? ''),
                _cell(m['dias']?.toString() ?? ''),
              ]);
            }),
          ],
        ),
        pw.SizedBox(height: 12),
        _sectionTitle('Transferencia y procedimientos'),
        pw.Text(transfer, style: const pw.TextStyle(fontSize: 11)),
        pw.SizedBox(height: 8),
        pw.Text(payload['procedimientos'] ?? '-', style: const pw.TextStyle(fontSize: 11)),
        pw.SizedBox(height: 12),
        _sectionTitle('Condición al alta'),
        pw.Text('Condición: ${payload['condicionAlta'] ?? '-'}', style: const pw.TextStyle(fontSize: 11)),
        pw.Text('Pronóstico: ${payload['pronostico'] ?? '-'}', style: const pw.TextStyle(fontSize: 11)),
        if ((payload['condicionAlta'] ?? '') == 'Fallecido') ...[
          pw.SizedBox(height: 8),
          pw.Text('Necropsia: ${mortalidad['autopsia'] == true ? 'Sí' : 'No'}'),
          pw.Text('Causa final: ${mortalidad['causaFinal'] ?? '-'}'),
          pw.Text('Causa intermedia: ${mortalidad['causaIntermedia'] ?? '-'}'),
          pw.Text('Causa básica: ${mortalidad['causaBasica'] ?? '-'}'),
        ],
        pw.Spacer(),
        pw.Divider(),
        pw.Text(payload['pie'] ?? '', style: const pw.TextStyle(fontSize: 10)),
        pw.SizedBox(height: 24),
        _buildSignatureBlock(
          medicoData: firmas?['medico'],
          residenteData: firmas?['residente'],
          fallbackMedico: payload['firmaMedico']?.toString(),
        ),
      ],
    );
  }

  static pw.Widget _buildSignatureBlock({dynamic medicoData, dynamic residenteData, String? fallbackMedico}) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        _signatureEntry('Médico tratante', medicoData ?? (fallbackMedico != null ? {'nombre': fallbackMedico} : null)),
        pw.SizedBox(height: 18),
        _signatureEntry('Residente', residenteData),
      ],
    );
  }

  static pw.Widget _signatureEntry(String titulo, dynamic data) {
    final map = data is Map<String, dynamic> ? data : null;
    final nombre = map == null ? '' : (map['nombre']?.toString() ?? '');
    final cmp = map == null ? '' : (map['cmp']?.toString() ?? '');
    final linea = nombre.isEmpty ? '__________________________' : nombre;
    final cmpText = cmp.isNotEmpty ? ' (CMP: $cmp)' : '';
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Text('$titulo - Firma y sello', style: const pw.TextStyle(fontSize: 11)),
        pw.SizedBox(height: 40),
        pw.Container(height: 1, color: PdfColors.grey700),
        pw.SizedBox(height: 4),
        pw.Text('$linea$cmpText', style: const pw.TextStyle(fontSize: 11)),
      ],
    );
  }

  static pw.Widget _cell(String text, {bool bold = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(
        text,
        style: pw.TextStyle(fontSize: 10, fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal),
      ),
    );
  }
}
