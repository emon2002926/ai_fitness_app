import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_assert_image.dart';
import '../../../core/util/screen_size.dart';
import '../../../core/widgets/buttons/app_button.dart';
import '../../../core/widgets/text/app_text.dart';
import '../controllers/otp_verification_controller.dart';


class OtpVerificationScreen extends StatelessWidget {
  final String email;
  final bool isFromSignUp;

  const OtpVerificationScreen({
    super.key,
    required this.email,
    required this.isFromSignUp,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OtpVerificationController(
      email: email,
      isFromSignUp: isFromSignUp,
    ));

    final maskedEmail = _maskEmail(email);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
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

                  SizedBox(height: context.h(40)),

                  AppText(
                    data: 'Check your email',
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),

                  SizedBox(height: context.h(12)),

                  AppText(
                    data:
                    'We sent a code to $maskedEmail. Enter 6 digit code that mentioned in the email',
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Colors.white60,
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: context.h(40)),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(6, (i) => _OtpBox(
                      controller: controller.otpControllers[i],
                      focusNode: controller.focusNodes[i],
                      onChanged: (val) => controller.onOtpChanged(val, i),
                    )),
                  ),

                  SizedBox(height: context.h(40)),

                  Obx(() => AppButton(
                    buttonText: 'Verify Code',
                    onPressed: controller.verifyCode,
                    fillColor: const Color(0xFFF5A623),
                    textColor: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    buttonHeight: 56,
                    isLoading: controller.isLoading.value,
                    loadingText: 'Verifying...',
                  )),

                  SizedBox(height: context.h(24)),

                  GestureDetector(
                    onTap: controller.resendOtp,
                    child: RichText(
                      text: TextSpan(
                        style: GoogleFonts.nunito(
                          fontSize: context.sp(15),
                          color: Colors.white60,
                          fontWeight: FontWeight.w400,
                        ),
                        children: [
                          const TextSpan(text: "Haven't got the email yet? "),
                          TextSpan(
                            text: 'Resend email',
                            style: const TextStyle(
                              color: Color(0xFFF5A623),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: context.h(40)),
                ],
              ),
            ),

            AppButton.buildLoadingOverlay(
              isLoading: controller.isLoading,
              loadingMessage: 'Verifying your code...',
              backgroundColor: Colors.black,
            ),
          ],
        ),
      ),
    );
  }

  String _maskEmail(String email) {
    final parts = email.split('@');
    if (parts.length != 2) return email;
    final name = parts[0];
    final domain = parts[1];
    if (name.length <= 3) return '${name[0]}...@$domain';
    return '${name.substring(0, 3)}...@$domain';
  }
}

class _OtpBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;

  const _OtpBox({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.w(48),
      height: context.h(56),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        onChanged: onChanged,
        maxLength: 1,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: GoogleFonts.nunito(
          fontSize: context.sp(22),
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: const Color(0xFF1A1A1A),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(context.w(10)),
            borderSide: const BorderSide(color: Colors.white24),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(context.w(10)),
            borderSide: const BorderSide(color: Colors.white24),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(context.w(10)),
            borderSide: const BorderSide(color: Color(0xFFF5A623), width: 1.5),
          ),
        ),
      ),
    );
  }
}