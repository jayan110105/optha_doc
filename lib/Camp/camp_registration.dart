import 'dart:io';
import 'package:flutter/material.dart';
import 'package:opthadoc/Components/Label.dart';
import 'package:opthadoc/Components/InputField.dart';
import 'package:opthadoc/Components/CustomTextArea.dart';

class CampRegistration extends StatefulWidget {
  const CampRegistration({super.key});

  @override
  State<CampRegistration> createState() => _CampRegistrationState();
}

class _CampRegistrationState extends State<CampRegistration> {
  int step = 0;

  final List<Map<String, dynamic>> steps = [
    {"id": "photo", "title": "Photo", "icon": Icons.camera_alt},
    {"id": "basic", "title": "Basic Info", "icon": Icons.person},
    {"id": "gender", "title": "Gender", "icon": Icons.group},
    {"id": "details", "title": "Details", "icon": Icons.description},
  ];

  final formData = {
    "photo": null,
    "name": "",
    "age": "",
    "gender": "",
    "aadhar": "",
    "parent": "",
    "phone": "",
    "address": "",
    "complaint": "",
  };

  void updateForm(String key, dynamic value) {
    setState(() {
      formData[key] = value;
    });
  }

  void nextStep() {
    if (step < steps.length - 1) {
      setState(() {
        step++;
      });
    }
  }

  void prevStep() {
    if (step > 0) {
      setState(() {
        step--;
      });
    }
  }

  void scanAadhar() {
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        formData["name"] = "John Doe";
        formData["age"] = "30";
        formData["gender"] = "Male";
        formData["aadhar"] = "1234 5678 9012";
        formData["address"] = "123 Main St, City, State, PIN: 123456";
        step = 2;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // Define the widget array for each step
    final stepWidgets = [
      // Step 1: Photo
      Center(
        child: Column(
          children: [
            CircleAvatar(
              radius: 80,
              backgroundColor: Color(0xFF163351).withOpacity(0.1),
              backgroundImage: formData["photo"] != null
                  ? FileImage(formData["photo"] as File)
                  : null,
              child: formData["photo"] == null
                  ? Icon(
                Icons.camera_alt,
                color: Color(0xFF163351).withOpacity(0.4),
                size: 50,
              )
                  : null,
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
            hintText: "Enter patient name",
            onChanged: (value) => updateForm("name", value),
          ),
          const SizedBox(height: 16),
          Label(text: "Age"),
          const SizedBox(height: 8),
          InputField(
            hintText: "Enter age",
            onChanged: (value) => updateForm("age", value),
          ),
          SizedBox(height: 24),
          SizedBox(
            width: double.infinity, // Makes the button stretch across the container
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF163351),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: scanAadhar,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center, // Centers the content
                children: [
                  Icon(Icons.qr_code_scanner, color: Colors.white),
                  SizedBox(width: 8),
                  Text("Scan Aadhar"),
                ],
              ),
            ),
          )
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
            onTap: () => updateForm("gender", gender),
            child: Container(
              width: 90, // Fixed width for each item
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: formData["gender"] == gender
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
                    color: formData["gender"] == gender
                        ? Colors.grey[200]
                        : Color(0xFF163351),
                    size: 30,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    gender,
                    style: TextStyle(
                      color: formData["gender"] == gender
                          ? Colors.grey[200]
                          : Color(0xFF163351),
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
            hintText: "Enter Aadhar number",
            onChanged: (value) => updateForm("aadhar", value),
          ),
          SizedBox(height: 16),
          Label(text: "Parent/Spouse Name"),
          SizedBox(height: 8),
          InputField(
            hintText: "Enter parent/spouse name",
            onChanged: (value) => updateForm("parent", value),
          ),
          SizedBox(height: 16),
          Label(text: "Phone Number"),
          SizedBox(height: 8),
          InputField(
            hintText: "Enter phone number",
            onChanged: (value) => updateForm("phone", value),
          ),
          SizedBox(height: 16),
          Label(text: "Address"),
          SizedBox(height: 8),
          CustomTextArea(
            hintText: "Enter address",
            onChanged: (value) => updateForm("address", value),
            isEnabled: true,
            minLines: 5,
            maxLines: null, // Allows unlimited lines
          ),
          SizedBox(height: 16),
          Label(text: "Chief Complaint"),
          SizedBox(height: 8),
          CustomTextArea(
            hintText: "Enter chief complaint",
            onChanged: (value) => updateForm("complaint", value),
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
                        // Use the current step widget
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: steps.map((s) {
                            int index = steps.indexOf(s);
                            return Column(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor:
                                  step >= index ? Color(0xFF163351) : Colors.grey[300],
                                  child: Icon(
                                    step > index ? Icons.check_circle : s["icon"],
                                    color: step >= index ? Colors.white : Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  s["title"],
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: step >= index
                                        ? Color(0xFF163351)
                                        : Colors.grey[600],
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                spreadRadius: 2,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: stepWidgets[step],
                          ), // Display the current step widget
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
                              onPressed:
                              step == steps.length - 1 ? () => print(formData) : nextStep,
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
