import 'package:barraca_app/models/food.dart';
import 'package:barraca_app/models/restaurant.dart';

class Order {
  final Restaurant restaurant;
  final Food food;
  final String date;
  int quantity;

  Order(
      {required this.restaurant,
      required this.food,
      required this.date,
      required this.quantity});
}
