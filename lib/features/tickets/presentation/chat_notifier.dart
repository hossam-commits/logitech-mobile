import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/chat_message.dart';
import '../../../core/constants/mock_messages.dart';

class ChatNotifier extends StateNotifier<List<ChatMessage>> {
  ChatNotifier() : super([]) {
    state = MOCK_MESSAGES
        .map(
          (m) => ChatMessage(
            id: DateTime.now().toString(),
            text: m['text'],
            sender: m['sender'],
            timestamp:
                DateTime.now().subtract(const Duration(minutes: 10)),
          ),
        )
        .toList();
  }

  void sendMessage(String text) {
    if (text.trim().isEmpty) return;
    final msg = ChatMessage(
      id: DateTime.now().toString(),
      text: text,
      sender: 'me',
      timestamp: DateTime.now(),
    );
    state = [...state, msg];

    Future.delayed(const Duration(seconds: 2), () {
      final reply = ChatMessage(
        id: DateTime.now().toString(),
        text: '‘ﬂ—«° ”‰ﬁÊ„ »„ «»⁄… «·√„—.',
        sender: 'supervisor',
        timestamp: DateTime.now(),
      );
      if (mounted) {
        state = [...state, reply];
      }
    });
  }
}
