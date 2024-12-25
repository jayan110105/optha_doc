import 'package:flutter/material.dart';

class WithoutAidCard extends StatelessWidget {
  final Map<String, dynamic>? selectedRecord;

  const WithoutAidCard({super.key, this.selectedRecord});

  Widget _buildEyeSection(String eye, String distanceVision) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Eye Header
        Row(
          children: [
            Icon(
              Icons.visibility,
              color: Color(0xFF163351),
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              "$eye Eye",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF163351),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Vision Details Container
        SizedBox(
          width: double.infinity,
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Color(0xFF163351).withValues(alpha: .05),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Distance Vision",
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF163351).withValues(alpha: .6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  distanceVision,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF163351),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card Header
          Row(
            children: const [
              Icon(
                Icons.visibility_off,
                color: Color(0xFF163351),
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                "Without Aid",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF163351),
                ),
              ),
            ],
          ),
          // Card Content
          const SizedBox(height: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Eye Details
              _buildEyeSection(
                "Left",
                selectedRecord?['withoutAid']['left'] ?? "-",
              ),
              const SizedBox(height: 24.0), // Space between Left and Right Eye
              // Right Eye Details
              _buildEyeSection(
                "Right",
                selectedRecord?['withoutAid']['right'] ?? "-",
              ),
            ],
          ),
        ],
      ),
    );
  }
}
