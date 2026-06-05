import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/util/screen_size.dart';
import '../../../core/widgets/text/app_text.dart';

class EditableValueBox extends StatelessWidget {
  final TextEditingController controller;
  final String unit;

  const EditableValueBox({super.key, required this.controller, required this.unit});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: context.w(24),
            vertical: context.h(10),
          ),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white38),
            borderRadius: BorderRadius.circular(context.w(12)),
          ),
          child: IntrinsicWidth(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                fontSize: context.sp(36),
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
                suffix: AppText(
                  data: ' $unit',
                  fontSize: 28,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: context.h(10)),
        AppText(
          data: 'Tap the number to edit',
          fontSize: 13,
          color: Colors.white38,
        ),
      ],
    );
  }
}
class UnitToggle extends StatelessWidget {
  final String leftLabel;
  final String rightLabel;
  final String selected;
  final ValueChanged<String> onChanged;

  const UnitToggle({super.key, 
    required this.leftLabel,
    required this.rightLabel,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _UnitButton(
          label: leftLabel,
          isActive: selected == leftLabel,
          onTap: () => onChanged(leftLabel),
        ),
        _UnitButton(
          label: rightLabel,
          isActive: selected == rightLabel,
          onTap: () => onChanged(rightLabel),
        ),
      ],
    );
  }
}

class _UnitButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _UnitButton({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: context.w(54),
          vertical: context.h(8),
        ),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFF5A623) : Colors.transparent,
          borderRadius: BorderRadius.circular(context.w(10)),
          border: Border.all(
            color: isActive ? const Color(0xFFF5A623) : Colors.white38,
          ),
        ),
        child: AppText(
          data: label,
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }
}


