import 'package:flutter/material.dart';
import 'package:opthadoc/Components/CustomCheckbox.dart';

class Diagnosis extends StatelessWidget {
  final Map<String, dynamic> data;
  final Function(String key, dynamic value) updateValue;

  const Diagnosis({
    super.key,
    required this.data,
    required this.updateValue,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> diagnosisKeys = [
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
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Diagnosis",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Color(0xFF163351),
          ),
        ),
        const SizedBox(height: 24),
        ...['right', 'left', 'both'].map((eye) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                eye == "right" ? "RE :" : eye == "left" ? "LE :" : "BE :",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF163351),
                ),
              ),
              const SizedBox(height: 16),
              for (int i = 0; i < diagnosisKeys.length; i += 2)
                Row(
                  children: [
                    Expanded(
                      child: CustomCheckbox(
                        value: data['${diagnosisKeys[i]}-$eye'] ?? false,
                        onChanged: (bool? value) {
                          updateValue('${diagnosisKeys[i]}-$eye', value ?? false);
                        },
                        text: diagnosisKeys[i],
                      ),
                    ),
                    const SizedBox(width: 16),
                    if (i + 1 < diagnosisKeys.length)
                      Expanded(
                        child: CustomCheckbox(
                          value: data['${diagnosisKeys[i + 1]}-$eye'] ?? false,
                          onChanged: (bool? value) {
                            updateValue(
                                '${diagnosisKeys[i + 1]}-$eye', value ?? false);
                          },
                          text: diagnosisKeys[i + 1],
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
