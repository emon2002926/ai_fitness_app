import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/util/screen_size.dart';
import '../../../core/widgets/avatar/avatar_display_widget.dart';
import '../../../core/widgets/app_bar/build_app_bar.dart';
import '../../../core/widgets/text/app_text.dart';
import '../controllers/levels_controller.dart';

// ─── Brand colours ──────────────────────────────────────────────────────────
const _kAccent = Color(0xFFF5A623);
const _kAccentDark = Color(0xFFD48B0F);
const _kCardBg = Color(0xFF1A1A1A);
const _kCompletedGreen = Color(0xFF4CAF50);

class LevelsScreen extends StatelessWidget {
  const LevelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<LevelsController>()
        ? Get.find<LevelsController>()
        : Get.put(LevelsController());

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: BuildAppBar(
        title: 'Levels',
        fontWeight: FontWeight.bold,
        showBackButton: false,
        showNotification: true,
        onNotificationPressed: controller.onNotificationPressed,
        avatarUrl: 'assets/images/avatar.png',
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value && !controller.hasLoadedOnce.value) {
            return const Center(
              child: CircularProgressIndicator(color: _kAccent),
            );
          }
          return Stack(
            children: [
              // ── Subtle radial gradient background ──
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment(0.6, -0.3),
                      radius: 1.2,
                      colors: [
                        Color(0xFF1C1500),
                        Colors.black,
                      ],
                    ),
                  ),
                ),
              ),

              // ── Background mascot — rounded, subtle ──
              Positioned(
                right: -context.w(20),
                bottom: context.h(100),
                child: Opacity(
                  opacity: 0.50,
                  child: ClipOval(
                    child: AvatarDisplayWidget(
                      width: context.w(260),
                      height: context.w(260),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              // ── Scrollable level content ──
              RefreshIndicator(
                color: _kAccent,
                backgroundColor: _kCardBg,
                onRefresh: controller.fetchLevelData,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: context.w(20),
                    vertical: context.h(20),
                  ),
                  child: Column(
                    children: [
                      _LevelProgressCard(controller: controller),
                      SizedBox(height: context.h(32)),
                      _LevelPath(controller: controller),
                      SizedBox(height: context.h(40)),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

// ─── Progress Card ──────────────────────────────────────────────────────────
class _LevelProgressCard extends StatelessWidget {
  final LevelsController controller;
  const _LevelProgressCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          padding: EdgeInsets.all(context.w(16)),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF2A1E00),
                Color(0xFF1A1A1A),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _kAccent.withOpacity(0.4),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: _kAccent.withOpacity(0.08),
                blurRadius: 20,
                spreadRadius: 0,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // ── Level badge ──
              Container(
                width: context.w(52),
                height: context.w(52),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [_kAccent, _kAccentDark],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: _kAccent.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: AppText(
                    data: '${controller.currentLevel.value}',
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(width: context.w(14)),

              // ── XP info ──
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      data: 'Level ${controller.currentLevel.value}',
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    SizedBox(height: context.h(8)),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: controller.xpProgress,
                        backgroundColor: Colors.white.withOpacity(0.08),
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(_kAccent),
                        minHeight: 8,
                      ),
                    ),
                    SizedBox(height: context.h(6)),
                    AppText(
                      data:
                          '${controller.currentXp.value} / ${controller.maxXp.value} XP',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white54,
                    ),
                  ],
                ),
              ),
              SizedBox(width: context.w(12)),

              // ── Rounded mascot avatar ──
              Container(
                width: context.w(56),
                height: context.w(56),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _kAccent.withOpacity(0.5),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _kAccent.withOpacity(0.15),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: ClipOval(
                  child: AvatarDisplayWidget(
                    width: context.w(56),
                    height: context.w(56),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

// ─── Level Path (snake / zigzag) ────────────────────────────────────────────
class _LevelPath extends StatelessWidget {
  final LevelsController controller;
  const _LevelPath({required this.controller});

  static const List<double> _xFractions = [
    0.55,
    0.30,
    0.20,
    0.25,
    0.40,
    0.55,
    0.70,
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final levels = controller.levels;
      if (levels.isEmpty) return const SizedBox.shrink();

      final screenWidth = MediaQuery.of(context).size.width - context.w(40);
      const rowHeight = 110.0;
      final totalHeight = levels.length * rowHeight + 20;

      final List<Offset> centers = List.generate(levels.length, (i) {
        return Offset(
          screenWidth * _xFractions[i],
          i * rowHeight + rowHeight / 2,
        );
      });

      return SizedBox(
        width: double.infinity,
        height: totalHeight,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // ── Dashed connecting path ──
            Positioned.fill(
              child: CustomPaint(
                painter: _CurvedPathPainter(centers: centers),
              ),
            ),
            // ── Level nodes ──
            ...List.generate(levels.length, (index) {
              final item = levels[index];
              final center = centers[index];

              final double nodeSize = item.state == LevelState.current
                  ? context.w(72)
                  : item.state == LevelState.completed
                      ? context.w(60)
                      : context.w(54);

              final bool labelOnRight = _xFractions[index] <= 0.5;

              Widget node = _LevelNode(item: item, size: nodeSize);

              Widget row = Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (!labelOnRight)
                    Padding(
                      padding: EdgeInsets.only(right: context.w(12)),
                      child: _levelLabel(item, context),
                    ),
                  node,
                  if (labelOnRight)
                    Padding(
                      padding: EdgeInsets.only(left: context.w(12)),
                      child: _levelLabel(item, context),
                    ),
                ],
              );

              return Positioned(
                left: center.dx - nodeSize / 2 - (labelOnRight ? 0 : 90),
                top: center.dy - nodeSize / 2,
                child: row,
              );
            }),
          ],
        ),
      );
    });
  }

  Widget _levelLabel(LevelItem item, BuildContext context) {
    final isActive = item.state != LevelState.locked;
    return AppText(
      data: 'Level ${item.level}',
      fontSize: 17,
      fontWeight: FontWeight.bold,
      color: isActive ? Colors.white : Colors.white30,
    );
  }
}

// ─── Dashed curved path painter ─────────────────────────────────────────────
class _CurvedPathPainter extends CustomPainter {
  final List<Offset> centers;
  const _CurvedPathPainter({required this.centers});

  @override
  void paint(Canvas canvas, Size size) {
    if (centers.length < 2) return;

    final paint = Paint()
      ..color = _kAccent.withOpacity(0.25)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    const nodeRadius = 36.0;

    for (int i = 0; i < centers.length - 1; i++) {
      final from = centers[i];
      final to = centers[i + 1];

      final dx = to.dx - from.dx;
      final dy = to.dy - from.dy;
      final dist = Offset(dx, dy).distance;
      final nx = dx / dist;
      final ny = dy / dist;

      final start =
          Offset(from.dx + nx * nodeRadius, from.dy + ny * nodeRadius);
      final end = Offset(to.dx - nx * nodeRadius, to.dy - ny * nodeRadius);

      final cp1 = Offset(start.dx, start.dy + (end.dy - start.dy) * 0.5);
      final cp2 = Offset(end.dx, start.dy + (end.dy - start.dy) * 0.5);

      path.moveTo(start.dx, start.dy);
      path.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, end.dx, end.dy);
    }

    _drawDashed(canvas, path, paint);
  }

  void _drawDashed(Canvas canvas, Path path, Paint paint,
      {double dash = 8, double gap = 6}) {
    for (final m in path.computeMetrics()) {
      double d = 0;
      bool drawing = true;
      while (d < m.length) {
        final len = drawing ? dash : gap;
        if (drawing) canvas.drawPath(m.extractPath(d, d + len), paint);
        d += len;
        drawing = !drawing;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _CurvedPathPainter old) =>
      old.centers != centers;
}

// ─── Individual level node ──────────────────────────────────────────────────
class _LevelNode extends StatelessWidget {
  final LevelItem item;
  final double size;
  const _LevelNode({required this.item, required this.size});

  @override
  Widget build(BuildContext context) {
    switch (item.state) {
      case LevelState.current:
        return _buildCurrentNode();
      case LevelState.completed:
        return _buildCompletedNode();
      case LevelState.locked:
        return _buildLockedNode();
    }
  }

  Widget _buildCurrentNode() {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_kAccent, _kAccentDark],
        ),
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(
            color: _kAccent.withOpacity(0.5),
            blurRadius: 18,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: _kAccent.withOpacity(0.25),
            blurRadius: 30,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Center(
        child: Image.asset(
          'assets/images/star_icon.png',
          width: size * 0.45,
          height: size * 0.45,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildCompletedNode() {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF66BB6A),
            Color(0xFF388E3C),
          ],
        ),
        border: Border.all(
          color: _kCompletedGreen.withOpacity(0.5),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: _kCompletedGreen.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Center(
        child: Icon(
          Icons.check_rounded,
          color: Colors.white,
          size: size * 0.45,
        ),
      ),
    );
  }

  Widget _buildLockedNode() {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF2A2A2A),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 2,
        ),
      ),
      child: Center(
        child: Icon(
          Icons.lock_rounded,
          color: Colors.white24,
          size: size * 0.38,
        ),
      ),
    );
  }
}