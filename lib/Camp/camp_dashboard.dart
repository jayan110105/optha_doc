import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:opthadoc/Components/CardComponent.dart';
import 'package:opthadoc/Components/CustomDropdown.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:opthadoc/data/DatabaseHelper.dart';
import 'dart:convert';

class CampDashboard extends StatefulWidget {
  final String campCode;

  const CampDashboard({super.key, required this.campCode});

  @override
  State<CampDashboard> createState() => _CampDashboardState();
}

class _CampDashboardState extends State<CampDashboard> with SingleTickerProviderStateMixin{

  int _selectedSegment = 0;

  int maleCount = 0;
  int femaleCount = 0;
  int otherCount = 0;
  int get totalCount => maleCount + femaleCount + otherCount;

  int age0_18 = 0;
  int age19_40 = 0;
  int age41_60 = 0;
  int age60plus = 0;
  int get totalAgeCount => age0_18 + age19_40 + age41_60 + age60plus;

  Map<String, int> sphereRangeCounts = {};

  Map<String, List<int>> symptomsData = {
    'Blurred Vision': [58, 65],
    'Pain': [15, 18],
    'Redness': [20, 22],
    'Watering': [25, 28],
    'Flashes': [10, 12],
    'Floaters': [12, 15],
  };

  Map<String, int> comorbidityData = {};

  Future<Map<String, int>> fetchComorbidityCounts() async {
    final exams = await DatabaseHelper.instance.getExaminations();

    // Map raw DB keys to display labels
    final labelMap = {
      "Diabetes": "Diabetes",
      "Hypertension": "Hypertension",
      "Heart disease": "Heart Disease",
      "Asthma": "Asthma",
      "Allergy to dust/meds": "Allergy",
      "Benign prostatic hyperplasia": "Prostatic Hyperplasia",
    };

    // Initialize counts with display labels
    final counts = {
      for (var label in labelMap.values) label: 0,
    };

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
      } catch (e) {
        print("⚠️ Failed to decode comorbidities: $e");
      }
    }

    print("Comorbidity counts (with labels): $counts");
    return counts;
  }

  Future<Map<String, List<int>>> fetchSymptomsData() async {
    final exams = await DatabaseHelper.instance.getExaminations();

    final symptomKeys = {
      'Blurred Vision': 'Diminution of vision',
      'Pain': 'Pain',
      'Watering': 'Watering/discharge',
      'Flashes': 'Flashes',
      'Floaters': 'Floaters',
    };


    final Map<String, int> rightCounts = {};
    final Map<String, int> leftCounts = {};

    for (var entry in exams) {
      final complaintsRaw = entry['complaints'];
      if (complaintsRaw == null || complaintsRaw.trim().isEmpty) continue;

      try {
        final complaints = jsonDecode(complaintsRaw);

        final right = complaints['rightEye'] as Map<String, dynamic>;
        final left = complaints['leftEye'] as Map<String, dynamic>;

        for (var label in symptomKeys.keys) {

          final jsonKey = symptomKeys[label]!;

          // Count if true
          if ((right[jsonKey] ?? 'no') == 'yes') {
            rightCounts[label] = (rightCounts[label] ?? 0) + 1;
          }
          if ((left[jsonKey] ?? 'no') == 'yes') {
            leftCounts[label] = (leftCounts[label] ?? 0) + 1;
          }
        }
      } catch (e) {
        print('Failed to decode complaints: $e');
      }
    }

    // Convert to List<int> structure
    final Map<String, List<int>> symptomsData = {};
    for (var label in symptomKeys.keys) {
      symptomsData[label] = [
        rightCounts[label] ?? 0,
        leftCounts[label] ?? 0,
      ];
    }

    return symptomsData;
  }

  Future<void> _fetchRefractiveErrorDistribution() async {
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

          final sign = eyeData['sphereSign'] ?? '';
          final value = eyeData['sphere'] ?? '';
          if (value == '') continue;

          double? sphere = double.tryParse(value.toString());
          if (sphere == null) continue;

          if (sign == '-') sphere = -sphere;

          // Categorize
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
      } catch (e) {
        print('⚠️ Failed to decode withCorrection: $e');
      }
    }

    setState(() {
      sphereRangeCounts = ranges;
    });
  }

  Future<void> _fetchData() async {
    final registrations = await DatabaseHelper.instance.getRegistrations();

    // Count genders
    maleCount = registrations.where((e) => e['gender']?.toLowerCase() == 'male').length;
    femaleCount = registrations.where((e) => e['gender']?.toLowerCase() == 'female').length;
    otherCount = registrations.where((e) => e['gender']?.toLowerCase() == 'other').length;

    setState(() {});
  }

  Future<void> _fetchAgeGroups() async {
    final registrations = await DatabaseHelper.instance.getRegistrations();

    age0_18 = 0;
    age19_40 = 0;
    age41_60 = 0;
    age60plus = 0;

    for (var reg in registrations) {
      int? age = reg['age'];
      if (age == null) continue;

      if (age <= 18) {
        age0_18++;
      } else if (age <= 40) {
        age19_40++;
      } else if (age <= 60) {
        age41_60++;
      } else {
        age60plus++;
      }
    }

    setState(() {}); // Update UI after fetch
  }

  Widget genderCard({
    required String label,
    required int count,
    required int totalCount,
  }) {
    String percentage = (totalCount == 0 || count == 0)
        ? "0%"
        : "${(count / totalCount * 100).toStringAsFixed(1)}%";

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              count.toString(),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(label, style: const TextStyle(fontSize: 14)),
            Text(
              percentage,
              style: const TextStyle(color: Colors.black45, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget comorbidityCard({
    required String label,
    required int count,
  }) {
    return Expanded(
      child: Container(
        height: 100,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              count.toString(),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }


  @override
  void initState() {
    super.initState();
    _fetchData();
    _fetchAgeGroups();
    _fetchRefractiveErrorDistribution();
    fetchSymptomsData().then((data) {
      setState(() {
        symptomsData = data;
      });
    });
    fetchComorbidityCounts().then((data) {
      setState(() {
        comorbidityData = data;
      });
    });
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFF163351).withValues(alpha: 0.1),
            radius: 25.0,
            child: const Text(
              'G',
              style: TextStyle(
                color: Color(0xFF163351),
                fontSize: 20.0,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Camp Mode',
                style: TextStyle(
                  color: Color(0xFF163351),
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              Text(
                'Camp Code: ${widget.campCode}',
                style: TextStyle(
                  color: const Color(0xFF163351).withValues(alpha: 0.6),
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/home'),
            icon: const Icon(
              Icons.logout,
              color: Color(0xFF163352),
              size: 25.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodayStatsCard() {
    return CardComponent(
      backgroundColor: Color(0xFF163351),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Today's Stats",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStat("Registrations", "12"),
                _buildStat("Checkups", "8"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white60, // text-white/60
          ),
        ),
        const SizedBox(height: 4.0),
        Text(
          value,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget buildBar(String label, int count, int totalCount, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontSize: 14)),
              Text(count.toString(),
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: totalCount == 0 ? 0 : count / totalCount,
            backgroundColor: Colors.grey[300],
            color: color,
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }

  Widget buildCaseRow(dynamic icon, String label, int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              icon is String
                  ? SvgPicture.asset(
                icon,
                colorFilter: ColorFilter.mode(
                  const Color(0xFF163351).withValues(alpha: .4),
                  BlendMode.srcIn,
                ),
                height: 26.0,
                width: 26.0,
              )
                  : Icon(
                icon,
                color: const Color(0xFF163351).withValues(alpha: .4),
              ),
              SizedBox(width: 8),
              Text(label, style: TextStyle(fontSize: 14)),
            ],
          ),
          Text(count.toString(), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildSymptomCard(String label, int count) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: const TextStyle(color: Colors.black45, fontSize: 14, fontWeight: FontWeight.w500)),
            const SizedBox(height: 4),
            Text(
              count.toString(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final List<Color> sphereColors = [
      Colors.blue,
      Colors.green,
      Colors.purple,
      Colors.amber,
      Colors.pink,
      Colors.teal,
      Colors.indigo,
      Colors.red,
    ];

    final segmentWidget = [
      Column(
        children: [
          CardComponent(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.people, color: Color(0xFF163351)),
                    SizedBox(width: 8),
                    Text('Gender Distribution', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(height: 4),
                Text('Distribution of patients by gender', style: const TextStyle(color: Colors.black45, fontSize: 14),),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    genderCard(label: "Male", count: maleCount, totalCount: totalCount),
                    const SizedBox(width: 16),
                    genderCard(label: "Female", count: femaleCount, totalCount: totalCount),
                    const SizedBox(width: 16),
                    genderCard(label: "Other", count: otherCount, totalCount: totalCount),
                  ],
                ),
              ],
            )
          ),
          SizedBox(height: 16),
          CardComponent(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.bar_chart, color: Color(0xFF163351)),
                      SizedBox(width: 8),
                      Text('Age Distribution', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text('Breakdown of patients by age groups', style: const TextStyle(color: Colors.black45, fontSize: 14),),
                  SizedBox(height: 8),
                  buildBar('0-18', age0_18, totalAgeCount, Colors.blue),
                  buildBar('19-40', age19_40, totalAgeCount, Colors.green),
                  buildBar('41-60', age41_60, totalAgeCount, Colors.purple),
                  buildBar('60+', age60plus, totalAgeCount, Colors.amber),
                ],
              )
          ),
        ],
      ),
      Column(
        children: [
          CardComponent(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.visibility, color: Color(0xFF163351)),
                    SizedBox(width: 8),
                    Text(
                      'Refractive Error Range (Sphere)',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  'Distribution of sphere values across patients',
                  style: const TextStyle(color: Colors.black45, fontSize: 14),
                ),
                SizedBox(height: 8),

                // Dynamically render bars
                ...sphereRangeCounts.entries.toList().asMap().entries.map((entry) {
                  final index = entry.key;
                  final label = entry.value.key;
                  final count = entry.value.value;
                  final total = sphereRangeCounts.values.fold(0, (sum, val) => sum + val);

                  return buildBar(label, count, total == 0 ? 1 : total, sphereColors[index % sphereColors.length]);
                }),
              ],
            ),
          ),
          SizedBox(height: 16),
          CardComponent(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.visibility, color: Color(0xFF163351)),
                    SizedBox(width: 8),
                    Text(
                      'Symptoms Reported Per Eye',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  'Comparison of symptoms between left and right eyes',
                  style: const TextStyle(color: Colors.black45, fontSize: 14),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [
                    Row(
                      children: [
                        Icon(Icons.circle, color: Colors.blue, size: 10),
                        SizedBox(width: 4),
                        Text(
                            "Left Eye",
                            style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.circle, color: Colors.green, size: 10),
                        SizedBox(width: 4),
                        Text(
                            "Right Eye",
                            style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ...symptomsData.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildSymptomCard(entry.key, entry.value[0]),
                        SizedBox(width: 16),
                        _buildSymptomCard(entry.key, entry.value[1]),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
          SizedBox(height: 16),
          CardComponent(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      "assets/icons/vital_signs.svg",
                      colorFilter: ColorFilter.mode(
                          const Color(0xFF163351),
                          BlendMode.srcIn,
                      ),
                      height: 26.0,
                      width: 26.0,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Comorbidity Prevalence',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  'Common comorbidities among patients',
                  style: const TextStyle(color: Colors.black45, fontSize: 14),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    comorbidityCard(
                      label: "Hypertension",
                      count: comorbidityData["Hypertension"] ?? 0,
                    ),
                    SizedBox(width: 16,),
                    comorbidityCard(
                      label: "Diabetes",
                      count: comorbidityData["Diabetes"] ?? 0,
                    ),
                    SizedBox(width: 16,),
                    comorbidityCard(
                      label: "Heart Disease",
                      count: comorbidityData["Heart Disease"] ?? 0,
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    comorbidityCard(
                      label: "Asthma",
                      count: comorbidityData["Asthma"] ?? 0,
                    ),
                    SizedBox(width: 16,),
                    comorbidityCard(
                      label: "Allergy",
                      count: comorbidityData["Allergy"] ?? 0,
                    ),
                    SizedBox(width: 16,),
                    comorbidityCard(
                      label: "Prostatic Hyperplasia",
                      count: comorbidityData["Prostatic Hyperplasia"] ?? 0,
                    ),
                  ],
                )
              ],
            ),
          ),
        ]
      ),
      CardComponent(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Special Cases', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              buildCaseRow(Icons.visibility, 'Non-Vision Cases', 18),
              buildCaseRow("assets/icons/eyeglasses.svg", 'Bifocal Prescriptions', 43),
            ],
          )
      )
    ];

    return SingleChildScrollView(
      child: Container(
        color: const Color(0xFFE9E6DB),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildHeader(context),
              const Divider(),
              const SizedBox(height: 10),
              _buildTodayStatsCard(),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Epidemiological Analysis",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF163352),
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: CustomDropdown(
                      hintText: "Select VA",
                      textStyle: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF163351),
                          fontWeight: FontWeight.w500
                      ),
                      keyName: 'withoutGlasses-distanceVision',
                      verticalPadding: 0,
                      items: ["Today", "This Week", "This Month", "All Time"],
                      selectedValue: "Today",
                      onChanged: (value) {
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: CupertinoSlidingSegmentedControl<int>(
                  groupValue: _selectedSegment,
                  children: const {
                    0: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text("Demographics"),
                    ),
                    1: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text("Clinical"),
                    ),
                    2: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text("Outcomes"),
                    ),
                  },
                  onValueChanged: (int? value) {
                    if (value != null) {
                      setState(() {
                        _selectedSegment = value;
                      });
                    }
                  },
                ),
              ),
              const SizedBox(height: 16),
              segmentWidget[_selectedSegment],
            ],
          ),
        ),
      ),
    );
  }
}

