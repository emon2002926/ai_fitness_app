import 'package:ai_fitness_app/core/util/app_navigation.dart';
import 'package:flutter/material.dart';

import '../../../features/profile/views/profile_screen.dart';
import '../../util/screen_size.dart';
import '../text/app_text.dart';


class BuildAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool showBackButton;
  final VoidCallback? onBackButtonPressed;
  final bool showNotification;
  final VoidCallback? onNotificationPressed;
  final String? avatarUrl;
  final VoidCallback? onAvatarPressed;
  final Color? backgroundColor;
  final double? titleFontSize;
  final FontWeight? fontWeight;
  final bool isAssetAvatar;


  const BuildAppBar({
    super.key,
    this.title,
    this.showBackButton = true,
    this.onBackButtonPressed,
    this.showNotification = false,
    this.onNotificationPressed,
    this.avatarUrl,
    this.onAvatarPressed,
    this.backgroundColor,
    this.titleFontSize,
    this.fontWeight,
    this.isAssetAvatar = true,   // default to asset since that's what you use now
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor ?? Colors.black,
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: kToolbarHeight,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: context.w(16)),
            child: Row(
              children: [
                if (showBackButton)
                  GestureDetector(
                    onTap: onBackButtonPressed ?? () => Navigator.pop(context),
                    child: Container(
                      width: context.w(40),
                      height: context.w(40),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF5A623),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  )
                else
                  SizedBox(width: context.w(40)),

                Expanded(
                  child: title != null
                      ? AppText(
                    data: title!,
                    fontSize: titleFontSize ?? 24,
                    fontWeight: fontWeight ?? FontWeight.bold,
                    color: Colors.white,
                    textAlign: TextAlign.center,
                  )
                      : const SizedBox.shrink(),
                ),

                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (showNotification)
                      GestureDetector(
                        onTap: onNotificationPressed,
                        child: Stack(
                          children: [
                            Icon(
                              Icons.notifications_outlined,
                              color: Colors.white,
                              size: context.sp(26),
                            ),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                width: context.w(8),
                                height: context.w(8),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFF5A623),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (showNotification && avatarUrl != null)
                      SizedBox(width: context.w(12)),
                    if (avatarUrl != null)
                      GestureDetector(
                        onTap: onAvatarPressed ?? (){
                          AppNavigation.push(ProfileScreen(), context: context);
                        },
                        child: Container(
                          width: context.w(38),
                          height: context.w(38),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFFF5A623),
                              width: 2,
                            ),
                            image: DecorationImage(
                              image: isAssetAvatar
                                  ? AssetImage("assets/images/avatar.png") as ImageProvider
                                  : NetworkImage(avatarUrl!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      )
                    else if (!showNotification)
                      SizedBox(width: context.w(40)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}