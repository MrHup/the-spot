import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:the_spot/data/repository/generate_key.dart';

Future<String> uploadFile(File toUpload) async {
  // generate random string
  final randomString = getRandomString(12);
  // Create a storage reference from our app
  final storageRef = FirebaseStorage.instance.ref();

// Create a reference to "mountains.jpg"
  final mountainsRef = storageRef.child("$randomString.jpg");

  try {
    await mountainsRef.putFile(toUpload);
    final url = await mountainsRef.getDownloadURL();
    return url;
  } catch (e) {
    return "";
  }
}
