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
          if (key == "Are PG comfortable ?" && controller["History of glasses"] != "yes") {
            return const SizedBox.shrink(); // Skip rendering this question unless relevant
          }
          if (key == "Details of surgery/procedure" &&
              controller["Previous surgery/laser rx"] != "yes") {
            return const SizedBox.shrink(); // Skip unless surgery is marked "yes"
          }

          if (key == "Last Glass change" && controller["History of glasses"] != "yes") {
            return const SizedBox.shrink();
          }

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
        }).toList(),
      ],
    );
  }
}
