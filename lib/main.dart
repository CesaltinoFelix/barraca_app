import 'package:barraca_app/controllers/user_controller.dart';
import 'package:barraca_app/pages/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:barraca_app/pages/login.dart';
import 'package:get/get.dart';
import 'package:barraca_app/utils/constants.dart';

void main() async {
  final UserController userController = Get.put(UserController());
  userController.verifyLogin();
  String userId = await userController.loadData('email');
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      scaffoldBackgroundColor: Colors.white,
      primarySwatch: Colors.blue,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 48),
          backgroundColor: const Color(0xFFF2994A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide.none,
          ),
          elevation: 0,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: const Color(0xFFFBFBFB),
        filled: true,
        border: defaultOutlineInputBorder,
        enabledBorder: defaultOutlineInputBorder,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFF2994A)),
        ),
      ),
    ),
    home: userId != '' ? HomeScreen() : WelcomeScreen(),
  ));
}

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    "Bem-vindo",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Verificação automática de identidade que permite verificar sua identidade",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[700], fontSize: 15),
                  ),
                ],
              ),
              Container(
                height: MediaQuery.of(context).size.height / 3,
                child: Lottie.asset('assets/images/barraca-splash-screen.json',
                    fit: BoxFit.cover),
              ),
              Column(
                children: <Widget>[
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
                      onPressed: () {
                        Get.off(LoginPage());
                      },
                      color: Colors.orange.shade300,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      child: Text(
                        "Login",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 18),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
