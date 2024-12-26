import 'package:flutter/material.dart';

class WithAidCard extends StatelessWidget {
  final Map<String, dynamic>? selectedRecord;

  const WithAidCard({super.key, required this.selectedRecord});

  Widget _buildDetailRow(String label, String value) {
    // Determine if the label requires a larger font size
    bool isHighlighted = label == "Distance Vision" || label == "Near Vision";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Color(0xFF163351).withAlpha(153), // 60% alpha
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Flexible(
          child: Text(
            value,
            style: TextStyle(
              fontSize: isHighlighted ? 18 : 14, // Larger font size for highlighted labels
              fontWeight: FontWeight.bold,
              color: Color(0xFF163351),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEyeDetails(String eye, Map<String, dynamic> record) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.visibility,
              color: Color(0xFF163351),
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              "${eye[0].toUpperCase()}${eye.substring(1)} Eye",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF163351),
                fontSize: 16,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: const Color(0xFF163351).withValues(alpha: .05),
            borderRadius: BorderRadius.circular(8),
          ),
          child: GridView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(), // Prevents scrolling inside the grid
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Number of columns
              mainAxisSpacing: 12, // Spacing between rows
              crossAxisSpacing: 8, // Spacing between columns
              childAspectRatio: 3, // Adjust to control the height/width ratio
            ),
            children: [
              _buildDetailRow("Distance Vision", record['withAid'][eye]['distanceVision']),
              _buildDetailRow("Near Vision", record['withAid'][eye]['nearVision']),
              _buildDetailRow("D.V. Sphere", record['withAid'][eye]['dvSphere']),
              _buildDetailRow("N.V. Sphere", record['withAid'][eye]['nvSphere']),
              _buildDetailRow("Cylinder", record['withAid'][eye]['cyl']),
              _buildDetailRow("Axis", "${record['withAid'][eye]['axis']}°"),
            ],
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
          Row(
            children: const [
              Icon(
                Icons.visibility,
                color: Color(0xFF163351),
                size: 24,
              ),
              SizedBox(width: 8),
              Text(
                "With Aid",
                style: TextStyle(
                  color: Color(0xFF163351),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Column(
            children: [
              _buildEyeDetails("left", selectedRecord!),
              const SizedBox(height: 24),
              _buildEyeDetails("right", selectedRecord!),
            ],
          ),
          const SizedBox(height: 24),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF163351).withValues(alpha: .1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.straighten,
                    color: Color(0xFF163351),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "I.P.D: ${selectedRecord?['withAid']['ipd']} mm",
                    style: const TextStyle(
                      color: Color(0xFF163351),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}