import 'package:flutter/material.dart';
import 'package:opthadoc/Components/CustomDropdown.dart';
import 'package:opthadoc/Components/Label.dart';

class Exam extends StatefulWidget {
  const Exam({super.key});

  @override
  State<Exam> createState() => _ExamState();
}

class _ExamState extends State<Exam> {

  final Map<String, TextEditingController> controllers = {};

  @override
  void dispose() {
    // Dispose controllers to avoid memory leaks
    for (var controller in controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Examination : torchlight",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Color(0xFF163351),
          ),
        ),
        SizedBox(height: 24),
        ...['right', 'left'].map((eye) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                eye == "right" ? "RE :" : "LE :",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF163351),
                ),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Label(text: "Visual Axis"),
                        CustomDropdown(
                          textStyle: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF163351),
                              fontWeight: FontWeight.bold
                          ),
                          keyName: 'withoutGlasses-$eye-distanceVision',
                          items: ["Parallel","Exotropia","esotropia","alternating squint"],
                          // selectedValue: controllers['withoutGlasses.$eye.distanceVision']!.text,
                          onChanged: (value) {
                            setState(() {
                              controllers['withoutGlasses.$eye.distanceVision']!.text = value!;
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
                        Label(text: "EOM"),
                        CustomDropdown(
                          textStyle: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF163351),
                              fontWeight: FontWeight.bold
                          ),
                          keyName: 'withoutGlasses-$eye-distanceVision',
                          items: ["Normal","Limited"],
                          // selectedValue: controllers['withoutGlasses.$eye.distanceVision']!.text,
                          onChanged: (value) {
                            setState(() {
                              controllers['withoutGlasses.$eye.distanceVision']!.text = value!;
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
                        Label(text: "Conjunctiva/Sclera"),
                        CustomDropdown(
                          textStyle: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF163351),
                              fontWeight: FontWeight.bold
                          ),
                          keyName: 'withoutGlasses-$eye-distanceVision',
                          items: ["Normal", "Pterygium (grade 1/2/3/4 – Nasal/temporal/both)", "Episcleritis/ Scleritis", "Hordeolum externum", "Hordeolum Internum"],
                          // selectedValue: controllers['withoutGlasses.$eye.distanceVision']!.text,
                          onChanged: (value) {
                            setState(() {
                              controllers['withoutGlasses.$eye.distanceVision']!.text = value!;
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
                        Label(text: "Cornea"),
                        CustomDropdown(
                          textStyle: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF163351),
                              fontWeight: FontWeight.bold
                          ),
                          keyName: 'withoutGlasses-$eye-distanceVision',
                          items: ["Clear", "Opacity", "Hazy"],
                          // selectedValue: controllers['withoutGlasses.$eye.distanceVision']!.text,
                          onChanged: (value) {
                            setState(() {
                              controllers['withoutGlasses.$eye.distanceVision']!.text = value!;
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
                        Label(text: "AC"),
                        CustomDropdown(
                          textStyle: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF163351),
                              fontWeight: FontWeight.bold
                          ),
                          keyName: 'withoutGlasses-$eye-distanceVision',
                          items: ["Normal", "Shallow depth"],
                          // selectedValue: controllers['withoutGlasses.$eye.distanceVision']!.text,
                          onChanged: (value) {
                            setState(() {
                              controllers['withoutGlasses.$eye.distanceVision']!.text = value!;
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
                        Label(text: "Pupil Reactions"),
                        CustomDropdown(
                          textStyle: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF163351),
                              fontWeight: FontWeight.bold
                          ),
                          keyName: 'withoutGlasses-$eye-distanceVision',
                          items: ["Normal", "RAPD+"],
                          // selectedValue: controllers['withoutGlasses.$eye.distanceVision']!.text,
                          onChanged: (value) {
                            setState(() {
                              controllers['withoutGlasses.$eye.distanceVision']!.text = value!;
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
                        Label(text: "Lens"),
                        CustomDropdown(
                          textStyle: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF163351),
                              fontWeight: FontWeight.bold
                          ),
                          keyName: 'withoutGlasses-$eye-distanceVision',
                          items: ["Immature cataract", "Near Mature cataract", "Mature Cataract", "Hypermature Cataract", "PCIOL", "Aphakia"],
                          // selectedValue: controllers['withoutGlasses.$eye.distanceVision']!.text,
                          onChanged: (value) {
                            setState(() {
                              controllers['withoutGlasses.$eye.distanceVision']!.text = value!;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
            ],
          );
        })
      ],
    );
  }
}
