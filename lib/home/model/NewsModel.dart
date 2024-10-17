class News {
  final String title;
  final String imagePath;
  final String readTime;
  final String date;
  final String content;
  final String category;
  final String id;

  News({
    required this.title,
    required this.imagePath,
    required this.readTime,
    required this.date,
    required this.content,
    required this.id,
    required this.category,
  });
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'imagePath': imagePath,
      'readTime': readTime,
      'date': date,
      'content': content,
      'category': category,
      'id': id,
    };
  }

  factory News.fromFirestore(Map<String, dynamic> data, String id) {
    return News(
      title: data['title'] ?? '',
      imagePath: data['imagePath'] ?? '',
      readTime: data['readTime'] ?? '',
      date: data['date'] ?? '',
      content: data['content'] ?? '',
      category: data['category'] ?? '',
      id: id, // Set the Firestore document ID here
    );
  }
}
