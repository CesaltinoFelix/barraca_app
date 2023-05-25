import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class QrCodePage extends StatefulWidget {
  const QrCodePage({super.key});

  @override
  State<QrCodePage> createState() => _QrCodePageState();
}

class _QrCodePageState extends State<QrCodePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          "Referência de Pagamento",
          style: TextStyle(color: Colors.black),
        ),
        elevation: 1,
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              ' Aponta a camera do seu telemovel para seres redirecionado a tela de pagamento. \nSeu QR code é privado. ',
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Image.asset('assets/images/qrcode.jpg'),
            ElevatedButton(
              onPressed: () => _onShare(context),
              child: const Text('Share'),
            )
          ],
        ),
      ),
    );
  }

  _onShare(context) async {
    // Use Builder to get the widget context

// _onShare method:
    final box = context.findRenderObject() as RenderBox?;

    await Share.share(
      'Teste de pagamento',
      subject: 'QR code gerado',
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );
  }
}
