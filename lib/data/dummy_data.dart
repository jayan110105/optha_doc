import 'package:flutter/material.dart';

final List<Map<String, dynamic>> records = [
  {
    "id": "1",
    "name": "Jayan",
    "age": 19,
    "patientId": "110105",
    "withoutAid": {"left": "6/6", "right": "6/9"},
    "withAid": {
      "left": {
        "distanceVision": "6/9",
        "nearVision": "N/A",
        "dvSphere": "-2.0",
        "nvSphere": "-1.5",
        "cyl": "-0.5",
        "axis": "90",
      },
      "right": {
        "distanceVision": "6/6",
        "nearVision": "N/A",
        "dvSphere": "-1.0",
        "nvSphere": "-0.75",
        "cyl": "-0.25",
        "axis": "85",
      },
      "ipd": "64",
    },
    "sphere": {"left": "null6.0", "right": "nullnull"},
    "complaint": "bad",
    "createdAt": DateTime.parse("2024-10-09T11:29:00"),
  },
  {
    "id": "2",
    "name": "Sarah Smith",
    "age": 25,
    "patientId": "110106",
    "withoutAid": {"left": "6/12", "right": "6/9"},
    "withAid": {
      "left": {
        "distanceVision": "6/6",
        "nearVision": "6/6",
        "dvSphere": "-2.5",
        "nvSphere": "-2.0",
        "cyl": "-0.75",
        "axis": "80",
      },
      "right": {
        "distanceVision": "6/6",
        "nearVision": "6/6",
        "dvSphere": "-2.0",
        "nvSphere": "-1.5",
        "cyl": "-0.5",
        "axis": "90",
      },
      "ipd": "62",
    },
    "sphere": {"left": "-2.5", "right": "-2.0"},
    "complaint": "blurred vision",
    "createdAt": DateTime.parse("2024-10-04T21:53:00"),
  },
];

final List<Map<String, dynamic>> steps = [
  {"title": "Patient Info", "icon": Icons.person},
  {"title": "Without Aid", "icon": Icons.visibility_off},
  {"title": "With Aid", "icon": Icons.visibility},
  {"title": "With Correction", "icon": "assets/icons/eyeglasses.svg"},
  {"title": "Additional Info", "icon": Icons.text_snippet},
];