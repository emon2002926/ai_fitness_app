import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/util/screen_size.dart';
import '../../../core/widgets/app_bar/build_app_bar.dart';
import '../../../core/widgets/text/app_text.dart';

class SupportLegalController extends GetxController {
  final avatarUrl = ''.obs;

  void onNotificationPressed() {}
  void onAvatarPressed() {}
}

class SupportLegalScreen extends StatelessWidget {
  const SupportLegalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<SupportLegalController>()
        ? Get.find<SupportLegalController>()
        : Get.put(SupportLegalController());

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: BuildAppBar(
        title: 'Support & legal',
        showBackButton: true,
        showNotification: true,
        onNotificationPressed: controller.onNotificationPressed,
        avatarUrl: controller.avatarUrl.value.isEmpty
            ? null
            : controller.avatarUrl.value,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: context.w(20),
          vertical: context.h(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              data:
                  'This Privacy Policy describes how we collect, use, and protect your information when you use our Money Management App ("we," "our," or "us"). By using the app, you agree to this policy.',
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
            SizedBox(height: context.h(24)),
            _LegalSection(
              heading: 'Information We Collect',
              bullets: const [
                'Personal details such as your name, email, and phone number.',
                'Financial data you enter manually, such as income, expenses, and savings goals.',
                'Device information (for performance and analytics).',
              ],
            ),
            _LegalSection(
              heading: 'How We Use Your Data',
              bullets: const [
                'To track and visualize your spending and income.',
                'To personalize insights, reminders, and budgeting tips.',
                'To improve app performance and user experience.',
              ],
            ),
            _LegalSection(
              heading: 'Data Security',
              paragraph:
                  'We use encryption and secure storage to keep your information safe. Your data is never sold to third parties.',
            ),
            _LegalSection(
              heading: 'Third-Party Services',
              paragraph:
                  'Some app features may integrate with secure third-party services (like Google or Apple Sign-In). We never share your financial data without your consent.',
            ),
            SizedBox(height: context.h(40)),
          ],
        ),
      ),
    );
  }
}

class _LegalSection extends StatelessWidget {
  final String heading;
  final String? paragraph;
  final List<String>? bullets;

  const _LegalSection({
    required this.heading,
    this.paragraph,
    this.bullets,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.h(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            data: heading,
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          SizedBox(height: context.h(10)),
          if (bullets != null)
            ...bullets!.map((b) => _BulletItem(text: b)),
          if (paragraph != null)
            AppText(
              data: paragraph!,
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
        ],
      ),
    );
  }
}

class _BulletItem extends StatelessWidget {
  final String text;

  const _BulletItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.h(6)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: context.h(6), right: context.w(8)),
            child: Container(
              width: context.w(6),
              height: context.w(6),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Expanded(
            child: AppText(
              data: text,
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
