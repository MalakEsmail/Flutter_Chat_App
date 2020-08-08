import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_chat_app/helper/constants.dart';
import 'package:my_flutter_chat_app/services/database.dart';
import 'package:my_flutter_chat_app/views/conversation_screen.dart';
import 'package:my_flutter_chat_app/widgets/widget.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  DataBaseMethods dataBaseMethods = new DataBaseMethods();

  TextEditingController searchTextEditingController =
      new TextEditingController();
  QuerySnapshot searchSnapshot;

  bool isLoading = false;
  bool haveUserSearched = false;

  ////////////////////////////////////////////

  Widget searchList() {
    return searchSnapshot != null
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchSnapshot.documents.length,
            itemBuilder: (context, index) {
              return SearchTitle(searchSnapshot.documents[index].data["name"],
                  searchSnapshot.documents[index].data["email"]);
            },
          )
        : Container();
  }

  /*
  * Widget userList(){
    return haveUserSearched ? ListView.builder(
      shrinkWrap: true,
      itemCount: searchResultSnapshot.documents.length,
        itemBuilder: (context, index){
        return userTile(
          searchResultSnapshot.documents[index].data["userName"],
          searchResultSnapshot.documents[index].data["userEmail"],
        );
        }) : Container();
  }
  * */

  createUSerChatRoomAndStartConversation({
    // BuildContext context,
    String userName,
  }) {
    String chatRoomId = getChatRoomId(userName, Constants.myName);
    List<String> users = [userName, Constants.myName];
    Map<String, dynamic> chatRoomMap = {
      "users": users,
      "chatroomId": chatRoomId,
    };
    DataBaseMethods().createChatRoom(chatRoomId, chatRoomMap);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ConversationScreen()));
  }

  Widget SearchTitle(String userName, String userEmail) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                userName,
                style: mediumTextStyle(),
              ),
              Text(
                userEmail,
                style: mediumTextStyle(),
              ),
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              createUSerChatRoomAndStartConversation();
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(30)),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Message',
                style: mediumTextStyle(),
              ),
            ),
          )
        ],
      ),
    );
  }

  initiateSearch() {
    dataBaseMethods
        .getUserByUserName(searchTextEditingController.text)
        .then((val) {
      setState(() {
        searchSnapshot = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              color: Color(0x54FFFFFF),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: TextField(
                    controller: searchTextEditingController,
                    style: TextStyle(color: Colors.white54),
                    decoration: InputDecoration(
                        hintText: "search user name ... ",
                        hintStyle: TextStyle(color: Colors.white54),
                        border: InputBorder.none),
                  )),
                  GestureDetector(
                    onTap: () {
                      initiateSearch();
                    },
                    child: Container(
                        height: 40,
                        width: 40,
                        padding: EdgeInsets.all(8),
                        child: Icon(Icons.search)
                        //  Image.asset('assets/images/add.png')
                        ),
                  ),
                ],
              ),
            ),
            searchList()
          ],
        ),
      ),
    );
  }
}

/*class SearchTitle extends StatelessWidget {
  final String userName;
  final String userEmail;

  SearchTitle(this.userName, this.userEmail);

  @override
  Widget build(BuildContext context) {
    return;
  }
}*/

getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}
