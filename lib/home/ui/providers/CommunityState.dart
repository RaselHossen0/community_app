// lib/auth/data/CommunityNotifier.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommunityNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CommunityNotifier() : super([]) {
    _loadCommunities();
  }

  Future<void> _loadCommunities() async {
    final querySnapshot = await _firestore.collection('communities').get();
    state = querySnapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id; // Include the document ID
      return data;
    }).toList();
  }

  Future<void> leaveCommunity(String communityId, String userId) async {
    final communityRef = _firestore.collection('communities').doc(communityId);
    final communityDoc = await communityRef.get();
    if (communityDoc.exists) {
      final members = List<String>.from(communityDoc.data()!['members'] ?? []);
      members.remove(userId);
      await communityRef.update({'members': members});
      _loadCommunities();
    }
  }

  Future<void> createCommunity(Map<String, dynamic> community) async {
    await _firestore.collection('communities').add(community);
    _loadCommunities();
  }

  Future<void> deleteCommunity(String communityId) async {
    await _firestore.collection('communities').doc(communityId).delete();
    _loadCommunities();
  }

  Future<void> addMember(String communityId, String userId) async {
    final communityRef = _firestore.collection('communities').doc(communityId);
    final communityDoc = await communityRef.get();
    if (communityDoc.exists) {
      final members = List<String>.from(communityDoc.data()!['members'] ?? []);
      if (!members.contains(userId)) {
        members.add(userId);
        await communityRef.update({'members': members});
        _loadCommunities();
      }
    }
  }
}

final communityProvider =
    StateNotifierProvider<CommunityNotifier, List<Map<String, dynamic>>>((ref) {
  return CommunityNotifier();
});
