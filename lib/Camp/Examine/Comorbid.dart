import 'package:flutter/material.dart';
import 'package:opthadoc/Components/CustomCheckbox.dart';

class Comorbid extends StatelessWidget {
  final Map<String, bool> comorbidities;
  final Function(String key, bool value) updateValue;

  const Comorbid({
    super.key,
    required this.comorbidities,
    required this.updateValue,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> comorbidityKeys = comorbidities.keys.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Comorbidities and Medications",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Color(0xFF163351),
          ),
        ),
        const SizedBox(height: 24),
        Column(
          children: [
            for (int i = 0; i < comorbidityKeys.length; i += 2)
              Row(
                children: [
                  Expanded(
                    child: CustomCheckbox(
                      value: comorbidities[comorbidityKeys[i]] ?? false,
                      onChanged: (bool? value) {
                        updateValue(comorbidityKeys[i], value ?? false);
                      },
                      text: comorbidityKeys[i],
                    ),
                  ),
                  const SizedBox(width: 16),
                  if (i + 1 < comorbidityKeys.length) // Check if next item exists
                    Expanded(
                      child: CustomCheckbox(
                        value: comorbidities[comorbidityKeys[i + 1]] ?? false,
                        onChanged: (bool? value) {
                          updateValue(comorbidityKeys[i + 1], value ?? false);
                        },
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
