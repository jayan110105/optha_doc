import 'package:flutter/material.dart';
import 'package:opthadoc/Camp/Examine/Comorbid.dart';
import 'package:opthadoc/Camp/Examine/Diagnosis.dart';
import 'package:opthadoc/Camp/Examine/Dilated.dart';
import 'package:opthadoc/Camp/Examine/Exam.dart';
import 'package:opthadoc/Camp/Examine/PreSurgery.dart';
import 'package:opthadoc/Camp/Examine/Token.dart';
import 'package:opthadoc/Camp/Examine/Workup.dart';
import 'package:opthadoc/Components/CardComponent.dart';
import 'package:opthadoc/Components/ErrorSnackBar.dart';
import 'package:opthadoc/Components/ProgressStep.dart';
import 'package:opthadoc/Camp/Examine/Complaint.dart';
import 'package:opthadoc/Components/StretchedIconButton.dart';
import 'package:opthadoc/Output/Examine.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:opthadoc/main.dart';

bool get isDatabaseDisabled => dotenv.env['DISABLE_DB'] == 'true';
bool get isValidationDisabled => dotenv.env['DISABLE_VALIDATION'] == 'true';

class CampExamine extends StatefulWidget {
  final int initialStep;
  final String? initialPatientToken;
  final String campCode;
  const CampExamine({super.key, this.initialStep = 0, this.initialPatientToken, required this.campCode});

  @override
  State<CampExamine> createState() => _CampExamineState();
}

class _CampExamineState extends State<CampExamine> {

  int step = 0;

  final ScrollController _scrollController = ScrollController();

  final List<Map<String, dynamic>> steps = [
    {"id":"token", "title": "Token", "icon": Icons.tag},
    {"id": "complaint", "title": "Complaint", "icon": Icons.chat},
    {"id": "comorbid", "title": "Comorbid", "icon": "assets/icons/vital_signs.svg"},
    {"id": "exam", "title": "Exam", "icon": "assets/icons/stethoscope.svg"},
    {"id": "workup", "title": "Workup", "icon": Icons.biotech},
    {"id": "dilated", "title": "Dilated", "icon": Icons.visibility},
    {"id": "diagnosis", "title": "Diagnosis", "icon": Icons.assignment_turned_in},
    {"id": "pre-surgery ", "title": "Pre-Surgery", "icon": Icons.assignment},
  ];

  final Map<String, dynamic> _patientData = {
    "vision_re_dv": null, // Distance Vision RE
    "vision_re_nv": null, // Near Vision RE
    "vision_le_dv": null, // Distance Vision LE
    "vision_le_nv": null, // Near Vision LE
    "years-right": null,
    "months-right": null,
    "days-right": null,
    "years-left": null,
    "months-left": null,
    "days-left": null,
  };

  final Map<String, dynamic> _historyData = {
    for (var eye in ['right', 'left'])
      for (var label in [
        "Diminution of vision",
        "Ocular Trauma",
        "Flashes",
        "Floaters",
        "Glaucoma on Rx",
        "Pain/redness",
        "Watering/discharge",
      ])
        "$label-$eye": null, // For radio or dropdown selections

    for (var eye in ['right', 'left'])
      "Nature of Trauma-$eye": TextEditingController(),

    // **Only one instance of these fields (not per eye)**
    "History of glasses": null,
    "Are PG comfortable ?": null,
    "Last Glass change": TextEditingController(), // Text input
    "Previous surgery/laser rx": null,
    "Details of surgery/procedure": TextEditingController(), // Text input
  };


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

  final Map<String, dynamic> _workupData = {
    "re-ducts": "",
    "le-ducts": "",
    "sbp": TextEditingController(),
    "dbp": TextEditingController(),
    "grbs": TextEditingController(),
  };

  final Map<String, dynamic> _dilatedData = {
    "mydriasis-right": null,
    "mydriasis-left": null,
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

  final Map<String, dynamic> _diagnosisData = {
    for (var eye in ['right', 'left'])
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

    "notes": TextEditingController()
  };

  final Map<String, dynamic> _preSurgeryData = {
    "Cardio/Medicine clearance for surgery": null,
    "IOP": false,
    "BSCAN": false,
    "Systemic evaluation": false,
  };

  final TextEditingController _tokenController = TextEditingController();

  void _updateValue(String key, dynamic value) {
    if (_patientData.containsKey(key)) {
      setState(() {
        _patientData[key] = value;
      });
    } else if (_historyData.containsKey(key)) {
      setState(() {
        _historyData[key] = value;
      });
    }
  }

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

  // Function to update values in the controller
  void _updateWorkupValue(String key, dynamic value) {
    setState(() {
      _workupData[key] = value;
    });
  }

  // Function to update values in the controller
  void _updateDilatedValue(String key, dynamic value) {
    setState(() {
      _dilatedData[key] = value;
    });
  }

  // Function to update values in the controller
  void _updateDiagnosisValue(String key, dynamic value) {
    setState(() {
      _diagnosisData[key] = value;
    });
  }

  // Function to update values in the controller
  void _updatePreSurgeryValue(String key, dynamic value) {
    setState(() {
      _preSurgeryData[key] = value;
    });
  }

  void scrollToTop() {
    _scrollController.animateTo(
      0.0,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
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

  void prevStep() {
    if (step > 0) {
      setState(() {
        step--;
      });
      scrollToTop();
    }
  }

  bool validateStepFields(int currentStep) {

    if (isValidationDisabled) {
      print('Validation is disabled during testing.');
      return true;
    }

    List<String> requiredFields;

    Map<String, String> fieldLabels = {
      "token": "Patient Token",
      "vision_re_dv": "Right Eye Distance Vision",
      "vision_le_dv": "Left Eye Distance Vision",
      "visualAxis-right": "Right Eye Visual Axis",
      "visualAxis-left": "Left Eye Visual Axis",
      "eom-right": "Right Eye Extraocular Movements",
      "eom-left": "Left Eye Extraocular Movements",
      "conjunctiva-right": "Right Eye Conjunctiva",
      "conjunctiva-left": "Left Eye Conjunctiva",
      "cornea-right": "Right Eye Cornea",
      "cornea-left": "Left Eye Cornea",
      "ac-right": "Right Eye Anterior Chamber",
      "ac-left": "Left Eye Anterior Chamber",
      "pupilReactions-right": "Right Eye Pupil Reactions",
      "pupilReactions-left": "Left Eye Pupil Reactions",
      "lens-right": "Right Eye Lens",
      "lens-left": "Left Eye Lens",
    };

    switch (currentStep) {
      case 0: // Step 0: Token
        requiredFields = ["token"];
        break;

      case 1: // Step 1: Complaint
        requiredFields = ["vision_re_dv", "vision_le_dv"];
        break;

      case 3: // Step 3: Examination
        requiredFields = [
          "visualAxis-right",
          "visualAxis-left",
          "eom-right",
          "eom-left",
          "conjunctiva-right",
          "conjunctiva-left",
          "cornea-right",
          "cornea-left",
          "ac-right",
          "ac-left",
          "pupilReactions-right",
          "pupilReactions-left",
          "lens-right",
          "lens-left",
        ];
        break;

      case 4: // Step 4: Workup
        requiredFields = [];
        break;

      case 5: // Step 5: Dilated
        requiredFields = [];
        break;

      case 6: // Step 6: Diagnosis
        requiredFields = [];
        break;

      case 7: // Step 7: Pre-Surgery
        requiredFields = [];
        break;

      default:
        return true; // No validation needed for undefined steps
    }

    for (var field in requiredFields) {
      final fieldValue = _getFieldValue(field);

      if (fieldValue == null || fieldValue.toString().isEmpty) {
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

  dynamic _getFieldValue(String key) {
    if (key == "token") {
      return _tokenController.text; // Fetch token from the controller
    }else if (_patientData.containsKey(key)) {
      return _patientData[key];
    } else if (_historyData.containsKey(key)) {
      final value = _historyData[key];
      return value is TextEditingController ? value.text : value;
    } else if (_comorbidities.containsKey(key)) {
      return _comorbidities[key];
    } else if (_examData.containsKey(key)) {
      return _examData[key];
    } else if (_workupData.containsKey(key)) {
      final value = _workupData[key];
      return value is TextEditingController ? value.text : value;
    } else if (_dilatedData.containsKey(key)) {
      return _dilatedData[key];
    } else if (_diagnosisData.containsKey(key)) {
      return _diagnosisData[key];
    } else if (_preSurgeryData.containsKey(key)) {
      return _preSurgeryData[key];
    }
    return null;
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


  void resetForm() {
    setState(() {
      // Reset all map data to their initial state
      _patientData.updateAll((key, value) => null);
      _historyData.forEach((key, value) {
        if (value is TextEditingController) {
          value.clear();
        } else {
          _historyData[key] = null;
        }
      });
      _comorbidities.updateAll((key, value) => false);
      _examData.updateAll((key, value) => "");
      _workupData.forEach((key, value) {
        if (value is TextEditingController) {
          value.clear();
        } else {
          _workupData[key] = "";
        }
      });
      _dilatedData.updateAll((key, value) => null);
      _diagnosisData.updateAll((key, value) => false);
      _preSurgeryData.updateAll((key, value) => null);

      // Reset the token controller
      _tokenController.clear();

      // Reset the step to the first step
      step = 0;
    });

    print("Form has been reset!");
  }


  @override
  void dispose() {
    _tokenController.dispose();
    _historyData.forEach((key, value) {
      if (value is TextEditingController) {
        value.dispose();
      }
    });
    _workupData.forEach((key, value) {
      if (value is TextEditingController) {
        value.dispose();
      }
    });
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    step = widget.initialStep;

    _tokenController.text = widget.initialPatientToken ?? '' ;
  }

  @override
  Widget build(BuildContext context) {

    final stepWidgets = [
      Token(controller: _tokenController, campCode: widget.campCode,),
      Complaint(patientData: _patientData, historyData: _historyData, updateValue: _updateValue,),
      Comorbid(comorbidities: _comorbidities, updateValue: _updateComorbidity,),
      Exam(data: _examData, updateValue: _updateExamValue,),
      Workup(data: _workupData, updateValue: _updateWorkupValue,),
      Dilated(data: _dilatedData, updateValue: _updateDilatedValue,),
      Diagnosis(data: _diagnosisData, updateValue: _updateDiagnosisValue,),
      PreSurgery(data: _preSurgeryData, updateValue: _updatePreSurgeryValue,),
      Column(
        children: [
          Text(
            "Examination complete. What would you like to do next?",
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
            label: "Examine Another Patient",
            onPressed: resetForm, // Replace with your onPressed function
          ),
          SizedBox(height: 8),
          StretchedIconButton(
            backgroundColor: const Color(0xFF163351),
            icon: Icons.share,
            textColor: Colors.white,
            label: "Share PDF",
            onPressed: () {
              generateExamine(
                _patientData,
                _historyData,
                _comorbidities,
                _examData,
                _workupData,
                _dilatedData,
                _diagnosisData,
                _preSurgeryData,
              );
            }, // Replace with your onPressed function
          ),
        ],
      )
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFE9E7DB),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
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
                              "Camp Examination",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF163351),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Medical Examination Form",
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
                        allowStepTap: isValidationDisabled,
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
    );
  }
}
