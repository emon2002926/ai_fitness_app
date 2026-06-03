import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../util/screen_size.dart';


import '../text/app_text.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabSelected;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      {'icon': Icons.home_outlined, 'label': 'Home'},
      {'icon': Icons.history_outlined, 'label': 'Workout'},
      {'icon': Icons.person_outline, 'label': 'Ai Coach'},
      {'icon': Icons.settings_outlined, 'label': 'Nutrition'},
      {'icon': Icons.settings_outlined, 'label': 'Levels '},
      {'icon': Icons.settings_outlined, 'label': 'Progress'},
    ];

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF0EFE9),
        border: Border(
          top: BorderSide(color: Color(0xFFE0DDD7), width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: context.h(64),
          child: Row(
            children: List.generate(items.length, (index) {
              final isSelected = currentIndex == index;
              final label = items[index]['label'] as String;
              final icon = items[index]['icon'] as IconData;

              return Expanded(
                child: GestureDetector(
                  onTap: () => onTabSelected(index),
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        icon,
                        size: context.sp(24),
                        color: isSelected
                            ? const Color(0xFF3D7060)
                            : const Color(0xFFB0ADA8),
                      ),
                      SizedBox(height: context.h(4)),
                      // AppText(
                      //   data: label,
                      //   fontSize: 13,
                      //   googleFontFamily: GoogleFonts.jost,
                      //
                      //   fontWeight: isSelected
                      //       ? FontWeight.w700
                      //       : FontWeight.w400,
                      //   color: isSelected
                      //       ? const Color(0xFF3D7060)
                      //       : const Color(0xFFB0ADA8),
                      // ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}