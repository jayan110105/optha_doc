import 'package:flutter/material.dart';
import 'package:opthadoc/Components/CustomDropdown.dart';
import 'package:opthadoc/Components/InputField.dart';
import 'package:opthadoc/Components/Label.dart';

class Workup extends StatefulWidget {
  const Workup({super.key});

  @override
  State<Workup> createState() => _WorkupState();
}

class _WorkupState extends State<Workup> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Workup",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Color(0xFF163351),
          ),
        ),
        SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Label(text: "RE Ducts"),
                  CustomDropdown(
                    textStyle: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF163351),
                        fontWeight: FontWeight.bold
                    ),
                    keyName: '',
                    items: ["Free", "Blocked", "Partially patent"],
                    // selectedValue: controllers['withoutGlasses.$eye.distanceVision']!.text,
                    onChanged: (value) {
                      setState(() {
                        // controllers['withoutGlasses.$eye.distanceVision']!.text = value!;
                      });
                    },
                  ),
                ],
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Label(text: "LE Ducts"),
                  CustomDropdown(
                    textStyle: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF163351),
                        fontWeight: FontWeight.bold
                    ),
                    keyName: '',
                    items: ["Free", "Blocked", "Partially patent"],
                    // selectedValue: controllers['withoutGlasses.$eye.distanceVision']!.text,
                    onChanged: (value) {
                      setState(() {
                        // controllers['withoutGlasses.$eye.distanceVision']!.text = value!;
                      });
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
                  Label(text: "BP"),
                  InputField(hintText: "")
                ],
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Label(text: "GRBS"),
                  InputField(hintText: "")
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
