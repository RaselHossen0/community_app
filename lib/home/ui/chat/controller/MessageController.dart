// lib/notifiers/MessageNotifier.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/MessageModel.dart';

class MessageNotifier extends StateNotifier<List<Message>> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  MessageNotifier() : super([]);

  Future<void> loadMessages(String communityId) async {
    final querySnapshot = await _firestore
        .collection('messages')
        .where('communityId', isEqualTo: communityId)
        .orderBy('timestamp', descending: true)
        .get();
    state = querySnapshot.docs.map((doc) => Message.fromDocument(doc)).toList();
  }

  Future<void> sendMessage(Message message) async {
    await _firestore.collection('messages').add(message.toMap());
    loadMessages(message.communityId);
  }
}

final messageProvider =
    StateNotifierProvider<MessageNotifier, List<Message>>((ref) {
  return MessageNotifier();
});
