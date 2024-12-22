import 'package:flutter/material.dart';
import 'package:opthadoc/Components/Label.dart';

class CustomDropdown extends StatelessWidget {
  final String keyName;
  final String label;
  final List<String> items;
  final String? selectedValue;
  final ValueChanged<String?> onChanged;

  const CustomDropdown({
    required this.keyName,
    required this.label,
    required this.items,
    this.selectedValue,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Label(text: label),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8), // Matches "rounded-md"
            border: Border.all(
              color: const Color(0xFFE0E0E0), // Matches "border-input"
            ),
          ),
          child: DropdownButton<String>(
            value: selectedValue,
            isExpanded: true,
            icon: const Icon(Icons.keyboard_arrow_down, size: 24, color: Colors.grey),
            hint: const Text(
              "Select",
              style: TextStyle(color: Colors.grey, fontSize: 14), // Matches placeholder text style
            ),
            style: const TextStyle(color: Colors.black, fontSize: 14),
            underline: Container(),
            items: items
                .map((item) => DropdownMenuItem(
              value: item,
              child: Text(item),
            ))
                .toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
