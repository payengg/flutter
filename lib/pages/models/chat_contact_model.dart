// lib/pages/models/chat_contact_model.dart

class ChatContact {
  final String name;
  final String lastMessage;
  final String imageUrl;
  final String time;
  final int unreadCount;

  ChatContact({
    required this.name,
    required this.lastMessage,
    required this.imageUrl,
    required this.time,
    required this.unreadCount,
  });
}