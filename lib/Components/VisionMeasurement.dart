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
  late bool isNearVisionRequired = false;
  late Map<String, bool> isDistanceVisionPRequired = {
    "left": false,
    "right": false,
  };
  late Map<String, bool> isNearVisionPRequired = {
    "left": false,
    "right": false,
  };

  @override
  void initState() {
    super.initState();
    isNearVisionRequired =  widget.controllers['${widget.prefix}.nearVisionRequired']?.text == 'Yes';

    isDistanceVisionPRequired['left'] =  widget.controllers['${widget.prefix}.left.distanceVisionP']?.text == 'Yes';
    isDistanceVisionPRequired['right'] =  widget.controllers['${widget.prefix}.right.distanceVisionP']?.text == 'Yes';

    isNearVisionPRequired['left'] =  widget.controllers['${widget.prefix}.left.nearVisionP']?.text == 'Yes';
    isNearVisionPRequired['right'] =  widget.controllers['${widget.prefix}.right.nearVisionP']?.text == 'Yes';
  }


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
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: CustomDropdown(
                                      hintText: "+/-",
                                      keyName: "${widget.prefix}.$eye.distanceVisionSphereSign",
                                      items: ["+", "-"],
                                      selectedValue: widget.controllers["${widget.prefix}.$eye.distanceVisionSphereSign"]?.text,
                                      onChanged: (value) {
                                        setState(() {
                                          widget.controllers["${widget.prefix}.$eye.distanceVisionSphereSign"]?.text = value!;
                                        });
                                      }
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: CustomDropdown(
                                    hintText: "0.0",
                                    keyName: "${widget.prefix}.$eye.distanceVisionSphere",
                                    items: List.generate(33, (index) => (index * 0.25).toStringAsFixed(2)),
                                    selectedValue: widget.controllers["${widget.prefix}.$eye.distanceVisionSphere"]?.text,
                                    onChanged: (value) {
                                      setState(() {
                                        widget.controllers["${widget.prefix}.$eye.distanceVisionSphere"]?.text = value!;
                                      });
                                    }
                                  ),
                                ),
                              ],
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
                                    keyName: "${widget.prefix}.$eye.cylinderSign",
                                    items: ["+", "-"],
                                    selectedValue: widget.controllers["${widget.prefix}.$eye.cylinderSign"]?.text,
                                    onChanged: (value) {
                                      setState(() {
                                        widget.controllers["${widget.prefix}.$eye.cylinderSign"]?.text = value!;
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
                          label: "Axis",
                          min: 0,
                          max: 180,
                          selectedValue: int.tryParse(widget.controllers["${widget.prefix}.$eye.axis"]!.text) ?? 0, // Parse the String to int
                          onChanged: (value) {
                            setState(() {
                              widget.controllers["${widget.prefix}.$eye.axis"]?.text = value.toString();
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
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: CustomDropdown(
                                    hintText: "6/6",
                                    keyName: "${widget.prefix}.$eye.distanceVisionVA",
                                    items: ["6/6", "6/9", "6/12", "6/18", "6/24", "6/36", "6/60","3/60","1/60","HM+","PL+","PL-"],
                                    selectedValue: widget.controllers["${widget.prefix}.$eye.distanceVisionVA"]?.text,
                                    onChanged: (value) {
                                      setState(() {
                                        widget.controllers["${widget.prefix}.$eye.distanceVisionVA"]?.text = value!;
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  flex: 1,
                                  child: Row(
                                    children: [
                                      Checkbox(
                                        visualDensity: VisualDensity.compact,
                                        value: isDistanceVisionPRequired[eye] ?? false,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            isDistanceVisionPRequired[eye] = value ?? false; // Update the state
                                            widget.controllers['${widget.prefix}.$eye.distanceVisionP']?.text = isDistanceVisionPRequired[eye]??false ? 'Yes' : 'No'; // Update the controller if needed
                                          });
                                        },
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        activeColor: const Color(0xFF163351),
                                        checkColor: Colors.white,
                                        side: BorderSide(
                                          color: Color(0xFFD3D3D3),
                                          width: 2,
                                        ),
                                      ),
                                      Label(text: "p")
                                    ],
                                  )
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16,),
                  isNearVisionRequired ?
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Near Vision",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF163351).withValues(alpha: 0.6),
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Label(text: "Sphere"),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: CustomDropdown(
                                          hintText: "+/-",
                                          keyName: "${widget.prefix}.$eye.nearVisionSphereSign",
                                          items: ["+", "-"],
                                          selectedValue: widget.controllers["${widget.prefix}.$eye.nearVisionSphereSign"]?.text,
                                          onChanged: (value) {
                                            setState(() {
                                              widget.controllers["${widget.prefix}.$eye.nearVisionSphereSign"]?.text = value!;
                                            });
                                          }
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: CustomDropdown(
                                          hintText: "0.0",
                                          keyName: "${widget.prefix}.$eye.nearVisionSphere",
                                          items: List.generate(33, (index) => (index * 0.25).toStringAsFixed(2)),
                                          selectedValue: widget.controllers["${widget.prefix}.$eye.nearVisionSphere"]?.text,
                                          onChanged: (value) {
                                            setState(() {
                                              widget.controllers["${widget.prefix}.$eye.nearVisionSphere"]?.text = value!;
                                            });
                                          }
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Label(text: "Visual Acuity"),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: CustomDropdown(
                                        hintText: "N5",
                                        keyName: "${widget.prefix}.$eye.nearVisionVA",
                                        items: ["N5", "N6", "N8", "N10", "N12", "N14", "N18","N24","N36", "N48", "N60"],
                                        selectedValue: widget.controllers["${widget.prefix}.$eye.nearVisionVA"]?.text,
                                        onChanged: (value) {
                                          setState(() {
                                            widget.controllers["${widget.prefix}.$eye.nearVisionVA"]?.text = value!;
                                          });
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                        flex: 1,
                                        child: Row(
                                          children: [
                                            Checkbox(
                                              visualDensity: VisualDensity.compact,
                                              value: isNearVisionPRequired[eye] ?? false,
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  isNearVisionPRequired[eye] = value ?? false; // Update the state
                                                  widget.controllers['${widget.prefix}.$eye.nearVisionP']?.text = isNearVisionPRequired[eye]??false ? 'Yes' : 'No'; // Update the controller if needed
                                                });
                                              },
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                              activeColor: const Color(0xFF163351),
                                              checkColor: Colors.white,
                                              side: const BorderSide(
                                                color: Color(0xFFD3D3D3),
                                                width: 2,
                                              ),
                                            ),
                                            Label(text: "p")
                                          ],
                                        )
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ) : const SizedBox(),
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
                value: isNearVisionRequired, // Current state of the checkbox
                onChanged: (bool? value) {
                  setState(() {
                    isNearVisionRequired = value ?? false; // Update the state
                    widget.controllers['${widget.prefix}.nearVisionRequired']?.text = isNearVisionRequired ? 'Yes' : 'No'; // Update the controller if needed
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

