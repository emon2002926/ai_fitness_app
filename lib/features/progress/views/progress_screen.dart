import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../core/util/screen_size.dart';
import '../../../core/widgets/app_bar/build_app_bar.dart';
import '../../../core/widgets/text/app_text.dart';
import 'package:get/get.dart';

import '../controllers/progress_controller.dart';


class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProgressController());

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: BuildAppBar(
        title: 'Progress',
        showBackButton: false,
        showNotification: true,
        onNotificationPressed: controller.onNotificationPressed,

        avatarUrl: 'assets/images/avatar.png',

      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: context.w(20),
            vertical: context.h(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _StatsRow(controller: controller),
              SizedBox(height: context.h(28)),
              _WeeklySection(controller: controller),
              SizedBox(height: context.h(28)),
              _WeightProgressSection(controller: controller),
              SizedBox(height: context.h(28)),
              _WeightSummaryCard(controller: controller),
              SizedBox(height: context.h(40)),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Stats Row ────────────────────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  final ProgressController controller;
  const _StatsRow({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            emoji: '🔥',
            value: '${controller.dayStreak}',
            label: 'Day Streak',
          ),
        ),
        SizedBox(width: context.w(12)),
        Expanded(
          child: _StatCard(
            emoji: '⚡',
            value: '${controller.mealsLogged}',
            label: 'Meals Logged',
          ),
        ),
        SizedBox(width: context.w(12)),
        Expanded(
          child: _StatCard(
            emoji: '🏆',
            value: '+${controller.kgGained.toStringAsFixed(2)}',
            label: 'Kg Gained',
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String emoji;
  final String value;
  final String label;

  const _StatCard({
    required this.emoji,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.w(12),
        vertical: context.h(14),
      ),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white24, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 22)),
          SizedBox(height: context.h(8)),
          AppText(
            data: value,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          SizedBox(height: context.h(4)),
          AppText(
            data: label,
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Colors.white54,
          ),
        ],
      ),
    );
  }
}


class _WeeklySection extends StatefulWidget {
  final ProgressController controller;
  const _WeeklySection({required this.controller});

  @override
  State<_WeeklySection> createState() => _WeeklySectionState();
}

class _WeeklySectionState extends State<_WeeklySection> {
  late int _touchedIndex;

  @override
  void initState() {
    super.initState();
    _touchedIndex = widget.controller.selectedDayIndex;
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.controller.weeklyData;
    final touched = data[_touchedIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          data: 'This Week',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        SizedBox(height: context.h(16)),
        SizedBox(
          height: context.h(260),
          child: LineChart(
            LineChartData(
              minX: 0,
              maxX: 6,
              minY: 0,
              maxY: 2500,
              clipData: const FlClipData.all(),
              backgroundColor: Colors.transparent,
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: 500,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: Colors.white12,
                  strokeWidth: 1,
                  dashArray: [4, 4],
                ),
              ),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 500,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      if (value == 0 || value == 2500) {
                        return AppText(
                          data: value.toInt().toString(),
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: Colors.white70,
                        );
                      }
                      if (value % 500 == 0) {
                        return AppText(
                          data: value.toInt().toString(),
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: Colors.white70,
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 32,
                    getTitlesWidget: (value, meta) {
                      final idx = value.toInt();
                      if (idx < 0 || idx >= data.length) {
                        return const SizedBox.shrink();
                      }
                      final isSelected = idx == _touchedIndex;
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: isSelected
                            ? Container(
                          width: 28,
                          height: 28,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF5A623),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: AppText(
                              data: data[idx].day,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        )
                            : AppText(
                          data: data[idx].day,
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: Colors.white54,
                        ),
                      );
                    },
                  ),
                ),
              ),
              lineTouchData: LineTouchData(
                enabled: true,
                touchCallback: (event, response) {
                  if (response != null &&
                      response.lineBarSpots != null &&
                      response.lineBarSpots!.isNotEmpty) {
                    setState(() {
                      _touchedIndex =
                          response.lineBarSpots!.first.x.toInt();
                    });
                  }
                },
                touchTooltipData: LineTouchTooltipData(
                  getTooltipColor: (_) => const Color(0xFFF5A623),
                  tooltipRoundedRadius: 8,
                  tooltipPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  getTooltipItems: (spots) {
                    return spots.map((spot) {
                      final idx = spot.x.toInt();
                      final d = data[idx];
                      return LineTooltipItem(
                        'Fat     ${d.fat.toInt()}g\nCarbs  ${d.carbs.toInt()}g\nProtein ${d.protein.toInt()}g',
                        const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          height: 1.6,
                        ),
                      );
                    }).toList();
                  },
                ),
                getTouchedSpotIndicator: (barData, spotIndexes) {
                  return spotIndexes.map((idx) {
                    return TouchedSpotIndicatorData(
                      FlLine(color: Colors.transparent),
                      FlDotData(
                        getDotPainter: (spot, percent, bar, index) =>
                            FlDotCirclePainter(
                              radius: 6,
                              color: Colors.white,
                              strokeWidth: 2,
                              strokeColor: const Color(0xFFF5A623),
                            ),
                      ),
                    );
                  }).toList();
                },
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: List.generate(
                    data.length,
                        (i) => FlSpot(i.toDouble(), data[i].calories),
                  ),
                  isCurved: true,
                  curveSmoothness: 0.35,
                  color: const Color(0xFFF5A623),
                  barWidth: 2.5,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color(0xFFF5A623).withOpacity(0.45),
                        const Color(0xFFF5A623).withOpacity(0.05),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}


class _WeightProgressSection extends StatelessWidget {
  final ProgressController controller;
  const _WeightProgressSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText(
              data: 'Weight Progress',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            GestureDetector(
              onTap: controller.onUpdateWeight,
              child: AppText(
                data: 'Update',
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFF5A623),
              ),
            ),
          ],
        ),
        SizedBox(height: context.h(16)),
        _WeightChartCard(controller: controller),
      ],
    );
  }
}

class _WeightChartCard extends StatelessWidget {
  final ProgressController controller;
  const _WeightChartCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    final history = controller.weightHistory;
    final goal = controller.weightGoal;

    // Combine history + goal for x-axis mapping
    final allEntries = [...history, goal];
    final minDate = allEntries.first.date.millisecondsSinceEpoch.toDouble();
    final maxDate = allEntries.last.date.millisecondsSinceEpoch.toDouble();

    double dateToX(DateTime d) =>
        (d.millisecondsSinceEpoch.toDouble() - minDate) /
            (maxDate - minDate) *
            6.0;

    final historySpots = history
        .map((e) => FlSpot(dateToX(e.date), e.weight))
        .toList();

    // Dashed goal line from last history point to goal
    final lastHistory = history.last;
    final goalSpots = [
      FlSpot(dateToX(lastHistory.date), lastHistory.weight),
      FlSpot(dateToX(goal.date), goal.weight),
    ];

    final minY = 55.0;
    final maxY = 80.0;

    return Container(
      padding: EdgeInsets.all(context.w(16)),
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Current weight + badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    data: 'Current Weight',
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Colors.white54,
                  ),
                  SizedBox(height: context.h(4)),
                  AppText(
                    data: '${controller.currentWeight} kg',
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: context.w(16),
                  vertical: context.h(10),
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5A623),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: AppText(
                  data: '+ ${controller.weightGainBadge.toInt()} kg',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: context.h(16)),

          // Chart
          LayoutBuilder(
            builder: (context, constraints) {
              final availableWidth = constraints.maxWidth;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: context.h(220),
                    child: LineChart(
                      LineChartData(
                        minX: 0,
                        maxX: 6,
                        minY: minY,
                        maxY: maxY,
                        clipData: const FlClipData.all(),
                        backgroundColor: Colors.transparent,
                        gridData: FlGridData(
                          show: true,
                          drawHorizontalLine: false,
                          drawVerticalLine: true,
                          verticalInterval: 1,
                          getDrawingVerticalLine: (value) {
                            final snapped = value.round().toDouble();
                            if ((value - snapped).abs() < 0.01 &&
                                snapped >= 0 &&
                                snapped <= 6) {
                              return FlLine(
                                color: Colors.white12,
                                strokeWidth: 1,
                              );
                            }
                            return FlLine(color: Colors.transparent, strokeWidth: 0);
                          },
                        ),
                        borderData: FlBorderData(show: false),
                        titlesData: const FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          // Completely removed from fl_chart to avoid clipping
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        lineTouchData: const LineTouchData(enabled: false),
                        lineBarsData: [
                          // Actual weight history (solid curve)
                          LineChartBarData(
                            spots: historySpots,
                            isCurved: true,
                            curveSmoothness: 0.4,
                            color: const Color(0xFFF5A623),
                            barWidth: 2.5,
                            isStrokeCapRound: true,
                            dotData: FlDotData(
                              show: true,
                              getDotPainter: (spot, percent, bar, index) {
                                if (index == 0) {
                                  return FlDotCirclePainter(
                                    radius: 5,
                                    color: Colors.white,
                                    strokeWidth: 1.5,
                                    strokeColor: Colors.white54,
                                  );
                                }
                                return FlDotCirclePainter(
                                  radius: 0,
                                  color: Colors.transparent,
                                  strokeWidth: 0,
                                  strokeColor: Colors.transparent,
                                );
                              },
                            ),
                            belowBarData: BarAreaData(
                              show: true,
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  const Color(0xFFF5A623).withOpacity(0.3),
                                  const Color(0xFFF5A623).withOpacity(0.02),
                                ],
                              ),
                            ),
                          ),
                          // Goal line (dashed)
                          LineChartBarData(
                            spots: goalSpots,
                            isCurved: false,
                            color: const Color(0xFFF5A623).withOpacity(0.6),
                            barWidth: 2,
                            isStrokeCapRound: true,
                            dashArray: [6, 5],
                            dotData: FlDotData(
                              show: true,
                              getDotPainter: (spot, percent, bar, index) {
                                if (index == 1) {
                                  return FlDotCirclePainter(
                                    radius: 5,
                                    color: Colors.white,
                                    strokeWidth: 1.5,
                                    strokeColor: Colors.white54,
                                  );
                                }
                                return FlDotCirclePainter(
                                  radius: 0,
                                  color: Colors.transparent,
                                  strokeWidth: 0,
                                  strokeColor: Colors.transparent,
                                );
                              },
                            ),
                            belowBarData: BarAreaData(
                              show: true,
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  const Color(0xFFF5A623).withOpacity(0.15),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      duration: Duration.zero,
                    ),
                  ),

                  // ── Date labels rendered OUTSIDE fl_chart so they never get clipped ──
                  SizedBox(height: context.h(6)),
                  SizedBox(
                    width: availableWidth,
                    height: 16,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // "1 March 2022" — pinned to left edge
                        const Positioned(
                          left: 0,
                          child: AppText(
                            data: '1 March 2022',
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            color: Colors.white54,
                          ),
                        ),
                        // "18 July 2026" — centered
                        Positioned(
                          left: availableWidth / 2 - 38,
                          child: const AppText(
                            data: '18 July 2026',
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            color: Colors.white54,
                          ),
                        ),
                        // "Today" — pinned to right edge
                        const Positioned(
                          right: 0,
                          child: AppText(
                            data: 'Today',
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            color: Colors.white54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),

        ],
      ),
    );
  }
}


class _WeightChartCardV2 extends StatelessWidget {
  final ProgressController controller;
  const _WeightChartCardV2({required this.controller});

  @override
  Widget build(BuildContext context) {
    final history = controller.weightHistory;
    final goal = controller.weightGoal;
    final allEntries = [...history, goal];

    final minDate = allEntries.first.date.millisecondsSinceEpoch.toDouble();
    final maxDate = allEntries.last.date.millisecondsSinceEpoch.toDouble();
    const double minY = 55.0;
    const double maxY = 80.0;
    const double chartHeight = 200.0;
    const double chartWidth = 1.0; // relative

    double dateToX(DateTime d) =>
        (d.millisecondsSinceEpoch.toDouble() - minDate) /
            (maxDate - minDate) *
            6.0;

    double yToFraction(double y) => 1.0 - (y - minY) / (maxY - minY);

    final historySpots = history
        .map((e) => FlSpot(dateToX(e.date), e.weight))
        .toList();

    final lastHistory = history.last;
    final goalSpots = [
      FlSpot(dateToX(lastHistory.date), lastHistory.weight),
      FlSpot(dateToX(goal.date), goal.weight),
    ];

    // Weight label data: [x fraction 0-1, y fraction 0-1, label]
    final weightLabels = [
      (dateToX(history[0].date) / 6.0, yToFraction(history[0].weight),
      '${history[0].weight.toInt()} kg'),
      (dateToX(history[3].date) / 6.0, yToFraction(history[3].weight),
      '${history[3].weight.toInt()} kg'),
      (dateToX(goal.date) / 6.0, yToFraction(goal.weight),
      '${goal.weight.toInt()} kg'),
    ];

    return Container(
      padding: EdgeInsets.all(context.w(16)),
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    data: 'Current Weight',
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Colors.white54,
                  ),
                  SizedBox(height: context.h(4)),
                  AppText(
                    data: '${controller.currentWeight} kg',
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: context.w(16),
                  vertical: context.h(10),
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5A623),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: AppText(
                  data: '+ ${controller.weightGainBadge.toInt()} kg',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: context.h(16)),
          LayoutBuilder(
            builder: (context, constraints) {
              final availableWidth = constraints.maxWidth;
              // Chart area: left padding ~0, right padding ~0 (fl_chart manages)
              const leftPad = 0.0;
              const rightPad = 0.0;
              final chartAreaWidth = availableWidth - leftPad - rightPad;
              const bottomAxisHeight = 28.0;

              return SizedBox(
                height: chartHeight + bottomAxisHeight + 20,
                child: Stack(
                  children: [
                    // fl_chart
                    Positioned.fill(
                      child: LineChart(
                        LineChartData(
                          minX: 0,
                          maxX: 6,
                          minY: minY,
                          maxY: maxY,
                          clipData: const FlClipData.all(),
                          gridData: FlGridData(
                            show: true,
                            drawHorizontalLine: false,
                            drawVerticalLine: true,
                            verticalInterval: 1,
                            getDrawingVerticalLine: (_) => FlLine(
                              color: Colors.white10,
                              strokeWidth: 1,
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          titlesData: FlTitlesData(
                            leftTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: bottomAxisHeight,
                                getTitlesWidget: (value, meta) {
                                  final labels = {
                                    0.0: '1 March 2022',
                                    3.0: '18 July 2026',
                                    6.0: 'Today',
                                  };
                                  final lbl = labels[value];
                                  if (lbl == null) {
                                    return const SizedBox.shrink();
                                  }
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: AppText(
                                      data: lbl,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white38,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          lineTouchData: const LineTouchData(enabled: false),
                          lineBarsData: [
                            LineChartBarData(
                              spots: historySpots,
                              isCurved: true,
                              curveSmoothness: 0.4,
                              color: const Color(0xFFF5A623),
                              barWidth: 2.5,
                              isStrokeCapRound: true,
                              dotData: FlDotData(
                                show: true,
                                getDotPainter: (spot, percent, bar, index) {
                                  if (index == 0) {
                                    return FlDotCirclePainter(
                                      radius: 5,
                                      color: Colors.white,
                                      strokeWidth: 1.5,
                                      strokeColor: Colors.white54,
                                    );
                                  }
                                  if (index == historySpots.length - 1) {
                                    return FlDotCirclePainter(
                                      radius: 5,
                                      color: Colors.white,
                                      strokeWidth: 1.5,
                                      strokeColor: const Color(0xFFF5A623),
                                    );
                                  }
                                  return FlDotCirclePainter(
                                    radius: 0,
                                    color: Colors.transparent,
                                    strokeWidth: 0,
                                    strokeColor: Colors.transparent,
                                  );
                                },
                              ),
                              belowBarData: BarAreaData(
                                show: true,
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    const Color(0xFFF5A623).withOpacity(0.3),
                                    const Color(0xFFF5A623).withOpacity(0.02),
                                  ],
                                ),
                              ),
                            ),
                            LineChartBarData(
                              spots: goalSpots,
                              isCurved: false,
                              color: const Color(0xFFF5A623).withOpacity(0.55),
                              barWidth: 2,
                              dashArray: [6, 5],
                              dotData: FlDotData(
                                show: true,
                                getDotPainter: (spot, percent, bar, index) {
                                  if (index == 1) {
                                    return FlDotCirclePainter(
                                      radius: 5,
                                      color: Colors.white,
                                      strokeWidth: 1.5,
                                      strokeColor: Colors.white54,
                                    );
                                  }
                                  return FlDotCirclePainter(
                                    radius: 0,
                                    color: Colors.transparent,
                                    strokeWidth: 0,
                                    strokeColor: Colors.transparent,
                                  );
                                },
                              ),
                              belowBarData: BarAreaData(
                                show: true,
                                color:
                                const Color(0xFFF5A623).withOpacity(0.08),
                              ),
                            ),
                          ],
                        ),
                        duration: Duration.zero,
                      ),
                    ),

                    // Overlaid weight labels (badges)
                    ...weightLabels.map((lbl) {
                      final xFrac = lbl.$1;
                      final yFrac = lbl.$2;
                      final text = lbl.$3;

                      // fl_chart adds ~8px left/right padding internally
                      const flPad = 8.0;
                      final px = leftPad +
                          flPad +
                          xFrac * (chartAreaWidth - flPad * 2);
                      final py = yFrac * chartHeight;

                      return Positioned(
                        left: px - 28,
                        top: py - 28,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5A623),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: AppText(
                            data: text,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ─── Weight Summary Card ──────────────────────────────────────────────────────

class _WeightSummaryCard extends StatelessWidget {
  final ProgressController controller;
  const _WeightSummaryCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.w(20),
        vertical: context.h(18),
      ),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFFE5E7EB), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            data: 'Weight Progress',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.white54,
          ),
          SizedBox(height: context.h(16)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _WeightSummaryItem(
                value: '+${controller.gain3Days} kg',
                label: '3 days',
              ),
              _WeightSummaryItem(
                value: '+${controller.gain7Days} kg',
                label: '7 days',
              ),
              _WeightSummaryItem(
                value:
                '+${controller.gain30Days.toStringAsFixed(2)} kg',
                label: '30 days',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WeightSummaryItem extends StatelessWidget {
  final String value;
  final String label;

  const _WeightSummaryItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          data: value,
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: const Color(0xFFF5A623),
        ),
        SizedBox(height: context.h(4)),
        AppText(
          data: label,
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: Colors.white54,
        ),
      ],
    );
  }
}