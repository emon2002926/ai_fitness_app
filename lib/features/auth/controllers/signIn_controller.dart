
import 'package:ai_fitness_app/features/base_screen/views/base_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/services/api/services/api_services.dart';
import '../../../core/util/app_navigation.dart';
import '../views/sign_up_screen.dart';
class SignInController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final ApiServices _api = Get.find<ApiServices>();

  final emailFocus = FocusNode();
  final passwordFocus = FocusNode();

  final isPasswordVisible = false.obs;
  final isLoading = false.obs;

  final formKey = GlobalKey<FormState>();

  void togglePasswordVisibility() =>
      isPasswordVisible.value = !isPasswordVisible.value;

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your email';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) return 'Please enter a valid email';
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your password';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  Future<void> login() async {

    AppNavigation.pushAndClear(BasePage());
    // AppNavigation.pushAndClear(UserInfoScreen());




    // if (!formKey.currentState!.validate()) return;
    //
    // final email = emailController.text.trim();
    // final password = passwordController.text.trim();
    //
    // isLoading.value = true;
    // try {
    //   final raw = await _api.post(
    //     '/auth/user/signin',
    //     body: {'email': email, 'password': password},
    //   );
    //
    //   final response = SignInResponseModel.fromJson(raw);
    //
    //   if (response.data == null) {
    //     CustomSnackBar.error('Login failed. Please try again.');
    //     return;
    //   }
    //
    //   final token = response.data!.token;
    //   final user = response.data!.user;
    //
    //   StorageService.saveToken(token);
    //   await StorageService.saveUser(user);
    //
    //   StatusChecker.navigate(user.approveStatus);
    //   CustomSnackBar.success('Welcome back, ${user.name}!');
    // } on HttpException catch (e) {
    //   if (e.body != null && e.body!.contains('not verified')) {
    //     CustomSnackBar.warning('Please verify your email to continue.');
    //     await Future.delayed(const Duration(milliseconds: 500));
    //     AppNavigation.push(OtpVerificationScreen(email: email, isFromSignUp: true));
    //   } else {
    //     CustomSnackBar.error(e.message);
    //   }
    // } finally {
    //   isLoading.value = false;
    // }
  }

  void navigateToSignUp() => AppNavigation.push(SignUpScreen());
  // void navigateToForgetPassword() => AppNavigation.push(ForgetPasswordScreen());

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    emailFocus.dispose();
    passwordFocus.dispose();
    super.onClose();
  }
}