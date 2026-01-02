import 'package:flutter/material.dart';
import '../../ward_round/presentation/ward_round_screen.dart';
import '../../procedures/presentation/external_procedure_form.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // New Clean Blue Gradient - Visual Proof of Change
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('UCI MONITOR', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.0)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent, 
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.indigo.shade900.withOpacity(0.95), Colors.blue.shade900.withOpacity(0.95)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Procedimiento externo',
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () => _openExternalProcedureForm(context),
          ),
          IconButton(icon: const Icon(Icons.notifications_outlined), onPressed: () {}),
          const SizedBox(width: 8),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade50, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 1. Stats Header - ABSOLUTELY NO ISOLATION HERE
              _buildStatsHeader(),
              
              // 2. Bed Grid
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: GridView.builder(
                    padding: const EdgeInsets.only(bottom: 20, top: 20),
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 350,
                      childAspectRatio: 1.3,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: 13,
                    itemBuilder: (context, index) => BedCard(bedNumber: index + 1),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Row(
        children: [
          // ONLY 3 STATS
          _buildStatItem('OCUPACIÓN', '85%', Colors.blueGrey),
          _buildStatItem('CRÍTICOS', '4', Colors.red, isAlert: true),
          _buildStatItem('VENTILADOS', '6', Colors.blue),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color, {bool isAlert = false}) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
          ],
          border: isAlert ? Border.all(color: color.withOpacity(0.3), width: 1) : null,
        ),
        child: Column(
          children: [
            Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey.shade600, letterSpacing: 0.5)),
          ],
        ),
      ),
    );
  }
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
      const SnackBar(content: Text('Procedimiento registrado.')),
    );
  }
}

class BedCard extends StatelessWidget {
  final int bedNumber;
  const BedCard({super.key, required this.bedNumber});

  @override
  Widget build(BuildContext context) {
    // Mock Data
    final bool isOccupied = bedNumber % 3 != 0;
    final bool isCritical = bedNumber % 4 == 0;
    final bool isVentilated = isOccupied && bedNumber % 2 == 0;
    // NO ISOLATION VARIABLE

    return Card(
      elevation: 3,
      shadowColor: Colors.blueGrey.withOpacity(0.15), 
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isOccupied ? Colors.white : Colors.grey.shade100,
          border: Border.all(
             color: isOccupied ? Colors.blue.shade100 : Colors.grey.shade300, 
             width: 1
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (c) => WardRoundScreen(bedNumber: bedNumber)));
          },
          child: Stack(
            children: [
              // Big Watermark
              Positioned(
                right: -5,
                top: -5,
                child: Text(
                  '$bedNumber',
                  style: TextStyle(fontSize: 70, fontWeight: FontWeight.w900, color: Colors.grey.withOpacity(0.08)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Badges
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                         Container(
                           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                           decoration: BoxDecoration(
                             color: isOccupied ? const Color(0xFF0277BD) : Colors.grey.shade500,
                             borderRadius: BorderRadius.circular(6),
                           ),
                           child: Text(
                             'CAMA $bedNumber', 
                             style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)
                           ),
                         ),
                         
                         // ICONS ROW - NO ISOLATION
                         if (isOccupied)
                           Row(
                             children: [
                               if (isVentilated) const Padding(
                                 padding: EdgeInsets.only(left: 6),
                                 child: Icon(Icons.air, size: 20, color: Colors.blue),
                               ),
                               if (isCritical) const Padding(
                                 padding: EdgeInsets.only(left: 6),
                                 child: Icon(Icons.monitor_heart, size: 20, color: Colors.red),
                               ),
                             ],
                           )
                      ],
                    ),
                    const Spacer(),
                    
                    // Patient Info
                    if (isOccupied) ...[
                      const Text(
                        'PACIENTE A.B.C.',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                        maxLines: 1, overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Neumonía Grave - COVID', 
                        style: TextStyle(fontSize: 13, color: Colors.blueGrey.shade700, fontWeight: FontWeight.w500),
                        maxLines: 1, overflow: TextOverflow.ellipsis
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _buildDetailBadge(Icons.calendar_today, '5 días'),
                          const SizedBox(width: 8),
                          _buildDetailBadge(Icons.person, '58a'),
                        ],
                      ),
                    ] else ...[
                      Center(
                        child: Column(
                          children: [
                            Icon(Icons.hotel, size: 32, color: Colors.grey.shade300),
                            const SizedBox(height: 4),
                            Text('DISPONIBLE', style: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.bold, fontSize: 12)),
                          ],
                        ),
                      )
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailBadge(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.grey.shade600),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade700, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
