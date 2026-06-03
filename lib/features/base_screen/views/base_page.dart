import 'package:ai_fitness_app/features/ai_coach/views/ai_coach_screen.dart';
import 'package:ai_fitness_app/features/work_out/views/work_out_screen.dart';
import 'package:flutter/material.dart';

import '../../../core/widgets/bottom_navigation/bottom_navigation.dart';
import '../../levels/views/levels_screen.dart';
import '../../nutrition/views/nutrition_screen.dart';

import '../../progress/views/progress_screen.dart';
import '../controllers/base_controller.dart';
import '../../home/views/home_view.dart';
import 'package:get/get.dart';



class BasePage extends StatelessWidget {
  const BasePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BaseController>();

    final screens = [
      const HomeView(),
      WorkOutScreen(),
      AiCoachScreen(),
      NutritionScreen(),
      LevelsScreen(),
      ProgressScreen(),
    ];

    return Obx(() => Scaffold(
      key: controller.scaffoldKey,
      backgroundColor: const Color(0xFFF0EFE9),
      extendBody: true,

      body: WillPopScope(
        onWillPop: () {
          final key = controller.keyForIndex(controller.currentIndex.value);
          if (key.currentState?.canPop() == true) {
            key.currentState?.pop();
            return Future.value(false);
          }
          return Future.value(true);
        },
        child: IndexedStack(
          index: controller.currentIndex.value,
          children: [
            Navigator(
              key: controller.homeNavKey,
              onGenerateInitialRoutes: (_, _) =>
              [MaterialPageRoute(builder: (_) => screens[0])],
            ),
            Navigator(
              key: controller.workOutNavKey,
              onGenerateInitialRoutes: (_, _) =>
              [MaterialPageRoute(builder: (_) => screens[1])],
            ),
            Navigator(
              key: controller.aiCoachNavKey,
              onGenerateInitialRoutes: (_, _) =>
              [MaterialPageRoute(builder: (_) => screens[2])],
            ),
            Navigator(
              key: controller.nutritionNavKey,
              onGenerateInitialRoutes: (_, _) =>
              [MaterialPageRoute(builder: (_) => screens[3])],
            ),
            Navigator(
              key: controller.levelsNavKey,
              onGenerateInitialRoutes: (_, _) =>
              [MaterialPageRoute(builder: (_) => screens[4])],
            ),
            Navigator(
              key: controller.progressNavKey,
              onGenerateInitialRoutes: (_, _) =>
              [MaterialPageRoute(builder: (_) => screens[5])],
            ),
          ],
        ),
      ),

      bottomNavigationBar: Obx(() => CustomBottomNavigationBar(
        currentIndex: controller.currentIndex.value,
        onTabSelected: controller.onTabSelected,
      )),
    ));
  }
}