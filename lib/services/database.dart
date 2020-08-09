import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseMethods {
  getUserByUserName(String username) async {
    return await Firestore.instance
        .collection('users')
        .where("name", isEqualTo: username)
        .getDocuments();
  }

  getUserByUserEmail(String userEmail) async {
    return await Firestore.instance
        .collection('users')
        .where("email", isEqualTo: userEmail)
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

  addConversationMessage(String chatRoomId, messageMap) {
    Firestore.instance
        .collection('chatRoom')
        .document(chatRoomId)
        .collection('chats')
        .add(messageMap);
  }

  getConversationMessage(String chatRoomId) async {
    return await Firestore.instance
        .collection('chatRoom')
        .document(chatRoomId)
        .collection('chats')
        .orderBy("time", descending: false)
        .snapshots();
  }
}
