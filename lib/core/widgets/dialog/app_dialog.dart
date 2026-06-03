import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../util/screen_size.dart';
import '../buttons/app_button.dart';
import '../text/app_text.dart';

class AppDialog extends StatelessWidget {
  final String? title;
  final String? description;
  final String? confirmText;
  final String? cancelText;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const AppDialog({
    super.key,
    required this.onConfirm,
    required this.onCancel,
    this.title,
    this.description,
    this.confirmText,
    this.cancelText,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.w(20))),
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.symmetric(
        horizontal: context.isTabletDevice
            ? context.screenWidth * 0.30
            : context.w(24),
        vertical: context.h(40),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: context.w(28),
          vertical: context.h(32),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Title ──────────────────────────────────────────────────
            AppText(
              data: title ?? 'Confirm',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1F2A44),
              googleFontFamily: GoogleFonts.jost,
            ),

            SizedBox(height: context.h(12)),

            // ── Description ────────────────────────────────────────────
            AppText(
              data: description ?? 'Are you sure?',
              fontSize: 14,
              color: Colors.grey.shade600,
              maxLines: 4,
              height: 1.5,
              googleFontFamily: GoogleFonts.jost,

            ),

            SizedBox(height: context.h(32)),

            // ── Actions ────────────────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    buttonText: cancelText ?? 'Cancel',
                    onPressed: onCancel,
                    fillColor: Colors.transparent,
                    borderColor: Colors.grey.shade300,
                    borderWidth: 1,
                    textColor: Colors.grey.shade600,
                    borderRadius: 12,
                    buttonHeight: 52,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: context.w(12)),
                Expanded(
                  child: AppButton(
                    buttonText: confirmText ?? 'Confirm',
                    onPressed: onConfirm,
                    fillColor: Colors.red,
                    borderRadius: 12,
                    buttonHeight: 52,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}