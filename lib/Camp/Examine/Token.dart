import 'package:flutter/material.dart';
import 'package:opthadoc/Components/InputField.dart';
import 'package:opthadoc/Components/Label.dart';
import 'package:intl/intl.dart';

class Token extends StatelessWidget {
  final String campCode;
  final TextEditingController controller;

  const Token({
    super.key,
    required this.controller,
    required this.campCode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Label(text: "Patient Token"),
        const SizedBox(height: 8),
        Row(
          children: [
            Text(
              "$campCode-${DateFormat('yyyyMMdd').format(DateTime.now())}-",
              style: TextStyle(
                color: Color(0xFF163351),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: InputField(
                hintText: "Enter patient token",
                controller: controller,
              ),
            ),
          ],
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
