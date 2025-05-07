import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

String getDurationString(Map<String, dynamic> patientData, String eye) {
  final durations = ['years', 'months', 'days'].map((unit) {
    int value = int.tryParse(patientData['$unit-$eye']?.toString() ?? '0') ?? 0;
    return value > 0 ? '$value $unit${value > 1 ? 's' : ''}' : null;
  }).where((e) => e != null).join(', ');

  return durations.isNotEmpty ? durations : "N/A";
}

bool hasNonEmptyValue(String? value) => (value?.trim().isNotEmpty ?? false);

pw.TableRow buildTableRow(String label, String reValue, String leValue, {bool boldValues = false, double fontSize = 12}) {
  pw.Widget cell(String text, {bool bold = false}) => pw.Padding(
    padding: const pw.EdgeInsets.all(8.0),
    child: pw.Text(
      text,
      style: pw.TextStyle(fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal, fontSize: fontSize),
    ),
  );

  return pw.TableRow(children: [
    cell(label, bold: true),
    cell(reValue, bold: boldValues),
    cell(leValue, bold: boldValues),
  ]);
}

pw.TableRow? buildFilteredTableRow(String title, String? right, String? left) {
  String rightValue = (right ?? 'NO').toUpperCase();
  String leftValue = (left ?? 'NO').toUpperCase();

  if (rightValue == 'NO' && leftValue == 'NO') {
    return null; // Exclude this row
  }

  return buildTableRow(title, rightValue, leftValue);
}

Future<void> generateExamine(
    Map<String, dynamic> patientData,
    Map<String, dynamic> historyData,
    Map<String, bool> comorbidities,
    Map<String, String> examData,
    Map<String, dynamic> workupData,
    Map<String, dynamic> dilatedData,
    Map<String, dynamic> diagnosisData,
    Map<String, dynamic> preSurgeryData,
  ) async {
  final pdf = pw.Document();

  final activeComorbidities = comorbidities.entries.where((entry) => entry.value).toList();

  List<String> diagnosisList = [
    'Immature cataract', 'Near Mature cataract', 'Mature Cataract',
    'Hypermature Cataract', 'PCIOL', 'Aphakia', 'Pterygium',
    'Dacryocystitis', 'Amblyopia', 'Glaucoma', 'Diabetic retinopathy',
    'Stye', 'Conjunctivitis', 'Dry eye', 'Allergic conjunctivitis',
    'Refractive error', 'Normal'
  ];

// Create lists to store diagnoses per eye
  List<String> rightEyeDiagnoses = [];
  List<String> leftEyeDiagnoses = [];

  for (var diagnosis in diagnosisList) {
    if (diagnosisData['$diagnosis-right'] == true) {
      rightEyeDiagnoses.add(diagnosis);
    }
    if (diagnosisData['$diagnosis-left'] == true) {
      leftEyeDiagnoses.add(diagnosis);
    }
  }

// Convert lists to comma-separated strings
  String rightEyeDiagnosesText = rightEyeDiagnoses.isNotEmpty ? rightEyeDiagnoses.join(', ') : 'None';
  String leftEyeDiagnosesText = leftEyeDiagnoses.isNotEmpty ? leftEyeDiagnoses.join(', ') : 'None';

  String diagnosisNote = diagnosisData['notes']?.text.trim() ?? '';

  bool hasWorkupData =
      (workupData["re-ducts"]?.trim().isNotEmpty ?? false) ||
      (workupData["le-ducts"]?.trim().isNotEmpty ?? false) ||
      (workupData["sbp"]?.text.trim().isNotEmpty ?? false) ||
      (workupData["dbp"]?.text.trim().isNotEmpty ?? false) ||
      (workupData["grbs"]?.text.trim().isNotEmpty ?? false);

  bool hasMydriasis = (dilatedData["mydriasis-right"]?.trim().isNotEmpty ?? false) ||
      (dilatedData["mydriasis-left"]?.trim().isNotEmpty ?? false);

  bool hasFundus = (dilatedData["fundus-right"]?.trim().isNotEmpty ?? false) ||
      (dilatedData["fundus-left"]?.trim().isNotEmpty ?? false);

  bool shouldIncludeRow(String key) {
    return (historyData['$key-right'] != null && historyData['$key-right'].toString().toUpperCase() != 'no') ||
        (historyData['$key-left'] != null && historyData['$key-left'].toString().toUpperCase() != 'no');
  }

  final List<String> historyKeys = [
    'Diminution of vision',
    'Ocular Trauma',
    'Flashes',
    'Floaters',
    'Glaucoma on Rx',
    'Pain/redness',
    'Watering/discharge'
  ];

  List<pw.TableRow> diagnosisRows = [
    buildFilteredTableRow('Cataract', dilatedData['Cataract-right'], dilatedData['Cataract-left']),
    buildFilteredTableRow('Glaucoma', dilatedData['Glaucoma-right'], dilatedData['Glaucoma-left']),
    buildFilteredTableRow('Diabetic retinopathy', dilatedData['Diabetic retinopathy-right'], dilatedData['Diabetic retinopathy-left']),
    buildFilteredTableRow('ARMD', dilatedData['ARMD-right'], dilatedData['ARMD-left']),
    buildFilteredTableRow('Optic disc pallor/atrophy', dilatedData['Optic disc pallor/atrophy-right'], dilatedData['Optic disc pallor/atrophy-left']),
  ].where((row) => row != null).cast<pw.TableRow>().toList();


  final filteredHistoryKeys = historyKeys.where((key) => shouldIncludeRow(key)).toList();

  final List<String> preKeysToCheck = ["IOP", "BSCAN", "Systemic evaluation"];

// Filter only entries where the key matches and the value is true
  final preSurgeryEntries = preSurgeryData.entries
      .where((entry) => preKeysToCheck.contains(entry.key) && entry.value == true)
      .toList();

  final List<String> keysToCheck = [
    "Select for surgery",
    "Ref to Higher center/Base hospital",
    "Review in next camp visit",
    "Medical fitness",
    "Observation",
    "Glass prescription"
  ];

// Filter the entries that match the specified keys and have `true` values
  final planEntries = preSurgeryData.entries
      .where((entry) => keysToCheck.contains(entry.key) && entry.value == true)
      .toList();

  pw.Widget buildSectionHeader(String title, {double fontSize = 16}) {
    return pw.Center(
      child: pw.Text(
        title,
        style: pw.TextStyle(fontSize: fontSize, fontWeight: pw.FontWeight.bold),
      ),
    );
  }

  pdf.addPage(
    pw.MultiPage(
      build: (context) => [
        buildSectionHeader('Camp Case Sheet', fontSize: 20),
        pw.SizedBox(height: 40),
        pw.Table(
            columnWidths: {
              0: pw.FlexColumnWidth(1),
              1: pw.FlexColumnWidth(1),
              2: pw.FlexColumnWidth(1),
            },
            children: [
              buildTableRow('', 'RE', 'LE', boldValues: true),
            ]
        ),
        pw.Table(
          border: pw.TableBorder.all(),
          columnWidths: {
            0: pw.FlexColumnWidth(1),
            1: pw.FlexColumnWidth(1),
            2: pw.FlexColumnWidth(1),
          },
          children: [
            buildTableRow('Vision (DV)', patientData['vision_re_dv']??'NA', patientData['vision_le_dv']??'NA', boldValues: true),
            if (hasNonEmptyValue(patientData['vision_re_nv']) || hasNonEmptyValue(patientData['vision_le_nv']))
              buildTableRow('Vision (NV)', patientData['vision_re_nv'] ?? 'NA', patientData['vision_le_nv'] ?? 'NA', boldValues: true,),
          ],
        ),

        pw.SizedBox(height: 10),

        if (filteredHistoryKeys.isNotEmpty) ...[
          buildSectionHeader('History'),
          pw.SizedBox(height: 10),
          pw.Table(
            border: pw.TableBorder.all(),
            columnWidths: {
              0: pw.FlexColumnWidth(1), // Single column for the entire table
            },
            children: [
              // Row 1 with nested table
              pw.TableRow(
                children: [
                  pw.Table(
                    border: pw.TableBorder.all(),
                    columnWidths: {
                      0: pw.FlexColumnWidth(2),
                      1: pw.FlexColumnWidth(1),
                      2: pw.FlexColumnWidth(1),
                    },
                    children: [
                      buildTableRow('', 'RE:', 'LE:', boldValues: true, fontSize: 16),
                    ],
                  ),
                ],
              ),
              if(shouldIncludeRow('Diminution of vision'))
              pw.TableRow(
                children: [
                  pw.Table(
                    border: pw.TableBorder.all(),
                    columnWidths: {
                      0: pw.FlexColumnWidth(2),
                      1: pw.FlexColumnWidth(1),
                      2: pw.FlexColumnWidth(1),
                    },
                    children: [
                      buildTableRow('Diminution of vision:',
                          (historyData['Diminution of vision-right'] ?? 'NO').toString().toUpperCase(),
                          (historyData['Diminution of vision-left'] ?? 'NO').toString().toUpperCase()
                      ),
                    ],
                  ),
                ],
              ),
              if(shouldIncludeRow('Diminution of vision'))
              pw.TableRow(
                children: [
                  pw.Table(
                    border: pw.TableBorder.all(),
                    columnWidths: {
                      0: pw.FlexColumnWidth(2),
                      1: pw.FlexColumnWidth(1),
                      2: pw.FlexColumnWidth(1),
                    },
                    children: [
                      buildTableRow('Duration:', getDurationString(patientData, "right"), getDurationString(patientData, "left")),
                    ],
                  ),
                ],
              ),
              if(shouldIncludeRow('Ocular Trauma'))
              pw.TableRow(
                children: [
                  pw.Table(
                    border: pw.TableBorder.all(),
                    columnWidths: {
                      0: pw.FlexColumnWidth(2),
                      1: pw.FlexColumnWidth(1),
                      2: pw.FlexColumnWidth(1),
                    },
                    children: [
                      buildTableRow('Ocular Trauma',
                          (historyData['Ocular Trauma-right'] ?? 'NO').toString().toUpperCase(),
                          (historyData['Ocular Trauma-left'] ?? 'NO').toString().toUpperCase()
                      ),
                    ],
                  ),
                ],
              ),
              // Row 2 with nested table
              if (historyData['Nature of Trauma-right'] != null &&
                  historyData['Nature of Trauma-right'].text.trim().isNotEmpty) ...[
                pw.TableRow(
                  children: [
                    pw.Table(
                      border: pw.TableBorder.all(),
                      columnWidths: {
                        0: pw.FlexColumnWidth(1),
                        1: pw.FlexColumnWidth(1),
                      },
                      children: [
                        pw.TableRow(
                          children: [
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(8.0),
                              child: pw.Text(
                                'Nature of Trauma - RE',
                                style: pw.TextStyle(),
                              ),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(8.0),
                              child: pw.Text(
                                historyData['Nature of Trauma-right'].text,
                                style: pw.TextStyle(),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
              if (historyData['Nature of Trauma-left'] != null &&
                  historyData['Nature of Trauma-left'].text.trim().isNotEmpty) ...[
                pw.TableRow(
                  children: [
                    pw.Table(
                      border: pw.TableBorder.all(),
                      columnWidths: {
                        0: pw.FlexColumnWidth(1),
                        1: pw.FlexColumnWidth(1),
                      },
                      children: [
                        pw.TableRow(
                          children: [
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(8.0),
                              child: pw.Text(
                                'Nature of Trauma - LE',
                                style: pw.TextStyle(),
                              ),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(8.0),
                              child: pw.Text(
                                historyData['Nature of Trauma-left'].text,
                                style: pw.TextStyle(),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
              // Row 3 with nested table
              for (var key in filteredHistoryKeys.where((k) => k != 'Diminution of vision' && k != 'Ocular Trauma'))
                pw.TableRow(
                  children: [
                    pw.Table(
                      border: pw.TableBorder.all(),
                      columnWidths: {
                        0: pw.FlexColumnWidth(2),
                        1: pw.FlexColumnWidth(1),
                        2: pw.FlexColumnWidth(1),
                      },
                      children: [
                        buildTableRow(
                          key,
                          (historyData['$key-right'] ?? 'NO').toString().toUpperCase(),
                          (historyData['$key-left'] ?? 'NO').toString().toUpperCase(),
                        ),
                      ],
                    ),
                  ],
                ),
            ],
          ),
          pw.SizedBox(height: 20),
        ],
        if ((historyData['History of glasses'] != null || historyData['History of glasses'] == 'no') &&
            (historyData['Previous surgery/laser rx'] != null || historyData['Previous surgery/laser rx'] != 'no')) ...[
          buildSectionHeader('Additional History'),
          pw.SizedBox(height: 10),
          pw.Table(
            border: pw.TableBorder.all(),
            columnWidths: {
              0: pw.FlexColumnWidth(1), // Single column for the entire table
            },
            children: [
              // Row 1 with nested table
              pw.TableRow(
                children: [
                  if (historyData['History of glasses'] != null)
                  pw.Table(
                    border: pw.TableBorder.all(),
                    columnWidths: {
                      0: pw.FlexColumnWidth(2),
                      1: pw.FlexColumnWidth(2),
                    },
                    children: [
                      pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8.0),
                            child: pw.Text(
                              'History of glasses ',
                              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8.0),
                            child: pw.Text(
                              (historyData['History of glasses'] ?? 'NO').toString().toUpperCase(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              // Row 2 with nested table
              if (historyData['History of glasses'] == "yes" && historyData['Are PG comfortable ?'] == "yes") ...[
                pw.TableRow(
                  children: [
                    pw.Table(
                      border: pw.TableBorder.all(),
                      columnWidths: {
                        0: pw.FlexColumnWidth(2),
                        1: pw.FlexColumnWidth(3),
                      },
                      children: [
                        pw.TableRow(
                          children: [
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(8.0),
                              child: pw.Text(
                                'are PG comfortable ?',
                                style: pw.TextStyle(),
                              ),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(8.0),
                              child: pw.Text(
                                (historyData['Are PG comfortable ?'] ?? 'NO').toString().toUpperCase(),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
              // Row 3 with nested table
              if (historyData['History of glasses'] == "yes" && historyData['Last Glass change'].text.isNotEmpty) ...[
                pw.TableRow(
                  children: [
                    pw.Table(
                      border: pw.TableBorder.all(),
                      columnWidths: {
                        0: pw.FlexColumnWidth(2),
                        1: pw.FlexColumnWidth(3),
                      },
                      children: [
                        pw.TableRow(
                          children: [
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(8.0),
                              child: pw.Text(
                                'Last Glass change',
                                style: pw.TextStyle(),
                              ),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(8.0),
                              child: pw.Text(
                                historyData['Last Glass change'].text ?? 'NA',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
              // Row 4 with nested table
              if (historyData['Previous surgery/laser rx'] != null)
              pw.TableRow(
                children: [
                  pw.Table(
                    border: pw.TableBorder.all(),
                    columnWidths: {
                      0: pw.FlexColumnWidth(1),
                      1: pw.FlexColumnWidth(1),
                    },
                    children: [
                      pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8.0),
                            child: pw.Text(
                              'Previous surgery/laser rx : ',
                              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8.0),
                            child: pw.Text(
                              (historyData['Previous surgery/laser rx'] ?? 'NO').toString().toUpperCase(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              if (historyData['Previous surgery/laser rx'] == "yes" && historyData['Details of surgery/procedure'].text.isNotEmpty) ...[
                pw.TableRow(
                  children: [
                    pw.Table(
                      border: pw.TableBorder.all(),
                      columnWidths: {
                        0: pw.FlexColumnWidth(1),
                        1: pw.FlexColumnWidth(1),
                      },
                      children: [
                        pw.TableRow(
                          children: [
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(8.0),
                              child: pw.Text(
                                'Details of surgery/procedure:',
                                style: pw.TextStyle(),
                              ),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(8.0),
                              child: pw.Text(
                                historyData['Details of surgery/procedure'].text ?? 'NA',
                                style: pw.TextStyle(),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ]
            ],
          ),
          pw.SizedBox(height: 20),
        ],
        if (activeComorbidities.isNotEmpty) ...[
          pw.Center(
            child: pw.Text(
              'Comorbidities and Medications:',
              style: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Table(
            border: pw.TableBorder.all(),
            columnWidths: {
              0: pw.FlexColumnWidth(2),
              1: pw.FlexColumnWidth(2),
            },
            children: [
              // Diabetes mellitus row
              ...activeComorbidities.map(
                    (entry) => pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8.0),
                      child: pw.Text(
                        entry.key,
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8.0),
                      child: pw.Text('YES'),
                    ),
                  ],
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 20),
        ],

        pw.Center(
          child: pw.Text(
            'Examination : torchlight -',
            style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
          ),
        ),
        pw.SizedBox(height: 10),
        pw.Table(
          border: pw.TableBorder.all(),
          columnWidths: {
            0: pw.FlexColumnWidth(2), // First column for labels
            1: pw.FlexColumnWidth(1.5), // Second column for RE
            2: pw.FlexColumnWidth(1.5), // Third column for LE
          },
          children: [
            // Header Row
            buildTableRow('', 'RE:', 'LE:', boldValues: true),
            // Visual Axis Row
            buildTableRow('Visual Axis', examData["visualAxis-right"] ?? ' ', examData["visualAxis-left"] ?? ' '),
            buildTableRow('EOM', examData["eom-right"] ?? ' ', examData["eom-left"] ?? ' '),
            buildTableRow('Conjunctiva/Sclera', examData["conjunctiva-right"] ?? ' ', examData["conjunctiva-left"] ?? ' '),
            buildTableRow('Cornea', examData["cornea-right"] ?? ' ', examData["cornea-left"] ?? ' '),
            buildTableRow('AC', examData["ac-right"] ?? ' ', examData["ac-left"] ?? ' '),
            buildTableRow('Pupil Reactions', examData["pupilReactions-right"] ?? ' ', examData["pupilReactions-left"] ?? ' '),
            buildTableRow('Lens', examData["lens-right"] ?? ' ', examData["lens-left"] ?? ' '),
          ],
        ),
        pw.SizedBox(height: 20),
        if (hasWorkupData) ...[
          pw.Center(
            child: pw.Text(
              'Workup:',
              style: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
          pw.SizedBox(height: 10),

          // Table for RE & LE Ducts
          if ((workupData["re-ducts"]?.trim().isNotEmpty ?? false) ||
          (workupData["le-ducts"]?.trim().isNotEmpty ?? false))...[
            pw.Table(
              border: pw.TableBorder.all(),
              columnWidths: {
                0: pw.FlexColumnWidth(2), // First column
                1: pw.FlexColumnWidth(1), // Second column (RE)
                2: pw.FlexColumnWidth(1), // Third column (LE)
              },
              children: [
                    buildTableRow('', 'RE:', 'LE:', boldValues: true),
                    buildTableRow('Ducts', workupData["re-ducts"] ?? ' ', workupData["le-ducts"] ?? ' '),
              ],
            ),
            pw.SizedBox(height: 20)
          ],
          // BP and GRBS Rows (Only Add If Non-Empty)
          if ((workupData["sbp"]?.text.trim().isNotEmpty ?? false) ||
              (workupData["dbs"]?.text.trim().isNotEmpty ?? false))
            pw.Table(
              border: pw.TableBorder.all(),
              columnWidths: {
                0: pw.FlexColumnWidth(1), // Full width
                1: pw.FlexColumnWidth(2),
              },
              children: [
                if ((workupData["sbp"]?.text.trim().isNotEmpty ?? false) ||
                    (workupData["dbp"]?.text.trim().isNotEmpty ?? false))
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text(
                          'BP -',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text(
                          '${workupData["sbp"].text}/${workupData["dbp"].text} mmHg',
                        ),
                      ),
                    ],
                  ),

                if (workupData["grbs"]?.text.trim().isNotEmpty ?? false)
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text(
                          'GRBS -',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text(
                          workupData["grbs"].text,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            pw.SizedBox(height: 20),
        ],

        if(!hasMydriasis && !hasFundus && diagnosisRows.isNotEmpty) ... [
          pw.Text(
            'Dilated Evaluation',
            style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 10),
          pw.Table(
            border: pw.TableBorder.all(),
            columnWidths: {
              0: pw.FlexColumnWidth(2), // First column (label)
              1: pw.FlexColumnWidth(1), // Second column (RE)
              2: pw.FlexColumnWidth(1), // Third column (LE)
            },
            children: [

              buildTableRow('', 'RE:', 'LE:', boldValues: true),

              if (hasMydriasis)
                buildTableRow('Mydriasis', dilatedData["mydriasis-right"] ?? ' ', dilatedData["mydriasis-left"] ?? ' '),

              if (hasFundus)
                buildTableRow('Fundus', dilatedData["fundus-right"] ?? ' ', dilatedData["fundus-left"] ?? ' '),

              ...diagnosisRows,
            ],
          ),
          pw.SizedBox(height: 20),
        ],
        if (rightEyeDiagnoses.isNotEmpty || leftEyeDiagnoses.isNotEmpty || diagnosisNote != '') ...[
          buildSectionHeader("Diagnosis"),
          if (rightEyeDiagnoses.isNotEmpty || leftEyeDiagnoses.isNotEmpty) ...[
            pw.SizedBox(height: 10),
            pw.Table(
              border: pw.TableBorder.all(),
              columnWidths: {
                0: pw.FlexColumnWidth(1), // Eye column
                1: pw.FlexColumnWidth(3), // Diagnosis column
              },
              children: [
                // Table header
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8.0),
                      child: pw.Text(
                        'Eye',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8.0),
                      child: pw.Text(
                        'Diagnosis',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                  ],
                ),

                // Right Eye Row
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8.0),
                      child: pw.Text('Right Eye'),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8.0),
                      child: pw.Text(rightEyeDiagnosesText),
                    ),
                  ],
                ),

                // Left Eye Row
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8.0),
                      child: pw.Text('Left Eye'),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8.0),
                      child: pw.Text(leftEyeDiagnosesText),
                    ),
                  ],
                ),
              ],
            ),
          ],
          if (diagnosisNote.isNotEmpty) ...[
            pw.SizedBox(height: 10),
            pw.Table(
              border: pw.TableBorder.all(),
              columnWidths: {
                0: pw.FlexColumnWidth(1), // Label column
                1: pw.FlexColumnWidth(3), // YES column
              },
              children: [
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8.0),
                      child: pw.Text(
                        'Note',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8.0),
                      child: pw.Text(
                        diagnosisNote,
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
          pw.SizedBox(height: 20),
        ],

        if (planEntries.isNotEmpty) ...[
          pw.Text(
            'Required Pre-Surgery Actions:',
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: planEntries.map((entry) {
              return pw.Text(
                '- ${entry.key}', // Bullet point with the label
                style: pw.TextStyle(fontSize: 14),
              );
            }).toList(),
          ),
          pw.SizedBox(height: 20),
        ],

        if ((preSurgeryData['Cardio/Medicine clearance for surgery'] ?? 'NO').toString().toUpperCase() != 'NO')...[
          pw.Table(
            border: pw.TableBorder.all(),
            columnWidths: {
              0: pw.FlexColumnWidth(2), // Label column
              1: pw.FlexColumnWidth(2), // YES column
            },
            children: [
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8.0),
                    child: pw.Text(
                      'Cardio/Medicine clearance for surgery:',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8.0),
                    child: pw.Text(
                      (preSurgeryData['Cardio/Medicine clearance for surgery'] ?? 'NO').toString().toUpperCase(),
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 20),
        ],
        // Does patient need the following table
        if (preSurgeryEntries.isNotEmpty) ...[
          pw.Text(
            'Does patient need the following on arrival at KH:',
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Table(
            border: pw.TableBorder.all(),
            columnWidths: {
              0: pw.FlexColumnWidth(2), // Label column
              1: pw.FlexColumnWidth(2), // YES column
            },
            children: preSurgeryEntries.map((entry) {
              return pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8.0),
                    child: pw.Text(
                      entry.key, // Key as the label
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8.0),
                    child: pw.Text(
                      'YES', // Since only true values are considered
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ]
      ],
    ),
  );

  await Printing.layoutPdf(
    onLayout: (PdfPageFormat format) async => pdf.save(),
  );
}
