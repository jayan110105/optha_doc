import 'package:flutter/material.dart';

class AdditionalInfoCard extends StatelessWidget {
  final Map<String, dynamic>? selectedRecord;

  const AdditionalInfoCard({super.key, this.selectedRecord});

  Widget _buildSection({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: const Color(0xFF163351),
              size: 16,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF163351),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: const Color(0xFF163351).withValues(alpha: .05),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: const Color(0xFF163351),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Icon(
                Icons.text_snippet,
                color: Color(0xFF163351),
                size: 24,
              ),
              SizedBox(width: 8),
              Flexible(
                child: Text(
                  "Additional Information",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF163351),
                    height: 1,
                  ),
                  softWrap: true, // Enables wrapping if text exceeds the available width
                  overflow: TextOverflow.visible, // Ensures text doesn't get clipped
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Card Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Brief Complaint
              _buildSection(
                icon: Icons.message,
                title: "Brief Complaint",
                content: selectedRecord?['complaint'] ?? "N/A",
              ),
              const SizedBox(height: 16),

              // Bifocal and Color Grid
              Row(
                children: [
                  Expanded(
                    child: _buildSection(
                      icon: Icons.remove_red_eye,
                      title: "Bifocal",
                      content: selectedRecord?['bifocal'] ?? "N/A",
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildSection(
                      icon: Icons.palette,
                      title: "Color",
                      content: selectedRecord?['color'] ?? "N/A",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Remarks
              _buildSection(
                icon: Icons.text_snippet,
                title: "Remarks",
                content: selectedRecord?['remarks'] ?? "No remarks",
              ),
            ],
          ),
        ],
      ),
    );
  }
}
