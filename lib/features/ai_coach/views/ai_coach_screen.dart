import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/util/app_navigation.dart';
import '../../../core/util/screen_size.dart';
import '../../../core/widgets/avatar/avatar_display_widget.dart';
import '../../../core/widgets/text/app_text.dart';
import '../../profile/views/profile_screen.dart';
import '../controllers/ai_coach_controller.dart';
import 'package:get/get.dart';

import '../widgets/ai_coach_widgets.dart';


class AiCoachScreen extends StatelessWidget {
  const AiCoachScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<AiCoachController>()
        ? Get.find<AiCoachController>()
        : Get.put(AiCoachController());

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _AiCoachAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                final messages = controller.messages;
                final isTyping = controller.isTyping.value;

                return ListView.builder(
                  controller: controller.scrollController,
                  padding: EdgeInsets.symmetric(
                    horizontal: context.w(16),
                    vertical: context.h(16),
                  ),
                  itemCount: messages.length + (isTyping ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (isTyping && index == messages.length) {
                      return _TypingIndicator();
                    }
                    final message = messages[index];
                    return message.isUser
                        ? _UserBubble(message: message)
                        : AiBubble(message: message);
                  },
                );
              }),
            ),
            _MessageInput(controller: controller),
          ],
        ),
      ),
    );
  }
}

class _AiCoachAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: kToolbarHeight + context.h(8),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: context.w(16)),
            child: Row(
              children: [

                SizedBox(width: context.w(42)),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppText(
                        data: 'AI Coach',
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: context.w(8),
                            height: context.w(8),
                            decoration: const BoxDecoration(
                              color: Color(0xFF4CAF50),
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: context.w(6)),
                          AppText(
                            data: 'Online',
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: Colors.white54,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {

                  },
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Icon(Icons.notifications_outlined, color: Colors.white, size: context.sp(26)),
                      Positioned(
                        right: -2,
                        top: -2,
                        child: Container(
                          width: context.w(8),
                          height: context.w(8),
                          decoration: const BoxDecoration(
                            color: Color(0xFF4CAF50),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: context.w(12)),
                GestureDetector(
                  onTap: () {
                    AppNavigation.push(const ProfileScreen(),context: context);
                  },
                  child: Container(
                    width: context.w(40),
                    height: context.w(40),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFF5A623), width: 2),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/avatar.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 8);
}

class _UserBubble extends StatelessWidget {
  final ChatMessage message;
  const _UserBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.h(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(width: context.w(40)),
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: context.w(16),
                vertical: context.h(14),
              ),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                  bottomLeft: Radius.circular(18),
                  bottomRight: Radius.circular(4),
                ),
                border: Border.all(color: const Color(0xFFF5A623), width: 1.5),
              ),
              child: AppText(
                data: message.text,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: const Color(0xFFF5A623),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TypingIndicator extends StatefulWidget {
  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _animation = Tween(begin: 0.3, end: 1.0).animate(_animController);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.h(20)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: context.w(38),
            height: context.w(38),
            margin: EdgeInsets.only(right: context.w(10)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(context.w(19)),
              child: AvatarDisplayWidget(
                fit: BoxFit.contain,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: context.w(16),
              vertical: context.h(14),
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomRight: Radius.circular(18),
                bottomLeft: Radius.circular(4),
              ),
              border: Border.all(color: Colors.white12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (i) {
                return AnimatedBuilder(
                  animation: _animController,
                  builder: (_, _) {
                    final delay = i * 0.3;
                    final value = ((_animation.value - delay).clamp(0.0, 1.0));
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: context.w(3)),
                      width: context.w(8),
                      height: context.w(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(value),
                      ),
                    );
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageInput extends StatelessWidget {
  final AiCoachController controller;
  const _MessageInput({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: EdgeInsets.fromLTRB(
        context.w(16),
        context.h(8),
        context.w(16),
        context.h(24),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(context.w(30)),
          border: Border.all(color: Colors.white24),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller.messageController,
                style: GoogleFonts.nunito(
                  color: Colors.white,
                  fontSize: context.sp(15),
                ),
                onSubmitted: (_) => controller.sendMessage(),
                decoration: InputDecoration(
                  hintText: 'Type your message...',
                  hintStyle: GoogleFonts.nunito(
                    color: Colors.white38,
                    fontSize: context.sp(15),
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: context.w(20),
                    vertical: context.h(14),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: context.w(6)),
              child: GestureDetector(
                onTap: controller.sendMessage,
                child: Container(
                  width: context.w(42),
                  height: context.w(42),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF5A623),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}