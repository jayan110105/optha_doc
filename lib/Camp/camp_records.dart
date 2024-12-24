import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:opthadoc/Components/InputField.dart';
import 'package:opthadoc/Components/CardComponent.dart';
import 'package:opthadoc/Components/Label.dart';

class CampRecords extends StatefulWidget {
  const CampRecords({super.key});

  @override
  State<CampRecords> createState() => _CampRecordsState();
}

class _CampRecordsState extends State<CampRecords> {
  final List<Map<String, dynamic>> records = [
    {
      "id": "1",
      "name": "Jayan",
      "age": 19,
      "patientId": "110105",
      "withoutAid": {"left": "6/6", "right": "6/9"},
      "withAid": {"left": "6/9", "right": "N/A"},
      "sphere": {"left": "null6.0", "right": "nullnull"},
      "complaint": "bad",
      "createdAt": DateTime.parse("2024-10-09T11:29:00"),
    },
    {
      "id": "2",
      "name": "Sarah Smith",
      "age": 25,
      "patientId": "110106",
      "withoutAid": {"left": "6/12", "right": "6/9"},
      "withAid": {"left": "6/6", "right": "6/6"},
      "sphere": {"left": "-2.5", "right": "-2.0"},
      "complaint": "blurred vision",
      "createdAt": DateTime.parse("2024-10-04T21:53:00"),
    },
  ];

  String searchQuery = "";
  Map<String, dynamic>? selectedRecord;

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
                                style: TextStyle(color: Color(0xFF163351))),
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
                ),
              ),
              SizedBox(height: 20),
              CardComponent(
                backgroundColor: Color(0xFF163351),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 35,
                            backgroundColor: Colors.white,
                            foregroundColor: Color(0xFF163351),
                            child: Text(selectedRecord!["name"][0]),
                          ),
                          SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                selectedRecord!["name"],
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(Icons.person, color: Colors.white.withValues(alpha: 0.8),size: 20,),
                                  SizedBox(width: 4),
                                  Text(
                                    "Age: ${selectedRecord!["age"]}",
                                    style: TextStyle(color: Colors.white.withValues(alpha: 0.8)),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(Icons.text_snippet, color: Colors.white.withValues(alpha: 0.8),size: 20,),
                                  SizedBox(width: 4),
                                  Text(
                                    "ID: ${selectedRecord!["patientId"]}",
                                    style: TextStyle(color: Colors.white.withValues(alpha: 0.8)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Text(
                        "Last Examination",
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.8))
                      ),
                      Text(
                          "Oct 9, 2024",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                      ),
                      Text(
                          "11:29 AM",
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.8))
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                "Vision Measurements",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF163351),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Without Aid",
                                style: TextStyle(
                                    color: Color(0xFF163351),
                                    fontWeight: FontWeight.bold)),
                            Text("Left: ${selectedRecord!["withoutAid"]["left"]}"),
                            Text("Right: ${selectedRecord!["withoutAid"]["right"]}"),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("With Aid",
                                style: TextStyle(
                                    color: Color(0xFF163351),
                                    fontWeight: FontWeight.bold)),
                            Text("Left: ${selectedRecord!["withAid"]["left"]}"),
                            Text("Right: ${selectedRecord!["withAid"]["right"]}"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
