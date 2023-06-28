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
import 'package:uno/uno.dart';
import 'package:barraca_app/helpers/gerar_codigo.dart';

import '../components/success.dart';
import '../controllers/sale_controller.dart';
import '../helpers/api.dart';

class PaymentScreen extends StatefulWidget {
  PaymentScreen({Key? key}) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int value = 0;
  dynamic myOrder = {};
  bool showCustomerModal = false; // Variável para controlar a exibição do modal

  @override
  void initState() {
    super.initState();
    myOrder = Get.arguments;
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
                  leading: Radio(
                    activeColor: kPrimaryColor,
                    value: index,
                    groupValue: value,
                    onChanged: (i) => setState(() => value = i!),
                  ),
                  title: Text(
                    paymentLabels[index],
                    style: TextStyle(color: kDarkColor),
                  ),
                  trailing: Icon(paymentIcons[index], color: kPrimaryColor),
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
                case 3:
                  wallet = 'cash';
                  break;
                case 4:
                  wallet = 'cartao';
                  break;
                default:
                  wallet = 'cash';
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
                if (isLastElement) {
                  // Último elemento, enviando dados para fatura
                  await sendOrderItems(newOrderItems, codigoFatura!);
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

Future<String?> sendOrderItems(
    List<OrderItem> orderItems, String codigoFatura) async {
  final uno = Uno();
  final jsonData = orderItems.map((item) => item.toJson()).toList();

  try {
    final response = await uno.post('${baseUrl}/sale-invoice/$codigoFatura',
        data: {'data': jsonData});
    return codigoFatura.toString();
  } catch (error) {
    print('Erro na requisição: $error');
    return null;
  }
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
