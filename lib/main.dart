import 'package:ai_fitness_app/features/onboarding/views/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'core/bindings/app_bindings.dart';
import 'core/services/api/services/api_services.dart';
import 'core/util/app_navigation.dart';
import 'features/onboarding/views/plan_ready_screen.dart';
import 'features/onboarding/views/user_info_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AppBindings.init();
  GetStorage();

  Get.put(ApiServices(baseUrl: 'https://skinseekapi.dsrt321.online'));
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      navigatorKey: AppNavigation.navigatorKey,

      // home: const PlanReadyScreen(),
      home: const OnboardingScreen(),
      // home: const UserInfoScreen(),
      // home: const BasePage(),
    );
  }
}




