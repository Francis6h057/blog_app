import 'package:flutter/material.dart';

class BlogEditor extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final double? minLength;
  const BlogEditor({
    super.key,
    required this.controller,
    required this.hintText,
    this.minLength,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
      ),
      maxLines: null,
      minLines: minLength?.toInt() ?? 1,
    );
  }
}
