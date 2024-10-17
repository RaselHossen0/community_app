import 'package:cloud_firestore/cloud_firestore.dart';

import '../../home/model/NewsModel.dart';

class NewsRepository {
  final FirebaseFirestore _firestore;

  NewsRepository(this._firestore);

  Future<List<News>> fetchNews() async {
    final snapshot = await _firestore.collection('news').get();
    return snapshot.docs
        .map((doc) => News.fromFirestore(doc.data(), doc.id))
        .toList();
  }

  Future<List<News>> fetchNewsByCategory(String category) async {
    final snapshot = await _firestore
        .collection('news')
        .where('category', isEqualTo: category)
        .get();
    return snapshot.docs
        .map((doc) => News.fromFirestore(doc.data(), doc.id))
        .toList();
  }

  //delete news
  Future<void> deleteNews(String newsId) async {
    await _firestore.collection('news').doc(newsId).delete();
  }

  Future<void> addNews(News news) async {
    await _firestore.collection('news').add(news.toMap());
  }
}
