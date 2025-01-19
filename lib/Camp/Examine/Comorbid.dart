import 'package:flutter/material.dart';
import 'package:opthadoc/Components/CustomCheckbox.dart';

class Comorbid extends StatefulWidget {
  const Comorbid({super.key});

  @override
  State<Comorbid> createState() => _ComorbidState();
}

class _ComorbidState extends State<Comorbid> {
  final Map<String, bool> comorbidities = {
    "Diabetes mellitus": false,
    "Hypertension": false,
    "Heart disease": false,
    "Asthma": false,
    "Allergy to dust/meds": false,
    "Benign prostatic hyperplasia on treatment": false,
    "Is the patient On Antiplatelets" : false,
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
    for (var key in comorbidities.keys) {
      controllers[key] = TextEditingController();
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> comorbidityKeys = comorbidities.keys.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Comorbidities and Medications",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Color(0xFF163351),
          ),
        ),
        SizedBox(height: 24),
        Column(
          children: [
            for (int i = 0; i < comorbidityKeys.length; i += 2)
              Row(
                children: [
                  Expanded(
                    child: CustomCheckbox(
                      value: comorbidities[comorbidityKeys[i]] ?? false,
                      onChanged: (bool? value) {
                        setState(() {
                          comorbidities[comorbidityKeys[i]] = value ?? false;
                        });
                      },
                      controllers: controllers,
                      text: comorbidityKeys[i],
                    ),
                  ),
                  const SizedBox(width: 16),
                  if (i + 1 < comorbidityKeys.length) // Check if next item exists
                    Expanded(
                      child: CustomCheckbox(
                        value: comorbidities[comorbidityKeys[i + 1]] ?? false,
                        onChanged: (bool? value) {
                          setState(() {
                            comorbidities[comorbidityKeys[i + 1]] = value ?? false;
                          });
                        },
                        controllers: controllers,
                        text: comorbidityKeys[i + 1],
                      ),
                    ),
                ],
              ),
          ],
        ),
      ],
    );
  }
}
