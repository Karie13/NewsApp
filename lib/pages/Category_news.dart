import 'package:flutter/material.dart';

import '../Services/Show_Category_news.dart';
import '../models/show_category.dart';
import 'article_view.dart';

class CategoryNews extends StatefulWidget {
  final String name;
  const CategoryNews({Key? key, required this.name}) : super(key: key);

  @override
  _CategoryNewsState createState() => _CategoryNewsState();
}

class _CategoryNewsState extends State<CategoryNews> {
  List<ShowCategoryModel> articles = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    fetchCategoryNews();
  }

  Future<void> fetchCategoryNews() async {
    ShowCategoryNews news = ShowCategoryNews();
    await news.getCategoriesNews(widget.name);
    setState(() {
      articles = news.Categories;
      _loading = false;
    });


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name,style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : articles.isNotEmpty
              ? ListView.builder(
                  itemCount: articles.length,
                  itemBuilder: (context, index) {
                    final article = articles[index];
                    print("Displaying article: ${article.title}"); // Debugging line
                    return BlogTile(
                      url: article.url ?? '', // Provide default empty string
                      imageUrl: article.urlToImage?.isNotEmpty == true 
                          ? article.urlToImage! 
                          : 'https://via.placeholder.com/150', // Provide default placeholder image
                      title: article.title ?? 'No Title', // Provide default value
                      description: article.description ?? 'No Description', // Provide default value
                    );
                  },
                )
              : Center(child: Text("No news available for this category")),
    );
  }
}

class BlogTile extends StatelessWidget {
  final String imageUrl, title, description, url;

  const BlogTile({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to a detailed article page or open the URL in a web view
       Navigator.push(context, MaterialPageRoute(builder: (context)=> ArticleView(blogUrl: url))); // Debugging line
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Material(
            elevation: 3.0,
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
  imageUrl,
  height: 100,
  width: 100,
  fit: BoxFit.cover,
  loadingBuilder: (context, child, loadingProgress) {
    if (loadingProgress == null) return child;
    return const Center(
      child: CircularProgressIndicator(),
    );
  },
  errorBuilder: (context, error, stackTrace) {
    return const Icon(
      Icons.broken_image,
      size: 40,
    );
  },
),

                    ),
                  ),
                  SizedBox(
                    height: 18,
                    width: 15,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                          maxLines: 2,
                        ),
                        SizedBox(height: 7.0),
                        Text(
                          description,
                          style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                          maxLines: 2, // Limit description to 2 lines
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
