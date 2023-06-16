import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PhotoModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Escolha uma opção',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Get.back(result: 'gallery');
              },
              child: Text('Carregar da Galeria'),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                Get.back(result: 'camera');
              },
              child: Text('Fazer uma Foto'),
            ),
          ],
        ),
      ),
    );
  }
}
