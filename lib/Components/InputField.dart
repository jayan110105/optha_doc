import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final TextInputType keyboardType;
  final bool isEnabled;
  final Icon? prefixIcon; // Optional prefix icon

  const InputField({
    super.key,
    required this.hintText,
    this.controller,
    this.onChanged,
    this.keyboardType = TextInputType.text,
    this.isEnabled = true,
    this.prefixIcon, // Optional prefix icon
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: TextStyle(
        fontWeight: FontWeight.w500,
      ),
      cursorColor: Color(0xFF163351),
      controller: controller,
      onChanged: onChanged,
      keyboardType: keyboardType,
      enabled: isEnabled,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 14, // Matches "text-sm"
          color: Colors.grey[400], // Matches "text-muted-foreground"
        ),
        prefixIcon: prefixIcon, // Adds the optional prefix icon
        prefixIconConstraints: const BoxConstraints(
          minWidth: 36, // Matches design spacing
          minHeight: 36,
        ),
        filled: true,
        fillColor: const Color(0xFFF9F9F9), // Matches background color
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12, // Matches "px-3"
          vertical: 10, // Matches "py-2"
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Color(0xFFE0E0E0), // Matches "border-input"
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Color(0xFF163351), // Matches "focus-visible:ring-ring"
            width: 2, // Focus ring width
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Color(0xFFE0E0E0), // Matches "border-input"
          ),
        ),
      ),
    );
  }
}
