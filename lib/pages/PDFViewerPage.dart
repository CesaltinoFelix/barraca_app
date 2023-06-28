import 'package:barraca_app/helpers/api.dart';
import 'package:barraca_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
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
  String codigoFatura = '';

  @override
  void initState() {
    super.initState();
    setState(() {
      codigoFatura = Get?.arguments;
    });

    if (codigoFatura != '') {
      downloadPDF();
    }
  }

  Future<void> downloadPDF() async {
    final url = '$baseUrl/fatura_$codigoFatura.pdf';
    print(url);
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
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        title: Text('Fatura', style: TextStyle(color: Colors.black)),
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
              child: const CircularProgressIndicator(color: kPrimaryColor),
            ),
        ],
      ),
    );
  }
}
