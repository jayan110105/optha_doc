import 'package:flutter/material.dart';
import 'package:opthadoc/Components/Label.dart';
import 'package:opthadoc/Components/InputField.dart';
import 'package:opthadoc/Components/CustomDropdown.dart';
import 'package:opthadoc/Components/AxisScrollWheel.dart';

class VisionMeasurements extends StatefulWidget {
  final String prefix;
  final bool isChecked;
  final Function(bool) onCheckboxChanged;
  final Map<String, dynamic> formData;
  final Function(String, dynamic) updateForm;

  const VisionMeasurements({
    required this.prefix,
    required this.isChecked,
    required this.onCheckboxChanged,
    required this.formData,
    required this.updateForm,
    Key? key,
  }) : super(key: key);

  @override
  _VisionMeasurementsState createState() => _VisionMeasurementsState();
}

class _VisionMeasurementsState extends State<VisionMeasurements> {
  late bool isChecked;

  @override
  void initState() {
    super.initState();
    isChecked = widget.isChecked;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ...["left", "right"].map((eye) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Eye Indicator
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: const Color(0xFF163351),
                      child: Text(
                        eye == "left" ? "L" : "R",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      eye == "left" ? "Left Eye" : "Right Eye",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  "Distance Vision",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF163351).withValues(alpha: 0.6),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 16),
                // Sphere and Cylinder
                Row(
                  children: [
                    Expanded(
                      child: CustomDropdown(
                        keyName: "${widget.prefix}.$eye.sphere",
                        label: "Sphere",
                        items: ["-10", "10"],
                        onChanged: (value) => widget.updateForm("${widget.prefix}.$eye.sphere", value),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomDropdown(
                        keyName: "${widget.prefix}.$eye.cylinder",
                        label: "Cylinder",
                        items: ["-10", "10"],
                        onChanged: (value) => widget.updateForm("${widget.prefix}.$eye.cylinder", value),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Axis and Visual Acuity
                Row(
                  children: [
                    Expanded(
                      child: AxisScrollWheel(
                        keyName: "${widget.prefix}.$eye.axis",
                        label: "Axis",
                        min: 0,
                        max: 180,
                        selectedValue: widget.formData["${widget.prefix}.$eye.axis"] ?? 0,
                        onChanged: (value) {
                          widget.updateForm("${widget.prefix}.$eye.axis", value);
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomDropdown(
                        keyName: "${widget.prefix}.$eye.va",
                        label: "Visual Acuity",
                        items: ["6/6", "6/9", "6/12", "6/18"],
                        onChanged: (value) => widget.updateForm("${widget.prefix}.$eye.va", value),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Checkbox(
              visualDensity: VisualDensity.compact,
              value: isChecked,
              onChanged: (bool? value) {
                setState(() {
                  isChecked = value!;
                  widget.onCheckboxChanged(value);
                });
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              activeColor: const Color(0xFF163351),
              checkColor: Colors.white,
              side: const BorderSide(
                color: Color(0xFF163351),
                width: 2,
              ),
            ),
            const SizedBox(width: 4),
            const Label(text: "Near Vision Required"),
          ],
        ),
        const SizedBox(height: 16),
        const Label(text: "IPD Value"),
        const SizedBox(height: 8),
        const InputField(hintText: "Enter IPD value"),
      ],
    );
  }
}
