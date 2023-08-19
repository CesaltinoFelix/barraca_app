import 'package:barraca_app/controllers/user_controller.dart';
import 'package:barraca_app/helpers/api.dart';
import 'package:barraca_app/pages/home_screen.dart';
import 'package:barraca_app/pages/register.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uno/uno.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  final UserController userController = Get.find<UserController>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final uno = Uno();
  bool isLogin = false;

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
                  'Bem-vindo de volta!',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                ),
                const SizedBox(height: 16),
                const Text('Faça login para acessar e começar a vender'),
                const SizedBox(height: 32),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'E-mail',
                        ),
                        validator: _emailValidator,
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          labelText: 'Senha',
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
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            // Implementar recuperação de senha
                          },
                          child: const Text(
                            'Esqueceu sua senha?',
                            style: TextStyle(color: Color(0xFF3D80DE)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: isLogin
                      ? null
                      : () async {
                          setState(() {
                            // isLogin = true;
                          });
                          if (_formKey.currentState!.validate()) {
                            // Extrair dados do formulário
                            String email = _emailController.text;
                            String password = _passwordController.text;
                            Map<String, dynamic> data = {
                              'email': email,
                              'password': password,
                              // Adicione outros campos e valores conforme necessário
                            };

                            try {
                              // Fazer a consulta na API
                              var response = await http.post(
                                  Uri.parse('$baseUrl/login'),
                                  body: data);

                              if (response.statusCode == 200) {
                                // Redirecionar para a tela inicial

                                var responseData =
                                    await json.decode(response.body);
                                Map<String, String> headers = {
                                  'x-acess-token': '${responseData['token']}',
                                  'Content-Type':
                                      'application/json', // Indica que o corpo da requisição é em formato JSON
                                };
                                var costumertResponse = await http.get(
                                    Uri.parse(
                                        '$baseUrl/costumers/${responseData['entityId']}'),
                                    headers: headers);
                                var newCostumertResponse =
                                    await json.decode(costumertResponse.body);

                                userController.login(
                                    responseData['id'].toString(),
                                    responseData['name'],
                                    responseData['token'],
                                    email,
                                    responseData['img'],
                                    newCostumertResponse['nif'],
                                    newCostumertResponse['contact'],
                                    newCostumertResponse['adress']);

                                Get.offAll(HomeScreen());
                              } else {
                                // Exibir mensagem de erro ou tratar falha no login
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text(
                                        'Credenciais inválidas, verifica as suas informações!'),
                                    duration:
                                        const Duration(milliseconds: 2000),
                                    backgroundColor: Colors.red.shade400,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                );
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text(
                                      'Estamos fora de serviço de momento, por favor tente mais tarde!'),
                                  duration: const Duration(milliseconds: 2000),
                                  backgroundColor: Colors.red.shade400,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                              );
                            } finally {
                              setState(() {
                                isLogin = false;
                              });
                            }
                          }
                        },
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(
                        const Size(double.infinity, 48)),
                  ),
                  child: isLogin
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          'Entrar',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                ),
                const SizedBox(height: 16),
                RichText(
                  text: TextSpan(
                    text: 'Não tem uma conta? ',
                    style: const TextStyle(color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Cadastre-se',
                        style: const TextStyle(
                            color: Color(0xFF3D80DE),
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // Implementar ação de cadastro
                            Get.to(RegisterPage());
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
