import 'package:flutter/material.dart';
import 'package:opthadoc/Components/Label.dart';

class AxisScrollWheel extends StatelessWidget {
  final String keyName;
  final String label;
  final int min;
  final int max;
  final int selectedValue;
  final ValueChanged<int> onChanged;

  const AxisScrollWheel({
    required this.keyName,
    required this.label,
    required this.min,
    required this.max,
    required this.selectedValue,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Label(text: label),
        SizedBox(
          height: 50,
          child: ListWheelScrollView.useDelegate(
            magnification: 1.05,
            diameterRatio: 1.2,
            overAndUnderCenterOpacity: 0.4,
            useMagnifier: true,
            itemExtent: 20,
            onSelectedItemChanged: onChanged,
            childDelegate: ListWheelChildBuilderDelegate(
              builder: (context, index) {
                int value = min + (index * 5);
                if (value > max) return null;
                return Container(
                  width: double.infinity,
                  color: const Color(0xFF163351).withValues(alpha: .1),
                  child: Center(
                    child: Text(
                      '$value °',
                      style: TextStyle(
                        color: const Color(0xFF163351).withValues(alpha: 0.8),
                      ),
                    ),
                  ),
                );
              },
              childCount: ((max - min) ~/ 5) + 1,
            ),
          ),
        ),
      ],
    );
  }
}
