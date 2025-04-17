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

  Map<String, int> stats = {
    'Registrations': 0,
    'Checkups': 0,
  };

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

  Map<String, int> vaImprovementData = {};

  Map<String, int> diagnosisData = {};

  int get totalVAImprovements => vaImprovementData.values.fold(0, (sum, value) => sum + value);

  Map<String, Map<String, int>> anatomicalFindings = {};

  String timeframe = "Today";

  void _loadAllData() {
    CampDataService.fetchStats(timeframe).then((d) => setState(() => stats = d));
    CampDataService.fetchGenderCounts(timeframe).then((d) => setState(() => genderCounts = d));
    CampDataService.fetchAgeGroups(timeframe).then((d) => setState(() => ageGroupCounts = d));
    CampDataService.fetchSphereRangeCounts(timeframe).then((d) => setState(() => sphereRangeCounts = d));
    CampDataService.fetchSymptomsData(timeframe).then((d) => setState(() => symptomsData = d));
    CampDataService.fetchComorbidityCounts(timeframe).then((d) => setState(() => comorbidityData = d));
    CampDataService.fetchVAImprovementData(timeframe).then((d) => setState(() => vaImprovementData = d));
    CampDataService.fetchAnatomicalFindings(timeframe).then((d) => setState(() => anatomicalFindings = d));
    CampDataService.fetchDiagnosisCounts(timeframe).then((d) => setState(() => diagnosisData = d));
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
        height: 112,
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
                color: Color(0xFF163351),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Color(0xFF163351).withValues(alpha: 0.7),),
            ),
          ],
        ),
      ),
    );
  }


  @override
  void initState() {
    super.initState();
    _loadAllData();
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
              "$timeframe's Stats",
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
                _buildStat("Registrations", "${stats['Registrations']}"),
                const SizedBox(width: 16.0),
                _buildStat("Checkups", "${stats['Checkups']}"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Expanded(
      child: Column(
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
      ),
    );
  }

  Widget buildCategorySection(String title, Map<String, int> data) {
    final total = data.values.fold(0, (a, b) => a + b);
    final colorMap = [Colors.blue, Colors.green, Colors.purple, Colors.amber, Colors.pink, Colors.teal, Colors.indigo];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
        Divider(),
        const SizedBox(height: 8),
        for (var i = 0; i < data.length; i++)
          buildBar(
            data.keys.elementAt(i),
            data.values.elementAt(i),
            total == 0 ? 1 : total,
            colorMap[i % colorMap.length],
          ),
        const SizedBox(height: 16),
      ],
    );
  }


  Widget buildBar(String label, int count, int totalCount, Color color, {bool showIcon = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  if (showIcon) ...[
                    Icon(Icons.circle, color: color, size: 14),
                    const SizedBox(width: 8),
                  ],
                  Text(label, style: const TextStyle(fontSize: 14)),
                ],
              ),
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
                      'Refractive Error Range',
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
          if (anatomicalFindings.values.any((section) => section.isNotEmpty))
            SizedBox(height: 16),
          if (anatomicalFindings.values.any((section) => section.isNotEmpty))
            CardComponent(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.visibility, color: Color(0xFF163351)),
                      SizedBox(width: 8),
                      Text(
                        'Anatomical Findings',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Detailed breakdown of anatomical findings by category',
                    style: const TextStyle(color: Colors.black45, fontSize: 14),
                  ),
                  SizedBox(height: 16),
                  ...anatomicalFindings.entries
                      .where((entry) => entry.value.isNotEmpty)
                      .map((entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: buildCategorySection(entry.key, entry.value),
                  )),
                ],
              ),
            )
          else
            SizedBox.shrink(),
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
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    comorbidityCard(
                      label: "On Antiplatelets",
                      count: comorbidityData["On Antiplatelets"] ?? 0,
                    ),
                    SizedBox(width: 16,),
                    Expanded(child: SizedBox()),
                    SizedBox(width: 16,),
                    Expanded(child: SizedBox())
                  ],
                )
              ],
            ),
          ),
        ]
      ),
      Column(
        children: [
          CardComponent(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.arrow_outward, color: Color(0xFF163351)),
                      SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'VA Improvement Pre/Post Correction',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          softWrap: true,
                          overflow: TextOverflow.visible,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text('Visual acuity improvement after correction', style: const TextStyle(color: Colors.black45, fontSize: 14),),
                  SizedBox(height: 8),
                  buildBar('Significant (3+ lines)', vaImprovementData['Significant'] ?? 0, totalVAImprovements, Colors.green, showIcon: true),
                  buildBar('Moderate (1–2 lines)', vaImprovementData['Moderate'] ?? 0, totalVAImprovements, Colors.blue, showIcon: true),
                  buildBar('Minimal (<1 line)', vaImprovementData['Minimal'] ?? 0, totalVAImprovements, Colors.amber, showIcon: true),
                  buildBar('No improvement', vaImprovementData['No improvement'] ?? 0, totalVAImprovements, Colors.red, showIcon: true),
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
                    SvgPicture.asset(
                      "assets/icons/stethoscope.svg",
                      colorFilter: ColorFilter.mode(
                        const Color(0xFF163351),
                        BlendMode.srcIn,
                      ),
                      height: 26.0,
                      width: 26.0,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'All Diagnoses',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  'Diagnoses among patients',
                  style: const TextStyle(color: Colors.black45, fontSize: 14),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    comorbidityCard(
                      label: "Immature Cataract",
                      count: diagnosisData["Immature Cataract"] ?? 0,
                    ),
                    SizedBox(width: 16,),
                    comorbidityCard(
                      label: "Near Mature Cataract",
                      count: diagnosisData["Near Mature Cataract"] ?? 0,
                    ),
                    SizedBox(width: 16,),
                    comorbidityCard(
                      label: "Mature Cataract",
                      count: diagnosisData["Mature Cataract"] ?? 0,
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    comorbidityCard(
                      label: "Hypermature Cataract",
                      count: diagnosisData["Hypermature Cataract"] ?? 0,
                    ),
                    SizedBox(width: 16,),
                    comorbidityCard(
                      label: "PCIOL",
                      count: diagnosisData["Pciol"] ?? 0,
                    ),
                    SizedBox(width: 16,),
                    comorbidityCard(
                      label: "Aphakia",
                      count: diagnosisData["Aphakia"] ?? 0,
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    comorbidityCard(
                      label: "Pterygium",
                      count: diagnosisData["Pterygium"] ?? 0,
                    ),
                    SizedBox(width: 16,),
                    comorbidityCard(
                      label: "Dacryocystitis",
                      count: diagnosisData["Dacryocystitis"] ?? 0,
                    ),
                    SizedBox(width: 16,),
                    comorbidityCard(
                      label: "Amblyopia",
                      count: diagnosisData["Amblyopia"] ?? 0,
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    comorbidityCard(
                      label: "Glaucoma",
                      count: diagnosisData["Glaucoma"] ?? 0,
                    ),
                    SizedBox(width: 16,),
                    comorbidityCard(
                      label: "Diabetic Retinopathy",
                      count: diagnosisData["Diabetic Retinopathy"] ?? 0,
                    ),
                    SizedBox(width: 16,),
                    comorbidityCard(
                      label: "Stye",
                      count: diagnosisData["Stye"] ?? 0,
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    comorbidityCard(
                      label: "Conjunctivitis",
                      count: diagnosisData["Conjunctivitis"] ?? 0,
                    ),
                    SizedBox(width: 16,),
                    comorbidityCard(
                      label: "Dry Eye",
                      count: diagnosisData["Dry Eye"] ?? 0,
                    ),
                    SizedBox(width: 16,),
                    comorbidityCard(
                      label: "Allergic Conjunctivitis",
                      count: diagnosisData["Allergic Conjunctivitis"] ?? 0,
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
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
                      hintText: "Select Time Frame",
                      textStyle: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF163351),
                          fontWeight: FontWeight.w500
                      ),
                      keyName: 'timeframe',
                      verticalPadding: 0,
                      items: ["Today", "This Week", "This Month", "All Time"],
                      selectedValue: timeframe,
                      onChanged: (value) {
                        setState(() => timeframe = value!);
                        _loadAllData();
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

