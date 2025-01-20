import 'package:flutter/material.dart';
import 'package:opthadoc/Components/CustomDropdown.dart';
import 'package:opthadoc/Components/Label.dart';

class Exam extends StatelessWidget {
  final Map<String, String> data;
  final Function(String key, String value) updateValue;

  const Exam({super.key, required this.data, required this.updateValue});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Examination : torchlight",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Color(0xFF163351),
          ),
        ),
        const SizedBox(height: 24),
        // Dynamically generate fields for "right" and "left" eyes
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
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Label(text: "Visual Axis"),
                        CustomDropdown(
                          textStyle: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF163351),
                              fontWeight: FontWeight.bold),
                          keyName: 'visualAxis-$eye',
                          items: [
                            "Parallel",
                            "Exotropia",
                            "Esotropia",
                            "Alternating squint"
                          ],
                          selectedValue: data['visualAxis-$eye'],
                          onChanged: (value) {
                            updateValue('visualAxis-$eye', value!);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Label(text: "EOM"),
                        CustomDropdown(
                          textStyle: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF163351),
                              fontWeight: FontWeight.bold),
                          keyName: 'eom-$eye',
                          items: ["Normal", "Limited"],
                          selectedValue: data['eom-$eye'],
                          onChanged: (value) {
                            updateValue('eom-$eye', value!);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Label(text: "Conjunctiva/Sclera"),
                        CustomDropdown(
                          textStyle: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF163351),
                              fontWeight: FontWeight.bold),
                          keyName: 'conjunctiva-$eye',
                          items: [
                            "Normal",
                            "Pterygium (grade 1/2/3/4 – Nasal/temporal/both)",
                            "Episcleritis/ Scleritis",
                            "Hordeolum externum",
                            "Hordeolum Internum"
                          ],
                          selectedValue: data['conjunctiva-$eye'],
                          onChanged: (value) {
                            updateValue('conjunctiva-$eye', value!);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Label(text: "Cornea"),
                        CustomDropdown(
                          textStyle: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF163351),
                              fontWeight: FontWeight.bold),
                          keyName: 'cornea-$eye',
                          items: ["Clear", "Opacity", "Hazy"],
                          selectedValue: data['cornea-$eye'],
                          onChanged: (value) {
                            updateValue('cornea-$eye', value!);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Label(text: "AC"),
                        CustomDropdown(
                          textStyle: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF163351),
                              fontWeight: FontWeight.bold),
                          keyName: 'ac-$eye',
                          items: ["Normal", "Shallow depth"],
                          selectedValue: data['ac-$eye'],
                          onChanged: (value) {
                            updateValue('ac-$eye', value!);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Label(text: "Pupil Reactions"),
                        CustomDropdown(
                          textStyle: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF163351),
                              fontWeight: FontWeight.bold),
                          keyName: 'pupilReactions-$eye',
                          items: ["Normal", "RAPD+"],
                          selectedValue: data['pupilReactions-$eye'],
                          onChanged: (value) {
                            updateValue('pupilReactions-$eye', value!);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Label(text: "Lens"),
                        CustomDropdown(
                          textStyle: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF163351),
                              fontWeight: FontWeight.bold),
                          keyName: 'lens-$eye',
                          items: [
                            "Immature cataract",
                            "Near Mature cataract",
                            "Mature Cataract",
                            "Hypermature Cataract",
                            "PCIOL",
                            "Aphakia"
                          ],
                          selectedValue: data['lens-$eye'],
                          onChanged: (value) {
                            updateValue('lens-$eye', value!);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          );
        }),
      ],
    );
  }
}
