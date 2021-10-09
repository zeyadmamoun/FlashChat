import 'package:flash_chat_final/const&widgets/constants.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final bool obsecure;
  final onChanged ;

  CustomTextField({required this.hintText,this.onChanged,required this.obsecure});

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: TextStyle(color: Colors.white),
      onChanged: onChanged,
      obscureText: obsecure,
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderRadius:BorderRadius.circular(30.0) ,
              borderSide: BorderSide(width:1,color :Colors.indigoAccent)
          ),
          hintText: hintText,
          hintStyle: TextStyle(
              color: Colors.white54
          )
      ),
    );
  }
}

class SignupButton extends StatelessWidget {

  final width;
  final height;
  final colour;
  final content;
  final onPressed;

  SignupButton({@required this.width,@required this.height,this.colour,@required this.content,this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: MaterialButton(onPressed: onPressed,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0)
        ),
        color: colour,
        child: content,
      ),
    );
  }
}

class SearchTile extends StatelessWidget {

  SearchTile({this.username,this.email,this.onTap});
  final username;
  final email;
  final onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 20.0),
      child: Row(
        children: <Widget>[
          Column(
            children: <Widget>[
              Text(username,
                style: TextStyle(
                    color: Colors.white
                ),
              ),
              SizedBox(height: 10,),
              Text(email,
                style: TextStyle(
                    color: Colors.white
                ),
              ),
            ],
          ),
          Spacer(),
          SignupButton(
            width: 100.0,
            height:50.0,
            colour: Colors.indigoAccent,
            content: Text("Message",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: onTap,
          )
        ],
      ),
    );
  }
}

class ProgressIndicator extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 250),
      child: Column(
        children: [
          Image.asset('images/chat.png'),
          SizedBox(height: 20,),
          CircularProgressIndicator()
        ],
      ),
    );
  }
}

class MyMessageTile extends StatelessWidget {
  final String message;
  final String time;
  final bool isSentByMe;
  MyMessageTile({required this.message, required this.time,required this.isSentByMe});

  final myMessageBorders = BorderRadius.only(
      topLeft: Radius.circular(15.0),
      bottomLeft: Radius.circular(15.0),
      bottomRight: Radius.circular(15.0)
  );
  final otherBorders = BorderRadius.only(
      topRight: Radius.circular(15.0),
      bottomLeft: Radius.circular(15.0),
      bottomRight: Radius.circular(15.0)
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 7, horizontal: 8.0),
      width: MediaQuery.of(context).size.width,
      alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10 , vertical: 10),
        decoration: BoxDecoration(
            borderRadius: isSentByMe ? myMessageBorders : otherBorders,
            color: isSentByMe ? Colors.indigoAccent : appBarColor
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              message,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w300
              ),
            ),
            SizedBox(height: 1,),
            Text(
              time,
              style: TextStyle(
                  color: Colors.white60,
                  fontSize: 9,
                  fontWeight: FontWeight.w300
              ),
            ),
          ],
        )
      ),
    );
  }
}