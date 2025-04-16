import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:opthadoc/Components/CardComponent.dart';
import 'package:opthadoc/Components/CustomDropdown.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:opthadoc/utils/camp_data_service.dart';

class CampDashboard extends StatefulWidget {
  final String campCode;

  const CampDashboard({super.key, required this.campCode});

  @override
  State<CampDashboard> createState() => _CampDashboardState();
}

class _CampDashboardState extends State<CampDashboard> with SingleTickerProviderStateMixin{

  int _selectedSegment = 0;

  Map<String, int> genderCounts = {
    'male': 0,
    'female': 0,
    'other': 0,
  };

  int get totalCount => genderCounts.values.reduce((a, b) => a + b);

  Map<String, int> ageGroupCounts = {
    '0-18': 0,
    '19-40': 0,
    '41-60': 0,
    '60+': 0,
  };

  int get totalAgeCount => ageGroupCounts.values.reduce((a, b) => a + b);


  Map<String, int> sphereRangeCounts = {};

  Map<String, List<int>> symptomsData = {};

  Map<String, int> comorbidityData = {};

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

    CampDataService.fetchGenderCounts().then((data) {
      setState(() {
        genderCounts = data;
      });
    });

    CampDataService.fetchAgeGroups().then((data) {
      setState(() {
        ageGroupCounts = data;
      });
    });

    CampDataService.fetchSphereRangeCounts().then((data) {
      setState(() {
        sphereRangeCounts = data;
      });
    });

    CampDataService.fetchSymptomsData().then((data) {
      setState(() {
        symptomsData = data;
      });
    });

    CampDataService.fetchComorbidityCounts().then((data) {
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
                    genderCard(label: "Male", count: genderCounts["male"] ?? 0, totalCount: totalCount),
                    const SizedBox(width: 16),
                    genderCard(label: "Female", count: genderCounts["female"] ?? 0, totalCount: totalCount),
                    const SizedBox(width: 16),
                    genderCard(label: "Other", count: genderCounts["other"] ?? 0, totalCount: totalCount),
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
                  buildBar('0-18', ageGroupCounts['0-18'] ?? 0, totalAgeCount, Colors.blue),
                  buildBar('19-40', ageGroupCounts['19-40'] ?? 0, totalAgeCount, Colors.green),
                  buildBar('41-60', ageGroupCounts['41-60'] ?? 0, totalAgeCount, Colors.purple),
                  buildBar('60+', ageGroupCounts['60+'] ?? 0, totalAgeCount, Colors.amber),
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

