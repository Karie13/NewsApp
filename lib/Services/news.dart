import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/article_model.dart';

class News {
  List<ArticleModel> news = [];

  Future<void> getNews() async {
    String url = "https://newsapi.org/v2/everything?domains=wsj.com&apiKey=54747610bd54414fb7e60951fcef90df";
    
    try {
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        if (jsonData['status'] == 'ok') {
          jsonData['articles'].forEach((element) {
            if (element['urlToImage'] != null && element['description'] != null) {
              ArticleModel articleModel = ArticleModel(
                title: element['title'] ?? "No Title",
                author: element['author'] ?? "Unknown",
                description: element['description'] ?? "No Description",
                url: element['url'],
                urlToImage: element['urlToImage'],
              );
              news.add(articleModel);
            }
          });
        } else {
          print("Error: API returned a non-ok status");
        }
      } else {
        print("Error: Failed to fetch news with status code ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }
}
