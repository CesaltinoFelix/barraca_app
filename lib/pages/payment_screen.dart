import 'dart:convert';

import 'package:barraca_app/pages/qr_code.dart';
import 'package:barraca_app/utils/constants.dart';
import 'package:barraca_app/components/default_app_bar.dart';
import 'package:barraca_app/components/defaultBackButton.dart';
import 'package:barraca_app/components/defaultButton.dart';
import 'package:barraca_app/components/headerLabel.dart';
import 'package:barraca_app/components/customer_modal.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:uno/uno.dart';
import 'package:barraca_app/helpers/gerar_codigo.dart';
import '../controllers/user_controller.dart';
import '../helpers/money_format.dart';

import '../components/success.dart';
import '../controllers/sale_controller.dart';

//=====================PACOTES DO PRINTER========================
import 'package:sunmi_printer_plus/column_maker.dart';
import 'package:sunmi_printer_plus/enums.dart';
import 'dart:async';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';
import 'package:sunmi_printer_plus/sunmi_style.dart';

class PaymentScreen extends StatefulWidget {
  PaymentScreen({Key? key}) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int value = 0;
  dynamic myOrder = {};
  bool showCustomerModal = false; // Variável para controlar a exibição do modal
  bool printBinded = false;
  int paperSize = 0;
  String serialNumber = "";
  String printerVersion = "";
  final userController = Get.find<UserController>();
  @override
  void initState() {
    super.initState();
    myOrder = Get.arguments;

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
      backgroundColor: kWhiteColor,
      appBar: DefaultAppBar(
        title: 'Pagamento',
        child: DefaultBackButton(),
      ),
      body: Column(
        children: [
          HeaderLabel(
            headerText: 'Escolha o método de pagamento!',
          ),
          Expanded(
            child: ListView.separated(
              itemCount: paymentLabels.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Container(
                    margin: const EdgeInsets.all(4),
                    width: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0,
                              3), // define o deslocamento da sombra horizontalmente e verticalmente
                        ),
                      ],
                      image: DecorationImage(
                        image: AssetImage(paymentImages[index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  title: Text(
                    paymentLabels[index],
                    style: TextStyle(color: kDarkColor),
                  ),
                  trailing: Radio(
                    activeColor: kPrimaryColor,
                    value: index,
                    groupValue: value,
                    onChanged: (i) => setState(() => value = i!),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return Divider();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Checkbox(
                  value: showCustomerModal,
                  activeColor: kPrimaryColor,
                  onChanged: (value) {
                    setState(() {
                      showCustomerModal = value!;
                    });
                  },
                ),
                Text('Imprimir factura'),
              ],
            ),
          ),
          DefaultButton(
            btnText: showCustomerModal ? 'Seguinte' : 'Concluir',
            onPressed: () async {
              Map<String, String>? customerData;
              if (showCustomerModal) {
                customerData = await showDialog<Map<String, String>?>(
                  context: context,
                  builder: (BuildContext context) => CustomerModal(),
                );
                if (customerData == null) {
                  return;
                }
              }

              final List<OrderItem> newOrderItems = [];
              final String codigoFatura = gerarCodigoFatura();
              String wallet;

              switch (value) {
                case 0:
                  wallet = 'unitel';
                  break;
                case 1:
                  wallet = 'guita';
                  break;
                /*  case 3:
                  wallet = 'cash';
                  break;
                case 4:
                  wallet = 'cartao';
                  break; */
                default:
                  wallet = 'unitel';
              }

              myOrder.asMap().forEach((index, order) async {
                order['wallet'] = wallet;
                final isLastElement = index == myOrder.length - 1;
                final orderItem = OrderItem(
                  descricao: order['name'],
                  quantidade: order['quantity'],
                  precoUnitario: double.parse(order['price'].toString()),
                  total: int.parse(order['quantity'].toString()) *
                      double.parse(order['price'].toString()),
                );
                newOrderItems.add(orderItem);
                // Processar o elemento atual
                SaleController().saveSales(data: order, context: context);

                // Verificar se é o último elemento
                if (isLastElement && showCustomerModal) {
                  // Último elemento, enviando dados para fatura
                  sendOrderItems(userController, newOrderItems, codigoFatura!,
                      customerData);
                }
              });

              // if (customerData != null) {
              if (wallet == 'cash' || wallet == 'cartao') {
                Get.off(Success());
              } else {
                Get.off(const QrCodePage(), arguments: codigoFatura);
              }
            },
          ),
        ],
      ),
    );
  }
}

String formatarDataAtual() {
  DateTime dataAtual = DateTime.now();
  DateFormat formato = DateFormat('dd/MM/yyyy');
  String dataFormatada = formato.format(dataAtual);
  return dataFormatada;
}

//Future<String?>
void sendOrderItems(userController, List<OrderItem> orderItems,
    String codigoFatura, Map<String, String>? customerData) async {
/*     List<OrderItem> orderItems, String codigoFatura) async {
  final uno = Uno();
  final jsonData = orderItems.map((item) => item.toJson()).toList();

  try {
    final response = await uno.post('${baseUrl}/sale-invoice/$codigoFatura',
        data: {'data': jsonData});
    return codigoFatura.toString();
  } catch (error) {
    print('Erro na requisição: $error');
    return null;
  } */
  double totalSale = 0;
  String currentDate = formatarDataAtual();
  await SunmiPrinter.initPrinter();

  await SunmiPrinter.startTransactionPrint(true);
  await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
  await SunmiPrinter.line();
  await SunmiPrinter.printText(
    userController.username.value.toString(),
    style: SunmiStyle(
        align: SunmiPrintAlign.CENTER, bold: true, fontSize: SunmiFontSize.MD),
  );
  await SunmiPrinter.printText(
    userController.adress.value.toString(),
    style: SunmiStyle(align: SunmiPrintAlign.CENTER),
  );
  await SunmiPrinter.printText(
    'NIF: ${userController.nif.value.toString()}',
    style: SunmiStyle(align: SunmiPrintAlign.CENTER),
  );

  await SunmiPrinter.printText(
    'Tel: ${userController.contact.value.toString()}',
    style: SunmiStyle(align: SunmiPrintAlign.CENTER),
  );
  await SunmiPrinter.line();
  await SunmiPrinter.printText('FR ${currentDate.replaceAll('/', '')}/23');
  await SunmiPrinter.line();
  await SunmiPrinter.printRow(cols: [
    ColumnMaker(text: 'Original', width: 15, align: SunmiPrintAlign.LEFT),
    ColumnMaker(text: currentDate, width: 15, align: SunmiPrintAlign.RIGHT),
  ]);
  await SunmiPrinter.lineWrap(1);
  await SunmiPrinter.printText('Nome: ${customerData!['name']}');
  await SunmiPrinter.printText('NIF: ${customerData['nif']}');

  await SunmiPrinter.line();

  await SunmiPrinter.printRow(cols: [
    ColumnMaker(text: 'DESC/QTD', width: 12, align: SunmiPrintAlign.LEFT),
    ColumnMaker(text: 'PREÇO', width: 9, align: SunmiPrintAlign.CENTER),
    ColumnMaker(text: 'TOTAL', width: 9, align: SunmiPrintAlign.RIGHT),
  ]);

  for (var orderItem in orderItems) {
    totalSale += orderItem.total;
    await SunmiPrinter.printText('${orderItem.descricao}');
    await SunmiPrinter.printRow(cols: [
      ColumnMaker(
          text: '${orderItem.quantidade}x',
          width: 4,
          align: SunmiPrintAlign.LEFT),
      ColumnMaker(
          text: moneyFormat(orderItem.precoUnitario) ?? '',
          width: 11,
          align: SunmiPrintAlign.CENTER),
      ColumnMaker(
          text: moneyFormat(orderItem.total) ?? '',
          width: 15,
          align: SunmiPrintAlign.RIGHT),
    ]);
  }

  await SunmiPrinter.line();
  await SunmiPrinter.printRow(cols: [
    ColumnMaker(
      text: 'TOTAL',
      width: 10,
      align: SunmiPrintAlign.LEFT,
    ),
    ColumnMaker(
        text: '${totalSale.toStringAsFixed(2)}AKZ',
        width: 20,
        align: SunmiPrintAlign.RIGHT),
  ]);

  await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
  await SunmiPrinter.line();
  await SunmiPrinter.bold();
  await SunmiPrinter.printText('Qrcode para pagamento',
      style: SunmiStyle(align: SunmiPrintAlign.CENTER));
  await SunmiPrinter.lineWrap(1);
  await SunmiPrinter.resetBold();
  await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
  await SunmiPrinter.printQRCode(
      '{"codigoOperador":"","nomeBeneficiario":"MFAL- PRESTACAO DE SERVICOSSULDA","valor":"500,00","codigoQRCode":"8D291F8159F2791840C00FBEDD26C3373734170C3F5AAFF66AF55F5A86982706970230C61821F8074B67A9562A3E2DF41A7C1E1E7ACC252D7B1A8C85CD49A71FC7A40BE02D3EE6402B5A4CED455E4E283080138AE46F807D43AC480F7407BA890DAB524DB33B927F23270C8023590A796EA4ED40F1975580A0AF57F7DBD2DFB8"}',
      size: 3);
  await SunmiPrinter.lineWrap(2);
  await SunmiPrinter.printText(
    'Processado por programa',
    style: SunmiStyle(align: SunmiPrintAlign.CENTER),
  );
  await SunmiPrinter.printText(
    'validado n. xxxx',
    style: SunmiStyle(align: SunmiPrintAlign.CENTER),
  );
  await SunmiPrinter.lineWrap(3);

  await SunmiPrinter.exitTransactionPrint(true);
}

class OrderItem {
  final String descricao;
  final int quantidade;
  final double precoUnitario;
  final double total;

  OrderItem({
    required this.descricao,
    required this.quantidade,
    required this.precoUnitario,
    required this.total,
  });

  Map<String, dynamic> toJson() {
    return {
      'descricao': descricao,
      'quantidade': quantidade,
      'precoUnitario': precoUnitario,
      'total': total,
    };
  }
}
