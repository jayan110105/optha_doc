import 'package:flutter/material.dart';

class CustomTextArea extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final bool isEnabled;
  final int minLines;
  final int? maxLines;

  const CustomTextArea({
    super.key,
    required this.hintText,
    this.controller,
    this.onChanged,
    this.isEnabled = true,
    this.minLines = 5, // Default height similar to `min-h-[80px]`
    this.maxLines, // Null by default for unlimited lines
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      enabled: isEnabled,
      minLines: minLines,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 14, // Matches "text-sm"
          color: Colors.grey[400], // Matches "placeholder:text-muted-foreground"
        ),
        filled: true,
        fillColor: const Color(0xFFF9F9F9), // Matches "bg-background"
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12, // Matches "px-3"
          vertical: 10, // Matches "py-2"
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8), // Matches "rounded-md"
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
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Colors.grey, // Matches "disabled:opacity-50"
          ),
        ),
      ),
    );
  }
}
