import 'package:flutter/material.dart';
import 'package:opthadoc/Components/CustomDropdown.dart';
import 'package:opthadoc/Components/Label.dart';
import 'package:opthadoc/Components/InputField.dart';
import 'package:opthadoc/Components/StretchedIconButton.dart';
import 'package:opthadoc/Components/VisionMeasurement.dart';
import 'package:opthadoc/Components/ProgressStep.dart';
import 'package:opthadoc/Components/CardComponent.dart';
import 'package:opthadoc/data/DatabaseHelper.dart';
import 'package:opthadoc/Output/Refraction.dart';
import 'package:intl/intl.dart';


class CampEyeCheckup extends StatefulWidget {
  final int initialStep;
  final String? initialPatientToken;
  final String campCode;
  final Function(int, String) onNavigateToExamine;

  const CampEyeCheckup({super.key, this.initialStep = 0, required this.onNavigateToExamine, this.initialPatientToken, required this.campCode});

  @override
  State<CampEyeCheckup> createState() => _CampEyeCheckupState();
}

class _CampEyeCheckupState extends State<CampEyeCheckup> {
  int step = 0;

  bool isChecked = false;

  final List<Map<String, dynamic>> steps = [
    {"title": "Token", "icon": Icons.tag},
    {"title": "Without Glasses", "icon": Icons.visibility_off},
    {"title": "With Glasses", "icon": Icons.visibility},
    {"title": "With Correction", "icon": "assets/icons/eyeglasses.svg"},
    {"title": "Additional Info", "icon": Icons.text_snippet},
  ];

  final Map<String, TextEditingController> controllers = {};

  void saveCheckup() async {
    final dbHelper = DatabaseHelper.instance;

    // Prepare data for saving
    final checkupData = {
      'patientToken': controllers['patientToken']?.text ?? '',
      'withoutGlasses': controllers.entries
          .where((entry) => entry.key.startsWith('withoutGlasses'))
          .map((entry) => '${entry.key}:${entry.value.text}')
          .join(','),
      'withGlasses': controllers.entries
          .where((entry) => entry.key.startsWith('withGlasses'))
          .map((entry) => '${entry.key}:${entry.value.text}')
          .join(','),
      'withCorrection': controllers.entries
          .where((entry) => entry.key.startsWith('withCorrection'))
          .map((entry) => '${entry.key}:${entry.value.text}')
          .join(','),
      'remarks': controllers['remarks']?.text ?? '',
    };

    // Save data to the database
    final id = await dbHelper.insertEyeCheckup(checkupData);
    print('Eye Checkup saved with ID: $id');
  }


  @override
  void initState() {

    super.initState();

    step = widget.initialStep;

    print("Initial Step: $step");

    for (var eye in ['left', 'right']) {
      controllers['withoutGlasses.$eye.distanceVision'] = TextEditingController();
    }

    for (var prefix in ['withGlasses', 'withCorrection']) {
      for (var eye in ['left', 'right']) {
        controllers['$prefix.$eye.distanceVisionSphereSign'] = TextEditingController();
        controllers['$prefix.$eye.distanceVisionSphere'] = TextEditingController();
        controllers['$prefix.$eye.cylinderSign'] = TextEditingController();
        controllers['$prefix.$eye.cylinder'] = TextEditingController();
        controllers['$prefix.$eye.axis'] = TextEditingController();
        controllers['$prefix.$eye.distanceVisionVA'] = TextEditingController();
        controllers['$prefix.$eye.distanceVisionP'] = TextEditingController();
        controllers['$prefix.$eye.nearVisionSphereSign'] = TextEditingController();
        controllers['$prefix.$eye.nearVisionSphere'] = TextEditingController();
        controllers['$prefix.$eye.nearVisionVA'] = TextEditingController();
        controllers['$prefix.$eye.nearVisionP'] = TextEditingController();
      }
      controllers['$prefix.IPD'] = TextEditingController();
      controllers['$prefix.nearVisionRequired'] = TextEditingController(text: 'No');
    }

    controllers['patientToken'] = TextEditingController(
      text: widget.initialPatientToken ?? '', // Initialize with initialPatientToken if provided
    );

    controllers['bifocal'] = TextEditingController();
    controllers['color'] = TextEditingController();
    controllers['remarks'] = TextEditingController();
  }

  @override
  void dispose() {
    // Dispose controllers
    for (var controller in controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void resetForm() {
    setState(() {
      // Reset all text controllers
      for (var controller in controllers.values) {
        controller.text = '';
      }
      // Reset step to the first step
      step = 0;
    });

    print("Form has been reset!");
  }

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
      // Step 0: Patient ID
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Label(text: "Patient Token"),
          SizedBox(height: 8,),
          Row(
            children: [
              Text(
                "${widget.campCode}-${DateFormat('yyyyMMdd').format(DateTime.now())}-",
                style: TextStyle(
                  color: Color(0xFF163351),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: InputField(
                    hintText: "Enter patient token",
                    controller: controllers['patientToken'],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            "Enter the patient's token number to proceed with the eye checkup.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF163351).withValues(alpha: 0.6),
              fontSize: 14,
            )
          )
        ],
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              'Without Glasses',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF163351),
              ),
            ),
          ),
          SizedBox(height: 8,),
          ...['right', 'left'].map((eye) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: const Color(0xFF163351),
                        child: Text(
                          eye == "left" ? "L" : "R",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        eye == "left" ? "Left Eye" : "Right Eye",
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Distance Vision',
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  CustomDropdown(
                    hintText: "Select VA",
                    textStyle: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF163351),
                        fontWeight: FontWeight.bold
                    ),
                    keyName: 'withoutGlasses-$eye-distanceVision',
                    items: ["6/6", "6/9", "6/12", "6/18", "6/24", "6/36", "6/60","3/60","1/60","HM+","PL+","PL-"],
                    selectedValue: controllers['withoutGlasses.$eye.distanceVision']!.text,
                    onChanged: (value) {
                      setState(() {
                        controllers['withoutGlasses.$eye.distanceVision']!.text = value!;
                      });
                    },
                  ),
                ],
              ),
            );
          }),
        ],
      ),
      // Step 1: Without Glasses
      VisionMeasurements(
        key: ValueKey("withGlasses"),
        prefix: "withGlasses",
        controllers: controllers,
      ),
      // Step 2: With Glasses
      VisionMeasurements(
        key: ValueKey("withCorrection"),
        prefix: "withCorrection",
        controllers: controllers,
      ),
      // Step 3: Additional Info
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.search, size: 20, color: Color(0xFF163351)),
              const SizedBox(width: 8),
              Label(text: "Bifocal")
            ],
          ),
          SizedBox(height: 8),
          CustomDropdown(
              keyName: "Bifocal",
              items: ["Kryptok","Executive","D-Segment","Trifocal","Omnivision","Progressive"],
              selectedValue: controllers['bifocal']!.text, // Use controller value
              onChanged: (value) {
                setState(() {
                  controllers['bifocal']!.text = value!; // Update controller
                });
              },
          ),
          SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.color_lens, size: 20, color: Color(0xFF163351)),
              const SizedBox(width: 8),
              Label(text: "Color")
            ],
          ),
          SizedBox(height: 8),
          CustomDropdown(
              keyName: "Color",
              items: ["White","SP2Alpha","Photogrey","Photosun","Photobrown"],
              selectedValue: controllers['color']!.text, // Use controller value
              onChanged: (value) {
                setState(() {
                  controllers['color']!.text = value!; // Update controller
                }); // Update controller
              },
          ),
          SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.chat_bubble, size: 20, color: Color(0xFF163351)),
              const SizedBox(width: 8),
              Label(text: "Remarks")
            ],
          ),
          SizedBox(height: 8),
          CustomDropdown(
              keyName: "Remarks",
              items: ["D.V. only","N.V. only","Constant use"],
              selectedValue: controllers['remarks']!.text, // Use controller value
              onChanged: (value) {
                setState(() {
                  controllers['remarks']!.text = value!;
                });
              },
          ),
          SizedBox(height: 16),
        ],
      ),
      Column(
        children: [
          Text(
            "Refraction test complete. What would you like to do next?",
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF163351),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          StretchedIconButton(
            backgroundColor: const Color(0xFF163351),
            textColor: Colors.white,
            label: "Test Another Patient",
            onPressed: resetForm, // Replace with your onPressed function
          ),
          SizedBox(height: 8),
          StretchedIconButton(
            backgroundColor: const Color(0xFF163351),
            textColor: Colors.white,
            label: "Go to Examination",
            onPressed: () {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                widget.onNavigateToExamine(1, controllers['patientToken']!.text); // Pass step 3 to EyeCheckup after build
              });
            }, // Replace with your onPressed function
          ),
          SizedBox(height: 8),
          StretchedIconButton(
            backgroundColor: const Color(0xFF163351),
            icon: Icons.share,
            textColor: Colors.white,
            label: "Share PDF",
            onPressed: () {
              generateRefraction();
            }, // Replace with your onPressed function
          ),
        ],
      )
    ];

    return Scaffold(
      backgroundColor: Color(0xFFE9E7DB),
      body: SafeArea(
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
                              "Refraction Test",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF163351),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Perform a refraction test for the patient",
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
                        // allowStepTap: false,
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
    );
  }
}
