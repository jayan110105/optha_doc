import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

Future<void> generateDetailsPDF(Map<String, TextEditingController> controllers) async {
  final pdf = pw.Document();

  // Add a page to the PDF
  pdf.addPage(
    pw.Page(
      build: (context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Patient Details',
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 20),
          // Table to display details
          pw.Table(
            border: pw.TableBorder.all(),
            columnWidths: {
              0: pw.FlexColumnWidth(1), // Label column
              1: pw.FlexColumnWidth(2), // Value column
            },
            children: controllers.entries.map(
                  (entry) {
                return pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8.0),
                      child: pw.Text(
                        entry.key[0].toUpperCase() + entry.key.substring(1), // Capitalize key
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8.0),
                      child: pw.Text(entry.value.text.isEmpty ? ' ' : entry.value.text),
                    ),
                  ],
                );
              },
            ).toList(),
          ),
        ],
      ),
    ),
  );

  // Print the PDF or save it
  await Printing.layoutPdf(
    onLayout: (PdfPageFormat format) async => pdf.save(),
  );
}
