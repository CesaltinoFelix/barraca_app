import 'package:flutter/material.dart';

class SnackbarMenssage {
  const SnackbarMenssage();
  nasckProductSuccess(context) {
    nasckbarModel(context, 'Produto Cadastrado!', Colors.green.shade400);
  }

  nasckProductError(context) {
    nasckbarModel(context, 'Erro Ao Cadastrar Produto!', Colors.red.shade400);
  }

  nasckSalesSuccess(context) {
    nasckbarModel(context, 'Venda Cadastrada!', Colors.green.shade400);
  }

  nasckSalesError(context) {
    nasckbarModel(context, 'Erro Ao Cadastrar venda!', Colors.red.shade400);
  }

  nasckbarModel(context, text, color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        duration: const Duration(milliseconds: 1500),
        backgroundColor: color,
        /* action: SnackBarAction(
              label: 'Action',
              onPressed: () {},
            ), */
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
