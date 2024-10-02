// lib/providers/NewsletterNotifier.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/models/User.dart';

final newsletterProvider =
    StateNotifierProvider<NewsletterNotifier, bool>((ref) {
  return NewsletterNotifier();
});

class NewsletterNotifier extends StateNotifier<bool> {
  NewsletterNotifier() : super(false);

  Future<void> checkSubscription(User user) async {
    final doc = await FirebaseFirestore.instance
        .collection('newsletter_subscriptions')
        .doc(user.uid)
        .get();
    state = doc.exists;
  }

  Future<void> subscribe(User user) async {
    await FirebaseFirestore.instance
        .collection('newsletter_subscriptions')
        .doc(user.uid)
        .set(User.toMap(
          user,
        ));
    state = true;
  }
}
