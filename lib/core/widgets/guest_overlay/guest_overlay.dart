//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../features/auth/sign_in/views/sign_in_screen.dart';
// import '../../../features/auth/sign_up/views/sign_up_screen.dart';
// import '../../util/screen_size.dart';
// import '../../util/storage_service.dart';
// import '../text/app_text.dart';
//
// import 'dart:ui';
//
// class GuestOverlay extends StatelessWidget {
//   final Widget child;
//
//   const GuestOverlay({
//     super.key,
//     required this.child,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     if (StorageService.hasToken) {
//       return child;
//     }
//
//     return Stack(
//       children: [
//         // Original page
//         child,
//
//         // Dark frosted background (iOS style - dark tint)
//         Positioned.fill(
//           child: BackdropFilter(
//             filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
//             child: Container(
//               color: Colors.black.withOpacity(0.4),
//             ),
//           ),
//         ),
//
//         // Frosted glass card
//         SafeArea(
//           child: Center(
//             child: Padding(
//               padding: EdgeInsets.symmetric(
//                 horizontal: context.responsiveSize(28),
//               ),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(
//                   context.responsiveSize(28),
//                 ),
//                 child: BackdropFilter(
//                   filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
//                   child: Container(
//                     padding: EdgeInsets.all(context.responsiveSize(28)),
//                     decoration: BoxDecoration(
//                       // iOS dark frosted material
//                       gradient: LinearGradient(
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                         colors: [
//                           Colors.black.withOpacity(0.18),
//                           Colors.black.withOpacity(0.08),
//                         ],
//                       ),
//                       borderRadius: BorderRadius.circular(
//                         context.responsiveSize(28),
//                       ),
//                       border: Border.all(
//                         color: Colors.white.withOpacity(0.15),
//                         width: 0.5,
//                       ),
//                     ),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         // Lock icon - frosted circle
//                         ClipOval(
//                           child: BackdropFilter(
//                             filter: ImageFilter.blur(
//                               sigmaX: 15,
//                               sigmaY: 15,
//                             ),
//                             child: Container(
//                               width: context.responsiveSize(68),
//                               height: context.responsiveSize(68),
//                               decoration: BoxDecoration(
//                                 color: Colors.white.withOpacity(0.12),
//                                 shape: BoxShape.circle,
//                                 border: Border.all(
//                                   color: Colors.white.withOpacity(0.15),
//                                   width: 0.5,
//                                 ),
//                               ),
//                               child: Center(
//                                 child: Icon(
//                                   Icons.lock_outline_rounded,
//                                   size: context.responsiveSize(32),
//                                   color: const Color(0xFFE8A838),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//
//                         SizedBox(height: context.responsiveSize(20)),
//
//                         // Title
//                         AppText(
//                           data: 'Login Required',
//                           fontSize: 22,
//                           fontWeight: FontWeight.w700,
//                           color: Colors.white,
//                           useResponsiveFontSize: true,
//                           textAlign: TextAlign.center,
//                         ),
//
//                         SizedBox(height: context.responsiveSize(8)),
//
//                         // Description
//                         AppText(
//                           data:
//                           'You are in guest mode. Sign in or create an account to unlock all features and track your progress.',
//                           fontSize: 14,
//                           fontWeight: FontWeight.w500,
//                           color: Colors.white.withOpacity(0.6),
//                           useResponsiveFontSize: true,
//                           textAlign: TextAlign.center,
//                         ),
//
//                         SizedBox(height: context.responsiveSize(28)),
//
//                         // Sign In Button - iOS vibrant style
//                         GestureDetector(
//                           onTap: () {
//                             Get.to(() => SignInScreen());
//                           },
//                           child: ClipRRect(
//                             borderRadius: BorderRadius.circular(
//                               context.responsiveSize(14),
//                             ),
//                             child: BackdropFilter(
//                               filter: ImageFilter.blur(
//                                 sigmaX: 10,
//                                 sigmaY: 10,
//                               ),
//                               child: Container(
//                                 width: double.infinity,
//                                 height: context.responsiveSize(52),
//                                 decoration: BoxDecoration(
//                                   color: const Color(0xFF4CB8B3)
//                                       .withOpacity(0.85),
//                                   borderRadius: BorderRadius.circular(
//                                     context.responsiveSize(14),
//                                   ),
//                                 ),
//                                 child: Center(
//                                   child: AppText(
//                                     data: 'Sign in',
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w600,
//                                     color: Colors.white,
//                                     useResponsiveFontSize: true,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//
//                         SizedBox(height: context.responsiveSize(10)),
//
//                         // Create Account - iOS secondary glass button
//                         GestureDetector(
//                           onTap: () {
//                             Get.to(() => SignUpScreen());
//                           },
//                           child: ClipRRect(
//                             borderRadius: BorderRadius.circular(
//                               context.responsiveSize(14),
//                             ),
//                             child: BackdropFilter(
//                               filter: ImageFilter.blur(
//                                 sigmaX: 10,
//                                 sigmaY: 10,
//                               ),
//                               child: Container(
//                                 width: double.infinity,
//                                 height: context.responsiveSize(52),
//                                 decoration: BoxDecoration(
//                                   color: Colors.white.withOpacity(0.12),
//                                   borderRadius: BorderRadius.circular(
//                                     context.responsiveSize(14),
//                                   ),
//                                   border: Border.all(
//                                     color: Colors.white.withOpacity(0.12),
//                                     width: 0.5,
//                                   ),
//                                 ),
//                                 child: Center(
//                                   child: AppText(
//                                     data: 'Create an account',
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w500,
//                                     color: Colors.white.withOpacity(0.9),
//                                     useResponsiveFontSize: true,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }