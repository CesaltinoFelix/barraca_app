import 'package:flutter/material.dart';

import '../components/defaultBackButton.dart';
import '../components/default_app_bar.dart';
import '../data/transaction_data.dart';
import '../utils/constants.dart';
import '../widgets/sell_status_card.dart';

class SellStatusScreen extends StatefulWidget {
  const SellStatusScreen({super.key});

  @override
  State<SellStatusScreen> createState() => _SellStatusScreenState();
}

class _SellStatusScreenState extends State<SellStatusScreen> {
  String isSelected = 'Tudo';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        title: "Estado das Vendas",
        child: DefaultBackButton(),
      ),
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FittedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    ActionChip(
                        avatar: CircleAvatar(
                          backgroundColor: isSelected == 'Tudo'
                              ? kPrimaryColor
                              : Colors.grey.shade800,
                          child: Text('A',
                              style: const TextStyle(color: Colors.white)),
                        ),
                        label: Text('Tudo'),
                        onPressed: () {
                          setState(() {
                            isSelected = 'Tudo';
                          });
                          print("Tudo");
                        }),
                    SizedBox(
                      width: 5,
                    ),
                    ActionChip(
                        avatar: CircleAvatar(
                          backgroundColor: isSelected == 'Concluido'
                              ? kPrimaryColor
                              : Colors.grey.shade800,
                          child: Text('B',
                              style: const TextStyle(color: Colors.white)),
                        ),
                        label: Text('Concluido'),
                        onPressed: () {
                          setState(() {
                            isSelected = 'Concluido';
                          });
                          print("Concluído");
                        }),
                    SizedBox(
                      width: 5,
                    ),
                    ActionChip(
                        avatar: CircleAvatar(
                          backgroundColor: isSelected == 'Pendente'
                              ? kPrimaryColor
                              : Colors.grey.shade800,
                          child: Text('C',
                              style: const TextStyle(color: Colors.white)),
                        ),
                        label: Text('Pendente'),
                        onPressed: () {
                          setState(() {
                            isSelected = 'Pendente';
                          });
                          print("Pendente");
                        }),
                    SizedBox(
                      width: 5,
                    ),
                    ActionChip(
                        avatar: CircleAvatar(
                          backgroundColor: isSelected == 'Cancelado'
                              ? kPrimaryColor
                              : Colors.grey.shade800,
                          child: Text('D',
                              style: const TextStyle(color: Colors.white)),
                        ),
                        label: Text('Cancelado'),
                        onPressed: () {
                          setState(() {
                            isSelected = 'Cancelado';
                          });
                          print("Cancelado");
                        }),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                height: 640,
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
                        return SellStatusCard(
                            transaction: myTransactions[index]);
                      }),
                ),
              ),
              SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
