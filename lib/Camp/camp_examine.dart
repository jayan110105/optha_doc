import 'package:flutter/material.dart';
import 'package:opthadoc/Camp/Examine/Comorbid.dart';
import 'package:opthadoc/Camp/Examine/Diagnosis.dart';
import 'package:opthadoc/Camp/Examine/Dilated.dart';
import 'package:opthadoc/Camp/Examine/Exam.dart';
import 'package:opthadoc/Camp/Examine/PreSurgery.dart';
import 'package:opthadoc/Camp/Examine/Workup.dart';
import 'package:opthadoc/Components/CardComponent.dart';
import 'package:opthadoc/Components/ProgressStep.dart';
import 'package:opthadoc/Camp/Examine/Patient.dart';
import 'package:opthadoc/Camp/Examine/History.dart';

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
    {"id": "comorbid", "title": "Comorbid", "icon": "assets/icons/vital_signs.svg"},
    {"id": "exam", "title": "Exam", "icon": "assets/icons/stethoscope.svg"},
    {"id": "workup", "title": "Workup", "icon": Icons.biotech},
    {"id": "dilated", "title": "Dilated", "icon": Icons.visibility},
    {"id": "diagnosis", "title": "Diagnosis", "icon": Icons.assignment_turned_in},
    {"id": "pre-surgery ", "title": "Pre-Surgery", "icon": Icons.assignment},
  ];

  final Map<String, TextEditingController> patientControllers = {
    "vision_re": TextEditingController(),
    "vision_le": TextEditingController(),
    "complaint_re": TextEditingController(),
    "complaint_le": TextEditingController(),
    "complaint_duration": TextEditingController(),
  };

  final Map<String, dynamic> historyData = {
    "Ocular Trauma": null,
    "Flashes": null,
    "Floaters": null,
    "Glaucoma on Rx": null,
    "Pain/redness": null,
    "Watering/discharge": null,
    "History of glasses": null,
    "Are PG comfortable ?": null,
    "Last Glass change": TextEditingController(),
    "Previous surgery/laser rx": null,
    "Details of surgery/procedure": TextEditingController(),
  };

  void updateHistoryValue(String key, dynamic value) {
    setState(() {
      historyData[key] = value;
    });
  }

  final Map<String, bool> _comorbidities = {
    "Diabetes mellitus": false,
    "Hypertension": false,
    "Heart disease": false,
    "Asthma": false,
    "Allergy to dust/meds": false,
    "Benign prostatic hyperplasia on treatment": false,
    "Is the patient On Antiplatelets": false,
  };

  final Map<String, String> _examData = {
    "visualAxis-right": "",
    "visualAxis-left": "",
    "eom-right": "",
    "eom-left": "",
    "conjunctiva-right": "",
    "conjunctiva-left": "",
    "cornea-right": "",
    "cornea-left": "",
    "ac-right": "",
    "ac-left": "",
    "pupilReactions-right": "",
    "pupilReactions-left": "",
    "lens-right": "",
    "lens-left": "",
  };

  // Function to update values in the controller
  void _updateExamValue(String key, String value) {
    setState(() {
      _examData[key] = value;
    });
  }

  // Function to update values in the controller
  void _updateComorbidity(String key, bool value) {
    setState(() {
      _comorbidities[key] = value;
    });
  }

  final Map<String, dynamic> _workupData = {
    "re-ducts": "",
    "le-ducts": "",
    "bp": TextEditingController(),
    "grbs": TextEditingController(),
  };

  // Function to update values in the controller
  void _updateWorkupValue(String key, dynamic value) {
    setState(() {
      _workupData[key] = value;
    });
  }

  final Map<String, dynamic> _dilatedData = {
    "mydriasis-right": TextEditingController(),
    "mydriasis-left": TextEditingController(),
    "fundus-right": "",
    "fundus-left": "",
    "Cataract-right": null,
    "Cataract-left": null,
    "Glaucoma-right": null,
    "Glaucoma-left": null,
    "Diabetic retinopathy-right": null,
    "Diabetic retinopathy-left": null,
    "ARMD-right": null,
    "ARMD-left": null,
    "Optic disc pallor/ atrophy-right": null,
    "Optic disc pallor/ atrophy-left": null,
  };

  // Function to update values in the controller
  void _updateDilatedValue(String key, dynamic value) {
    setState(() {
      _dilatedData[key] = value;
    });
  }

  final Map<String, dynamic> _diagnosisData = {
    for (var eye in ['right', 'left', 'both'])
      for (var label in [
        "Immature cataract",
        "Near Mature cataract",
        "Mature Cataract",
        "Hypermature Cataract",
        "PCIOL",
        "Aphakia",
        "Pterygium",
        "Dacryocystitis",
        "Amblyopia",
        "Glaucoma",
        "Diabetic retinopathy",
        "Stye",
        "Conjunctivitis",
        "Dry eye",
        "Allergic conjunctivitis",
      ])
        "$label-$eye": false,
  };

  // Function to update values in the controller
  void _updateDiagnosisValue(String key, dynamic value) {
    setState(() {
      _diagnosisData[key] = value;
    });
  }

  final Map<String, dynamic> _preSurgeryData = {
    "Cardio/Medicine clearance for surgery": null,
    "IOP": false,
    "BSCAN": false,
    "Systemic evaluation": false,
  };

  // Function to update values in the controller
  void _updatePreSurgeryValue(String key, dynamic value) {
    setState(() {
      _preSurgeryData[key] = value;
    });
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
      Patient(controllers: patientControllers,),
      History(controller: historyData, updateValue: updateHistoryValue,),
      Comorbid(comorbidities: _comorbidities, updateValue: _updateComorbidity,),
      Exam(data: _examData, updateValue: _updateExamValue,),
      Workup(data: _workupData, updateValue: _updateWorkupValue,),
      Dilated(data: _dilatedData, updateValue: _updateDilatedValue,),
      Diagnosis(data: _diagnosisData, updateValue: _updateDiagnosisValue,),
      PreSurgery(data: _preSurgeryData, updateValue: _updatePreSurgeryValue,),
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
