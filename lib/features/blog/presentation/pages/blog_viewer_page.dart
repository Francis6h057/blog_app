import 'package:flutter/material.dart';

class BlogViewerPage extends StatelessWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const BlogViewerPage(),
      );
  const BlogViewerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
    );
  }
}
