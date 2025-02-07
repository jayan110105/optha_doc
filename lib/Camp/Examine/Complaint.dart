import 'package:flutter/material.dart';
import 'package:opthadoc/Components/CustomDropdown.dart';
import 'package:opthadoc/Components/CustomRadioGroup.dart';
import 'package:opthadoc/Components/InputField.dart';
import 'package:opthadoc/Components/Label.dart';
import 'package:opthadoc/Components/CustomTextArea.dart';

class Complaint extends StatelessWidget {
  final Map<String, dynamic> patientData;
  final Map<String, dynamic> historyData;
  final Function(String key, dynamic value) updateValue;

  const Complaint({
    super.key,
    required this.patientData,
    required this.historyData,
    required this.updateValue,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> historyKeysPerEye = [
      "Ocular Trauma",
      "Flashes",
      "Floaters",
      "Glaucoma on Rx",
      "Pain/redness",
      "Watering/discharge",
    ];

    final List<String> historyKeysOnce = [
      "History of glasses",
      "Are PG comfortable ?",
      "Last Glass change",
      "Previous surgery/laser rx",
      "Details of surgery/procedure",
    ];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Complaints",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Color(0xFF163351),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Label(text: "Vision RE (DV)"),
                    CustomDropdown(
                      hintText: "Select DV",
                      keyName: 'vision_re_dv',
                      items: ["6/6", "6/9", "6/12", "6/18", "6/24", "6/36", "6/60","3/60","1/60","HM+","PL+","PL-"],
                      selectedValue: patientData["vision_re_dv"],
                      onChanged: (value) {
                        updateValue("vision_re_dv", value!);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Label(text: "Vision RE (NV)"),
                    CustomDropdown(
                      hintText: "Select NV",
                      keyName: "vision_re_nv",
                      items: ["N5", "N6", "N8", "N10", "N12", "N14", "N18","N24","N36", "N48", "N60"],
                      selectedValue: patientData["vision_re_nv"],
                      onChanged: (value) {
                        updateValue("vision_re_nv", value!);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Label(text: "Vision LE (DV)"),
                    CustomDropdown(
                      hintText: "Select DV",
                      keyName: 'vision_le_dv',
                      items: ["6/6", "6/9", "6/12", "6/18", "6/24", "6/36", "6/60","3/60","1/60","HM+","PL+","PL-"],
                      selectedValue: patientData["vision_le_dv"],
                      onChanged: (value) {
                        updateValue("vision_le_dv", value!);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Label(text: "Vision LE (NV)"),
                    CustomDropdown(
                      hintText: "Select NV",
                      keyName: "vision_le_nv",
                      items: ["N5", "N6", "N8", "N10", "N12", "N14", "N18","N24","N36", "N48", "N60"],
                      selectedValue: patientData["vision_le_nv"],
                      onChanged: (value) {
                        updateValue("vision_le_nv", value!);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...['right', 'left'].map((eye) {
            final eyeLabel = eye == 'right' ? "RE" : "LE";
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(
                  "History for $eyeLabel",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF163351),
                  ),
                ),
                SizedBox(height: 16),
                Label(text: "Diminution of vision"),
                CustomRadioGroup(
                  selectedValue: historyData["Diminution of vision-$eye"],
                  onChanged: (value) {
                    updateValue("Diminution of vision-$eye", value);
                  },
                ),
                const SizedBox(height: 16),
                Label(text: "Complaint Duration",),
                Row(
                  children: [
                    Expanded(
                      child: CustomDropdown(
                        hintText: "Year",
                        textStyle: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF163351),
                          fontWeight: FontWeight.bold,
                        ),
                        keyName: 'years-$eye',
                        items: List.generate(100, (index) => "${index + 1}").toList(),
                        selectedValue: patientData['years-$eye'],
                        onChanged: (value) {
                          updateValue('years-$eye', value!);
                        },
                        hintFontSize: 13,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomDropdown(
                        hintText: "Month",
                        textStyle: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF163351),
                          fontWeight: FontWeight.bold,
                        ),
                        keyName: 'months-$eye',
                        items: List.generate(12, (index) => "${index + 1}").toList(),
                        selectedValue: patientData['months-$eye'],
                        onChanged: (value) {
                          updateValue('months-$eye', value!);
                        },
                        hintFontSize: 13,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomDropdown(
                        hintText: "Day",
                        textStyle: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF163351),
                          fontWeight: FontWeight.bold,
                        ),
                        keyName: 'days-$eye',
                        items: List.generate(31, (index) => "${index + 1}").toList(),
                        selectedValue: patientData['days-$eye'],
                        onChanged: (value) {
                          updateValue('days-$eye', value!);
                        },
                        hintFontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ...historyKeysPerEye.map((key) {
                  final keyWithEye = "$key-$eye";

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Label(text: key),
                      CustomRadioGroup(
                        selectedValue: historyData[keyWithEye],
                        onChanged: (value) {
                          updateValue(keyWithEye, value);
                        },
                      ),
                      // Show "Nature of Trauma" field only if "Ocular Trauma" is "yes"
                      if (key == "Ocular Trauma" && historyData[keyWithEye] == "yes") ...[
                        const SizedBox(height: 8),
                        Label(text: "Nature of Trauma"),
                        InputField(
                          hintText: "Enter nature of trauma",
                          controller: historyData["Nature of Trauma-$eye"],
                        ),
                      ],
                      const SizedBox(height: 16),
                    ],
                  );
                }),

              ],
            );
          }),
          const SizedBox(height: 16),
          const Text(
            "Additional History",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF163351),
            ),
          ),
          const SizedBox(height: 16),
          ...historyKeysOnce.where((key) {
            // Show these fields **only if "History of glasses" is "yes"**
            if (["Are PG comfortable ?", "Last Glass change"].contains(key) &&
                historyData["History of glasses"] != "yes") {
              return false;
            }

            // Show "Details of surgery/procedure" only if "Previous surgery/laser rx" is "yes"
            if (key == "Details of surgery/procedure" &&
                historyData["Previous surgery/laser rx"] != "yes") {
              return false;
            }

            return true; // Show other keys normally
          }).map((key) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Label(text: key),
                key == "Details of surgery/procedure"
                    ? CustomTextArea(
                  hintText: "Enter surgery details",
                  minLines: 3,
                  controller: historyData[key], // Use single key (no left/right)
                )
                    : key == "Last Glass change"
                    ? InputField(
                  hintText: "Enter date or duration",
                  controller: historyData[key],
                )
                    : CustomRadioGroup(
                  selectedValue: historyData[key],
                  onChanged: (value) {
                    updateValue(key, value);
                  },
                ),
                const SizedBox(height: 16),
              ],
            );
          }),
        ],
      ),
    );
  }
}