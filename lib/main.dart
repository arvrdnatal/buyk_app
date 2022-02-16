import 'package:buyk_app/app/app_colors.dart';
import 'package:buyk_app/app/app_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.black,
      systemNavigationBarIconBrightness: Brightness.light
    )
  );
  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyDCYDtwWFL4gFWI72lb8L0-ywSr4qZgGr4',
        appId: '1:946350958970:android:c8ef8565ac73a5e52ecec3',
        messagingSenderId: '946350958970',
        projectId: 'buyk-app',
        storageBucket: "buyk-app.appspot.com",
      ),
    );
  } on FirebaseException catch (e) {
    if (e.code != 'duplicate-app') {
      rethrow;
    }
  } catch (e) {
    rethrow;
  }
  runApp(AppWidget());
}