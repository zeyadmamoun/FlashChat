import 'package:flash_chat_final/services/Authentication_method.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat_final/const&widgets/widgets.dart';

class LoginScreen extends StatefulWidget {

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  String? email;
  String? password;
  String error = '';
  AuthenticationMethods authenticationMethods = AuthenticationMethods();


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
                  Image.asset('images/chat.png',scale: 3.5),
                  SizedBox(
                    height: 75,
                  ),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 20.0,
                      ),
                      Text("Welcome\nBack",
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
                  Row(
                    children: <Widget>[
                      SizedBox(width: 25,),
                      Text('Sign in',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize:25.0,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(width: 190,),
                      SignupButton(
                        onPressed: ()async{
                          error = await authenticationMethods.checkUserExist(context,email!, password!, error);
                          if(error.isEmpty){
                            Navigator.pushNamed(context, '/chatList');
                          }else{
                            setState(() {});
                          }
                        },
                        width: 90.0,
                        height: 50.0,
                        content: Icon(Icons.arrow_forward_ios_rounded,color: Colors.white),
                        colour: Colors.indigoAccent,)
                    ],
                  ),
                  SizedBox(height: 15,),
                  Text(error.isNotEmpty ? error : '',
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 12
                    ),
                  ),
                  SizedBox(height: 30.0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have account yet"),
                      TextButton(
                        onPressed: (){
                            Navigator.pushNamed(context, '/signupScreen');
                          },
                          child: Text('Register here',
                            style: TextStyle(color: Colors.indigoAccent),
                          ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          )
      ),
    );
  }
}