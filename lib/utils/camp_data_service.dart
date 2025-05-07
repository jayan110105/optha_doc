// Updated CampDataService with range-based filtering support
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:opthadoc/data/DatabaseHelper.dart';

class CampDataService {
  /// Builds SQL WHERE clause and arguments for a given time range.
  static List<dynamic> _buildDateRange(String range) {
    if (range == 'Today') {
      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      return ['date LIKE ?', '$today%'];
    } else if (range == 'This Week') {
      final now = DateTime.now();
      final weekStart = now.subtract(Duration(days: now.weekday - 1));
      final start = DateFormat('yyyy-MM-dd').format(weekStart);
      return ['date >= ?', start];
    } else if (range == 'This Month') {
      final now = DateTime.now();
      final start = DateFormat('yyyy-MM-01').format(now);
      return ['date >= ?', start];
    }
    // All Time: no filtering
    return [null, null];
  }

  /// Executes a filtered query on the given [table] for the specified [range].
  static Future<List<Map<String, dynamic>>> _filteredQuery(
      String table, String range) async {
    final db = await DatabaseHelper.instance.database;
    final clause = _buildDateRange(range);
    final where = clause[0] as String?;
    final args = clause[1] != null ? [clause[1]] : null;
    return await db.query(
      table,
      where: where,
      whereArgs: args,
      orderBy: 'date DESC',
    );
  }

  /// Fetches registration and checkup counts for the given [range].
  static Future<Map<String, int>> fetchStats(String range) async {
    final regs = await _filteredQuery('registrations', range);
    final chk = await _filteredQuery('eye_checkups', range);
    return {
      'Registrations': regs.length,
      'Checkups': chk.length,
    };
  }

  /// Fetches gender distribution from registrations.
  static Future<Map<String, int>> fetchGenderCounts(String range) async {
    final data = await _filteredQuery('registrations', range);
    return {
      'male': data.where((e) => (e['gender'] as String?)?.toLowerCase() == 'male').length,
      'female': data.where((e) => (e['gender'] as String?)?.toLowerCase() == 'female').length,
      'other': data.where((e) => (e['gender'] as String?)?.toLowerCase() == 'other').length,
    };
  }

  /// Fetches age group distribution from registrations.
  static Future<Map<String, int>> fetchAgeGroups(String range) async {
    final data = await _filteredQuery('registrations', range);
    final counts = {'0-18': 0, '19-40': 0, '41-60': 0, '60+': 0};
    for (var r in data) {
      final age = r['age'] as int?;
      if (age == null) continue;
      if (age <= 18) counts['0-18'] = counts['0-18']! + 1;
      else if (age <= 40) counts['19-40'] = counts['19-40']! + 1;
      else if (age <= 60) counts['41-60'] = counts['41-60']! + 1;
      else counts['60+'] = counts['60+']! + 1;
    }
    return counts;
  }

  /// Fetches comorbidity counts from examinations.
  static Future<Map<String, int>> fetchComorbidityCounts(String range) async {
    final exams = await _filteredQuery('examinations', range);
    final labelMap = {
      'Diabetes': 'Diabetes',
      'Hypertension': 'Hypertension',
      'Heart disease': 'Heart Disease',
      'Asthma': 'Asthma',
      'Allergy to dust/meds': 'Allergy',
      'Benign prostatic hyperplasia': 'Prostatic Hyperplasia',
      'On Antiplatelets': 'On Antiplatelets',
    };
    final counts = {for (var v in labelMap.values) v: 0};
    for (var e in exams) {
      final raw = e['comorbidities'] as String?;
      if (raw == null || raw.isEmpty) continue;
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      decoded.forEach((k, v) {
        if (v == true && labelMap.containsKey(k)) {
          counts[labelMap[k]!] = counts[labelMap[k]!]! + 1;
        }
      });
    }
    return counts;
  }

  /// Fetches symptom counts (right/left) from complaints.
  static Future<Map<String, List<int>>> fetchSymptomsData(String range) async {
    final exams = await _filteredQuery('examinations', range);
    final symptomKeys = {
      'Blurred Vision': 'Diminution of vision',
      'Pain': 'Pain',
      'Watering': 'Watering/discharge',
      'Flashes': 'Flashes',
      'Floaters': 'Floaters',
    };
    final right = <String, int>{};
    final left = <String, int>{};
    for (var e in exams) {
      final raw = e['complaints'] as String?;
      if (raw == null || raw.isEmpty) continue;
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      final re = decoded['rightEye'] as Map<String, dynamic>? ?? {};
      final le = decoded['leftEye'] as Map<String, dynamic>? ?? {};
      symptomKeys.forEach((label, key) {
        if ((re[key] ?? '').toString().toLowerCase() == 'yes') {
          right[label] = (right[label] ?? 0) + 1;
        }
        if ((le[key] ?? '').toString().toLowerCase() == 'yes') {
          left[label] = (left[label] ?? 0) + 1;
        }
      });
    }
    return {
      for (var label in symptomKeys.keys)
        label: [right[label] ?? 0, left[label] ?? 0],
    };
  }

  /// Fetches sphere range distribution from checkups.
  static Future<Map<String, int>> fetchSphereRangeCounts(String range) async {
    final data = await _filteredQuery('eye_checkups', range);
    final ranges = {
      '-6.0 or worse': 0,
      '-5.9 to -4.0': 0,
      '-3.9 to -2.0': 0,
      '-1.9 to -0.5': 0,
      '-0.4 to +0.4': 0,
      '+0.5 to +2.0': 0,
      '+2.1 to +4.0': 0,
      '+4.1 or more': 0,
    };
    for (var e in data) {
      final raw = e['withCorrection'] as String?;
      if (raw == null || raw.isEmpty) continue;
      final parsed = jsonDecode(raw) as Map<String, dynamic>;
      for (var eye in ['left', 'right']) {
        final d = parsed[eye] as Map<String, dynamic>?;
        if (d == null) continue;
        var s = double.tryParse(d['sphere']?.toString() ?? '');
        if (s == null) continue;
        if (d['sphereSign'] == '-') s = -s;
        if (s <= -6.0) ranges['-6.0 or worse'] = ranges['-6.0 or worse']! + 1;
        else if (s <= -4.0) ranges['-5.9 to -4.0'] = ranges['-5.9 to -4.0']! + 1;
        else if (s <= -2.0) ranges['-3.9 to -2.0'] = ranges['-3.9 to -2.0']! + 1;
        else if (s <= -0.5) ranges['-1.9 to -0.5'] = ranges['-1.9 to -0.5']! + 1;
        else if (s <= 0.4) ranges['-0.4 to +0.4'] = ranges['-0.4 to +0.4']! + 1;
        else if (s <= 2.0) ranges['+0.5 to +2.0'] = ranges['+0.5 to +2.0']! + 1;
        else if (s <= 4.0) ranges['+2.1 to +4.0'] = ranges['+2.1 to +4.0']! + 1;
        else ranges['+4.1 or more'] = ranges['+4.1 or more']! + 1;
      }
    }
    return ranges;
  }

  /// Fetches VA improvement categories from checkups.
  static Future<Map<String, int>> fetchVAImprovementData(String range) async {
    final data = await _filteredQuery('eye_checkups', range);
    final result = {'Significant': 0, 'Moderate': 0, 'Minimal': 0, 'No improvement': 0};
    final vaRank = {
      '6/6': 1, '6/9': 2, '6/12': 3, '6/18': 4,
      '6/24': 5, '6/36': 6, '6/60': 7,
      '3/60': 8, '1/60': 9, 'HM+': 10, 'PL+': 11, 'PL-': 12,
    };
    for (var e in data) {
      final w = jsonDecode(e['withoutGlasses'] as String) as Map<String, dynamic>;
      final c = jsonDecode(e['withCorrection'] as String) as Map<String, dynamic>;
      for (var eye in ['left', 'right']) {
        final pre = vaRank[w['${eye}VA']];
        final post = vaRank[c[eye]?['VA']];
        if (pre != null && post != null) {
          final diff = pre - post;
          if (diff >= 3) result['Significant'] = result['Significant']! + 1;
          else if (diff >= 1) result['Moderate'] = result['Moderate']! + 1;
          else if (diff > 0) result['Minimal'] = result['Minimal']! + 1;
          else result['No improvement'] = result['No improvement']! + 1;
        } else {
          result['No improvement'] = result['No improvement']! + 1;
        }
      }
    }
    return result;
  }

  /// Fetches anatomical findings distributions from examinations.
  static Future<Map<String, Map<String, int>>> fetchAnatomicalFindings(
      String range) async {
    final data = await _filteredQuery('examinations', range);

    final result = {
      'Visual Axis': <String, int>{},
      'EOM': <String, int>{},
      'Conjunctiva': <String, int>{},
      'Cornea': <String, int>{},
      'AC': <String, int>{},
      'Pupil Reactions': <String, int>{},
      'Lens': <String, int>{},
    };

    final keyMap = {
      'visualAxis': 'Visual Axis',
      'eom': 'EOM',
      'conjunctiva': 'Conjunctiva',
      'cornea': 'Cornea',
      'anteriorChamber': 'AC',
      'pupilReactions': 'Pupil Reactions',
      'lens': 'Lens',
    };

    for (var e in data) {
      final raw = e['examFindings'] as String?;
      if (raw == null || raw.isEmpty) continue;
      final dec = jsonDecode(raw) as Map<String, dynamic>;
      keyMap.forEach((field, title) {
        final fld = dec[field] as Map<String, dynamic>?;
        if (fld == null) return;
        for (var eye in ['left', 'right']) {
          final val = fld[eye]?.toString();
          if (val == null || val.isEmpty) continue;
          result[title]![val] = (result[title]![val] ?? 0) + 1;
        }
      });
    }
    return result;
  }

  /// Fetches diagnosis counts from examinations.
  static Future<Map<String, int>> fetchDiagnosisCounts(String range) async {
    final data = await _filteredQuery('examinations', range);
    final counts = <String, int>{};
    for (var e in data) {
      final raw = e['diagnosis'] as String?;
      if (raw == null) continue;
      final dec = jsonDecode(raw) as Map<String, dynamic>;
      for (var eyeKey in ['rightEye', 'leftEye']) {
        final eyeData = dec[eyeKey] as Map<String, dynamic>?;
        if (eyeData == null) continue;
        eyeData.forEach((key, val) {
          if (val == true) {
            final label = key.split(' ').map((w) => w.isEmpty ? '' : '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}').join(' ');
            counts[label] = (counts[label] ?? 0) + 1;
          }
        });
      }
    }
    return counts;
  }

  /// Fetches surgical path counts from examinations.
  static Future<Map<String, int>> fetchSurgicalPathCounts(String range) async {
    final exams = await _filteredQuery('examinations', range);
    final counts = {
      'Selected for Surgery': 0,
      'Referred': 0,
      'Review Next Camp': 0,
      'Medical Fitness': 0,
      'Observation': 0,
      'Glass Prescription': 0,
    };
    
    for (var e in exams) {
      final raw = e['preSurgeryPlan'] as String?;
      if (raw == null || raw.isEmpty) continue;
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      
      if (decoded['selectedForSurgery'] == true) counts['Selected for Surgery'] = counts['Selected for Surgery']! + 1;
      if (decoded['referral'] == true) counts['Referred'] = counts['Referred']! + 1;
      if (decoded['reviewNextCamp'] == true) counts['Review Next Camp'] = counts['Review Next Camp']! + 1;
      if (decoded['medicalFitness'] == true) counts['Medical Fitness'] = counts['Medical Fitness']! + 1;
      if (decoded['observation'] == true) counts['Observation'] = counts['Observation']! + 1;
      if (decoded['glassPrescription'] == true) counts['Glass Prescription'] = counts['Glass Prescription']! + 1;
    }
    return counts;
  }
}
