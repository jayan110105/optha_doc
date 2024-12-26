import 'package:flutter/material.dart';
import 'package:opthadoc/Components/CustomDropdown.dart';

class EditWithAidCard extends StatefulWidget {
  final Map<String, dynamic>? selectedRecord;

  const EditWithAidCard({super.key, required this.selectedRecord});

  @override
  State<EditWithAidCard> createState() => _WithAidCardState();
}

class _WithAidCardState extends State<EditWithAidCard> {

  Widget _buildDetailRow(String label, String value, List<String> dropdownItems, ValueChanged<String?> onEdit) {
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
        Expanded(
          child: CustomDropdown(
            keyName: label,
            items: dropdownItems,
            selectedValue: value,
            onChanged: onEdit,
            textStyle: TextStyle(
              fontSize: isHighlighted ? 18 : 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF163351),
            ),
          )
        )
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
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 20,
              crossAxisSpacing: 8,
              childAspectRatio: 2,
            ),
            children: [
              _buildDetailRow(
                "Distance Vision",
                record['withAid'][eye]['distanceVision'],
                ["6/6", "6/9", "6/12", "6/18", "6/24", "6/36", "6/60"],
                    (value) => setState(() {
                  record['withAid'][eye]['distanceVision'] = value!;
                }),
              ),
              _buildDetailRow(
                "Near Vision",
                record['withAid'][eye]['nearVision'],
                ["N5", "N6", "N8", "N10", "N12", "N14", "N18"],
                    (value) => setState(() {
                  record['withAid'][eye]['nearVision'] = value!;
                }),
              ),
              _buildDetailRow(
                "D.V. Sphere",
                record['withAid'][eye]['dvSphere'],
                ["-2.0", "-1.0", "0.0", "+1.0", "+2.0"],
                    (value) => setState(() {
                  record['withAid'][eye]['dvSphere'] = value!;
                }),
              ),
              _buildDetailRow(
                "N.V. Sphere",
                record['withAid'][eye]['nvSphere'],
                ["-2.0", "-1.0", "0.0", "+1.0", "+2.0"],
                    (value) => setState(() {
                  record['withAid'][eye]['nvSphere'] = value!;
                }),
              ),
              _buildDetailRow(
                "Cylinder",
                record['withAid'][eye]['cyl'],
                ["-1.5", "-1.0", "0.0", "+1.0", "+1.5"],
                    (value) => setState(() {
                  record['withAid'][eye]['cyl'] = value!;
                }),
              ),
              _buildDetailRow(
                "Axis",
                "${record['withAid'][eye]['axis']}°",
                ["0°", "30°", "60°", "90°", "120°", "150°", "180°"],
                    (value) => setState(() {
                  record['withAid'][eye]['axis'] = value!.replaceAll("°", "");
                }),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            ],
          ),
          const SizedBox(height: 24),
          Column(
            children: [
              _buildEyeDetails("left", widget.selectedRecord!),
              const SizedBox(height: 24),
              _buildEyeDetails("right", widget.selectedRecord!),
            ],
          ),
          const SizedBox(height: 24),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF163351).withValues(alpha: .1),
                borderRadius: BorderRadius.circular(40),
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
                    "I.P.D: ",
                    style: const TextStyle(
                      color: Color(0xFF163351),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 50,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white, // Set background color to white
                        borderRadius: BorderRadius.circular(8), // Optional: Add rounded corners
                        border: Border.all(color: Colors.grey.shade300), // Optional: Add a border
                      ),
                      child: TextField(
                        controller: TextEditingController(
                          text: widget.selectedRecord?['withAid']['ipd'],
                        ),
                        onChanged: (value) {
                          setState(() {
                            widget.selectedRecord?['withAid']['ipd'] = value;
                          });
                        },
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4), // Adjust padding
                        ),
                        style: const TextStyle(
                          color: Color(0xFF163351),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
