import 'package:flutter/material.dart';

import '../../util/screen_size.dart';
import '../text/app_text.dart';


class BuildAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Color? titleColor;
  final Color? iconColor;
  final bool showSideButton;
  final VoidCallback? onSideButtonPressed;
  final IconData sideButtonIcon;
  final bool showBackButton;
  final Color? backgroundColor;
  final double? titleFontSize;
  final FontWeight? fontWeight;
  final VoidCallback? onBackButtonPressed;

  const BuildAppBar({
    super.key,
    this.title,
    this.titleColor,
    this.iconColor,
    this.showSideButton = false,
    this.onSideButtonPressed,
    this.sideButtonIcon = Icons.notifications_none_rounded,
    this.showBackButton = true,
    this.backgroundColor,
    this.titleFontSize,
    this.fontWeight,
    this.onBackButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor ?? Colors.transparent,
      child: SafeArea(
        bottom: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.responsiveSize(16),
                vertical: context.responsiveSize(12),
              ),
              child: Row(
                children: [
                  showBackButton
                      ? GestureDetector(
                    onTap: onBackButtonPressed ?? () => Navigator.pop(context),
                    child: Padding(
                      padding: EdgeInsets.only(right: context.responsiveSize(8)),
                      child: Icon(
                        Icons.chevron_left,
                        size: context.responsiveSize(32),
                        color: iconColor ?? Colors.black87,
                      ),
                    ),
                  )
                      : SizedBox(width: context.responsiveSize(32)),

                  Expanded(
                    child: title != null
                        ? AppText(
                      data: title!,
                      fontSize: titleFontSize ?? 20,
                      fontWeight: fontWeight ?? FontWeight.w600,
                      color: titleColor ?? Colors.black87,
                      useResponsiveFontSize: true,
                      textAlign: TextAlign.center,
                    )
                        : const SizedBox.shrink(),
                  ),

                  showSideButton
                      ? GestureDetector(
                    onTap: onSideButtonPressed,
                    child: Icon(
                      sideButtonIcon,
                      size: context.responsiveSize(28),
                      color: iconColor ?? Colors.black87,
                    ),
                  )
                      : SizedBox(width: context.responsiveSize(32)),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 0.8,
              color: Colors.black12,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

}