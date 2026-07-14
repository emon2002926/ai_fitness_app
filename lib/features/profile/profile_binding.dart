import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';

import 'controllers/profile_controller.dart';

class ProfileBindings {

  static void profileDependencies() {
    Get.lazyPut<ProfileController>(
          () => ProfileController(),
    );
  }

}
