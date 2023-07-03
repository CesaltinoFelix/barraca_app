import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:barraca_app/constants/app_textstyle.dart';
import 'package:barraca_app/data/transaction_data.dart';
import 'package:barraca_app/helpers/money_format.dart';

class SellStatusCard extends StatelessWidget {
  final TransactionModel? transaction;
  const SellStatusCard({Key? key, this.transaction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color.fromRGBO(224, 224, 224, 1))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                height: 60,
                width: 60,
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: transaction!.color,
                ),
                // child: Image.asset(transaction!.avatar ?? ''),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    transaction!.avatar ?? '',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    transaction!.name ?? '',
                    style: ApptextStyle.LISTTILE_TITLE,
                  ),
                  Text(
                    transaction!.month ?? '',
                    style: ApptextStyle.LISTTILE_SUB_TITLE,
                  ),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Kz${moneyFormat(double.parse(transaction!.currentBalance!.split('kz')[1].toString()))}' ??
                        '',
                    style: ApptextStyle.LISTTILE_TITLE,
                  ),
                  Row(
                    children: [
                      transaction!.changePercentageIndicator == "up"
                          ? Text(
                              'Concluido',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.green,
                              ),
                            )
                          : Text(
                              'Pendente',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.orange,
                              ),
                            )
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
