class ChatMessage {
  final String id;
  final String text;
  final String sender; // 'me', 'supervisor', 'system'
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.text,
    required this.sender,
    required this.timestamp,
  });
}
