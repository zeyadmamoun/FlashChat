import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat_final/const&widgets/Drawer_Body.dart';
import 'package:flash_chat_final/const&widgets/constants.dart';
import 'package:flash_chat_final/module/DataSearch_class.dart';
import 'package:flash_chat_final/services/Authentication_method.dart';
import 'package:flash_chat_final/services/Database_methods.dart';
import 'package:flash_chat_final/services/Firebase_Storage.dart';
import 'package:flash_chat_final/services/Provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'Chat_screen.dart';

class ChatListScreen extends StatefulWidget {
  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {

  AuthenticationMethods authenticationMethods = AuthenticationMethods();
  DatabaseMethods databaseMethods = DatabaseMethods();
  StorageMethods methods = StorageMethods();
  var src;

  Stream<QuerySnapshot>? chatRoomsStream;

  @override
  void initState() {
    databaseMethods
        .getChatRooms(Provider.of<UserData>(context, listen: false).username)
        .then((value) {
      setState(() {
        chatRoomsStream = value;
      });
      print(Provider.of<UserData>(context, listen: false).username);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: Text('Flash Chat'),
        actions: [
          IconButton(icon: Icon(Icons.search), onPressed: () {
            showSearch(context: context, delegate: DataSearch());
          },),
        ],
      ),
      drawer: MyDrawer(),
      body: Provider.of<UserData>(context, listen: false).username.isEmpty ? Container() : ListView(
          padding: EdgeInsets.only(top: 13.0),
          children: chatRoomsStream == null ? [] : [
            StreamBuilder<QuerySnapshot>(
                stream: chatRoomsStream,
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Something went wrong'));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return ListView(
                      physics: ScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      children: snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data = document.data()! as Map<
                            String,
                            dynamic>;
                          var contactName = data['chatroomId'].toString()
                            .replaceAll('_', '')
                            .replaceAll(Provider.of<UserData>(context, listen: false).username, '');
                          var symbol = contactName.substring(0, 1);
                          return Column(
                          children: [
                            ListTile(
                              leading: CircleAvatar(
                                radius: 30,
                                child: Text(symbol.toUpperCase(),
                                  style: TextStyle(color: Colors.white),),
                                backgroundColor: Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
                              ),
                              title: Text(contactName),
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => ChatScreen(
                                          anotherUsername: contactName,
                                          chatRoomId: data['chatroomId'],
                                        )
                                    )
                                );
                              },
                            ),
                            SizedBox(height: 10,),
                            Divider(),
                          ],
                        );
                      }).toList()
                  );
                }
            )
          ]
      ),
    );
  }
}