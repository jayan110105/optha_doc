import 'package:flutter/material.dart';
import 'package:opthadoc/Components/InputField.dart';
import 'package:opthadoc/Components/Label.dart';

class Patient extends StatelessWidget {
  final Map<String, TextEditingController> controllers;

  const Patient({super.key, required this.controllers});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Patient Information",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Color(0xFF163351),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Label(text: "Vision RE"),
                  InputField(
                    controller: controllers["vision_re"],
                    hintText: "With PH, BGC, NV",
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Label(text: "Vision LE"),
                  InputField(
                    controller: controllers["vision_le"],
                    hintText: "With PH, BGC, NV",
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Label(text: "Complaint RE"),
        InputField(
          controller: controllers["complaint_re"],
          hintText: "Diminution of vision",
        ),
        const SizedBox(height: 16),
        const Label(text: "Complaint LE"),
        InputField(
          controller: controllers["complaint_le"],
          hintText: "Diminution of vision",
        ),
        const SizedBox(height: 16),
        const Label(text: "Complaint Duration"),
        InputField(
          controller: controllers["complaint_duration"],
          hintText: "Duration of complaint",
        ),
      ],
    );
  }
}
