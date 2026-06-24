

import 'package:ai_fitness_app/features/auth/bindings/auth_binding.dart';

import '../../features/base_screen/binding/base_binding.dart';

class AppBindings {
  AppBindings._();
  static void init() {
    // SignInBinding.dependencies();
    BaseBinding.dependencies();
    AuthBindings.signInDependencies();
    AuthBindings.otpVerificationDependencies();
    // AuthBindings.signInDependencies();
    // AuthBindings.signUpDependencies();
    //
    // AuthBindings.forgotPassDependencies();
    // AuthBindings.otpVerificationDependencies();
    // AuthBindings.resetPassDependencies();
    // AuthBindings.onboardingDependencies();
    //
    // ProfileBindings.profileDependencies();
    // ProfileBindings.chooseSkinTypeConcernsDependencies();
    // ProfileBindings.chooseSkinTypeDependencies();
    // IngredientAnalyserBindings.ingredientAnalyserScreenDependencies();
    // IngredientAnalyserBindings.pasteIngredientTabDependencies();
    // IngredientAnalyserBindings.scanBarcodeTabbDependencies();
    // IngredientAnalyserBindings.uploadPhotoDependencies();
    //
    // DupeFinderBinding.dupFinderScreenDependencies();
    // DupeFinderBinding.scanBarCodeDependencies();
    // DupeFinderBinding.typeProductDependencies();
    // ClashCheckerBindings.clashCheckerDependencies();
    // BuildMyRoutineBinding.buildMyRoutineDependencies();

  }

}