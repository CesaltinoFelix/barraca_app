import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:barraca_app/pages/home_screen.dart';
import 'package:barraca_app/pages/product_screen.dart';
import 'package:barraca_app/pages/profile_screen.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => AppState();
}

class AppState extends State<App> {
  int activeTab = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: getFooter(),
      body: getBody(),
    );
  }

  Widget getFooter() {
    return CurvedNavigationBar(
      backgroundColor: Colors.grey.shade200,
      items: <Widget>[
        Icon(LineAwesomeIcons.home, size: 30),
        Icon(LineAwesomeIcons.credit_card, size: 30),
        Icon(LineAwesomeIcons.bar_chart, size: 30),
        Icon(LineAwesomeIcons.user, size: 30),
      ],
      onTap: (index) {
        setState(() {
          activeTab = index;
        });
      },
    );
  }

  Widget getBody() {
    return IndexedStack(
      index: activeTab,
      children: [HomeScreen(), ProductCreen(), ProductCreen(), ProfileScreen()],
    );
  }
}
