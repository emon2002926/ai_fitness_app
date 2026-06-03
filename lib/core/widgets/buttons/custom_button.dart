import 'package:flutter/material.dart';
import '../../../core/util/screen_size.dart';
import '../../../core/widgets/text/app_text.dart';
import '../../constants/app_assert_image.dart';

class CustomAppButton extends StatelessWidget {
  const CustomAppButton({
    super.key,
    required this.text,
    required this.onTap, this.image, this.textColor, this.fontSize,
  });

  final String text;
  final VoidCallback onTap;
  final String? image;
  final Color? textColor;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          vertical: context.responsiveSize(14),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(context.responsiveSize(8)),
          image: DecorationImage(
            image: AssetImage(image ?? AppAssertImage.instance.greenButtonBg),
            fit: BoxFit.fill,
          ),
        ),
        child: Center(
          child: AppText(
            data: text,
            fontSize:fontSize?? context.responsiveSize(20),
            fontWeight: FontWeight.w700,
            color: textColor??Colors.white,
            useResponsiveFontSize: true,
          ),
        ),
      ),
    );
  }
}