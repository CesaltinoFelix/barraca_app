// Food

import 'package:barraca_app/models/food.dart';
import 'package:barraca_app/models/order.dart';
import 'package:barraca_app/models/restaurant.dart';
import 'package:barraca_app/models/user.dart';

final _burrito = Food(
    imageUrl: "assets/images/products/burrito.jpg",
    name: "Burrito",
    price: 8.99);

final _steak = Food(
    imageUrl: "assets/images/products/steak.jpg", name: "Steak", price: 17.99);

final _pasta = Food(
    imageUrl: "assets/images/products/pasta.jpg", name: "Pasta", price: 14.99);

final _ramen = Food(
    imageUrl: "assets/images/products/ramen.jpg", name: "Ramen", price: 13.99);

final _pancakes = Food(
    imageUrl: "assets/images/products/pancakes.jpg",
    name: "Pancakes",
    price: 9.99);

final _burger = Food(
    imageUrl: "assets/images/products/burger.jpg",
    name: "Burger",
    price: 14.99);

final _pizza = Food(
    imageUrl: "assets/images/products/pizza.jpg", name: "Pizza", price: 11.99);

final _salmon = Food(
    imageUrl: "assets/images/products/salmon.jpg",
    name: "Salmon Salad",
    price: 12.99);

// Restaurants

final _restaurant0 = Restaurant(
    imageUrl: "assets/images/products/restaurant0.jpg",
    name: "Haveli Restaurant",
    address: "2170-A Food St Fort Rd",
    rating: 5,
    menu: [
      _burrito,
      _steak,
      _pasta,
      _ramen,
      _pancakes,
      _burger,
      _pizza,
      _salmon
    ]);

final _restaurant1 = Restaurant(
    imageUrl: "assets/images/products/restaurant1.jpg",
    name: "Andaaz Restaurant",
    address: "2189 A Fort Rd",
    rating: 4.1,
    menu: [_steak, _pasta, _ramen, _pancakes, _burger, _pizza]);

final _restaurant2 = Restaurant(
    imageUrl: "assets/images/products/restaurant2.jpg",
    name: "Monal Restaurant",
    address: "Plaza Liberty Park",
    rating: 5,
    menu: [_steak, _pasta, _pancakes, _burger, _pizza, _salmon]);

final _restaurant3 = Restaurant(
    imageUrl: "assets/images/products/restaurant3.jpg",
    name: "Spice Bazaar",
    address: "T-01, Off MM Alam Road",
    rating: 4.3,
    menu: [_burger, _steak, _burger, _pizza, _salmon]);

final _restaurant4 = Restaurant(
    imageUrl: "assets/images/products/restaurant4.jpg",
    name: "Cooco's Den",
    address: "2168/A Food St Fort Rd",
    rating: 4.0,
    menu: [_burger, _ramen, _pancakes, _salmon]);

// Restaurants List

final List<Restaurant> restaurants = [
  _restaurant0,
  _restaurant1,
  _restaurant2,
  _restaurant3,
  _restaurant4
];

// User

final currentUser = User(name: "Zeeshan Ahmed", orders: [
  Order(
      restaurant: _restaurant2,
      food: _steak,
      date: "Apr 30, 2022",
      quantity: 1),
  Order(
      restaurant: _restaurant0,
      food: _ramen,
      date: "Apr 28, 2022",
      quantity: 3),
  Order(
      restaurant: _restaurant1,
      food: _burrito,
      date: "Apr 30, 2022",
      quantity: 2),
  Order(
      restaurant: _restaurant3,
      food: _salmon,
      date: "Apr 30, 2022",
      quantity: 1),
  Order(
      restaurant: _restaurant4,
      food: _pancakes,
      date: "Apr 30, 2022",
      quantity: 1)
], cart: [
  Order(
      restaurant: _restaurant2,
      food: _burger,
      date: "Apr 29, 2022",
      quantity: 2),
  Order(
      restaurant: _restaurant2,
      food: _pasta,
      date: "Apr 30, 2022",
      quantity: 1),
  Order(
      restaurant: _restaurant3,
      food: _salmon,
      date: "Apr 30, 2022",
      quantity: 1),
  Order(
      restaurant: _restaurant4,
      food: _pancakes,
      date: "Apr 29, 2022",
      quantity: 3),
  Order(
      restaurant: _restaurant1,
      food: _burrito,
      date: "Apr 30, 2022",
      quantity: 2)
]);
