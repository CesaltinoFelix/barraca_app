import 'dart:typed_data';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sunmi_printer_plus/column_maker.dart';
import 'package:sunmi_printer_plus/enums.dart';
import 'dart:async';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';
import 'package:sunmi_printer_plus/sunmi_style.dart';

/* void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeRight, DeviceOrientation.landscapeRight]);
  runApp(const PrintSettingScreen());
}
 */
class PrintSettingScreen extends StatefulWidget {
  const PrintSettingScreen({Key? key}) : super(key: key);

  @override
  _PrintSettingScreenState createState() => _PrintSettingScreenState();
}

class _PrintSettingScreenState extends State<PrintSettingScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Sunmi Printer',
        theme: ThemeData(
          primaryColor: Colors.black,
        ),
        debugShowCheckedModeBanner: false,
        home: const Home());
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool printBinded = false;
  int paperSize = 0;
  String serialNumber = "";
  String printerVersion = "";
  @override
  void initState() {
    super.initState();

    _bindingPrinter().then((bool? isBind) async {
      SunmiPrinter.paperSize().then((int size) {
        setState(() {
          paperSize = size;
        });
      });

      SunmiPrinter.printerVersion().then((String version) {
        setState(() {
          printerVersion = version;
        });
      });

      SunmiPrinter.serialNumber().then((String serial) {
        setState(() {
          serialNumber = serial;
        });
      });

      setState(() {
        printBinded = isBind!;
      });
    });
  }

  /// must binding ur printer at first init in app
  Future<bool?> _bindingPrinter() async {
    final bool? result = await SunmiPrinter.bindingPrinter();
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Sunmi printer Example'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                ),
                child: Text("Print binded: " + printBinded.toString()),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Text("Paper size: " + paperSize.toString()),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Text("Serial number: " + serialNumber),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Text("Printer version: " + printerVersion),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                          onPressed: () async {
                            await SunmiPrinter.initPrinter();

                            await SunmiPrinter.startTransactionPrint(true);
                            await SunmiPrinter.setAlignment(
                                SunmiPrintAlign.CENTER);
                            await SunmiPrinter.line();
                            await SunmiPrinter.printText(
                              'Barraca LDA',
                              style: SunmiStyle(
                                  align: SunmiPrintAlign.CENTER,
                                  bold: true,
                                  fontSize: SunmiFontSize.MD),
                            );
                            await SunmiPrinter.printText(
                              'Pizzaria, Golf 2 - Kilamba Kiaxi',
                              style: SunmiStyle(align: SunmiPrintAlign.CENTER),
                            );
                            await SunmiPrinter.printText(
                              'NIF: 007242560LA046',
                              style: SunmiStyle(align: SunmiPrintAlign.CENTER),
                            );
                            await SunmiPrinter.printText(
                              'Tel: 922 823 242',
                              style: SunmiStyle(align: SunmiPrintAlign.CENTER),
                            );
                            await SunmiPrinter.line();
                            await SunmiPrinter.printText('FR 202306/23');
                            await SunmiPrinter.line();
                            await SunmiPrinter.printRow(cols: [
                              ColumnMaker(
                                  text: 'Original',
                                  width: 15,
                                  align: SunmiPrintAlign.LEFT),
                              ColumnMaker(
                                  text: '02/07/2023',
                                  width: 15,
                                  align: SunmiPrintAlign.RIGHT),
                            ]);
                            await SunmiPrinter.line();

                            await SunmiPrinter.printRow(cols: [
                              ColumnMaker(
                                  text: 'DESC',
                                  width: 12,
                                  align: SunmiPrintAlign.LEFT),
                              ColumnMaker(
                                  text: 'QTD',
                                  width: 6,
                                  align: SunmiPrintAlign.CENTER),
                              ColumnMaker(
                                  text: 'UN',
                                  width: 6,
                                  align: SunmiPrintAlign.RIGHT),
                              ColumnMaker(
                                  text: 'TOT',
                                  width: 6,
                                  align: SunmiPrintAlign.RIGHT),
                            ]);

                            await SunmiPrinter.printRow(cols: [
                              ColumnMaker(
                                  text: 'Soda',
                                  width: 12,
                                  align: SunmiPrintAlign.LEFT),
                              ColumnMaker(
                                  text: '1x',
                                  width: 6,
                                  align: SunmiPrintAlign.CENTER),
                              ColumnMaker(
                                  text: '1.99',
                                  width: 6,
                                  align: SunmiPrintAlign.RIGHT),
                              ColumnMaker(
                                  text: '1.99',
                                  width: 6,
                                  align: SunmiPrintAlign.RIGHT),
                            ]);

                            await SunmiPrinter.line();
                            await SunmiPrinter.printRow(cols: [
                              ColumnMaker(
                                text: 'TOTAL',
                                width: 10,
                                align: SunmiPrintAlign.LEFT,
                              ),
                              ColumnMaker(
                                  text: '23.569,45Kz',
                                  width: 20,
                                  align: SunmiPrintAlign.RIGHT),
                            ]);

                            await SunmiPrinter.setAlignment(
                                SunmiPrintAlign.CENTER);
                            await SunmiPrinter.line();
                            await SunmiPrinter.bold();
                            await SunmiPrinter.printText(
                                'Qrcode para pagamento');
                            await SunmiPrinter.resetBold();
                            await SunmiPrinter.printQRCode(
                                'https://www.linkedin.com/company/mfal-systems?originalSubdomain=ao',
                                size: 2);
                            await SunmiPrinter.lineWrap(2);
                            await SunmiPrinter.exitTransactionPrint(true);
                          },
                          child: const Text('Gerar Recibo')),
                    ]),
              ),
            ],
          ),
        ));
  }
}
