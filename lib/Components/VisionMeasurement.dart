import 'package:flutter/material.dart';
import 'package:opthadoc/Components/Label.dart';
import 'package:opthadoc/Components/InputField.dart';
import 'package:opthadoc/Components/CustomDropdown.dart';
import 'package:opthadoc/Components/AxisScrollWheel.dart';

class VisionMeasurements extends StatefulWidget {
  final String prefix;
  final Map<String, TextEditingController> controllers;

  const VisionMeasurements({
    required this.prefix,
    required this.controllers,
    super.key,
  });

  @override
  State<VisionMeasurements> createState() => _VisionMeasurementsState();
}

class _VisionMeasurementsState extends State<VisionMeasurements> {
  late bool isChecked;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView( // Add scrolling capability
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              'With Glasses',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF163351),
              ),
            ),
          ),
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
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Distance Vision",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF163351).withValues(alpha: 0.6),
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Sphere and Cylinder
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Label(text: "Sphere"),
                            CustomDropdown(
                              keyName: "${widget.prefix}.$eye.sphere",
                              items: List.generate(33, (index) => (index * 0.25).toStringAsFixed(2)),
                              selectedValue: widget.controllers["${widget.prefix}.$eye.sphere"]?.text,
                              onChanged: (value) {
                                setState(() {
                                  widget.controllers["${widget.prefix}.$eye.sphere"]?.text = value!;
                                });
                              }
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Label(text: "Cylinder"),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: CustomDropdown(
                                    hintText: "+/-",
                                    keyName: "${widget.prefix}.$eye.sign",
                                    items: ["+", "-"],
                                    selectedValue: widget.controllers["${widget.prefix}.$eye.sign"]?.text,
                                    onChanged: (value) {
                                      setState(() {
                                        widget.controllers["${widget.prefix}.$eye.sign"]?.text = value!;
                                      });
                                    }
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  flex: 1,
                                  child: CustomDropdown(
                                    hintText: "0.0",
                                    keyName: "${widget.prefix}.$eye.cylinder",
                                    items: List.generate(25, (index) => (index * 0.25).toStringAsFixed(2)),
                                    selectedValue: widget.controllers["${widget.prefix}.$eye.cylinder"]?.text,
                                    onChanged: (value) {
                                      setState(() {
                                        widget.controllers["${widget.prefix}.$eye.cylinder"]?.text = value!;
                                      });
                                    }
                                  ),
                                ),
                              ],
                            ),
                          ],
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
                          selectedValue: int.tryParse(widget.controllers["${widget.prefix}.$eye.axis"]!.text) ?? 0, // Parse the String to int
                          onChanged: (value) {
                            setState(() {
                              widget.controllers["${widget.prefix}.$eye.axis"]?.text = value.toString();
                              print(widget.controllers["${widget.prefix}.$eye.axis"]?.text);
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Label(text: "Visual Acuity"),
                            CustomDropdown(
                              keyName: "${widget.prefix}.$eye.va",
                              items: ["6/6", "6/9", "6/12", "6/18", "6/24", "6/36", "6/60","3/60","1/60"],
                              selectedValue: widget.controllers["${widget.prefix}.$eye.va"]?.text,
                              onChanged: (value) {
                                setState(() {
                                  widget.controllers["${widget.prefix}.$eye.va"]?.text = value!;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Checkbox(
                visualDensity: VisualDensity.compact,
                value: true,
                onChanged: (bool? value) {
                  setState(() {
                    // isChecked = value?;
                    // widget.onCheckboxChanged(value);
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
          InputField(
              hintText: "Enter IPD value",
              controller: widget.controllers['${widget.prefix}.IPD'],
          ),
        ],
      ),
    );
  }
}

