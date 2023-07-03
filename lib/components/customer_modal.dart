import 'dart:convert';
import 'package:barraca_app/utils/constants.dart';
import 'package:flutter/material.dart';

class CustomerModal extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController nifController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Flex(
          direction: Axis.vertical,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Informações do Cliente',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 24),
            Flexible(
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Nome do Cliente',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 16),
            Flexible(
              child: TextField(
                controller: nifController,
                decoration: InputDecoration(
                  labelText: 'NIF (Número de Identificação Fiscal)',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: Text('Cancelar'),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      String name = nameController.text;
                      String nif = nifController.text;
                      if (name.isEmpty) name = 'Consumidor Final';
                      if (nif.isEmpty) nif = '999999';
                      Map<String, String> result = {'name': name, 'nif': nif};

                      Navigator.pop(context, result);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: Text('Confirmar'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
