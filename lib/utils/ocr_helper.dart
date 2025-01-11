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

  // print(extractedText);
  return extractedText;
}

String cleanName(String name) {
  // Match and retain only words containing alphabetic characters exclusively
  String cleanedName = name
      .split(' ') // Split the name into words
      .where((word) => RegExp(r'^[a-zA-Z]+$').hasMatch(word)) // Keep only alphabetic words
      .join(' '); // Join the cleaned words back into a single string

  return cleanedName.trim(); // Trim any leading or trailing spaces
}

String cleanAddress(String address){
  final RegExp removeLineRegex = RegExp(
    r'^.*Unique\s+ldentification\s+Authority\s+of\s+india.*$', // Match the specific line
    caseSensitive: false, // Make it case insensitive
    multiLine: true, // Ensure multi-line matching
  );

  // Remove the line
  final cleanedText = address.replaceAll(removeLineRegex, '').trim();

  return cleanedText;
}

/// Preprocesses the scanned text to extract Aadhaar details.
Map<String, String> preprocessAadhaarText(String scannedText) {
  String normalizedText = scannedText.toLowerCase().replaceAll(RegExp(r'\s+'), ' ');

  String namePattern = r'government of india\s*(.*?)\s*(?:dob|date of birth|date of bith|gender|male|female)';
  RegExp nameRegex = RegExp(namePattern, caseSensitive: false);
  String rawName = capitalize(nameRegex.firstMatch(normalizedText)?.group(1)?.trim()) ?? 'Name not found';
  String name = cleanName(rawName);

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

Map<String, String> preprocessAddressText(String scannedText) {

  final RegExp addressRegex = RegExp(
    r'Address:(.*?)\d{6}', // Match Address (case-sensitive in the pattern)
    dotAll: true,
    caseSensitive: false, // Makes the regex case-insensitive
  );

  // Extract the address
  final match = addressRegex.firstMatch(scannedText);

  if (match != null) {
    // Remove "Address: " prefix
    final String address = cleanAddress(match.group(0)!.replaceFirst('Address:', '').trim());
    print(address);
    return {
      'address': address,
    };
  } else {
    // print('Address not found');
    return {
      'address': 'Address not found',
    };
  }
}

/// Helper function to capitalize the first letter of a string.
String? capitalize(String? text) {
  if (text == null || text.isEmpty) return text;
  return text[0].toUpperCase() + text.substring(1);
}
