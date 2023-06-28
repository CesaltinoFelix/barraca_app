import 'package:barraca_app/pages/printer_setting_screen.dart';
import 'package:barraca_app/pages/scanner_code.dart';
import 'package:barraca_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:barraca_app/controllers/user_controller.dart';
import 'package:barraca_app/pages/help.dart';
import 'package:barraca_app/pages/personalize_screen.dart';
import 'package:barraca_app/pages/product_screen.dart';
import 'package:barraca_app/pages/sell_screen.dart';
import 'package:barraca_app/pages/profile_screen.dart';

class HomeScreen extends StatelessWidget {
  final UserController userController = Get.find<UserController>();

  BoxDecoration getBoxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(5),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 1,
          blurRadius: 2,
          offset: Offset(0, 1),
        ),
      ],
    );
  }

  Widget getExpanded(String imageName, String mainText, Widget page) {
    return Expanded(
      child: GestureDetector(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/home/$imageName.png',
                height: 100.0,
                width: 400,
              ),
              SizedBox(height: 5.0),
              Text(
                mainText,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
            ],
          ),
          margin: EdgeInsets.all(10.0),
          decoration: getBoxDecoration(),
        ),
        onTap: () => Get.to(page),
      ),
    );
  }

  Widget myDrawer(UserController userController) {
    return Drawer(
      backgroundColor: Colors.grey.shade100,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text('${userController.username.value}'),
            accountEmail: Text('${userController.email.value}'),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.asset(
                  userController.email.value == 'cesaltinofelix2000@gmail.com'
                      ? 'assets/images/avatar.jpeg'
                      : 'assets/images/profile-1.png',
                  fit: BoxFit.cover,
                  width: 90,
                  height: 90,
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.blue.shade300,
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('assets/images/profile-bg1.jpg'),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.shopping_bag_outlined),
            title: Text('Produtos'),
            onTap: () => Get.to(ProductScreen()),
          ),
          ListTile(
            leading: Icon(Icons.edit_outlined),
            title: Text('Costumizar Produto'),
            onTap: () => Get.to(PersonalizeScreen()),
          ),
          ListTile(
            leading: Icon(Icons.attach_money_outlined),
            title: Text('Estado das Vendas'),
            onTap: () => Get.to(ProductScreen()),
          ),
          SizedBox(height: 20),
          Divider(),
          ListTile(
            leading: Icon(Icons.account_circle_outlined),
            title: Text('Perfil'),
            onTap: () => Get.to(ProfileScreen()),
          ),
          ListTile(
            leading: Icon(Icons.history),
            title: Text('Historico'),
            onTap: () => Get.to(ProductScreen()),
          ),
          ListTile(
            leading: Icon(Icons.print),
            title: Text('Impressora'),
            onTap: () => Get.to(HelpScreen()),
          ),
          ListTile(
            leading: Icon(Icons.help_outline),
            title: Text('Ajuda'),
            onTap: () => Get.to(HelpScreen()),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: kPrimaryColor,
        centerTitle: true,
        elevation: 1,
        title: Text(
          "Barraca",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return LayoutBuilder(
            builder: (context, constraints) {
              if (orientation == Orientation.portrait) {
                // Layout para orientação retrato
                return Container(
                  width: double.infinity,
                  padding:
                      EdgeInsets.symmetric(vertical: 200.0, horizontal: 70.0),
                  height: MediaQuery.of(context).size.height,
                  color: Colors.grey.shade200,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      getExpanded('selling', 'Vender', SellScreen()),
                    ],
                  ),
                );
              } else {
                // Layout para orientação paisagem
                return Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 50.0, horizontal: 200.0),
                  height: constraints.maxHeight,
                  color: Colors.grey.shade200,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      getExpanded('selling', 'Vender', SellScreen()),
                    ],
                  ),
                );
              }
            },
          );
        },
      ),
      drawer: myDrawer(userController),
    );
  }
}
