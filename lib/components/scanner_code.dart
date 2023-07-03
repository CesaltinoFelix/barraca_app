import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter_beep/flutter_beep.dart';
import '../utils/constants.dart';

class ScannerCode extends StatefulWidget {
  TextEditingController? productbarcodeController_text =
      TextEditingController();
  Function()? onScanToggle;

  ScannerCode({
    required this.productbarcodeController_text,
    required this.onScanToggle,
    Key? key,
  }) : super(key: key);

  @override
  State<ScannerCode> createState() => _ScannerCodeState();
}

class _ScannerCodeState extends State<ScannerCode> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          flex: 5,
          child: QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
              borderColor: kPrimaryColor,
              borderWidth: 7,
              borderLength: 20,
              borderRadius: 10,
              cutOutSize: MediaQuery.of(context).size.width * 0.7,
            ),
          ),
        ),
      ],
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      FlutterBeep.beep();

      setState(() {
        result = scanData;
        widget.productbarcodeController_text!.text = result!.code.toString();
        widget.onScanToggle!();
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
