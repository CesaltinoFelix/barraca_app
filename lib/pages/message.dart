import 'package:barraca_app/utils/constants.dart';
import 'package:barraca_app/components/default_app_bar.dart';
import 'package:barraca_app/components/defaultBackButton.dart';
import 'package:barraca_app/components/emptySection.dart';
import 'package:flutter/material.dart';

class Message extends StatefulWidget {
  Message({Key? key}) : super(key: key);

  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<Message> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: kWhiteColor,
      appBar: DefaultAppBar(
        title: 'Notificações',
        child: DefaultBackButton(),
      ),
      body: EmptySection(
        emptyImg: chatBubble,
        emptyMsg: 'Sem Notificações',
      ),
    );
  }
}
