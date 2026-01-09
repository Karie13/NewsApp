import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ArticleView extends StatefulWidget {
  final String blogUrl;

  const ArticleView({required this.blogUrl, super.key});

  @override
  State<ArticleView> createState() => _ArticleViewState();
}

class _ArticleViewState extends State<ArticleView> {
  late final WebViewController _controller;
  double _loadingProgress = 0;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() {
              _loadingProgress = progress / 100;
            });
          },
          onPageStarted: (String url) {
            setState(() => _hasError = false);
          },
          onPageFinished: (String url) {
            setState(() => _loadingProgress = 0);
          },
          onWebResourceError: (WebResourceError error) {
            setState(() => _hasError = true);
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.blogUrl));
  }

  // Handle the back button press
  Future<bool> _handleBackPress() async {
    if (await _controller.canGoBack()) {
      await _controller.goBack();
      return false; // Stay in the app, just go back within the website
    }
    return true; // Exit the screen and go back to Home
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _handleBackPress,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          elevation: 0.5,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          title: RichText(
            text: const TextSpan(
              style: TextStyle(
                fontSize: 20, 
                fontWeight: FontWeight.w800, // Heavy weight for a premium feel
                letterSpacing: -0.5,         // Tight letter spacing for modern look
              ),
              children: [
                TextSpan(text: "Global", style: TextStyle(color: Colors.black)),
                TextSpan(text: "News", style: TextStyle(color: Colors.blueAccent)),
              ],
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.black87),
              onPressed: () => _controller.reload(),
            ),
          ],
          centerTitle: true,
        ),
        body: Column(
          children: [
            // Linear Progress Bar at the top (Modern UX)
            if (_loadingProgress > 0 && _loadingProgress < 1.0)
              LinearProgressIndicator(
                value: _loadingProgress,
                backgroundColor: Colors.white,
                color: Colors.blueAccent,
                minHeight: 3,
              ),

            Expanded(
              child: Stack(
                children: [
                  WebViewWidget(controller: _controller),
                  
                  // Professional Error UI
                  if (_hasError) _buildErrorWidget(),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: _buildBottomActionBar(),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      color: Colors.white,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.wifi_off_rounded, size: 70, color: Colors.blueGrey),
          const SizedBox(height: 20),
          const Text(
            "Connection Error",
            style: TextStyle(
              fontSize: 22, 
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 50),
            child: Text(
              "We couldn't reach the news server. Please check your internet or try again later.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey, 
                fontSize: 14,
                height: 1.5, // Better line height for readability
              ),
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              setState(() => _hasError = false);
              _controller.reload();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
            child: const Text(
              "Retry", 
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBottomActionBar() {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200, width: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 18, color: Colors.black87),
            onPressed: () async {
              if (await _controller.canGoBack()) _controller.goBack();
            },
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.black87),
            onPressed: () async {
              if (await _controller.canGoForward()) _controller.goForward();
            },
          ),
          const VerticalDivider(indent: 20, endIndent: 20, color: Colors.black12),
          IconButton(
            icon: const Icon(Icons.share_rounded, color: Colors.black87),
            onPressed: () {
              // Standard share logic
            },
          ),
        ],
      ),
    );
  }
}