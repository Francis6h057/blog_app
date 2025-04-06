import 'dart:io';

import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/pick_image.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_editor.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Main page for adding a new blog
class AddNewBlogPage extends StatefulWidget {
  // Route helper for navigation
  static route() => MaterialPageRoute(
        builder: (context) => const AddNewBlogPage(),
      );

  const AddNewBlogPage({super.key});

  @override
  State<AddNewBlogPage> createState() => _AddNewBlogPageState();
}

class _AddNewBlogPageState extends State<AddNewBlogPage> {
  // Controllers to manage input for blog title and content
  final blogTitleController = TextEditingController();
  final blogContentController = TextEditingController();

  List<String> selectedTopics = [];
  File? image;

  void selectImage() async {
    final pickedImage = await pickImage();

    if (pickedImage != null) {
      setState(() {
        image = pickedImage;
      });
    }
  }

  @override
  void dispose() {
    // Clean up controllers when widget is disposed
    blogContentController.dispose();
    blogTitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Automatically adjust the layout when the keyboard is shown
      resizeToAvoidBottomInset: true,

      // App bar for the page
      appBar: AppBar(
        title: const Center(
          child: Text('New Blog'),
        ),
        backgroundColor: AppPallete.transparentColor,
        surfaceTintColor: AppPallete.transparentColor,
        actions: [
          // Placeholder action icon (e.g. to submit blog later)
          IconButton(
            onPressed: () {},
            icon: const Icon(CupertinoIcons.check_mark_circled),
          ),
        ],
      ),

      // Page body
      body: SafeArea(
        // Dismiss keyboard when tapping outside input
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },

          // LayoutBuilder used to get constraints for dynamic sizing
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                // Add padding around content
                padding: const EdgeInsets.all(16),

                // Reverses scroll direction so bottom stays visible with keyboard
                reverse: true,

                child: ConstrainedBox(
                  // Makes sure the scroll view takes at least the full screen height
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),

                  child: IntrinsicHeight(
                    // Ensures the column takes only needed vertical space
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(
                          height: 24,
                        ),
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
                            // Dotted border for image selection placeholder
                            : GestureDetector(
                                onTap: () {
                                  selectImage();
                                },
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.folder_open_rounded,
                                          size: 46,
                                        ),
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

                        // Horizontal scrolling list of category chips
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              'Technology',
                              'Business',
                              'Programming',
                              'Entertainment'
                            ]
                                .map((e) => Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: GestureDetector(
                                        onTap: () {
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
                                                  AppPallete.gradient1,
                                                )
                                              : null,
                                          side: selectedTopics.contains(e)
                                              ? null
                                              : const BorderSide(
                                                  color: AppPallete.borderColor,
                                                ),
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),

                        const SizedBox(height: 10),

                        // Text field for blog title
                        BlogEditor(
                          controller: blogTitleController,
                          hintText: 'Blog Title',
                        ),

                        const SizedBox(height: 10),

                        // Text field for blog content
                        BlogEditor(
                          controller: blogContentController,
                          hintText: 'Blog Content',
                          minLength: 4,
                        ),

                        const Spacer(),

                        // Extra space to push content above the keyboard when open
                        SizedBox(
                          height: MediaQuery.of(context).viewInsets.bottom,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
