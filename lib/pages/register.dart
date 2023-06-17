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
                        label: 'Nome',
                        hintText: 'Digite seu nome',
                        controller: _nameController,
                        validator: _validateName,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 24),
                      _buildFormField(
                        label: 'NIF/BI',
                        hintText: 'Digite seu NIF ou número do BI',
                        controller: _nifController,
                        validator: _validateNif,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 24),
                      _buildFormField(
                        label: 'E-mail',
                        hintText: 'Digite seu e-mail',
                        controller: _emailController,
                        validator: _emailValidator,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 24),
                      _buildFormField(
                        label: 'Telemóvel',
                        hintText: 'Digite seu número',
                        controller: _contactController,
                        validator: _validateContact,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        maxLength: 9,
                      ),
                      const SizedBox(height: 24),
                      _buildFormField(
                        label: 'Senha',
                        hintText: 'Digite sua senha',
                        controller: _passwordController,
                        validator: _passwordValidator,
                        obscureText: _obscureText.value,
                        suffixIcon: IconButton(
                          icon: Icon(_obscureText.value
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () => _obscureText.toggle(),
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildFormField(
                        label: 'Confirmar Senha',
                        hintText: 'Confirme sua senha',
                        controller: _passwordConfirmController,
                        validator: _passwordValidator,
                        obscureText: _obscureText.value,
                        suffixIcon: IconButton(
                          icon: Icon(_obscureText.value
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () => _obscureText.toggle(),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _registerUser,
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(
                        const Size(double.infinity, 48)),
                  ),
                  child: const Text(
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
                        style: const TextStyle(color: Color(0xFF3D80DE)),
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
    required String hintText,
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
        Text(
          label,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          maxLength: maxLength,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hintText,
            suffixIcon: suffixIcon,
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

      final requestCostumerBody = {
        'name': name,
        'nif': nif,
        'email': email,
        'contact': contact,
      };

      try {
        final costumerResponse = await http.post(
          Uri.parse('$baseUrl/costumers'),
          body: requestCostumerBody,
        );

        if (costumerResponse.statusCode == 200) {
          final responseCostumerData = json.decode(costumerResponse.body);
          final requestUserBody = {
            'name': name,
            'password': password,
            'email': email,
            'entityId': responseCostumerData['id'].toString(),
          };

          final response = await http.post(
            Uri.parse('$baseUrl/users'),
            body: requestUserBody,
          );

          final responseUserData = json.decode(response.body);

          userController.login(
            responseUserData['id'].toString(),
            responseUserData['name'],
            email,
            responseUserData['img'],
          );

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
