import 'package:barraca_app/controllers/product_controller.dart';
import 'package:barraca_app/data/data.dart';
import 'package:barraca_app/models/order.dart';
import 'package:flutter/material.dart';
import 'package:barraca_app/pages/qr_code.dart';
import 'package:uno/uno.dart';
import 'package:barraca_app/helpers/api.dart';

class SellCreen extends StatefulWidget {
  const SellCreen({Key? key}) : super(key: key);

  @override
  State<SellCreen> createState() => SelltCreenState();
}

class SelltCreenState extends State<SellCreen> {
  List<dynamic> myOrder = [];

  final uno = Uno();
  List<dynamic>? products;
  productList() async {
    var res = await ProductController().productList();
    if (res.data is List<dynamic>) {
      setState(() {
        products = res.data;
      });
    }
  }

  @override
  initState() {
    productList();
    super.initState();
  }

  void loadUi() {
    setState(() {
      products;
    });
  }

  @override
  Widget build(BuildContext context) {
    double totalPrice = 0.0;
    currentUser.cart.forEach((Order order) {
      totalPrice += order.food.price * order.quantity;
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
      body: products != null
          ? ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                if (index < products!.length) {
                  Map<String, dynamic> product = products![index];
                  return _buildCart(product, myOrder, loadUi);
                }
                return Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          /* Text(
                            "Produtos Selecionados",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            myOrder?.length != null ? "${myOrder.length}" : "0",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ) */
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
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
                      SizedBox(height: 80)
                    ],
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(thickness: 1.0, color: Colors.grey),
              itemCount: products!.length + 1)
          : Container(),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(10),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => QrCodePage()));
          },
          child: Container(
            height: 60,
            decoration: BoxDecoration(
                color: Colors.orange.shade300,
                borderRadius: BorderRadius.circular(50),
                boxShadow: const [
                  BoxShadow(
                      blurRadius: 6,
                      color: Colors.black26,
                      offset: Offset(0, -1))
                ]),
            child: const Center(
              child: Text(
                "CHECKOUT",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
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
                        const SizedBox(height: 10),
                        Text(
                          product['description'],
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 10),
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
