import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_assert_image.dart';
import '../../core/util/screen_size.dart';
import 'splash_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _fade;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    Get.put(SplashController());

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fade = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _scale = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutBack),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: FadeTransition(
            opacity: _fade,
            child: ScaleTransition(
              scale: _scale,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    AppAssertImage.instance.appLogo,
                    width: context.w(200),
                    height: context.w(200),
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: context.h(40)),
                  SizedBox(
                    width: context.w(24),
                    height: context.w(24),
                    child: const CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Color(0xFFF5A623),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
