import 'package:flutter/material.dart';

class AuthField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool obscureText;

  const AuthField({
    super.key,
    required this.hintText,
    required this.controller,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: hintText,
      ),
      obscureText: obscureText,
      controller: controller,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$hintText cannot be empty';
        }
        return null;
      },
    );
  }
}
