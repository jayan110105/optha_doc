import 'package:flutter/material.dart';
import 'package:opthadoc/Components/CustomDropdown.dart';

class WithoutAidCard extends StatefulWidget {
  final Map<String, dynamic>? selectedRecord;

  const WithoutAidCard({super.key, this.selectedRecord});

  @override
  State<WithoutAidCard> createState() => _WithoutAidCardState();
}

class _WithoutAidCardState extends State<WithoutAidCard> {
  void updateRecord(String key, Map<String, String> value) {
    setState(() {
      widget.selectedRecord?[key] = value;
    });
  }

  Widget _buildEyeSection(String eye) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Eye Header
        Row(
          children: [
            Icon(
              Icons.visibility,
              color: const Color(0xFF163351),
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              "$eye Eye",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF163351),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Vision Details Container
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: const Color(0xFF163351).withValues(alpha: .05),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Distance Vision",
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF163351),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.selectedRecord?['withoutAid']?[eye.toLowerCase()] ?? '-',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF163351),
                ),
              ),
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
          const SizedBox(height: 24),
          _buildEyeSection("Left"),
          const SizedBox(height: 24),
          _buildEyeSection("Right"),
        ],
      ),
    );
  }
}
