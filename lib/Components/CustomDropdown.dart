import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final String keyName;
  final List<String> items;
  final String? selectedValue;
  final ValueChanged<String?> onChanged;
  final TextStyle? textStyle;
  final String? hintText;
  final double? hintFontSize; // New parameter for hint font size

  const CustomDropdown({
    required this.keyName,
    required this.items,
    this.selectedValue,
    required this.onChanged,
    this.textStyle,
    this.hintText,
    this.hintFontSize, // Accept font size for hint
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8), // Matches "rounded-md"
        border: Border.all(
          color: const Color(0xFFE0E0E0), // Matches "border-input"
        ),
      ),
      child: DropdownButton<String>(
        borderRadius: BorderRadius.circular(8),
        value: items.contains(selectedValue) ? selectedValue : null,
        isExpanded: true,
        icon: Icon(
          Icons.keyboard_arrow_down,
          size: selectedValue == null ? 18 : 10,
          color: Colors.grey,
        ),
        hint: Text(
          hintText ?? "Select",
          style: TextStyle(
            color: Colors.grey,
            fontSize: hintFontSize ?? 14, // Apply hintFontSize
            fontWeight: FontWeight.normal,
          ),
        ),
        style: textStyle ??
            const TextStyle(
              color: Color(0xFF163351),
              fontSize: 14,
            ), // Use the passed textStyle or the default one
        underline: Container(),
        dropdownColor: Colors.white,
        items: items
            .map((item) => DropdownMenuItem(
          value: item,
          child: Text(item),
        ))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}
