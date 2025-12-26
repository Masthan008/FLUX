import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class ReportService {
  static Future<void> generateMonthlyReport() async {
    final pdf = pw.Document();
    final box = await Hive.openBox('attendance_records');
    
    // Get all records
    final records = box.values.toList();
    
    // Sort by date (descending)
    records.sort((a, b) => b['date'].compareTo(a['date']));

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Header(
                level: 0,
                child: pw.Text("FluxFlow Attendance Report", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              ),
              pw.SizedBox(height: 10),
              pw.Text("Generated on: ${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now())}"),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(
                context: context,
                headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
                headerHeight: 25,
                cellAlignments: {
                  0: pw.Alignment.centerLeft,
                  1: pw.Alignment.centerLeft,
                  2: pw.Alignment.center,
                  3: pw.Alignment.centerLeft,
                },
                headers: ['Date & Time', 'Subject', 'Status', 'Student Name'],
                data: records.map((record) {
                  final date = DateTime.parse(record['date']);
                  return [
                    DateFormat('yyyy-MM-dd HH:mm').format(date),
                    record['subject'] ?? 'Unknown',
                    record['status'] ?? 'Unknown',
                    record['student_name'] ?? 'N/A',
                  ];
                }).toList(),
              ),
            ],
          );
        },
      ),
    );

    await Printing.sharePdf(bytes: await pdf.save(), filename: 'attendance_report.pdf');
  }
}
