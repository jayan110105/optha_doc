import 'package:flutter/material.dart';
import 'package:opthadoc/Components/CustomDropdown.dart';
import 'package:opthadoc/Components/InputField.dart';
import 'package:opthadoc/Components/Label.dart';

class Workup extends StatelessWidget {
  final Map<String, dynamic> data;
  final Function(String key, dynamic value) updateValue;

  const Workup({
    super.key,
    required this.data,
    required this.updateValue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Workup",
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
                  const Label(text: "RE Ducts"),
                  CustomDropdown(
                    textStyle: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF163351),
                      fontWeight: FontWeight.bold,
                    ),
                    keyName: 're-ducts',
                    items: ["Free", "Blocked", "Partially patent"],
                    selectedValue: data['re-ducts'],
                    onChanged: (value) {
                      updateValue('re-ducts', value);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Label(text: "LE Ducts"),
                  CustomDropdown(
                    textStyle: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF163351),
                      fontWeight: FontWeight.bold,
                    ),
                    keyName: 'le-ducts',
                    items: ["Free", "Blocked", "Partially patent"],
                    selectedValue: data['le-ducts'],
                    onChanged: (value) {
                      updateValue('le-ducts', value);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Label(text: "BP"),
                  InputField(
                    hintText: "Enter BP value",
                    controller: data['bp'],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Label(text: "GRBS"),
                  InputField(
                    hintText: "Enter GRBS value",
                    controller: data['grbs'],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
