import 'package:ai_fitness_app/core/util/app_navigation.dart';
import 'package:ai_fitness_app/core/util/storage_service.dart';
import 'package:ai_fitness_app/features/base_screen/views/base_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/util/screen_size.dart';
import 'package:get/get.dart';

import '../../../core/widgets/buttons/app_button.dart';
import '../../../core/widgets/text/app_text.dart';
import '../controllers/PlanReadyController.dart';


class PlanReadyScreen extends StatelessWidget {
  const PlanReadyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<PlanReadyController>()
        ? Get.find<PlanReadyController>()
        : Get.put(PlanReadyController());
    print("sdfkgjfhdgkh: ${StorageService.accessToken}");
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.w(24),
                vertical: context.h(12),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      width: context.w(40),
                      height: context.w(40),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF5A623),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                    ),
                  ),
                  SizedBox(width: context.w(16)),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(context.w(4)),
                      child: LinearProgressIndicator(
                        value: 1.0,
                        minHeight: context.h(4),
                        backgroundColor: Colors.white12,
                        valueColor: const AlwaysStoppedAnimation(Color(0xFFF5A623)),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(color: Color(0xFFF5A623)),
                      SizedBox(height: context.h(24)),
                      Obx(() => AppText(
                        data: controller.statusMessage.value,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white60,
                        textAlign: TextAlign.center,
                      )),
                    ],
                  );
                }

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('🎉', style: TextStyle(fontSize: context.sp(80))),
                    SizedBox(height: context.h(24)),
                    AppText(
                      data: 'Your Plan is Ready',
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: context.h(8)),
                    AppText(
                      data: 'AI-calculated daily targets',
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Colors.white54,
                    ),
                    SizedBox(height: context.h(40)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: context.w(24)),
                      child: Row(
                        children: [
                          Expanded(
                            child: _PlanCard(
                              emoji: '🔥',
                              label: 'Calories',
                              value: '${controller.calories.value}',
                              unit: 'kcal',
                            ),
                          ),
                          SizedBox(width: context.w(16)),
                          Expanded(
                            child: _PlanCard(
                              emoji: '🥩',
                              label: 'Protein',
                              value: '${controller.protein.value}',
                              unit: 'gm',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ),

            Obx(() => controller.isLoading.value
                ? const SizedBox.shrink()
                : Padding(
              padding: EdgeInsets.fromLTRB(
                context.w(24),
                context.h(8),
                context.w(24),
                context.h(32),
              ),
              child: AppButton(
                buttonText: 'CONTINUE',
                onPressed: () => AppNavigation.pushAndClear(const BasePage()),
                fillColor: const Color(0xFFF5A623),
                textColor: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            )),
          ],
        ),
      ),
    );
  }
}
class _PlanCard extends StatelessWidget {
  final String emoji;
  final String label;
  final String value;
  final String unit;

  const _PlanCard({
    required this.emoji,
    required this.label,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.w(20)),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(context.w(14)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: TextStyle(fontSize: context.sp(28))),
          SizedBox(height: context.h(8)),
          AppText(
            data: label,
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: Colors.white54,
            googleFontFamily: GoogleFonts.nunito,
          ),
          SizedBox(height: context.h(4)),
          RichText(
            text: TextSpan(
              style: GoogleFonts.nunito(
                fontSize: context.sp(22),
                fontWeight: FontWeight.w700,
                color: const Color(0xFFF5A623),
              ),
              children: [
                TextSpan(text: value),
                TextSpan(
                  text: ' $unit',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFFF5A623),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}