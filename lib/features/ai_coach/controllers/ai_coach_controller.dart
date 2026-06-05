import 'package:get/get.dart';
import 'package:flutter/material.dart';
class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime time;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.time,
  });
}

class AiCoachController extends GetxController {
  final messageController = TextEditingController();
  final scrollController = ScrollController();
  final messages = <ChatMessage>[].obs;
  final isTyping = false.obs;
  final isSending = false.obs;

  @override
  void onReady() {
    super.onReady();
    messages.add(ChatMessage(
      text: 'Hi Alex! 👋',
      isUser: false,
      time: DateTime.now(),
    ));
  }

  Future<void> sendMessage() async {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    messageController.clear();
    messages.add(ChatMessage(text: text, isUser: true, time: DateTime.now()));
    _scrollToBottom();

    isTyping.value = true;
    await Future.delayed(const Duration(milliseconds: 1200));
    isTyping.value = false;

    // TODO: replace with real API call
    messages.add(ChatMessage(
      text: 'Great goal! I\'ll adjust your plan for a balanced approach.\n\n      Increase protein intake Strength training 4x/week Stay consistent with cardio',
      isUser: false,
      time: DateTime.now(),
    ));
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void onClose() {
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
