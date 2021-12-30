import 'package:buyk_app/app/app_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyDCYDtwWFL4gFWI72lb8L0-ywSr4qZgGr4',
      appId: '1:946350958970:android:c8ef8565ac73a5e52ecec3',
      messagingSenderId: '946350958970',
      projectId: 'buyk-app',
    )
  );
  runApp(const AppWidget());
}