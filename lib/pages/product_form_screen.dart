import 'dart:io';

import 'package:barraca_app/controllers/product_controller.dart';
import 'package:barraca_app/helpers/snackbar_menssage.dart';
import 'package:barraca_app/pages/home_screen.dart';
import 'package:barraca_app/components/photo_modal.dart';
import 'package:barraca_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:uno/uno.dart';
import 'package:get/get.dart';

class ProductFormScreen extends StatefulWidget {
  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formData = <String, Object>{};
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final uno = Uno();
  File? _image;
  final _picker = ImagePicker();
  XFile? pickedImage;
  dynamic product = {};

  // Função para abrir o seletor de imagem
  Future<void> _openImagePicker(String type) async {
    XFile? auxPickedImage;
    if (type == 'gallery') {
      auxPickedImage = await _picker.pickImage(source: ImageSource.gallery);
    } else if (type == 'camera') {
      auxPickedImage = await _picker.pickImage(source: ImageSource.camera);
    }
    setState(() {
      pickedImage = auxPickedImage;
    });

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage!.path);
      });
    }
  }

  // Função para submeter o formulário
  Future<void> _submitForm() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }
    _formKey.currentState?.save();

    setState(() => _isLoading = true);
    if (product?['id'] != null) {
      await ProductController().updateProduct(
          context: context,
          id: product?['id'],
          data: _formData,
          pickedImage: pickedImage);
      SnackbarMenssage().nasckProductUpdateSuccess(context);
      Get.to(HomeScreen());
    } else {
      try {
        await ProductController().saveProduct(
            context: context, data: _formData, pickedImage: pickedImage);
        SnackbarMenssage().nasckProductSuccess(context);
        Get.to(HomeScreen());
      } catch (error) {
        await showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Erro'),
            content: const Text('Ocorreu um erro ao salvar o produto.'),
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
  }

  @override
  void initState() {
    setState(() {
      product = Get?.arguments;
    });
    super.initState();
  }

  // Função de validação para o campo 'Nome'
  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Campo obrigatório';
    }
    return null;
  }

  // Função de validação para o campo 'Preço'
  String? _validatePrice(String? value) {
    if (value == null || value.isEmpty) {
      return 'Campo obrigatório';
    }
    if (value == '0') {
      return 'O valor deve ser maior que 0 Kz';
    }
    if (!RegExp(r'^\d+(\.\d+)?$').hasMatch(value)) {
      return 'Apenas números e ponto são permitidos';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        title: product == null
            ? const Text(
                "Novo Produto",
                style: TextStyle(color: Colors.black),
              )
            : const Text(
                "Atualizar Produto",
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
                              value: product?['name'],
                              label: "Nome",
                              onSaved: (name) => _formData['name'] = name ?? '',
                              validator: _validateName),
                          makeInput(
                              value: product?['price'],
                              label: "Preço",
                              obscureText: false,
                              onSaved: (price) =>
                                  _formData['price'] = price ?? '',
                              validator: _validatePrice),
                          makeInput(
                              value: product?['description'],
                              label: "Descrição",
                              obscureText: false,
                              onSaved: (description) =>
                                  _formData['description'] = description ?? '',
                              validator: null),
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
                                    onTap: () async {
                                      String? result = await showDialog<String>(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            PhotoModal(),
                                      );
                                      result != null
                                          ? _openImagePicker(result!)
                                          : null;
                                    },
                                  ),
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

  // Widget para criar o campo de entrada de texto
  Widget makeInput({
    value,
    label,
    obscureText = false,
    onSaved,
    validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Colors.black87,
          ),
        ),
        SizedBox(
          height: 5,
        ),
        TextFormField(
          initialValue: value != null ? value.toString() : '',
          validator: validator,
          onSaved: onSaved,
          obscureText: obscureText,
          cursorColor: Colors.orange.shade300,
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.orange.shade300),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
          ),
        ),
        SizedBox(
          height: 30,
        ),
      ],
    );
  }

  // Widget para exibir a imagem selecionada ou um espaço reservado
  Widget makeInputImg() {
    return _image == null
        ? Image.asset(
            'assets/images/image_placeholder.jpg',
            height: 100,
            width: 100,
            fit: BoxFit.fill,
          )
        : Image.file(
            _image!,
            height: 100,
            width: 100,
            fit: BoxFit.cover,
          );
  }
}
