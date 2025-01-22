import 'package:flutter/material.dart';
import 'package:opthadoc/Components/InputField.dart';
import 'package:opthadoc/Components/Label.dart';

class Token extends StatelessWidget {
  final TextEditingController controller;

  const Token({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Label(text: "Patient Token"),
        const SizedBox(height: 8),
        InputField(
          hintText: "Enter patient token",
          controller: controller,
        ),
        const SizedBox(height: 16),
        Text(
          "Enter the patient's token number to proceed with the eye checkup.",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: const Color(0xFF163351).withAlpha(150), // ~60% opacity
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
