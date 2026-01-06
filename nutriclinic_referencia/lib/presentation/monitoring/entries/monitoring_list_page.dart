import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import 'package:nutrivigil/domain/monitoring/daily_monitoring_entry.dart';
import 'package:nutrivigil/presentation/monitoring/bloc/monitoring_bloc.dart';
import 'package:nutrivigil/presentation/widgets/empty_state.dart';
import 'package:nutrivigil/presentation/monitoring/entries/monitoring_entry_form_page.dart';

class MonitoringListPage extends StatelessWidget {
  const MonitoringListPage(
      {super.key, required this.patientId, required this.patientName});

  final String patientId;
  final String patientName;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Seguimiento: $patientName'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Registros'),
              Tab(text: 'Tendencias'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            BlocBuilder<MonitoringBloc, MonitoringState>(
              builder: (context, state) {
                switch (state.status) {
                  case MonitoringStatus.loading:
                    return const Center(child: CircularProgressIndicator());
                  case MonitoringStatus.failure:
                    return EmptyState(
                        message:
                            state.errorMessage ?? 'Error al cargar registros');
                  case MonitoringStatus.success:
                    if (state.entries.isEmpty) {
                      return const EmptyState(
                          message: 'Aún no hay registros diarios.');
                    }
                    return _MonitoringList(entries: state.entries);
                  case MonitoringStatus.initial:
                  default:
                    return const Center(child: CircularProgressIndicator());
                }
              },
            ),
            BlocBuilder<MonitoringBloc, MonitoringState>(
              builder: (context, state) {
                if (state.entries.isEmpty) {
                  return const EmptyState(
                      message: 'Sin datos suficientes para graficar.');
                }
                return _TrendCharts(entries: state.entries);
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: context.read<MonitoringBloc>(),
                  child: MonitoringEntryFormPage(patientId: patientId),
                ),
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class _MonitoringList extends StatelessWidget {
  const _MonitoringList({required this.entries});

  final List<DailyMonitoringEntry> entries;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: entries.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (_, index) {
        final entry = entries[index];
        final subtitle = <String?>[
          entry.caloricIntakeKcal != null
              ? 'Calorías: ${entry.caloricIntakeKcal!.toStringAsFixed(0)} kcal'
              : null,
          entry.proteinIntakeGrams != null
              ? 'Proteínas: ${entry.proteinIntakeGrams!.toStringAsFixed(1)} g'
              : null,
          entry.glucoseMax != null
              ? 'Glucosa max: ${entry.glucoseMax!.toStringAsFixed(1)}'
              : null,
        ].whereType<String>().join(' • ');

        return ListTile(
          title: Text(_formatDate(entry.date)),
          subtitle: Text(subtitle.isEmpty ? 'Sin datos principales' : subtitle),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}

class _TrendCharts extends StatelessWidget {
  const _TrendCharts({required this.entries});

  final List<DailyMonitoringEntry> entries;

  @override
  Widget build(BuildContext context) {
    final sorted = [...entries]..sort((a, b) => a.date.compareTo(b.date));
    return LayoutBuilder(
      builder: (context, constraints) {
        final charts = [
          _TrendChart(
            title: 'Ingesta',
            entries: sorted,
            series: [
              _TrendSeries(
                label: 'Calorías',
                color: const Color(0xFFF4511E),
                valueSelector: (entry) => entry.caloricIntakeKcal?.toDouble(),
              ),
              _TrendSeries(
                label: 'Proteínas',
                color: const Color(0xFF00897B),
                valueSelector: (entry) => entry.proteinIntakeGrams,
              ),
            ],
          ),
          _TrendChart(
            title: 'Peso',
            entries: sorted,
            series: [
              _TrendSeries(
                label: 'Peso',
                color: const Color(0xFF1E88E5),
                valueSelector: (entry) => entry.weightKg,
              ),
            ],
          ),
        ];

        const padding = EdgeInsets.all(16);
        const spacing = 16.0;
        final isWide = constraints.maxWidth >= 720;

        if (isWide) {
          final availableWidth =
              constraints.maxWidth - padding.horizontal - spacing;
          final itemWidth =
              (availableWidth / 2).clamp(280, constraints.maxWidth);
          return SingleChildScrollView(
            padding: padding,
            child: Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: charts
                  .map(
                    (chart) => SizedBox(
                      width: itemWidth.toDouble(),
                      child: chart,
                    ),
                  )
                  .toList(),
            ),
          );
        }

        return ListView.separated(
          padding: padding,
          itemBuilder: (context, index) => charts[index],
          separatorBuilder: (_, __) => const SizedBox(height: spacing),
          itemCount: charts.length,
        );
      },
    );
  }
}

class _TrendSeries {
  _TrendSeries({
    required this.label,
    required this.color,
    required this.valueSelector,
  });

  final String label;
  final Color color;
  final double? Function(DailyMonitoringEntry entry) valueSelector;
}

class _TrendChart extends StatelessWidget {
  const _TrendChart({
    required this.title,
    required this.entries,
    required this.series,
  });

  final String title;
  final List<DailyMonitoringEntry> entries;
  final List<_TrendSeries> series;

  @override
  Widget build(BuildContext context) {
    final dates = entries.map((e) => e.date).toList();
    final seriesSpots = series
        .map(
          (seriesData) => _buildSpots(entries, seriesData.valueSelector),
        )
        .toList();

    final hasData = seriesSpots.any((spots) => spots.isNotEmpty);
    if (!hasData) {
      return Card(
        child: Center(
          child: Text('Sin datos suficientes para $title.'),
        ),
      );
    }

    final minY = _findMinY(seriesSpots);
    final maxY = _findMaxY(seriesSpots);
    final range = maxY - minY;
    final padding =
        range == 0 ? (maxY == 0 ? 1.0 : maxY.abs() * 0.1) : range * 0.1;

    final chartData = LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.black.withOpacity(0.7),
          getTooltipItems: (touchedSpots) => touchedSpots.map((spot) {
            final index = spot.x.toInt();
            final formattedDate = _formatDate(dates[index]);
            return LineTooltipItem(
              '${series[spot.barIndex].label}\n$formattedDate\n${spot.y.toStringAsFixed(1)}',
              const TextStyle(color: Colors.white),
            );
          }).toList(),
        ),
      ),
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 48,
            getTitlesWidget: (value, meta) {
              return Text(value.toStringAsFixed(0),
                  style: const TextStyle(fontSize: 11));
            },
          ),
        ),
        rightTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (_, __) =>
                Text(title, style: Theme.of(context).textTheme.titleMedium),
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: (value, meta) {
              final index = value.toInt();
              if (index < 0 ||
                  index >= dates.length ||
                  (value - index).abs() > 0.01) {
                return const SizedBox.shrink();
              }
              final step = _bottomLabelStep(dates.length);
              if (index % step != 0 &&
                  index != dates.length - 1 &&
                  index != 0) {
                return const SizedBox.shrink();
              }
              return SideTitleWidget(
                axisSide: meta.axisSide,
                child: Text(
                  _formatDate(dates[index], pattern: 'dd/MM'),
                  style: const TextStyle(fontSize: 11),
                ),
              );
            },
          ),
        ),
      ),
      gridData: FlGridData(show: true, drawVerticalLine: false),
      borderData: FlBorderData(
        show: true,
        border: const Border(
          left: BorderSide(color: Colors.black12),
          bottom: BorderSide(color: Colors.black12),
          right: BorderSide(color: Colors.transparent),
          top: BorderSide(color: Colors.transparent),
        ),
      ),
      minX: 0,
      maxX: (dates.length - 1).toDouble(),
      minY: minY - padding,
      maxY: maxY + padding,
      lineBarsData: [
        for (var i = 0; i < series.length; i++)
          if (seriesSpots[i].isNotEmpty)
            LineChartBarData(
              spots: seriesSpots[i],
              isCurved: false,
              barWidth: 3,
              color: series[i].color,
              dotData: FlDotData(show: seriesSpots[i].length <= 10),
              belowBarData: BarAreaData(
                show: false,
              ),
            ),
      ],
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                for (final serie in series)
                  _LegendEntry(
                    label: serie.label,
                    color: serie.color,
                  ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 280,
              child: LineChart(chartData),
            ),
          ],
        ),
      ),
    );
  }

  List<FlSpot> _buildSpots(
    List<DailyMonitoringEntry> entries,
    double? Function(DailyMonitoringEntry) selector,
  ) {
    final spots = <FlSpot>[];
    for (var index = 0; index < entries.length; index++) {
      final value = selector(entries[index]);
      if (value != null) {
        spots.add(FlSpot(index.toDouble(), value));
      }
    }
    return spots;
  }

  double _findMinY(List<List<FlSpot>> seriesSpots) {
    final values =
        seriesSpots.expand((spots) => spots.map((spot) => spot.y)).toList();
    if (values.isEmpty) {
      return 0;
    }
    return values.reduce((a, b) => a < b ? a : b);
  }

  double _findMaxY(List<List<FlSpot>> seriesSpots) {
    final values =
        seriesSpots.expand((spots) => spots.map((spot) => spot.y)).toList();
    if (values.isEmpty) {
      return 0;
    }
    return values.reduce((a, b) => a > b ? a : b);
  }

  int _bottomLabelStep(int length) {
    if (length <= 4) {
      return 1;
    }
    if (length <= 8) {
      return 2;
    }
    return (length / 4).ceil();
  }

  String _formatDate(DateTime date, {String pattern = 'dd/MM/yyyy'}) {
    return DateFormat(pattern).format(date);
  }
}

class _LegendEntry extends StatelessWidget {
  const _LegendEntry({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          margin: const EdgeInsets.only(right: 6),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
