import 'package:flutter/material.dart';
import 'package:opthadoc/Components/CustomRadioGroup.dart';
import 'package:opthadoc/Components/CustomTextArea.dart';
import 'package:opthadoc/Components/InputField.dart';
import 'package:opthadoc/Components/Label.dart';

class History extends StatefulWidget {
  final Map<String, dynamic> controller;
  final Function(String key, dynamic value) updateValue;

  const History({super.key, required this.controller, required this.updateValue});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Patient History",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Color(0xFF163351),
          ),
        ),
        const SizedBox(height: 24),
        // Dynamically generate questions with CustomRadioGroup
        ...controller.keys.map((key) {
          // Skip irrelevant questions based on logic
          if (key == "Are PG comfortable ?" && controller["History of glasses"] != "yes") {
            return const SizedBox.shrink();
          }
          if (key == "Details of surgery/procedure" &&
              controller["Previous surgery/laser rx"] != "yes") {
            return const SizedBox.shrink();
          }
          if (key == "Last Glass change" && controller["History of glasses"] != "yes") {
            return const SizedBox.shrink();
          }

          // Display dependent questions only when "Ocular Trauma" is "yes"
          if (["Flashes", "Floaters", "Glaucoma on Rx", "Pain/redness", "Watering/discharge"]
              .contains(key)) {
            if (controller["Ocular Trauma"] != "yes") {
              return const SizedBox.shrink();
            }
          }

          // Special handling for text areas and input fields
          if (key == "Details of surgery/procedure") {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Label(text: key),
                CustomTextArea(
                  hintText: "Enter surgery details",
                  minLines: 3,
                  controller: controller[key],
                ),
                const SizedBox(height: 16),
              ],
            );
          }

          if (key == "Last Glass change") {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Label(text: key),
                InputField(
                  hintText: "Enter date or duration",
                  controller: controller[key],
                ),
                const SizedBox(height: 16),
              ],
            );
          }

          // Default rendering for radio group questions
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Label(text: key),
              CustomRadioGroup(
                selectedValue: controller[key],
                onChanged: (value) {
                  widget.updateValue(key, value); // Call the passed updateValue function
                },
              ),
              const SizedBox(height: 16),
            ],
          );
        }),
      ],
    );
  }
}
