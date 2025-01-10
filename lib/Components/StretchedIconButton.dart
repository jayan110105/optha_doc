import 'package:flutter/material.dart';

class StretchedIconButton extends StatelessWidget {
  final Color backgroundColor;
  final Color textColor;
  final IconData? icon;
  final String label;
  final VoidCallback onPressed;
  final double borderRadius;

  const StretchedIconButton({
    super.key,
    required this.backgroundColor,
    required this.textColor,
    this.icon,
    required this.label,
    required this.onPressed,
    this.borderRadius = 8.0, // Default border radius
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // Makes the button stretch across the container
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) Icon(icon, color: textColor), // Add icon conditionally
              if (icon != null) const SizedBox(width: 8),
              Text(label),
            ],
          ),
        ),
      ),
    );
  }
}
