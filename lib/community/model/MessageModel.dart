// lib/models/Message.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String id;
  final String communityId;
  final String senderId;
  final String type; // text, image, video, audio, etc.
  final String content;
  final Timestamp timestamp;

  Message({
    required this.id,
    required this.communityId,
    required this.senderId,
    required this.type,
    required this.content,
    required this.timestamp,
  });

  factory Message.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Message(
      id: doc.id,
      communityId: data['communityId'],
      senderId: data['senderId'],
      type: data['type'],
      content: data['content'],
      timestamp: data['timestamp'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'communityId': communityId,
      'senderId': senderId,
      'type': type,
      'content': content,
      'timestamp': timestamp,
    };
  }
}
