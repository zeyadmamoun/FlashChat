import 'dart:io';
import 'dart:math';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

class StorageMethods{

  static const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  Future uploadFile(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    var name = getRandomString(15);


    if (result != null) {
      File file = File(result.files.single.path.toString());
      try {
        await firebase_storage.FirebaseStorage.instance
            .ref("$name/")
            .putFile(file);
      } on firebase_storage.FirebaseException catch (e) {
        print(e);
      }
    } else {
      print("user didn't choose pic ");
    }
  }

  Future downloadFile(String fileName) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    File downloadToFile = File('${appDocDir.path}/download-logo.png');

    try {
      await firebase_storage.FirebaseStorage.instance
          .ref(fileName)
          .writeToFile(downloadToFile);
      return downloadToFile;
    } on firebase_storage.FirebaseException catch (e) {
      print(e);
    }
  }
}



