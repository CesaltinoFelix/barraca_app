import 'package:flutter/material.dart';

class SnackbarMenssage {
  //##########################   product ############################
  const SnackbarMenssage();
  nasckProductSuccess(context) {
    nasckbarModel(context, 'Produto Cadastrado!', Colors.green.shade400);
  }

  nasckProductUpdateSuccess(context) {
    nasckbarModel(context, 'Produto Actualizado!', Colors.green.shade400);
  }

  nasckProductInfo(context) {
    nasckbarModel(context, 'Nenhum Produto Selecionado!', Colors.blue.shade400);
  }

  nasckProductError(context) {
    nasckbarModel(context, 'Erro Ao Cadastrar Produto!', Colors.red.shade400);
  }

  //##########################   Sales ############################

  nasckSalesSuccess(context) {
    nasckbarModel(context, 'Venda Cadastrada!', Colors.green.shade400);
  }

  nasckSalesError(context) {
    nasckbarModel(context, 'Erro Ao Cadastrar venda!', Colors.red.shade400);
  }

  //##########################   register ############################
  nasckRegisterDistinctPasswordInfo(context) {
    nasckbarModel(context, 'Password são diferentes!', Colors.orange.shade400);
  }

  nasckRegisterSuccess(context, name) {
    nasckbarModel(context, 'Olá $name, Sejá bem-vindo!', Colors.green.shade400);
  }

  //##########################   Model ############################

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
