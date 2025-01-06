import 'package:flutter/material.dart';
import 'package:opthadoc/Components/Label.dart';

class AxisScrollWheel extends StatelessWidget {
  final String label;
  final int min;
  final int max;
  final int selectedValue;
  final ValueChanged<int> onChanged;

  const AxisScrollWheel({
    required this.label,
    required this.min,
    required this.max,
    required this.selectedValue,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final int initialItem = (selectedValue - min) ~/ 5;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Label(text: label),
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: 50,
              child: ListWheelScrollView.useDelegate(
                controller: FixedExtentScrollController(initialItem: initialItem),
                magnification: 1.05,
                diameterRatio: 1.2,
                overAndUnderCenterOpacity: 0.4,
                useMagnifier: true,
                itemExtent: 20,
                onSelectedItemChanged:  (index) {
                  int value = min + (index * 5);
                  onChanged(value);
                  },
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
                            fontSize: 16,
                            fontWeight: value == selectedValue
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: value == selectedValue
                                ? const Color(0xFF163351)
                                : const Color(0xFF163351).withValues(alpha: 0.6),
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: ((max - min) ~/ 5) + 1,
                ),
              ),
            ),
            Positioned(
              top: 50 / 2 - 2, // Vertically centered
              left: 0,
              right: 0,
              child: Container(
                height: 2,
                color: Color(0xFF163351).withValues(alpha: 0.6), // Indicator line color
              ),
            ),
          ],
        ),
      ],
    );
  }
}
