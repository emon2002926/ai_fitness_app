import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/mascot_controller.dart';

class AvatarDisplayWidget extends StatelessWidget {
  final double? width;
  final double? height;
  final BoxFit fit;

  const AvatarDisplayWidget({
    Key? key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final avatarUrl = MascotController.to.avatarImageUrl.value;
      final species = MascotController.to.species.value;

      if (avatarUrl != null && avatarUrl.isNotEmpty) {
        return Image.network(
          avatarUrl,
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (context, error, stackTrace) {
            return _fallbackImage();
          },
        );
      } else {
        return _fallbackImage(species);
      }
    });
  }

  Widget _fallbackImage([String? species]) {
    final assetName = species != null && species.isNotEmpty ? species : 'lion';
    return Image.asset(
      'assets/images/mascot_$assetName.png',
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(
          'assets/images/mascot_lion.png',
          width: width,
          height: height,
          fit: fit,
        );
      },
    );
  }
}
