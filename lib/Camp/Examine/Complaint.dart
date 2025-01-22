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
    final List<String> historyKeys = [
      "Ocular Trauma",
      "Flashes",
      "Floaters",
      "Glaucoma on Rx",
      "Pain/redness",
      "Watering/discharge",
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
                Label(text: "Complaint Duration",),
                Row(
                  children: [
                    Expanded(
                      child: CustomDropdown(
                        hintText: "Years",
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
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomDropdown(
                        hintText: "Months",
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
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomDropdown(
                        hintText: "Days",
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
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ...historyKeys.map((key) {
                  final keyWithEye = "$key-$eye";

                  if (key == "Are PG comfortable ?" &&
                      historyData["History of glasses-$eye"] != "yes") {
                    return const SizedBox.shrink();
                  }
                  if (key == "Details of surgery/procedure" &&
                      historyData["Previous surgery/laser rx-$eye"] != "yes") {
                    return const SizedBox.shrink();
                  }
                  if (key == "Last Glass change" &&
                      historyData["History of glasses-$eye"] != "yes") {
                    return const SizedBox.shrink();
                  }

                  if (["Flashes", "Floaters", "Glaucoma on Rx", "Pain/redness", "Watering/discharge"]
                      .contains(key)) {
                    if (historyData["Ocular Trauma-$eye"] != "yes") {
                      return const SizedBox.shrink();
                    }
                  }

                  if (key == "Details of surgery/procedure" ||
                      key == "Last Glass change") {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Label(text: key),
                        key == "Details of surgery/procedure"
                            ? CustomTextArea(
                          hintText: "Enter surgery details",
                          minLines: 3,
                          controller: historyData[keyWithEye],
                        )
                            : InputField(
                          hintText: "Enter date or duration",
                          controller: historyData[keyWithEye],
                        ),
                        const SizedBox(height: 16),
                      ],
                    );
                  }

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
                      const SizedBox(height: 16),
                    ],
                  );
                }),
              ],
            );
          }),
        ],
      ),
    );
  }
}