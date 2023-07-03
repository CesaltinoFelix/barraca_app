import 'package:barraca_app/helpers/money_format.dart';
import 'package:flutter/material.dart';

import '../components/defaultBackButton.dart';
import '../components/default_app_bar.dart';
import '../data/transaction_data.dart';
import '../utils/constants.dart';
import '../widgets/transaction_card.dart';

class SellHistoryScreen extends StatefulWidget {
  const SellHistoryScreen({super.key});

  @override
  State<SellHistoryScreen> createState() => _SellHistoryScreenState();
}

class _SellHistoryScreenState extends State<SellHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        title: "Histórico de Vendas",
        child: DefaultBackButton(),
      ),
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 15,
              ),
              Container(
                height: 590,
                child: SingleChildScrollView(
                  child: ListView.separated(
                      itemCount: myTransactions.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          height: 10,
                        );
                      },
                      itemBuilder: (context, index) {
                        return TransactionCard(
                            transaction: myTransactions[index]);
                      }),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: kSecondaryColor,
                ),
                padding: const EdgeInsets.all(24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Preço Total ',
                          style: TextStyle(color: kAccentColor),
                        ),

                        const SizedBox(height: 8),
                        // total price
                        Text(
                          '\Kz${moneyFormat(23000)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),

                    // pay now
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: kAccentColor),
                        borderRadius: BorderRadius.circular(28),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: const [
                          Text(
                            'Ver Relatório',
                            style: TextStyle(color: Colors.white),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
