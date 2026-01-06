import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../auth/data/auth_repository.dart';
import '../../auth/domain/profile.dart';
import 'procedure_management_screen.dart';
import 'pdf/procedure_report_pdf_generator.dart';
import '../../../../core/database/database.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../../core/services/sync_service.dart';
import 'package:intl/intl.dart';
import 'package:excel/excel.dart' as xls;
import 'package:url_launcher/url_launcher.dart';
import 'package:drift/drift.dart' as drift; // for queries if needed
import '../../../../main.dart'; // for appDatabase
import 'package:intl/date_symbol_data_local.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../exams/presentation/exam_template_management_screen.dart';


class AdminPanelScreen extends StatefulWidget {
  final UserProfile profile;
  final AuthRepository repository;
  final Future<void> Function() onSignOut;
  const AdminPanelScreen({
    super.key,
    required this.profile,
    required this.repository,
    required this.onSignOut,
  });

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

const Map<String, String> _roleLabels = {
  'admin': 'Administrador',
  'medico': 'Médico',
  'residente': 'Residente',
};

class _AdminExportDataset {
  final String key;
  final String sheetName;
  final String title;
  final String description;
  const _AdminExportDataset({
    required this.key,
    required this.sheetName,
    required this.title,
    required this.description,
  });
}

const List<_AdminExportDataset> _excelDatasets = [
  _AdminExportDataset(
    key: 'patients',
    sheetName: 'Pacientes',
    title: 'Pacientes',
    description: 'Datos demográficos y datos de contacto.',
  ),
  _AdminExportDataset(
    key: 'admissions',
    sheetName: 'Admisiones',
    title: 'Admisiones',
    description: 'Camas, fechas, diagnósticos y puntajes SOFA/APACHE.',
  ),
  _AdminExportDataset(
    key: 'evolutions',
    sheetName: 'Evoluciones',
    title: 'Evoluciones',
    description: 'Notas clínicas diarias y parámetros ventilatorios.',
  ),
  _AdminExportDataset(
    key: 'indication_sheets',
    sheetName: 'Indicaciones',
    title: 'Hojas de indicaciones',
    description: 'Planillas terapéuticas registradas.',
  ),
  _AdminExportDataset(
    key: 'epicrisis_notes',
    sheetName: 'Epicrisis',
    title: 'Notas de epicrisis',
    description: 'Documentos finales por paciente/admisión.',
  ),
  _AdminExportDataset(
    key: 'performed_procedures',
    sheetName: 'Procedimientos',
    title: 'Procedimientos registrados',
    description: 'Procedimientos efectuados desde la app.',
  ),
];

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  List<Map<String, dynamic>> _pending = [];
  bool _loadingPending = false;
  bool _exporting = false;

  @override
  void initState() {
    super.initState();
    _loadPending();
  }

  Future<void> _loadPending() async {
    setState(() => _loadingPending = true);
    final data = await widget.repository.fetchPendingUsers();
    if (mounted) {
      setState(() {
        _pending = data;
        _loadingPending = false;
      });
    }
  }

  Future<void> _approveUser(Map<String, dynamic> user) async {
    String role = (user['requested_role']?.toString().isNotEmpty ?? false)
        ? user['requested_role'].toString()
        : 'medico';
    final selectedRole = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Selecciona el rol'),
        content: DropdownButtonFormField<String>(
          value: role,
          items: const [
            DropdownMenuItem(value: 'medico', child: Text('Médico')),
            DropdownMenuItem(value: 'residente', child: Text('Residente')),
            DropdownMenuItem(value: 'admin', child: Text('Administrador')),
          ],
          onChanged: (value) {
            if (value != null) role = value;
          },
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(onPressed: () => Navigator.pop(context, role), child: const Text('Aprobar')),
        ],
      ),
    );
    if (selectedRole == null) return;
    await widget.repository.approveUser(
      userId: user['user_id'] as String,
      role: selectedRole,
      approvedBy: widget.profile.userId,
    );
    await _loadPending();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Usuario aprobado.')));
    }
  }

  Future<void> _rejectUser(Map<String, dynamic> user) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rechazar solicitud'),
        content: Text('¿Desea rechazar a ${user['full_name'] ?? user['email'] ?? 'este usuario'}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Rechazar')),
        ],
      ),
    );
    if (confirm != true) return;
    await widget.repository.rejectUser(user['user_id'] as String);
    await _loadPending();
  }

  Future<void> _exportProceduresReport() async {
     final selectedPeriod = await _pickReportPeriod();
     if (selectedPeriod == null) return;
     setState(() => _exporting = true);
     try {
       await initializeDateFormatting('es');
       final periodDate = DateTime(selectedPeriod.year, selectedPeriod.month);
       final report = await SupabaseService().generateProcedureReport(
         year: periodDate.year,
         month: periodDate.month,
       );
       final csvData = report['csv_data']?.toString() ?? '';
       if (csvData.trim().isEmpty) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('No hay datos para el mes seleccionado')),
            );
          }
          return;
       }

       final periodYear = report['period_year'] as int? ?? periodDate.year;
       final periodMonth = report['period_month'] as int? ?? periodDate.month;
       final reportId = report['id'];
       final existingStoragePath = report['storage_path']?.toString();
       final generatedAtRaw = report['created_at']?.toString();
       final generatedAt = generatedAtRaw != null ? DateTime.tryParse(generatedAtRaw) : null;

       // Generar XLSX
       const sheetName = 'Procedimientos';
       final excel = xls.Excel.createExcel();
       final xls.Sheet sheet = excel[sheetName];
       excel.setDefaultSheet(sheetName);
       final monthLabel =
           DateFormat('MMMM yyyy', 'es').format(periodDate).toUpperCase();
       sheet.appendRow(
           ['PROCEDIMIENTOS - UNIDAD DE CUIDADOS INTENSIVOS']);
       sheet.appendRow([monthLabel]);
       sheet.appendRow(const ['']);
       String normalizeForComparison(String value) {
         return value
             .toLowerCase()
             .replaceAll('á', 'a')
             .replaceAll('é', 'e')
             .replaceAll('í', 'i')
             .replaceAll('ó', 'o')
             .replaceAll('ú', 'u')
             .replaceAll('ü', 'u')
             .replaceAll('ñ', 'n');
       }

       final columnHeaders = [
         'FECHA y/ HORA',
         '# CAMA- SERVICIO',
         'NOMBRE Y APELLIDO DEL PACIENTE',
         '# HISTORIA CLÍNICA',
         'DIAGNÓSTICO',
         'PROCEDIMIENTO',
         'ASISTENTE',
       'RESIDENTE',
      ];
      sheet.appendRow(columnHeaders);
      final reportRows = <List<String>>[];

       final lines = csvData.split('\n');
       final headerIndex = lines.indexWhere(
           (line) => line.trim().toUpperCase().startsWith('FECHA Y/ HORA'));
       final dataStart = headerIndex >= 0 ? headerIndex + 1 : lines.length;
       for (var i = dataStart; i < lines.length; i++) {
         final line = lines[i].trim();
         if (line.isEmpty) continue;
         final cells = line.split(';');
         if (cells.length < 10) {
           cells.addAll(List.filled(10 - cells.length, ''));
         }
         final cama = cells[1].trim();
         final origin = cells[8].trim();
         final originComparable = normalizeForComparison(origin);
         String formattedService;
         if (originComparable.isEmpty ||
             originComparable == '-' ||
             originComparable.contains('sin origen') ||
             originComparable.contains('ingreso') ||
             originComparable.contains('evolucion')) {
           formattedService = 'UCI';
         } else {
           final parts = origin
               .split('-')
               .map((part) => part.trim())
               .where((part) => part.isNotEmpty)
               .map((part) {
                 final lower = part.toLowerCase();
                 return lower.isEmpty
                     ? ''
                     : lower[0].toUpperCase() + lower.substring(1);
               });
           formattedService = parts.join(' - ');
           if (formattedService.isEmpty) {
             formattedService = 'UCI';
           }
         }
         final camaServicio = [
           if (cama.isNotEmpty && cama != '-') cama,
           formattedService,
         ].join(' - ');
         final row = [
           cells[0].trim(),
           camaServicio,
           cells[2].trim(),
           cells[3].trim(),
           cells[4].trim(),
           cells[5].trim(),
           cells[6].trim(),
           cells[7].trim(),
         ];
         sheet.appendRow(row);
         reportRows.add(row);
       }

       final bytes = excel.encode();
       if (bytes == null) {
         throw Exception('No se pudo generar el archivo de Excel.');
       }

       final timestampLabel =
           DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
       final periodSlug = '${periodYear}_${periodMonth.toString().padLeft(2, '0')}';
       final fileName = 'procedimientos_${periodSlug}_$timestampLabel.xlsx';
       final relativeStoragePath =
           '$periodYear/${periodMonth.toString().padLeft(2, '0')}/$fileName';
       final supabase = SupabaseService();
       final storedPath = await supabase
           .uploadReportFile(bytes: bytes, storagePath: relativeStoragePath);
       final downloadUrl = SupabaseService()
           .getReportPublicUrl(storagePath: storedPath);
       if (reportId != null) {
         await SupabaseService()
             .updateReportStoragePath(reportId, storedPath);
         if (existingStoragePath != null &&
             existingStoragePath.isNotEmpty &&
             existingStoragePath != storedPath) {
           await supabase.deleteReportFile(storagePath: existingStoragePath);
         }
       }

       if (!mounted) return;
       await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Reporte generado'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Archivo listo para imprimir: $fileName'),
              const SizedBox(height: 8),
              const Text('Descarga directa:'),
              const SizedBox(height: 4),
              SelectableText(downloadUrl,
                  style: const TextStyle(color: Colors.blueAccent)),
              const SizedBox(height: 12),
              Text(
                [
                  'Periodo: ${periodMonth.toString().padLeft(2, '0')}/$periodYear',
                  if (reportId != null) 'ID Supabase: $reportId',
                  if (generatedAt != null)
                    'Generado: ${DateFormat('dd/MM/yyyy HH:mm').format(generatedAt.toLocal())}',
                  if (existingStoragePath != null && existingStoragePath.isNotEmpty)
                    'Storage: $existingStoragePath',
                ].join('\n'),
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final uri = Uri.parse(downloadUrl);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              },
              child: const Text('Descargar'),
            ),
            TextButton(
              onPressed: () async {
                await ProcedureReportPdfGenerator.generateAndPrint(
                  periodLabel: monthLabel,
                  rows: reportRows,
                );
              },
              child: const Text('Imprimir PDF'),
            ),
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cerrar')),
          ],
        ),
      );

     } catch (e) {
       String errorMessage = 'Error al exportar: $e';
       if (e is StorageException) {
         final lower = e.message.toLowerCase();
         if (lower.contains('bucket not found')) {
           errorMessage =
               'Error: No se encontró el bucket de Storage "reports". '
               'Crea ese bucket en Supabase (Storage > New bucket, público) '
               'o actualiza el nombre en SupabaseService.uploadReportFile().';
         } else if (lower.contains('row-level security') ||
             e.statusCode == 403) {
           errorMessage =
               'Supabase Storage rechazó la carga (RLS). Abre Storage > reports > Policies '
               'y añade una política que permita INSERT/UPDATE desde usuarios autenticados '
               'para ese bucket (consulta docs/sql/03_procedure_reports.sql para el SQL).';
         }
       }
       if (mounted) {
         ScaffoldMessenger.of(context)
             .showSnackBar(SnackBar(content: Text(errorMessage)));
       }
     } finally {
       if (mounted) setState(() => _exporting = false);
     }
  }

  Future<void> _syncLatestData() async {
    final syncService = SyncService(appDatabase, SupabaseService());
    await syncService.syncAll();
  }

  Future<void> _exportExcelData() async {
    final datasets = await _pickExcelDatasets();
    if (datasets == null || datasets.isEmpty) return;
    setState(() => _exporting = true);
    try {
      await _syncLatestData();
      final keys = datasets.map((d) => d.key).toList();
      final requireAdmissionsForFilter =
          keys.contains('patients') && !keys.contains('admissions');
      final requestTables = List<String>.from(keys);
      if (requireAdmissionsForFilter) {
        requestTables.add('admissions');
      }
      final dump = await widget.repository.exportDatabaseDump(tables: requestTables);
      final bytes = _buildExcelBytes(dump, datasets);
      if (bytes.isEmpty) {
        throw Exception('No se pudo generar el archivo de Excel.');
      }
      final now = DateTime.now();
      final timestamp = DateFormat('yyyyMMdd_HHmmss').format(now);
      final relativePath = 'manual_exports/uci_export_$timestamp.xlsx';
      final supabase = SupabaseService();
      final storedPath = await supabase.uploadReportFile(
        bytes: bytes,
        storagePath: relativePath,
      );
      await supabase.cleanupManualExports(keepRelativePath: storedPath);
      final downloadUrl = supabase.getReportPublicUrl(storagePath: storedPath);

      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Excel listo para descargar'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Incluye: ${datasets.map((d) => d.title).join(', ')}'),
              const SizedBox(height: 8),
              const Text('Enlace público:'),
              const SizedBox(height: 4),
              SelectableText(
                downloadUrl,
                style: const TextStyle(color: Colors.blueAccent),
              ),
              const SizedBox(height: 12),
              Text(
                'Generado: ${DateFormat('dd/MM/yyyy HH:mm').format(now.toLocal())}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: downloadUrl));
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Enlace copiado')),
                  );
                }
              },
              child: const Text('Copiar enlace'),
            ),
            TextButton(
              onPressed: () async {
                final uri = Uri.parse(downloadUrl);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              },
              child: const Text('Abrir'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cerrar'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al generar Excel: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }

  Future<List<_AdminExportDataset>?> _pickExcelDatasets() async {
    final selectedKeys = _excelDatasets.map((d) => d.key).toSet();
    final result = await showDialog<Set<String>>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('¿Qué deseas incluir?'),
          content: StatefulBuilder(
            builder: (context, setStateDialog) {
              return SizedBox(
                width: double.maxFinite,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Selecciona los módulos para el Excel.'),
                      const SizedBox(height: 12),
                      ..._excelDatasets.map((dataset) {
                        final checked = selectedKeys.contains(dataset.key);
                        return CheckboxListTile(
                          value: checked,
                          onChanged: (value) {
                            setStateDialog(() {
                              if (value == true) {
                                selectedKeys.add(dataset.key);
                              } else {
                                selectedKeys.remove(dataset.key);
                              }
                            });
                          },
                          title: Text(dataset.title),
                          subtitle: Text(dataset.description),
                        );
                      }),
                    ],
                  ),
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                if (selectedKeys.isEmpty) {
                  Navigator.pop(context, <String>{});
                } else {
                  Navigator.pop(context, Set<String>.from(selectedKeys));
                }
              },
              child: const Text('Generar'),
            ),
          ],
        );
      },
    );
    if (result == null || result.isEmpty) return null;
    return _excelDatasets
        .where((dataset) => result.contains(dataset.key))
        .toList();
  }

  List<int> _buildExcelBytes(
    Map<String, dynamic> dump,
    List<_AdminExportDataset> datasets,
  ) {
    final excel = xls.Excel.createExcel();
    final summarySheet = excel['Resumen'];
    final patientIdsWithAdmissions = _collectPatientIdsWithAdmissions(dump);
    final generatedAt = dump['generated_at']?.toString();
    final generatedLabel = generatedAt != null
        ? DateFormat('dd/MM/yyyy HH:mm').format(
            DateTime.tryParse(generatedAt)?.toLocal() ?? DateTime.now(),
          )
        : DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now());
    summarySheet.appendRow(['Exportación de datos UCI']);
    summarySheet.appendRow(['Generado', generatedLabel]);
    summarySheet.appendRow(const ['']);
    summarySheet.appendRow(['Tablas incluidas']);
    for (final dataset in datasets) {
      final rows = List<Map<String, dynamic>>.from(
        (dump[dataset.key] ?? []) as List,
      );
      if (dataset.key == 'patients' && patientIdsWithAdmissions.isNotEmpty) {
        rows.removeWhere((row) {
          final id = _parseInt(row['id']);
          return id == null || !patientIdsWithAdmissions.contains(id);
        });
      }
      summarySheet.appendRow([
        dataset.title,
        '${rows.length} registros',
      ]);
      _appendDatasetSheet(excel, dataset.sheetName, rows);
    }
    return excel.encode() ?? <int>[];
  }

  void _appendDatasetSheet(
    xls.Excel excel,
    String sheetName,
    List<Map<String, dynamic>> rows,
  ) {
    final sheet = excel[sheetName];
    if (rows.isEmpty) {
      sheet.appendRow(const ['Sin datos para este módulo.']);
      return;
    }
    final headers = <String>{};
    for (final row in rows) {
      headers.addAll(row.keys);
    }
    final orderedHeaders = headers.toList()..sort();
    sheet.appendRow(orderedHeaders.map(_prettifyHeader).toList());
    for (final row in rows) {
      sheet.appendRow(
        orderedHeaders.map((key) => _formatCellValue(row[key])).toList(),
      );
    }
  }

  String _prettifyHeader(String key) {
    const translations = {
      'id': 'ID',
      'patient_id': 'ID Paciente',
      'admission_id': 'ID Admisión',
      'dni': 'DNI',
      'hc': 'Historia Clínica',
      'name': 'Nombre',
      'full_name': 'Nombre completo',
      'age': 'Edad',
      'sex': 'Sexo',
      'address': 'Dirección',
      'occupation': 'Ocupación',
      'phone': 'Teléfono',
      'family_contact': 'Contacto familiar',
      'place_of_birth': 'Lugar de nacimiento',
      'insurance_type': 'Seguro',
      'created_at': 'Creado',
      'updated_at': 'Actualizado',
      'admission_date': 'Fecha de ingreso',
      'sofa_score': 'Puntaje SOFA',
      'apache_score': 'Puntaje APACHE',
      'nutric_score': 'Puntaje NUTRIC',
      'diagnosis': 'Diagnóstico',
      'procedures': 'Procedimientos',
      'bed_number': 'Número de cama',
      'discharged_at': 'Alta',
      'uci_priority': 'Prioridad UCI',
      'bp': 'Presión arterial',
      'hr': 'Frecuencia cardíaca',
      'rr': 'Frecuencia respiratoria',
      'o2_sat': 'Saturación O₂',
      'temp': 'Temperatura',
      'subjective': 'Subjetivo',
      'objective_json': 'Objetivo',
      'plan': 'Plan',
      'analysis': 'Análisis',
      'author_name': 'Autor',
      'author_role': 'Rol',
      'payload': 'Contenido',
      'performed_at': 'Realizado el',
      'procedure_name': 'Procedimiento',
      'assistant': 'Asistente',
      'resident': 'Residente',
      'origin': 'Origen',
      'guardia': 'Guardia',
      'note': 'Nota',
    };
    if (translations.containsKey(key)) {
      return translations[key]!;
    }
    final buffer = StringBuffer();
    final parts = key.split('_');
    for (final part in parts) {
      if (part.isEmpty) continue;
      buffer.write(part[0].toUpperCase());
      if (part.length > 1) {
        buffer.write(part.substring(1));
      }
      buffer.write(' ');
    }
    return buffer.toString().trim();
  }

  String _formatCellValue(dynamic value) {
    if (value == null) return '';
    if (value is bool) return value ? 'Sí' : 'No';
    if (value is DateTime) {
      return DateFormat('dd/MM/yyyy HH:mm').format(value.toLocal());
    }
    if (value is num) return value.toString();
    if (value is Map || value is List) {
      return jsonEncode(value);
    }
    final stringValue = value.toString();
    final parsed = DateTime.tryParse(stringValue);
    if (parsed != null) {
      return DateFormat('dd/MM/yyyy HH:mm').format(parsed.toLocal());
    }
    return stringValue;
  }

  Set<int> _collectPatientIdsWithAdmissions(Map<String, dynamic> dump) {
    final admissionsRaw = dump['admissions'];
    if (admissionsRaw is! List) return <int>{};
    final ids = <int>{};
    for (final entry in admissionsRaw) {
      if (entry is! Map<String, dynamic>) continue;
      final id = _parseInt(entry['patient_id']);
      if (id != null) ids.add(id);
    }
    return ids;
  }

  int? _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  Future<DateTime?> _pickReportPeriod() async {
    final supabase = SupabaseService();
    List<int> years = [];
    try {
      years = await supabase.fetchAvailableReportYears();
    } catch (_) {}
    final now = DateTime.now();
    if (years.isEmpty) {
      years = [now.year];
    } else if (!years.contains(now.year)) {
      years.add(now.year);
      years.sort((a, b) => b.compareTo(a));
    }
    int selectedYear = years.first;
    int selectedMonth = now.month;
    const monthNames = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre',
    ];
    final result = await showDialog<DateTime>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Selecciona periodo'),
          content: StatefulBuilder(
            builder: (context, setStateDialog) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<int>(
                    value: selectedMonth,
                    decoration: const InputDecoration(
                      labelText: 'Mes',
                      border: OutlineInputBorder(),
                    ),
                    items: List.generate(
                      12,
                      (index) => DropdownMenuItem(
                        value: index + 1,
                        child: Text(monthNames[index]),
                      ),
                    ),
                    onChanged: (value) {
                      if (value == null) return;
                      setStateDialog(() => selectedMonth = value);
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<int>(
                    value: selectedYear,
                    decoration: const InputDecoration(
                      labelText: 'Año',
                      border: OutlineInputBorder(),
                    ),
                    items: years
                        .map(
                          (year) => DropdownMenuItem(
                            value: year,
                            child: Text(year.toString()),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value == null) return;
                      setStateDialog(() => selectedYear = value);
                    },
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  DateTime(selectedYear, selectedMonth),
                );
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de administración'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await widget.onSignOut();
              if (mounted) Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadPending,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.table_view_outlined, color: Colors.indigo),
                    title: const Text('Exportar Base de Datos (Excel)'),
                    subtitle: const Text('Libro editable con hojas por módulo.'),
                    trailing: _exporting ? const CircularProgressIndicator() : const Icon(Icons.file_download),
                    onTap: _exporting ? null : _exportExcelData,
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.table_chart_outlined, color: Colors.green),
                    title: const Text('Exportar Reporte de Procedimientos'),
                    subtitle: const Text('CSV para Excel con detalle por procedimiento.'),
                    trailing: _exporting ? const CircularProgressIndicator() : const Icon(Icons.file_download),
                    onTap: _exporting ? null : _exportProceduresReport,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
             Card(
              child: ListTile(
                leading: const Icon(Icons.medical_services_outlined, color: Colors.blue),
                title: const Text('Gestionar Catálogo de Procedimientos'),
                subtitle: const Text('Crear, editar o eliminar procedimientos estandarizados.'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const ProcedureManagementScreen()));
                },
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: const Icon(Icons.biotech_outlined, color: Colors.deepPurple),
                title: const Text('Gestionar exámenes auxiliares'),
                subtitle: const Text('Define plantillas y campos personalizados.'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const ExamTemplateManagementScreen()));
                },
              ),
            ),
            const SizedBox(height: 16),
            Text('Usuarios pendientes', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            if (_loadingPending)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_pending.isEmpty)
              const Card(
                child: ListTile(
                  leading: Icon(Icons.verified_outlined),
                  title: Text('No hay solicitudes pendientes'),
                ),
              )
            else
              ..._pending.map((user) => Card(
                    child: ListTile(
                      title: Text(user['full_name']?.toString() ?? user['email']?.toString() ?? 'Usuario'),
                      subtitle: Text(
                        '${user['email'] ?? ''} • DNI: ${user['dni'] ?? '-'} • CMP: ${user['cmp'] ?? '-'}\nRol solicitado: ${_roleLabels[user['requested_role']] ?? 'Médico'}',
                      ),
                      trailing: Wrap(
                        spacing: 8,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.check_circle, color: Colors.green),
                            onPressed: () => _approveUser(user),
                          ),
                          IconButton(
                            icon: const Icon(Icons.cancel, color: Colors.redAccent),
                            onPressed: () => _rejectUser(user),
                          ),
                        ],
                      ),
                    ),
                  )),
          ],
        ),
      ),
    );
  }
}
