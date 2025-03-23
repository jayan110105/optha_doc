import 'package:flutter/material.dart';
import 'package:opthadoc/Components/CardComponent.dart';
import 'package:opthadoc/Components/CustomDropdown.dart';

class CampDashboard extends StatefulWidget {
  final String campCode;

  const CampDashboard({super.key, required this.campCode});

  @override
  State<CampDashboard> createState() => _CampDashboardState();
}

class _CampDashboardState extends State<CampDashboard> with SingleTickerProviderStateMixin{

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: const Color(0xFFE9E6DB),
        child: Column(
          children: [
            _buildHeader(context),
            const Divider(),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(16.0), // Equivalent to p-4
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200, // Dull white/grey background for tabs
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TabBar(
                  dividerColor: Colors.transparent,
                  indicatorPadding: const EdgeInsets.symmetric(horizontal: -16.0, vertical: 4),
                  controller: _tabController,
                  labelColor: const Color(0xFF163351),
                  unselectedLabelColor: Colors.grey,
                  indicator: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    shape: BoxShape.rectangle,
                  ),
                  tabs: const [
                    Tab(text: "Demographics"),
                    Tab(text: "Case Analysis"),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 500,
              child: TabBarView(
                controller: _tabController,
                children: [
                  SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height - 200),
                      child: Container(
                        color: const Color(0xFFE9E6DB),
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTodayStatsCard(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height - 200),
                      child: Container(
                        color: const Color(0xFFE9E6DB),
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Epidemiological Analysis",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF163352),
                                  ),
                                ),
                                const SizedBox(width: 16.0),
                                Expanded(
                                  child: CustomDropdown(
                                    hintText: "Select VA",
                                    textStyle: const TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF163351),
                                      fontWeight: FontWeight.w500,
                                    ),
                                    keyName: 'withoutGlasses-distanceVision',
                                    verticalPadding: 0,
                                    items: const ["Today", "This Week", "This Month", "All Time"],
                                    selectedValue: "Today",
                                    onChanged: (value) {},
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

