class News {
  final String title;
  final String imagePath;
  final String readTime;
  final String date;
  final String content;
  final String category;

  News({
    required this.title,
    required this.imagePath,
    required this.readTime,
    required this.date,
    required this.content,
    required this.category,
  });

  factory News.fromFirestore(Map<String, dynamic> data) {
    return News(
      title: data['title'] ?? '',
      imagePath: data['imagePath'] ?? '',
      readTime: data['readTime'] ?? '',
      date: data['date'] ?? '',
      content: data['content'] ?? '',
      category: data['category'] ?? '',
    );
  }
}
