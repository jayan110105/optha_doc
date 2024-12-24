import 'package:flutter/material.dart';

class CardComponent extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color backgroundColor;
  final BorderRadiusGeometry borderRadius;
  final List<BoxShadow>? boxShadow;

  const CardComponent({
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.backgroundColor = Colors.white,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.boxShadow = const [
      BoxShadow(
        color: Colors.black12, // Default shadow color
        blurRadius: 10,
        spreadRadius: 2,
        offset: Offset(0, 4),
      ),
    ],
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
        boxShadow: boxShadow,
      ),
      child: child,
    );
  }
}
