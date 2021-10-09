import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat_final/const&widgets/constants.dart';
import 'package:flash_chat_final/module/Create_Conversation.dart';
import 'package:flash_chat_final/screens/Chat_screen.dart';
import 'package:flash_chat_final/services/Database_methods.dart';
import 'package:flash_chat_final/services/Provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DataSearch extends SearchDelegate<String>{

  DatabaseMethods databaseMethods = DatabaseMethods();
  ConversationsMethods conversationsMethods = ConversationsMethods();
  List<QueryDocumentSnapshot> temp = [];

  @override
  ThemeData appBarTheme(BuildContext context) {
    super.appBarTheme(context);
    return ThemeData(
      primaryColor: Color(0xff14191f),
      hintColor: Colors.white38,
      colorScheme: ColorScheme.dark().copyWith(
        background: Color(0xff202933),
        primary: myAccentColor
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return[
      IconButton(onPressed: (){query = '';}, icon: Icon(Icons.clear))
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(onPressed: (){
      Navigator.pop(context);}, icon: Icon(Icons.arrow_back)
    );
  }

  @override
  Widget buildResults(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(10),
      child: ListView.builder(
        itemCount: temp.length,
        itemBuilder: (context,index){
          return ListTile(
            leading: CircleAvatar(child: Image.asset('images/account.png'),),
            title: Text(temp[index]["username"]),
            subtitle: Text(temp[index]['email']),
            onTap:(){
              if(temp[index]["username"] != Provider.of<UserData>(context,listen: false).username ){
                String chatRoomId = conversationsMethods.createChatroomAndStartConversation(
                    temp[index]["username"],
                    Provider.of<UserData>(context, listen: false).username
                );
                Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(
                    anotherUsername: temp[index]["username"],
                    chatRoomId: chatRoomId,
                   )
                 )
                );
              }
            }
          );
        }
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context){

    databaseMethods.getUserByUsername(query).then((value){
      temp=value;
    });
    return Container();
  }
}