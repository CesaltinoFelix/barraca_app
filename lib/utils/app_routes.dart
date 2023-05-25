import 'package:flutter/material.dart';
import 'package:barraca_app/pages/product_screen.dart';

class AppRoutes {
  static const home = '/home-screen';
  static const splashScreen = '/';

  static ProductRoute(context) {
    Navigator.push(
        context, MaterialPageRoute(builder: ((ctx) => ProductCreen())));
  }
}
