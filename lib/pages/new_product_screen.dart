import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:uno/uno.dart';
import 'package:barraca_app/animation/FadeAnimation.dart';

class NewProductScreen extends StatefulWidget {
  @override
  State<NewProductScreen> createState() => _NewProductScreenState();
}

class _NewProductScreenState extends State<NewProductScreen> {
  final _formData = <String, Object>{};
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final uno = Uno();
  File? _image;
  final _picker = ImagePicker();

  // Implementing the image picker
  Future<void> _openImagePicker() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
        print(pickedImage);
      });
      print(pickedImage);
    }
  }

  void sms() {
// Make a request for a user with a given ID
    uno.get('http://192.168.100.53:3000/products').then((response) {
      print(response.data); // it's a Map<String, dynamic>.
    }).catchError((error) {
      print(error); // It's a UnoError.
    });
  }

  Future<void> _submitForm() async {
    /*    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    } */

    _formKey.currentState?.save();

    // setState(() => _isLoading = true);
    try {
      await saveProduct(_formData);

      Navigator.of(context).pop();
    } catch (error) {
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Ocorreu um erro!'),
          content: const Text('Ocorreu um erro para salvar o produto.'),
          actions: [
            TextButton(
              child: const Text('Ok'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void>? saveProduct(Map<String, Object> data) async {
    final product = {
      'id': '',
      'name': data['name'].toString(),
      'description': data['description'].toString(),
      'price': data['price'],
      'img': data['img'].toString(),
    };
    try {
      await uno
          .post('http://192.168.100.53:3000/product', data: product)
          .then((response) {
        print(response.data); // it's a Map<String, dynamic>.
      }).catchError((error) {
        print(error); // It's a UnoError.
      });
    } catch (e) {
      print('Error fetching product data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "Novo Producto",
          style: TextStyle(color: Colors.black),
        ),
        elevation: 1,
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                          height: MediaQuery.of(context).size.height / 3,
                          child: Lottie.asset('assets/images/shopping.json')),
                      Column(
                        children: <Widget>[
                          makeInput(
                              label: "Nome",
                              onSaved: (name) =>
                                  _formData['name'] = name ?? ''),
                          makeInput(
                              label: "Preço",
                              obscureText: false,
                              onSaved: (price) =>
                                  _formData['price'] = price ?? ''),
                          makeInput(
                              label: "Descrição",
                              obscureText: false,
                              onSaved: (description) =>
                                  _formData['description'] = description ?? ''),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Imagem',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black87),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 4, color: Colors.white),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8)),
                                  ),
                                  child: GestureDetector(
                                      child: makeInputImg(),
                                      onTap: _openImagePicker),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                border: Border(
                                  bottom: BorderSide(color: Colors.black),
                                  top: BorderSide(color: Colors.black),
                                  left: BorderSide(color: Colors.black),
                                  right: BorderSide(color: Colors.black),
                                )),
                            child: MaterialButton(
                              minWidth: double.infinity,
                              height: 60,
                              onPressed: _submitForm,
                              color: Colors.orange.shade300,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50)),
                              child: Text(
                                "Salvar Producto",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 18),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget makeInput({label, obscureText = false, onSaved}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
        ),
        SizedBox(
          height: 5,
        ),
        TextFormField(
          initialValue: '1',
          onSaved: onSaved,
          obscureText: obscureText,
          cursorColor: Colors.orange.shade300,
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.orange.shade300)),
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400)),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400)),
          ),
        ),
        SizedBox(
          height: 30,
        ),
      ],
    );
  }

  Widget makeInputImg() {
    return _image == null
        ? Image.asset(
            height: 100,
            width: 100,
            fit: BoxFit.fill,
            "assets/images/image_placeholder.jpg",
          )
        : Image.file(
            height: 100,
            width: 100,
            fit: BoxFit.cover,
            _image!,
          );
  }
}
