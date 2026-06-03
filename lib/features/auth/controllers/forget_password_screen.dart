import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_assert_image.dart';
import '../../../core/util/screen_size.dart';
import '../../../core/widgets/buttons/app_button.dart';
import '../../../core/widgets/text/app_text.dart';
import '../../../core/widgets/text/text_field/AppTextFiled.dart';
import 'forgot_password_controller.dart';


class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgotPasswordController());

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
                      data: 'Forgot password',
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),

                    SizedBox(height: context.h(12)),

                    AppText(
                      data: 'Please enter your email to reset the password',
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

                    SizedBox(height: context.h(24)),

                    Obx(() => AppButton(
                      buttonText: 'Reset Password',
                      onPressed: controller.resetPassword,
                      fillColor: const Color(0xFFF5A623),
                      textColor: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      buttonHeight: 56,
                      isLoading: controller.isLoading.value,
                      loadingText: 'Sending...',
                    )),

                    SizedBox(height: context.h(40)),
                  ],
                ),
              ),
            ),

            AppButton.buildLoadingOverlay(
              isLoading: controller.isLoading,
              loadingMessage: 'Sending reset code...',
              backgroundColor: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}