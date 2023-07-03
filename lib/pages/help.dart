import 'package:flutter/material.dart';

import '../components/defaultBackButton.dart';
import '../components/default_app_bar.dart';
import '../utils/constants.dart';

class HelpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: DefaultAppBar(
        title: 'Ajuda',
        child: DefaultBackButton(),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Perguntas Frequentes',
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            FaqItem(
              question: 'Como faço para criar uma conta?',
              answer:
                  'Para criar uma conta, clique no botão "Criar Conta" na página inicial e siga as instruções.',
              selectedColor: Colors.orange.shade300,
            ),
            FaqItem(
              question: 'Como faço para fazer uma compra?',
              answer:
                  'Para fazer uma compra, adicione os produtos desejados ao seu carrinho e siga o processo de checkout.',
              selectedColor: Colors.orange.shade300,
            ),
            FaqItem(
              question: 'Como entro em contato com o suporte?',
              answer:
                  'Para entrar em contato com o suporte, envie um e-mail para dotsoluction.suport@gmail.com ou ligue para o número (+244) 922-823-242.',
              selectedColor: Colors.orange.shade300,
            ),
            FaqItem(
              question: 'Como faço para vender meus produtos?',
              answer:
                  'Para vender seus produtos, acesse a seção "Vender" no menu principal e siga as instruções para cadastrar seus produtos e definir os detalhes, como preço e descrição.',
              selectedColor: Colors.orange.shade300,
            ),
            FaqItem(
              question: 'Quais são os métodos de pagamento disponíveis?',
              answer:
                  'Atualmente, oferecemos os seguintes métodos de pagamento: cartão de crédito, transferência bancária e pagamento na entrega.',
              selectedColor: Colors.orange.shade300,
            ),
            FaqItem(
              question: 'Como cadastrar um novo produto?',
              answer:
                  'Para cadastrar um novo produto, acesse a seção "Meus Produtos" no menu principal e clique no botão "Cadastrar Produto". Preencha as informações solicitadas, como nome, categoria, preço e imagens.',
              selectedColor: Colors.orange.shade300,
            ),
          ],
        ),
      ),
    );
  }
}

class FaqItem extends StatefulWidget {
  final String question;
  final String answer;
  final Color selectedColor;

  const FaqItem({
    Key? key,
    required this.question,
    required this.answer,
    required this.selectedColor,
  }) : super(key: key);

  @override
  _FaqItemState createState() => _FaqItemState();
}

class _FaqItemState extends State<FaqItem> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ExpansionTile(
        tilePadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        title: Text(
          widget.question,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: expanded ? widget.selectedColor : Colors.black,
          ),
        ),
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              widget.answer,
              style: TextStyle(fontSize: 16.0),
            ),
          ),
        ],
        onExpansionChanged: (expanded) {
          setState(() {
            this.expanded = expanded;
          });
        },
        trailing: Icon(
          expanded ? Icons.expand_less : Icons.expand_more,
          size: 32.0,
          color: expanded ? widget.selectedColor : Colors.black,
        ),
      ),
    );
  }
}
