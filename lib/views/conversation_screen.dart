import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_chat_app/helper/constants.dart';
import 'package:my_flutter_chat_app/services/database.dart';
import 'package:my_flutter_chat_app/widgets/widget.dart';

class ConversationScreen extends StatefulWidget {
  final String chatRoomId;

  ConversationScreen(this.chatRoomId);

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  DataBaseMethods dataBaseMethods = new DataBaseMethods();
  TextEditingController messageTextEditingController =
      new TextEditingController();
  Stream chatMessageStream;

  Widget chatMessageList() {
    return StreamBuilder(
        stream: chatMessageStream,
        builder: (context, snapshot) {
          return ListView.builder(
              itemCount: snapshot.data.documents.lenth,
              itemBuilder: (context, index) {
                return MessageTile(
                    snapshot.data.documents[index].data["message"],
                    snapshot.data.documents[index].data["sendBy"] ==
                        Constants.myName);
              });
        });
  }

  sendMessage() {
    if (messageTextEditingController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": messageTextEditingController.text,
        "sendBy": Constants.myName,
        "time": DateTime.now().millisecondsSinceEpoch,
      };
      dataBaseMethods.addConversationMessage(widget.chatRoomId, messageMap);
      messageTextEditingController.text = "";
    }
  }

  @override
  void initState() {
    dataBaseMethods.getConversationMessage(widget.chatRoomId).then((value) {
      setState(() {
        chatMessageStream = value;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(),
      body: Container(
        child: Stack(
          children: <Widget>[
            chatMessageList(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      color: Color(0x54FFFFFF),
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              child: TextField(
                            controller: messageTextEditingController,
                            style: TextStyle(color: Colors.white54),
                            decoration: InputDecoration(
                                hintText: "search user name ... ",
                                hintStyle: TextStyle(color: Colors.white54),
                                border: InputBorder.none),
                          )),
                          GestureDetector(
                            onTap: () {
                              sendMessage();
                            },
                            child: Container(
                                height: 40,
                                width: 40,
                                padding: EdgeInsets.all(8),
                                child: Icon(Icons.send)
                                //  Image.asset('assets/images/add.png')
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;

  MessageTile(this.message, this.isSendByMe);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: isSendByMe ? [Colors.lightBlueAccent] : [Colors.grey]),
        ),
        alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Text(
          message,
          style: mediumTextStyle(),
        ),
      ),
    );
  }
}
