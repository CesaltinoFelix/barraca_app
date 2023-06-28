import 'package:barraca_app/controllers/product_controller.dart';
import 'package:barraca_app/helpers/snackbar_menssage.dart';
import 'package:barraca_app/pages/payment_screen.dart';
import 'package:barraca_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:uno/uno.dart';

import '../components/defaultBackButton.dart';
import '../components/default_app_bar.dart';
import '../helpers/api.dart';

class SellScreen extends StatefulWidget {
  const SellScreen({Key? key}) : super(key: key);

  @override
  State<SellScreen> createState() => SelltCreenState();
}

class SelltCreenState extends State<SellScreen> {
  final List<dynamic> myOrder = [];
  final uno = Uno();
  List<dynamic>? Allproducts;
  List<dynamic>? products;
  bool _isLoading = true;
  final TextEditingController searchController = TextEditingController();

  void productList() async {
    var res = await ProductController().productList();
    if (res.data is List<dynamic>) {
      setState(() {
        Allproducts = res.data;
        Allproducts!.sort(
            (a, b) => a['name'].toString().compareTo(b['name'].toString()));
        products = Allproducts;
        _isLoading = false;
      });
    }
  }

  void searchProduct(String? searchQuery) {
    setState(() {
      if (searchQuery != null && searchQuery.isNotEmpty) {
        products = Allproducts!.where((product) {
          String productName = product['name'].toString().toLowerCase();
          return productName.contains(searchQuery.toLowerCase());
        }).toList();
      } else {
        products = Allproducts;
      }
    });
  }

  @override
  void initState() {
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
      backgroundColor: kWhiteColor,
      appBar: const DefaultAppBar(
        title: 'Vender',
        child: DefaultBackButton(),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: kPrimaryColor),
            )
          : products != null
              ? Column(
                  children: [
                    search(
                      onChanged: (value) {
                        searchProduct(value);
                      },
                      searchController: searchController,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            height: 570,
                            width: double.infinity,
                            child: ListView.separated(
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                if (index < products!.length) {
                                  Map<String, dynamic> product =
                                      products![index];
                                  return _buildCart(product, loadUi);
                                }
                                return Container();
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                                      const Divider(
                                thickness: 1.0,
                                color: Colors.grey,
                              ),
                              itemCount: products!.length,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Produtos Selecionados",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      myOrder.length.toString(),
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Valor Total",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "\Kz${totalPrice.toStringAsFixed(2)}",
                                      style: TextStyle(
                                        color: Colors.green.shade700,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : Container(),
      bottomSheet: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: ElevatedButton(
            onPressed: () async {
              if (myOrder.isEmpty) {
                const SnackbarMenssage().nasckProductInfo(context);
              } else {
                Get.to(PaymentScreen(), arguments: myOrder);
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
          ),
        ),
      ),
    );
  }

  Widget _buildCart(Map<String, dynamic> product, Function() loadUi) {
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
                      fit: BoxFit.cover,
                    ),
                  ),
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
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Container(
                          width: 120,
                          decoration: BoxDecoration(
                            border: Border.all(width: 0.8, color: Colors.grey),
                            borderRadius: BorderRadius.circular(12),
                          ),
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
                                    fontWeight: FontWeight.w600,
                                  ),
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
                                  fontWeight: FontWeight.bold,
                                ),
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
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.all(12),
            child: Column(
              children: [
                CheckboxExample(
                  product: product,
                  myOrder: myOrder,
                  loadUi: loadUi,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "\Kz${product['price']}",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CheckboxExample extends StatefulWidget {
  final Map<String, dynamic> product;
  final List<dynamic> myOrder;
  final Function() loadUi;

  const CheckboxExample({
    required this.product,
    required this.myOrder,
    required this.loadUi,
    Key? key,
  }) : super(key: key);

  @override
  State<CheckboxExample> createState() => _CheckboxExampleState();
}

class _CheckboxExampleState extends State<CheckboxExample> {
  bool isChecked = false;

  @override
  void initState() {
    super.initState();
    isChecked =
        widget.myOrder.any((order) => order['id'] == widget.product['id']);
  }

  @override
  void didUpdateWidget(CheckboxExample oldWidget) {
    super.didUpdateWidget(oldWidget);
    isChecked =
        widget.myOrder.any((order) => order['id'] == widget.product['id']);
  }

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      return Colors.orange.shade300;
    }

    if (!widget.myOrder.any((order) => order['id'] == widget.product['id'])) {
      isChecked = false;
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

Widget search({
  required ValueChanged<String> onChanged,
  required TextEditingController searchController,
}) {
  return Padding(
    padding: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
    child: TextField(
      controller: searchController,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 15.0),
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 15.0, right: 10.0),
          child: SvgPicture.asset(
            'assets/icons/search.svg',
            color: kPrimaryColor,
            height: 20.0,
          ),
        ),
        suffixIcon: GestureDetector(
          onTap: () {
            searchController.clear();
            onChanged('');
          },
          child: const Icon(
            Icons.clear,
            color: Colors.grey,
          ),
        ),
        hintText: 'Pesquisar produtos',
        hintStyle: TextStyle(color: Colors.grey.shade500),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey.shade100,
      ),
      style: TextStyle(fontSize: 16.0),
      onChanged: onChanged,
    ),
  );
}
