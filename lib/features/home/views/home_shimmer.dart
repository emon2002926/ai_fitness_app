
import 'package:flutter/cupertino.dart';

import '../../../core/util/screen_size.dart';
import '../../../core/widgets/shimmer/app_shimmer.dart';

class HomeShimmer extends StatelessWidget {
  const HomeShimmer();

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.only(bottom: context.h(100)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.w(20),
                vertical: context.h(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerBox(width: context.w(180), height: context.h(26)),
                        SizedBox(height: context.h(8)),
                        ShimmerBox(width: context.w(140), height: context.h(14)),
                      ],
                    ),
                  ),
                  ShimmerBox(width: context.w(56), height: context.h(32), radius: 20),
                  SizedBox(width: context.w(12)),
                  ShimmerBox(height: context.w(26), circle: true),
                  SizedBox(width: context.w(12)),
                  ShimmerBox(height: context.w(44), circle: true),
                ],
              ),
            ),
            SizedBox(height: context.h(20)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.w(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Level card
                  ShimmerBox(
                    width: double.infinity,
                    height: context.h(100),
                    radius: 16,
                  ),
                  SizedBox(height: context.h(16)),
                  // Stats row
                  Row(
                    children: [
                      Expanded(child: ShimmerBox(height: context.h(90), radius: 14)),
                      SizedBox(width: context.w(10)),
                      Expanded(child: ShimmerBox(height: context.h(90), radius: 14)),
                      SizedBox(width: context.w(10)),
                      Expanded(child: ShimmerBox(height: context.h(90), radius: 14)),
                    ],
                  ),
                  SizedBox(height: context.h(24)),
                  ShimmerBox(width: context.w(120), height: context.h(16)),
                  SizedBox(height: context.h(12)),
                  // Today's plan card
                  ShimmerBox(
                    width: double.infinity,
                    height: context.h(200),
                    radius: 16,
                  ),
                  SizedBox(height: context.h(16)),
                  // Calorie card
                  ShimmerBox(
                    width: double.infinity,
                    height: context.h(320),
                    radius: 16,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
