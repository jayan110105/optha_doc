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
import 'package:opthadoc/Components/ErrorSnackBar.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:opthadoc/main.dart';

bool get isDatabaseDisabled => dotenv.env['DISABLE_DB'] == 'true';
bool get isValidationDisabled => dotenv.env['DISABLE_VALIDATION'] == 'true';

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}

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

  final ScrollController _scrollController = ScrollController();

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
    await dbHelper.insertEyeCheckup(checkupData);
  }

  void scrollToTop() {
    _scrollController.animateTo(
      0.0,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  void initState() {

    super.initState();

    step = widget.initialStep;

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
        controllers['$prefix.$eye.axis']?.text = '0';
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
    for (var controller in controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void resetForm() {
    setState(() {
      for (var controller in controllers.values) {
        controller.text = '';
      }
      step = 0;
    });
  }

  void nextStep() {
    if (!validateStepFields(step)) return;
    if(step == steps.length - 1) {
      setState(() {
        step++;
      });
      scrollToTop();
    } else if (step < steps.length - 1) {
      setState(() {
        step++;
      });
      scrollToTop();
    }
  }

  bool validateStepFields(int currentStep) {

    if (isValidationDisabled) {
      return true;
    }

    List<String> requiredFields;

    Map<String, String> fieldLabels = {
      "patientToken": "Patient Token",
      "withoutGlasses.left.distanceVision": "Left Eye Distance Vision",
      "withoutGlasses.right.distanceVision": "Right Eye Distance Vision",

      "withCorrection.left.distanceVisionSphereSign": "Left Eye Sphere (With Correction)",
      "withCorrection.left.distanceVisionSphere": "Left Eye Sphere (With Correction)",
      "withCorrection.left.axis": "Left Eye Axis (With Correction)",
      "withCorrection.left.distanceVisionVA": "Left Eye Visual Acuity (With Correction)",

      "withCorrection.left.nearVisionSphereSign": "Left Eye Sphere (With Correction)",
      "withCorrection.left.nearVisionSphere": "Left Eye Sphere (With Correction)",
      "withCorrection.left.nearVisionVA": "Left Eye Visual Acuity (With Correction)",

      "withCorrection.right.distanceVisionSphereSign": "Right Eye Sphere (With Correction)",
      "withCorrection.right.distanceVisionSphere": "Right Eye Sphere (With Correction)",
      "withCorrection.right.cylinderSign": "Right Eye Cylinder (With Correction)",
      "withCorrection.right.cylinder": "Right Eye Cylinder (With Correction)",
      "withCorrection.right.axis": "Right Eye Axis (With Correction)",
      "withCorrection.right.distanceVisionVA": "Right Eye Visual Acuity (With Correction)",

      "withCorrection.right.nearVisionSphereSign": "Right Eye Sphere (With Correction)",
      "withCorrection.right.nearVisionSphere": "Right Eye Sphere (With Correction)",
      "withCorrection.right.nearVisionVA": "Right Eye Visual Acuity (With Correction)",

      "bifocal": "Bifocal Type",
      "color": "Lens Color",
      "remarks": "Remarks",
    };

    switch (currentStep) {
      case 0: // Step 0: Token
        requiredFields = ["patientToken"];
        break;

      case 1: // Step 1: Without Glasses
        requiredFields = [
          "withoutGlasses.left.distanceVision",
          "withoutGlasses.right.distanceVision"
        ];
        break;

      case 2: // Step 2: With Glasses
        requiredFields = [];
        break;

      case 3: // Step 3: With Correction
        requiredFields = [
          "withCorrection.left.distanceVisionSphereSign",
          "withCorrection.left.distanceVisionSphere",
          "withCorrection.left.axis",
          "withCorrection.left.distanceVisionVA",

          "withCorrection.right.distanceVisionSphereSign",
          "withCorrection.right.distanceVisionSphere",
          "withCorrection.right.axis",
          "withCorrection.right.distanceVisionVA",
        ];

        if(controllers['withCorrection.nearVisionRequired']!.text == "Yes") {
          requiredFields.add("withCorrection.left.nearVisionSphereSign");
          requiredFields.add("withCorrection.left.nearVisionSphere");
          requiredFields.add("withCorrection.left.nearVisionVA");
          requiredFields.add("withCorrection.right.nearVisionSphereSign");
          requiredFields.add("withCorrection.right.nearVisionSphere");
          requiredFields.add("withCorrection.right.nearVisionVA");
        }
        break;

      case 4: // Step 4: Additional Info
        requiredFields = ["bifocal", "color", "remarks"];
        break;

      default:
        return true; // No validation needed for undefined steps
    }

    for (var field in requiredFields) {
      if (controllers[field]?.text.isEmpty ?? true) {
        showCustomSnackBar(
          context,
          "${fieldLabels[field] ?? field} is required",
          "Please enter the ${fieldLabels[field]?.toLowerCase() ?? field.replaceAll('_', ' ')} to proceed.",
        );
        return false;
      }
    }

    return true; // All fields are valid
  }

  void showCustomSnackBar(BuildContext context, String title, String message) {
    // Remove any existing SnackBar before showing a new one
    scaffoldMessengerKey.currentState?.hideCurrentSnackBar();

    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2), // Ensures it disappears after a while
        content: ErrorSnackBar(
          title: title,
          message: message,
        ),
      ),
    );
  }


  void prevStep() {
    if (step > 0) {
      setState(() {
        step--;
      });
      scrollToTop();
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
                    isNumber: true,
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
              generateRefraction(controllers);
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
                controller: _scrollController,
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
