import 'package:flash_chat_final/screens/ChatList_screen.dart';
import 'package:flash_chat_final/screens/Chat_screen.dart';
import 'package:flash_chat_final/screens/Loading_Screen.dart';
import 'package:flash_chat_final/screens/Login_screen.dart';
import 'package:flash_chat_final/screens/Signup_screen.dart';
import 'package:flash_chat_final/services/Authentication_method.dart';
import 'package:flash_chat_final/services/Database_methods.dart';
import 'package:flash_chat_final/services/Firebase_Storage.dart';
import 'package:flash_chat_final/services/Provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserData()),
        ChangeNotifierProvider(create: (_) => AnotherUser()),
      ],
  child: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {

  AuthenticationMethods authenticationMethods = AuthenticationMethods();
  DatabaseMethods databaseMethods = DatabaseMethods();
  StorageMethods methods = StorageMethods();
  Widget firstPage = LoadingScreen();
  List needs = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 500),()async{
      await getData(context);
      checkToken();
    });
  }
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  checkToken()async{
    await authenticationMethods.getToken().then((value){
      needs = value;
    });
    print(needs);
    if(needs[0] != null){
      firstPage = ChatListScreen();
    }else{
      firstPage = LoginScreen();
    }
    setState(() {});
  }
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  Future getData(BuildContext context)async{
    var userData;
    await authenticationMethods.getToken().then((value)async{
      if(value[1] != null){
        await databaseMethods.getUserByEmail(value[1]).then((value) => userData = value);
        Provider.of<UserData>(context,listen: false).setUserData(userData['username'], userData['email'], null);
      }
    });
  }
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: firstPage ,
      routes: {
        '/LoginScreen': (context) => LoginScreen(),
        '/signupScreen': (context) => SignupScreen(),
        '/chatList': (context) => ChatListScreen(),
        '/chatScreen': (context) => ChatScreen(anotherUsername: '', chatRoomId: '',),
        '/CircularProgressIndicator':(context) => CircularProgressIndicator()
      },
    );
  }
}