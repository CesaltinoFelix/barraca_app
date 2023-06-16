import 'package:barraca_app/controllers/user_controller.dart';
import 'package:barraca_app/helpers/api.dart';
import 'package:barraca_app/helpers/snackbar_menssage.dart';
import 'package:barraca_app/pages/home_screen.dart';
import 'package:barraca_app/pages/login.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uno/uno.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key});

  @override
  State<RegisterPage> createState() => RegisternPageState();
}

class RegisternPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  final UserController userController = Get.find<UserController>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nifController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final uno = Uno();
  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira seu e-mail';
    }
    if (!RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
        .hasMatch(value)) {
      return 'Por favor, insira um e-mail válido';
    }
    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira sua senha';
    }
    return null;
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Campo obrigatório';
    }
    return null;
  }

  String? _validateNif(String? value) {
    if (value == null || value.isEmpty) {
      return 'Campo obrigatório';
    }
    return null;
  }

  String? _validateContact(String? value) {
    if (value == null || value.isEmpty) {
      return 'Campo obrigatório';
    }
    // Verifica se o valor contém exatamente 9 dígitos
    if (!RegExp(r'^\d{9}$').hasMatch(value)) {
      return 'Deve conter exatamente 9 dígitos';
    }
    return null;
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
                      Text(
                        'Nome',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _nameController,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        decoration:
                            const InputDecoration(hintText: 'Digite seu nome'),
                        validator: _validateName,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'NIF/BI',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _nifController,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                            hintText: 'Digite seu NIF ou numero do BI'),
                        validator: _validateNif,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'E-mail',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                            hintText: 'Digite seu e-mail'),
                        validator: _emailValidator,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Telemovel',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _contactController,
                        maxLength: 9,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                            hintText: 'Digite seu numero'),
                        validator: _validateContact,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Senha',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          hintText: 'Digite sua senha',
                          suffixIcon: IconButton(
                            icon: Icon(_obscureText
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                        ),
                        validator: _passwordValidator,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Confirmar Senha',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _passwordConfirmController,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          hintText: 'Confirme sua senha',
                          suffixIcon: IconButton(
                            icon: Icon(_obscureText
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                        ),
                        validator: _passwordValidator,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // Extrair dados do formulário
                      String email = _emailController.text;
                      String name = _nameController.text;
                      String nif = _nifController.text;
                      String contact = _contactController.text;
                      String password = _passwordController.text;
                      String passwordConfirm = _passwordConfirmController.text;
                      if (password != passwordConfirm) {
                        const SnackbarMenssage()
                            .nasckRegisterDistinctPasswordInfo(context);
                        return;
                      }

                      final requestCostumerBody = {
                        'name': name,
                        'nif': nif,
                        'email': email,
                        'contact': contact,
                      };

                      var CostumerResponse = await http.post(
                          Uri.parse('$baseUrl/costumers'),
                          body: requestCostumerBody);
                      // return print(response);

                      if (CostumerResponse.statusCode == 200) {
                        // Redirecionar para a tela inicial
                        var responseCostumerData =
                            await json.decode(CostumerResponse.body);
                        final requestUserBody = {
                          'name': name,
                          'password': password,
                          'email': email,
                          'entityId': responseCostumerData['id'].toString(),
                        };
                        var response = await http.post(
                            Uri.parse('$baseUrl/users'),
                            body: requestUserBody);

                        var responseUserData = await json.decode(response.body);

                        userController.login(
                            responseUserData['id'].toString(),
                            responseUserData['name'],
                            email,
                            responseUserData['img']);
                        SnackbarMenssage().nasckRegisterSuccess(context, name);
                        Get.offAll(HomeScreen());
                      } else {
                        // Exibir mensagem de erro ou tratar falha no login
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text(
                                'Erro ao registar, tente mais tarde!'),
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
                  },
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
                            // Implementar ação de login
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
}
