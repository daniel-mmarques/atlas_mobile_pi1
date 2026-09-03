import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.text,
    required this.senderId,
    required this.senderName,
    required this.createdAt,
    this.expiresAt,
  });

  final String id;
  final String text;
  final String senderId;
  final String senderName;
  final DateTime createdAt;
  final DateTime? expiresAt;

  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  factory ChatMessage.fromMap(String id, Map<String, dynamic> map) {
    final createdAt = map['createdAt'];
    final expiresAt = map['expiresAt'];
    return ChatMessage(
      id: id,
      text: map['text'] as String? ?? '',
      senderId: map['senderId'] as String? ?? '',
      senderName: map['senderName'] as String? ?? 'User',
      createdAt: createdAt is Timestamp ? createdAt.toDate() : DateTime.now(),
      expiresAt: expiresAt is Timestamp ? expiresAt.toDate() : null,
    );
  }
}
