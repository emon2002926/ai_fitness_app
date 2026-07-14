import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/util/screen_size.dart';
import '../../../core/widgets/app_bar/build_app_bar.dart';
import '../../../core/widgets/buttons/app_button.dart';
import '../../../core/widgets/text/app_text.dart';
import '../controllers/cooking_steps_controller.dart';
import '../controllers/nutrition_controller.dart';

class CookingStepsScreen extends StatelessWidget {
  final MealItem meal;

  const CookingStepsScreen({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CookingStepsController(meal: meal));

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: BuildAppBar(
        title: 'Cooking Steps',
        showNotification: true,
        avatarUrl: 'assets/images/avatar.png',
        onNotificationPressed: () {},
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _HeroImage(meal: meal, controller: controller),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: context.w(20)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: context.h(16)),
                            _MetaRow(meal: meal),
                            SizedBox(height: context.h(16)),
                            _MacroPills(meal: meal),
                            SizedBox(height: context.h(28)),
                            _SectionTitle(title: 'Ingredients'),
                            SizedBox(height: context.h(16)),
                            ...controller.ingredients.map((i) => _IngredientRow(ingredient: i)),
                            SizedBox(height: context.h(28)),
                            _SectionTitle(title: 'Cooking Steps'),
                            SizedBox(height: context.h(16)),
                            ...controller.steps.map((s) => _StepRow(step: s)),
                            SizedBox(height: context.h(24)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            _LogMealButton(controller: controller),
          ],
        ),
      ),
    );
  }
}

class _HeroImage extends StatelessWidget {
  final MealItem meal;
  final CookingStepsController controller;

  const _HeroImage({required this.meal, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: context.h(280),
      child: Image.asset(
        "assets/images/recipe.png",
        width: double.infinity,
        height: context.h(280),
        fit: BoxFit.cover,
      ),
    );
  }
}


class _MetaRow extends StatelessWidget {
  final MealItem meal;
  const _MetaRow({required this.meal});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CookingStepsController>();

    return Row(
      children: [
        Text('⏱️', style: TextStyle(fontSize: context.sp(16))),
        SizedBox(width: context.w(6)),
        AppText(
          data: '${meal.minutes} min',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.white70,
        ),
        const Spacer(),
        Text('🔥', style: TextStyle(fontSize: context.sp(16))),
        SizedBox(width: context.w(6)),
        AppText(
          data: '${meal.kcal} Cal',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.white70,
        ),
        SizedBox(width: context.w(16)),
        Obx(() => GestureDetector(
              onTap: controller.toggleFavorite,
              child: Container(
                width: context.w(36),
                height: context.w(36),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white24),
                ),
                child: Icon(
                  controller.isFavorite.value
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  color: controller.isFavorite.value
                      ? const Color(0xFFF5A623)
                      : Colors.white54,
                  size: context.sp(18),
                ),
              ),
            )),
      ],
    );
  }
}



class _MacroPills extends StatelessWidget {
  final MealItem meal;
  const _MacroPills({required this.meal});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _MacroPill(emoji: '🍗', label: 'Protein', value: meal.protein)),
        SizedBox(width: context.w(10)),
        Expanded(child: _MacroPill(emoji: '🌾', label: 'Carbs',   value: meal.carbs)),
        SizedBox(width: context.w(10)),
        Expanded(child: _MacroPill(emoji: '🥩', label: 'Fat',     value: meal.fat)),
      ],
    );
  }
}
class _MacroPill extends StatelessWidget {
  final String emoji;
  final String label;
  final int value;

  const _MacroPill({
    required this.emoji,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.w(14),
        vertical: context.h(10),
      ),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(context.w(10)),
        border: Border.all(color: Colors.white70),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: TextStyle(fontSize: context.sp(14))),
          SizedBox(width: context.w(6)),
          Flexible(
            child: AppText(
              data: label,
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.white,
              maxLines: 1,                 // ✅ AppText supports these
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: context.w(8)),
          AppText(
            data: '$value',
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}



class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AppText(
        data: title,
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
    );
  }
}



class _IngredientRow extends StatelessWidget {
  final Ingredient ingredient;
  const _IngredientRow({required this.ingredient});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: context.h(10)),
      padding: EdgeInsets.symmetric(
        horizontal: context.w(14),
        vertical: context.h(12),
      ),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(context.w(14)),
        border: Border.all(color: Colors.white70),
      ),
      child: Row(
        children: [
          Container(
            width: context.w(48),
            height: context.w(48),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(context.w(10)),
            ),
            child: Padding(
              padding: EdgeInsets.all(context.w(6)),
              child: Image.asset(ingredient.image, fit: BoxFit.contain),
            ),
          ),
          SizedBox(width: context.w(16)),
          Expanded(
            child: AppText(
              data: ingredient.name,
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.white70,
            ),
          ),
          AppText(
            data: ingredient.amount,
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.white70,
          ),
        ],
      ),
    );
  }
}


class _StepRow extends StatelessWidget {
  final CookingStep step;
  const _StepRow({required this.step});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: context.h(12)),
      padding: EdgeInsets.all(context.w(16)),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(context.w(14)),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: context.w(28),
            height: context.w(28),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: step.isDone ? const Color(0xFFF5A623) : Colors.transparent,
              border: Border.all(
                color: step.isDone ? const Color(0xFFF5A623) : Colors.white38,
                width: 1.5,
              ),
            ),
            alignment: Alignment.center,
            child: AppText(
              data: '${step.number}',
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          SizedBox(width: context.w(14)),
          Expanded(
            child: AppText(
              data: step.description,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: step.isDone ? Colors.white24 : Colors.white,
              decoration: step.isDone ? TextDecoration.lineThrough : null,
              decorationColor: Colors.white24,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}


class _LogMealButton extends StatelessWidget {
  final CookingStepsController controller;
  const _LogMealButton({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: EdgeInsets.fromLTRB(
        context.w(20),
        context.h(8),
        context.w(20),
        context.h(32),
      ),
      child: AppButton(
        buttonText: 'LOG MEAL',
        onPressed: () => controller.logMeal(context),
        fillColor: const Color(0xFFF5A623),
        textColor: Colors.white,
        fontSize: 15,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
