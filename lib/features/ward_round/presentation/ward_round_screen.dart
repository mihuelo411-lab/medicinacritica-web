import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import 'package:fl_chart/fl_chart.dart';
import '../../clinical_history/presentation/evolution_screen.dart';
import '../../clinical_history/presentation/indications_screen.dart';
import '../../nutrition/presentation/nutrition_screen.dart';
import '../../patients/presentation/admission_screen.dart';
import '../../patients/data/patient_repository.dart'; // Import for ActiveAdmission type
import '../../clinical_history/presentation/clinical_history_screen.dart';
import '../../../../core/database/database.dart';
import '../../../../main.dart'; // appDatabase

class WardRoundScreen extends StatefulWidget {
  final int bedNumber;
  final ActiveAdmission? admission;

  const WardRoundScreen({
    super.key, 
    required this.bedNumber,
    this.admission,
  });

  @override
  State<WardRoundScreen> createState() => _WardRoundScreenState();
}

class _WardRoundScreenState extends State<WardRoundScreen> {
  bool _loading = true;
  String? _lastDx;
  String? _admissionDx;
  String? _hemodynamicsStatus;
  String? _ventilatorStatus;
  bool? _vasoactivesActive;
  List<_ScoreTrendData> _scoreTrends = const [];

  int? get _hospitalDays => _daysSince(widget.admission?.admission.admissionDate);
  int? get _uciDays => _daysSince(widget.admission?.admission.createdAt);

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (widget.admission == null) {
      setState(() => _loading = false);
      return;
    }
    final admissionId = widget.admission!.admission.id;
    final evolutions = await (appDatabase.select(appDatabase.evolutions)
      ..where((tbl) => tbl.admissionId.equals(admissionId))
      ..orderBy([(tbl) => drift.OrderingTerm(expression: tbl.date, mode: drift.OrderingMode.asc)])
    ).get();

    String? vmStatus;
    String? hemoStatus;
    bool? vasoStatus;

    if (evolutions.isNotEmpty) {
      vmStatus = _deriveVmStatus(evolutions.last.vmSettingsJson);
      hemoStatus = _deriveHemodynamicsStatus(evolutions.last.objectiveJson);
      vasoStatus = _extractVasoactiveFlag(evolutions.last.objectiveJson);
    }

    hemoStatus ??= _extractPhysicalExamTag(widget.admission?.admission.physicalExam, 'Hemodinamia');
    vmStatus ??= _vmStatusFromExam(widget.admission?.admission.physicalExam);
    vasoStatus ??= _extractVasoactiveFromExam(widget.admission?.admission.physicalExam);

    final scoreTrends = _buildScoreTrends(widget.admission!.admission, evolutions);

    if (!mounted) return;
    setState(() {
      _admissionDx = widget.admission?.admission.diagnosis;
      _lastDx = evolutions.isNotEmpty ? (evolutions.last.diagnosis?.isNotEmpty == true ? evolutions.last.diagnosis : _admissionDx) : _admissionDx;
      _hemodynamicsStatus = hemoStatus;
      _ventilatorStatus = vmStatus;
      _vasoactivesActive = vasoStatus;
      _scoreTrends = scoreTrends;
      _loading = false;
    });
  }

  Map<String, dynamic> _safeJson(String? raw) {
    if (raw == null || raw.isEmpty) return {};
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) return decoded;
      if (decoded is Map) return decoded.map((k, v) => MapEntry(k.toString(), v));
      return {};
    } catch (_) {
      return {};
    }
  }

  String? _deriveVmStatus(String? raw) {
    final data = _safeJson(raw);
    if (data.isEmpty) return null;
    final vmActive = _parseBool(data['VM_Activa']);
    final vmDays = _tryParseInt(data['VM_Days']);
    if (vmActive == null) return null;
    if (vmActive && vmDays != null && vmDays > 0) {
      return 'VM: Día $vmDays';
    }
    return vmActive ? 'VM: Activa' : 'VM: No activa';
  }

  String? _deriveHemodynamicsStatus(String? raw) {
    final data = _safeJson(raw);
    final hemo = data['Hemo'];
    if (hemo is String && hemo.trim().isNotEmpty) {
      return hemo.trim();
    }
    return null;
  }

  bool? _extractVasoactiveFlag(String? raw) {
    final data = _safeJson(raw);
    if (data.isEmpty) return null;
    final dynamic entry = data['Vasoactivos'] ?? data['vasoactivos'];
    if (entry == null) return null;
    if (entry is bool) return entry;
    return _parseVasoactiveText(entry.toString());
  }

  bool? _extractVasoactiveFromExam(String? source) {
    if (source == null) return null;
    final normalized = source.toLowerCase();
    if (!normalized.contains('vaso')) return null;
    if (normalized.contains('sin vaso') || normalized.contains('no vaso') || normalized.contains('vasoactivos: no')) {
      return false;
    }
    if (normalized.contains('con vaso') || normalized.contains('vasoactivos en uso') || normalized.contains('vasoactivos: si')) {
      return true;
    }
    return null;
  }

  bool? _parseVasoactiveText(String raw) {
    final normalized = raw.toLowerCase().trim();
    if (normalized.isEmpty) return null;
    if (normalized == '1' || normalized == 'true' || normalized == 'sí' || normalized == 'si') {
      return true;
    }
    if (normalized == '0' || normalized == 'false') return false;
    if (normalized.contains('sin') || normalized.contains('suspend')) return false;
    if (normalized.contains('uso') || normalized.contains('activo')) return true;
    return null;
  }

  String? _extractPhysicalExamTag(String? source, String label) {
    if (source == null) return null;
    final normalizedLabel = label.toLowerCase();
    for (final line in source.split('\n')) {
      final trimmed = line.trim();
      if (trimmed.toLowerCase().startsWith('$normalizedLabel:')) {
        final value = trimmed.substring(label.length + 1).trim();
        if (value.isNotEmpty) return value;
      }
    }
    return null;
  }

  String? _vmStatusFromExam(String? source) {
    if (source == null) return null;
    if (source.contains('[VM: SI')) return 'VM: Activa';
    if (source.contains('[VM: NO')) return 'VM: No activa';
    return null;
  }

  int? _tryParseInt(dynamic value) {
    if (value == null) return null;
    final match = RegExp(r'-?\d+').firstMatch(value.toString());
    if (match == null) return null;
    return int.tryParse(match.group(0)!);
  }

  bool? _parseBool(dynamic value) {
    if (value == null) return null;
    final normalized = value.toString().toLowerCase();
    if (normalized == '1' || normalized == 'true') return true;
    if (normalized == '0' || normalized == 'false') return false;
    return null;
  }

  int? _daysSince(DateTime? date) {
    if (date == null) return null;
    final diff = DateTime.now().difference(date).inDays;
    return diff < 0 ? 0 : diff;
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Sin registro';
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$day/$month/$year $hour:$minute';
  }

  Color _scoreColorFor(String label) {
    switch (label.toUpperCase()) {
      case 'SOFA':
        return Colors.deepPurple;
      case 'APACHE II':
        return Colors.teal;
      case 'NUTRIC':
        return Colors.orange;
      default:
        return Colors.blueGrey;
    }
  }

  _ScoreTrendData? _trendForLabel(String label) {
    try {
      return _scoreTrends.firstWhere(
        (t) => t.label.toLowerCase().contains(label.toLowerCase()),
      );
    } catch (_) {
      return null;
    }
  }

  List<_ScoreTrendData> _buildScoreTrends(Admission admission, List<Evolution> evolutions) {
    List<_ScorePoint> pointsFor(String label) => _extractScorePoints(evolutions, label);

    return [
      _scoreSeries(
        label: 'SOFA',
        admissionValue: admission.sofaScore,
        admissionDate: admission.admissionDate,
        mortality: admission.sofaMortality,
        evolutions: pointsFor('SOFA'),
      ),
      _scoreSeries(
        label: 'APACHE II',
        admissionValue: admission.apacheScore,
        admissionDate: admission.admissionDate,
        mortality: admission.apacheMortality,
        evolutions: pointsFor('APACHE'),
      ),
      _scoreSeries(
        label: 'NUTRIC',
        admissionValue: admission.nutricScore,
        admissionDate: admission.admissionDate,
        evolutions: pointsFor('NUTRIC'),
      ),
    ];
  }

  _ScoreTrendData _scoreSeries({
    required String label,
    required double? admissionValue,
    required DateTime admissionDate,
    required List<_ScorePoint> evolutions,
    String? mortality,
  }) {
    final points = <_ScorePoint>[];
    if (admissionValue != null) {
      points.add(_ScorePoint(date: admissionDate, value: admissionValue, isAdmission: true));
    }
    points.addAll(evolutions);
    return _ScoreTrendData(label: label, mortalityLabel: mortality, points: points);
  }

  List<_ScorePoint> _extractScorePoints(List<Evolution> evolutions, String label) {
    final results = <_ScorePoint>[];
    final regex = RegExp('$label\\s*:?\\s*(\\d+(?:\\.\\d+)?)', caseSensitive: false);
    for (final evo in evolutions) {
      final objective = _safeJson(evo.objectiveJson);
      final value = _findScoreInTexts(regex, [
        evo.analysis,
        evo.plan,
        evo.diagnosis,
        objective['Scores'] is String ? objective['Scores'] as String : null,
      ]);
      if (value != null) {
        results.add(_ScorePoint(date: evo.date, value: value));
      }
    }
    return results;
  }

  double? _findScoreInTexts(RegExp regex, List<String?> texts) {
    for (final text in texts) {
      if (text == null) continue;
      final match = regex.firstMatch(text);
      if (match != null) {
        final number = match.group(1);
        if (number != null) {
          final value = double.tryParse(number);
          if (value != null) return value;
        }
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final admission = widget.admission;
    // Colors from theme
    final colorScheme = Theme.of(context).colorScheme;

    if (admission == null) {
      return _buildEmptyState(context);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Cama ${widget.bedNumber}: Visita Médica'),
        actions: [
          IconButton(
            icon: const Icon(Icons.restaurant), // Nutrition Icon
            tooltip: 'Evaluación Nutricional (NutriLogic)',
            onPressed: () {
               Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NutritionScreen(bedNumber: widget.bedNumber)),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'Historial Completo',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (c) => ClinicalHistoryScreen(activeAdmission: admission),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: _loading 
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Asistente de Residente (Header)
                _buildPatientSummaryCard(colorScheme),
                
                const SizedBox(height: 16),
                _buildDxRow(),

                const SizedBox(height: 20),
                _buildAntecedentsCard(),

                const SizedBox(height: 20),
                _buildTrendPreview(),
                const SizedBox(height: 20),
                _buildAdmissionEvolutionSummary(),
                const SizedBox(height: 20),
                _buildVisitSuggestionsCard(),

                const SizedBox(height: 80), // Space for FAB
              ],
            ),
      ),
      floatingActionButton: widget.admission == null
          ? null
          : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                FloatingActionButton.extended(
                  heroTag: 'indications_fab',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => IndicationsScreen(
                          activeAdmission: widget.admission!,
                        ),
                      ),
                    ).then((_) => _loadData());
                  },
                  icon: const Icon(Icons.checklist),
                  label: const Text('INDICACIONES'),
                  backgroundColor: Colors.orange.shade600,
                  foregroundColor: Colors.white,
                ),
                const SizedBox(height: 12),
                FloatingActionButton.extended(
                  heroTag: 'evolution_fab',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EvolutionScreen(bedNumber: widget.bedNumber),
                      ),
                    ).then((_) => _loadData());
                  },
                  icon: const Icon(Icons.edit_document),
                  label: const Text('EVOLUCIONAR AHORA'),
                  backgroundColor: colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
              ],
            ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cama ${widget.bedNumber}: Disponible')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person_add_alt_1_rounded, size: 80, color: Colors.indigo.withValues(alpha: 0.3)),
              const SizedBox(height: 24),
              const Text(
                'Cama Disponible',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueGrey),
              ),
              const SizedBox(height: 12),
              const Text(
                'Esta cama se encuentra libre. Para iniciar el seguimiento de un nuevo paciente, registra el ingreso.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: () async {
                  await Navigator.push(
                    context,
                  MaterialPageRoute(builder: (context) => AdmissionScreen(bedNumber: widget.bedNumber)),
                  );
                  // After returning from successful admission (save), close this empty state screen
                  // so the dashboard can refresh and show the occupied state.
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
                icon: const Icon(Icons.add),
                label: const Text('REGISTRAR NUEVO INGRESO'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPatientSummaryCard(ColorScheme colors) {
    return Card(
      elevation: 0,
      color: colors.surfaceContainerHighest, // M3 style
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colors.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
             Row(
              children: [
                const CircleAvatar(child: Icon(Icons.person)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.admission?.patient.name ?? 'PACIENTE SIN NOMBRE',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text('${widget.admission?.patient.age} Años - ${widget.admission?.patient.sex}'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Ingreso hospital: ${_formatDate(widget.admission?.admission.admissionDate)}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  Text('Ingreso UCI (registro local): ${_formatDate(widget.admission?.admission.createdAt)}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                if (_hospitalDays != null)
                  _buildCompactTag(Icons.bed, 'Hospital: $_hospitalDays días', Colors.indigo.shade50),
                if (_hospitalDays != null && _uciDays != null)
                  const SizedBox(width: 8),
                if (_uciDays != null)
                  _buildCompactTag(Icons.monitor, 'UCI: $_uciDays días', Colors.pink.shade50),
                const Spacer(),
                if (widget.admission?.admission.uciPriority != null && widget.admission!.admission.uciPriority!.isNotEmpty)
                  Chip(
                    label: Text('Prioridad ${widget.admission!.admission.uciPriority}'),
                    backgroundColor: Colors.white,
                  ),
              ],
            ),
            const Divider(),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Diagnóstico Principal:', style: TextStyle(color: Colors.grey)),
                      Text(
                         widget.admission?.admission.diagnosis ?? 'Sin diagnóstico registrado', 
                         style: const TextStyle(fontWeight: FontWeight.bold)
                      ),
                    ],
                  ),
                ),
              ],
            ),
             const SizedBox(height: 8),
            if (_ventilatorStatus != null || _hemodynamicsStatus != null || _vasoactivesActive != null)
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  if (_ventilatorStatus != null)
                    _buildCompactTag(Icons.air, _ventilatorStatus!, Colors.blue.shade100),
                  if (_hemodynamicsStatus != null)
                    _buildCompactTag(Icons.monitor_heart, _hemodynamicsStatus!, Colors.orange.shade100),
                  if (_vasoactivesActive != null)
                    _buildCompactTag(
                      Icons.bolt,
                      _vasoactivesActive! ? 'Vasoactivos en uso' : 'Sin vasoactivos',
                      _vasoactivesActive! ? Colors.orange.shade100 : Colors.green.shade100,
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDxRow() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('DX de ingreso', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
                Text(_admissionDx ?? 'Sin registro', style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('DX actual', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
                Text(_lastDx ?? 'Sin registro', style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactTag(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14),
          const SizedBox(width: 4),
          Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildAntecedentsCard() {
    final admission = widget.admission?.admission;
    final patient = widget.admission?.patient;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Antecedentes de ingreso', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _infoRow(Icons.flag, 'Signos y síntomas', admission?.signsSymptoms ?? 'Sin registro'),
            _infoRow(Icons.timer, 'Tiempo de enfermedad', admission?.timeOfDisease ?? 'Sin registro'),
            _infoRow(Icons.timeline, 'Forma / Curso', '${admission?.illnessStart ?? "-"} • ${admission?.illnessCourse ?? "-"}'),
            _infoRow(Icons.menu_book, 'Relato / Antecedentes relevantes', admission?.story ?? 'Sin registro'),
            const Divider(height: 24),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                _pillData(Icons.person, 'Ocupación: ${patient?.occupation ?? "No especificada"}'),
                _pillData(Icons.family_restroom, 'Familiar responsable: ${patient?.familyContact ?? "No registrado"}'),
                _pillData(Icons.phone, 'Teléfono: ${patient?.phone ?? "Sin número"}'),
                _pillData(Icons.health_and_safety, 'Seguro: ${patient?.insuranceType ?? "No registrado"}'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade700),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                Text(content, style: const TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _pillData(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.grey.shade700),
          const SizedBox(width: 6),
          Text(text, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildTrendPreview() {
    final hasData = _scoreTrends.any((t) => t.points.isNotEmpty);
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Tendencias (Ingreso + Evoluciones)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(
              hasData
                  ? 'Comparación directa de SOFA, APACHE II y NUTRIC entre el ingreso y cada evolución registrada.'
                  : 'Ingresa los scores en la nota inicial y evoluciones diarias para habilitar estas curvas.',
              style: const TextStyle(color: Colors.black87),
            ),
            const SizedBox(height: 16),
            if (hasData) ...[
              SizedBox(
                height: 260,
                child: _ScoresLineChart(
                  trends: _scoreTrends,
                  colorResolver: _scoreColorFor,
                ),
              ),
              const SizedBox(height: 12),
              _buildTrendLegend(),
              const SizedBox(height: 12),
              SizedBox(
                height: 210,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final trend = _scoreTrends[index];
                    return _ScoreTrendCard(data: trend, color: _scoreColorFor(trend.label));
                  },
                  separatorBuilder: (context, index) => const SizedBox(width: 12),
                  itemCount: _scoreTrends.length,
                ),
              ),
            ] else
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('Ingresa los scores en la nota inicial y evoluciones diarias para habilitar estas curvas.'),
              ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: hasData ? _showTrendVisionDialog : null,
                icon: const Icon(Icons.open_in_full),
                label: const Text('Ver vista ampliada'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendLegend() {
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: _scoreTrends
          .map((t) => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: _scoreColorFor(t.label),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(t.label, style: const TextStyle(fontSize: 12)),
                ],
              ))
          .toList(),
    );
  }

  Widget _buildAdmissionEvolutionSummary() {
    final comparisons = <_ScoreComparison>[];
    for (final label in ['SOFA', 'APACHE', 'NUTRIC']) {
      final trend = _trendForLabel(label);
      if (trend == null || trend.points.isEmpty) continue;
      final admissionPoint = trend.points.firstWhere(
        (p) => p.isAdmission,
        orElse: () => trend.points.first,
      );
      final latestPoint = trend.points.last;
      comparisons.add(_ScoreComparison(
        label: trend.label,
        admission: admissionPoint.value,
        latest: latestPoint.value,
      ));
    }

    if (comparisons.isEmpty && _hemodynamicsStatus == null && _ventilatorStatus == null) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Ingreso vs última evolución', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...comparisons.map((comp) {
              final delta = comp.delta;
              final trendText = delta == null
                  ? ''
                  : delta == 0
                      ? 'sin cambios'
                      : delta > 0
                          ? '↑ ${delta.toStringAsFixed(1)} pts'
                          : '↓ ${delta.abs().toStringAsFixed(1)} pts';
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  radius: 16,
                  backgroundColor: _scoreColorFor(comp.label).withValues(alpha: 0.15),
                  child: Text(comp.label.substring(0, 1), style: const TextStyle(fontSize: 12)),
                ),
                title: Text('${comp.label}: ${comp.latest?.toStringAsFixed(1) ?? '-'}'),
                subtitle: Text(
                  comp.admission != null ? 'Ingreso: ${comp.admission!.toStringAsFixed(1)} • Tendencia: $trendText' : 'Tendencia: $trendText',
                ),
              );
            }),
            if (_ventilatorStatus != null || _hemodynamicsStatus != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Wrap(
                  spacing: 10,
                  runSpacing: 6,
                  children: [
                    if (_ventilatorStatus != null)
                      Chip(
                        avatar: const Icon(Icons.air, size: 16),
                        label: Text(_ventilatorStatus!),
                        backgroundColor: Colors.blue.shade50,
                      ),
                    if (_hemodynamicsStatus != null)
                      Chip(
                        avatar: const Icon(Icons.monitor_heart, size: 16),
                        label: Text(_hemodynamicsStatus!),
                        backgroundColor: Colors.orange.shade50,
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildVisitSuggestionsCard() {
    final suggestions = <String>[];
    final sofaTrend = _trendForLabel('SOFA');
    if (sofaTrend != null && sofaTrend.points.length > 1) {
      final delta = sofaTrend.points.last.value - sofaTrend.points.first.value;
      suggestions.add(
        delta > 0
            ? 'Resalta en el pase que el SOFA aumentó ${delta.toStringAsFixed(1)} puntos respecto al ingreso para enfocar intervenciones.'
            : 'Menciona la reducción de SOFA (${delta.abs().toStringAsFixed(1)} pts) como indicador temprano de respuesta terapéutica.',
      );
    }
    final apacheTrend = _trendForLabel('APACHE');
    if (apacheTrend != null && apacheTrend.points.length > 1) {
      suggestions.add('Documenta por qué APACHE cambió de ${apacheTrend.points.first.value.toStringAsFixed(1)} a ${apacheTrend.points.last.value.toStringAsFixed(1)} para alinear al equipo.');
    }
    if (_ventilatorStatus != null) {
      suggestions.add('Incluye en la visita un resumen estructurado de la VM (modo, Vt, PEEP) usando la tarjeta de ventilación.');
    }
    if (_vasoactivesActive == true) {
      suggestions.add('Añade las dosis y objetivos de PAM cuando los vasoactivos están activos para facilitar el pase de guardia.');
    }
    if (widget.admission?.admission.plan != null && widget.admission!.admission.plan!.isNotEmpty) {
      final planText = widget.admission!.admission.plan!.trim();
      final snippet = planText.length > 90 ? '${planText.substring(0, 90)}…' : planText;
      suggestions.add('Contrasta el plan inicial ("$snippet") con los cambios diarios para contextualizar al familiar.');
    }

    if (suggestions.isEmpty) return const SizedBox.shrink();

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Sugerencias para el pase de visita', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...suggestions.map((s) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• ', style: TextStyle(fontSize: 16)),
                      Expanded(child: Text(s)),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  void _showTrendVisionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final hasData = _scoreTrends.any((t) => t.points.length >= 2);
        return AlertDialog(
          title: const Text('Panel de tendencias'),
          content: SizedBox(
            width: 500,
            child: hasData
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 280,
                        child: _ScoresLineChart(
                          trends: _scoreTrends,
                          colorResolver: _scoreColorFor,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text('Valores normalizados por día de estancia. Usa los colores para guiar la discusión con el familiar.'),
                    ],
                  )
                : const Text('Registra los scores en el ingreso y en al menos dos evoluciones para habilitar esta vista.'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Entendido'),
            ),
          ],
        );
      },
    );
  }
}

class _ScoreTrendData {
  final String label;
  final List<_ScorePoint> points;
  final String? mortalityLabel;
  const _ScoreTrendData({
    required this.label,
    required this.points,
    this.mortalityLabel,
  });
}

class _ScorePoint {
  final DateTime date;
  final double value;
  final bool isAdmission;
  const _ScorePoint({
    required this.date,
    required this.value,
    this.isAdmission = false,
  });
}

class _ScoreComparison {
  final String label;
  final double? admission;
  final double? latest;
  const _ScoreComparison({
    required this.label,
    required this.admission,
    required this.latest,
  });

  double? get delta {
    if (admission == null || latest == null) return null;
    return latest! - admission!;
  }
}

class _ScoreTrendCard extends StatelessWidget {
  final _ScoreTrendData data;
  final Color color;
  const _ScoreTrendCard({required this.data, required this.color});

  @override
  Widget build(BuildContext context) {
    final latest = data.points.isNotEmpty ? data.points.last : null;
    final variation = data.points.length > 1 ? data.points.last.value - data.points.first.value : null;

    return Container(
      width: 240,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(data.label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 6),
          Text(
            latest != null ? latest.value.toStringAsFixed(1) : 'Sin registro',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
          ),
          if (data.mortalityLabel != null && data.mortalityLabel!.isNotEmpty)
            Text('Mort: ${data.mortalityLabel}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 12),
          Expanded(
            child: _MiniTrendChart(color: color, points: data.points),
          ),
          const SizedBox(height: 8),
          Text(
            variation != null && variation.abs() > 0
                ? 'Δ ${variation >= 0 ? '+' : ''}${variation.toStringAsFixed(1)}'
                : 'Esperando nuevas evoluciones',
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class _ScoresLineChart extends StatelessWidget {
  final List<_ScoreTrendData> trends;
  final Color Function(String label) colorResolver;

  const _ScoresLineChart({required this.trends, required this.colorResolver});

  @override
  Widget build(BuildContext context) {
    final allPoints = trends.expand((t) => t.points).toList();
    if (allPoints.length < 2) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(child: Text('Registra al menos dos evoluciones con scores para graficar.')),
      );
    }

    DateTime earliest = allPoints.first.date;
    DateTime latest = allPoints.first.date;
    double minValue = allPoints.first.value;
    double maxValue = allPoints.first.value;
    for (final point in allPoints) {
      if (point.date.isBefore(earliest)) earliest = point.date;
      if (point.date.isAfter(latest)) latest = point.date;
      if (point.value < minValue) minValue = point.value;
      if (point.value > maxValue) maxValue = point.value;
    }

    double daysFromBase(DateTime d) => d.difference(earliest).inHours / 24.0;
    final maxX = daysFromBase(latest);
    final range = (maxValue - minValue).abs();
    final double yPadding = (range < 2 ? 2 : range * 0.2).clamp(1, 10).toDouble();

    final series = <_ChartLineSeries>[];
    for (final trend in trends) {
      final spots = trend.points
          .map((p) => FlSpot(daysFromBase(p.date), p.value))
          .toList()
        ..sort((a, b) => a.x.compareTo(b.x));
      if (spots.length < 2) continue;
      series.add(
        _ChartLineSeries(
          label: trend.label,
          data: LineChartBarData(
            spots: spots,
            isCurved: true,
            barWidth: 3,
            color: colorResolver(trend.label),
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
        ),
      );
    }

    final double interval = maxX <= 0 ? 1 : (maxX / 4).clamp(1, 4).toDouble();

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: maxX <= 0 ? 1 : maxX,
        minY: minValue - yPadding,
        maxY: maxValue + yPadding,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: 1,
          verticalInterval: interval,
          getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey.shade200, strokeWidth: 1),
          getDrawingVerticalLine: (value) => FlLine(color: Colors.grey.shade100, strokeWidth: 1),
        ),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (_) => Colors.black.withValues(alpha: 0.7),
            getTooltipItems: (spots) => spots
                .map(
                  (s) => LineTooltipItem(
                    '${s.barIndex < series.length ? series[s.barIndex].label : 'Score'}: ${s.y.toStringAsFixed(1)}\nD+${s.x.toStringAsFixed(1)}',
                    const TextStyle(color: Colors.white),
                  ),
                )
                .toList(),
          ),
        ),
        borderData: FlBorderData(show: true, border: Border.all(color: Colors.grey.shade300)),
        titlesData: FlTitlesData(
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              interval: interval,
              getTitlesWidget: (value, meta) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text('D+${value.round()}', style: const TextStyle(fontSize: 10)),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 32,
              interval: 2,
              getTitlesWidget: (value, meta) => Text(value.toStringAsFixed(0), style: const TextStyle(fontSize: 10)),
            ),
          ),
        ),
        lineBarsData: series.map((s) => s.data).toList(),
      ),
    );
  }
}

class _ChartLineSeries {
  final String label;
  final LineChartBarData data;
  _ChartLineSeries({required this.label, required this.data});
}

class _MiniTrendChart extends StatelessWidget {
  final List<_ScorePoint> points;
  final Color color;
  const _MiniTrendChart({required this.points, required this.color});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (points.length < 2) {
          return Container(
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Icon(Icons.show_chart, color: color.withValues(alpha: 0.4)),
            ),
          );
        }
        return CustomPaint(
          size: Size(constraints.maxWidth, constraints.maxHeight),
          painter: _MiniTrendPainter(points: points, color: color),
        );
      },
    );
  }
}

class _MiniTrendPainter extends CustomPainter {
  final List<_ScorePoint> points;
  final Color color;
  _MiniTrendPainter({required this.points, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    final minX = points.map((p) => p.date.millisecondsSinceEpoch).reduce((a, b) => a < b ? a : b).toDouble();
    final maxX = points.map((p) => p.date.millisecondsSinceEpoch).reduce((a, b) => a > b ? a : b).toDouble();
    final minY = points.map((p) => p.value).reduce((a, b) => a < b ? a : b);
    final maxY = points.map((p) => p.value).reduce((a, b) => a > b ? a : b);
    final xRange = (maxX - minX).abs() < 0.001 ? 1 : maxX - minX;
    final yRange = (maxY - minY).abs() < 0.001 ? 1 : maxY - minY;

    Offset mapPoint(_ScorePoint point) {
      final x = ((point.date.millisecondsSinceEpoch - minX) / xRange) * size.width;
      final y = size.height - (((point.value - minY) / yRange) * size.height);
      return Offset(x, y);
    }

    final path = Path();
    for (var i = 0; i < points.length; i++) {
      final point = mapPoint(points[i]);
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }

    final linePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawPath(path, linePaint);

    final pointPaint = Paint()..color = color;
    for (final point in points) {
      final position = mapPoint(point);
      canvas.drawCircle(position, point.isAdmission ? 4 : 3, pointPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _MiniTrendPainter oldDelegate) {
    return oldDelegate.points != points || oldDelegate.color != color;
  }
}
