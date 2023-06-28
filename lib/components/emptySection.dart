import 'package:barraca_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class EmptySection extends StatelessWidget {
  final String? emptyImg, emptyMsg;
  const EmptySection({
    Key? key,
    this.emptyImg,
    this.emptyMsg,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Lottie.asset(emptyImg!),
            height: MediaQuery.of(context).size.height / 3,
          ),
          Padding(
            padding: const EdgeInsets.only(top: kLessPadding),
            child: Text(
              emptyMsg!,
              style: kLightTextStyle,
            ),
          ),
        ],
      ),
    );
  }
}
