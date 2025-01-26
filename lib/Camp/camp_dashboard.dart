import 'package:flutter/material.dart';
import 'package:opthadoc/Components/CardComponent.dart';

class CampDashboard extends StatelessWidget {
  final String campCode;

  const CampDashboard({super.key, required this.campCode});

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
                'Camp Code: $campCode',
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

  Widget _buildRecentActivityCard() {
    return CardComponent(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Recent Activity",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF163351),
              ),
            ),
            const SizedBox(height: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildActivity("Last checkup: 5m ago"),
                const SizedBox(height: 8.0),
                _buildActivity("Last registration: 12m ago"),
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
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildActivity(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
        color: const Color(0xFF163351).withValues(alpha: .6), // text-[#163351]/60
      ),
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
                  _buildRecentActivityCard(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

