// Importing the necessary packages: 'dart:io' for file handling and 'image_picker' for picking images from the gallery.
import 'dart:io';
import 'package:image_picker/image_picker.dart';

// Asynchronous function to pick an image from the gallery.
Future<File?> pickImage() async {
  try {
    // Using the ImagePicker plugin to pick an image from the gallery.
    final xFile = await ImagePicker().pickImage(
      // The source of the image is the gallery.
      source: ImageSource.gallery,
    );

    // Check if an image was picked (xFile is not null).
    if (xFile != null) {
      // If an image was picked, return it as a File object.
      return File(xFile.path);
    } else {
      // If no image was picked (xFile is null), return null.
      return null;
    }
  } catch (e) {
    // If an error occurs during the image picking process, catch the error and return null.
    return null;
  }
}
