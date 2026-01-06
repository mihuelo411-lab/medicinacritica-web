import 'dart:convert';
import 'dart:ui';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:drift/drift.dart' as drift;
import 'package:uci_management/features/clinical_history/presentation/evolution_screen.dart';
import '../../ward_round/presentation/ward_round_screen.dart';
import '../../procedures/presentation/external_procedure_form.dart';
import 'package:uci_management/core/theme/app_theme.dart';
import '../../../../main.dart';
import '../../patients/data/patient_repository.dart';
import '../../clinical_history/presentation/clinical_history_screen.dart';
import '../../clinical_history/presentation/epicrisis_screen.dart';
import '../../clinical_history/presentation/indications_screen.dart';
import '../../exams/presentation/exam_results_screen.dart';
import '../../../../core/database/database.dart'; // For ActiveAdmission types if needed or models
import '../../../../core/services/supabase_service.dart';
import '../../../../core/services/sync_service.dart';

class UciMonitorScreen extends StatefulWidget {
  final bool showAdminControls;
  final VoidCallback? onAdminPanelRequested;
  final Future<void> Function()? onSignOut;
  const UciMonitorScreen({
    super.key,
    this.showAdminControls = false,
    this.onAdminPanelRequested,
    this.onSignOut,
  });

  @override
  State<UciMonitorScreen> createState() => _UciMonitorScreenState();
}

class _UciMonitorScreenState extends State<UciMonitorScreen> {
  bool? _isDarkMode; // Nullable to handle hot-reload state injection
  Map<int, ActiveAdmission> _occupiedBeds = {};
  Map<int, bool> _vasoactiveStatus = {};
  bool _isLoading = true;
  int _totalPatients = 0;
  int _dischargedPatients = 0;
  int _activeReadmissions = 0;

  @override
  void initState() {
    super.initState();
    _loadBedData();
  }

  Future<void> _loadBedData() async {
    // 0. Sync from Cloud (One-way sync for now)
    // We do this first so local DB is up to date
    try {
      await patientRepository.syncFromSupabase();
    } catch (e) {
      debugPrint('Sync failed silently: $e');
    }

    // 1. Fetch from repository (Local DB)
    final admissions = await patientRepository.getActiveAdmissions();
    
    // 2. Map to bed numbers
    final Map<int, ActiveAdmission> map = {};
    for (var a in admissions) {
      if (a.admission.bedNumber != null) {
        map[a.admission.bedNumber!] = a;
      }
    }

    final vasoMap = await _fetchVasoactiveStatus(map);
    final readmissionCount = admissions.where((a) => a.admission.isReadmission).length;
    final dischargedCount = await _fetchDischargedCount();
    final totalPatients = await _fetchTotalPatientsCount();

    if (mounted) {
      setState(() {
        _occupiedBeds = map;
        _vasoactiveStatus = vasoMap;
        _activeReadmissions = readmissionCount;
        _dischargedPatients = dischargedCount;
        _totalPatients = totalPatients;
        _isLoading = false;
      });
    }
  }

  Future<int> _fetchDischargedCount() async {
    try {
      final row = await appDatabase.customSelect(
        'SELECT COUNT(*) AS total FROM admissions WHERE status = ?',
        variables: [drift.Variable.withString('alta')],
        readsFrom: {appDatabase.admissions},
      ).getSingle();
      return row.read<int>('total');
    } catch (_) {
      return 0;
    }
  }

  Future<int> _fetchTotalPatientsCount() async {
    try {
      final row = await appDatabase.customSelect(
        'SELECT COUNT(*) AS total FROM patients',
        readsFrom: {appDatabase.patients},
      ).getSingle();
      return row.read<int>('total');
    } catch (_) {
      return 0;
    }
  }

  Future<Map<int, bool>> _fetchVasoactiveStatus(Map<int, ActiveAdmission> beds) async {
    final result = <int, bool>{};
    for (final entry in beds.entries) {
      final admissionId = entry.value.admission.id;
      final lastEvolution = await (appDatabase.select(appDatabase.evolutions)
            ..where((tbl) => tbl.admissionId.equals(admissionId))
            ..orderBy([(tbl) => drift.OrderingTerm.desc(tbl.date)])
            ..limit(1))
          .get();
      if (lastEvolution.isEmpty) continue;
      final flag = _parseVasoactiveFlag(lastEvolution.first.objectiveJson);
      if (flag != null) {
        result[entry.key] = flag;
      }
    }
    return result;
  }

  bool? _parseVasoactiveFlag(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map) {
        final entry = decoded['Vasoactivos'] ?? decoded['vasoactivos'];
        if (entry == null) return null;
        if (entry is bool) return entry;
        final normalized = entry.toString().toLowerCase().trim();
        if (normalized.isEmpty) return null;
        if (normalized == '1' || normalized == 'true' || normalized == 'sí' || normalized == 'si') {
          return true;
        }
        if (normalized == '0' || normalized == 'false') return false;
        if (normalized.contains('sin') || normalized.contains('suspend')) return false;
        if (normalized.contains('uso') || normalized.contains('activo')) return true;
      }
    } catch (_) {}
    return null;
  }



  @override
  Widget build(BuildContext context) {
    // Premium iOS-style Gradient Background
    final isDark = _isDarkMode ?? false;
    // Calculate Stats
    final occupiedCount = _occupiedBeds.length;
    final totalBeds = 13;
    final occupancyPercent = ((occupiedCount / totalBeds) * 100).toStringAsFixed(0);
    
    final criticalCount = _occupiedBeds.values.where((a) => (a.admission.sofaScore ?? 0) > 6).length;
    final ventilatedCount = _occupiedBeds.values.where((a) => (a.admission.procedures ?? '').toLowerCase().contains('ventilaci')).length;

    return Theme(
      data: isDark ? AppTheme.darkTheme : AppTheme.lightTheme,
      child: Scaffold(
        extendBodyBehindAppBar: true, 
        backgroundColor: isDark ? AppTheme.darkTheme.scaffoldBackgroundColor : AppTheme.lightTheme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          // 1. Dynamic Bouncing Bubbles Background
          const Positioned.fill(child: _BouncingBubblesBackground()),

          // 2. Main Scroll View
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Large Collapsing Header
              SliverAppBar(
                backgroundColor: Colors.transparent,
                expandedHeight: 80, // Reduced from 120
                floating: false,
                pinned: true,
                elevation: 0,
                actions: [
                  IconButton(
                    tooltip: 'Procedimiento externo',
                    icon: const Icon(Icons.add_circle_outline, color: Colors.white),
                    onPressed: () => _openExternalProcedureForm(context),
                  ),
                  PopupMenuButton<String>(
                    icon: CircleAvatar(
                      backgroundColor: isDark ? Colors.white.withOpacity(0.2) : Colors.grey.withOpacity(0.1),
                      radius: 16,
                      child: Icon(Icons.settings, color: isDark ? Colors.white : Colors.grey.shade800, size: 20),
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    onSelected: (value) {
                      if (value == 'theme') {
                        setState(() => _isDarkMode = !isDark);
                      }
                    },
                    itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(
                        value: 'theme',
                        child: Row(
                          children: [
                            Icon(isDark ? Icons.light_mode : Icons.dark_mode, color: Colors.indigo),
                            const SizedBox(width: 12),
                            Text(isDark ? 'Modo Claro' : 'Modo Oscuro'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (widget.showAdminControls && widget.onAdminPanelRequested != null)
                    IconButton(
                      icon: const Icon(Icons.admin_panel_settings_outlined, color: Colors.white),
                      onPressed: widget.onAdminPanelRequested,
                    ),
                  if (widget.onSignOut != null)
                    IconButton(
                      icon: const Icon(Icons.logout),
                      onPressed: () async => await widget.onSignOut?.call(),
                    ),
                  const SizedBox(width: 8),
                ],
                flexibleSpace: ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: FlexibleSpaceBar(
                      titlePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      centerTitle: false,
                      title: Row(
                        children: [
                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              image: const DecorationImage(
                                image: AssetImage('assets/images/logo_hospital.jpeg'),
                                fit: BoxFit.cover,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'HOSPITAL REGIONAL',
                                style: TextStyle(
                                  color: isDark ? Colors.white70 : Colors.grey.shade600,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 10,
                                  letterSpacing: 1.5,
                                ),
                              ),
                              Text(
                                'DE TRUJILLO', 
                                style: TextStyle(
                                  color: isDark ? Colors.white : Colors.indigo.shade900,
                                  fontWeight: FontWeight.w800, 
                                  fontSize: 16, 
                                  letterSpacing: -0.2,
                                  fontFamily: 'Roboto', 
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      background: Container(
                        color: const Color(0xFF1E1E2C).withOpacity(0.2), // Darker tint
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20), // Removed top padding
                        child: Icon(
                          Icons.grid_view_rounded, 
                          color: Colors.white.withOpacity(0.05), // Subtler
                          size: 40
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // 3. Stats Section (Glass Pills)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                  child: Row(
                    children: [
                      _GlassStatPill(
                        label: 'Ocupación',
                        value: '$occupancyPercent%',
                        icon: Icons.pie_chart_rounded,
                        color: const Color(0xFF8E8CFF), // Lighter Indigo for Dark Mode
                      ),
                      const SizedBox(width: 12),
                      _GlassStatPill(
                        label: 'Críticos',
                        value: criticalCount.toString(),
                        icon: Icons.warning_amber_rounded,
                        color: const Color(0xFFFF6B60), // Lighter Red
                        isAlert: criticalCount > 0,
                      ),
                      const SizedBox(width: 12),
                      _GlassStatPill(
                        label: 'Ventilados',
                        value: ventilatedCount.toString(),
                        icon: Icons.air,
                        color: const Color(0xFF5AC8FA), // Lighter Blue
                      ),
                    ],
                  ),
                ),
              ),

              // 3b. Status summary columns
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final isNarrow = constraints.maxWidth < 600;
                      final ingresadosCard = _StatusSummaryCard(
                        title: 'Pacientes ingresados',
                        highlight: occupiedCount.toString(),
                        icon: Icons.sensor_occupied_outlined,
                        metrics: [
                          _StatusSummaryMetric(
                            label: 'Activos en cama',
                            value: occupiedCount.toString(),
                            color: const Color(0xFF34C759),
                          ),
                          _StatusSummaryMetric(
                            label: 'Reingresos detectados',
                            value: _activeReadmissions.toString(),
                            color: const Color(0xFF9C27B0),
                          ),
                        ],
                      );
                      final totalesCard = _StatusSummaryCard(
                        title: 'Pacientes totales',
                        highlight: _totalPatients.toString(),
                        icon: Icons.groups_2_outlined,
                        metrics: [
                          _StatusSummaryMetric(
                            label: 'Dados de alta (histórico)',
                            value: _dischargedPatients.toString(),
                            color: const Color(0xFFFF9500),
                          ),
                          _StatusSummaryMetric(
                            label: 'Actualmente en cama',
                            value: occupiedCount.toString(),
                            color: const Color(0xFF5AC8FA),
                          ),
                        ],
                      );
                      if (isNarrow) {
                        return Column(
                          children: [
                            ingresadosCard,
                            const SizedBox(height: 12),
                            totalesCard,
                          ],
                        );
                      }
                      return Row(
                        children: [
                          Expanded(child: ingresadosCard),
                          const SizedBox(width: 12),
                          Expanded(child: totalesCard),
                        ],
                      );
                    },
                  ),
                ),
              ),


              // 4. Section Title
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Text(
                    'PACIENTES ACTIVOS',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                      color: isDark ? Colors.white54 : Colors.grey.shade600,
                    ),
                  ),
                ),
              ),

              // 5. Grid Content
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 400,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.5, // Wider cards for more info space
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final bedNum = index + 1;
                      return _GlassPatientCard(
                        bedNumber: bedNum, 
                        admission: _occupiedBeds[bedNum],
                        onRefresh: _loadBedData,
                        vasoactiveActive: _vasoactiveStatus[bedNum],
                        onDischarge: (ctx, adm) {
                          _showDischargeDialog(ctx, bedNum, adm);
                        },
                      );
                    },
                    childCount: 13,
                  ),
                ),
              ),
              
              const SliverPadding(padding: EdgeInsets.only(bottom: 40)),
            ],
          ),
        ],
      ),
      ),
    );
  }

  Future<void> _openExternalProcedureForm(BuildContext context) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: const ExternalProcedureForm(),
        );
      },
    );
    if (result == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Procedimiento externo registrado.')),
      );
      _loadBedData();
    }
  }

  void _showDischargeDialog(BuildContext context, int bedNumber, ActiveAdmission? admission) {
    if (admission == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sin información de admisión.')));
      return;
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Egreso'),
        content: Text('¿Está seguro que desea liberar la Cama $bedNumber?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              _startEpicrisisFlow(context, admission);
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('DAR DE ALTA'),
          ),
        ],
      ),
    );
  }

  Future<void> _startEpicrisisFlow(BuildContext context, ActiveAdmission admission) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => EpicrisisScreen(
          activeAdmission: admission,
          onDischarge: () => _completeDischarge(admission.admission.id),
        ),
      ),
    );
    if (result == true) {
      await _loadBedData();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Paciente dado de alta')));
    }
  }

  Future<void> _completeDischarge(int admissionId) async {
    final dischargeDate = DateTime.now();
    try {
      await SupabaseService().dischargeAdmission(
        admissionId: admissionId,
        dischargedAt: dischargeDate,
      );
      await (appDatabase.update(appDatabase.admissions)
            ..where((tbl) => tbl.id.equals(admissionId)))
          .write(
            AdmissionsCompanion(
              bedNumber: const drift.Value<int?>(null),
              dischargedAt: drift.Value(dischargeDate),
              status: const drift.Value('alta'),
              isSynced: const drift.Value(true),
            ),
          );
      try {
        await SyncService(appDatabase, SupabaseService()).syncAll();
      } catch (syncError) {
        debugPrint('Full sync after discharge failed: $syncError');
      }
    } catch (error) {
      await (appDatabase.update(appDatabase.admissions)
            ..where((tbl) => tbl.id.equals(admissionId)))
          .write(
            AdmissionsCompanion(
              bedNumber: const drift.Value<int?>(null),
              dischargedAt: drift.Value(dischargeDate),
              status: const drift.Value('alta'),
              isSynced: const drift.Value(false),
            ),
          );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error sincronizando alta: $error')),
        );
      }
      rethrow;
    }
  }
}

class _GlassStatPill extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final bool isAlert;

  const _GlassStatPill({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.isAlert = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            height: 105,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isAlert 
                ? color.withOpacity(0.15) 
                : Colors.white.withOpacity(0.6),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withOpacity(0.4),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 22),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black87, // Adaptive
                        letterSpacing: -0.5,
                      ),
                    ),
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.black54, // Adaptive
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GlassPatientCard extends StatelessWidget {
  final int bedNumber;
  final ActiveAdmission? admission;
  final VoidCallback onRefresh;
  final bool? vasoactiveActive;
  final void Function(BuildContext context, ActiveAdmission admission) onDischarge;

  const _GlassPatientCard({
    required this.bedNumber, 
    this.admission,
    required this.onRefresh,
    this.vasoactiveActive,
    required this.onDischarge,
  });

  @override
  Widget build(BuildContext context) {
    final bool isOccupied = admission != null;
    final bool isCritical = isOccupied && (admission!.admission.sofaScore ?? 0) > 6; // Real logic based on SOFA?
    final bool isVentilated = false; // Need data for this, defaulting to false for now
    final bool isOnVasoactives = vasoactiveActive ?? false;
    final bool isReadmission = admission?.admission.isReadmission ?? false;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDark ? Colors.white : Colors.black87;
    final secondaryTextColor = isDark ? Colors.white60 : Colors.black54;
    final glassColor = isDark ? Colors.white.withOpacity(0.1) : Colors.white.withOpacity(0.6); // Darker glass for light mode ? No, white glass on light bg needs to be opaque or different. Actually, standard glass is white with opacity. On light BG, white opacity makes it lighter. We might want a darker tint for contrast or just rely on the shadow/border. Let's try white glass but dark text.

    return GestureDetector(  
      onTap: () async {
        if (isOccupied) {
          _showFloatingGlassMenu(context, bedNumber, admission);
        } else {
          // Empty bed -> New Admission
          // Temporarily bypassing WardRoundScreen for direct admission if needed, 
          // or we must update WardRoundScreen. Let's stick to user flow but ensure we refresh.
           await Navigator.push(context, MaterialPageRoute(builder: (c) => WardRoundScreen(
             bedNumber: bedNumber,
             admission: null,
           )));
           onRefresh(); // Refresh after returning
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              decoration: BoxDecoration(
                color: isOccupied 
                    ? (isDark ? Colors.white.withOpacity(0.1) : Colors.white) // Solid white card for light mode usually looks better or slightly off-white
                    : (isDark ? Colors.white.withOpacity(0.05) : Colors.white.withOpacity(0.4)),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? Colors.white.withOpacity(0.2) : Colors.black.withOpacity(0.05),
                  width: 1.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2), // Darker shadow
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Decorative background icon for texture
                  Positioned(
                    right: -10,
                    bottom: -10,
                    child: Icon(
                      Icons.bed_rounded,
                      size: 80,
                      color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05), // Dark icon for light mode
                    ),
                  ),
                  
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: isOccupied ? Colors.white.withOpacity(0.1) : Colors.transparent,
                                borderRadius: BorderRadius.circular(30),
                                border: isOccupied ? null : Border.all(color: Colors.white24),
                              ),
                              child: Text(
                                'Cama $bedNumber',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: primaryTextColor, // Adaptive color
                                ),
                              ),
                            ),
                            if (isOccupied)
                              _StatusDot(isCritical: isCritical),
                          ],
                        ),
                        
                        const Spacer(),

                        if (isOccupied) ...[
                          Text(
                            admission!.patient.name,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: primaryTextColor, // Adaptive
                              letterSpacing: -0.3,
                            ),
                            maxLines: 1, overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${admission!.admission.diagnosis ?? "Sin Diagnóstico"} • ${admission!.patient.age}a',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: secondaryTextColor, // Adaptive
                            ),
                            maxLines: 1, overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: [
                              if (isVentilated)
                                const _MiniBadge(icon: Icons.air, color: Color(0xFF5AC8FA)), // Light Blue
                              if (isOnVasoactives)
                                const _MiniBadge(icon: Icons.bolt, color: Color(0xFFFF9500)),
                              if (isCritical)
                                const _MiniBadge(icon: Icons.monitor_heart, color: Color(0xFFFF6B60)), // Light Red
                              if (isReadmission)
                                const _ReingresoBadge(),
                            ],
                          ),
                        ] else ...[
                          Center(
                            child: Text(
                              'Disponible',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: isDark ? Colors.white30 : Colors.black26, // Adaptive
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _Bubble _generateBubble(int random) {
    return _Bubble(
      x: (random % 100) / 100.0,
      y: ((random * 2) % 100) / 100.0,
      radius: 50.0 + (random % 80),
      dx: ((random % 10) - 5) / 2000.0,
      dy: ((random % 10) - 5) / 2000.0,
      color: HSLColor.fromAHSL(
        0.15 + ((random % 20) / 100.0), // Opacity
        (random % 360).toDouble(), // Hue
        0.6, // Saturation
        0.4 // Lightness (Darker for visibility on light BG)
      ).toColor(),
    );
  }

  void _showFloatingGlassMenu(BuildContext context, int bedNumber, ActiveAdmission? admission) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Cerrar',
      barrierColor: Colors.black.withOpacity(0.3),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return Stack(
          children: [
            // Full screen blur
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(color: Colors.transparent),
              ),
            ),
            Center(
              child: ScaleTransition(
                scale: CurvedAnimation(parent: anim1, curve: Curves.easeOutBack),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.85),
                        borderRadius: BorderRadius.circular(24),
                         border: Border.all(color: Colors.white, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                             // Header
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.indigo.shade100,
                                  child: Icon(Icons.person, color: Colors.indigo.shade900),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('CAMA $bedNumber', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
                                      Text(
                                        admission?.patient.name ?? 'Sin paciente',
                                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close_rounded, color: Colors.grey),
                                  onPressed: () => Navigator.pop(context),
                                )
                              ],
                            ),
                            const Divider(height: 32),
                             // Items
                            _buildMenuItem(context, Icons.medical_services_rounded, 'Visita Médica', Colors.teal, () {
                                Navigator.pop(context);
                                Navigator.push(context, MaterialPageRoute(builder: (c) => WardRoundScreen(
                                  bedNumber: bedNumber,
                                  admission: admission,
                                )));
                             }),
                            _buildMenuItem(context, Icons.edit_note_rounded, 'Evolucionar', Colors.orange, () {
                               Navigator.pop(context);
                               Navigator.push(context, MaterialPageRoute(builder: (c) => EvolutionScreen(bedNumber: bedNumber)));
                            }),
                            _buildMenuItem(context, Icons.history_edu_rounded, 'Historia Clínica', Colors.purple, () {
                               if (admission != null) {
                                Navigator.pop(context); // Close dialog
                                Navigator.push(context, MaterialPageRoute(builder: (c) => ClinicalHistoryScreen(
                                  activeAdmission: admission!
                                )));
                               } else {
                                 Navigator.pop(context);
                                 ScaffoldMessenger.of(context).showSnackBar(
                                   const SnackBar(content: Text('Error: Información de admisión no disponible'))
                                 );
                               }
                            }),
                            _buildMenuItem(context, Icons.analytics_outlined, 'Exámenes auxiliares', Colors.indigo, () {
                              if (admission == null) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Información de admisión no disponible')),
                                );
                                return;
                              }
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (c) => ExamResultsScreen(activeAdmission: admission!),
                                ),
                              );
                            }),
                            _buildMenuItem(context, Icons.assignment_rounded, 'Hoja de indicaciones', Colors.blueGrey, () {
                              if (admission == null) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Información de admisión no disponible')),
                                );
                                return;
                              }
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (c) => IndicationsScreen(activeAdmission: admission!),
                                ),
                              );
                            }),
                             const Divider(height: 24),
                            _buildMenuItem(context, Icons.exit_to_app_rounded, 'Dar de Alta', Colors.red, () {
                                if (admission == null) {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Información de admisión no disponible'))
                                  );
                                  return;
                                }
                                Navigator.pop(context);
                                onDischarge(context, admission!);
                            }, isDestructive: true),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String text, Color color, VoidCallback onTap, {bool isDestructive = false}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 16),
            Text(
              text, 
              style: TextStyle(
                fontSize: 16, 
                fontWeight: FontWeight.w600, 
                color: isDestructive ? Colors.red : Colors.black87
              )
            ),
            const Spacer(),
            Icon(Icons.chevron_right_rounded, color: Colors.black26, size: 20),
          ],
        ),
      ),
    );
  }

}

class _StatusSummaryMetric {
  final String label;
  final String value;
  final Color color;
  const _StatusSummaryMetric({
    required this.label,
    required this.value,
    required this.color,
  });
}

class _StatusSummaryCard extends StatelessWidget {
  final String title;
  final String highlight;
  final IconData icon;
  final List<_StatusSummaryMetric> metrics;
  const _StatusSummaryCard({
    required this.title,
    required this.highlight,
    required this.icon,
    required this.metrics,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.05),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.35 : 0.08),
            blurRadius: 25,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF5A6AF0)),
          const SizedBox(height: 10),
          Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              letterSpacing: 0.6,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white70 : Colors.blueGrey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            highlight,
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w800,
              letterSpacing: -1.2,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 14),
          ...metrics.map((metric) => _StatusMetricRow(metric: metric)).toList(),
        ],
      ),
    );
  }
}

class _StatusMetricRow extends StatelessWidget {
  final _StatusSummaryMetric metric;
  const _StatusMetricRow({required this.metric});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: metric.color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: metric.color.withOpacity(0.4),
                  blurRadius: 6,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              metric.label,
              style: TextStyle(
                fontSize: 13,
                color: isDark ? Colors.white70 : Colors.grey.shade600,
              ),
            ),
          ),
          Text(
            metric.value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusDot extends StatelessWidget {
  final bool isCritical;
  const _StatusDot({required this.isCritical});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: isCritical ? const Color(0xFFFF3B30) : const Color(0xFF34C759), // iOS Red or Green
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: (isCritical ? Colors.red : Colors.green).withOpacity(0.4),
            blurRadius: 6,
            spreadRadius: 2,
          ),
        ],
      ),
    );
  }
}

class _MiniBadge extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _MiniBadge({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 14, color: color),
    );
  }
}

class _ReingresoBadge extends StatelessWidget {
  const _ReingresoBadge();

  @override
  Widget build(BuildContext context) {
    const badgeColor = Color(0xFF9C27B0);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.repeat, size: 13, color: badgeColor),
          SizedBox(width: 4),
          Text(
            'Reingreso',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: badgeColor,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

// New Bouncing Bubbles Widget
class _BouncingBubblesBackground extends StatefulWidget {
  const _BouncingBubblesBackground({super.key});

  @override
  State<_BouncingBubblesBackground> createState() => _BouncingBubblesBackgroundState();
}

class _BouncingBubblesBackgroundState extends State<_BouncingBubblesBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_Bubble> _bubbles = [];
  final int _bubbleCount = 12;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < _bubbleCount; i++) {
        _bubbles.add(_Bubble.random());
    }

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        for (var bubble in _bubbles) {
          bubble.update();
        }
        return CustomPaint(
          painter: _BubblePainter(_bubbles),
          size: Size.infinite,
        );
      },
    );
  }
}

class _Bubble {
  double x;
  double y;
  double radius;
  double dx;
  double dy;
  Color color;

  _Bubble({
    required this.x,
    required this.y,
    required this.radius,
    required this.dx,
    required this.dy,
    required this.color,
  });

  factory _Bubble.random() {
    final random = DateTime.now().microsecondsSinceEpoch;
    final r = Random(random); 
    
    return _Bubble(
      x: r.nextDouble(),
      y: r.nextDouble(),
      radius: 50.0 + r.nextInt(100), 
      dx: (r.nextDouble() - 0.5) / 200, 
      dy: (r.nextDouble() - 0.5) / 200,
      color: HSLColor.fromAHSL(
        0.15 + (r.nextDouble() * 0.2), 
        r.nextDouble() * 360,
        0.6,
        0.4
      ).toColor(),
    );
  }

  void update() {
    x += dx;
    y += dy;
    if (x < -0.2 || x > 1.2) dx = -dx;
    if (y < -0.2 || y > 1.2) dy = -dy;
  }
}

class _BubblePainter extends CustomPainter {
  final List<_Bubble> bubbles;

  _BubblePainter(this.bubbles);

  @override
  void paint(Canvas canvas, Size size) {
    for (var bubble in bubbles) {
      final paint = Paint()
        ..color = bubble.color
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 30); 

      canvas.drawCircle(
        Offset(bubble.x * size.width, bubble.y * size.height),
        bubble.radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
