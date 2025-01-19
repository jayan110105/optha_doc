import 'package:flutter/material.dart';
import 'package:opthadoc/Components/InputField.dart';
import 'package:opthadoc/Components/Label.dart';

class Patient extends StatelessWidget {
  const Patient({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Patient Information",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Color(0xFF163351),
          ),
        ),
        SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Label(text: "Vision RE"),
                  InputField(hintText: "With PH, BGC, NV")
                ],
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Label(text: "Vision LE"),
                  InputField(hintText: "With PH, BGC, NV")
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Label(text: "Complaint RE"),
        InputField(hintText: "Diminution of vision"),
        SizedBox(height: 16),
        Label(text: "Complaint LE"),
        InputField(hintText: "Diminution of vision"),
        SizedBox(height: 16),
        Label(text: "Complaint Duration"),
        InputField(hintText: "Duration of complaint"),
      ],
    );
  }
}
