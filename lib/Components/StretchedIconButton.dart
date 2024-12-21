import 'package:flutter/material.dart';

class StretchedIconButton extends StatelessWidget {
  final Color backgroundColor;
  final Color textColor;
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final double borderRadius;

  const StretchedIconButton({
    Key? key,
    required this.backgroundColor,
    required this.textColor,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.borderRadius = 8.0, // Default border radius
  }) : super(key: key);

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
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: textColor),
            const SizedBox(width: 8),
            Text(label),
          ],
        ),
      ),
    );
  }
}
