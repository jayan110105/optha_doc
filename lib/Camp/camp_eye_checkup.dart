import 'package:flutter/material.dart';
import 'package:opthadoc/Components/Label.dart';
import 'package:opthadoc/Components/InputField.dart';
import 'package:opthadoc/Components/StretchedIconButton.dart';
import 'package:opthadoc/Components/VisionMeasurement.dart';

class CampEyeCheckup extends StatefulWidget {
  const CampEyeCheckup({super.key});

  @override
  State<CampEyeCheckup> createState() => _CampEyeCheckupState();
}

class _CampEyeCheckupState extends State<CampEyeCheckup> {
  int step = 0;

  bool isChecked = false;

  final List<Map<String, dynamic>> steps = [
    {"id": "patient", "title": "Patient ID", "icon": Icons.search},
    {"id": "without-glasses", "title": "Without Glasses", "icon": Icons.visibility_off},
    {"id": "with-glasses", "title": "With Glasses", "icon": Icons.visibility},
    {"id": "additional", "title": "Additional Info", "icon": Icons.check_circle},
  ];

  final Map<String, dynamic> formData = {
    "patientId": "",
    "withoutGlasses": {
      "left": {"sphere": "", "cylinder": "", "axis": "", "va": ""},
      "right": {"sphere": "", "cylinder": "", "axis": "", "va": ""},
    },
    "withGlasses": {
      "left": {"sphere": "", "cylinder": "", "axis": "", "va": ""},
      "right": {"sphere": "", "cylinder": "", "axis": "", "va": ""},
    },
    "complaint": "",
    "ipd": "",
    "nearVision": false,
  };

  void updateForm(String key, dynamic value) {
    setState(() {
      final keys = key.split('.');
      Map<String, dynamic> currentMap = formData;
      for (int i = 0; i < keys.length - 1; i++) {
        currentMap = currentMap[keys[i]] as Map<String, dynamic>;
      }
      currentMap[keys.last] = value;
    });
  }

  void nextStep() => setState(() => step = (step + 1).clamp(0, steps.length - 1));
  void prevStep() => setState(() => step = (step - 1).clamp(0, steps.length - 1));

  Widget buildProgressSteps() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: steps.map((s) {
        int index = steps.indexOf(s);
        return Column(
          children: [
            CircleAvatar(
              backgroundColor: step >= index ? Color(0xFF163351) : Color(0xFF163351).withValues(alpha: 0.1),
              child: Icon(
                step > index ? Icons.check_circle : s["icon"],
                color: step >= index ? Colors.white : Color(0xFF163351).withValues(alpha: 0.4),
              ),
            ),
            SizedBox(height: 4),
            Text(s["title"], style: TextStyle(fontSize: 12, color: step >= index
                ? Color(0xFF163351)
                : Colors.grey[600],)),
          ],
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {

    final stepWidgets = [
      // Step 0: Patient ID
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Label(text: "Patient ID"),
          SizedBox(height: 8,),
          InputField(
              hintText: "Enter patient ID",
              onChanged: (value) => updateForm("patientId", value),
          ),
          SizedBox(height: 16),
          StretchedIconButton(
            backgroundColor: const Color(0xFF163351),
            textColor: Colors.white,
            icon: Icons.search,
            label: "Find Patient",
            onPressed: nextStep, // Replace with your onPressed function
          ),
        ],
      ),
      // Step 1: Without Glasses
      VisionMeasurements(
        prefix: "withoutGlasses",
        isChecked: false,
        onCheckboxChanged: (value) {
          print("Checkbox changed: $value");
        },
        formData: formData,
        updateForm: (key, value) {
          setState(() {
            formData[key] = value;
          });
        },
      ),
      // Step 2: With Glasses
      VisionMeasurements(
        prefix: "withGlasses",
        isChecked: false,
        onCheckboxChanged: (value) {
          print("Checkbox changed: $value");
        },
        formData: formData,
        updateForm: (key, value) {
          setState(() {
            formData[key] = value;
          });
        },
      ),
      // Step 3: Additional Info
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            onChanged: (value) => updateForm("complaint", value),
            decoration: InputDecoration(labelText: "Brief Complaint"),
          ),
          SizedBox(height: 10),
          TextField(
            onChanged: (value) => updateForm("ipd", value),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: "IPD Value"),
          ),
          Row(
            children: [
              Checkbox(
                value: formData["nearVision"],
                onChanged: (value) => updateForm("nearVision", value),
              ),
              Text("Near Vision Required"),
            ],
          ),
        ],
      ),
    ];

    return Scaffold(
      backgroundColor: Color(0xFFE9E7DB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Eye Checkup",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF163351),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Perform an eye checkup for the patient",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF163351).withValues(alpha: 0.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        buildProgressSteps(),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: .1),
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
                                  Text(step == steps.length - 1 ? "Save Checkup" : "Continue"),
                                  if (step < steps.length - 1) ...[
                                    SizedBox(width: 8), // Adds spacing if not the last step
                                    Icon(Icons.arrow_forward_ios, color: Colors.white),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
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
