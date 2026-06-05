import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../core/util/screen_size.dart';
import '../../../core/widgets/buttons/app_button.dart';
import '../../../core/widgets/text/app_text.dart';


class EditAgeController extends GetxController {
  final selectedAge = 19.obs;
  final isLoading = false.obs;

  final int minAge = 10;
  final int maxAge = 100;

  late final FixedExtentScrollController scrollController;

  @override
  void onInit() {
    super.onInit();
    scrollController = FixedExtentScrollController(
      initialItem: selectedAge.value - minAge,
    );
  }

  void onAgeChanged(int index) {
    selectedAge.value = minAge + index;
  }

  Future<void> save() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 800));
    isLoading.value = false;
    Get.back();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}

class EditAgeScreen extends StatelessWidget {
  const EditAgeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditAgeController());

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
                onTap: (){Navigator.pop(context);},
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
            SizedBox(height: context.h(40)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.w(20)),
              child: AppText(
                data: "What's your Age?",
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Expanded(
              child: Center(
                child: SizedBox(
                  height: context.h(380),
                  child: ListWheelScrollView.useDelegate(
                    controller: controller.scrollController,
                    itemExtent: context.h(90),
                    perspective: 0.003,
                    diameterRatio: 1.8,
                    physics: const FixedExtentScrollPhysics(),
                    onSelectedItemChanged: controller.onAgeChanged,
                    childDelegate: ListWheelChildBuilderDelegate(
                      childCount: controller.maxAge - controller.minAge + 1,
                      builder: (context, index) {
                        final age = controller.minAge + index;
                        return Obx(() {
                          final isSelected = age == controller.selectedAge.value;
                          return Center(
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: context.w(160),
                              height: context.h(100),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFFF5A623)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: Text(
                                  '$age',
                                  style: TextStyle(
                                    fontSize: isSelected
                                        ? context.sp(52)
                                        : context.sp(36),
                                    fontWeight: FontWeight.bold,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.white24,
                                  ),
                                ),
                              ),
                            ),
                          );
                        });
                      },
                    ),
                  ),
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
                onPressed: controller.save,
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
