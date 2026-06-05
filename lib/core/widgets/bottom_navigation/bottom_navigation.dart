import 'package:flutter/material.dart';
import '../../util/screen_size.dart';



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
      Icons.home_rounded,
      Icons.grid_view_rounded,
      Icons.chat_bubble_outline_rounded,
      Icons.pie_chart_outline_rounded,
      Icons.bar_chart_rounded,
      Icons.emoji_events_outlined,
    ];

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          context.w(16),
          context.h(8),
          context.w(16),
          context.h(16),
        ),
        child: Container(
          height: context.h(68),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(context.w(50)),
            border: Border.all(color: Colors.white12, width: 1),
          ),
          padding: EdgeInsets.symmetric(horizontal: context.w(8)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (index) {
              final isSelected = currentIndex == index;

              return GestureDetector(
                onTap: () => onTabSelected(index),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  width: context.w(isSelected ? 52 : 40),
                  height: context.w(isSelected ? 52 : 40),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFFF5A623)
                        : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    items[index],
                    size: context.sp(isSelected ? 24 : 22),
                    color: Colors.white,
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