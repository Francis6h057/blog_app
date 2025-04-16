// Function to calculate the estimated reading time based on word count.
int calculateReadingTime(String content) {
  // Splitting the content into words using whitespace as a separator (using regular expression).
  final wordCount = content.split(RegExp(r'\s+')).length;

  // Calculating reading time by dividing the word count by 200 words per minute (average reading speed).
  final readingTime = wordCount / 200;

  // Returning the calculated reading time, rounded up to the nearest integer.
  return readingTime.ceil();
}
