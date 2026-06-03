import '../controllers/base_controller.dart';
import 'package:get/get.dart';
class BaseBinding {
  static void dependencies(){
    Get.lazyPut<BaseController>(
          ()=> BaseController(),
      fenix: true,
    );

    // Get.lazyPut<BaseController>(
    //       ()=> BaseController(),
    //   fenix: true,
    // );
  }


}