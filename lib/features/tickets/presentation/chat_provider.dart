import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/chat_message.dart';
import 'chat_notifier.dart';

final chatProvider = StateNotifierProvider<ChatNotifier, List<ChatMessage>>(
  (ref) => ChatNotifier(),
);
