import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:logitech_mobile/core/constants/mock_messages.dart';
import 'package:logitech_mobile/features/tickets/domain/chat_message.dart';

class ChatNotifier extends Notifier<List<ChatMessage>> {
  bool _mounted = true;

  @override
  List<ChatMessage> build() {
    ref.onDispose(() => _mounted = false);
    return mockMessages
        .map(
          (m) => ChatMessage(
            id: DateTime.now().toString(),
            text: m['text'],
            sender: m['sender'],
            timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
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
        text: 'شكراً، سنقوم بمتابعة الأمر.',
        sender: 'supervisor',
        timestamp: DateTime.now(),
      );
      if (_mounted) {
        state = [...state, reply];
      }
    });
  }
}
