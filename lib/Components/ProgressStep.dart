import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProgressSteps extends StatefulWidget {
  final List<Map<String, dynamic>> steps;
  final int currentStep;
  final ValueChanged<int> onStepTapped;
  final bool allowStepTap;

  const ProgressSteps({
    super.key,
    required this.steps,
    required this.currentStep,
    required this.onStepTapped,
    this.allowStepTap = true,
  });

  @override
  State<ProgressSteps> createState() => _ProgressStepsState();
}

class _ProgressStepsState extends State<ProgressSteps> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Emulate spaceBetween behavior
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widget.steps.map((step) {
              int index = widget.steps.indexOf(step);
              return Padding(
                padding: const EdgeInsets.only(right: 10.0), // Add spacing between items
                child: GestureDetector(
                  onTap: widget.allowStepTap
                      ? () => widget.onStepTapped(index) // Allow tapping if enabled
                      : null,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        backgroundColor: widget.currentStep >= index
                            ? const Color(0xFF163351)
                            : const Color(0xFF163351).withValues(alpha: .1),
                        child: widget.currentStep > index
                            ? const Icon(
                          Icons.check_circle,
                          color: Colors.white,
                        )
                            : (step["icon"] is String
                            ? SvgPicture.asset(
                          step["icon"],
                          colorFilter: ColorFilter.mode(
                            widget.currentStep >= index
                                ? Colors.white
                                : const Color(0xFF163351)
                                .withValues(alpha: .4),
                            BlendMode.srcIn,
                          ),
                          height: 26.0,
                          width: 26.0,
                        )
                            : Icon(
                          step["icon"],
                          color: widget.currentStep >= index
                              ? Colors.white
                              : const Color(0xFF163351)
                              .withValues(alpha: .4),
                        )),
                      ),
                      const SizedBox(height: 8), // Simulates `runSpacing`
                      SizedBox(
                        width: 60, // Adjust width for consistent text alignment
                        child: Text(
                          step["title"],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: widget.currentStep >= index
                                ? const Color(0xFF163351)
                                : Colors.grey[600],
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

// Usage Example
// ProgressSteps(
//   steps: [
//     {"title": "Step 1", "icon": Icons.ac_unit},
//     {"title": "Step 2", "icon": "assets/icons/custom_icon.svg"},
//     {"title": "Step 3", "icon": Icons.accessibility},
//   ],
//   currentStep: 1,
//   onStepTapped: (index) {
//     setState(() {
//       currentStep = index;
//     });
//   },
// )