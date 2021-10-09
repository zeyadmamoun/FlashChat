import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat_final/const&widgets/constants.dart';
import 'package:flash_chat_final/const&widgets/widgets.dart';
import 'package:flash_chat_final/services/Database_methods.dart';
import 'package:flash_chat_final/services/Provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {

final String anotherUsername;
final String chatRoomId;
ChatScreen({required this.anotherUsername,required this.chatRoomId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}
class _ChatScreenState extends State<ChatScreen> {

  TextEditingController messageController = TextEditingController();
  DatabaseMethods databaseMethods = DatabaseMethods();
  Stream<QuerySnapshot>? chatMessagesStream ;

  sendMessage(BuildContext context){
    if(messageController.text.isNotEmpty){
      Map<String,String> messageMap = {
        'message' : messageController.text,
        'sentBy' : Provider.of<UserData>(context,listen: false).username,
        'time' : '${(DateTime.now().millisecondsSinceEpoch)}'
    };
      databaseMethods.addConversationMessage(widget.chatRoomId, messageMap);
      messageController.text = '';
    }
  }

  @override
  void initState() {
    print(widget.chatRoomId);
    databaseMethods.getConversationMessage(widget.chatRoomId).then((value){
      setState(() {
        chatMessagesStream = value ;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
       title: Row(
         children: [
           CircleAvatar(
             backgroundImage: AssetImage('images/account.png'),
             radius: 18,
           ),
           SizedBox(width: 20,),
           Text(widget.anotherUsername,
             style: TextStyle(fontSize: 18)
           ),
           Spacer(),
           Icon(Icons.online_prediction,color: Colors.indigoAccent,)
         ],
       ),
      ),
      body: chatMessagesStream == null ? Container() : Stack(
        children: <Widget>[
          ListView(
            children: [
              SizedBox(height: 15.0,),
              StreamBuilder<QuerySnapshot>(
                stream: chatMessagesStream,
                builder: (context , AsyncSnapshot<QuerySnapshot> snapshot){
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
                      Map<String,dynamic> data =  document.data()! as Map<String, dynamic>;
                      var time = DateTime.fromMillisecondsSinceEpoch(int.parse(data['time'])) ;
                      return MyMessageTile(
                          isSentByMe: data['sentBy'] == Provider.of<UserData>(context,listen: false).username? true : false ,
                          message: data['message'],
                          time: '${time.year}-${time.month}-${time.day}  ${time.hour}:${time.minute}',
                      );
                    }).toList(),
                  );
                }
              )
            ],
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
              height: 60,
              width: double.infinity,
              color: appBarColor,
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.indigoAccent,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Icon(
                        Icons.insert_link,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      expands: true,
                      textDirection: TextDirection.rtl,
                      textInputAction: TextInputAction.newline,
                      controller: messageController,
                      decoration: InputDecoration(
                          hintText: "Write message...",
                          hintStyle: TextStyle(color: Colors.white70),
                          border: InputBorder.none),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      sendMessage(context);
                    },
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 18,
                    ),
                    backgroundColor: Colors.indigoAccent,
                    elevation: 0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}