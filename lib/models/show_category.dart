class ShowCategoryModel {
  final String? title;
  final String? author;
  final String? description;
  final String? url;
  final String? urlToImage;

  ShowCategoryModel({
    this.title,
    this.author,
    this.description,
    this.url,
    this.urlToImage,
  });

  factory ShowCategoryModel.fromJson(Map<String, dynamic> json) {
    return ShowCategoryModel(
      title: json['title'] as String?,
      author: json['author'] as String?,
      description: json['description'] as String?,
      url: json['url'] as String?,
      urlToImage: json['urlToImage'] as String?,
    );
  }
}
