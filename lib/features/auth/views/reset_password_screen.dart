import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_assert_image.dart';
import '../../../core/util/screen_size.dart';
import '../../../core/widgets/buttons/app_button.dart';
import '../../../core/widgets/text/app_text.dart';
import '../../../core/widgets/text/text_field/AppTextFiled.dart';
import '../controllers/reset_password_controller.dart';

class ResetPasswordScreen extends StatelessWidget {
  final String email;
  final String otp;

  const ResetPasswordScreen({
    super.key,
    required this.email,
    required this.otp,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ResetPasswordController());

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
                      height: context.h(120),
                      fit: BoxFit.contain,
                    ),

                    SizedBox(height: context.h(40)),

                    AppText(
                      data: 'Password reset',
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),

                    SizedBox(height: context.h(12)),

                    AppText(
                      data:
                      "Enter your email address and we'll send you a link to reset your password.",
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Colors.white60,
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: context.h(48)),

                    Obx(() => AppTextField(
                      hintText: 'Enter your new password',
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

                    SizedBox(height: context.h(16)),

                    Obx(() => AppTextField(
                      hintText: 'New Password a Second Time',
                      controller: controller.confirmPasswordController,
                      focusNode: controller.confirmPasswordFocus,
                      prefixIcon: Icons.lock_outline,
                      suffixIcon: controller.isConfirmPasswordVisible.value
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      onSuffixIconTap:
                      controller.toggleConfirmPasswordVisibility,
                      obscureText:
                      !controller.isConfirmPasswordVisible.value,
                      validator: controller.validateConfirmPassword,
                      keyboardType: TextInputType.visiblePassword,
                    )),

                    SizedBox(height: context.h(32)),

                    Obx(() => AppButton(
                      buttonText: 'Update Password',
                      onPressed: () {
                        controller.updatePassword(email);
                      },
                      fillColor: const Color(0xFFF5A623),
                      textColor: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      buttonHeight: 56,
                      isLoading: controller.isLoading.value,
                      loadingText: 'Updating...',
                    )),

                    SizedBox(height: context.h(40)),
                  ],
                ),
              ),
            ),

            AppButton.buildLoadingOverlay(
              isLoading: controller.isLoading,
              loadingMessage: 'Updating your password...',
              backgroundColor: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}