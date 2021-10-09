import 'package:flash_chat_final/services/Authentication_method.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat_final/const&widgets/widgets.dart';

class SignupScreen extends StatefulWidget {

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  String? username;
  String? email;
  String? password;
  String error = '';

  AuthenticationMethods authenticationMethods = AuthenticationMethods();

  void checkForInput()async{
    if(username != null && username!.isNotEmpty){
      if(email != null && password != null){
        error = await authenticationMethods.registerUser(context,email!, password!,error);
        if(error == ''){
          authenticationMethods.addUserToDatabase(username!,email!);
          Navigator.pushNamed(context, '/chatList');
        }else{
          setState(() {});
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff14191f),
      body: SafeArea(
          child:ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  SizedBox(
                    height: 75,
                  ),
                  Image.asset('images/chat.png',scale: 3.5,),
                  SizedBox(
                    height: 75,
                  ),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 20.0,
                      ),
                      Text("Sign up\nand start",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize:50.0,
                            fontWeight: FontWeight.w500
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 50.0,
                  ),
                  Container(
                    width: 370.0,
                    child: CustomTextField(
                      obsecure: false,
                      hintText: '    Username',
                      onChanged: (value){
                        username = value;
                      },
                    ),
                  ),
                  SizedBox(height: 20.0,),
                  Container(
                    width: 370.0,
                    child: CustomTextField(
                      obsecure: false,
                      hintText: '    Email Address',
                      onChanged: (value){
                        email = value;
                      },
                    ),
                  ),
                  SizedBox(height: 20.0,),
                  Container(
                    width: 370.0,
                    child: CustomTextField(
                      obsecure: true,
                      hintText: '    Password',
                      onChanged: (value){
                        password = value;
                      },
                    ),
                  ),
                  SizedBox(height: 70.0,),
                  SignupButton(
                    width: 370.0,
                    height: 50.0,
                    onPressed: (){
                      checkForInput();
                    },
                    colour: Colors.indigoAccent,
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Sign up',
                          style: TextStyle(
                              color: Colors.white
                          ),
                        ),
                        SizedBox(width: 25.0,),
                        Icon(Icons.app_registration,color: Colors.white,),
                      ],
                    ),),
                  SizedBox(height: 15,),
                  Text(error.isNotEmpty ? error : '',
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 12
                    ),
                  ),
                ],
              ),
            ],
          )
      ),
    );
  }
}