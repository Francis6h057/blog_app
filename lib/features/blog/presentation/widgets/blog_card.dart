import 'package:blog_app/core/utils/calculate_reading_time.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:flutter/material.dart';

// BlogCard displays a blog summary in a styled container
class BlogCard extends StatelessWidget {
  final Blog blog; // Blog entity to display
  final Color color; // Background color of the card

  const BlogCard({
    super.key,
    required this.blog,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // Margin around the card, with slightly less bottom margin
      margin: const EdgeInsets.all(18).copyWith(bottom: 8),
      // Padding inside the card
      padding: const EdgeInsets.all(12),
      // Box styling with color and rounded corners
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      height: 200, // Fixed height for the card
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start, // Align content to the left
        children: [
          // Scrollable row of topic chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: blog.topics
                  .map((e) => Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Chip(
                          label: Text(e), // Display topic name
                        ),
                      ))
                  .toList(),
            ),
          ),
          // Blog title
          Text(
            blog.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(), // Push reading time to the bottom
          // Estimated reading time
          Text('${calculateReadingTime(blog.content)} min'),
        ],
      ),
    );
  }
}
