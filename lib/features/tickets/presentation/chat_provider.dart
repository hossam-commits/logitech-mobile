import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:logitech_mobile/features/tickets/domain/chat_message.dart';
import 'package:logitech_mobile/features/tickets/presentation/chat_notifier.dart';

final chatProvider = NotifierProvider<ChatNotifier, List<ChatMessage>>(
  ChatNotifier.new,
);
