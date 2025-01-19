import 'package:flutter/material.dart';
import 'package:opthadoc/Components/CustomDropdown.dart';
import 'package:opthadoc/Components/CustomRadioGroup.dart';
import 'package:opthadoc/Components/InputField.dart';
import 'package:opthadoc/Components/Label.dart';

class Dilated extends StatefulWidget {
  const Dilated({super.key});

  @override
  State<Dilated> createState() => _DilatedState();
}

class _DilatedState extends State<Dilated> {

  final List<Map<String, String>> questions = [
    {"label": "Cataract"},
    {"label": "Glaucoma"},
    {"label": "Diabetic retinopathy"},
    {"label": "ARMD"},
    {"label": "Optic disc pallor/ atropy"},
  ];

  final Map<String, String?> selectedValues = {};

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Dilated Examination",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Color(0xFF163351),
          ),
        ),
        SizedBox(height: 24),
        ...['right', 'left'].map((eye) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                eye == "right" ? "RE :" : "LE :",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF163351),
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Label(text: "Mydriasis"),
                        InputField(hintText: "2 to 8 mm")
                      ],
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Label(text: "Fundus"),
                        CustomDropdown(
                          textStyle: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF163351),
                              fontWeight: FontWeight.bold
                          ),
                          keyName: '',
                          items: ["Grossly normal", "Abnormal"],
                          // selectedValue: controllers['withoutGlasses.$eye.distanceVision']!.text,
                          onChanged: (value) {
                            setState(() {
                              // controllers['withoutGlasses.$eye.distanceVision']!.text = value!;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              ...questions.map((question) {
                final label = question["label"]!;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Label(text: label)),
                    Expanded(
                      child: CustomRadioGroup(
                        selectedValue: selectedValues[label],
                        onChanged: (value) {
                          setState(() {
                            selectedValues[label] = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                );
              }),
              const SizedBox(height: 16),
            ],
          );
        })
      ],
    );
  }
}
