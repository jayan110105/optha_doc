import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

String getDurationString(Map<String, dynamic> patientData, String eye) {
  int years = int.tryParse(patientData['years-$eye']?.toString() ?? '0') ?? 0;
  int months = int.tryParse(patientData['months-$eye']?.toString() ?? '0') ?? 0;
  int days = int.tryParse(patientData['days-$eye']?.toString() ?? '0') ?? 0;

  List<String> parts = [];

  if (years > 0) parts.add("$years year${years > 1 ? 's' : ''}");
  if (months > 0) parts.add("$months month${months > 1 ? 's' : ''}");
  if (days > 0) parts.add("$days day${days > 1 ? 's' : ''}");

  return parts.isNotEmpty ? parts.join(", ") : "N/A";
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

  final filteredDiagnoses = [
    'Immature cataract',
    'Near Mature cataract',
    'Mature Cataract',
    'Hypermature Cataract',
    'PCIOL',
    'Aphakia',
    'Pterygium',
    'Dacryocystitis',
    'Amblyopia',
    'Glaucoma',
    'Diabetic retinopathy',
    'Stye',
    'Conjunctivitis',
    'Dry eye',
    'Allergic conjunctivitis'
  ].where((diagnosis) =>
  diagnosisData['$diagnosis-right'] == true ||
      diagnosisData['$diagnosis-left'] == true ||
      diagnosisData['$diagnosis-both'] == true
  ).toList();

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

  final filteredHistoryKeys = historyKeys.where((key) => shouldIncludeRow(key)).toList();

  pw.TableRow buildTableRow(
      String label,
      String reValue,
      String leValue, {
        bool boldValues = false,
        double fontSize = 12,
      }) {
    return pw.TableRow(
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.all(8.0),
          child: pw.Text(
            label,
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: fontSize),
          ),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(8.0),
          child: pw.Text(
            reValue,
            style: pw.TextStyle(
              fontWeight: boldValues ? pw.FontWeight.bold : pw.FontWeight.normal,
              fontSize: fontSize,
            ),
          ),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(8.0),
          child: pw.Text(
            leValue,
            style: pw.TextStyle(
              fontWeight: boldValues ? pw.FontWeight.bold : pw.FontWeight.normal,
              fontSize: fontSize,
            ),
          ),
        ),
      ],
    );
  }



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
            buildTableRow('Vision (NV)', patientData['vision_re_nv']??'NA', patientData['vision_le_nv']??'NA', boldValues: true),
          ],
        ),

        pw.SizedBox(height: 10),
        buildSectionHeader('History'),
        pw.SizedBox(height: 10),
        if (filteredHistoryKeys.isNotEmpty) ...[
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
              if(shouldIncludeRow('Flashes'))
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
                      buildTableRow('Flashes',
                          (historyData['Flashes-right'] ?? 'NO').toString().toUpperCase(),
                          (historyData['Flashes-left'] ?? 'NO').toString().toUpperCase()
                      ),
                    ],
                  ),
                ],
              ),
              // Row 4 with nested table
              if(shouldIncludeRow('Floaters'))
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
                      buildTableRow('Floaters',
                          (historyData['Floaters-right'] ?? 'NO').toString().toUpperCase(),
                          (historyData['Floaters-left'] ?? 'NO').toString().toUpperCase()
                      ),
                    ],
                  ),
                ],
              ),
              if(shouldIncludeRow('Glaucoma on Rx'))
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
                      buildTableRow('Glaucoma on Rx',
                          (historyData['Glaucoma on Rx-right'] ?? 'NO').toString().toUpperCase(),
                          (historyData['Glaucoma on Rx-left'] ?? 'NO').toString().toUpperCase()
                      ),
                    ],
                  ),
                ],
              ),
              if(shouldIncludeRow('Pain/redness'))
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
                      buildTableRow('Pain/ redness',
                          (historyData['Pain/redness-right'] ?? 'NO').toString().toUpperCase(),
                          (historyData['Pain/redness-left'] ?? 'NO').toString().toUpperCase()
                      ),
                    ],
                  ),
                ],
              ),
              if(shouldIncludeRow('Watering/discharge'))
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
                      buildTableRow('Watering/ discharge',
                          (historyData['Watering/discharge-right'] ?? 'NO').toString().toUpperCase(),
                          (historyData['Watering/discharge-left'] ?? 'NO').toString().toUpperCase()
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
              if (historyData['History of glasses'] == "yes") ...[
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
              if (historyData['History of glasses'] == "yes") ...[
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
              if (historyData['Previous surgery/laser rx'] == "yes") ...[
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
          pw.Table(
            border: pw.TableBorder.all(),
            columnWidths: {
              0: pw.FlexColumnWidth(2), // First column
              1: pw.FlexColumnWidth(1), // Second column (RE)
              2: pw.FlexColumnWidth(1), // Third column (LE)
            },
            children: [
              buildTableRow('', 'RE:', 'LE:', boldValues: true),

              if ((workupData["re-ducts"]?.trim().isNotEmpty ?? false) ||
                  (workupData["le-ducts"]?.trim().isNotEmpty ?? false))
                buildTableRow('Ducts', workupData["re-ducts"] ?? ' ', workupData["le-ducts"] ?? ' '),
            ],
          ),

          pw.SizedBox(height: 20),

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
        ],
        pw.SizedBox(height: 20),
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
            // Mydriasis Row
            if (hasMydriasis)
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8.0),
                    child: pw.Text(
                      'Mydriasis',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8.0),
                    child: pw.Text(dilatedData["mydriasis-right"] ?? ' '),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8.0),
                    child: pw.Text(dilatedData["mydriasis-left"] ?? ' '),
                  ),
                ],
              ),
            // Fundus Row
            if (hasFundus)
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8.0),
                    child: pw.Text(
                      'Fundus',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8.0),
                    child: pw.Text(dilatedData["fundus-right"] ?? ' '),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8.0),
                    child: pw.Text(dilatedData["fundus-left"] ?? ' '),
                  ),
                ],
              ),
            // Cataract Row
            pw.TableRow(
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8.0),
                  child: pw.Text(
                    'Cataract',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8.0),
                  child: pw.Text(
                    (dilatedData['Cataract-right'] ?? 'NO').toString().toUpperCase(),
                  ),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8.0),
                  child: pw.Text(
                    (dilatedData['Cataract-left'] ?? 'NO').toString().toUpperCase(),
                  ),
                ),
              ],
            ),
            // Glaucoma Row
            pw.TableRow(
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8.0),
                  child: pw.Text(
                    'Glaucoma',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8.0),
                  child: pw.Text(
                    (dilatedData['Glaucoma-right'] ?? 'NO').toString().toUpperCase(),
                  ),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8.0),
                  child: pw.Text(
                    (dilatedData['Glaucoma-left'] ?? 'NO').toString().toUpperCase(),
                  ),
                ),
              ],
            ),
            // Diabetic Retinopathy Row
            pw.TableRow(
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8.0),
                  child: pw.Text(
                    'Diabetic retinopathy',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8.0),
                  child: pw.Text(
                    (dilatedData['Diabetic retinopathy-right'] ?? 'NO').toString().toUpperCase(),
                  ),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8.0),
                  child: pw.Text(
                    (dilatedData['Diabetic retinopathy-left'] ?? 'NO').toString().toUpperCase(),
                  ),
                ),
              ],
            ),
            // ARMD Row
            pw.TableRow(
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8.0),
                  child: pw.Text(
                    'ARMD',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8.0),
                  child: pw.Text(
                    (dilatedData['ARMD-right'] ?? 'NO').toString().toUpperCase(),
                  ),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8.0),
                  child: pw.Text(
                    (dilatedData['ARMD-left'] ?? 'NO').toString().toUpperCase(),
                  ),
                ),
              ],
            ),
            // Optic Disc Pallor Row
            pw.TableRow(
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8.0),
                  child: pw.Text(
                    'Optic disc pallor/ atropy',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8.0),
                  child: pw.Text(
                    (dilatedData['Optic disc pallor/ atrophy-right'] ?? 'NO').toString().toUpperCase(),
                  ),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8.0),
                  child: pw.Text(
                    (dilatedData['Optic disc pallor/ atrophy-left'] ?? 'NO').toString().toUpperCase(),
                  ),
                ),
              ],
            ),
          ],
        ),
        pw.SizedBox(height: 20),
        if (filteredDiagnoses.isNotEmpty) ...[
          pw.Table(
            border: pw.TableBorder.all(),
            columnWidths: {
              0: pw.FlexColumnWidth(3), // Diagnosis column
              1: pw.FlexColumnWidth(1), // Right eye column
              2: pw.FlexColumnWidth(1), // Left eye column
              3: pw.FlexColumnWidth(1), // Both eyes column
            },
            children: [
              // Header Row
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8.0),
                    child: pw.Text(
                      'Diagnosis :',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8.0),
                    child: pw.Text(
                      'Right eye',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8.0),
                    child: pw.Text(
                      'Left eye',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8.0),
                    child: pw.Text(
                      'Both eyes',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                ],
              ),

              // Diagnosis Rows
              ...filteredDiagnoses.map(
                    (diagnosis) => pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8.0),
                      child: pw.Text(diagnosis),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8.0),
                      child: pw.Text(
                        diagnosisData['$diagnosis-right'] == true ? 'YES' : 'NO',
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8.0),
                      child: pw.Text(
                        diagnosisData['$diagnosis-left'] == true ? 'YES' : 'NO',
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8.0),
                      child: pw.Text(
                        diagnosisData['$diagnosis-both'] == true ? 'YES' : 'NO',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
        pw.SizedBox(height: 20),
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
        // Does patient need the following table
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
          children: [
            pw.TableRow(
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8.0),
                  child: pw.Text(
                      'IOP',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8.0),
                  child: pw.Text(
                      preSurgeryData['IOP'] == true ? 'YES' : 'NO',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ),
              ],
            ),
            pw.TableRow(
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8.0),
                  child: pw.Text(
                      'BSCAN',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8.0),
                  child: pw.Text(
                    preSurgeryData['BSCAN'] == true ? 'YES' : 'NO',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ),
              ],
            ),
            pw.TableRow(
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8.0),
                  child: pw.Text(
                      'Systemic evaluation',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8.0),
                  child: pw.Text(
                    preSurgeryData['Systemic evaluation'] == true ? 'YES' : 'NO',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  );

  await Printing.layoutPdf(
    onLayout: (PdfPageFormat format) async => pdf.save(),
  );
}
