import 'package:flutter/material.dart';
import 'package:opthadoc/Components/CustomCheckbox.dart';

class Diagnosis extends StatefulWidget {
  const Diagnosis({super.key});

  @override
  State<Diagnosis> createState() => _DiagnosisState();
}

class _DiagnosisState extends State<Diagnosis> {
  final Map<String, bool> diagnosis = {
    "Immature cataract": false,
    "Near Mature cataract": false,
    "Mature Cataract": false,
    "Hypermature Cataract": false,
    "PCIOL": false,
    "Aphakia": false,
    "Pterygium": false,
    "Dacryocystitis": false,
    "Amblyopia": false,
    "Glaucoma": false,
    "Diabetic retinopathy": false,
    "Stye": false,
    "Conjunctivitis": false,
    "Dry eye": false,
    "Allergic conjunctivitis": false,
  };

  final Map<String, TextEditingController> controllers = {};

  @override
  void dispose() {
    // Dispose controllers to avoid memory leaks
    for (var controller in controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Initialize controllers for each comorbidity
    for (var key in diagnosis.keys) {
      controllers[key] = TextEditingController();
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> diagnosisKeys = diagnosis.keys.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Diagnosis",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Color(0xFF163351),
          ),
        ),
        SizedBox(height: 24),
        ...['right', 'left', 'both'].map((eye) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                eye == "right" ? "RE :" : eye == "left" ? "LE :" : "BE :",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF163351),
                ),
              ),
              SizedBox(height: 16),
              for (int i = 0; i < diagnosisKeys.length; i += 2)
                Row(
                  children: [
                    Expanded(
                      child: CustomCheckbox(
                        value: diagnosis[diagnosisKeys[i]] ?? false,
                        onChanged: (bool? value) {
                          setState(() {
                            diagnosis[diagnosisKeys[i]] = value ?? false;
                          });
                        },
                        controllers: controllers,
                        text: diagnosisKeys[i],
                      ),
                    ),
                    const SizedBox(width: 16),
                    if (i + 1 < diagnosisKeys.length) // Check if next item exists
                      Expanded(
                        child: CustomCheckbox(
                          value: diagnosis[diagnosisKeys[i + 1]] ?? false,
                          onChanged: (bool? value) {
                            setState(() {
                              diagnosis[diagnosisKeys[i + 1]] = value ?? false;
                            });
                          },
                          controllers: controllers,
                          text: diagnosisKeys[i + 1],
                        ),
                      ),
                  ],
                ),
              SizedBox(height: 16),
            ],
          );
        }),
      ],
    );
  }
}
