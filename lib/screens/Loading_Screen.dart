import 'package:flash_chat_final/const&widgets/constants.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      body: Padding(
        padding: EdgeInsets.only(top: 250,left: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('images/chat.png',scale: 1.3,),
            SizedBox(height: 20,),
            CircularProgressIndicator()
          ],
        ),
      ),
    );
  }
}
