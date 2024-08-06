// lib/models/news.dart

class News {
  final String title;
  final String image;
  final String description;
  final String content;
  final String link;

  News({
    required this.title,
    required this.image,
    required this.description,
    required this.content,
    required this.link,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      title: json['title'],
      image: json['image'] ?? '', // Manejo de caso en que la imagen sea null
      description: json['description'],
      content: json['content'],
      link: json['link'],
    );
  }
}
