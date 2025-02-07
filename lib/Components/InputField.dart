import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final bool isEnabled;
  final bool isNumber; // New option for number keypad
  final Icon? prefixIcon;

  const InputField({
    super.key,
    required this.hintText,
    this.controller,
    this.onChanged,
    this.isEnabled = true,
    this.isNumber = false, // Defaults to text input
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: const TextStyle(
        fontWeight: FontWeight.w500,
      ),
      cursorColor: const Color(0xFF163351),
      controller: controller,
      onChanged: onChanged,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text, // Switch based on isNumber
      enabled: isEnabled,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 14,
          color: Colors.grey[400],
        ),
        prefixIcon: prefixIcon,
        prefixIconConstraints: const BoxConstraints(
          minWidth: 36,
          minHeight: 36,
        ),
        filled: true,
        fillColor: const Color(0xFFF9F9F9),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Color(0xFFE0E0E0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Color(0xFF163351),
            width: 2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Color(0xFFE0E0E0),
          ),
        ),
      ),
    );
  }
}
