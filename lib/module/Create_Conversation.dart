import 'package:cloud_firestore/cloud_firestore.dart';

class ConversationsMethods{
  createChatRoom(String chatRoomId,chatRoomMap){
    FirebaseFirestore.instance.collection('ChatRoom')
        .doc(chatRoomId).set(chatRoomMap).catchError((e){print(e);});
  }
  //chatRoomId is the name of the document
  // chatRoomMap is the data in the document
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  // chatroom map consist of list of two users and id of the two usernames.
  createChatroomAndStartConversation(String anotherUsername,String myName){
    
    String chatroomId =  getChatRoomId(anotherUsername,myName);

    List<String> users = [anotherUsername,myName];
    Map<String,dynamic>chatRoomMap = {
      'chatroomId': chatroomId ,
      'users': users
    };

    createChatRoom(chatroomId, chatRoomMap);
    return chatroomId;
  }
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  //we should create the same chatRoomId if any user of the two starts the conversation so we use that function.
  getChatRoomId(String a ,String b){
    if(a.length >= b.length){
      return '$b\_$a';
    }else{
      return '$a\_$b';
    }
  }
}