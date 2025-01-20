import 'package:flutter/material.dart';
import 'package:opthadoc/Components/CustomDropdown.dart';
import 'package:opthadoc/Components/CustomRadioGroup.dart';
import 'package:opthadoc/Components/InputField.dart';
import 'package:opthadoc/Components/Label.dart';

class Dilated extends StatelessWidget {
  final Map<String, dynamic> data;
  final Function(String key, dynamic value) updateValue;

  const Dilated({
    super.key,
    required this.data,
    required this.updateValue,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> questions = [
      {"label": "Cataract"},
      {"label": "Glaucoma"},
      {"label": "Diabetic retinopathy"},
      {"label": "ARMD"},
      {"label": "Optic disc pallor/ atrophy"},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Dilated Examination",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Color(0xFF163351),
          ),
        ),
        const SizedBox(height: 24),
        ...['right', 'left'].map((eye) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                eye == "right" ? "RE :" : "LE :",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF163351),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Label(text: "Mydriasis"),
                        InputField(
                          hintText: "2 to 8 mm",
                          controller: data['mydriasis-$eye'],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Label(text: "Fundus"),
                        CustomDropdown(
                          textStyle: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF163351),
                            fontWeight: FontWeight.bold,
                          ),
                          keyName: 'fundus-$eye',
                          items: ["Grossly normal", "Abnormal"],
                          selectedValue: data['fundus-$eye'],
                          onChanged: (value) {
                            updateValue('fundus-$eye', value);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ...questions.map((question) {
                final label = question["label"]!;
                final key = '$label-$eye';
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Label(text: label)),
                    Expanded(
                      child: CustomRadioGroup(
                        selectedValue: data[key],
                        onChanged: (value) {
                          updateValue(key, value);
                        },
                      ),
                    ),
                  ],
                );
              }).toList(),
              const SizedBox(height: 16),
            ],
          );
        }),
      ],
    );
  }
}
