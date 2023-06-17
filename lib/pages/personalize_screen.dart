import 'dart:io';

import 'package:barraca_app/controllers/product_controller.dart';
import 'package:barraca_app/pages/home_screen.dart';
import 'package:barraca_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:uno/uno.dart';
import 'package:get/get.dart';

class PersonalizeScreen extends StatefulWidget {
  @override
  State<PersonalizeScreen> createState() => _PersonalizeScreenState();
}

class _PersonalizeScreenState extends State<PersonalizeScreen> {
  final _formData = <String, Object>{};
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final uno = Uno();
  File? _image;
  final _picker = ImagePicker();
  XFile? pickedImage;
  // Implementing the image picker
  Future<void> _openImagePicker() async {
    XFile? auxPickedImage;
    auxPickedImage = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      pickedImage = auxPickedImage;
    });

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage!.path);
      });
    }
  }

  Future<void> _submitForm() async {
    /*    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    } */
    _formKey.currentState?.save();

    setState(() => _isLoading = true);
    try {
      await ProductController().saveProduct(
          context: context, data: _formData, pickedImage: pickedImage);
      // Navigator.of(context).pop();
      Get.to(HomeScreen());
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "Personalizar Produto",
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
                          ElevatedButton(
                            onPressed: _submitForm,
                            style: ButtonStyle(
                              minimumSize: MaterialStateProperty.all(
                                  const Size(double.infinity, 48)),
                            ),
                            child: Text(
                              "Salvar Produto",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
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
