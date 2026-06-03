import 'package:ai_fitness_app/core/util/app_navigation.dart';
import 'package:ai_fitness_app/features/auth/controllers/forget_password_screen.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_assert_image.dart';
import '../../../core/util/screen_size.dart';
import '../../../core/widgets/buttons/app_button.dart';
import '../../../core/widgets/text/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/widgets/text/text_field/AppTextFiled.dart';
import '../controllers/signIn_controller.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignInController());

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: context.w(24)),
              child: Form(
                key: controller.formKey,
                child: Column(
                  children: [
                    SizedBox(height: context.h(20)),

                    Image.asset(
                      AppAssertImage.instance.appLogo,
                      width: context.w(200),
                      height: context.h(150),
                      fit: BoxFit.contain,
                    ),

                    SizedBox(height: context.h(24)),

                    AppText(
                      data: 'Sign In',
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),

                    SizedBox(height: context.h(8)),

                    AppText(
                      data: 'Enter your details to access your account.',
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Colors.white60,
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: context.h(48)),

                    AppTextField(
                      hintText: 'Enter Email Address',
                      controller: controller.emailController,
                      focusNode: controller.emailFocus,
                      prefixIcon: Icons.email_outlined,
                      validator: controller.validateEmail,
                      keyboardType: TextInputType.emailAddress,
                    ),

                    SizedBox(height: context.h(16)),

                    Obx(() => AppTextField(
                      hintText: 'Enter Password',
                      controller: controller.passwordController,
                      focusNode: controller.passwordFocus,
                      prefixIcon: Icons.lock_outline,
                      suffixIcon: controller.isPasswordVisible.value
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      onSuffixIconTap: controller.togglePasswordVisibility,
                      obscureText: !controller.isPasswordVisible.value,
                      validator: controller.validatePassword,
                      keyboardType: TextInputType.visiblePassword,
                    )),

                    SizedBox(height: context.h(12)),

                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: (){
                          AppNavigation.push(ForgetPasswordScreen());
                        },
                        child: AppText(
                          data: 'Forget Password?',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white60,
                        ),
                      ),
                    ),

                    SizedBox(height: context.h(48)),

                    Obx(() => AppButton(
                      buttonText: 'Sign In',
                      onPressed: controller.login,
                      fillColor: const Color(0xFFF5A623),
                      textColor: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      buttonHeight: 56,
                      isLoading: controller.isLoading.value,
                      loadingText: 'Signing In...',
                    )),

                    SizedBox(height: context.h(16)),

                    AppButton(
                      buttonText: 'Sign Up',
                      onPressed: controller.navigateToSignUp,
                      fillColor: Colors.transparent,
                      textColor: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      buttonHeight: 56,
                      borderColor: Colors.white24,
                      borderWidth: 1,
                    ),

                    SizedBox(height: context.h(40)),
                  ],
                ),
              ),
            ),

            AppButton.buildLoadingOverlay(
              isLoading: controller.isLoading,
              loadingMessage: 'Signing you in...',
              backgroundColor: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}