

import 'package:ai_fitness_app/features/auth/bindings/auth_binding.dart';
import 'package:ai_fitness_app/features/profile/profile_binding.dart';

import '../../features/base_screen/binding/base_binding.dart';

class AppBindings {
  AppBindings._();
  static void init() {
    // SignInBinding.dependencies();
    BaseBinding.dependencies();
    AuthBindings.signInDependencies();
    AuthBindings.otpVerificationDependencies();
    ProfileBindings.profileDependencies();
  }

}