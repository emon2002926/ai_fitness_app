
import 'package:flutter/material.dart';

import '../../util/screen_size.dart';
import '../text/app_text.dart';

class TextDivider extends StatelessWidget {
  final String text;
  final Color lineColor;
  final Color textColor;
  final double fontSize;
  final FontWeight fontWeight;

  const TextDivider({
    super.key,
    this.text = 'or',
    this.lineColor = const Color(0xFF2D2D2D),
    this.textColor = const Color(0xFF9E9E9E),
    this.fontSize = 14,
    this.fontWeight = FontWeight.w400,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Container(height: 1, color: lineColor)),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.responsiveSize(16),
          ),
          child: AppText(
            data: text,
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: textColor,
            useResponsiveFontSize: true,
          ),
        ),
        Expanded(child: Container(height: 1, color: lineColor)),
      ],
    );
  }
}