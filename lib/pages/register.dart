import 'dart:convert';

import 'package:barraca_app/controllers/user_controller.dart';
import 'package:barraca_app/helpers/api.dart';
import 'package:barraca_app/helpers/snackbar_menssage.dart';
import 'package:barraca_app/pages/home_screen.dart';
import 'package:barraca_app/pages/login.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key});

  @override
  State<RegisterPage> createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  final userController = Get.find<UserController>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  final _nameController = TextEditingController();
  final _nifController = TextEditingController();
  final _contactController = TextEditingController();
  final _adressController = TextEditingController();
  bool isResgisting = false;
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                Image.asset('assets/images/logo-1.png', height: 70),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                Text(
                  'Bem-vindo ao Barraca!',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                ),
                const SizedBox(height: 16),
                const Text('Crie a sua conta na Barraca'),
                const SizedBox(height: 32),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFormField(
                        label: 'Nome (Entidade)',
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
                        label: 'Endereço',
                        controller: _adressController,
                        validator: null,
                        keyboardType: TextInputType.streetAddress,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 24),
                      _buildFormField(
                        label: 'Senha',
                        controller: _passwordController,
                        validator: _passwordValidator,
                        obscureText: _obscureText,
                        suffixIcon: IconButton(
                          icon: Icon(_obscureText
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () => setState(() {
                            _obscureText = !_obscureText;
                          }),
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildFormField(
                        label: 'Confirmar Senha',
                        controller: _passwordConfirmController,
                        validator: _passwordValidator,
                        obscureText: _obscureText,
                        suffixIcon: IconButton(
                          icon: Icon(_obscureText
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () => setState(() {
                            _obscureText = !_obscureText;
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: isResgisting ? null : _registerUser,
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(
                        const Size(double.infinity, 48)),
                  ),
                  child: isResgisting
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          'Cadastrar-se',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                ),
                const SizedBox(height: 16),
                RichText(
                  text: TextSpan(
                    text: 'Já tem uma conta? ',
                    style: const TextStyle(color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Login',
                        style: const TextStyle(
                            color: Color(0xFF3D80DE),
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Get.to(LoginPage());
                          },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    required String? Function(String?)? validator,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    int? maxLength,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          maxLength: maxLength,
          obscureText: obscureText,
          decoration: InputDecoration(
            suffixIcon: suffixIcon,
            labelText: label,
          ),
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

  Future<void> _registerUser() async {
    setState(() {
      isResgisting = true;
    });
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text;
      final name = _nameController.text;
      final nif = _nifController.text;
      final contact = _contactController.text;
      final adress = _adressController.text;
      final password = _passwordController.text;
      final passwordConfirm = _passwordConfirmController.text;

      if (password != passwordConfirm) {
        SnackbarMenssage().nasckRegisterDistinctPasswordInfo(context);
        return;
      }

      final requestCostumerBody = {
        'name': name,
        'nif': nif,
        'email': email,
        'adress': adress,
        'contact': contact,
      };
      dynamic costumerResponse;
      try {
        costumerResponse = await http.post(
          Uri.parse('$baseUrl/costumers'),
          body: requestCostumerBody,
        );
      } catch (e) {
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

        return setState(() {
          isResgisting = false;
        });
      }

      if (costumerResponse != null && costumerResponse.statusCode == 200) {
        final responseCostumerData = json.decode(costumerResponse.body);
        final requestUserBody = {
          'name': name,
          'password': password,
          'email': email,
          'entityId': responseCostumerData['id'].toString(),
        };
        dynamic response;

        try {
          response = await http.post(
            Uri.parse('$baseUrl/users'),
            body: requestUserBody,
          );
        } catch (e) {
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

          return setState(() {
            isResgisting = false;
          });
        }
        final responseUserData = await json.decode(response.body);

        userController.login(
            responseUserData['id'].toString(),
            responseUserData['name'],
            email,
            responseUserData['img'],
            responseCostumerData['nif'],
            responseCostumerData['contact'],
            responseCostumerData['adress']);

        SnackbarMenssage().nasckRegisterSuccess(context, name);
        Get.offAll(HomeScreen());
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                const Text('Erro ao registrar, tente novamente mais tarde!'),
            duration: const Duration(milliseconds: 2000),
            backgroundColor: Colors.red.shade400,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        );
        setState(() {
          isResgisting = false;
        });
      }
    }

    setState(() {
      isResgisting = false;
    });
  }
}
