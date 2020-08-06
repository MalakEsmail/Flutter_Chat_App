import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseMethods {
  getUserByUserName(String username) async {
    return await Firestore.instance
        .collection('users')
        .where("name", isEqualTo: username)
        .getDocuments();
  }

  uploadUserInformation(userMap) {
    Firestore.instance.collection('users').add(userMap);
  }

  createChatRoom(String charRoomId, chatRoomMap) {
    Firestore.instance
        .collection("ChatRoom")
        .document(charRoomId)
        .setData(chatRoomMap);
  }
}
