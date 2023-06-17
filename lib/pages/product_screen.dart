import 'package:barraca_app/controllers/product_controller.dart';
import 'package:barraca_app/helpers/api.dart';
import 'package:barraca_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:barraca_app/pages/product_form_screen.dart';
import 'package:get/get.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

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
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "Lista de Produtos",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => ProductFormScreen()),
              );
            },
          )
        ],
        elevation: 1,
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: primaryColor),
            )
          : products != null
              ? ListView.builder(
                  itemCount: products?.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    var product = products?.data[index];
                    return _buildProductCard(product);
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
                IconButton(
                  icon: const Icon(Icons.edit),
                  color: Theme.of(context).colorScheme.primary,
                  onPressed: () {
                    Get.to(ProductFormScreen(), arguments: product);
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
                              fetchProductList();
                            },
                          ),
                        ],
                      ),
                    ).then((value) async {
                      if (value ?? false) {
                        // Perform the delete operation
                      }
                    });
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
