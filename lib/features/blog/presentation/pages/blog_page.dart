import 'package:blog_app/core/common/widgets/loader.dart';
import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/show_snackbar.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/features/blog/presentation/pages/add_new_blog_page.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlogPage extends StatefulWidget {
  // Static route method to navigate to this page
  static route() => MaterialPageRoute(builder: (context) => const BlogPage());
  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  @override
  void initState() {
    super.initState();
    // Trigger fetching of all blogs when the page loads
    context.read<BlogBloc>().add(BlogFetchAllBlogs());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Top app bar with a title and "Add" icon button
      appBar: AppBar(
        title: const Center(child: Text('Blog App')),
        backgroundColor: AppPallete.transparentColor,
        actions: [
          IconButton(
            onPressed: () {
              // Navigate to blog creation page
              Navigator.push(context, AddNewBlogPage.route());
            },
            icon: const Icon(CupertinoIcons.add_circled),
          ),
        ],
      ),
      // Handling UI and state changes using BlocConsumer
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          // If blog loading fails, show error message
          if (state is BlogFailure) {
            showSnackBar(context, state.error);
          }
        },
        builder: (context, state) {
          // Show loading spinner while blogs are being fetched
          if (state is BlogLoading) {
            return const Loader();
          }

          // Display blogs when successfully loaded
          if (state is BlogDisplaySuccess) {
            return ListView.builder(
              itemCount: state.blogs.length,
              itemBuilder: (context, index) {
                final blog = state.blogs[index];
                // Alternate blog card background colors for visual appeal
                return BlogCard(
                  blog: blog,
                  color: index % 3 == 0
                      ? AppPallete.gradient1
                      : index % 3 == 1
                          ? AppPallete.gradient2
                          : AppPallete.gradient3,
                );
              },
            );
          }

          // If no state matches, return an empty widget
          return const SizedBox();
        },
      ),
    );
  }
}
