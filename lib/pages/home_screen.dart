import 'package:barraca_app/pages/profile_screen.dart';
import 'package:barraca_app/controllers/user_controller.dart';

import 'package:flutter/material.dart';
import 'package:barraca_app/pages/help.dart';
import 'package:barraca_app/pages/personalize_screen.dart';
import 'package:barraca_app/pages/product_screen.dart';
import 'package:barraca_app/pages/sell_screen.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen();

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  BoxDecoration getBoxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5),
          topRight: Radius.circular(5),
          bottomLeft: Radius.circular(5),
          bottomRight: Radius.circular(5)),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 1,
          blurRadius: 2,
          offset: Offset(0, 1), // changes position of shadow
        ),
      ],
    );
  }

  final UserController userController = Get.find<UserController>();
  Expanded getExpanded(String imageName, String mainText, Widget page) {
    return Expanded(
      child: GestureDetector(
        child: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Image.asset(
                    'assets/images/home/$imageName.png',
                    height: 100.0,
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  mainText,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
              ],
            ),
          ),
          margin:
              EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0, bottom: 10.0),
          decoration: getBoxDecoration(),
        ),
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => page));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 1,
        title: Text(
          "Barraca",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 200.0, horizontal: 70.0),
        height: MediaQuery.of(context).size.height,
        color: Colors.grey.shade200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  getExpanded('selling', 'Vender', SellCreen()),
                  // getExpanded('products', 'Produtos', ProductCreen()),
                ],
              ),
            ),
          ],
        ),
      ),
      drawer: myDrawer(userController),
    );
  }
}

Widget myDrawer(userController) {
  return Drawer(
    backgroundColor: Colors.grey.shade100,
    child: ListView(
      // Remove padding
      padding: EdgeInsets.zero,
      children: [
        UserAccountsDrawerHeader(
          accountName: Text('${userController.username.value}'),
          accountEmail: Text('${userController.email.value}'),
          currentAccountPicture: CircleAvatar(
            child: userController.email.value == 'cesaltinofelix2000@gmail.com'
                ? ClipOval(
                    child: Image.asset(
                      'assets/images/avatar.jpeg',
                      fit: BoxFit.cover,
                      width: 90,
                      height: 90,
                    ),
                  )
                : ClipOval(
                    child: Image.asset(
                      'assets/images/profile-1.png',
                      fit: BoxFit.cover,
                      width: 90,
                      height: 90,
                    ),
                  ),
          ),
          decoration: BoxDecoration(
            color: Colors.blue,
            image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('assets/images/profile-bg1.jpg')),
          ),
        ),
        ListTile(
          leading: Icon(Icons.shopping_bag_outlined),
          title: Text('Produtos'),
          onTap: () {
            Get.back();
            Get.to(ProductCreen());
          },
        ),
        ListTile(
          leading: Icon(Icons.edit_outlined),
          title: Text('Costumizar'),
          onTap: () {
            Get.back();
            Get.to(PersonalizeScreen());
          },
        ),
        ListTile(
          leading: Icon(Icons.attach_money_outlined),
          title: Text('Vendas'),
          onTap: () {
            Get.back();
            Get.to(ProductCreen());
          },
        ),
        SizedBox(
          height: 20,
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.account_circle_outlined),
          title: Text('Perfil'),
          onTap: () {
            Get.back();
            Get.to(ProfileScreen());
          },
        ),
        ListTile(
          leading: Icon(Icons.history),
          title: Text('Historico'),
          onTap: () {
            Get.back();
            Get.to(ProductCreen());
          },
        ),
        ListTile(
          leading: Icon(Icons.help_outline),
          title: Text('Ajuda'),
          onTap: () {
            Get.back();
            Get.to(HelpScreen());
          },
        ),
      ],
    ),
  );
}
