import 'dart:convert';
import 'package:opthadoc/data/DatabaseHelper.dart';

class CampDataService {
  static Future<Map<String, int>> fetchComorbidityCounts() async {
    final exams = await DatabaseHelper.instance.getExaminations();

    final labelMap = {
      "Diabetes": "Diabetes",
      "Hypertension": "Hypertension",
      "Heart disease": "Heart Disease",
      "Asthma": "Asthma",
      "Allergy to dust/meds": "Allergy",
      "Benign prostatic hyperplasia": "Prostatic Hyperplasia",
      "On Antiplatelets": "On Antiplatelets",
    };

    final counts = {for (var label in labelMap.values) label: 0};

    for (var entry in exams) {
      final raw = entry['comorbidities'];
      if (raw == null || raw.toString().trim().isEmpty) continue;

      try {
        final decoded = jsonDecode(raw);
        decoded.forEach((key, value) {
          if (labelMap.containsKey(key) && value == true) {
            final displayLabel = labelMap[key]!;
            counts[displayLabel] = counts[displayLabel]! + 1;
          }
        });
      } catch (_) {}
    }

    return counts;
  }

  static Future<Map<String, List<int>>> fetchSymptomsData() async {
    final exams = await DatabaseHelper.instance.getExaminations();

    final symptomKeys = {
      'Blurred Vision': 'Diminution of vision',
      'Pain': 'Pain',
      'Watering': 'Watering/discharge',
      'Flashes': 'Flashes',
      'Floaters': 'Floaters',
    };

    final rightCounts = <String, int>{};
    final leftCounts = <String, int>{};

    for (var entry in exams) {
      final complaintsRaw = entry['complaints'];
      if (complaintsRaw == null || complaintsRaw.trim().isEmpty) continue;

      try {
        final complaints = jsonDecode(complaintsRaw);
        final right = complaints['rightEye'] ?? {};
        final left = complaints['leftEye'] ?? {};

        for (var label in symptomKeys.keys) {
          final key = symptomKeys[label]!;
          if ((right[key] ?? 'no') == 'yes') rightCounts[label] = (rightCounts[label] ?? 0) + 1;
          if ((left[key] ?? 'no') == 'yes') leftCounts[label] = (leftCounts[label] ?? 0) + 1;
        }
      } catch (_) {}
    }

    return {
      for (var label in symptomKeys.keys)
        label: [rightCounts[label] ?? 0, leftCounts[label] ?? 0],
    };
  }

  static Future<Map<String, int>> fetchSphereRangeCounts() async {
    final checkups = await DatabaseHelper.instance.getEyeCheckups();

    final ranges = {
      "-6.0 or worse": 0,
      "-5.9 to -4.0": 0,
      "-3.9 to -2.0": 0,
      "-1.9 to -0.5": 0,
      "-0.4 to +0.4": 0,
      "+0.5 to +2.0": 0,
      "+2.1 to +4.0": 0,
      "+4.1 or more": 0,
    };

    for (var entry in checkups) {
      final rawJson = entry['withCorrection'];
      if (rawJson == null || rawJson.trim().isEmpty) continue;

      try {
        final parsed = jsonDecode(rawJson);
        for (final eye in ['left', 'right']) {
          final eyeData = parsed[eye];
          if (eyeData == null) continue;

          double? sphere = double.tryParse(eyeData['sphere']?.toString() ?? '');
          if (sphere == null) continue;

          if (eyeData['sphereSign'] == '-') sphere = -sphere;

          if (sphere <= -6.0) {
            ranges["-6.0 or worse"] = ranges["-6.0 or worse"]! + 1;
          } else if (sphere <= -4.0) {
            ranges["-5.9 to -4.0"] = ranges["-5.9 to -4.0"]! + 1;
          } else if (sphere <= -2.0) {
            ranges["-3.9 to -2.0"] = ranges["-3.9 to -2.0"]! + 1;
          } else if (sphere <= -0.5) {
            ranges["-1.9 to -0.5"] = ranges["-1.9 to -0.5"]! + 1;
          } else if (sphere <= 0.4) {
            ranges["-0.4 to +0.4"] = ranges["-0.4 to +0.4"]! + 1;
          } else if (sphere <= 2.0) {
            ranges["+0.5 to +2.0"] = ranges["+0.5 to +2.0"]! + 1;
          } else if (sphere <= 4.0) {
            ranges["+2.1 to +4.0"] = ranges["+2.1 to +4.0"]! + 1;
          } else {
            ranges["+4.1 or more"] = ranges["+4.1 or more"]! + 1;
          }
        }
      } catch (_) {}
    }

    return ranges;
  }

  static Future<Map<String, int>> fetchGenderCounts() async {
    final registrations = await DatabaseHelper.instance.getRegistrations();
    return {
      'male': registrations.where((e) => e['gender']?.toLowerCase() == 'male').length,
      'female': registrations.where((e) => e['gender']?.toLowerCase() == 'female').length,
      'other': registrations.where((e) => e['gender']?.toLowerCase() == 'other').length,
    };
  }

  static Future<Map<String, int>> fetchAgeGroups() async {
    final registrations = await DatabaseHelper.instance.getRegistrations();

    final counts = {
      '0-18': 0,
      '19-40': 0,
      '41-60': 0,
      '60+': 0,
    };

    for (var reg in registrations) {
      final age = reg['age'];
      if (age == null) continue;

      if (age <= 18) {
        counts['0-18'] = counts['0-18']! + 1;
      } else if (age <= 40) {
        counts['19-40'] = counts['19-40']! + 1;
      } else if (age <= 60) {
        counts['41-60'] = counts['41-60']! + 1;
      }
      else {
        counts['60+'] = counts['60+']! + 1;
      }
    }

    return counts;
  }

  static Future<Map<String, int>> fetchVAImprovementData() async {
    final checkups = await DatabaseHelper.instance.getEyeCheckups();

    final Map<String, int> result = {
      "Significant": 0,
      "Moderate": 0,
      "Minimal": 0,
      "No improvement": 0,
    };

    final Map<String, int> vaRank = {
      '6/6': 1, '6/9': 2, '6/12': 3, '6/18': 4,
      '6/24': 5, '6/36': 6, '6/60': 7,
      '3/60': 8, '1/60': 9, 'HM+': 10, 'PL+': 11, 'PL-': 12,
    };

    for (final entry in checkups) {
      try {
        final withoutRaw = entry['withoutGlasses'];
        final withRaw = entry['withCorrection'];
        if (withoutRaw == null || withRaw == null) continue;

        final without = jsonDecode(withoutRaw);
        final withCorr = jsonDecode(withRaw);

        for (final eye in ['left', 'right']) {
          final preVA = without['${eye}VA'];
          final postVA = withCorr[eye]?['VA'];

          final preRank = vaRank[preVA];
          final postRank = vaRank[postVA];

          if (preRank != null && postRank != null) {
            final diff = preRank - postRank;

            if (diff >= 3) {
              result["Significant"] = result["Significant"]! + 1;
            } else if (diff >= 1) {
              result["Moderate"] = result["Moderate"]! + 1;
            } else if (diff > 0) {
              result["Minimal"] = result["Minimal"]! + 1;
            } else {
              result["No improvement"] = result["No improvement"]! + 1;
            }
          } else {
            result["No improvement"] = result["No improvement"]! + 1;
          }
        }
      } catch (e) {
        print('⚠️ Error parsing VA improvement: $e');
        result["No improvement"] = result["No improvement"]! + 2; // fallback
      }
    }

    return result;
  }

  static Future<Map<String, Map<String, int>>> fetchAnatomicalFindings() async {
    final exams = await DatabaseHelper.instance.getExaminations();

    final Map<String, Map<String, int>> result = {
      "Visual Axis": {},
      "EOM": {},
      "Conjunctiva": {},
      "Cornea": {},
      "AC": {},
      "Pupil Reactions": {},
      "Lens": {},
    };

    for (var entry in exams) {
      final raw = entry['examFindings'];
      if (raw == null || raw.toString().trim().isEmpty) continue;

      try {
        final decoded = jsonDecode(raw);

        // Map keys to display titles
        final keyMap = {
          "visualAxis": "Visual Axis",
          "eom": "EOM",
          "conjunctiva": "Conjunctiva",
          "cornea": "Cornea",
          "anteriorChamber": "AC",
          "pupilReactions": "Pupil Reactions",
          "lens": "Lens",
        };

        for (final fieldKey in keyMap.keys) {
          final category = keyMap[fieldKey]!;
          final field = decoded[fieldKey];
          if (field is! Map<String, dynamic>) continue;

          for (final eye in ['left', 'right']) {
            final finding = field[eye];
            if (finding == null || finding.toString().trim().isEmpty) continue;

            final value = finding.toString();
            result[category]![value] = (result[category]![value] ?? 0) + 1;
          }
        }
      } catch (e) {
        print("⚠️ Failed to parse examFindings: $e");
      }
    }

    return result;
  }

  static String _normalizeLabel(String input) {
    return input
        .split(' ')
        .map((w) => w.isEmpty ? '' : w[0].toUpperCase() + w.substring(1).toLowerCase())
        .join(' ');
  }

  static Future<Map<String, int>> fetchDiagnosisCounts() async {
    final checkups = await DatabaseHelper.instance.getExaminations();

    final Map<String, int> diagnosisCounts = {};

    for (final entry in checkups) {
      final raw = entry['diagnosis'];
      if (raw == null) continue;

      try {
        final decoded = jsonDecode(raw);

        for (final eye in ['rightEye', 'leftEye']) {
          final eyeData = decoded[eye];
          if (eyeData is Map<String, dynamic>) {
            eyeData.forEach((key, value) {
              if (value == true) {
                // Normalize labels (capitalize first letter of each word)
                final label = _normalizeLabel(key);
                diagnosisCounts[label] = (diagnosisCounts[label] ?? 0) + 1;
              }
            });
          }
        }
      } catch (e) {
        print("⚠️ Diagnosis decode failed: $e");
      }
    }

    return diagnosisCounts;
  }

}


