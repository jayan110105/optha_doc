import 'package:flutter/material.dart';
import 'package:opthadoc/Components/CustomDropdown.dart';
import 'package:opthadoc/Components/CustomTextArea.dart';
import 'package:opthadoc/Components/Label.dart';
import 'package:opthadoc/Components/InputField.dart';
import 'package:opthadoc/Components/StretchedIconButton.dart';
import 'package:opthadoc/Components/VisionMeasurement.dart';
import 'package:opthadoc/Components/ProgressStep.dart';
import 'package:opthadoc/Components/CardComponent.dart';

class CampEyeCheckup extends StatefulWidget {
  const CampEyeCheckup({super.key});

  @override
  State<CampEyeCheckup> createState() => _CampEyeCheckupState();
}

class _CampEyeCheckupState extends State<CampEyeCheckup> {
  int step = 0;

  bool isChecked = false;

  final List<Map<String, dynamic>> steps = [
    {"title": "Patient ID", "icon": Icons.search},
    {"title": "Without Glasses", "icon": Icons.visibility_off},
    {"title": "With Glasses", "icon": Icons.visibility},
    {"title": "With Correction", "icon": "assets/icons/eyeglasses.svg"},
    {"title": "Additional Info", "icon": Icons.text_snippet},
  ];

  final Map<String, TextEditingController> controllers = {};

  @override
  void initState() {

    super.initState();
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

    controllers['patientId'] = TextEditingController();

    controllers['bifocal'] = TextEditingController();
    controllers['color'] = TextEditingController();
    controllers['remarks'] = TextEditingController();
    controllers['complaint'] = TextEditingController();
  }

  @override
  void dispose() {
    // Dispose controllers
    for (var controller in controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void nextStep() => setState(() => step = (step + 1).clamp(0, steps.length - 1));
  void prevStep() => setState(() => step = (step - 1).clamp(0, steps.length - 1));

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
              controller: controllers['patientId'],
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
                    items: ["6/6", "6/9", "6/12", "6/18", "6/24", "6/36", "6/60","3/60","1/60"],
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
          Label(text: "Brief Complaint"),
          SizedBox(height: 8),
          CustomTextArea(
              hintText: "Enter patient's complaint",
              isEnabled: true,
              minLines: 3,
              maxLines: null,
              controller: controllers['complaint'],
          )
        ],
      ),
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
                            onPressed:
                            step == steps.length - 1 ? () => print("") : nextStep,
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
