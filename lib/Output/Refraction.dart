import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart' show rootBundle;

Future<void> generateRefraction(Map<String, TextEditingController> controllers) async {
  final pdf = pw.Document();

  final imageBytes = await rootBundle.load('assets/images/KMC.jpg');
  final logoImage = pw.MemoryImage(imageBytes.buffer.asUint8List());
  final String formattedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());

  pdf.addPage(
    pw.MultiPage(
      build: (context) => [
        pw.Image(
          logoImage,
          width: 180,
        ),
        pw.SizedBox(height: 20),
        pw.Center(
          child: pw.Column(
              children: [
                pw.Text(
                  'DEPARTMENT OF OPHTHALMOLOGY',
                  style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  'PRESCRIPTION FOR GLASSES (OUTREACH)',
                  style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
                ),
              ]
          ),
        ),
        pw.SizedBox(height: 20),
        // Date and Hospital No
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text('Date: $formattedDate'),
          ],
        ),
        pw.SizedBox(height: 20),
        // Prescription Table
        pw.Table(
          columnWidths: {
            0: pw.FlexColumnWidth(1),
            1: pw.FlexColumnWidth(4),
            2: pw.FlexColumnWidth(4),
          },
          children: [
            pw.TableRow(
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8.0),
                  child: pw.Text(''),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8.0),
                  child: pw.Align(
                    alignment: pw.Alignment.center,
                    child: pw.Text(
                      'RIGHT Eye',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8.0),
                  child: pw.Align(
                    alignment: pw.Alignment.center,
                    child: pw.Text(
                      'LEFT Eye',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ]
        ),
        pw.Table(
          border: pw.TableBorder.all(),
          columnWidths: {
            0: pw.FlexColumnWidth(1),
          },
          children: [
            pw.TableRow(
              children: [
                pw.Table(
                  border: pw.TableBorder.all(),
                  columnWidths: {
                    0: pw.FlexColumnWidth(2),
                    1: pw.FlexColumnWidth(1),
                    2: pw.FlexColumnWidth(1),
                    3: pw.FlexColumnWidth(1),
                    4: pw.FlexColumnWidth(1),
                    5: pw.FlexColumnWidth(1),
                    6: pw.FlexColumnWidth(1),
                    7: pw.FlexColumnWidth(1),
                  },
                  children: [
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text(''),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text('Sp.'),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text('Cyl'),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text('Axis'),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text(''),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text('Sp.'),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text('Cyl'),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text('Axis'),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            pw.TableRow(
              children: [
                pw.Table(
                  border: pw.TableBorder.all(),
                  columnWidths: {
                    0: pw.FlexColumnWidth(1),
                    1: pw.FlexColumnWidth(1),
                    2: pw.FlexColumnWidth(1),
                    3: pw.FlexColumnWidth(1),
                    4: pw.FlexColumnWidth(1),
                    5: pw.FlexColumnWidth(1),
                    6: pw.FlexColumnWidth(1),
                    7: pw.FlexColumnWidth(1),
                    8: pw.FlexColumnWidth(1),
                  },
                  children: [
                    pw.TableRow(
                      children: [
                        pw.Table(
                          border: pw.TableBorder.all(),
                          columnWidths: {
                            0: pw.FlexColumnWidth(1),
                          },
                          children: [
                            pw.TableRow(
                                children: [
                                  pw.Padding(
                                    padding: const pw.EdgeInsets.all(8.0),
                                    child: pw.Text('D.V'),
                                  ),
                                ]
                            ),
                            pw.TableRow(
                                children: [
                                  pw.Padding(
                                    padding: const pw.EdgeInsets.all(8.0),
                                    child: pw.Text('N.V'),
                                  ),
                                ]
                            ),
                          ],
                        ),
                        pw.Table(
                          border: pw.TableBorder.all(),
                          columnWidths: {
                            0: pw.FlexColumnWidth(1),
                          },
                          children: [
                            pw.TableRow(
                                children: [
                                  pw.Padding(
                                    padding: const pw.EdgeInsets.all(8.0),
                                    child: pw.Text(
                                        controllers['withCorrection.right.distanceVisionVA']!.text +
                                            (controllers['withCorrection.right.distanceVisionP']!.text == 'Yes' ? ' p' : '')
                                    )

                                  ),
                                ]
                            ),
                            pw.TableRow(
                              children: [
                                pw.Padding(
                                  padding: const pw.EdgeInsets.all(8.0),
                                  child: pw.Text(
                                    controllers['withCorrection.right.nearVisionVA']!.text.isEmpty
                                        ? 'N/A'
                                        : controllers['withCorrection.right.nearVisionVA']!.text +
                                        (controllers['withCorrection.right.nearVisionP']!.text == 'Yes' ? 'p' : '')
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        pw.Table(
                          border: pw.TableBorder.all(),
                          columnWidths: {
                            0: pw.FlexColumnWidth(1),
                          },
                          children: [
                            pw.TableRow(
                                children: [
                                  pw.Padding(
                                    padding: const pw.EdgeInsets.all(8.0),
                                    child: pw.Text("${controllers['withCorrection.right.distanceVisionSphereSign']!.text} ${controllers['withCorrection.right.distanceVisionSphere']!.text}"),
                                  ),
                                ]
                            ),
                            pw.TableRow(
                              children: [
                                pw.Padding(
                                  padding: const pw.EdgeInsets.all(8.0),
                                  child: pw.Text(
                                    "${controllers['withCorrection.right.nearVisionSphereSign']!.text} ${controllers['withCorrection.right.nearVisionSphere']!.text.isEmpty ? 'N/A' : controllers['withCorrection.right.nearVisionSphere']!.text}",
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.symmetric(vertical: 22.0, horizontal: 8.0),
                          child: pw.Text("${controllers['withCorrection.right.cylinderSign']!.text} ${controllers['withCorrection.right.cylinder']!.text}"),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.symmetric(vertical: 22.0, horizontal: 8.0),
                          child: pw.Text("${controllers['withCorrection.right.axis']!.text}°"),
                        ),
                        pw.Table(
                          border: pw.TableBorder.all(),
                          columnWidths: {
                            0: pw.FlexColumnWidth(1),
                          },
                          children: [
                            pw.TableRow(
                                children: [
                                  pw.Padding(
                                    padding: const pw.EdgeInsets.all(8.0),
                                    child: pw.Text(
                                        controllers['withCorrection.left.distanceVisionVA']!.text +
                                            (controllers['withCorrection.left.distanceVisionP']!.text == 'Yes' ? ' p' : '')
                                    )
                                  ),
                                ]
                            ),
                            pw.TableRow(
                              children: [
                                pw.Padding(
                                  padding: const pw.EdgeInsets.all(8.0),
                                  child: pw.Text(
                                    controllers['withCorrection.left.nearVisionVA']?.text.isEmpty ?? true
                                        ? 'N/A'
                                        : controllers['withCorrection.left.nearVisionVA']!.text +
                                        (controllers['withCorrection.left.nearVisionP']!.text == 'Yes' ? 'p' : '')
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        pw.Table(
                          border: pw.TableBorder.all(),
                          columnWidths: {
                            0: pw.FlexColumnWidth(1),
                          },
                          children: [
                            pw.TableRow(
                                children: [
                                  pw.Padding(
                                    padding: const pw.EdgeInsets.all(8.0),
                                      child: pw.Text("${controllers['withCorrection.left.distanceVisionSphereSign']!.text} ${controllers['withCorrection.left.distanceVisionSphere']!.text}"),
                                  ),
                                ]
                            ),
                            pw.TableRow(
                              children: [
                                pw.Padding(
                                  padding: const pw.EdgeInsets.all(8.0),
                                  child: pw.Text(
                                    "${controllers['withCorrection.left.nearVisionSphereSign']!.text} "
                                        "${controllers['withCorrection.left.nearVisionSphere']!.text.isEmpty ? 'N/A' : controllers['withCorrection.left.nearVisionSphere']!.text}",
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.symmetric(vertical: 22.0, horizontal: 8.0),
                          child: pw.Text("${controllers['withCorrection.left.cylinderSign']!.text} ${controllers['withCorrection.left.cylinder']!.text}"),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.symmetric(vertical: 22.0, horizontal: 8.0),
                          child: pw.Text("${controllers['withCorrection.left.axis']!.text}°"),
                        ),
                      ]
                    ),
                  ]
                )
              ]
            ),
            pw.TableRow(
              children: [
                pw.Table(
                  border: pw.TableBorder.all(),
                  columnWidths: {
                    0: pw.FlexColumnWidth(2),
                    1: pw.FlexColumnWidth(7),
                  },
                  children: [
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text('I.P.D.'),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                          child: pw.Text("${controllers['withCorrection.IPD']!.text} mm"),
                        ),
                      ]
                    )
                  ]
                )
              ]
            )
          ],
        ),
        pw.SizedBox(height: 20),
        // Footer
        pw.Text(
          'Bifocal : ${controllers['bifocal']!.text}',
          style: pw.TextStyle(fontSize: 12),
        ),
        pw.SizedBox(height: 10),
        pw.Text(
          'Colour : ${controllers['color']!.text}',
          style: pw.TextStyle(fontSize: 12),
        ),
        pw.SizedBox(height: 10),
        pw.Text(
          'Remarks : ${controllers['remarks']!.text}',
          style: pw.TextStyle(fontSize: 12),
        ),
        pw.SizedBox(height: 40),
        ],
      ),
      );

  await Printing.layoutPdf(
  onLayout: (PdfPageFormat format) async => pdf.save(),
  );
}
