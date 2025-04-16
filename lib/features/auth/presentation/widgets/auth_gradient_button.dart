import 'package:blog_app/core/theme/app_pallete.dart'; // Custom color palette for the app
import 'package:flutter/material.dart'; // Flutter material package

// Custom AuthGradientButton widget
class AuthGradientButton extends StatelessWidget {
  final String text; // Text to display on the button
  final VoidCallback onPressed; // Callback function to handle the button press
  const AuthGradientButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // Container to wrap the button and apply custom decoration (gradient and border radius)
      decoration: BoxDecoration(
          gradient: const LinearGradient(
            // Linear gradient for the background color
            colors: [
              AppPallete.gradient1, // Starting color of the gradient
              AppPallete.gradient2, // Ending color of the gradient
              // AppPallete.gradient3 // Uncomment if you want to add a third gradient color
            ],
            begin: Alignment.bottomLeft, // Gradient starts from bottom-left
            end: Alignment.topRight, // Gradient ends at top-right
          ),
          borderRadius:
              BorderRadius.circular(12) // Rounded corners for the button
          ),
      child: ElevatedButton(
        onPressed:
            onPressed, // The callback that is executed when the button is pressed
        style: ElevatedButton.styleFrom(
            shadowColor:
                AppPallete.transparentColor, // Transparent shadow color
            fixedSize: const Size(395, 60), // Fixed size of the button (395x60)
            backgroundColor:
                AppPallete.transparentColor // Transparent background color
            ),
        child: Text(
          text, // The text to display on the button
          style: const TextStyle(
              fontSize: 36, // Font size of the text
              fontWeight: FontWeight.w600 // Font weight (semi-bold)
              ),
        ),
      ),
    );
  }
}
