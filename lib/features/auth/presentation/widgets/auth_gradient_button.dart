import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class AuthGradientButton extends StatelessWidget {
  final String text;
  const AuthGradientButton({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              AppPallete.gradient1,
              AppPallete.gradient2,
              // AppPallete.gradient3
            ],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
          borderRadius: BorderRadius.circular(12)),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
            shadowColor: AppPallete.transparentColor,
            fixedSize: const Size(395, 60),
            backgroundColor: AppPallete.transparentColor),
        child: Text(
          text,
          style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
