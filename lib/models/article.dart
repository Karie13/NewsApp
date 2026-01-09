class Article {
  final String title;
  final String? description;
  final String? urlToImage;
  final String url;
  final String publishedAt;
  final String? content;
  final String sourceName;

  Article({
    required this.title,
    this.description,
    this.urlToImage,
    required this.url,
    required this.publishedAt,
    this.content,
    required this.sourceName,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? 'No title',
      description: json['description'] ?? 'No description available',
      urlToImage: json['urlToImage'],
      url: json['url'] ?? '',
      publishedAt: json['publishedAt'] ?? DateTime.now().toString(),
      content: json['content'],
      sourceName: (json['source'] != null && json['source']['name'] != null) 
          ? json['source']['name'] 
          : 'Unknown Source',
    );
  }
}