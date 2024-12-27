import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final String keyName;
  final List<String> items;
  final String? selectedValue;
  final ValueChanged<String?> onChanged;
  final TextStyle? textStyle;
  final String? hintText;

  const CustomDropdown({
    required this.keyName,
    required this.items,
    this.selectedValue,
    required this.onChanged,
    this.textStyle,
    this.hintText,
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
        icon: const Icon(Icons.keyboard_arrow_down, size: 24, color: Colors.grey),
        hint: Text(
          hintText ?? "Select",
          style: const TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.normal), // Placeholder text style
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
