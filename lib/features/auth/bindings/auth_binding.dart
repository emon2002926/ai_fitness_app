import 'package:get/get.dart';
import '../controllers/forgot_password_controller.dart';
import '../controllers/otp_verification_controller.dart';
import '../controllers/signIn_controller.dart';


class AuthBindings {

  static void signInDependencies() {
    Get.lazyPut<SignInController>(
          () => SignInController(),
    );
  }



  // static void signUpDependencies() {
  //   Get.lazyPut<SignUpController>(
  //         () => SignUpController(),
  //   );
  // }


  static void forgotPassDependencies() {
    Get.lazyPut<ForgotPasswordController>(
          () => ForgotPasswordController(),
    );
  }
  //
  // static void resetPassDependencies() {
  //   Get.lazyPut<ResetPasswordController>(
  //         () => ResetPasswordController(),
  //   );
  // }
  // //
  static void otpVerificationDependencies() {
    Get.lazyPut<OtpVerificationController>(
          () => OtpVerificationController(),
    );
  }
  // static void onboardingDependencies() {
  //   Get.lazyPut<OnboardingController>(
  //         () => OnboardingController(),
  //   );
  // }

}
