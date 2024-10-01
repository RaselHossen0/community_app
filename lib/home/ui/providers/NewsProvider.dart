import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/NewsModel.dart';
import '../repository/NewsRepository.dart';

final firebaseFirestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final newsRepositoryProvider = Provider<NewsRepository>((ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  return NewsRepository(firestore);
});

final newsProvider = FutureProvider<List<News>>((ref) async {
  final repository = ref.watch(newsRepositoryProvider);
  return repository.fetchNews();
});

final newsByCategoryProvider =
    FutureProvider.family<List<News>, String>((ref, category) async {
  final repository = ref.watch(newsRepositoryProvider);
  return repository.fetchNewsByCategory(category);
});
