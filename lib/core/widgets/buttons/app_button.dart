import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../util/screen_size.dart';
import '../text/app_text.dart';


class AppButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback? onPressed;
  final Color? textColor;
  final double? borderRadius;
  final double? fontSize;
  final double? buttonHeight;
  final double? buttonWidth;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final FontWeight? fontWeight;
  final bool isLoading;
  final String? loadingText;
  final double? elevation;
  final Color? fillColor;
  final Color? borderColor;
  final double? borderWidth;
  final bool useResponsiveSize;

  const AppButton({
    super.key,
    required this.buttonText,
    required this.onPressed,
    this.textColor,
    this.borderRadius,
    this.fontSize,
    this.buttonHeight,
    this.buttonWidth,
    this.prefixIcon,
    this.suffixIcon,
    this.fontWeight,
    this.isLoading = false,
    this.loadingText,
    this.elevation,
    this.fillColor,
    this.borderColor,
    this.borderWidth,
    this.useResponsiveSize = true,
  });

  @override
  Widget build(BuildContext context) {
    // ✅ Use ScreenSize extension — clamped for tablets
    final double resolvedRadius = useResponsiveSize
        ? context.w(borderRadius ?? 15)
        : (borderRadius ?? 15);

    final double resolvedHeight = useResponsiveSize
        ? context.h(buttonHeight ?? 50)
        : (buttonHeight ?? 50);

    final double resolvedFontSize = useResponsiveSize
        ? context.sp(fontSize ?? 16)
        : (fontSize ?? 16);

    final double resolvedIconSize = useResponsiveSize
        ? context.sp(fontSize ?? 24)
        : (fontSize ?? 24);

    final bool isDisabled = onPressed == null || isLoading;

    return SizedBox(
      width: buttonWidth ?? double.infinity,
      height: resolvedHeight,
      child: Opacity(
        opacity: isDisabled ? 0.6 : 1.0,
        child: Container(
          decoration: BoxDecoration(
            color: fillColor ?? const Color(0xFFBC9041),
            borderRadius: BorderRadius.circular(resolvedRadius),
            border: Border.all(
              color: borderColor ?? Colors.transparent,
              width: borderWidth ?? 0,
            ),
          ),
          child: ElevatedButton(
            onPressed: isDisabled ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              elevation: elevation ?? 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(resolvedRadius),
              ),
              padding: EdgeInsets.zero,
              disabledBackgroundColor: Colors.transparent,
            ),
            child: isLoading
                ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: context.h(20),
                  width: context.w(20),
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(
                        textColor ?? Colors.white),
                    strokeWidth: 2.5,
                  ),
                ),
                if (loadingText != null) ...[
                  SizedBox(width: context.w(12)),
                  Text(
                    loadingText!,
                    style: TextStyle(
                      color: textColor ?? Colors.white,
                      fontSize: resolvedFontSize,
                      fontWeight: fontWeight ?? FontWeight.w600,
                    ),
                  ),
                ],
              ],
            )
                : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (prefixIcon != null) ...[
                  Icon(prefixIcon,
                      color: textColor ?? Colors.white,
                      size: resolvedIconSize),
                  SizedBox(width: context.w(8)),
                ],
                AppText(
                  data: buttonText,
                  color: textColor ?? Colors.white,
                  fontSize: fontSize ?? 16,
                  fontWeight: fontWeight ?? FontWeight.w600,
                  useResponsiveFontSize: useResponsiveSize,
                ),
                if (suffixIcon != null) ...[
                  SizedBox(width: context.w(8)),
                  Icon(suffixIcon,
                      color: textColor ?? Colors.white,
                      size: resolvedIconSize),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Loading Overlay ───────────────────────────────────────────────────────
  static Widget buildLoadingOverlay({
    required RxBool isLoading,
    required String loadingMessage,
    Color? backgroundColor,
    Color? cardColor,
  }) {
    return Obx(
          () => isLoading.value
          ? Container(
        color: (backgroundColor ?? Colors.black).withOpacity(0.5),
        child: Center(
          child: Builder(
            builder: (context) => Container(
              padding: EdgeInsets.all(context.w(24)),
              margin: EdgeInsets.symmetric(horizontal: context.w(40)),
              decoration: BoxDecoration(
                color: cardColor ?? const Color(0xFFF5F5DC),
                borderRadius: BorderRadius.circular(context.w(16)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: context.w(40),
                    width: context.w(40),
                    child: const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(
                          Color(0xFF9B7EBD)),
                      strokeWidth: 3,
                    ),
                  ),
                  SizedBox(height: context.h(20)),
                  Text(
                    loadingMessage,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: context.sp(16),
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF4A4A4A),
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      )
          : const SizedBox.shrink(),
    );
  }
}