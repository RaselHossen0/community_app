import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/NewsModel.dart';

class NewsRepository {
  final FirebaseFirestore _firestore;

  NewsRepository(this._firestore);

  Future<List<News>> fetchNews() async {
    final snapshot = await _firestore.collection('news').get();
    return snapshot.docs.map((doc) => News.fromFirestore(doc.data())).toList();
  }

  Future<List<News>> fetchNewsByCategory(String category) async {
    final snapshot = await _firestore
        .collection('news')
        .where('category', isEqualTo: category)
        .get();
    return snapshot.docs.map((doc) => News.fromFirestore(doc.data())).toList();
  }
}
