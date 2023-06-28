import 'package:barraca_app/utils/constants.dart';
import 'package:flutter/material.dart';

class DefaultButton extends StatelessWidget {
  final String? btnText;
  final Function? onPressed;
  const DefaultButton({
    Key? key,
    this.btnText,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(vertical: kDefaultPadding),
      padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: ElevatedButton(
        onPressed: () {
          onPressed!();
        },
        style: ButtonStyle(
          minimumSize:
              MaterialStateProperty.all(const Size(double.infinity, 48)),
        ),
        child: Text(
          btnText!.toUpperCase(),
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
