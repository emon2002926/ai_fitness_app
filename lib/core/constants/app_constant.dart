class AppConstant {
  final String font = "Montserrat";
  final String playfair = "PlayfairDisplay";
  final String poppins = "Poppins";
  final String freeTour = "Free Tour";
  final double DEAFULT_CAMERA_ZOOM = 15;

  static const String baseUrl = 'https://lexiapi.dsrt321.online';

  static const String signUpEndpoint = '$baseUrl/api/v1/auth/register/';
  static const String forgotPasswordEndpoint = '$baseUrl/api/v1/auth/forgot-password/';
  static const String resetPasswordEndpoint = '$baseUrl/api/v1/auth/set_new_password/';

  static const String setNewPasswordEndpoint = '$baseUrl/api/v1/auth/forgot-password/set/password/';
  static const String activateAccountEndpoint = '$baseUrl/api/v1/auth/register/activate/';
  static const String forgotPasswordVerifyEndpoint = '$baseUrl/api/v1/auth/forgot-password/verify/';
  static const String resendOtpEndpoint = '$baseUrl/api/v1/auth/resend-otp/';
  static const String onboardingEndpoint = '$baseUrl/api/v1/service/onboarding/create/';

  static const String homeEndpoint = '$baseUrl/api/v1/service/home/onboarding/';
  static const String workoutPlanEndpoint = '$baseUrl/api/v1/service/onboarding/workout-plan/list/';
  static const String achievementsEndpoint = '$baseUrl/api/v1/service/workout/achievements/';


}