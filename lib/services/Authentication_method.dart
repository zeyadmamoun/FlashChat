import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat_final/services/Database_methods.dart';
import 'package:flash_chat_final/services/Provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationMethods {

  FirebaseAuth auth = FirebaseAuth.instance;
  DatabaseMethods databaseMethods = DatabaseMethods();

  Future<String> registerUser(BuildContext context,String email,String password,String error)async{
     try {
       UserCredential userCredential = await auth.createUserWithEmailAndPassword(
           email: email,
           password: password,
       );
       var userDocument = await databaseMethods.getUserByEmail(email);
       Provider.of<UserData>(context,listen: false).setUserData(userDocument['username'], email, null);
       error='';
       storeToken(userCredential,email);
     } on FirebaseAuthException catch (e) {

       if (e.code == 'weak-password') {
         error = 'The password provided is too weak.';
         print('The password provided is too weak.');
       } else if (e.code == 'email-already-in-use') {
         error = 'The account already exists for that email.';
         print('The account already exists for that email.');
       }

     }catch(e){
       print(e);
     }
    return error;
  }
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  Future<String>checkUserExist(BuildContext context,String email,String password,String error)async{
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      var userDocument = await databaseMethods.getUserByEmail(email);
      Provider.of<UserData>(context,listen: false).setUserData(userDocument['username'], email, null);
      error = '';
      storeToken(userCredential,email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        error = 'No user found for that email.';
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        error = 'Wrong password provided for that user.';
        print('Wrong password provided for that user.');
      }
    }
    return error;
  }
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void>addUserToDatabase(String username,String email)async{
    return users.add({
      'username':username,
      'email': email,
    }).then((value) => print('User added')).catchError((onError)=>print('Failed:$onError'));
  }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  Future getToken()async{
     SharedPreferences preferences = await SharedPreferences.getInstance();
     List needs = [];
     needs.add(preferences.getString('token')) ;
     needs.add(preferences.getString('email')) ;
     return needs;
}
  void storeToken(UserCredential userCredential, email)async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('token', await userCredential.user!.getIdToken());
    await preferences.setString('email', email);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  changeUserAvatar(FirebaseAuth auth, String photoUrl){
    auth.currentUser!.updatePhotoURL(photoUrl);
    print(auth.currentUser!.photoURL);
  }

  getUserAvatar(BuildContext context){
    FirebaseAuth auth = FirebaseAuth.instance;
    Provider.of<UserData>(context,listen: false).setUserData(
        Provider.of<UserData>(context,listen: false).username,
        Provider.of<UserData>(context,listen: false).email,
        auth.currentUser!.photoURL
    );
    print(auth.currentUser!.photoURL);
  }
}