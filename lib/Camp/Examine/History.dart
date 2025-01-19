import 'package:flutter/material.dart';
import 'package:opthadoc/Components/CustomRadioGroup.dart';
import 'package:opthadoc/Components/CustomTextArea.dart';
import 'package:opthadoc/Components/InputField.dart';
import 'package:opthadoc/Components/Label.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {

  final Map<String, String?> selectedValues = {};

  final List<Map<String, String>> questions = [
    {"label": "Ocular Trauma"},
    {"label": "Flashes"},
    {"label": "Floaters"},
    {"label": "Glaucoma on Rx"},
    {"label": "Pain/redness"},
    {"label": "Watering/discharge"},
    {"label": "History of glasses"},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Patient History",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Color(0xFF163351),
          ),
        ),
        SizedBox(height: 24),
        // Dynamically generate questions with CustomRadioGroup
        ...questions.map((question) {
          final label = question["label"]!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Label(text: label),
              CustomRadioGroup(
                selectedValue: selectedValues[label],
                onChanged: (value) {
                  setState(() {
                    selectedValues[label] = value;
                  });
                },
              ),
              const SizedBox(height: 16),
            ],
          );
        }),
        selectedValues['History of glasses'] == 'yes'
            ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Label(text: "Are PG comfortable ?"),
            CustomRadioGroup(
              selectedValue: selectedValues["Are PG comfortable ?"],
              onChanged: (value) {
                setState(() {
                  selectedValues["Are PG comfortable ?"] = value;
                });
              },
            ),
            const SizedBox(height: 16),
            Label(text: "Last Glass change"),
            InputField(hintText: "Enter date or duration"),
          ],
        )
            : SizedBox.shrink(),
        const SizedBox(height: 16),
        Label(text: "Previous surgery/laser rx"),
        CustomRadioGroup(
          selectedValue: selectedValues["Previous surgery/laser rx"],
          onChanged: (value) {
            setState(() {
              selectedValues["Previous surgery/laser rx"] = value;
            });
          },
        ),
        const SizedBox(height: 16),
        selectedValues['Previous surgery/laser rx'] == 'yes'
            ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Label(text: "Details of surgery/procedure"),
            CustomTextArea(hintText: "Enter surgery details", minLines: 3,),
          ],
        )
            : SizedBox.shrink(),
      ],
    );
  }
}
