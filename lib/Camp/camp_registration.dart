import 'dart:io';
import 'package:flutter/material.dart';
import 'package:opthadoc/Components/Label.dart';
import 'package:opthadoc/Components/InputField.dart';
import 'package:opthadoc/Components/CustomTextArea.dart';
import 'package:opthadoc/Components/StretchedIconButton.dart';
import 'package:opthadoc/Components/ProgressStep.dart';
import 'package:opthadoc/Components/CardComponent.dart';
import 'package:image_picker/image_picker.dart';
import 'package:opthadoc/Components/ErrorSnackBar.dart';
import 'package:opthadoc/utils/ocr_helper.dart';

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}


class CampRegistration extends StatefulWidget {
  const CampRegistration({super.key});

  @override
  State<CampRegistration> createState() => _CampRegistrationState();
}

class _CampRegistrationState extends State<CampRegistration> {
  int step = 0;
  File? _image;

  final List<Map<String, dynamic>> steps = [
    {"id": "photo", "title": "Photo", "icon": Icons.camera_alt},
    {"id": "basic", "title": "Basic Info", "icon": Icons.person},
    {"id": "gender", "title": "Gender", "icon": Icons.group},
    {"id": "details", "title": "Details", "icon": Icons.description},
  ];

  final Map<String, TextEditingController> controllers = {
    "name": TextEditingController(),
    "age": TextEditingController(),
    "gender": TextEditingController(),
    "aadhar": TextEditingController(),
    "parent": TextEditingController(),
    "phone": TextEditingController(),
    "address": TextEditingController(),
    "complaint": TextEditingController(),
  };

  void showCustomSnackBar(BuildContext context, String title, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        content: ErrorSnackBar(
          title: title,
          message: message,
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose all controllers to free memory
    for (var controller in controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  // Check if all required fields are filled


  Future<File?> getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera); // or ImageSource.gallery

    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  void nextStep() {
    // if (!validateStepFields(step)) return;
    if(step == steps.length - 1)// Validate current step fields
      print("Submit");
    else if (step < steps.length - 1) {
      setState(() {
        step++;
      });
    }
  }

  bool validateStepFields(int currentStep) {
    List<String> requiredFields;

    switch (currentStep) {
      case 0: // Step 1: Photo
        if (_image == null) {
          showCustomSnackBar(
            context,
            "Photo is required",
            "Please upload a photo to proceed.",
          );
          return false;
        }
        return true;

      case 1: // Step 2: Basic Info
        requiredFields = ["name", "age"];
        break;

      case 2: // Step 3: Gender
        requiredFields = ["gender"];
        break;

      case 3: // Step 4: Details
        requiredFields = ["aadhar", "parent", "phone", "address", "complaint"];
        break;

      default:
        return true; // No validation needed for undefined steps
    }

    for (var field in requiredFields) {
      if (controllers[field]?.text.isEmpty ?? true) {
        showCustomSnackBar(
          context,
          "${field.capitalize()} is required",
          "Please enter the ${field.replaceAll('_', ' ')} to proceed.",
        );
        return false;
      }
    }

    return true; // All fields for the current step are valid
  }

  void prevStep() {
    if (step > 0) {
      setState(() {
        step--;
      });
    }
  }

  Future<void> scanAadhar() async {
    File? imageFile = await getImage();
    if (imageFile != null) {
      String text = await performOCR(imageFile);
      Map<String, String> extractedData = preprocessAadhaarText(text);
      setState(() {
        controllers["name"]?.text = extractedData['name'] ?? '';
        controllers["age"]?.text = extractedData['age'] ?? '';
        controllers["gender"]?.text = extractedData['gender'] ?? '';
        controllers["aadhar"]?.text = extractedData['aadhar'] ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Define the widget array for each step
    final stepWidgets = [
      // Step 1: Photo
      Center(
        child: Column(
          children: [
            GestureDetector(
              onTap: () async {
                File? imageFile = await getImage();
                if (imageFile != null) {
                  setState(() {
                    _image = imageFile;
                  });
                }
              },
              child: CircleAvatar(
                radius: 80,
                backgroundColor: Color(0xFF163351).withValues(alpha: 0.1),
                backgroundImage: _image != null ? FileImage(_image!) : null,
                child: _image == null
                    ? Icon(
                  Icons.camera_alt,
                  color: Color(0xFF163351).withValues(alpha: 0.4),
                  size: 50,
                )
                    : null,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Tap to take or upload photo",
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
      // Step 2: Basic Info
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Label(text: "Patient Name"),
          const SizedBox(height: 8),
          InputField(
            controller: controllers["name"],
            hintText: "Enter patient name",
          ),
          const SizedBox(height: 16),
          Label(text: "Age"),
          const SizedBox(height: 8),
          InputField(
            controller: controllers["age"],
            hintText: "Enter age",
          ),
          SizedBox(height: 24),
          StretchedIconButton(
            backgroundColor: const Color(0xFF163351),
            textColor: Colors.white,
            icon: Icons.qr_code_scanner,
            label: "Scan Aadhar",
            onPressed: scanAadhar, // Replace with your onPressed function
          ),
        ],
      ),
      // Step 3: Gender
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: ["Male", "Female", "Other"].map((gender) {
          IconData genderIcon;

          // Assign custom icons for each gender
          switch (gender) {
            case "Male":
              genderIcon = Icons.male;
              break;
            case "Female":
              genderIcon = Icons.female;
              break;
            default:
              genderIcon = Icons.transgender;
          }

          return GestureDetector(
            onTap: () => setState(() {
              controllers["gender"]!.text = gender;
            }),
            child: Container(
              width: 90, // Fixed width for each item
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: controllers["gender"]!.text == gender
                    ? const Color(0xFF163351)
                    : Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    genderIcon,
                    color: controllers["gender"]!.text == gender
                        ? Colors.grey[200]
                        : const Color(0xFF163351),
                    size: 30,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    gender,
                    style: TextStyle(
                      color: controllers["gender"]!.text == gender
                          ? Colors.grey[200]
                          : const Color(0xFF163351),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
      // Step 4: Details
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Label(text: "Aadhar Card Number"),
          SizedBox(height: 8),
          InputField(
            controller: controllers["aadhar"],
            hintText: "Enter Aadhaar number",
          ),
          SizedBox(height: 16),
          Label(text: "Parent/Spouse Name"),
          SizedBox(height: 8),
          InputField(
            controller: controllers["parent"],
            hintText: "Enter parent/spouse name",
          ),
          SizedBox(height: 16),
          Label(text: "Phone Number"),
          SizedBox(height: 8),
          InputField(
            controller: controllers["phone"],
            hintText: "Enter phone number",
          ),
          SizedBox(height: 16),
          Label(text: "Address"),
          SizedBox(height: 8),
          CustomTextArea(
            controller: controllers["address"],
            hintText: "Enter address",
            isEnabled: true,
            minLines: 5,
            maxLines: null, // Allows unlimited lines
          ),
          SizedBox(height: 16),
          Label(text: "Chief Complaint"),
          SizedBox(height: 8),
          CustomTextArea(
            controller: controllers["complaint"],
            hintText: "Enter chief complaint",
            isEnabled: true,
            minLines: 5,
            maxLines: null, // Allows unlimited lines
          ),
        ],
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFE9E7DB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Title, Progress Steps, etc.
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Camp Registration",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF163351),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Register a new patient for the eye camp",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF163351).withValues(alpha: 0.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        ProgressSteps(
                          steps: steps,
                          currentStep: step,
                          allowStepTap: false,
                          onStepTapped: (index) {
                            setState(() {
                              step = index;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        CardComponent(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: stepWidgets[step],
                            ),
                        ),
                        SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white, // Matches the bg-background color
                                foregroundColor: const Color(0xFF163351),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8), // Rounded border with 0 radius
                                ),
                              ),
                              onPressed: step > 0 ? prevStep : null,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.arrow_back_ios,
                                    color: step > 0 ? Color(0xFF163351): Colors.grey[500],
                                  ),
                                  SizedBox(width: 8,),
                                  Text("Back")],
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF163351), // Button background color
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8), // Rounded border with 0 radius
                                ),
                              ),
                              onPressed: nextStep,
                              child: Row(
                                children: [
                                  Text(step == steps.length - 1 ? "Submit" : "Continue"),
                                  if (step < steps.length - 1) ...[
                                    SizedBox(width: 8), // Adds spacing if not the last step
                                    Icon(Icons.arrow_forward_ios, color: Colors.white),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
