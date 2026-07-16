import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_assert_image.dart';
import '../../../core/util/screen_size.dart';
import '../../../core/widgets/buttons/app_button.dart';
import '../../../core/widgets/text/app_text.dart';
import '../../../core/widgets/text/text_field/AppTextFiled.dart';
import '../controllers/sign_up_controller.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<SignUpController>()
        ? Get.find<SignUpController>()
        : Get.put(SignUpController());

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

                    SizedBox(height: context.h(16)),

                    AppText(
                      data: 'Sign Up',
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),

                    SizedBox(height: context.h(8)),

                    AppText(
                      data: 'Create an account in just a few simple steps.',
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Colors.white60,
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: context.h(32)),

                    AppTextField(
                      hintText: 'Enter Full Name',
                      controller: controller.fullNameController,
                      focusNode: controller.fullNameFocus,
                      prefixIcon: Icons.person_outline,
                      validator: controller.validateFullName,
                      keyboardType: TextInputType.name,
                    ),

                    SizedBox(height: context.h(16)),

                    AppTextField(
                      hintText: 'Enter Email Address',
                      controller: controller.emailController,
                      focusNode: controller.emailFocus,
                      prefixIcon: Icons.email_outlined,
                      validator: controller.validateEmail,
                      keyboardType: TextInputType.emailAddress,
                    ),

                    SizedBox(height: context.h(16)),

                    AppTextField(
                      hintText: 'Enter Mobile Number',
                      controller: controller.mobileController,
                      focusNode: controller.mobileFocus,
                      prefixIcon: Icons.phone_outlined,
                      validator: controller.validateMobile,
                      keyboardType: TextInputType.phone,
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
                      buttonText: 'Sign Up',
                      onPressed: controller.signUp,
                      fillColor: const Color(0xFFF5A623),
                      textColor: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      buttonHeight: 56,
                      isLoading: controller.isLoading.value,
                      loadingText: 'Creating Account...',
                    )),

                    SizedBox(height: context.h(16)),

                    AppButton(
                      buttonText: 'Sign In',
                      onPressed: controller.navigateToSignIn,
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
              loadingMessage: 'Creating your account...',
              backgroundColor: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}