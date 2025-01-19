import 'package:flutter/material.dart';
import 'package:opthadoc/Components/CustomCheckbox.dart';
import 'package:opthadoc/Components/CustomRadioGroup.dart';
import 'package:opthadoc/Components/Label.dart';

class PreSurgery extends StatefulWidget {
  const PreSurgery({super.key});

  @override
  State<PreSurgery> createState() => _PreSurgeryState();
}

class _PreSurgeryState extends State<PreSurgery> {

  final Map<String, String?> selectedValues = {};

  final Map<String, bool> arrival = {
    "IOP": false,
    "BSCAN": false,
    "Systemic evaluation": false,
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
    for (var key in arrival.keys) {
      controllers[key] = TextEditingController();
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> arrivalKeys = arrival.keys.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Pre-Surgery Evaluation",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Color(0xFF163351),
          ),
        ),
        SizedBox(height: 24),
        Label(text: "Cardio/Medicine clearance for surgery"),
        CustomRadioGroup(
          selectedValue: selectedValues["Cardio/Medicine clearance for surgery"],
          onChanged: (value) {
            setState(() {
              selectedValues["Cardio/Medicine clearance for surgery"] = value;
            });
          },
        ),
        SizedBox(height: 16),
        Label(text: "Does patient need the following on arrival at KH:"),
        for (int i = 0; i < arrivalKeys.length; i ++)
          Row(
            children: [
              Expanded(
                child: CustomCheckbox(
                  value: arrival[arrivalKeys[i]] ?? false,
                  onChanged: (bool? value) {
                    setState(() {
                      arrival[arrivalKeys[i]] = value ?? false;
                    });
                  },
                  controllers: controllers,
                  text: arrivalKeys[i],
                ),
              ),
            ],
          ),
      ],
    );
  }
}
