import 'package:flutter/material.dart';

class CustomRadioGroup extends StatelessWidget {
  final String? selectedValue;
  final ValueChanged<String?> onChanged;

  const CustomRadioGroup({
    super.key,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Yes Option
        GestureDetector(
          onTap: () {
            onChanged("yes");
          },
          child: Row(
            children: [
              Radio<String>(
                value: "yes",
                groupValue: selectedValue,
                onChanged: onChanged,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                activeColor: const Color(0xFF163351),
                visualDensity: VisualDensity.compact, // Reduce intrinsic space
              ),
              const Text(
                "Yes",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        // No Option
        GestureDetector(
          onTap: () {
            onChanged("no");
          },
          child: Row(
            children: [
              Radio<String>(
                value: "no",
                groupValue: selectedValue,
                onChanged: onChanged,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                activeColor: const Color(0xFF163351),
                visualDensity: VisualDensity.compact, // Reduce intrinsic space
              ),
              const Text(
                "No",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}