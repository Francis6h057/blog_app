import 'dart:io';

import 'package:blog_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/core/common/widgets/loader.dart';
import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/pick_image.dart';
import 'package:blog_app/core/utils/show_snackbar.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/features/blog/presentation/pages/blog_page.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_editor.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Page for composing and uploading a new blog post
class AddNewBlogPage extends StatefulWidget {
  /// Route helper method for navigation
  static route() => MaterialPageRoute(
        builder: (context) => const AddNewBlogPage(),
      );

  const AddNewBlogPage({super.key});

  @override
  State<AddNewBlogPage> createState() => _AddNewBlogPageState();
}

class _AddNewBlogPageState extends State<AddNewBlogPage> {
  // Controllers for blog title and content input
  final blogTitleController = TextEditingController();
  final blogContentController = TextEditingController();

  // Form key for validation
  final formKey = GlobalKey<FormState>();

  // Selected topics for the blog post
  List<String> selectedTopics = [];

  // Blog image file
  File? image;

  /// Function to trigger image selection from gallery
  void selectImage() async {
    final pickedImage = await pickImage();

    if (pickedImage != null) {
      setState(() {
        image = pickedImage;
      });
    }
  }

  /// Function to validate and dispatch the blog upload event
  void uploadBlog() {
    // Run form validation
    if (formKey.currentState!.validate()) {
      if (selectedTopics.isEmpty) {
        showSnackBar(context, 'Please select at least one topic');
        return;
      }

      if (image == null) {
        showSnackBar(context, 'Please select an image');
        return;
      }

      final posterId =
          (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;

      // Dispatch the blog upload event to Bloc
      context.read<BlogBloc>().add(BlogUpload(
            posterId: posterId,
            title: blogTitleController.text.trim(),
            content: blogContentController.text.trim(),
            image: image!,
            topics: selectedTopics,
          ));
    }
  }

  @override
  void dispose() {
    // Clean up text controllers when the widget is disposed
    blogContentController.dispose();
    blogTitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Allow resizing when the keyboard is shown
      resizeToAvoidBottomInset: true,

      // App bar for the page
      appBar: AppBar(
        title: const Center(child: Text('New Blog')),
        actions: [
          // Upload button (checkmark icon)
          IconButton(
            onPressed: uploadBlog,
            icon: const Icon(CupertinoIcons.check_mark_circled),
          ),
        ],
      ),

      // Main body of the page
      body: SafeArea(
        child: BlocConsumer<BlogBloc, BlogState>(
          listener: (context, state) {
            if (state is BlogFailure) {
              showSnackBar(context, state.error);
            } else if (state is BlogUploadSuccess) {
              // Navigate to blog list page after successful upload
              Navigator.pushAndRemoveUntil(
                context,
                BlogPage.route(),
                (route) => false,
              );
            }
          },
          builder: (context, state) {
            if (state is BlogLoading) {
              // Show loading spinner during upload
              return const Loader();
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              reverse: true, // Keep scroll view pinned to bottom
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 24),

                    // Image preview or upload placeholder
                    image != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: GestureDetector(
                              onTap: selectImage,
                              child: Image.file(
                                image!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : GestureDetector(
                            onTap: selectImage,
                            child: DottedBorder(
                              strokeWidth: 3,
                              strokeCap: StrokeCap.round,
                              color: AppPallete.borderColor,
                              dashPattern: const [18, 9],
                              radius: const Radius.circular(16),
                              borderType: BorderType.RRect,
                              child: const SizedBox(
                                height: 120,
                                width: double.infinity,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.folder_open_rounded, size: 46),
                                    SizedBox(height: 10),
                                    Text(
                                      'Select your blog image',
                                      style: TextStyle(fontSize: 18),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),

                    const SizedBox(height: 10),

                    // Horizontal list of topic chips
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          'Technology',
                          'Business',
                          'Programming',
                          'Entertainment',
                        ]
                            .map(
                              (e) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    // Toggle topic selection
                                    if (selectedTopics.contains(e)) {
                                      selectedTopics.remove(e);
                                    } else {
                                      selectedTopics.add(e);
                                    }
                                    setState(() {});
                                  },
                                  child: Chip(
                                    label: Text(e),
                                    color: selectedTopics.contains(e)
                                        ? const WidgetStatePropertyAll(
                                            AppPallete.gradient1)
                                        : null,
                                    side: selectedTopics.contains(e)
                                        ? null
                                        : const BorderSide(
                                            color: AppPallete.borderColor),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Blog title input
                    BlogEditor(
                      controller: blogTitleController,
                      hintText: 'Blog Title',
                    ),

                    const SizedBox(height: 10),

                    // Blog content input
                    BlogEditor(
                      controller: blogContentController,
                      hintText: 'Blog Content',
                      minLength: 4,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
