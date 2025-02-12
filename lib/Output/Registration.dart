import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart' show rootBundle;

Future<void> generateDetailsPDF(Map<String, TextEditingController> controllers) async {
  final pdf = pw.Document();

  final imageBytes = await rootBundle.load('assets/images/KMC.jpg');
  final logoImage = pw.MemoryImage(imageBytes.buffer.asUint8List());

  final String formattedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());

  // Add a page to the PDF
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
                  '(O.P Registration Slip)',
                  style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  '${controllers['token']?.text}',
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
            pw.Row(
              children: [
                pw.Text(
                    'Name of the Patient:',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)
                ),
                pw.SizedBox(width: 10),
                pw.Text(controllers['name']!.text),
              ]
            ),
            pw.Row(
                children: [
                  pw.Text(
                      'Date: ',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)
                  ),
                  pw.SizedBox(width: 10),
                  pw.Text(formattedDate),
                ]
            ),
          ],
        ),
        pw.SizedBox(height: 10),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Row(
                children: [
                  pw.Text(
                      'Sex: ',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)
                  ),
                  pw.SizedBox(width: 10),
                  pw.Text(controllers['gender']!.text),
                ]
            ),
            pw.Row(
                children: [
                  pw.Text(
                      '(AGE): ',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)
                  ),
                  pw.SizedBox(width: 10),
                  pw.Text(controllers['age']!.text),
                ]
            ),
          ],
        ),
        pw.SizedBox(height: 10),
        pw.Row(
            children: [
              pw.Text(
                  'Father\'s Name: ',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)
              ),
              pw.SizedBox(width: 10),
              pw.Text(controllers['parent']!.text),
            ]
        ),
        pw.SizedBox(height: 10),
        pw.Row(
          children: [
            pw.Text(
              'Aadhaar No: ',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(width: 10),
            pw.Container(
              padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.black, width: 1),
              ),
              child: pw.Text(
                controllers['aadhar']!.text,
                style: pw.TextStyle(letterSpacing: 0.5),
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 10),
        pw.Text(
          'Address:',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        ),
        pw.Text(
          controllers['address']!.text,
        ),
        pw.SizedBox(height: 10),
        pw.Row(
            children: [
              pw.Text(
                  'Mobile No: ',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)
              ),
              pw.SizedBox(width: 10),
              pw.Text(controllers['phone']!.text),
            ]
        ),
      ],
    ),
  );

  // Print the PDF or save it
  await Printing.layoutPdf(
    onLayout: (PdfPageFormat format) async => pdf.save(),
  );
}
