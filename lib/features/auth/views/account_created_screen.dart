import 'package:ai_fitness_app/features/auth/views/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_assert_image.dart';
import '../../../core/util/app_navigation.dart';
import '../../../core/util/screen_size.dart';
import '../../../core/widgets/buttons/app_button.dart';
import '../../../core/widgets/text/app_text.dart';

class AccountCreatedScreen extends StatelessWidget {
  const AccountCreatedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: context.w(24)),
          child: Column(
            children: [
              SizedBox(height: context.h(20)),

              Image.asset(
                AppAssertImage.instance.appLogo,
                width: context.w(200),
                height: context.h(120),
                fit: BoxFit.contain,
              ),

              const Spacer(),

              AppText(
                data: 'Account Created Successfully',
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                textAlign: TextAlign.center,
              ),

              SizedBox(height: context.h(16)),

              AppText(
                data:
                'Your account has been created. You can now log in and start exploring your account.',
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: Colors.white60,
                textAlign: TextAlign.center,
              ),

              const Spacer(),

              AppButton(
                buttonText: 'Sign In',
                onPressed: () => AppNavigation.push(SignInScreen()),
                fillColor: const Color(0xFFF5A623),
                textColor: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                buttonHeight: 56,
              ),

              SizedBox(height: context.h(40)),
            ],
          ),
        ),
      ),
    );
  }
}