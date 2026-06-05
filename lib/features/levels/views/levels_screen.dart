import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_assert_image.dart';
import '../../../core/util/screen_size.dart';
import '../../../core/widgets/app_bar/build_app_bar.dart';
import '../../../core/widgets/text/app_text.dart';
import '../controllers/levels_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum LevelState { completed, current, locked }

class LevelItem {
  final int level;
  final LevelState state;
  final bool hasMascot;

  const LevelItem({
    required this.level,
    required this.state,
    this.hasMascot = false,
  });
}

class LevelsController extends GetxController {
  final avatarUrl = ''.obs;

  final int currentLevel = 12;
  final int currentXp = 8450;
  final int maxXp = 12000;

  double get xpProgress => currentXp / maxXp;

  final List<LevelItem> levels = const [
    LevelItem(level: 10, state: LevelState.completed),
    LevelItem(level: 11, state: LevelState.completed),
    LevelItem(level: 12, state: LevelState.current, hasMascot: true),
    LevelItem(level: 13, state: LevelState.locked),
    LevelItem(level: 14, state: LevelState.locked),
    LevelItem(level: 15, state: LevelState.locked),
    LevelItem(level: 16, state: LevelState.locked),
  ];

  void onNotificationPressed() {}
  void onAvatarPressed() {}
}

class LevelsScreen extends StatelessWidget {
  const LevelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LevelsController());

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
        child: SingleChildScrollView(
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
    );
  }
}

class _LevelProgressCard extends StatelessWidget {
  final LevelsController controller;

  const _LevelProgressCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.w(16)),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white70, width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: context.w(48),
            height: context.w(48),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFF5A623), width: 1.5),
            ),
            child: Center(
              child: AppText(
                data: '${controller.currentLevel}',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFF5A623),
              ),
            ),
          ),
          SizedBox(width: context.w(14)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  data: 'Level ${controller.currentLevel}',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                SizedBox(height: context.h(8)),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: controller.xpProgress,
                    backgroundColor: Colors.white12,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFFF5A623)),
                    minHeight: 6,
                  ),
                ),
                SizedBox(height: context.h(6)),
                AppText(
                  data: '${controller.currentXp} / ${controller.maxXp} XP',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.white54,
                ),
              ],
            ),
          ),
          SizedBox(width: context.w(12)),
          Image.asset(
            AppAssertImage.instance.lionLogo,
            width: context.w(56),
            height: context.w(56),
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}

class _LevelPath extends StatelessWidget {
  final LevelsController controller;

  const _LevelPath({required this.controller});

  // X fractions matching the diagonal curve in the screenshot
  static const List<double> _xFractions = [
    0.55, // Level 10 - center-right
    0.30, // Level 11 - left
    0.20, // Level 12 - far left (current)
    0.25, // Level 13 - left
    0.40, // Level 14 - center-left
    0.55, // Level 15 - center-right
    0.70, // Level 16 - right
  ];

  @override
  Widget build(BuildContext context) {
    final levels = controller.levels;
    final screenWidth = MediaQuery.of(context).size.width - context.w(40);
    const rowHeight = 100.0;
    final totalHeight = levels.length * rowHeight + 20;

    // Precompute centers
    List<Offset> centers = List.generate(levels.length, (i) {
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
          // Dashed curved path
          Positioned.fill(
            child: CustomPaint(
              painter: _CurvedPathPainter(centers: centers),
            ),
          ),
          // Nodes + labels
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

            if (item.hasMascot) {
              node = Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  node,
                  SizedBox(width: context.w(12)),

                  Padding(
                    padding: EdgeInsets.only(right: context.w(10)),
                    child: _levelLabel(item, context),
                  ),
                  SizedBox(width: context.w(16)),
                  Image.asset(
                    AppAssertImage.instance.lionLogo,
                    width: context.w(100),
                    height: context.w(100),
                    fit: BoxFit.contain,
                  ),
                ],
              );
            }

            Widget row = Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (!labelOnRight && !item.hasMascot)
                  Padding(
                    padding: EdgeInsets.only(right: context.w(10)),
                    child: _levelLabel(item, context),
                  ),
                node,
                if (labelOnRight && !item.hasMascot)
                  Padding(
                    padding: EdgeInsets.only(left: context.w(10)),
                    child: _levelLabel(item, context),
                  ),
              ],
            );

            // Estimate row width for positioning
            // Place so the NODE CENTER aligns to `center`
            return Positioned(
              left: center.dx - nodeSize / 2 - (labelOnRight ? 0 : 90),
              top: center.dy - nodeSize / 2,
              child: row,
            );
          }),
        ],
      ),
    );
  }

  Widget _levelLabel(LevelItem item, BuildContext context) {
    return AppText(
      data: 'Level ${item.level}',
      fontSize: 17,
      fontWeight: FontWeight.bold,
      color: item.state == LevelState.locked ? Colors.white38 : Colors.white,
    );
  }
}

class _CurvedPathPainter extends CustomPainter {
  final List<Offset> centers;

  const _CurvedPathPainter({required this.centers});

  @override
  void paint(Canvas canvas, Size size) {
    if (centers.length < 2) return;

    final paint = Paint()
      ..color =  Colors.transparent
      ..strokeWidth = 3.5
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

      // Trim to node edge
      final start = Offset(from.dx + nx * nodeRadius, from.dy + ny * nodeRadius);
      final end = Offset(to.dx - nx * nodeRadius, to.dy - ny * nodeRadius);

      // Smooth cubic bezier — control points pulled vertically
      final cp1 = Offset(start.dx, start.dy + (end.dy - start.dy) * 0.5);
      final cp2 = Offset(end.dx, start.dy + (end.dy - start.dy) * 0.5);

      path.moveTo(start.dx, start.dy);
      path.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, end.dx, end.dy);
    }

    _drawDashed(canvas, path, paint);
  }

  void _drawDashed(Canvas canvas, Path path, Paint paint,
      {double dash = 9, double gap = 7}) {
    for (final m in path.computeMetrics()) {
      double d = 0;
      bool drawing = true;
      while (d < m.length) {
        final len = drawing ? dash : gap;
        if (drawing) {
          canvas.drawPath(m.extractPath(d, d + len), paint);
        }
        d += len;
        drawing = !drawing;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _CurvedPathPainter old) =>
      old.centers != centers;
}
enum _ZigzagPosition { left, center, right }

class _LevelRow extends StatelessWidget {
  final LevelItem item;
  final _ZigzagPosition position;
  final bool isLast;

  const _LevelRow({
    required this.item,
    required this.position,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final nodeSize = item.state == LevelState.current
        ? context.w(88)
        : item.state == LevelState.completed
        ? context.w(76)
        : context.w(68);

    Widget node = _LevelNode(item: item, size: nodeSize);

    if (item.hasMascot) {
      node = Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          node,
          SizedBox(width: context.w(8)),
          Image.asset(
            AppAssertImage.instance.lionLogo,
            width: context.w(90),
            height: context.w(110),
            fit: BoxFit.contain,
          ),
        ],
      );
    }

    AlignmentGeometry alignment;
    switch (position) {
      case _ZigzagPosition.left:
        alignment = Alignment.centerLeft;
      case _ZigzagPosition.right:
        alignment = Alignment.centerRight;
      case _ZigzagPosition.center:
        alignment = Alignment.center;
    }

    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : context.h(28)),
      child: Align(
        alignment: alignment,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            node,
            SizedBox(width: context.w(16)),
            if (!item.hasMascot)
              AppText(
                data: 'Level ${item.level}',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: item.state == LevelState.locked
                    ? Colors.white38
                    : Colors.white,
              ),
          ],
        ),
      ),
    );
  }
}

class _LevelNode extends StatelessWidget {
  final LevelItem item;
  final double size;

  const _LevelNode({required this.item, required this.size});

  @override
  Widget build(BuildContext context) {
    if (item.state == LevelState.current) {
      return Container(
        width: size,
        height: size,

        child: Container(
        width: size,
        height: size,
        child: Image.asset(
          "assets/images/star_icon.png",
          width: size * 0.45,
          height: size * 0.45,
        ),
      )
      );
    }

    if (item.state == LevelState.completed) {
      return Container(
        width: size,
        height: size,
        child: Image.asset(
          "assets/images/check_icon.png",
          width: size * 0.45,
          height: size * 0.45,
        ),
      );
    }

    return Container(
      width: size,
      height: size,
      child: Image.asset(
        "assets/images/check_icon.png",
        width: size * 0.45,
        height: size * 0.45,
      ),
    );
  }
}