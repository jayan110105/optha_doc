import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:opthadoc/Components/CardComponent.dart';
import 'package:opthadoc/Components/CustomDropdown.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CampDashboard extends StatefulWidget {
  final String campCode;

  const CampDashboard({super.key, required this.campCode});

  @override
  State<CampDashboard> createState() => _CampDashboardState();
}

class _CampDashboardState extends State<CampDashboard> with SingleTickerProviderStateMixin{

  int _selectedSegment = 0;

  final int maleCount = 65;
  final int femaleCount = 85;
  final int otherCount = 2;
  final int totalCount = 65 + 85 + 2;

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

  Widget buildBar(String label, int count, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: TextStyle(fontSize: 14)),
              Text(count.toString(), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            ],
          ),
          SizedBox(height: 4),
          LinearProgressIndicator(
            value: count / totalCount,
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

  @override
  Widget build(BuildContext context) {

    final segmentWidget = [
      CardComponent(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Gender Distribution', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              buildBar('male', maleCount, Colors.blue),
              buildBar('female', femaleCount, Colors.green),
              buildBar('other', otherCount, Colors.purple),
            ],
          )
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
                      child: Text("Case Analysis"),
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

