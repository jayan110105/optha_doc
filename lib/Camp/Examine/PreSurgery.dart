import 'package:flutter/material.dart';
import 'package:opthadoc/Components/CustomCheckbox.dart';
import 'package:opthadoc/Components/CustomRadioGroup.dart';
import 'package:opthadoc/Components/Label.dart';

class PreSurgery extends StatelessWidget {
  final Map<String, dynamic> data;
  final Function(String key, dynamic value) updateValue;

  const PreSurgery({
    super.key,
    required this.data,
    required this.updateValue,
  });

  @override
  Widget build(BuildContext context) {

    final List<String> planKeys = [
      "Select for surgery",
      "Ref to Higher center/Base hospital",
      "Review in next camp visit",
      "Medical fitness",
      "Observation",
      "Glass prescription",
    ];

    final List<String> arrivalKeys = ["IOP", "BSCAN", "Systemic evaluation"];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Plan",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Color(0xFF163351),
          ),
        ),
        const SizedBox(height: 16),
        ...planKeys.map((key) {
          return CustomCheckbox(
            value: data[key] ?? false,
            onChanged: (bool? value) {
              updateValue(key, value ?? false);
            },
            text: key,
          );
        }),
        const SizedBox(height: 24),
        const Text(
          "Pre-Surgery Evaluation",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Color(0xFF163351),
          ),
        ),
        const SizedBox(height: 24),
        const Label(text: "Cardio/Medicine clearance for surgery"),
        CustomRadioGroup(
          selectedValue: data["Cardio/Medicine clearance for surgery"],
          onChanged: (value) {
            updateValue("Cardio/Medicine clearance for surgery", value);
          },
        ),
        const SizedBox(height: 16),
        const Label(text: "Does patient need the following on arrival at KH:"),
        for (final key in arrivalKeys)
          Row(
            children: [
              Expanded(
                child: CustomCheckbox(
                  value: data[key] ?? false,
                  onChanged: (bool? value) {
                    updateValue(key, value ?? false);
                  },
                  text: key,
                ),
              ),
            ],
          ),
      ],
    );
  }
}
