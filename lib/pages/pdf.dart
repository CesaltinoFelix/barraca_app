import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class pdf extends StatelessWidget {
  Future<void> generatePDF() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text('Hello, PDF!', style: pw.TextStyle(fontSize: 40)),
          );
        },
      ),
    );

    //  final dir = await getApplicationDocumentsDirectory();
    //final savePath = '/Documents';
    //final fileName = 'example.pdf';
    //final file = File(path.join(savePath, fileName));
    // await file.writeAsBytes(await pdf.save());
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final savePath = path.join(documentsDirectory.path, 'example.pdf');
    final file = File(savePath);
    await file.writeAsBytes(await pdf.save());
    print('PDF saved to: $savePath');
    print('${file}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Generation'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: generatePDF,
          child: Text('Generate PDF'),
        ),
      ),
    );
  }
}
