import 'package:flutter/material.dart';
import '../../../core/util/screen_size.dart';
import '../../../core/widgets/text/app_text.dart';
import '../controllers/ai_coach_controller.dart';
const _accent = Color(0xFFF5A623);
const _cardBg = Color(0xFF1A1A1A);
const _cardBorder = Colors.white12;

const Map<String, String> _mealEmojis = {
  'breakfast': '🍳',
  'lunch': '🥗',
  'dinner': '🍽️',
  'snack': '🍎',
};

class MealPlanMessage extends StatelessWidget {
  final List<MealPlanEntry> entries;
  const MealPlanMessage({super.key, required this.entries});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < entries.length; i++) ...[
          _MealCard(entry: entries[i]),
          if (i != entries.length - 1) SizedBox(height: context.h(10)),
        ],
      ],
    );
  }
}

class _MealCard extends StatelessWidget {
  final MealPlanEntry entry;
  const _MealCard({required this.entry});

  @override
  Widget build(BuildContext context) {
    final emoji = _mealEmojis[entry.mealType.toLowerCase()] ?? '🍴';
    final title = entry.mealType.isNotEmpty
        ? '${entry.mealType[0].toUpperCase()}${entry.mealType.substring(1)}'
        : entry.mealType;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.w(14)),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: context.w(30),
                height: context.w(30),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _accent.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: AppText(
                  data: emoji,
                  fontSize: 15,
                  useResponsiveFontSize: false,
                ),
              ),
              SizedBox(width: context.w(8)),
              AppText(
                data: title,
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: _accent,
              ),
            ],
          ),
          if (entry.items.isNotEmpty) ...[
            SizedBox(height: context.h(8)),
            AppText(
              data: entry.items.join(', '),
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              maxLines: 3,
              overflow: TextOverflow.visible,
            ),
          ],
          if (entry.calories != null ||
              entry.protein != null ||
              entry.carbs != null ||
              entry.fat != null ||
              entry.cookingTime != null) ...[
            SizedBox(height: context.h(10)),
            Wrap(
              spacing: context.w(6),
              runSpacing: context.h(6),
              children: [
                if (entry.calories != null) _MacroChip(label: '🔥 ${entry.calories}'),
                if (entry.protein != null) _MacroChip(label: '💪 ${entry.protein} protein'),
                if (entry.carbs != null) _MacroChip(label: '🌾 ${entry.carbs} carbs'),
                if (entry.fat != null) _MacroChip(label: '🥑 ${entry.fat} fat'),
                if (entry.cookingTime != null) _MacroChip(label: '⏱ ${entry.cookingTime}'),
              ],
            ),
          ],
          if (entry.ingredients.isNotEmpty) ...[
            SizedBox(height: context.h(12)),
            AppText(
              data: 'Ingredients',
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Colors.white54,
              latterSpacing: 0.4,
            ),
            SizedBox(height: context.h(6)),
            ...entry.ingredients.map(
                  (ingredient) => Padding(
                padding: EdgeInsets.only(bottom: context.h(4)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: context.h(7), right: context.w(8)),
                      child: Container(
                        width: 4,
                        height: 4,
                        decoration: const BoxDecoration(
                          color: _accent,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Expanded(
                      child: AppText(
                        data: ingredient,
                        fontSize: 13,
                        color: Colors.white70,
                        height: 1.4,
                        maxLines: 4,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          if (entry.cookingSteps.isNotEmpty) ...[
            SizedBox(height: context.h(12)),
            AppText(
              data: 'Steps',
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Colors.white54,
              latterSpacing: 0.4,
            ),
            SizedBox(height: context.h(6)),
            ...List.generate(entry.cookingSteps.length, (i) {
              return Padding(
                padding: EdgeInsets.only(bottom: context.h(6)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: context.w(18),
                      height: context.w(18),
                      margin: EdgeInsets.only(top: context.h(1), right: context.w(8)),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        shape: BoxShape.circle,
                      ),
                      child: AppText(
                        data: '${i + 1}',
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Colors.white70,
                        useResponsiveFontSize: false,
                      ),
                    ),
                    Expanded(
                      child: AppText(
                        data: entry.cookingSteps[i],
                        fontSize: 13,
                        color: Colors.white70,
                        height: 1.4,
                        maxLines: 6,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ],
      ),
    );
  }
}

class _MacroChip extends StatelessWidget {
  final String label;
  const _MacroChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: context.w(9), vertical: context.h(5)),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white12),
      ),
      child: AppText(
        data: label,
        fontSize: 11,
        color: Colors.white70,
        useResponsiveFontSize: false,
      ),
    );
  }
}

class AiBubble extends StatelessWidget {
  final ChatMessage message;
  const AiBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isMealPlan = message.mealPlan != null && message.mealPlan!.isNotEmpty;

    return Padding(
      padding: EdgeInsets.only(bottom: context.h(20)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: context.w(38),
            height: context.w(38),
            margin: EdgeInsets.only(right: context.w(10)),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage('assets/images/mascot_avatar.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Flexible(
            child: isMealPlan
                ? MealPlanMessage(entries: message.mealPlan!)
                : Container(
              padding: EdgeInsets.symmetric(
                horizontal: context.w(16),
                vertical: context.h(14),
              ),
              decoration: BoxDecoration(
                color: _cardBg,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                  bottomLeft: Radius.circular(4),
                ),
                border: Border.all(color: _cardBorder),
              ),
              child: AppText(
                data: message.text,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.white,
                height: 1.5,
                maxLines: 100,
                overflow: TextOverflow.visible,
              ),
            ),
          ),
          SizedBox(width: context.w(40)),
        ],
      ),
    );
  }
}