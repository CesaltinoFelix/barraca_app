import 'package:barraca_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class PDFViewerPage extends StatefulWidget {
  @override
  _PDFViewerPageState createState() => _PDFViewerPageState();
}

class _PDFViewerPageState extends State<PDFViewerPage> {
  bool _isLoading = true;
  String? _pdfPath;

  @override
  void initState() {
    super.initState();
    downloadPDF();
  }

  Future<void> downloadPDF() async {
    final url = 'http://www.pdf995.com/samples/pdf.pdf';

    final response = await http.get(Uri.parse(url));
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final filePath = '${documentsDirectory.path}/pdf.pdf';

    File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);

    setState(() {
      _pdfPath = filePath;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Visualizador de PDF'),
      ),
      body: Stack(
        children: [
          if (_pdfPath != null)
            PDFView(
              enableSwipe: true,
              swipeHorizontal: true,
              autoSpacing: true,
              pageFling: true,
              pageSnap: true,
              fitPolicy: FitPolicy.BOTH,
              preventLinkNavigation: false,
              filePath: _pdfPath!,
              onViewCreated: (PDFViewController controller) {
                setState(() {
                  _isLoading = false;
                });
              },
            ),
          if (_isLoading)
            Center(
              child: const CircularProgressIndicator(color: primaryColor),
            ),
        ],
      ),
    );
  }
}
