import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference chatRooms =
      FirebaseFirestore.instance.collection('ChatRoom');

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  Future getUserByUsername(String username) async {
    List<QueryDocumentSnapshot> usersList = [];

    await users.where('username', isEqualTo: username).get().then((value) {
      value.docs.forEach((element) {
        usersList.add(element);
      });
    });
    return usersList;
  }

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  Future getUserByEmail(String email) async {
    QueryDocumentSnapshot? userDocument;
    await users.where('email', isEqualTo: email).get().then((value) {
      value.docs.forEach((element) {
        userDocument = element;
      });
    });
    return userDocument;
  }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  addConversationMessage(String chatRoomId, messageMap) {
    chatRooms
        .doc(chatRoomId)
        .collection('chat')
        .add(messageMap)
        .catchError((e) {
      print(e);
    });
  }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  getConversationMessage(String chatRoomId)async{
    return await chatRooms
        .doc(chatRoomId)
        .collection('chat')
        .orderBy('time',descending: false)
        .snapshots();
  }
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  getChatRooms(String username)async{
    return await chatRooms.where('users',arrayContains: username).snapshots();
  }
}
