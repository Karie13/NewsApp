import 'dart:convert';

import 'package:http/http.dart' as http;



import '../models/slider_model.dart';

class SliderNews {
  List<SliderModel> Slidersnews = [];

  Future<void> getSliderNews() async {
    String url = "https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=753845bbf51c4c25a6f361f81b748c7e";
    
    try {
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        if (jsonData['status'] == 'ok') {
          jsonData['articles'].forEach((element) {
            if (element['urlToImage'] != null && element['description'] != null) {
              SliderModel sliderModel = SliderModel(
                title: element['title'] ?? "No Title",
                author: element['author'] ?? "Unknown",
                description: element['description'] ?? "No Description",
                url: element['url'],
                urlToImage: element['urlToImage'],
              );
              Slidersnews.add(sliderModel);
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
