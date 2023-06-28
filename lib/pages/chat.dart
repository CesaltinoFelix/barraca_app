import 'package:barraca_app/helpers/api.dart';
import 'package:barraca_app/utils/constants.dart';
import 'package:barraca_app/components/default_app_bar.dart';
import 'package:barraca_app/components/defaultBackButton.dart';
import 'package:barraca_app/components/emptySection.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/material.dart';
import 'package:uno/uno.dart';

import '../controllers/user_controller.dart';

class Chat extends StatefulWidget {
  Chat({Key? key}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  late IO.Socket socket;
  List<dynamic> messages = [];
  final uno = Uno();
  bool isLoanding = true;
  final TextEditingController _messageController = TextEditingController();
  final UserController userController = Get.find<UserController>();
  final ScrollController _scrollController =
      ScrollController(); // Add ScrollController
  @override
  void initState() {
    super.initState();
    socket = IO.io('http://$baseUrl', <String, dynamic>{
      'transports': ['websocket'],
    });
    socket.connect();
    socket.on('connect', (_) {
      // print('Connected to server');
    });
    socket.on('server-message', (data) {
      print('Message received from server: $data');
      setState(() {
        messages.add(data);
      });
    });

    try {
      getMessage();
    } catch (e) {
      setState(() {
        isLoanding = false;
      });
    } finally {
      setState(() {
        isLoanding = false;
      });
    }

    setScroller();
  }

  @override
  void dispose() {
    super.dispose();
    socket.disconnect();
  }

  void scrollToBottom() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void setScroller() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      scrollToBottom();
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        scrollToBottom();
      }
    });
  }

  void sendMessage(String message) async {
    if (message.isNotEmpty) {
      final data = {
        'message': message,
        'senderId': int.parse(userController.id.value)
      };
      final response = await uno.post('${baseUrl}/chat', data: data);

      _messageController.clear();
      socket.emit('client-message', data);
      getMessage();
    }
  }

  void getMessage() async {
    final response =
        await uno.get('${baseUrl}/chat/${userController.id.value}');

    setState(() {
      messages = response.data;
    });

    setScroller();
  }

  @override
  Widget build(BuildContext context) {
    String userId = userController.id.value;
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: DefaultAppBar(
        title: "Chat",
        child: DefaultBackButton(),
      ),
      body: isLoanding
          ? CircularProgressIndicator(
              color: kPrimaryColor,
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: messages.isEmpty && isLoanding
                      ? const EmptySection(
                          emptyImg: conversation,
                          emptyMsg: "Nenhuma mensagem ainda",
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            final message = messages[index];

                            final bool sentByMe =
                                message['senderId'].toString() ==
                                    userId.toString();
                            final color =
                                sentByMe ? kPrimaryColor : kSecondaryColor;
                            final alignment = sentByMe
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start;
                            return Container(
                              margin: const EdgeInsets.symmetric(
                                vertical: 4.0,
                                horizontal: 8.0,
                              ),
                              child: Row(
                                mainAxisAlignment: alignment,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                      color: color,
                                      borderRadius: sentByMe
                                          ? const BorderRadius.only(
                                              bottomLeft: Radius.circular(8),
                                              bottomRight: Radius.circular(8),
                                              topLeft: Radius.circular(8),
                                            )
                                          : const BorderRadius.only(
                                              bottomLeft: Radius.circular(8),
                                              bottomRight: Radius.circular(8),
                                              topRight: Radius.circular(8),
                                            ),
                                    ),
                                    child: Text(
                                      message['message'].toString(),
                                      style: TextStyle(
                                          color: kWhiteColor, fontSize: 16),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
                Expanded(
                  flex: 0,
                  child: Material(
                    elevation: kLess,
                    color: kWhiteColor,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: kLess),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.add,
                              color: kPrimaryColor,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: kLess),
                              padding: EdgeInsets.symmetric(
                                  horizontal: kLessPadding),
                              decoration: BoxDecoration(color: kWhiteColor),
                              child: TextField(
                                controller: _messageController,
                                cursorColor: kPrimaryColor,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText:
                                      "Envie uma mensagem para o apoio técnico",
                                  hintStyle: TextStyle(color: kLightColor),
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              sendMessage(_messageController.text);
                            },
                            icon: Icon(
                              Icons.send,
                              color: kPrimaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
