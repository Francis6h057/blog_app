import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/calculate_reading_time.dart';
import 'package:blog_app/core/utils/format_date.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:flutter/material.dart';

class BlogViewerPage extends StatelessWidget {
  final Blog blog;
  static route(blog) => MaterialPageRoute(
        builder: (context) => BlogViewerPage(
          blog: blog,
        ),
      );
  const BlogViewerPage({super.key, required this.blog});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(24.0).copyWith(top: 0, bottom: 0),
        child: Scrollbar(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    blog.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Text(
                    'By ${blog.posterName}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    '${formatDateBydMMMYYYY(blog.updatedAt)} . ${calculateReadingTime(blog.content)} min',
                    style: const TextStyle(
                      color: AppPallete.greyColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(blog.imageUrl),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Text(
                    blog.content,
                    style: const TextStyle(fontSize: 16, height: 1.6),
                  ),
                  const SizedBox(
                    height: 25,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
