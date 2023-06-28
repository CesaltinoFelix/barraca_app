import 'package:flutter/material.dart';
import 'package:barraca_app/constants/app_textstyle.dart';
import 'package:barraca_app/data/card_data.dart';

class MyCard extends StatelessWidget {
  final CardModel? card;
  const MyCard({Key? key, this.card}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      height: 200,
      width: 350,
      decoration: BoxDecoration(
        color: card!.cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Nome do titular",
                    style: ApptextStyle.MY_CARD_TITLE,
                  ),
                  Text(
                    card!.cardHolderName ?? '',
                    style: ApptextStyle.MY_CARD_SUBTITLE,
                  ),
                ],
              ),
              Text(
                card?.cardNumber ?? '',
                style: ApptextStyle.MY_CARD_SUBTITLE,
              ),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Data de Exp.",
                        style: ApptextStyle.MY_CARD_TITLE,
                      ),
                      Text(
                        card!.expDate ?? '',
                        style: ApptextStyle.MY_CARD_SUBTITLE,
                      ),
                    ],
                  ),
                  SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Código de CVV",
                        style: ApptextStyle.MY_CARD_TITLE,
                      ),
                      Text(
                        card!.cvv ?? '',
                        style: ApptextStyle.MY_CARD_SUBTITLE,
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 50,
                height: 50,
                child: Image.asset('assets/icons/mcard.png'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
