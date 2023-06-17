import 'package:barraca_app/controllers/product_controller.dart';
import 'package:barraca_app/helpers/snackbar_menssage.dart';
import 'package:barraca_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:barraca_app/pages/qr_code.dart';
import 'package:uno/uno.dart';
import 'package:barraca_app/helpers/api.dart';
import 'package:barraca_app/controllers/sale_controller.dart';
import 'package:barraca_app/controllers/user_controller.dart';
import 'package:get/get.dart';

class SellScreen extends StatefulWidget {
  const SellScreen({Key? key}) : super(key: key);

  @override
  State<SellScreen> createState() => SelltCreenState();
}

class SelltCreenState extends State<SellScreen> {
  List<dynamic> myOrder = [];
  final uno = Uno();
  List<dynamic>? products;
  bool _isLoading = true;
  productList() async {
    var res = await ProductController().productList();
    if (res.data is List<dynamic>) {
      setState(() {
        products = res.data;
        _isLoading = false;
      });
    }
  }

  @override
  initState() {
    super.initState();
    try {
      productList();
    } catch (e) {}
  }

  void loadUi() {
    setState(() {
      products;
    });
  }

  @override
  Widget build(BuildContext context) {
    double totalPrice = 0.0;
    myOrder.forEach((order) {
      totalPrice += order['price'] * order['quantity'];
    });

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "Vender",
          style: TextStyle(color: Colors.black),
        ),
        elevation: 1,
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: primaryColor),
            )
          : products != null
              ? Column(
                  children: [
                    Container(
                      height: 600,
                      width: double.infinity,
                      child: ListView.separated(
                          itemBuilder: (BuildContext context, int index) {
                            if (index < products!.length) {
                              Map<String, dynamic> product = products![index];
                              return _buildCart(product, myOrder, loadUi);
                            }
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(thickness: 1.0, color: Colors.grey),
                          itemCount: products!.length + 1),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Produtos Selecionados",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                myOrder?.length != null
                                    ? "${myOrder.length}"
                                    : "0",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Valor Total",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "\Kz${totalPrice.toStringAsFixed(2)}",
                                style: TextStyle(
                                    color: Colors.green.shade700,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(height: 50)
                        ],
                      ),
                    )
                  ],
                )
              : Container(),
      bottomSheet: Padding(
          padding: const EdgeInsets.all(10),
          child: ElevatedButton(
            onPressed: () async {
              if (myOrder.isEmpty) {
                const SnackbarMenssage().nasckProductInfo(context);
              } else {
                myOrder.forEach((order) {
                  SaleController().saveSales(data: order, context: context);
                });
                const SnackbarMenssage().nasckSalesSuccess(context);
                Get.off(QrCodePage());
              }
            },
            style: ButtonStyle(
              minimumSize:
                  MaterialStateProperty.all(const Size(double.infinity, 48)),
            ),
            child: const Text(
              'Concluir',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          )),
    );
  }

//Criando os widgets de compras
  Widget _buildCart(Map<String, dynamic> product, myOrder, loadUi) {
    return Container(
      height: 140,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.all(12),
                  width: 150,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                          image: NetworkImage('${baseUrl}/${product['img']}'),
                          fit: BoxFit.cover)),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          product['name'],
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 15),
                        Container(
                          width: 120,
                          decoration: BoxDecoration(
                              border:
                                  Border.all(width: 0.8, color: Colors.grey),
                              borderRadius: BorderRadius.circular(12)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: product['quantity'] == null ||
                                        product['quantity'] == 0 ||
                                        product['quantity'] == 1
                                    ? null
                                    : () {
                                        setState(() {
                                          product['quantity']--;
                                        });
                                      },
                                child: Text(
                                  "-",
                                  style: TextStyle(
                                      color: Colors.orange.shade300,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              const SizedBox(width: 20),
                              Text(
                                product['quantity'] == null
                                    ? '0'
                                    : product['quantity'].toString(),
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 20),
                              GestureDetector(
                                onTap: product['quantity'] == null ||
                                        product['quantity'] == 0
                                    ? null
                                    : () {
                                        setState(() {
                                          product['quantity']++;
                                        });
                                      },
                                child: Text(
                                  "+",
                                  style: TextStyle(
                                      color: Colors.orange.shade300,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.all(12),
            child: Column(
              children: [
                CheckboxExample(
                    product: product, myOrder: myOrder, loadUi: loadUi),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "\Kz${product['price']}",
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                /* TextField(
                  controller: textEditingController,
                  decoration: InputDecoration(
                    hintText: 'Enter text',
                  ),
                ), */
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CheckboxExample extends StatefulWidget {
  var product;
  var myOrder;
  var loadUi;
  CheckboxExample({this.product, this.myOrder, this.loadUi, super.key});
  @override
  State<CheckboxExample> createState() => _CheckboxExampleState();
}

class _CheckboxExampleState extends State<CheckboxExample> {
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      return Colors.orange.shade300;
    }

    return Checkbox(
      checkColor: Colors.white,
      fillColor: MaterialStateProperty.resolveWith(getColor),
      value: isChecked,
      onChanged: (bool? value) {
        setState(() {
          isChecked = value!;
          if (isChecked) {
            var productOrder = widget.product;
            productOrder['quantity'] = 1;
            setState(() {
              widget.myOrder.add(productOrder);
              widget.product['quantity'] = 1;
            });
            widget.loadUi();
          } else {
            int index = widget.myOrder
                .indexWhere((p) => p['id'] == widget.product['id']);

            if (index >= 0) {
              setState(() {
                widget.myOrder
                    .removeWhere((p) => p['id'] == widget.product['id']);
                widget.product['quantity'] = 0;
              });
              widget.loadUi();
            }
          }
        });
      },
    );
  }
}

bool? search(order, id) {
  print(id);
  int index = order.indexWhere((p) => p['id'] == id);

  return index >= 0 ? true : false;
}
