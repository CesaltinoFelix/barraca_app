import 'package:barraca_app/pages/home_screen.dart';
import 'package:barraca_app/utils/constants.dart';
import 'package:barraca_app/components/defaultButton.dart';
import './emptySection.dart';
import 'package:barraca_app/components/subTitle.dart';
import 'package:flutter/material.dart';

class Success extends StatefulWidget {
  Success({Key? key}) : super(key: key);

  @override
  _SuccessState createState() => _SuccessState();
}

class _SuccessState extends State<Success> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const EmptySection(
            emptyImg: success,
            emptyMsg: 'Sucesso !!',
          ),
          const SubTitle(
            subTitleText: 'Operação realizada com sucesso!',
          ),
          DefaultButton(
            btnText: 'Ok',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => HomeScreen(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
