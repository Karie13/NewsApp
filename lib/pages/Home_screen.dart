import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../Services/Slider_data.dart';
import '../Services/data.dart';
import '../Services/news.dart';
import '../models/article_model.dart';
import '../models/category_model.dart';
import '../models/slider_model.dart';
import 'Category_news.dart';
import 'article_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<CategoryModel> categories = [];
  List<SliderModel> sliders = [];
  List<ArticleModel> articles = [];
  bool _loading = true;
  int activeIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      categories = await getCategories();
      
      News newsService = News();
      SliderNews sliderService = SliderNews();

      await Future.wait([
        newsService.getNews(),
        sliderService.getSliderNews(),
      ]);

      if (mounted) {
        setState(() {
          articles = newsService.news;
          sliders = sliderService.Slidersnews;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Modern grayish-blue tint
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0.5,
        centerTitle: false,
       title: Center(
  child: Row(
    mainAxisSize: MainAxisSize.min, // ensures the row takes minimal space
    children: [
      Text(
        "News",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w900,
          fontSize: 26,
          letterSpacing: -0.5,
        ),
      ),
      SizedBox(width: 4), // small gap between words
      Text(
        "App",
        style: TextStyle(
          color: Colors.blueAccent,
          fontWeight: FontWeight.w900,
          fontSize: 26,
          letterSpacing: -0.5,
        ),
      ),
    ],
  ),
),

      
      ),
      body: _loading ? _buildShimmerEffect() : _buildMainContent(),
    );
  }

  Widget _buildMainContent() {
    return RefreshIndicator(
      onRefresh: _initializeData,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            _sectionHeader("Categories"),
            const SizedBox(height: 12),
            SizedBox(
              height: 90,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return CategoryTile(
                    categoryName: categories[index].categoryName!,
                    imageUrl: categories[index].imageUrl!,
                  );
                },
              ),
            ),

            const SizedBox(height: 25),
            _sectionHeader("Breaking News"),
            const SizedBox(height: 12),
            CarouselSlider.builder(
              itemCount: sliders.length,
              itemBuilder: (context, index, realIndex) => _buildSliderItem(sliders[index]),
              options: CarouselOptions(
                height: 200,
                autoPlay: true,
                viewportFraction: 0.9,
                enlargeCenterPage: true,
                onPageChanged: (index, reason) => setState(() => activeIndex = index),
              ),
            ),
            const SizedBox(height: 12),
            _buildAnimatedIndicator(),

            const SizedBox(height: 30),
            _sectionHeader("Trending Now"),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: articles.length,
              itemBuilder: (context, index) {
                return AnimatedArticleTile(article: articles[index], index: index);
              },
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: Colors.black,
          letterSpacing: -0.2,
        ),
      ),
    );
  }

  Widget _buildSliderItem(SliderModel slider) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ArticleView(blogUrl: slider.url!))),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              CachedNetworkImage(
                imageUrl: slider.urlToImage!,
                height: 200, width: double.infinity, fit: BoxFit.cover,
                placeholder: (context, url) => Container(color: Colors.grey[200]),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black.withOpacity(0.85), Colors.transparent],
                  ),
                ),
              ),
              Positioned(
                bottom: 15, left: 15, right: 15,
                child: Text(
                  slider.title!,
                  maxLines: 2,
                  style: const TextStyle(
                    color: Colors.white, 
                    fontSize: 16, 
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        sliders.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: activeIndex == index ? 20 : 7,
          height: 7,
          decoration: BoxDecoration(
            color: activeIndex == index ? Colors.blueAccent : Colors.grey.shade400,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: SingleChildScrollView(
        child: Column(
          children: List.generate(6, (index) => Container(
            height: 110, width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
          )),
        ),
      ),
    );
  }
}

class CategoryTile extends StatelessWidget {
  final String categoryName, imageUrl;
  const CategoryTile({super.key, required this.categoryName, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CategoryNews(name: categoryName))),
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        width: 140,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(imageUrl, height: 90, width: 140, fit: BoxFit.cover),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: Text(
                  categoryName,
                  style: const TextStyle(
                    color: Colors.white, 
                    fontSize: 14, 
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedArticleTile extends StatelessWidget {
  final ArticleModel article;
  final int index;
  const AnimatedArticleTile({super.key, required this.article, required this.index});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 400 + (index * 80)),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(offset: Offset(0, 30 * (1 - value)), child: child),
        );
      },
      child: GestureDetector(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ArticleView(blogUrl: article.url!))),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05), 
                blurRadius: 10, 
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: CachedNetworkImage(
                  imageUrl: article.urlToImage ?? '',
                  height: 90, width: 90, fit: BoxFit.cover,
                  errorWidget: (context, url, error) => Container(color: Colors.grey[100], child: const Icon(Icons.broken_image)),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.title ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold, 
                        fontSize: 15,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      article.description ?? 'Read full article for more details...',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey.shade600, 
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}