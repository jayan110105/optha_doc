import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

/// Performs OCR on the provided image file and extracts text.
Future<String> performOCR(File imageFile) async {
  // Convert the image to an InputImage object
  final inputImage = InputImage.fromFile(imageFile);

  // Initialize the text recognizer
  final textRecognizer = TextRecognizer();

  // Process the image and recognize text
  final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

  // Extract the text
  String extractedText = recognizedText.text;

  // Close the recognizer to free up resources
  textRecognizer.close();

  print(extractedText);
  return extractedText;
}

/// Preprocesses the scanned text to extract Aadhaar details.
Map<String, String> preprocessAadhaarText(String scannedText) {
  String normalizedText = scannedText.toLowerCase().replaceAll(RegExp(r'\s+'), ' ');

  String namePattern = r'government of india\s*(.*?)\s*(?:dob|date of birth|date of bith|gender|male|female)';
  RegExp nameRegex = RegExp(namePattern, caseSensitive: false);
  String name = capitalize(nameRegex.firstMatch(normalizedText)?.group(1)?.trim()) ?? 'Name not found';

  String dobPattern = r'(dob:|date of birth[: ]*)\s*(\d{1,2}/\d{1,2}/\d{4})';
  RegExp dobRegex = RegExp(dobPattern, caseSensitive: false);
  String dob = dobRegex.firstMatch(normalizedText)?.group(2) ?? 'DOB not found';

  int age = -1;
  if (dob != 'DOB not found') {
    DateTime dobDate = DateTime.parse(dob.split('/').reversed.join('-'));
    DateTime today = DateTime.now();
    age = today.year - dobDate.year;
    if (today.month < dobDate.month || (today.month == dobDate.month && today.day < dobDate.day)) {
      age--;
    }
  }

  // Extract Gender
  String genderPattern = r'\b(male|female)\b';
  RegExp genderRegex = RegExp(genderPattern, caseSensitive: false);
  String gender = capitalize(genderRegex.firstMatch(normalizedText)?.group(0)) ?? 'Gender not found';

  // Extract Aadhaar Number
  String aadhaarPattern = r'\b\d{4} \d{4} \d{4}\b';
  RegExp aadhaarRegex = RegExp(aadhaarPattern);
  String aadhar = aadhaarRegex.firstMatch(normalizedText)?.group(0)?.replaceAll(' ', '') ?? 'Aadhaar number not found';

  // Return a formatted string or a map with extracted data
  return {
    'name': name,
    'age': age == -1 ? 'Age not found' : age.toString(),
    'gender': gender,
    'aadhar': aadhar,
  };
}

/// Helper function to capitalize the first letter of a string.
String? capitalize(String? text) {
  if (text == null || text.isEmpty) return text;
  return text[0].toUpperCase() + text.substring(1);
}
