import 'package:flutter/material.dart';
import 'package:opthadoc/Components/CustomDropdown.dart';

class EditAdditionalInfoCard extends StatefulWidget {
  final Map<String, dynamic>? selectedRecord;

  const EditAdditionalInfoCard({super.key, this.selectedRecord});

  @override
  State<EditAdditionalInfoCard> createState() => _EditAdditionalInfoCardState();
}

class _EditAdditionalInfoCardState extends State<EditAdditionalInfoCard> {

  Widget _buildDropdownSection({
    required IconData icon,
    required String title,
    required String content,
    required String keyName,
    required List<String> dropdownItems,
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
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF163351),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        CustomDropdown(
          keyName: keyName,
          items: dropdownItems,
          selectedValue: content,
          onChanged: (value) {
            setState(() {
              widget.selectedRecord?[keyName] = value;
            });
          },
          textStyle: const TextStyle(
            fontSize: 14,
            color: Color(0xFF163351),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(
                    Icons.text_snippet,
                    color: Color(0xFF163351),
                    size: 24,
                  ),
                  SizedBox(width: 8),
                  Text(
                    "Additional Information",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF163351),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Card Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Brief Complaint Dropdown
              _buildDropdownSection(
                icon: Icons.message,
                title: "Brief Complaint",
                content: widget.selectedRecord?['complaint'] ?? "None",
                keyName: 'complaint',
                dropdownItems: ["None", "Blurred Vision", "Headache", "Eye Pain"], // Example complaints
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  // Bifocal Dropdown
                  Expanded(
                    child: _buildDropdownSection(
                      icon: Icons.remove_red_eye,
                      title: "Bifocal",
                      content: widget.selectedRecord?['bifocal'] ?? "N/A",
                      keyName: 'bifocal',
                      dropdownItems: ["Yes", "No"],
                    ),
                  ),
                  const SizedBox(width: 16), // Space between the dropdowns
                  // Color Dropdown
                  Expanded(
                    child: _buildDropdownSection(
                      icon: Icons.palette,
                      title: "Color",
                      content: widget.selectedRecord?['color'] ?? "N/A",
                      keyName: 'color',
                      dropdownItems: ["Red", "Blue", "Green", "Yellow"], // Example colors
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Remarks Dropdown
              _buildDropdownSection(
                icon: Icons.text_snippet,
                title: "Remarks",
                content: widget.selectedRecord?['remarks'] ?? "No remarks",
                keyName: 'remarks',
                dropdownItems: ["None", "Follow-up Required", "Refer to Specialist"], // Example remarks
              ),
            ],
          ),
        ],
      ),
    );
  }
}