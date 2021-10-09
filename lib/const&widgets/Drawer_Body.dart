import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat_final/services/Authentication_method.dart';
import 'package:flash_chat_final/services/Firebase_Storage.dart';
import 'package:flash_chat_final/services/Provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyDrawer extends StatelessWidget {

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final AuthenticationMethods authenticationMethods = AuthenticationMethods();
  final StorageMethods methods = StorageMethods();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            height: 220,
            child: DrawerHeader(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('images/Drawer Background.jpg'),
                        fit: BoxFit.cover
                    )
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0,top: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 80,
                        width: 100,
                        child: Provider.of<UserData>(context,listen: false).userAvatar != null ? Image.file(Provider.of<UserData>(context,listen: false).userAvatar!): Image.asset('images/account.png'),
                      ),
                      SizedBox(height: 20.0,),
                      Text(Provider.of<UserData>(context,listen: false).username,
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.normal
                        ),
                      ),
                      SizedBox(height: 9.0,),
                      Text(Provider.of<UserData>(context,listen: false).email!,
                        style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.normal
                        ),
                      ),
                    ],
                  ),
                )
            ),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('settings'),
            onTap: (){
              print(Provider.of<UserData>(context,listen: false).username);
              print(Provider.of<UserData>(context,listen: false).email);
              print(Provider.of<UserData>(context,listen: false).userAvatar);
            },
          ),
          ListTile(
            leading: Icon(Icons.photo),
            title: Text('change your avatar'),
            onTap: () async {
              await methods.uploadFile(context).then((value) async {
                await methods.downloadFile(value).then((value) {
                  if(value!= null){
                    Provider.of<UserData>(context,listen: false).setUserData(
                        Provider.of<UserData>(context,listen: false).username,
                        Provider.of<UserData>(context,listen: false).email,
                        value
                    );
                  }
                });
              });
            },
          ),
          ListTile(
            onTap: ()async{
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.clear();
              await FirebaseAuth.instance.signOut();
              Navigator.pushNamed(context, '/LoginScreen');
            },
            leading: Icon(Icons.logout,color: Colors.red,),
            title: Text('Logout',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}