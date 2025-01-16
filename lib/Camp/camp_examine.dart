import 'package:flutter/material.dart';
import 'package:opthadoc/Components/CardComponent.dart';
import 'package:opthadoc/Components/CustomDropdown.dart';
import 'package:opthadoc/Components/InputField.dart';
import 'package:opthadoc/Components/Label.dart';
import 'package:opthadoc/Components/ProgressStep.dart';

class CampExamine extends StatefulWidget {
  const CampExamine({super.key});

  @override
  State<CampExamine> createState() => _CampExamineState();
}

class _CampExamineState extends State<CampExamine> {

  int step = 0;

  final List<Map<String, dynamic>> steps = [
    {"id": "patient", "title": "Patient", "icon": Icons.person},
    {"id": "history", "title": "History", "icon": Icons.description},
    {"id": "exam", "title": "Exam", "icon": "assets/icons/stethoscope.svg"},
    {"id": "workup", "title": "Workup", "icon": Icons.biotech},
    {"id": "dilated", "title": "Dilated", "icon": Icons.visibility},
    {"id": "diagnosis", "title": "Diagnosis", "icon": Icons.assignment_turned_in},
  ];

  void nextStep() {
    // if (!validateStepFields(step)) return;
    if(step == steps.length - 1) {
      // Validate current step fields
      // saveRegistration();
      setState(() {
        step++;
      });
    } else if (step < steps.length - 1) {
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

  @override
  Widget build(BuildContext context) {

    final stepWidgets = [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Patient Information",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Color(0xFF163351),
            ),
          ),
          SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Label(text: "Vision RE"),
                    InputField(hintText: "With PH, BGC, NV")
                  ],
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Label(text: "Vision LE"),
                    InputField(hintText: "With PH, BGC, NV")
                  ],
                ),
              ),
            ],
          )
        ],
      )
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
                          allowStepTap: true,
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
                              onPressed: step<stepWidgets.length-1 ? nextStep : null,
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
