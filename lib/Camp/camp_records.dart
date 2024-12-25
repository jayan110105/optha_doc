import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:opthadoc/Components/InputField.dart';
import 'package:opthadoc/Components/CardComponent.dart';
import 'package:opthadoc/Components/ProgressStep.dart';
import 'package:opthadoc/data/dummy_data.dart';

class CampRecords extends StatefulWidget {
  const CampRecords({super.key});

  @override
  State<CampRecords> createState() => _CampRecordsState();
}

class _CampRecordsState extends State<CampRecords> {

  void nextStep() => setState(() => step = (step + 1).clamp(0, steps.length - 1));
  void prevStep() => setState(() => step = (step - 1).clamp(0, steps.length - 1));

  String searchQuery = "";
  Map<String, dynamic>? selectedRecord;
  int step = 0;

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

  List<Widget> getStepWidgets() {
    return [
      Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 48,
              backgroundColor: const Color(0xFF163351),
              child: Text(
                selectedRecord?['name'][0],
                style: const TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              selectedRecord?['name'],
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
                      text: 'Last Exam: ${DateFormat('MMM d, yyyy').format(selectedRecord?['createdAt'])}',
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildDetailItem(
                      icon: Icons.access_time,
                      text: DateFormat('h:mm a').format(selectedRecord?['createdAt']),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card Header
            Row(
              children: [
                Icon(
                  Icons.visibility_off,
                  color: Color(0xFF163351),
                  size: 20,
                ),
                const SizedBox(width: 8),
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
            SizedBox(height: 24,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Eye Details
                _buildEyeSection("Left", selectedRecord?['withoutAid']['left'] ?? "-"),
                const SizedBox(height: 24.0), // Space between Left and Right Eye
                // Right Eye Details
                _buildEyeSection("Right", selectedRecord?['withoutAid']['right'] ?? "-"),
              ],
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.visibility,
                  color: Color(0xFF163351),
                  size: 24,
                ),
                const SizedBox(width: 8),
                const Text(
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
      ),
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.visibility,
                  color: Color(0xFF163351),
                  size: 24,
                ),
                const SizedBox(width: 8),
                const Text(
                  "With Correction",
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
      ),
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card Header
            Row(
              children: [
                Icon(
                  Icons.text_snippet, // Replace with your desired icon
                  color: const Color(0xFF163351),
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  "Additional Information",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF163351),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24,),
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
                        icon: Icons.remove_red_eye, // Replace with Glasses icon
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
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredRecords = records.where((record) {
      return record["name"].toLowerCase().contains(searchQuery.toLowerCase()) ||
          record["patientId"].contains(searchQuery);
    }).toList();

    return Scaffold(
      backgroundColor: Color(0xFFE9E6DB),
      body: selectedRecord == null
          ? Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  "Camp Registration",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF163351),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Register a new patient for the eye camp",
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF163351).withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 20),
                CardComponent(
                    child: InputField(
                        hintText: "Search by name or ID...",
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value;
                          });
                        },
                        prefixIcon: Icon(Icons.search, color: Colors.grey[400])
                    )
                ),
                SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredRecords.length,
                    itemBuilder: (context, index) {
                      final record = filteredRecords[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: CardComponent(
                          boxShadow: [],
                          padding: EdgeInsets.zero,
                          child: ListTile(
                            onTap: () {
                              setState(() {
                                selectedRecord = record;
                              });
                            },
                            leading: CircleAvatar(
                              backgroundColor: Color(0xFF163351),
                              foregroundColor: Colors.white,
                              child: Text(record["name"][0]),
                            ),
                            title: Text(record["name"],
                                style: TextStyle(color: Color(0xFF163351), fontWeight: FontWeight.bold)),
                            subtitle: Text(
                              "ID: ${record["patientId"]} • ${DateFormat('MMM d, yyyy').format(record["createdAt"])}",
                              style: TextStyle(color: Color(0xFF163351).withValues(alpha: 0.6)),
                            ),
                            trailing: Icon(Icons.chevron_right,
                                color: Color(0xFF163351).withValues(alpha: 0.6)),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          )
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        selectedRecord = null;
                      });
                    },
                    icon: Icon(Icons.arrow_back, color: Color(0xFF163351)),
                    label: Row(
                      mainAxisSize: MainAxisSize.min, // Keeps content compact
                      children: [
                        SizedBox(width: 8),
                        Text(
                          "Back to Records",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // Adjust the width as needed
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Color(0xFF163351),
                      elevation: 0,
                      shadowColor: Colors.transparent,
                    ),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Define your onTap functionality here
                        },
                        child: Container(
                          height: 40.0,
                          width: 40.0,
                          decoration: BoxDecoration(
                            color: Colors.white, // Background color
                            border: Border.all(color: Color(0xFFd1d5db)), // Matches 'border-input'
                            borderRadius: BorderRadius.circular(8.0), // Rounded corners
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              'assets/icons/edit_square.svg', // Path to your SVG file
                              colorFilter: ColorFilter.mode(
                                Colors.black, // Apply the color filter
                                BlendMode.srcIn,
                              ), // Optional: Apply a color filter
                              height: 18.0, // Matches size-4
                              width: 18.0, // Matches size-4
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10,),
                      GestureDetector(
                        onTap: () {
                          // Define your onTap functionality here
                        },
                        child: Container(
                          height: 40.0,
                          width: 40.0,
                          decoration: BoxDecoration(
                            color: Colors.white, // Background color
                            border: Border.all(color: Color(0xFFd1d5db)), // Matches 'border-input'
                            borderRadius: BorderRadius.circular(8.0), // Rounded corners
                          ),
                          child: Center(
                            child: Icon(
                              Icons.share_outlined, // Replace with a custom icon if needed
                              color: Colors.black, // Adjust the icon color as required
                              size: 16.0, // Matches size-4
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              ProgressSteps(
                  steps: steps,
                  currentStep: step,
                  onStepTapped: (index) {
                    setState(() {
                      step = index;
                    });
                  },
              ),
              SizedBox(height: 20),
              CardComponent(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xFF163351).withValues(alpha: 0.1),
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: getStepWidgets()[step])
                    ,
                  ),
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, // Matches the bg-background color
                      foregroundColor: const Color(0xFF163351),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // Rounded border with 0 radius
                      ),
                    ),
                    onPressed: step > 0 ? prevStep : null,
                    child: Row(
                      children: [
                        Icon(
                          Icons.arrow_back_ios,
                          color: step > 0 ? Color(0xFF163351): Colors.grey[500],
                        ),
                        SizedBox(width: 8,),
                        Text("Back")],
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF163351), // Button background color
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // Rounded border with 0 radius
                      ),
                    ),
                    onPressed:
                    step == steps.length - 1 ? () => print("") : nextStep,
                    child: Row(
                      children: [
                        Text(step == steps.length - 1 ? "Save Checkup" : "Continue"),
                        if (step < steps.length - 1) ...[
                          SizedBox(width: 8), // Adds spacing if not the last step
                          Icon(Icons.arrow_forward_ios, color: Colors.white),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
