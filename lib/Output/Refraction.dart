import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart' show rootBundle;

Future<void> generateRefraction() async {
  final pdf = pw.Document();

  final imageBytes = await rootBundle.load('assets/images/KMC.jpg');
  final logoImage = pw.MemoryImage(imageBytes.buffer.asUint8List());

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
                  'PRESCRIPTION FOR GLASSES',
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
            pw.Text('Date: .....................................'),
            pw.Text('Hospital No.: .....................................'),
          ],
        ),
        pw.SizedBox(height: 10),
        // Name
        pw.Text('Name: .....................................................................................................'),
        pw.SizedBox(height: 20),
        // Prescription Table
        pw.Table(
          columnWidths: {
            0: pw.FlexColumnWidth(2),
            1: pw.FlexColumnWidth(3),
            2: pw.FlexColumnWidth(3),
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
                          child: pw.Text('Sphere'),
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
                          child: pw.Text('Sphere'),
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
                    0: pw.FlexColumnWidth(2),
                    1: pw.FlexColumnWidth(1),
                    2: pw.FlexColumnWidth(2),
                    3: pw.FlexColumnWidth(1),
                    4: pw.FlexColumnWidth(2),
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
                                    child: pw.Text('NA'),
                                  ),
                                ]
                            ),
                            pw.TableRow(
                                children: [
                                  pw.Padding(
                                    padding: const pw.EdgeInsets.all(8.0),
                                    child: pw.Text('NA'),
                                  ),
                                ]
                            ),
                          ],
                        ),
                        pw.SizedBox(width: 10),
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
                                    child: pw.Text('NA'),
                                  ),
                                ]
                            ),
                            pw.TableRow(
                                children: [
                                  pw.Padding(
                                    padding: const pw.EdgeInsets.all(8.0),
                                    child: pw.Text('NA'),
                                  ),
                                ]
                            ),
                          ],
                        ),
                        pw.SizedBox(width: 10),
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
                    1: pw.FlexColumnWidth(3),
                    2: pw.FlexColumnWidth(1),
                    3: pw.FlexColumnWidth(2),
                  },
                  children: [
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text('I.P.D.'),
                        ),
                        pw.SizedBox(),
                        pw.SizedBox(),
                        pw.SizedBox(),
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
          'Bifocal : KR/Exec/ID/Tri/Omni',
          style: pw.TextStyle(fontSize: 12),
        ),
        pw.SizedBox(height: 10),
        pw.Text(
          'Colour : White/SP2Alpha/Photogrey/Photosun/Photobrown',
          style: pw.TextStyle(fontSize: 12),
        ),
        pw.SizedBox(height: 10),
        pw.Text(
          'Remarks : Constant Use/D.V. Only/N.V. Only',
          style: pw.TextStyle(fontSize: 12),
        ),
        pw.SizedBox(height: 40),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.end,
          children: [
            pw.Text('Signature: ............................................'),
          ],
        ),
        ],
      ),
      );

  await Printing.layoutPdf(
  onLayout: (PdfPageFormat format) async => pdf.save(),
  );
}
