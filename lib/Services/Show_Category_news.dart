import 'dart:convert';
import 'package:http/http.dart' as http;


import '../models/show_category.dart'; // Ensure the correct import path

class ShowCategoryNews {
  List<ShowCategoryModel> Categories = [];

  Future<void> getCategoriesNews(String category) async {
    String url = "https://newsapi.org/v2/top-headlines?country=us&category=$category&apiKey=2298fcffc21647a89e23f0a2bccc1f53";

    try {
      var response = await http.get(Uri.parse(url));
      print("Response Status Code: ${response.statusCode}"); // Debugging line
      print("Response Body: ${response.body}"); // Debugging line

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        print("Decoded JSON Data: $jsonData"); // Debugging line

        if (jsonData['status'] == 'ok' && jsonData['articles'] is List) {
          Categories.clear();

          var articles = jsonData['articles'] as List;
          print("Number of articles fetched: ${articles.length}"); // Debugging line

          for (var element in articles) {
            // Use default values if fields are missing
            ShowCategoryModel categoriesModel = ShowCategoryModel(
              title: element['title'] ?? "No Title",
              author: element['author'] ?? "Unknown",
              description: element['description'] ?? "No Description",
              url: element['url'] ?? '',
              urlToImage: element['urlToImage'] ?? '',
            );
            Categories.add(categoriesModel);
          }

          print("Number of articles added to Categories: ${Categories.length}"); // Debugging line
        } else {
          print("Error: API response does not have expected structure or no articles found.");
        }
      } else {
        print("Error: Received status code ${response.statusCode}");
      }
    } catch (e) {
      print("Exception: $e");
    }
  }
}
