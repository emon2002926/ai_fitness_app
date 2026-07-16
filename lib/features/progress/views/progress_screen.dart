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
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFF5A623)),
            );
          }
          return SingleChildScrollView(
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
          );
        }),
      ),
    );
  }
}


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
            value: '${controller.dayStreak.value}',
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
    _touchedIndex = widget.controller.selectedDayIndex.value;
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.controller.weeklyData;

    if (data.isEmpty) {
      return AppText(
        data: 'No weekly data yet',
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Colors.white54,
      );
    }

    _touchedIndex = _touchedIndex.clamp(0, data.length - 1);

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

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  String _formatDate(DateTime d) => '${d.day} ${_months[d.month - 1]} ${d.year}';

  @override
  Widget build(BuildContext context) {
    final history = controller.weightHistory;
    final goal = controller.weightGoal.value;

    if (history.isEmpty) {
      return Container(
        padding: EdgeInsets.all(context.w(16)),
        decoration: BoxDecoration(
          color: const Color(0xFF111111),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white12, width: 1),
        ),
        child: AppText(
          data: 'No weight entries yet',
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Colors.white54,
        ),
      );
    }

    // Combine history + goal (if any) for x-axis mapping
    final allEntries = goal != null ? [...history, goal] : history;
    final minDate = allEntries.first.date.millisecondsSinceEpoch.toDouble();
    final maxDate = allEntries.last.date.millisecondsSinceEpoch.toDouble();
    final dateSpan = maxDate == minDate ? 1.0 : maxDate - minDate;

    double dateToX(DateTime d) =>
        (d.millisecondsSinceEpoch.toDouble() - minDate) / dateSpan * 6.0;

    final historySpots = history
        .map((e) => FlSpot(dateToX(e.date), e.weight))
        .toList();

    // Dashed goal line from last history point to goal (only when a goal exists)
    final lastHistory = history.last;
    final goalSpots = goal != null
        ? [
            FlSpot(dateToX(lastHistory.date), lastHistory.weight),
            FlSpot(dateToX(goal.date), goal.weight),
          ]
        : const <FlSpot>[];

    final weights = [
      ...history.map((e) => e.weight),
      if (goal != null) goal.weight,
    ];
    final minY = (weights.reduce((a, b) => a < b ? a : b) - 5).floorToDouble();
    final maxY = (weights.reduce((a, b) => a > b ? a : b) + 5).ceilToDouble();

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
                    data: '${controller.currentWeight.value} kg',
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
                  data:
                      '${controller.weightGainBadge.value >= 0 ? '+' : ''}${controller.weightGainBadge.value.toInt()} kg',
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
                          // Goal line (dashed) — only rendered when a goal is set
                          if (goalSpots.isNotEmpty)
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
                        // First recorded date — pinned to left edge
                        Positioned(
                          left: 0,
                          child: AppText(
                            data: _formatDate(allEntries.first.date),
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            color: Colors.white54,
                          ),
                        ),
                        // Midpoint date — centered
                        Positioned(
                          left: availableWidth / 2 - 38,
                          child: AppText(
                            data: _formatDate(DateTime.fromMillisecondsSinceEpoch(
                              ((minDate + maxDate) / 2).round(),
                            )),
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            color: Colors.white54,
                          ),
                        ),
                        // "Goal" if a goal is set, otherwise "Today" — pinned to right edge
                        Positioned(
                          right: 0,
                          child: AppText(
                            data: goal != null ? 'Goal' : 'Today',
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


class _WeightSummaryCard extends StatelessWidget {
  final ProgressController controller;
  const _WeightSummaryCard({required this.controller});

  String _signed(double value) =>
      '${value >= 0 ? '+' : ''}${value.toStringAsFixed(2)}';

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
                value: '${_signed(controller.gain3Days.value)} kg',
                label: '3 days',
              ),
              _WeightSummaryItem(
                value: '${_signed(controller.gain7Days.value)} kg',
                label: '7 days',
              ),
              _WeightSummaryItem(
                value: '${_signed(controller.gain30Days.value)} kg',
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