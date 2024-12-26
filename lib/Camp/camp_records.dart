import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:opthadoc/Components/InputField.dart';
import 'package:opthadoc/Components/CardComponent.dart';
import 'package:opthadoc/Components/ProgressStep.dart';
import 'package:opthadoc/data/dummy_data.dart';
import 'package:opthadoc/Camp/CampRecords/PatientInfo.dart';
import 'package:opthadoc/Camp/CampRecords/WithoutAid.dart';
import 'package:opthadoc/Camp/CampRecords/WithAid.dart';
import 'package:opthadoc/Camp/CampRecords/WithCorrection.dart';
import 'package:opthadoc/Camp/CampRecords/AdditionalInfo.dart';

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
  bool isEditing = false;

  List<Widget> getStepWidgets() {
    return [
      PatientDetailsCard(selectedRecord: selectedRecord, isEditing: isEditing,),
      WithoutAidCard(selectedRecord: selectedRecord,  isEditing: isEditing,),
      WithAidCard(selectedRecord: selectedRecord),
      WithCorrectionCard(selectedRecord: selectedRecord),
      AdditionalInfoCard(selectedRecord: selectedRecord),
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
                          setState(() => isEditing = !isEditing);
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
