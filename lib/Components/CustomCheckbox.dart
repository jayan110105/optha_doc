import 'package:flutter/material.dart';
import 'package:opthadoc/Components/Label.dart';

class CustomCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  final Map<String, TextEditingController> controllers;
  final String text; // New required parameter

  const CustomCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    required this.controllers,
    required this.text, // Add this parameter to the constructor
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          visualDensity: VisualDensity.compact,
          value: value,
          onChanged: (bool? newValue) {
            onChanged(newValue);
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          activeColor: const Color(0xFF163351),
          checkColor: Colors.white,
          side: const BorderSide(
            color: Color(0xFFD3D3D3),
            width: 2,
          ),
        ),
        Flexible(
          child: Label(text: text),
        ),
      ],
    );
  }
}
