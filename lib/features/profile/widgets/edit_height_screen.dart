import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/util/screen_size.dart';
import '../../../core/widgets/buttons/app_button.dart';
import '../../../core/widgets/text/app_text.dart';



import '../controllers/onboarding_service.dart';
import '../views/shared_widgets.dart';



class EditHeightController extends GetxController {
  final heightUnit       = 'Cm'.obs;
  final heightController = TextEditingController(text: '172');
  final isLoading        = false.obs;

  Future<void> save(BuildContext context) async {
    final raw = heightController.text.trim();
    if (raw.isEmpty) return;

    final heightInCm = heightUnit.value == 'Fit'
        ? (double.tryParse(raw) ?? 0) * 30.48
        : double.tryParse(raw) ?? 0;

    isLoading.value = true;
    final success = await OnboardingService.patch({
      'height': heightInCm.toStringAsFixed(0),
    });
    isLoading.value = false;
    if (success && context.mounted) Navigator.pop(context);
  }

  @override
  void onClose() {
    heightController.dispose();
    super.onClose();
  }
}
class EditHeightScreen extends StatelessWidget {
  const EditHeightScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<EditHeightController>()
        ? Get.find<EditHeightController>()
        : Get.put(EditHeightController());

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: context.h(16)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.w(20)),
              child: GestureDetector(
                onTap: () {Navigator.pop(context);},
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
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: context.w(24)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: context.h(40)),
                    AppText(
                      data: "What's your current Height?",
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    SizedBox(height: context.h(32)),
                    Obx(() => UnitToggle(
                      leftLabel: 'Cm',
                      rightLabel: 'Fit',
                      selected: controller.heightUnit.value,
                      onChanged: (val) => controller.heightUnit.value = val,
                    )),
                    SizedBox(height: context.h(32)),
                    Obx(() => Center(
                      child: EditableValueBox(
                        controller: controller.heightController,
                        unit: controller.heightUnit.value,
                      ),
                    )),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.w(20),
                vertical: context.h(24),
              ),
              child: Obx(() => AppButton(
                buttonText: 'SAVE',
                onPressed:() {controller.save(context);},
                fillColor: const Color(0xFFF5A623),
                textColor: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                buttonHeight: 56,
                isLoading: controller.isLoading.value,
                loadingText: 'Saving...',
              )),
            ),
          ],
        ),
      ),
    );
  }
}