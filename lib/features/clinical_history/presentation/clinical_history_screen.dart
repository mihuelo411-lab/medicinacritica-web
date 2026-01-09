import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:ui';
import 'package:drift/drift.dart' as drift;
import '../../patients/data/patient_repository.dart';
import '../../patients/presentation/admission_screen.dart';
import '../../patients/presentation/pdf/admission_pdf_generator.dart';
import '../../common/utils/procedure_narrative_builder.dart';
import '../../../../core/database/database.dart'; // For AdmissionsCompanion
import '../../../../main.dart'; // appDatabase
import '../presentation/pdf/evolution_pdf_generator.dart';
import 'indications_screen.dart';
import 'epicrisis_screen.dart';

class ClinicalHistoryScreen extends StatefulWidget {
  final ActiveAdmission activeAdmission;

  const ClinicalHistoryScreen({super.key, required this.activeAdmission});

  @override
  State<ClinicalHistoryScreen> createState() => _ClinicalHistoryScreenState();
}

class _PlanSigners {
  final String? preparedByName;
  final String? preparedByRole;
  final String? secondaryName;
  final String? secondaryRole;
  const _PlanSigners({
    this.preparedByName,
    this.preparedByRole,
    this.secondaryName,
    this.secondaryRole,
  });
}

class _ClinicalHistoryScreenState extends State<ClinicalHistoryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final patient = widget.activeAdmission.patient;
    final admission = widget.activeAdmission.admission;
    final theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // 1. Background Gradient (Fixed)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.indigo.shade50, Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          
          // 2. Main Content
          NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  expandedHeight: 200, // Increased height to prevent overlap
                  pinned: true,
                  backgroundColor: Colors.transparent, // Transparent for Glass effect
                  elevation: 0,
                  leading: const BackButton(color: Colors.indigo), // Dark back button for visibility
                  flexibleSpace: ClipRRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: FlexibleSpaceBar(
                        titlePadding: const EdgeInsets.only(left: 50, bottom: 60), // Adjusted padding
                        centerTitle: false,
                        title: innerBoxIsScrolled 
                          ? Text(patient.name, style: TextStyle(color: Colors.indigo.shade900, fontWeight: FontWeight.bold, fontSize: 16))
                          : null, // Hide title when expanded, use custom content below
                        background: Container(
                          padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.7), // Glass tint
                            border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.5))),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end, // Push content to bottom
                            children: [
                               Row(
                                 children: [
                                   Hero(
                                     tag: 'avatar_${admission.bedNumber}',
                                     child: CircleAvatar(
                                       radius: 30, // Slightly bigger
                                       backgroundColor: Colors.indigo.shade100,
                                       child: Text(
                                         patient.name.substring(0, 1).toUpperCase(),
                                         style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.indigo.shade900),
                                       ),
                                     ),
                                   ),
                                   const SizedBox(width: 16),
                                   Expanded(
                                     child: Column(
                                       crossAxisAlignment: CrossAxisAlignment.start,
                                       mainAxisSize: MainAxisSize.min,
                                       children: [
                                         Text(
                                           patient.name,
                                           style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.indigo.shade900),
                                           maxLines: 1, overflow: TextOverflow.ellipsis,
                                         ),
                                         const SizedBox(height: 4),
                                         Text(
                                           '${patient.age} años • Cama ${admission.bedNumber}',
                                           style: TextStyle(color: Colors.indigo.shade400, fontSize: 13, fontWeight: FontWeight.w600),
                                         ),
                                       ],
                                     ),
                                   ),
                                 ],
                               ),
                               const SizedBox(height: 60), // Add padding for TabBar clearance
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(48),
                    child: Container(
                      color: Colors.white.withOpacity(0.5), // Glassy tab bar
                      child: TabBar(
                        controller: _tabController,
                        indicatorColor: Colors.indigo,
                        indicatorWeight: 3,
                        labelColor: Colors.indigo.shade900,
                        unselectedLabelColor: Colors.grey,
                        labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                        tabs: const [
                          Tab(text: 'Admisión', icon: Icon(Icons.description_outlined, size: 20)),
                          Tab(text: 'Evoluciones', icon: Icon(Icons.history_edu, size: 20)),
                          Tab(text: 'Indicaciones', icon: Icon(Icons.checklist, size: 20)),
                          Tab(text: 'Epicrisis', icon: Icon(Icons.assignment_turned_in_outlined, size: 20)),
                          Tab(text: 'Exámenes', icon: Icon(Icons.biotech, size: 20)),
                        ],
                      ),
                    ),
                  ),
                ),
              ];
            },
            body: TabBarView(
              controller: _tabController,
              children: [
                _buildAdmissionTab(context, widget.activeAdmission),
                _buildEvolutionsTab(context, widget.activeAdmission),
                IndicationsBoard(activeAdmission: widget.activeAdmission),
                EpicrisisBoard(activeAdmission: widget.activeAdmission),
                const Center(child: Text('Exámenes Auxiliares (Próximamente)')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEvolutionsTab(BuildContext context, ActiveAdmission data) {
    return FutureBuilder<List<Evolution>>(
      future: (appDatabase.select(appDatabase.evolutions)
            ..where((t) => t.admissionId.equals(data.admission.id))
            ..orderBy([(t) => drift.OrderingTerm.desc(t.date)]))
          .get(),
      builder: (context, snap) {
        if (!snap.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final list = snap.data!;
        if (list.isEmpty) {
          return const Center(child: Text('Sin evoluciones registradas.'));
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          separatorBuilder: (_, __) => const Divider(),
          itemCount: list.length,
          itemBuilder: (context, idx) {
            final ev = list[idx];
            final dt = DateFormat('dd/MM/yyyy HH:mm').format(ev.date);
            final diag = ev.diagnosis ?? data.admission.diagnosis ?? '-';
            final vm = _parseMap(ev.vmSettingsJson);
            final guardia = vm['Guardia'] ?? '';
            return ListTile(
              title: Text(dt, style: Theme.of(context).textTheme.titleMedium),
              subtitle: Text(
                guardia.isNotEmpty ? '$diag • $guardia' : diag,
                maxLines: 2, overflow: TextOverflow.ellipsis,
              ),
              trailing: IconButton(
                icon: const Icon(Icons.print),
                tooltip: 'Reimprimir',
                onPressed: () => _printEvolution(ev, data.patient, data.admission),
              ),
            );
          },
        );
      },
    );
  }

  Map<String, String> _parseMap(String? jsonStr) {
    if (jsonStr == null || jsonStr.isEmpty) return {};
    try {
      final Map<String, dynamic> raw = jsonDecode(jsonStr);
      return raw.map((k, v) => MapEntry(k, v?.toString() ?? ''));
    } catch (_) {
      return {};
    }
  }

  Future<void> _printEvolution(Evolution evo, Patient patient, Admission admission) async {
    final vitals = _parseMap(evo.vitalsJson);
    final vm = _parseMap(evo.vmSettingsJson);
    final mech = _parseMap(evo.vmMechanicsJson);
    final objective = _parseMap(evo.objectiveJson);
    final guardia = vm['Guardia'] ?? 'Guardia';
    final proceduresText = await _buildStoredEvolutionProceduresNarrative(
      admission.id,
      guardia,
      generalNotes: evo.proceduresNote,
    );

    final preparedByName = evo.authorName;
    final preparedByRole = _mapRoleLabel(evo.authorRole);
    await EvolutionPdfGenerator.generateAndPrint(
      patient: patient,
      admission: admission,
      currentDiagnosis: evo.diagnosis ?? admission.diagnosis,
      vitals: vitals,
      vmSettings: vm,
      vmMechanics: mech,
      subjective: evo.subjective ?? '',
      objective: objective,
      analysis: evo.analysis ?? '',
      plan: evo.plan ?? '',
      guardia: guardia,
      noteDateTime: evo.date,
      procedures: proceduresText,
      preparedByName: preparedByName,
      preparedByRole: preparedByRole,
    );
  }

  Future<String> _buildStoredEvolutionProceduresNarrative(
    int admissionId,
    String? guardia, {
    String? generalNotes,
  }) async {
    final query = appDatabase.select(appDatabase.performedProcedures)
      ..where((t) => t.admissionId.equals(admissionId))
      ..where((t) => t.origin.equals('evolucion'));
    final guardiaTrimmed = guardia?.trim();
    if (guardiaTrimmed != null && guardiaTrimmed.isNotEmpty) {
      query.where((t) => t.guardia.equals(guardiaTrimmed));
    } else {
      query.where((t) => t.guardia.isNull());
    }
    final rows = await query.get();
    if (rows.isEmpty && (generalNotes == null || generalNotes.trim().isEmpty)) {
      return '';
    }
    return buildProcedureNarrative(
      generalNotes: generalNotes,
      entries: rows.map((p) => ProcedureNarrativeEntry(
        procedureName: p.procedureName,
        performedAt: p.performedAt,
        assistant: p.assistant,
        resident: p.resident,
        guardia: p.guardia,
        note: p.note,
      )),
    );
  }

  String? _mapRoleLabel(String? code) {
    if (code == null) return null;
    switch (code.toLowerCase()) {
      case 'médico residente':
      case 'medico residente':
      case 'residente':
        return 'MÉDICO RESIDENTE';
      case 'médico asistente':
      case 'medico asistente':
      case 'medico':
      case 'asistente':
      case 'admin':
        return 'MÉDICO ASISTENTE';
      default:
        return null;
    }
  }

  _PlanSigners _extractSignersFromPlan(String? plan) {
    if (plan == null) return const _PlanSigners();
    final headerRegex = RegExp(
      r'^\[Sesión:\s*([^\]|]+)(?:\s*\|\s*Médico tratante:\s*([^\]|]+))?(?:\s*\|\s*Asistente responsable:\s*([^\]]+))?\]',
      caseSensitive: false,
    );
    final match = headerRegex.firstMatch(plan);
    if (match == null) return const _PlanSigners();
    final roleText = match.group(1)?.trim().toLowerCase() ?? '';
    String? preparedRole;
    if (roleText.contains('residente')) {
      preparedRole = 'MÉDICO RESIDENTE';
    } else if (roleText.contains('asistente')) {
      preparedRole = 'MÉDICO ASISTENTE';
    }
    final preparedName = match.group(2)?.trim();
    final supervisor = match.group(3)?.trim();
    String? secondaryRole;
    if (supervisor != null && supervisor.isNotEmpty) {
      secondaryRole = 'MÉDICO ASISTENTE';
    }
    return _PlanSigners(
      preparedByName: preparedName?.isNotEmpty == true ? preparedName : null,
      preparedByRole: preparedRole,
      secondaryName: supervisor?.isNotEmpty == true ? supervisor : null,
      secondaryRole: secondaryRole,
    );
  }

  Widget _buildAdmissionTab(BuildContext context, ActiveAdmission data) {
    final adm = data.admission;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Action Buttons
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            children: [
              // Expanded(
              //   child: ElevatedButton.icon(
              //     onPressed: () {
              //        // Navigate to Edit
              //        Navigator.push(context, MaterialPageRoute(
              //          builder: (c) => AdmissionScreen(
              //            bedNumber: adm.bedNumber,
              //            admissionToEdit: data,
              //          )
              //        )).then((_) {
              //          // Reload to show updates? Ideally callback or refresh
              //          setState((){});
              //        });
              //     },
              //     icon: const Icon(Icons.edit_note, color: Colors.white),
              //     label: const Text('Editar Nota', style: TextStyle(color: Colors.white)),
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: Colors.orange.shade600,
              //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              //     ),
              //   ),
              // ),
              // const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () async {
                     // Reprint Logic
                     Map<String, String> vitalsMap = {};
                     if (adm.vitalsJson != null) {
                       try {
                         final mm = jsonDecode(adm.vitalsJson!) as Map<String, dynamic>;
                         mm.forEach((k, v) => vitalsMap[k] = v.toString());
                       } catch(_){}
                     }

                     final performed = await (appDatabase
                           .select(appDatabase.performedProcedures)
                         ..where((t) => t.admissionId.equals(adm.id))
                         ..where((t) => t.origin.equals('ingreso')))
                       .get();
                     final proceduresForPdf = buildProcedureNarrative(
                       generalNotes: adm.procedures,
                       entries: performed.map(
                         (p) => ProcedureNarrativeEntry(
                           procedureName: p.procedureName,
                           performedAt: p.performedAt,
                           assistant: p.assistant,
                           resident: p.resident,
                           guardia: p.guardia,
                           note: p.note,
                         ),
                       ),
                     );

                    final signers = _extractSignersFromPlan(adm.plan);
                    await AdmissionPdfGenerator.generateAndPrint(
                      patient: data.patient,
                      admission: AdmissionsCompanion(
                        id: drift.Value(adm.id),
                         diagnosis: drift.Value(adm.diagnosis ?? ''),
                         signsSymptoms: drift.Value(adm.signsSymptoms ?? ''), 
                         plan: drift.Value(adm.plan ?? ''),
                         sofaScore: drift.Value(adm.sofaScore),
                         apacheScore: drift.Value(adm.apacheScore),
                         nutricScore: drift.Value(adm.nutricScore),
                         sofaMortality: drift.Value(adm.sofaMortality),
                         apacheMortality: drift.Value(adm.apacheMortality),
                         uciPriority: drift.Value(adm.uciPriority),
                       ),
                       bedNumber: adm.bedNumber?.toString() ?? '-',
                       age: data.patient.age.toString(),
                       sex: data.patient.sex,
                       birthDate: '-', 
                       placeOfBirth: data.patient.placeOfBirth ?? '-',
                       insuranceType: data.patient.insuranceType ?? '-',
                       civilStatus: '-',
                       education: '-', 
                       religion: '-', 
                       occupation: data.patient.occupation ?? '-',
                       familyPhone: data.patient.phone ?? '-', 
                       responsibleFamily: data.patient.familyContact ?? '-',
                       familyAt: '-',
                       familyAf: '-',
                       uciPriority: adm.uciPriority ?? '-',
                       hospitalAdmissionDateTime: DateFormat('dd/MM/yyyy HH:mm').format(adm.admissionDate),
                       uciAdmissionDateTime: DateFormat('dd/MM/yyyy HH:mm').format(adm.admissionDate), 
                       vitals: vitalsMap,
                       signsSymptoms: adm.signsSymptoms ?? '-',
                       timeOfDisease: adm.timeOfDisease ?? '-',
                       illnessStart: adm.illnessStart ?? '-',
                       illnessCourse: adm.illnessCourse ?? '-',
                       story: adm.story ?? '-',
                       biolFunctions: {}, 
                       antecedents: {}, 
                       physicalExam: {'Examen': adm.physicalExam ?? '-'},
                       diagnosis: adm.diagnosis ?? '-',
                       sofaScore: (adm.sofaScore ?? 0).toString(),
                       apacheScore: (adm.apacheScore ?? 0).toString(),
                      nutricScore: (adm.nutricScore ?? 0).toString(),
                      plan: adm.plan ?? '-',
                      procedures: proceduresForPdf,
                      preparedByName: signers.preparedByName,
                      preparedByRole: signers.preparedByRole,
                      secondarySignatureName: signers.secondaryName,
                      secondarySignatureRole: signers.secondaryRole,
                    );
                  },
                  icon: const Icon(Icons.print, color: Colors.white),
                  label: const Text('Re-imprimir', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo.shade600,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
            ],
          ),
        ),
        _buildSectionCard(
          title: 'Enfermedad Actual',
          icon: Icons.sick_outlined,
          children: [
            _buildInfoRow('Síntomas:', adm.signsSymptoms ?? '-'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _buildInfoRow('Tiempo Enf:', adm.timeOfDisease ?? '-')),
                Expanded(child: _buildInfoRow('Inicio:', adm.illnessStart ?? '-')),
              ],
            ),
             const SizedBox(height: 8),
            _buildInfoRow('Curso:', adm.illnessCourse ?? '-'),
            const SizedBox(height: 8),
            _buildInfoRow('Relato:', adm.story ?? '-'),
          ],
        ),
        
        _buildSectionCard(
          title: 'Funciones Vitales (Ingreso)',
          icon: Icons.monitor_heart_outlined,
          children: [
             Builder(
               builder: (context) {
                 Map<String, dynamic> vitals = {};
                 if (adm.vitalsJson != null) {
                   try {
                     vitals = jsonDecode(adm.vitalsJson!) as Map<String, dynamic>;
                   } catch (_) {}
                 }
                 return Wrap(
                   spacing: 20,
                   runSpacing: 10,
                   children: [
                     _buildTag('PA', vitals['PA'] ?? '-'),
                     _buildTag('FC', vitals['FC'] ?? '-'),
                     _buildTag('FR', vitals['FR'] ?? '-'),
                     _buildTag('SatO2', '${vitals['SatO2'] ?? '-'}%'),
                     _buildTag('T°', '${vitals['T'] ?? '-'}°C'),
                   ],
                 );
               }
             )
          ],
        ),

        if (adm.physicalExam != null && adm.physicalExam!.isNotEmpty)
          _buildSectionCard(
            title: 'Examen Físico',
            icon: Icons.accessibility_new,
            children: [
              Text(adm.physicalExam ?? '', style: const TextStyle(fontSize: 14)),
            ],
          ),

        _buildSectionCard(
          title: 'Diagnósticos',
          icon: Icons.local_hospital,
          children: [
            Text(adm.diagnosis ?? '-', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          ],
        ),

        _buildSectionCard(
          title: 'Plan Terapéutico',
          icon: Icons.list_alt,
          children: [
            Text(adm.plan ?? '-', style: const TextStyle(fontSize: 14)),
          ],
        ),
        
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildSectionCard({required String title, required IconData icon, required List<Widget> children}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.indigo),
                const SizedBox(width: 8),
                Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo)),
              ],
            ),
            const Divider(height: 24),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
        Text(value, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  Widget _buildTag(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.indigo)),
        ],
      ),
    );
  }
}
