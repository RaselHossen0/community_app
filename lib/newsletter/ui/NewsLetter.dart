import 'package:cloud_firestore/cloud_firestore.dart';

class Newsletter {
  final String id;
  final String title;
  final String description;
  final DateTime date;

  Newsletter({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
  });

  // To convert from Firestore document to Newsletter model
  factory Newsletter.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Newsletter(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
    );
  }

  // To convert a Newsletter object to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'date': date,
    };
  }
}
