import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/util/app_log.dart';
import '../../../core/util/storage_service.dart';
import '../../../core/widgets/snakbar/custom_snackbar.dart';


class MealPlanEntry {
  final String mealType;
  final List<String> items;
  final List<String> ingredients;
  final List<String> cookingSteps;
  final String? cookingTime;
  final String? calories;
  final String? protein;
  final String? carbs;
  final String? fat;

  MealPlanEntry({
    required this.mealType,
    required this.items,
    required this.ingredients,
    required this.cookingSteps,
    this.cookingTime,
    this.calories,
    this.protein,
    this.carbs,
    this.fat,
  });

  bool get hasContent => items.isNotEmpty || ingredients.isNotEmpty || cookingSteps.isNotEmpty;

  factory MealPlanEntry.fromJson(String mealType, Map<String, dynamic> json) {
    List<String> asStringList(dynamic value) {
      if (value is List) {
        return value.map((e) => e.toString()).where((e) => e.trim().isNotEmpty).toList();
      }
      return [];
    }

    String? asNonEmptyString(dynamic value) {
      final str = value?.toString().trim();
      return (str == null || str.isEmpty) ? null : str;
    }

    return MealPlanEntry(
      mealType: mealType,
      items: asStringList(json['items']),
      ingredients: asStringList(json['ingredients']),
      cookingSteps: asStringList(json['cooking_steps']),
      cookingTime: asNonEmptyString(json['cooking_time']),
      calories: asNonEmptyString(json['calories']),
      protein: asNonEmptyString(json['protein']),
      carbs: asNonEmptyString(json['carbs']),
      fat: asNonEmptyString(json['fat']),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime time;
  final List<MealPlanEntry>? mealPlan;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.time,
    this.mealPlan,
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
    if (isSending.value) return;

    final userText = messageController.text.trim();
    if (userText.isEmpty) return;

    messageController.clear();
    messages.add(ChatMessage(text: userText, isUser: true, time: DateTime.now()));
    _scrollToBottom();

    isSending.value = true;
    isTyping.value = true;

    const endpoint = 'https://lexiapi.dsrt321.online/api/v1/service/chatbot/';
    final body = {'user_input': userText};

    try {
      AppLog.request(endpoint, body: body);

      final response = await http.post(
        Uri.parse(endpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${StorageService.accessToken}',

        },
        body: jsonEncode(body),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        AppLog.response(endpoint, data);
        messages.add(_buildBotMessage(data));
      } else {
        AppLog.error(endpoint, data, statusCode: response.statusCode);

        final message = data['detail'] ?? data['message'] ?? 'Something went wrong';
        CustomSnackBar.error(message);

        messages.add(ChatMessage(
          text: response.statusCode == 401
              ? "Your session has expired. Please log in again to keep chatting."
              : "Hmm, something went wrong on my end. Mind trying that again?",
          isUser: false,
          time: DateTime.now(),
        ));
      }
    } catch (e) {
      AppLog.error(endpoint, e.toString());
      CustomSnackBar.error('Something went wrong. Please try again.');

      messages.add(ChatMessage(
        text: "I couldn't reach the server. Please check your connection and try again.",
        isUser: false,
        time: DateTime.now(),
      ));
    } finally {
      isTyping.value = false;
      isSending.value = false;
      _scrollToBottom();
    }
  }

  static const _knownMealTypes = {'breakfast', 'lunch', 'dinner', 'snack'};

  Map<String, dynamic>? _extractMealPlanMap(Map<String, dynamic>? decoded) {
    if (decoded == null) return null;

    if (decoded['type'] == 'meal_plan') {
      final nested = decoded['meal_plan'];
      if (nested is Map) return Map<String, dynamic>.from(nested);
    }

    final keys = decoded.keys.map((k) => k.toString().toLowerCase());
    final looksLikeMealPlan = keys.any((k) => _knownMealTypes.contains(k));
    if (looksLikeMealPlan) {
      return decoded;
    }

    return null;
  }

  ChatMessage _buildBotMessage(dynamic data) {
    final now = DateTime.now();

    dynamic rawOutput;
    String? topLevelMessage;

    if (data is Map) {
      topLevelMessage = data['message']?.toString();
      final inner = data['data'];
      if (inner is Map) {
        rawOutput = inner['user_output'];
      }
    }

    Map<String, dynamic>? decodedMap;

    if (rawOutput is Map) {
      decodedMap = Map<String, dynamic>.from(rawOutput);
    } else if (rawOutput is String) {
      final trimmed = rawOutput.trim();
      if (trimmed.startsWith('{') || trimmed.startsWith('[')) {
        try {
          final parsed = jsonDecode(trimmed);
          if (parsed is Map<String, dynamic>) decodedMap = parsed;
        } catch (_) {}
      }
    }

    final mealPlanJson = _extractMealPlanMap(decodedMap);
    if (mealPlanJson != null) {
      final entries = mealPlanJson.entries
          .map((e) => MealPlanEntry.fromJson(
        e.key.toString(),
        e.value is Map ? Map<String, dynamic>.from(e.value) : <String, dynamic>{},
      ))
          .where((entry) => entry.hasContent)
          .toList();

      if (entries.isNotEmpty) {
        return ChatMessage(text: '', isUser: false, time: now, mealPlan: entries);
      }
    }

    String fallbackText;
    if (rawOutput is String && rawOutput.trim().isNotEmpty) {
      fallbackText = rawOutput;
    } else if (topLevelMessage != null && topLevelMessage.isNotEmpty) {
      fallbackText = topLevelMessage;
    } else {
      fallbackText = "Sorry, I didn't quite catch that.";
    }

    return ChatMessage(text: fallbackText, isUser: false, time: now);
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