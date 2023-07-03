import 'dart:convert';

import 'package:barraca_app/controllers/user_controller.dart';
import 'package:barraca_app/helpers/api.dart';
import 'package:barraca_app/helpers/snackbar_menssage.dart';
import 'package:barraca_app/pages/home_screen.dart';
import 'package:barraca_app/controllers/user_controller.dart';
import 'package:barraca_app/pages/login.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key});

  @override
  State<EditProfilePage> createState() => EditProfilePageState();
}

class EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _obscureText = true.obs;
  final userController = Get.find<UserController>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  final _nameController = TextEditingController();
  final _nifController = TextEditingController();
  final _contactController = TextEditingController();
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    _nameController.dispose();
    _nifController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          "Editar Perfil",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFormField(
                        value: userController.email.value.toString(),
                        label: 'Nome',
                        controller: _nameController,
                        validator: _validateName,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 24),
                      _buildFormField(
                        label: 'NIF/BI',
                        controller: _nifController,
                        validator: _validateNif,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 24),
                      _buildFormField(
                        label: 'E-mail',
                        controller: _emailController,
                        validator: _emailValidator,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 24),
                      _buildFormField(
                        label: 'Telemóvel',
                        controller: _contactController,
                        validator: _validateContact,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        maxLength: 9,
                      ),
                      const SizedBox(height: 24),
                      _buildFormField(
                        label: 'Senha',
                        controller: _passwordController,
                        validator: _passwordValidator,
                        obscureText: _obscureText.value,
                      ),
                      const SizedBox(height: 24),
                      _buildFormField(
                        label: 'Confirmar Senha',
                        controller: _passwordConfirmController,
                        validator: _passwordValidator,
                        obscureText: _obscureText.value,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _editPtofile,
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(
                        const Size(double.infinity, 48)),
                  ),
                  child: const Text(
                    'Salvar Alterações',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    String? value = '',
    required TextEditingController controller,
    required String? Function(String?)? validator,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    int? maxLength,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    print(value);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 12),
        TextFormField(
          // initialValue: value != '' ? value : '',
          controller: controller,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          maxLength: maxLength,
          obscureText: obscureText,
          validator: validator,
        ),
      ],
    );
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Digite seu nome';
    }
    return null;
  }

  String? _validateNif(String? value) {
    if (value == null || value.isEmpty) {
      return 'Digite seu NIF ou número do BI';
    }
    return null;
  }

  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Digite seu e-mail';
    }
    if (!GetUtils.isEmail(value)) {
      return 'E-mail inválido';
    }
    return null;
  }

  String? _validateContact(String? value) {
    if (value == null || value.isEmpty) {
      return 'Digite seu número de telemóvel';
    }
    if (value.length < 9) {
      return 'Número de telemóvel inválido';
    }
    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Digite sua senha';
    }
    if (value.length < 6) {
      return 'A senha deve conter pelo menos 6 caracteres';
    }
    return null;
  }

  Future<void> _editPtofile() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text;
      final name = _nameController.text;
      final nif = _nifController.text;
      final contact = _contactController.text;
      final password = _passwordController.text;
      final passwordConfirm = _passwordConfirmController.text;

      if (password != passwordConfirm) {
        SnackbarMenssage().nasckRegisterDistinctPasswordInfo(context);
        return;
      }

      try {
        final requestUserBody = {
          'name': name,
          'password': password,
          'email': email,
        };

        final response = await http.put(
          Uri.parse('$baseUrl/users/${userController.id.value}'),
          body: requestUserBody,
        );

        if (response.statusCode == 200) {
          final responseUserData = json.decode(response.body);
          var costumertResponse = await http.get(
              Uri.parse('$baseUrl/costumer/${responseUserData['entityId']}'));
          var newCostumertResponse = await json.decode(costumertResponse.body);

          userController.login(
              responseUserData['id'].toString(),
              responseUserData['name'],
              email,
              responseUserData['img'],
              newCostumertResponse['nif'],
              newCostumertResponse['contact'],
              newCostumertResponse['adress']);

          SnackbarMenssage().nasckRegisterSuccess(context, name);
          Get.offAll(HomeScreen());
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                  'Erro ao actualizar dados, tente novamente mais tarde!'),
              duration: const Duration(milliseconds: 2000),
              backgroundColor: Colors.red.shade400,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          );
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Erro ao conectar ao servidor'),
            duration: const Duration(milliseconds: 2000),
            backgroundColor: Colors.red.shade400,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        );
      }
    }
  }
}
