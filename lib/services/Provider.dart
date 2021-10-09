import 'dart:io';
import 'package:flutter/cupertino.dart';

class UserData extends ChangeNotifier{
  String username = '';
  String? email;
  File? userAvatar;

  setUserData(newUsername,newEmail,newAvatar){
    username = newUsername;
    email = newEmail;
    userAvatar = newAvatar;
    notifyListeners();
  }
}

class AnotherUser extends ChangeNotifier {
  String? username;
  String? userAvatar;

  setAnotherUserData(newUsername,newAvatar){
    username = newUsername;
    userAvatar = newAvatar;
    notifyListeners();
  }
}