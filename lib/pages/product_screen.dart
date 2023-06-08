import 'package:barraca_app/controllers/product_controller.dart';
import 'package:barraca_app/helpers/api.dart';
import 'package:flutter/material.dart';
import 'package:barraca_app/pages/new_product_screen.dart';
import 'package:uno/uno.dart';

class ProductCreen extends StatefulWidget {
  const ProductCreen({Key? key}) : super(key: key);

  @override
  State<ProductCreen> createState() => _ProductCreenState();
}

class _ProductCreenState extends State<ProductCreen> {
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
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          title: const Text(
            "Lista de Productos",
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => NewProductScreen()));
              },
            )
          ],
          elevation: 1,
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: products != null
            ? ListView.builder(
                itemCount: products?.data.length,
                itemBuilder: (BuildContext context, int index) {
                  var product = products?.data[index];
                  return _productCard(product);
                })
            : Container());
  }

  Widget _productCard(product) {
    return Container(
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.all(12),
                  width: 150,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                          image: NetworkImage('${baseUrl}/${product['img']}'),
                          fit: BoxFit.cover)),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          product['name'],
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "\Kz${product['price']}",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  color: Theme.of(context).colorScheme.primary,
                  onPressed: () {
                    /*  Navigator.of(context).pushNamed(
                  AppRoutes.productForm,
                  arguments: product, 
                );*/
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  color: Theme.of(context).colorScheme.error,
                  onPressed: () {
                    showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Excluir Produto'),
                        content: const Text('Tem certeza?'),
                        actions: [
                          TextButton(
                            child: const Text('Não'),
                            onPressed: () => Navigator.of(ctx).pop(false),
                          ),
                          TextButton(
                            child: const Text('Sim'),
                            onPressed: () async {
                              Navigator.of(ctx).pop(true);
                              await ProductController()
                                  .productDelete(product['id']);
                              productList();
                            },
                          ),
                        ],
                      ),
                    ).then((value) async {
                      if (value ?? false) {
                        /*  try {
                      await Provider.of<ProductList>(
                        context,
                        listen: false,
                      ).removeProduct(product);
                    } on HttpException catch (error) {
                      msg.showSnackBar(
                        SnackBar(
                          content: Text(error.toString()),
                        ),
                      );
                    } */
                      }
                    });
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
