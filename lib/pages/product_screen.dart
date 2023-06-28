import 'package:barraca_app/controllers/product_controller.dart';
import 'package:barraca_app/helpers/api.dart';
import 'package:barraca_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:barraca_app/pages/product_form_screen.dart';
import 'package:get/get.dart';

import '../components/defaultBackButton.dart';
import '../components/default_app_bar.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}
// ...

class _ProductScreenState extends State<ProductScreen> {
  bool _isLoading = true;
  var products;

  // Fetch the product list
  Future<void> fetchProductList() async {
    var res = await ProductController().productList();
    setState(() {
      products = res;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchProductList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: DefaultAppBar(
        title: "Lista de Produtos",
        action: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => ProductFormScreen()),
              );
            },
          )
        ],
        child: DefaultBackButton(),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: kPrimaryColor),
            )
          : products != null
              ? ListView.builder(
                  itemCount: products?.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    var product = products?.data[index];

                    return Dismissible(
                      key: UniqueKey(),
                      direction: DismissDirection.horizontal,
                      background: Container(
                        color: Colors.red,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      secondaryBackground: Container(
                        color: Colors.green,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      child: _buildProductCard(product),
                      onDismissed: (direction) async {
                        if (direction == DismissDirection.startToEnd) {
                          // Excluir o produto
                          await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Excluir Produto'),
                              content: const Text('Tem certeza?'),
                              actions: [
                                TextButton(
                                  child: const Text('Não'),
                                  onPressed: () {
                                    Navigator.of(ctx).pop(false);
                                    setState(() {});
                                  },
                                ),
                                TextButton(
                                  child: const Text('Sim'),
                                  onPressed: () async {
                                    Navigator.of(ctx).pop(true);
                                    await ProductController()
                                        .productDelete(product['id']);
                                    fetchProductList();
                                  },
                                ),
                              ],
                            ),
                          ).then((value) {
                            if (value ?? false) {
                              // Produto excluído com sucesso
                            }
                          });
                        } else if (direction == DismissDirection.endToStart) {
                          Get.to(ProductFormScreen(), arguments: product)!
                              .then((value) {
                            setState(() {});
                          });
                        }
                      },
                    );
                  },
                )
              : Container(),
    );
  }

  // Build the product card widget
  Widget _buildProductCard(product) {
    return Container(
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.all(12),
                  width: 120,
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
                        const SizedBox(height: 10),
                        Text(
                          "Kz${product['price']}",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
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
            margin: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                /*  IconButton(
                  icon: const Icon(Icons.edit),
                  color: Theme.of(context).colorScheme.primary,
                  onPressed: () {
                    setState(() {
                      isEditing = true; // Define que está em modo de edição
                    });
                    Get.to(ProductFormScreen(), arguments: product)!
                        .then((value) {
                      setState(() {
                        isEditing = false; // Sai do modo de edição
                      });
                    });
                  },
                ),*/
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
                              fetchProductList();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ...
