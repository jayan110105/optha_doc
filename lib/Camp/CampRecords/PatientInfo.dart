import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PatientDetailsCard extends StatelessWidget {
  final Map<String, dynamic>? selectedRecord;

  const PatientDetailsCard({super.key, this.selectedRecord});

  Widget _buildDetailItem({required IconData icon, required String text}) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Color(0xFF163351).withValues(alpha: 0.6),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF163351).withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 48,
            backgroundColor: const Color(0xFF163351),
            child: Text(
              selectedRecord?['name'][0] ?? '',
              style: const TextStyle(
                fontSize: 30,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            selectedRecord?['name'] ?? '',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF163351),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildDetailItem(
                    icon: Icons.person,
                    text: 'Age: ${selectedRecord?['age']}',
                  ),
                  const SizedBox(width: 16),
                  _buildDetailItem(
                    icon: Icons.text_snippet,
                    text: 'ID: ${selectedRecord?['patientId']}',
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildDetailItem(
                    icon: Icons.calendar_today,
                    text: 'Last Exam: ${selectedRecord?['createdAt'] != null ? DateFormat('MMM d, yyyy').format(selectedRecord!['createdAt']) : ''}',
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildDetailItem(
                    icon: Icons.access_time,
                    text: selectedRecord?['createdAt'] != null ? DateFormat('h:mm a').format(selectedRecord!['createdAt']) : '',
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
