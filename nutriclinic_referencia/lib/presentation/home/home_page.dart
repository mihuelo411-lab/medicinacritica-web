import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:nutrivigil/core/routes/app_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final actions = _actionItems(context);
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        title: const Text('NutriVigil'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _HomeHeroCard(),
              const SizedBox(height: 32),
              Text(
                'Accesos rápidos',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onBackground,
                ),
              ),
              const SizedBox(height: 16),
              ...actions.map(
                (action) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _HomeActionTile(item: action),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<_ActionItem> _actionItems(BuildContext context) {
    return [
      _ActionItem(
        title: 'Evaluación inicial',
        subtitle: 'Registra un nuevo episodio y define objetivos.',
        icon: CupertinoIcons.person_crop_circle_badge_plus,
        accent: const Color(0xFF2563EB),
        onTap: () => Navigator.of(context).pushNamed(AppRouter.patientForm),
      ),
      _ActionItem(
        title: 'Historial',
        subtitle: 'Consulta evaluaciones previas y reimprime PDFs.',
        icon: CupertinoIcons.doc_plaintext,
        accent: const Color(0xFF0EA5E9),
        onTap: () => Navigator.of(context).pushNamed(AppRouter.reports),
      ),
      _ActionItem(
        title: 'Seguimiento Nutricional',
        subtitle: 'Gestiona reevaluaciones y evolución (2ª, 3ª...)',
        icon: CupertinoIcons.arrow_right_arrow_left_circle_fill, // Evolution icon
        accent: const Color(0xFF10B981),
        onTap: () => Navigator.of(context).pushNamed(AppRouter.followUp),
      ),
      _ActionItem(
        title: 'Calculadoras',
        subtitle: 'Fórmulas y herramientas de soporte clínico.',
        icon: CupertinoIcons.lab_flask_solid,
        accent: const Color(0xFF7C3AED),
        onTap: () => Navigator.of(context).pushNamed(AppRouter.calculators),
      ),
    ];
  }
}

class _HomeHeroCard extends StatelessWidget {
  const _HomeHeroCard();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0F172A),
            Color(0xFF1D4ED8),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 30,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Text(
              'Gestión clínica',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.4,
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'Coordina cada evaluación con precisión.',
            style: textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Monitorea, ajusta y documenta la terapia nutricional desde un solo lugar.',
            style: textTheme.bodyLarge?.copyWith(
              color: Colors.white.withOpacity(0.85),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Icon(
                CupertinoIcons.shield_lefthalf_fill,
                color: colorScheme.secondary,
              ),
              const SizedBox(width: 8),
              Text(
                'Protocolos alineados a la evidencia',
                style: textTheme.bodyMedium?.copyWith(color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HomeActionTile extends StatelessWidget {
  const _HomeActionTile({required this.item});

  final _ActionItem item;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final surfaceColor = colorScheme.surface;

    return InkWell(
      borderRadius: BorderRadius.circular(28),
      onTap: item.onTap,
      child: Ink(
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.black12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: item.accent.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(item.icon, color: item.accent, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.subtitle,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.65),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              CupertinoIcons.chevron_right,
              size: 18,
              color: Colors.black26,
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionItem {
  const _ActionItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accent,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color accent;
  final VoidCallback onTap;
}
