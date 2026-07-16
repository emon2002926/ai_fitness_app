import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/util/app_navigation.dart';
import '../../../core/util/screen_size.dart';
import '../../../core/widgets/buttons/app_button.dart';
import '../../../core/widgets/text/app_text.dart';
import '../../auth/views/sign_in_screen.dart';
import '../../auth/views/sign_up_screen.dart';


class OnboardingController extends GetxController {
  final pageController = PageController();
  final currentPage = 0.obs;

  static const int totalOnboardingPages = 3;
  static const int totalPages = 4;

  void onPageChanged(int index) => currentPage.value = index;

  void nextPage() {
    if (currentPage.value < totalPages - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void skip() {
    pageController.animateToPage(
      totalOnboardingPages - 1,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void getStarted() => Get.offAllNamed('/register');
  void login() => Get.offAllNamed('/login');

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}

class OnboardingScreen extends GetView<OnboardingController> {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<OnboardingController>()) Get.put(OnboardingController());

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                PageView(
                  controller: controller.pageController,
                  onPageChanged: controller.onPageChanged,
                  children: const [
                    _OnboardingPageContent(index: 0),
                    _OnboardingPageContent(index: 1),
                    _OnboardingPageContent(index: 2),
                    _WelcomePageContent(),
                  ],
                ),

              ],
            ),
          ),
          Obx(() {
            final page = controller.currentPage.value;
            final isWelcome = page == OnboardingController.totalPages - 1;

            return Container(
              color: Colors.black,
              padding: EdgeInsets.fromLTRB(
                context.w(24),
                context.h(8),
                context.w(24),
                context.h(40),
              ),
              child: isWelcome
                  ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppButton(
                    buttonText: 'GET STARTED',
                    onPressed: (){AppNavigation.push(SignUpScreen(),context: context);},
                    fillColor: const Color(0xFFF5A623),
                    textColor: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                  SizedBox(height: context.h(16)),
                  AppButton(
                    buttonText: 'Log In',
                    onPressed: (){AppNavigation.push(SignInScreen(),context: context);},
                    fillColor: Colors.transparent,
                    textColor: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    borderColor: Colors.white38,
                    borderWidth: 1,

                  ),
                ],
              )
                  : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      OnboardingController.totalOnboardingPages,
                          (i) {
                        final isActive = i == page;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          margin: EdgeInsets.symmetric(horizontal: context.w(5)),
                          width: isActive ? context.w(24) : context.w(8),
                          height: context.h(8),
                          decoration: BoxDecoration(
                            color: isActive
                                ? const Color(0xFFF5A623)
                                : Colors.white24,
                            borderRadius: BorderRadius.circular(context.w(4)),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: context.h(24)),
                  if (page > 0)
                    AppButton(
                      buttonText: 'CONTINUE',
                      onPressed: controller.nextPage,
                      fillColor: const Color(0xFFF5A623),
                      textColor: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    )
                  else
                    AppButton(
                      buttonText: 'SKIP',
                      onPressed: controller.skip,
                      fillColor: Colors.transparent,
                      textColor: Colors.white54,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      borderColor: Colors.transparent,
                    ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _OnboardingPageContent extends StatelessWidget {
  final int index;
  const _OnboardingPageContent({required this.index});

  static const _data = [
    (
    title: 'Your Fitness ',
    titleHighlight: 'Journey\nStarts Here',
    subtitle:
    'Personalized workouts, smart nutrition & real-time tracking to help you become your best version.',
    imagePath: 'assets/images/lion_logo.png',
    ),
    (
    title: 'Train Smarter for\n',
    titleHighlight: 'Faster Result',
    subtitle:
    'AI-powered workout plans tailored to your goals, fitness level & equipment.',
    imagePath: 'assets/images/lion_logo.png',
    ),
    (
    title: 'Eat Better ',
    titleHighlight: 'Live Better',
    subtitle:
    'Personalized workouts, smart nutrition & real-time tracking to help you become your best version.',
    imagePath: 'assets/images/lion_logo.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final d = _data[index];

    return Column(
      children: [
        SizedBox(height: context.h(56)),
        _FitlexLogo(),
        SizedBox(height: context.h(16)),
        Expanded(
          child: Image.asset(d.imagePath, fit: BoxFit.contain),
        ),
        SizedBox(height: context.h(24)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.w(28)),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: GoogleFonts.nunito(
                fontSize: context.sp(30),
                fontWeight: FontWeight.w800,
                color: Colors.white,
                height: 1.2,
              ),
              children: [
                TextSpan(text: d.title),
                TextSpan(
                  text: d.titleHighlight,
                  style:  GoogleFonts.nunito(color: Color(0xFFF5A623)),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: context.h(16)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.w(32)),
          child: AppText(
            data: d.subtitle,
            color: Colors.white60,
            fontSize: 15,
            fontWeight: FontWeight.w400,
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: context.h(16)),
      ],
    );
  }
}

class _WelcomePageContent extends StatelessWidget {
  const _WelcomePageContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: context.h(56)),
        _FitlexLogo(),
        Expanded(
          child: Image.asset('assets/images/lion_logo.png', fit: BoxFit.contain),
        ),
        SizedBox(height: context.h(16)),
      ],
    );
  }
}

class _FitlexLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          'assets/images/logo.png',
          height: context.h(150),
          fit: BoxFit.contain,
        ),

      ],
    );
  }
}