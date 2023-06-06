import 'package:barraca_app/controllers/product_controller.dart';
import 'package:barraca_app/data/data.dart';
import 'package:barraca_app/models/order.dart';
import 'package:flutter/material.dart';
import 'package:barraca_app/pages/qr_code.dart';
import 'package:uno/uno.dart';

class SellCreen extends StatefulWidget {
  const SellCreen({Key? key}) : super(key: key);

  @override
  State<SellCreen> createState() => SelltCreenState();
}

class SelltCreenState extends State<SellCreen> {
  List<Map<String, dynamic>> myOrder = [];

  final uno = Uno();
  var products;
  productList() async {
    var res = await ProductController().productList();
    setState(() {
      products = res;
    });
  }

  // ProductController? c = Get.put(ProductController());
  @override
  initState() {
    productList();
    super.initState();
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
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          "Vender",
          style: TextStyle(color: Colors.black),
        ),
        elevation: 1,
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            if (index < currentUser.cart.length) {
              Order order = currentUser.cart[index];
              return _buildCart(order, myOrder);
            }
            return Padding(
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
                        "9",
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
              Divider(thickness: 1.0, color: Colors.grey),
          itemCount: currentUser.cart.length + 1),
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
                boxShadow: [
                  BoxShadow(
                      blurRadius: 6,
                      color: Colors.black26,
                      offset: Offset(0, -1))
                ]),
            child: Center(
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

  Widget _buildCart(Order order, myOrder) {
    int quantity = 0;
    print('celson 01');
    return Container(
      height: 140,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      print(quantity);
                      order.quantity++;
                      myOrder.add({'name': 'celson', 'age': 23});
                    });
                    print(myOrder);
                  },
                  child: Container(
                    margin: EdgeInsets.all(12),
                    width: 150,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                            image: AssetImage(order.food.imageUrl),
                            fit: BoxFit.cover)),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          order.food.name,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text(
                          order.restaurant.name,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 10),
                        Container(
                          width: 100,
                          decoration: BoxDecoration(
                              border:
                                  Border.all(width: 0.8, color: Colors.grey),
                              borderRadius: BorderRadius.circular(12)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    quantity--;
                                  });

                                  print('quantity.toString()');
                                },
                                child: Text(
                                  "-",
                                  style: TextStyle(
                                      color: Colors.orange.shade300,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              SizedBox(width: 20),
                              Text(
                                // quantity.toString()
                                order.quantity.toString(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(width: 20),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    quantity++;
                                  });
                                },
                                child: Text(
                                  "+",
                                  style: TextStyle(
                                      color: Colors.orange.shade300,
                                      fontSize: 18,
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
            margin: EdgeInsets.all(12),
            child: Column(
              children: [
                CheckboxExample(),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "\Kz${order.food.price * order.quantity}",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CheckboxExample extends StatefulWidget {
  const CheckboxExample({super.key});
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
        });
      },
    );
  }
}
