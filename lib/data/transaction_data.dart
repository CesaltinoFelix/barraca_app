import 'package:flutter/material.dart';

class TransactionModel {
  String? name;
  String? avatar;
  String? currentBalance;
  String? month;
  String? changePercentageIndicator;
  String? changePercentage;
  Color? color;

  TransactionModel({
    required this.avatar,
    required this.changePercentage,
    required this.changePercentageIndicator,
    required this.currentBalance,
    required this.month,
    required this.name,
    required this.color,
  });
}

List<TransactionModel> myTransactions = [
  TransactionModel(
    avatar: "assets/images/profile-1.png",
    currentBalance: "kz5482",
    changePercentage: "0.41%",
    changePercentageIndicator: "up",
    month: "Jan",
    name: "Reginaldo",
    color: Colors.green[100],
  ),
  TransactionModel(
    avatar: "assets/images/profile-1.png",
    currentBalance: "kz4252",
    changePercentageIndicator: "down",
    changePercentage: "4.54%",
    month: "Mar",
    name: "Vinicias",
    color: Colors.orange[100],
  ),
  TransactionModel(
    avatar: "assets/images/profile-1.png",
    currentBalance: "kz4052",
    changePercentage: "1.27%",
    changePercentageIndicator: "down",
    month: "Mar",
    name: "Jandira",
    color: Colors.red[100],
  ),
  TransactionModel(
    avatar: "assets/images/profile-1.png",
    currentBalance: "kz5052",
    changePercentageIndicator: "up",
    changePercentage: "3.09%",
    month: "Mar",
    name: "Solange",
    color: Colors.deepPurple[100],
  ),
  TransactionModel(
    avatar: "assets/images/profile-1.png",
    currentBalance: "kz5482",
    changePercentage: "0.41%",
    changePercentageIndicator: "up",
    month: "Jan",
    name: "Francisca",
    color: Colors.green[100],
  ),
  TransactionModel(
    avatar: "assets/images/avatar.jpeg",
    currentBalance: "kz4252",
    changePercentageIndicator: "down",
    changePercentage: "4.54%",
    month: "Mar",
    name: "Félix",
    color: Colors.orange[100],
  ),
];
