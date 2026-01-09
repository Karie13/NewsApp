import 'package:flutter/material.dart';

import 'pages/LandingPage.dart';






void main() {
  runApp(NewsApp());
}

class NewsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter News App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Landingpage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
